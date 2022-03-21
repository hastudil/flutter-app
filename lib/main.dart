import 'package:access_challenge/screens/loading_screen.dart';
import 'package:access_challenge/screens/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:access_challenge/screens/login/login_screen.dart';
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