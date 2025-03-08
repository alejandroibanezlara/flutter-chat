import 'package:flutter/material.dart';

class Terms extends StatelessWidget {
  const Terms({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text('Términos y condiciones de uso', style: TextStyle(color: Colors.black54, fontSize: 10, fontWeight: FontWeight.w200  ,)),
          SizedBox(height: 5,)
        ],
      ));
  }
}