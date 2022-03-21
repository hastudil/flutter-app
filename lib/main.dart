import 'package:access_challenge/screens/loading_screen.dart';
import 'package:access_challenge/screens/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:access_challenge/screens/login/login_screen.dart';
//import 'package:access_challenge/screens/signup/signup_screen.dart';
//import 'package:access_challenge/register.dart';
//import 'package:access_challenge/signin.dart';
//import 'package:flutter/services.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter_signin_button/flutter_signin_button.dart';
//import 'package:access_challenge/components/rounded_button.dart';
//import 'package:access_challenge/constants.dart';
import 'package:access_challenge/screens/home.dart';

import 'package:access_challenge/services/auth.dart';
import 'package:provider/provider.dart';

void main() => runApp(const AccessChallengeWeb());

class AccessChallengeWeb extends StatefulWidget {
  const AccessChallengeWeb({Key? key}) : super(key: key);

  @override
  _AccessChallengeWebState createState() => _AccessChallengeWebState();
}

class _AccessChallengeWebState extends State<AccessChallengeWeb> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthService.instance(),
      child: MaterialApp(
        initialRoute: '/',
        /*routes: const {
          // Rutas
        },*/
        debugShowCheckedModeBanner: false,
        title: 'Access Challenge',
        home: Consumer(
          builder: (context, AuthService authService, _) {
            switch (authService.status) {
              case AuthStatus.Uninitialized:
                return const LoadingScreen();
                //return Text('${authService.status}');
              case AuthStatus.Authenticated:
                return const WelcomeScreen();
              case AuthStatus.Authenticating:
                return const Home();
              case AuthStatus.Unauthenticated:
                return const LoginScreen();
            }
          },
        )
      ),
    );
  }
}

/*main() async {
  await Firebase.initializeApp();

  runApp(const AccessChallengeWeb());
}*/

/*class AccessChallengeWeb extends StatelessWidget{
  const AccessChallengeWeb({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Access Challenge',
      theme: ThemeData(
        //primarySwatch: Colors.blue,
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
  /*void _pushPage(BuildContext context, Widget page){
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }*/

  @override
  Widget build(BuildContext context){
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
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
            text: "LOGIN",
            textColor: Colors.black,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();//SignInPage();
                  },
                ),
              );
            },
          ),
          RoundedButton(
            text: "SIGN UP",
            color: singUpBtnColor,
            textColor: Colors.black,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUpScreen();//RegisterPage();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}*/