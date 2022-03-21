import 'package:access_challenge/models/products.dart';
import 'package:flutter/material.dart';
//import 'package:access_challenge/screens/login/login_screen.dart';
//import 'package:access_challenge/screens/Signup/signup_screen.dart';
//import 'package:access_challenge/screens/welcome/components/background.dart';
//import 'package:access_challenge/components/rounded_button.dart';
//import 'package:access_challenge/constants.dart';
//import 'package:access_challenge/screens/login/login_screen.dart';
import 'package:access_challenge/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:access_challenge/components/bar_chart.dart';

import 'package:access_challenge/components/import_data_controller.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    final User? user = _auth.currentUser;
    final String? userEmail = user!.email;
    // This size provide us total height and width of our screen
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black45,
        centerTitle: true,
        title: Text(
          'Welcome $userEmail',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          Builder(builder: (BuildContext context){
            return TextButton(
              onPressed: () async {
                await _importSpreadSheetData(context);
                return;
              },
              child: const Text('Import Data',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                )
              ),
            );
          }),
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
                  SnackBar(content: Text('$userEmail has successfully signed out'),
                ));

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const AccessChallengeWeb();//SignInPage();
                    },
                  ),
                );
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
      body: const MyChart(),
    );
  }

  Future<void> _signOut() async{
    await _auth.signOut();
  }

  Future<void> _importSpreadSheetData(context) async{
    ImportDataController().getProductsList(context);
  }
}