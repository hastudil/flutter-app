import 'package:access_challenge/components/already_have_an_account.dart';
import 'package:access_challenge/screens/signup/signup_screen.dart';
import 'package:flutter/material.dart';
//import 'package:access_challenge/screens/login/components/background.dart';
//import 'package:access_challenge/screens/signup/signup_screen.dart';
//import 'package:access_challenge/components/already_have_an_account.dart';
import 'package:access_challenge/components/or_divider.dart';
import 'package:access_challenge/components/rounded_button.dart';
import 'package:access_challenge/components/social_icon.dart';
//import 'package:flutter_auth/components/rounded_input_field.dart';
//import 'package:flutter_auth/components/rounded_password_field.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:access_challenge/screens/welcome/welcome_screen.dart';
import 'package:access_challenge/services/auth.dart';
import 'package:provider/provider.dart';


//import 'package:access_challenge/register.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;

class Body extends StatefulWidget{
  const Body({Key? key}) : super(key: key);
  final String title = 'Login';
  //final User? user = _auth.currentUser;  

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
            //padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
                    //alignment: Alignment.center,
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
                      //await _signInWithEmailAndPassword();
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
                          return SignUpScreen();
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
                          authService.googleSignIn(context);//_signInWithGoogle();
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
    /*return Form(
      key: _formKey,
      child: Card(
        margin: EdgeInsets.symmetric(
          vertical: size.height * 0.02,
          horizontal: size.width * 0.30
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          //padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              /*Container(
                alignment: Alignment.center,
                child: const Text(
                  'Login with email and password',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(),*/
              Positioned(
                child: Image.asset(
                  '../assets/images/iasa_cat.png',
                  height: size.height * 0.2,
                ),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (String? value){
                  if(value!.isEmpty) return 'Your email';
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (String? value){
                  if(value!.isEmpty) return 'Your password';
                  return null;
                },
                obscureText: true,
              ),
              /*Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
                child: SignInButtonBuilder(
                  //padding: const EdgeInsets.only(top: 16),
                  icon: Icons.login,
                  backgroundColor: Colors.blueGrey,
                  text: 'Login',
                  fontSize: 16,
                  innerPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 35),
                  onPressed: () async{
                    if(_formKey.currentState!.validate()){
                      await _signInWithEmailAndPassword();
                    }
                  },
                ),
              ),*/
              RoundedButton(
                text: "LOGIN",
                textColor: Colors.black,
                press: () async{
                  if(_formKey.currentState!.validate()){
                    await _signInWithEmailAndPassword();
                  }
                },
              ),
              OrDivider(),
              Row(
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
            ],
          ),
        ),
      )
    );*/
  }

  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  /*
  Future<void> _signInWithEmailAndPassword() async{
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text, 
        password: _passwordController.text,
      )).user!;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${user.email} login.'))
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const WelcomeScreen();//SignInPage();
          },
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed login.'),
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
        SnackBar(content: Text('Login ${user!.displayName} with Google'),
      ));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const WelcomeScreen();//SignInPage();
          },
        ),
      );
    } catch (e) {
      //print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed login with Google.'),
      ));
    }
  }
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
        centerTitle: true,
        title: Text(widget.title),
        /*actions: <Widget>[
          Builder(builder: (BuildContext context){
            return TextButton(
              onPressed: () async {
                final User? user = _auth.currentUser;
                if(user == null){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Not Login')
                  ));
                  return;
                }
                await _signOut();

                final String? userEmail = user.email;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('User: $userEmail has successfully signed out'),
                ));
              },
              child: const Text('Sign out',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                )
              ),
            );
          })
        ]*/
      ),
      body: Builder(builder: (BuildContext context){
        return ListView(
          padding: const EdgeInsets.all(10),
          children: <Widget>[
            //_UserInfoCard(user),
            //const Divider(),
            _EmailPasswordForm(),
            //const Divider(),
            //const _OtherProvidersSignInSection(),
          ],
        );
      }),
    );
  }*/

  /*Future<void> _signOut() async{
    await _auth.signOut();
  }*/
}

class _UserInfoCard extends StatefulWidget{
  final User? user;
  const _UserInfoCard(this.user);

  @override
  _UserInfoCardState createState() => _UserInfoCardState();
}

