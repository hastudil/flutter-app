import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class RegisterPage extends StatefulWidget{
  const RegisterPage({Key? key}) : super(key: key);
  final String title = 'Sign Up';

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _success = false;
  String _userEmail = '';

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
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
                Container(
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
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(_success
                    ? 'Successfully regitered $_userEmail'
                    : 'Registration incompleted'
                  ),
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
      setState(() {
        _success = true;
        _userEmail = user.email.toString();
      });
    }
    else{
      _success = false;
    }
  }
}