import 'package:flowwmate/pages/login_page.dart';
import 'package:flowwmate/pages/register_page.dart';
import 'package:flutter/material.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  @override
  bool showLoginPage = true;

  void togglePages(){
    setState(() {
      showLoginPage = !showLoginPage;

    });
  }
  Widget build(BuildContext context) {
    if(showLoginPage)
      return LoginPage(onTap: togglePages);
    else
      return RegisterPage(onTap: togglePages);
  }
}
