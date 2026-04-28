import 'package:flutter/material.dart';
import 'package:tiktok_pcto/home_bottom.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Per te"),
            SizedBox(width: 8,),
            Text("Seguiti"),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottom(),
    );
  }
}