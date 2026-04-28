import 'package:flutter/material.dart';
import 'package:tiktok_pcto/custom_button.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Registrati a TikTok",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
            ),
          ),
          SizedBox(height: 20),
          CustomButton(
            text: 'Usa telefono/email/username',
            icona: Icon(Icons.person_outline),
          ),
          CustomButton(
            text: 'Continua con Facebook',
            icona: Icon(Icons.facebook, color: Colors.blue),
          ),
          CustomButton(text: 'Continua con Apple', icona: Icon(Icons.apple)),
          CustomButton(
            text: 'Continua con Google',
            icona: Icon(Icons.g_mobiledata),
          ),
        ],
      ),
    );
  }
}
