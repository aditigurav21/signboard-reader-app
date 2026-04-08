import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../haptics/haptic_service.dart';
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

  final ImagePicker _picker = ImagePicker();

  // 📷 Pick image (camera or gallery)
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 100,
    );

    if (pickedFile != null) {
      HapticService.light(); // ✅ Image selected feedback

      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // 🚀 Send to backend
  Future<void> _detectText() async {
    if (_image == null) {
      HapticService.heavy(); // ✅ Error feedback

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image first")),
      );
      return;
    }

    setState(() => _loading = true);
    HapticService.medium(); // ✅ Processing start feedback

    var request = http.MultipartRequest(
      "POST",
      Uri.parse("http://10.151.163.254:5000/upload"),
    );

    request.files.add(
      await http.MultipartFile.fromPath("image", _image!.path),
    );

    try {
      var response = await request.send();
      var respStr = await response.stream.bytesToString();
      var data = json.decode(respStr);

      setState(() => _loading = false);
      HapticService.medium(); // ✅ Success feedback

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            image: _image!,
            detectedText: data["detectedText"] ?? "",
            translatedText: data["translatedText"] ?? "",
          ),
        ),
      );
    } catch (e) {
      setState(() => _loading = false);
      HapticService.heavy(); // ✅ Error feedback

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
            : Column(
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
    );
  }
}