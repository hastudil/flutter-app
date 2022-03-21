import 'package:flutter/material.dart';
//import 'package:access_challenge/screens/login/login_screen.dart';
//import 'package:access_challenge/screens/signup/components/background.dart';
import 'package:access_challenge/components/or_divider.dart';
import 'package:access_challenge/components/social_icon.dart';
//import 'package:access_challenge/components/already_have_an_account_acheck.dart';
import 'package:access_challenge/components/rounded_button.dart';
//import 'package:access_challenge/components/rounded_input_field.dart';
//import 'package:access_challenge/components/rounded_password_field.dart';
//import 'package:flutter_svg/flutter_svg.dart';
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

  //bool _success = false;
  //String _userEmail = '';

  @override
  Widget build(BuildContext context){
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
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
            //padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Positioned(
                  //height: size.height * 2,
                  child: Image.asset(
                    '../assets/images/iasa_cat.png',
                    //height: size.height * 0.1,
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
                /*Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.center,
                  child: TextButton.icon(
                    onPressed: () async{
                      if(_formKey.currentState!.validate()){
                        await _register();
                      }
                    }, 
                    icon: const Icon(Icons.person_add), 
                    style: TextButton.styleFrom(
                      primary: Colors.blueGrey,
                    ),
                    label: const Text('Register'),
                  ),
                ),*/
                RoundedButton(
                  text: "SIGN UP",
                  textColor: Colors.black,
                  press: () async{
                    if(_formKey.currentState!.validate()){
                      await _register();
                    }
                  },
                ),
                /*Container(
                  alignment: Alignment.center,
                  child: Text(_success
                    ? 'Successfully regitered $_userEmail'
                    : ''
                    //: 'Registration incompleted $_userEmail'
                  ),
                ),*/
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
      /*setState(() {
        //_success = true;
        _userEmail = user.email.toString();
      });*/

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign up ${user.email}'),
      ));
    }
    else{
      //_success = false;

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
      //print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed sign in with Google.'),
      ));
    }
  }
}








/*class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Signup",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            /*SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              onChanged: (value) {},
            ),*/
            RoundedButton(
              text: "Signup",
              press: () {},
            ),
            SizedBox(height: size.height * 0.03),
            /*AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),*/
            OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                /*SocalIcon(
                  iconSrc: "../assets/icons/facebook.svg",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "../assets/icons/twitter.svg",
                  press: () {},
                ),*/
                SocalIcon(
                  iconSrc: "../assets/icons/google-plus.svg",
                  press: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}*/