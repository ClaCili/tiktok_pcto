import 'package:flutter/material.dart';
import 'package:tiktok_pcto/screens/home_screen.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Icon icona;
  const CustomButton({super.key, required this.text, required this.icona});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30, top: 8, bottom: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              SizedBox(width: 10),
              icona,
              SizedBox(width: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
