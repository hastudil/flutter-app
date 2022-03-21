import 'package:access_challenge/components/rounded_button.dart';
import 'package:access_challenge/constants.dart';
import 'package:access_challenge/screens/login/login_screen.dart';
import 'package:access_challenge/screens/signup/signup_screen.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Access Challenge',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Scaffold(
        body: AuthTypeSelector(),
      ),
    );
  }
}

class AuthTypeSelector extends StatelessWidget{
  const AuthTypeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBackground,
        centerTitle: true,
        title: const Text(
          'Welcome to Access Challenge',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Positioned(
            child: Image.asset(
              '../assets/images/iasa.jpg',
              height: size.height * 0.4,
            ),
          ),
          RoundedButton(
            text: loginTextBtn,
            textColor: textBtnColor,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ),
              );
            },
          ),
          RoundedButton(
            text: signUpTextBtn,
            color: singUpBtnColor,
            textColor: textBtnColor,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SignUpScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}