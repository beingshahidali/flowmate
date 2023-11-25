

import 'package:firebase_core/firebase_core.dart';
import 'package:flowwmate/firebase_options.dart';
import 'package:flowwmate/services/auth/auth_gate.dart';
import 'package:flowwmate/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'services/auth/login_or_register.dart';
import 'services/auth/auth_gate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // runApp(ChangeNotifierProvider(create: (context)=>AuthService(),
  // child: const MyApp(),
  // ));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()), //provider : popular state management solution 
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      home: AuthGate(),
    );
  }
}
