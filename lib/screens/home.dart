import 'package:access_challenge/components/rounded_button.dart';
import 'package:access_challenge/constants.dart';
import 'package:access_challenge/screens/login/login_screen.dart';
import 'package:access_challenge/screens/signup/signup_screen.dart';
//import 'package:access_challenge/services/auth.dart';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';

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
        //primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Scaffold(
        body: AuthTypeSelector(),
      ),
    );
  }


  /*@override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text('Cerrar Sesión ${authService.user.displayName}'),
          onPressed: () {
            authService.signOut();
          },
        ),
      ),
    );
  }*/
}

class AuthTypeSelector extends StatelessWidget{
  //final authService = Provider.of<AuthService>(context);
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
}