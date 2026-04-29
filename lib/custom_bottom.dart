import 'package:flutter/material.dart';

class CustomBottom extends StatelessWidget {
  final VoidCallback? onTap;
  final String prompt;
  final String actionLabel;

  const CustomBottom({
    super.key,
    this.onTap,
    this.prompt = 'Non hai un account? ',
    this.actionLabel = 'Registrati',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(prompt),
          GestureDetector(
            onTap: onTap,
            child: Text(actionLabel, style: const TextStyle(color: Colors.pink)),
          ),
        ],
      ),
    );
  }
}
