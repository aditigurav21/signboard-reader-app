import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;
import '../../ocr_audio/ocr_service.dart';
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
  String? _destination;
  bool _loading = false;

  // 🎤 Voice Assistant
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _voiceText = "";

  // 🧠 OCR Service
  final OCRService _ocrService = OCRService();

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  // 🎤 Start Listening
  void _startListening() async {
    bool available = await _speech.initialize();

    if (available) {
      setState(() => _isListening = true);

      _speech.listen(
        onResult: (result) {
          setState(() {
            _voiceText = result.recognizedWords;
          });

          processCommand(_voiceText);
        },
      );
    }
  }

  // 🛑 Stop Listening
  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  // 🧠 Command Processing
  void processCommand(String command) {
    command = command.toLowerCase();

    // 🎯 Detect destination
    if (command.contains("exit")) {
      _destination = "exit";
    } else if (command.contains("hospital")) {
      _destination = "hospital";
    }

    // Actions
    if (command.contains("read")) {
      _detectText();
    } else if (command.contains("camera")) {
      _pickImage(ImageSource.camera);
    } else if (command.contains("gallery")) {
      _pickImage(ImageSource.gallery);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Command not recognized")),
      );
    }
  }

  // 📷 Pick image
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

  // 🔍 Detect Text
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
  String detectedText =
      await _ocrService.extractText(_image!.path);
      if (!mounted) return;

 

  String direction = getDirection(detectedText);

  if (_destination != null && direction != "unknown") {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "${_destination!.toUpperCase()} is on your $direction",
        ),
      ),
    );
  }

  setState(() => _loading = false);

  HapticService.medium();

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ResultScreen(
        image: _image!,
        detectedText: detectedText,
        translatedText: "",
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

  // 📍 Direction Logic
  String getDirection(String text) {
    text = text.toLowerCase();

    if (_destination != null && text.contains(_destination!)) {
      if (text.contains("→") || text.contains("right")) {
        return "right";
      } else if (text.contains("←") || text.contains("left")) {
        return "left";
      } else if (text.contains("↑") || text.contains("straight")) {
        return "straight";
      }
    }

    return "unknown";
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

                    // 🎤 Voice Button
                    CustomButton(
                      text: _isListening ? "Listening..." : "Start Voice",
                      onPressed:
                          _isListening ? _stopListening : _startListening,
                    ),

                    const SizedBox(height: 10),

                    CustomButton(
                      text: "Pick from Gallery",
                      onPressed: () =>
                          _pickImage(ImageSource.gallery),
                    ),

                    CustomButton(
                      text: "Capture from Camera",
                      onPressed: () =>
                          _pickImage(ImageSource.camera),
                    ),

                    const SizedBox(height: 10),

                    CustomButton(
                      text: "Detect Text",
                      onPressed: _detectText,
                    ),

                    const SizedBox(height: 20),

                    // 👀 Debug text
                    Text(
                      "You said: $_voiceText",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _speech.stop();
    _ocrService.dispose();
    super.dispose();
  }
}