import 'package:flutter/material.dart';
import '../../haptics/haptic_service.dart';
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(fontSize: 18),
      ),
      onPressed: (){
        HapticService.light(); // ✅ ADD THIS (button click feedback)
        onPressed(); // ✅ KEEP original functionality
      },
      child: Text(text),
    );
  }
}