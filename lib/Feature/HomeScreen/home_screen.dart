import 'package:flutter/material.dart';

import '../Onboeding/UI/onboarding_screen.dart' show OnboardingScreen;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>OnboardingScreen()));
          
        }, icon: Icon(Icons.back_hand)),
        
    ));
  }
}
