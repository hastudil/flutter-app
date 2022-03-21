import 'package:access_challenge/components/already_have_an_account.dart';
import 'package:access_challenge/constants.dart';
import 'package:access_challenge/screens/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:access_challenge/components/or_divider.dart';
import 'package:access_challenge/components/rounded_button.dart';
import 'package:access_challenge/components/social_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:access_challenge/services/auth.dart';
import 'package:provider/provider.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;

class Body extends StatefulWidget{
  const Body({Key? key}) : super(key: key);
  final String title = 'Login';

  @override
  State<StatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends State<Body>{
  User? user;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState(){
    _auth.userChanges().listen((event) => setState(() => user = event));
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    final authService = Provider.of<AuthService>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBackground,
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Card(
          margin: EdgeInsets.symmetric(
            vertical: size.height * 0.05,
            horizontal: size.width * 0.25
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Positioned(
                  child: Image.asset(
                    '../assets/images/iasa_cat.png',
                  ),
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (String? value){
                    if(value!.isEmpty){
                      return 'Your email';
                    }

                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (String? value){
                    if(value!.isEmpty){
                      return 'Your password';
                    }

                    return null;
                  },
                  obscureText: true,
                ),
                RoundedButton(
                  text: "LOGIN",
                  textColor: Colors.black,
                  press: () async{
                    if(_formKey.currentState!.validate()){
                      authService.signInWithEmailAndPassword(context,_emailController,_passwordController);
                    }
                  },
                ),
                AlreadyHaveAnAccountCheck(
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
                const OrDivider(),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SocialIcon(
                        iconSrc: "../assets/icons/google-plus.svg",
                        press: () async{
                          authService.googleSignIn(context);
                        },
                      ),
                    ],
                  )
                ),
              ],
            )
          ),
        )
      ),
    );
  }

  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}