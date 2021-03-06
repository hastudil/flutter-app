import 'package:flutter/material.dart';
import 'package:access_challenge/constants.dart';

class RoundedButton extends StatelessWidget {
  final String? text;
  final Function? press;
  final Color color, textColor;
  const RoundedButton({
    Key? key,
    this.text,
    this.press,
    this.color = singInBtnColor,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: newElevatedButton(text, press),
      ),
    );
  }

  Widget newElevatedButton(text, press) {
    return ElevatedButton(
      child: Text(
        text,
        style: TextStyle(color: textColor),
      ),
      onPressed: press,
      style: ElevatedButton.styleFrom(
        primary: color,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        textStyle: TextStyle(
          color: textColor, 
          fontSize: 14, 
          fontWeight: FontWeight.w500
        )
      ),
    );
  }
}