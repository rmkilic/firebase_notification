import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(      
      body: Column(children: [
        Text("Login View",style: Theme.of(context).textTheme.headlineLarge,)
      ],),
    );

  }
}