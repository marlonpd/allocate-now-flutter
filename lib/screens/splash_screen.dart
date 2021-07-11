import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Icon(
          Icons.monetization_on_sharp,
          size: MediaQuery.of(context).size.width * 0.785,
        ),
      ),
    );
  }
}
