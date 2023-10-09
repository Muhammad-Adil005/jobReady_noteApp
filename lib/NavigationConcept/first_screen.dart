import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/NavigationConcept/second_screen.dart';

class FirstScreen extends StatefulWidget {
  static String id = '/FirstScreen';

  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.pink,
                child: Icon(Icons.title),
              ),
              accountName: Text('Elon Mask'),
              accountEmail: Text('Tesla@gmail.com'),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                    context,
                    SecondScreen
                        .id); // if i go to the second screen and pressed back button then the Drawer will  be opened which is not a best practice for
                // this we use pop method before push method.
              },
            ),
            ListTile(
              leading: Icon(CupertinoIcons.square_grid_2x2),
              title: Text('About'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.add_circle_outline_rounded),
              title: Text('Courses'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Contact'),
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('First Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Push method
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => SecondScreen(),
            //   ),
            // );

            // PushNamed method
            Navigator.pushNamed(context, SecondScreen.id);
          },
          child: Text('Go to Second Screen'),
        ),
      ),
    );
  }
}

// Push and Push Replacement :> When we use Push Replacement we cannot go back to the screen where we
// are coming from.
