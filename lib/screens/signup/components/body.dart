import 'package:access_challenge/constants.dart';
import 'package:flutter/material.dart';
import 'package:access_challenge/components/or_divider.dart';
import 'package:access_challenge/components/social_icon.dart';
import 'package:access_challenge/components/rounded_button.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class Body extends StatefulWidget{
  const Body({Key? key}) : super(key: key);
  final String title = 'Sign Up';

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<Body>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context){
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
                  text: signUpTextBtn,
                  textColor: textBtnColor,
                  press: () async{
                    if(_formKey.currentState!.validate()){
                      await _register();
                    }
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
                          _signInWithGoogle();
                        },
                      ),
                    ],
                  )
                )
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

  Future<void> _register() async{
    final User? user = (await _auth.createUserWithEmailAndPassword(
      email: _emailController.text, 
      password: _passwordController.text,
    ))
    .user;

    if(user != null){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign up ${user.email}'),
      ));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed sign up'),
      ));
    }
  }

  Future<void> _signInWithGoogle() async{
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        var googleProvider = GoogleAuthProvider();
        userCredential = await _auth.signInWithPopup(googleProvider);
      }
      else{
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
        final googleAuthCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        userCredential = await _auth.signInWithCredential(googleAuthCredential);
      }

      final user = userCredential.user;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign up ${user!.displayName} with Google.'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed sign in with Google.'),
      ));
    }
  }
}