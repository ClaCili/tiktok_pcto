import 'package:flutter/material.dart';
import 'package:tiktok_pcto/custom_bottom.dart';
import 'package:tiktok_pcto/custom_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(leading: Icon(Icons.question_mark_rounded)),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Accedi a TikTok",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
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
              CustomButton(
                text: 'Continua con Apple',
                icona: Icon(Icons.apple),
              ),
              CustomButton(
                text: 'Continua con Google',
                icona: Icon(Icons.g_mobiledata),
              ),
              CustomButton(
                text: 'Continua con Facebook',
                icona: Icon(Icons.facebook),
              ),
              CustomButton(
                text: 'Continua con Facebook',
                icona: Icon(Icons.facebook),
              ),
              SizedBox(height: 280),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: Text(
                  textAlign: TextAlign.center,
                  "By continuing, you agree to our Terms of Service and acknowledge that you have read our Privacy Policy to learn how we collect, use, and share your data.",
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottom(),
      );
  }
}