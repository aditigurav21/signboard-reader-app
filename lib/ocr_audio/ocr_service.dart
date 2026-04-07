import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';

import '../ai/detection_service.dart';

class OCRService {

  final TextRecognizer textRecognizer = TextRecognizer();

  final DetectionService detectionService = DetectionService();

  bool modelReady = false;

  Future<String> extractText(String imagePath) async {

    // Load model once
    if (!modelReady) {
      await detectionService.loadModel();
      modelReady = true;
    }

    final inputImage = InputImage.fromFile(File(imagePath));

    final RecognizedText recognizedText =
    await textRecognizer.processImage(inputImage);

    List<String> filteredResults = [];

    for (TextBlock block in recognizedText.blocks) {

      String blockText = block.text;

      // AI filtering
      List<String> filtered =
      detectionService.detect(blockText);

      filteredResults.addAll(filtered);

    }

    return filteredResults.join("\n");

  }

  void dispose() {
    textRecognizer.close();
  }

}
