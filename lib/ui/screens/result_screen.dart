import 'dart:io';
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final File image;
  final String detectedText;
  final String translatedText;

  const ResultScreen({
    super.key,
    required this.image,
    required this.detectedText,
    required this.translatedText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Result")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(image, width: 300),
            const SizedBox(height: 20),
            Text("Detected Text: $detectedText"),
            const SizedBox(height: 10),
            Text("Translated Text: $translatedText"),
          ],
        ),
      ),
    );
  }
}