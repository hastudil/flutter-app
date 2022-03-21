import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:access_challenge/models/user.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:access_challenge/screens/welcome/welcome_screen.dart';


enum AuthStatus{
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated
}

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth;
  GoogleSignInAccount? _googleUser;
  final Person _user = Person();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  AuthStatus _status = AuthStatus.Uninitialized;
  

  AuthService.instance() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _status = AuthStatus.Unauthenticated;
    } 
    else {
      DocumentSnapshot userSnap = await _db
        .collection('Users')
        .doc(firebaseUser.uid)
        .get();

      _user.setFromFireStore(userSnap);
      _status = AuthStatus.Authenticated;
    }

    notifyListeners();
  }

  Future<void> signInWithEmailAndPassword(context,_emailController,_passwordController) async{
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text, 
        password: _passwordController.text,
      )).user!;

      notifyListeners();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const WelcomeScreen();
          },
        ),
      );
      
      await updateUserData(user);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed login.'),
      ));

      _status = AuthStatus.Uninitialized;
      notifyListeners();
    }
  }
  
  Future<void> googleSignIn(context) async {
    try {
      UserCredential userCredential;
      notifyListeners();

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
      User user = userCredential.user!;
      
      await updateUserData(user);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const WelcomeScreen();
          },
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed login with Google.'),
      ));

      _status = AuthStatus.Uninitialized;
      notifyListeners();
    }
  }

  Future<DocumentSnapshot> updateUserData(User user) async {
    DocumentReference userRef = _db
      .collection('Users')
      .doc(user.uid);

    userRef.set({
      'uid': user.uid,
      'email': user.email,
      'lastSign': DateTime.now(),
      'photoURL': user.photoURL,
      'displayName': user.displayName,
    }, SetOptions(merge: true));

    DocumentSnapshot userData = await userRef.get();

    return userData;
  }

  void signOut() {
    _auth.signOut();
    _status = AuthStatus.Unauthenticated;
    notifyListeners();
  }

  AuthStatus get status => _status;
  Person get user => _user;
  GoogleSignInAccount? get googleUser => _googleUser;
}