import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:note_app/screens/Register_Screen.dart';
import 'package:note_app/screens/home_screen.dart';
import 'package:note_app/services/auth_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const NoteApp());
}

class NoteApp extends StatelessWidget {
  const NoteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(370, 860),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Note App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            //primarySwatch: Colors.blue,
            brightness: Brightness.dark,
          ),
          home: StreamBuilder(
            stream: AuthService().firebaseAuth.authStateChanges(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return HomeScreen(snapshot.data);
                // return UploadImageScreen(); // Just for testing if it is Shown or not
              }
              return RegisterScreen();
            },
          ),
        );
      },
    );
  }
}

//FirstScreen(),
// When we used initail Routes then we cannot use a Home property.
// initialRoute: FirstScreen.id,
// routes: {
//   // When i used a static id then how to call each of the screen
//   FirstScreen.id: (context) => FirstScreen(),
//   SecondScreen.id: (context) => SecondScreen(),
//   ContactScreen.id: (context) => ContactScreen(),
// '/': (context) => FirstScreen(),
// '/SecondScreen': (context) => SecondScreen(),
// '/ContactScreen': (context) => ContactScreen(),
//},
