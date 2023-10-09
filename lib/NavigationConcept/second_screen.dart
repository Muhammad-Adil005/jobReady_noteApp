import 'package:flutter/material.dart';

import 'contact_screen.dart';

class SecondScreen extends StatefulWidget {
  static String id = '/SecondScreen';

  const SecondScreen({Key? key}) : super(key: key);

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Screen'),
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ContactScreen(),
              ),
            );

            // pop method
            // Navigator.pop(context);
          },
          child: Text(
              'Go to Contact Screen'), // when user click on this Text it will navigate to the previous screen
        ),
      ),
    );
  }
}
