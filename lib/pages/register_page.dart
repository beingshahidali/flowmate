import 'package:flowwmate/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/components/my_text_field.dart';
import '/components/my_button.dart';

class RegisterPage extends StatefulWidget {
  final void Function() ?onTap;
  const RegisterPage({super.key,required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();


  void signUp() async{
    if(passwordController.text != confirmPasswordController.text){
      ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text("Passwords don't match")));
      return;
    }
    //get auth service
    final authService = Provider.of<AuthService>(context,listen: false);
    try{
      await authService.signInWithEmailAndPassword(emailController.text, passwordController.text);
    }
    catch(e){
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
                Text("Let's create an account for you ",style: TextStyle(fontSize: 16)),
                SizedBox(height: 20,),
                MyTextField(controller: emailController, hintText: 'Email', obscureText: false),
                SizedBox(height: 20,),
                MyTextField(controller: passwordController, hintText: 'Password', obscureText: true),
                SizedBox(height: 20,),
                MyTextField(controller: confirmPasswordController, hintText: 'Confirm Password', obscureText: true),
                SizedBox(height: 20,),
                MyButton(onTap:signUp, text: 'Register'),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   const  Text('Already a member ? '),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text('Login now ! ',style: TextStyle(
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
