import 'package:animated_text_kit/animated_text_kit.dart';
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

class _LoginPageState extends State<LoginPage>with SingleTickerProviderStateMixin {
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
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),backgroundColor: Colors.red,));
    }
  }
  late AnimationController controller;
  late Animation animation;
  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync:this ,
        duration: Duration(seconds: 1)
    );

    animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    controller.forward();
    controller.addListener(() {
      setState(() {
      });
    });
  }
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20,),
                // Icon(Icons.message, size: 80,color: Colors.grey[800]),
                Row(
                  children: <Widget>[
                    Hero(
                      tag:'logo',
                      child: Container(
                        child: Image.asset('images/logo.png'),
                        height: animation.value*100,
                      ),
                    ),
                    AnimatedTextKit(isRepeatingAnimation: false,
                        animatedTexts: [   TypewriterAnimatedText('Flow-mate',
                            speed : const Duration(milliseconds: 150),
                            textStyle: TextStyle(
                                fontSize: 30.0, // Adjust the font size as needed
                                color: Colors.black,
                                fontWeight: FontWeight.w800// Change the text color
                            )) ]),
                  ],
                ),
                // Text('Welcome back',style: TextStyle(fontSize: 16)),
                SizedBox(height: 20,),
                MyTextField(controller: emailController, hintText: 'Email', obscureText: false),
                SizedBox(height: 20,),
                MyTextField(controller: passwordController, hintText: 'Password', obscureText: true),
                SizedBox(height: 20,),
                MyButton(onTap: signIn, text: 'Signin',color: Colors.lightBlueAccent,),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   const Text('Not a member ? ',style: TextStyle(
                     color: Colors.black,
                       fontSize: 16
                   ),),
                   const SizedBox(height: 20,),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text('Register now ! ',style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
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