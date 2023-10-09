import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:get/get.dart';

import '../controller/loading_controller.dart';
import '../services/auth_services.dart';
import 'Login_Screen.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  //bool loading = false;

  // Instantiate the controller
  final LoadingController loadingController = Get.put(LoadingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30.h),
              TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30.h),
              TextField(
                obscureText: true,
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30.h),
              Obx(() => loadingController.loading.value
                  ? CircularProgressIndicator()
                  : Container(
                      height: 50.h,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () async {
                          /* setState(() {
                            loading = true;
                          });*/
                          loadingController.loading.value = true;

                          if (emailController.text == "" ||
                              passwordController.text == "") {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("All fields sre required "),
                                backgroundColor: Colors.redAccent));
                          } else if (passwordController.text !=
                              confirmPasswordController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Passwords don't match !"),
                                backgroundColor: Colors.redAccent));
                          } else {
                            User? result = await AuthService().register(
                                emailController.text,
                                passwordController.text,
                                context);
                            if (result != null) {
                              print("successfully Registered");
                              /*Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(result),
                                  ),
                                  (route) => false);*/
                              Get.to(() => HomeScreen(result));
                            }
                          }
                          /*setState(() {
                            loading = false;
                          });*/
                          loadingController.loading.value = false;
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )),
              SizedBox(height: 20.h),
              TextButton(
                onPressed: () {
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );*/
                  Get.to(() => LoginScreen());
                },
                child: Text('Already have an account? Login here'),
              ),
              SizedBox(height: 20.h),
              Divider(),
              SizedBox(height: 20.h),
              Obx(
                () => loadingController.loading.value
                    ? CircularProgressIndicator()
                    : SignInButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              30), // Adjust the radius as needed
                        ),
                        Buttons.Google,
                        text: "Continue with Google",
                        onPressed: () async {
                          /*setState(() {
                          loading = true;
                        });*/
                          loadingController.loading.value = true;

                          await AuthService().signInWithGoogle();
                          /*setState(() {
                          loading = false;
                        });*/
                          loadingController.loading.value = false;
                        },
                        padding: EdgeInsets.all(5),
                      ),
                // SignInButton(
                //   Buttons.Facebook,
                //   text: "Continue with Facebook",
                //   onPressed: () {},
                //   padding: EdgeInsets.all(5),
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
