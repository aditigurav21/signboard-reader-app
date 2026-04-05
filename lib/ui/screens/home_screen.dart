import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../ocr_audio/ocr_service.dart';


import '../widgets/custom_button.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  bool _loading = false;

  final OCRService _ocrService = OCRService();

  final ImagePicker _picker = ImagePicker();

  // 📷 Pick image (camera or gallery)
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 100, // improves OCR
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }


  Future<void> _detectText() async {

    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image first")),
      );
      return;
    }

    setState(() => _loading = true);

    try {

      String detectedText =
      await _ocrService.extractText(_image!.path);

      setState(() => _loading = false);
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            image: _image!,
            detectedText: detectedText,
            translatedText: "", // optional translation later
          ),
        ),
      );

    } catch (e) {

      setState(() => _loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );

    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Signboard Reader")),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _image != null
                  ? Image.file(_image!, width: 300)
                  : const Text("No image selected"),

              const SizedBox(height: 20),

              CustomButton(
                text: "Pick from Gallery",
                onPressed: () => _pickImage(ImageSource.gallery),
              ),

              CustomButton(
                text: "Capture from Camera",
                onPressed: () => _pickImage(ImageSource.camera),
              ),

              const SizedBox(height: 10),

              CustomButton(
                text: "Detect Text",
                onPressed: _detectText,
              ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    _ocrService.dispose();
    super.dispose();
  }
}