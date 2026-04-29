import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Icon icona;
  final VoidCallback? onTap;

  const CustomButton({
    super.key,
    required this.text,
    required this.icona,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const SizedBox(width: 10),
              icona,
              const SizedBox(width: 20),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
