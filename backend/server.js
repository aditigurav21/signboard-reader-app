const express = require("express");
const cors = require("cors");
const multer = require("multer");
const Tesseract = require("tesseract.js");
const sharp = require("sharp");
const fs = require("fs");
const axios = require("axios");

const app = express();
const upload = multer({ dest: "uploads/" });

app.use(cors());

app.post("/upload", upload.single("image"), async (req, res) => {
  try {
    console.log("Request received");

    if (!req.file) {
      return res.status(400).json({ 
        detectedText: "", 
        translatedText: "No image uploaded" 
      });
    }

    console.log(req.file);

    const imagePath = req.file.path;
    const processedPath = `processed_${Date.now()}.png`;

    // Step 1: Preprocess image (improves OCR accuracy)
    await sharp(imagePath)
      .grayscale()
      .threshold(150)
      .toFile(processedPath);

    // Step 2: OCR
    const result = await Tesseract.recognize(processedPath, "eng", {
      logger: m => console.log(m) // shows progress
    });

    let detectedText = result.data.text
      .replace(/\n/g, " ")
      .trim();

    console.log("OCR result:", detectedText);

    // Step 3: Translation
    let translatedText = "";
    if (detectedText) {
      try {
        const response = await axios.post(
          "https://translate.argosopentech.com/translate",
          {
            q: detectedText,
            source: "en",
            target: "hi",
            format: "text"
          }
        );

        translatedText = response.data.translatedText;
      } catch (err) {
        console.log("Translation error:", err.message);
        translatedText = "Translation failed";
      }
    } else {
      translatedText = "No text detected";
    }

    console.log("Translated:", translatedText);

    // Step 4: Cleanup files
    fs.unlinkSync(imagePath);
    fs.unlinkSync(processedPath);

    // ✅ Final response
    res.json({
      detectedText: detectedText || "No text detected",
      translatedText
    });

  } catch (error) {
    console.error("ERROR:", error);
    res.status(500).json({ error: "OCR failed" });
  }
});

app.listen(5000, () => {
  console.log("Server running on port 5000");
});