class _UserInfoCardState extends State<_UserInfoCard>{
  @override
  Widget build(BuildContext context){
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              alignment: Alignment.center,
              child: const Text(
                'User info',
                style:  TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            if(widget.user != null)
              for(var provider in widget.user!.providerData)
            Dismissible(
              key: Key(provider.uid!), 
              onDismissed: (action) => widget.user!.unlink(provider.providerId),
              child: Card(
                child: ListTile(
                  subtitle: Text(
                    "${provider.uid == null ? "" : "ID: ${provider.uid}\n"}"
                    "${provider.displayName == null ? "" : "Name: ${provider.displayName}\n"}"
                    "${provider.email == null ? "" : "Email: ${provider.email}\n"}"
                    "${provider.phoneNumber == null ? "" : "Phone: ${provider.phoneNumber}\n"}"                    
                  ),
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}

class _EmailPasswordForm extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<_EmailPasswordForm>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context){
    Size size = MediaQuery.of(context).size;
    
    return Form(
      key: _formKey,
      child: Card(
        margin: EdgeInsets.symmetric(
          vertical: size.height * 0.02,
          horizontal: size.width * 0.30
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          //padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              /*Container(
                alignment: Alignment.center,
                child: const Text(
                  'Login with email and password',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(),*/
              Positioned(
                child: Image.asset(
                  '../assets/images/iasa_cat.png',
                  height: size.height * 0.2,
                ),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (String? value){
                  if(value!.isEmpty) return 'Your email';
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (String? value){
                  if(value!.isEmpty) return 'Your password';
                  return null;
                },
                obscureText: true,
              ),
              /*Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
                child: SignInButtonBuilder(
                  //padding: const EdgeInsets.only(top: 16),
                  icon: Icons.login,
                  backgroundColor: Colors.blueGrey,
                  text: 'Login',
                  fontSize: 16,
                  innerPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 35),
                  onPressed: () async{
                    if(_formKey.currentState!.validate()){
                      await _signInWithEmailAndPassword();
                    }
                  },
                ),
              ),*/
              RoundedButton(
                text: "LOGIN",
                textColor: Colors.black,
                press: () async{
                  if(_formKey.currentState!.validate()){
                    await _signInWithEmailAndPassword();
                  }
                },
              ),
              OrDivider(),
              Row(
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
            ],
          ),
        ),
      )
    );
  }

  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmailAndPassword() async{
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text, 
        password: _passwordController.text,
      )).user!;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${user.email} login.'))
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const WelcomeScreen();//SignInPage();
          },
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed login.'),
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
        SnackBar(content: Text('Login ${user!.displayName} with Google'),
      ));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const WelcomeScreen();//SignInPage();
          },
        ),
      );
    } catch (e) {
      //print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed login with Google.'),
      ));
    }
  }
}

/*class _OtherProvidersSignInSection extends StatefulWidget{
  const _OtherProvidersSignInSection();

  @override
  State<StatefulWidget> createState() => _OtherProvidersSignInSectionState();
}

class _OtherProvidersSignInSectionState extends State<_OtherProvidersSignInSection>{
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _tokenSecretController = TextEditingController();

  final bool _showAuthSecretTextField = false;
  final bool _showProviderTokenField = true;

  @override
  Widget build(BuildContext context){
    Size size = MediaQuery.of(context).size;
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: size.height * 0.02,
        horizontal: size.width * 0.30
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: const Text('Social Authentication',
                style: TextStyle(fontWeight: FontWeight.bold)
              ),
            ),
            const Divider(),
            Visibility(
              visible: _showProviderTokenField && !kIsWeb,
              child: TextField(
                controller: _tokenController,
                decoration: const InputDecoration(
                  labelText: "Enter provider's token"
                ),
              ),
            ),
            Visibility(
              visible: _showAuthSecretTextField && !kIsWeb,
              child: TextField(
                controller: _tokenSecretController,
                decoration: const InputDecoration(
                  labelText: "Enter provider's authTokenSecret"
                ),
              )
            ),
            Container(
              padding: const EdgeInsets.only(top: 16),
              alignment: Alignment.center,
              child: SignInButton(
                Buttons.Google,
                padding: const EdgeInsets.all(16),
                text: 'Login with Google', 
                onPressed: () async{
                  _signInWithGoogle();
                }
              ),
            )
          ],
        ),
      ),
    );
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
        SnackBar(content: Text('Login ${user!.displayName} with Google'),
      ));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const WelcomeScreen();//SignInPage();
          },
        ),
      );
    } catch (e) {
      //print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed login with Google.'),
      ));
    }
  }
}*/