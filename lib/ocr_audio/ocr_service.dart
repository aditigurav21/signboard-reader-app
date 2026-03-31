import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';

class OCRService {
  final TextRecognizer textRecognizer = TextRecognizer();

  Future<String> extractText(String imagePath) async {
    final inputImage = InputImage.fromFile(File(imagePath));

    final RecognizedText recognizedText =
    await textRecognizer.processImage(inputImage);

    String result = "";

    for (TextBlock block in recognizedText.blocks) {
      result += block.text + "\n";
    }

    return result;
  }

  void dispose() {
    textRecognizer.close();
  }
}