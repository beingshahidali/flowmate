import 'package:flowwmate/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/components/my_text_field.dart';
import '/components/my_button.dart';
import 'package:provider/provider.dart';
class LoginPage extends StatefulWidget {

  final void Function() ?onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() async{
    final authService = Provider.of<AuthService>(context,listen: false);
    try{
      await authService.signInWithEmailAndPassword(emailController.text, passwordController.text);
    }
    catch(e)
    {
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                SizedBox(height: 20,),
                Icon(Icons.message, size: 80,color: Colors.grey[800]),
                Text('Welcome back',style: TextStyle(fontSize: 16)),
                SizedBox(height: 20,),
                MyTextField(controller: emailController, hintText: 'Email', obscureText: false),
                SizedBox(height: 20,),
                MyTextField(controller: passwordController, hintText: 'Password', obscureText: true),
                SizedBox(height: 20,),
                MyButton(onTap: signIn, text: 'Signin'),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   const Text('Not a member ? '),
                   const SizedBox(height: 20,),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text('Register now ! ',style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),),
                    )

                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}