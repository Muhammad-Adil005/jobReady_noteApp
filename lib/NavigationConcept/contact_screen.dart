import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget {
  static String id = '/ContactScreen';

  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Screen'),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: Text('This is Contact Screen'),
        ),
      ),
    );
  }
}
