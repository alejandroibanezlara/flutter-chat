import 'package:flutter/material.dart';


class BtnAzul extends StatelessWidget {

  final String texto;
  final Color color;
  final Function() onPress;

  const BtnAzul({
    super.key, 
    required this.texto, 
    required this.onPress, 
    required this.color});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
            onPressed: onPress, 
            elevation: 2,
            color: color,
            shape: StadiumBorder(),
            child: Container(
              width: double.infinity,
              child: Center(
                child: 
                Text(texto, style: TextStyle(color: Colors.white, fontSize: 17),),
              ),
            ),
            
            );
  }
}