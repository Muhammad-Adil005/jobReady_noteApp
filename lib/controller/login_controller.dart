import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../screens/home_screen.dart';
import '../services/auth_services.dart';

class LoginController extends GetxController {
  var loading = false.obs;

  Future<void> loginUser(
      String email, String password, BuildContext context) async {
    loading.value = true;
    try {
      User? result = await AuthService().login(email, password, context);
      if (result != null) {
        print("successfully Login");
        Get.to(() => HomeScreen(result));
      }
    } catch (e) {
      print('Error occurred during login: $e');
    } finally {
      loading.value = false;
    }
  }
}

LoginController loginController = LoginController();
