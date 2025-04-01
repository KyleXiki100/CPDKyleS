import 'package:flutter/material.dart';

class QuickAccessButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const QuickAccessButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        fixedSize: const Size(200, 50),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}