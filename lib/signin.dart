import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignInPage extends StatefulWidget{
  const SignInPage({Key? key}) : super(key: key);
  final String title = 'Sign In & Out';

  @override
  State<StatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage>{
  User? user;

  @override
  void initState(){
    _auth.userChanges().listen((event) => setState(() => user = event));
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
        centerTitle: true,
        title: Text(widget.title),
        actions: <Widget>[
          Builder(builder: (BuildContext context){
            return TextButton(
              onPressed: () async {
                final User? user = _auth.currentUser;
                if(user == null){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Not Sign In')
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
        ]
      ),
      body: Builder(builder: (BuildContext context){
        return ListView(
          padding: const EdgeInsets.all(10),
          children: <Widget>[
            _UserInfoCard(user),
            //const Divider(),
            _EmailPasswordForm(),
            //const Divider(),
            const _OtherProvidersSignInSection(),
          ],
        );
      }),
    );
  }

  Future<void> _signOut() async{
    await _auth.signOut();
  }
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
    return Form(
      key: _formKey,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: const Text(
                  'Sign in with email and password',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(),
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
              Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
                child: SignInButtonBuilder(
                  //padding: const EdgeInsets.only(top: 16),
                  icon: Icons.login,
                  backgroundColor: Colors.blueGrey,
                  text: 'Sign In',
                  fontSize: 16,
                  innerPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 35),
                  onPressed: () async{
                    if(_formKey.currentState!.validate()){
                      await _signInWithEmailAndPassword();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Your credentials are incorrect.'),
                      ));
                    }
                  },
                ),
              )
              /*Container(
                padding: const EdgeInsets.only(top: 16),
                alignment: Alignment.center,
                child: SignInButton(
                  Buttons.Google,
                  padding: const EdgeInsets.all(10),
                  onPressed: () async{
                    if(_formKey.currentState!.validate()){
                      await _signInWithEmailAndPassword();
                    }
                  },
                  text: 'Sign In',                  
                ),
              )*/
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
        SnackBar(content: Text('${user.email} sign in'))
      );
    } catch (e) {}
  }
}

class _OtherProvidersSignInSection extends StatefulWidget{
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
    return Card(
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
            /*Container(
              padding: const EdgeInsets.only(top: 16),
              alignment: Alignment.center,
              child: kIsWeb
                  ? const Text('When using Flutter Web, API keys are configured through the Firebase Console. The below providers demostrate how this work.')
                  : const Text('We do not provide an API to obtain the token for below providers')
            ),*/
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
                text: 'Sign in with Google', 
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
        SnackBar(content: Text('Sign in ${user!.displayName} with google'),
      ));
    } catch (e) {
      //print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed sign in with Google: $e'),
      ));
    }
  }
}