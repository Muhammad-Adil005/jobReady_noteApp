import 'dart:io'; // Import dart:io for File class

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddNoteController extends GetxController {
  final RxBool loading = false.obs;
  final Rx<File?> imageFile = Rx<File?>(null);
  final RxString fileName =
      RxString(''); // Initialize RxString with an empty string
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<void> uploadImage() async {
    final picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) {
      return;
    }
    fileName.value =
        pickedImage.name; // Set the value directly without using .value
    imageFile.value = File(pickedImage.path);
  }
}
