import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geobound_mobile/firebase_options.dart';
import 'package:geobound_mobile/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'attendance-checker-63276',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Geobound',
      home: LoginScreen(),
    );
  }
}
