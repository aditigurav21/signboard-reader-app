import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';
import '../ai/sign_filter.dart';

class OCRService {
  final TextRecognizer textRecognizer = TextRecognizer();

  Future<String> extractText(String imagePath) async {
    final inputImage = InputImage.fromFile(File(imagePath));

    final RecognizedText recognizedText =
    await textRecognizer.processImage(inputImage);

    List<String> filteredResults = [];

    for (TextBlock block in recognizedText.blocks) {

      String blockText = block.text;

      List<String> filtered =
      SignFilter.filterText(blockText);

      filteredResults.addAll(filtered);

    }

    return filteredResults.join("\n");
  }

  void dispose() {
    textRecognizer.close();
  }
}