import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import 'config.dart';
import 'screens/login.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<CookieRequest>(
      create: (_) => CookieRequest(),
      child: MaterialApp(
        title: 'Dibuang Sayang',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: kGreen, secondary: kOrange),
          scaffoldBackgroundColor: kBackground,
          appBarTheme: const AppBarTheme(backgroundColor: kGreen, foregroundColor: Colors.white),
          useMaterial3: true,
        ),
        home: const LoginPage(),
      ),
    );
  }
}
