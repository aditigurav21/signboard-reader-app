import 'dart:io';
import 'package:flutter/material.dart';
import '../../haptics/haptic_service.dart'; 
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
     HapticService.medium(); // ✅ ADD THIS (screen open feedback)
    return Scaffold(
      appBar: AppBar(title: const Text("Result")),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Image.file(image, width: 300),
                const SizedBox(height: 20),

                const Text(
                  "Detected Signboard Text",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  detectedText.isEmpty
                      ? "No signboard text detected"
                      : detectedText,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  translatedText.isEmpty
                      ? ""
                      : "Translated Text: $translatedText",
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
    );
  }
}