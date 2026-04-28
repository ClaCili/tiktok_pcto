import 'package:flutter/material.dart';

class HomeBottom extends StatelessWidget {
  const HomeBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      width: 414,
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.home, color: Colors.white,),
            Icon(Icons.search, color: Colors.white,),
            Icon(Icons.add, color: Colors.white,),
            Icon(Icons.message, color: Colors.white,),
            Icon(Icons.person_outline, color: Colors.white,),
          ],
        ),
      ),
    );
  }
}