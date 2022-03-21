import 'package:auto_route/auto_route.dart';
import 'package:access_challenge/main.dart';
import 'package:access_challenge/screens/login/login_screen.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    AutoRoute(
      page: AccessChallengeWeb,
      name: 'HomeRoute',
      path: '/',
    ),
    AutoRoute(
      page: LoginScreen,
      name: 'LoginRoute',
      path: '/login',
    )
  ],
)
class $AppRouter {}