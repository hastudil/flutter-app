import 'package:flutter/material.dart';
import 'package:access_challenge/constants.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final void Function()? press;

  const AlreadyHaveAnAccountCheck({
    Key? key,
    this.login = true,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "Don't have an Account? " : "Already have an Account? ",
          style: const TextStyle(color: textBtnColor),
        ),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: press,
            child: Text(
              login ? "Sign Up" : "Sign In",
              style: const TextStyle(
                color: textBtnColor,
                fontWeight: FontWeight.bold,

              ),
            ),
          )
        ),
        
      ],
    );
  }
}