import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/login_controller.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
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
            Obx(
              () => loginController.loading.value
                  ? CircularProgressIndicator()
                  : Container(
                      height: 50.h,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () async {
                          // Call the login function from the controller
                          await loginController.loginUser(emailController.text,
                              passwordController.text, context);
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// This below code is without the use of Getx
/*
 Obx(
                () => loginController.loading.value
                    ? CircularProgressIndicator()
                    :
                Container(
                        height: 50.h,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              loading = true;
                            });
                            if (emailController.text == "" ||
                                passwordController.text == "") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("All fields sre required "),
                                      backgroundColor: Colors.redAccent));
                            } else {
                              User? result = await AuthService().login(
                                  emailController.text,
                                  passwordController.text,
                                  context);
                              if (result != null) {
                                print("successfully Login");
                                /* Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(result),
                                ),
                                (route) => false);*/
                                Get.to(() => (HomeScreen(result)));
                              }
                            }
                            setState(() {
                              loading = false;
                            });
                          },
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                SizedBox(height: 20.h)),
*/
