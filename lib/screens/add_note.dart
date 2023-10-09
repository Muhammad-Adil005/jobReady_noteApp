import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:note_app/screens/home_screen.dart';

import '../controller/add_note_controller.dart';
import '../services/firestore_service.dart';

class AddNoteScreen extends StatefulWidget {
  final User user;
  AddNoteScreen(this.user);

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  //TextEditingController titleController = TextEditingController();
  //TextEditingController descriptionController = TextEditingController();
  final AddNoteController controller = Get.put(AddNoteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  controller.uploadImage();
                },
                child: Container(
                  height: 150.h,
                  child: controller.imageFile.value == null
                      ? Center(
                          child: Icon(
                            Icons.image,
                            size: 100.sp,
                          ),
                        )
                      : Center(
                          child: Image.file(controller.imageFile.value!),
                        ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Title',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.sp,
                ),
              ),
              SizedBox(height: 20.h),
              TextField(
                controller: controller.titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30.h),
              Text(
                'Description',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.sp,
                ),
              ),
              SizedBox(height: 20.h),
              TextField(
                controller: controller.descriptionController,
                minLines: 5,
                maxLines: 10,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30.h),
              Obx(
                () => controller.loading.value
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        height: 50.h,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                          child: Text(
                            'Add Note',
                            style: TextStyle(
                              fontSize: 25.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () async {
                            if (controller.titleController.text.isEmpty ||
                                controller.descriptionController.text.isEmpty ||
                                controller.imageFile.value == null) {
                              // Show the Snackbar only if any of the fields is empty
                              Get.snackbar(
                                snackPosition: SnackPosition.BOTTOM,
                                'Error',
                                'All fields are required!',
                              );
                            } else {
                              controller.loading.value = true;

                              String imageUrl = await FirebaseStorage.instance
                                  .ref(controller.fileName.value)
                                  .putFile(controller.imageFile.value!)
                                  .then((result) {
                                return result.ref.getDownloadURL();
                              });
                              await FirestoreService().insertNote(
                                controller.titleController
                                    .text, // Use the controller from AddNoteController
                                controller.descriptionController
                                    .text, // Use the controller from AddNoteController
                                imageUrl,
                                widget.user.uid,
                              );
                              controller.loading.value = false;

                              // Navigate to the home screen after successfully adding the note
                              Get.to(
                                HomeScreen(widget.user),
                              );
                            }
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
