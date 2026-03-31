import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../ocr_audio/ocr_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    testOCR(); // 👈 runs when app starts
  }

  Future<void> testOCR() async {
    final ocr = OCRService();

    final byteData = await rootBundle.load('assets/images/test.jpg');
    final file = File('${(await getTemporaryDirectory()).path}/test.jpg');
    await file.writeAsBytes(byteData.buffer.asUint8List());

    String result = await ocr.extractText(file.path);

    print("OCR RESULT:");
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Signboard Reader"),
      ),
      body: const Center(
        child: Text("Running OCR... Check Console"),
      ),
    );
  }
}