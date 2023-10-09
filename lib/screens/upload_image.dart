// In This File You will learn How to upload image from camera, gallery.
// Then how to load these images
// Then how to delete these images
// Then how to Compress the image while uploading

import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({Key? key}) : super(key: key);

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  // This is the firebase instance just like firebase auth instance

  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  bool loading = false;

  // This is the Function for the uploading of images from camera or gallery
  Future<void> uploadImage(String inputSource) async {
    final picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(
        source:
            inputSource == 'camera' ? ImageSource.camera : ImageSource.gallery);

    if (pickedImage == null) {
      return null;
    }
    String fileName = pickedImage.name;
    File imageFile = File(pickedImage.path);
    // The code for compressed image
    File compressedFile = await compressImage(imageFile);
    try {
      setState(() {
        loading = true;
      });
      // await firebaseStorage.ref(fileName).putFile(imageFile);
      await firebaseStorage.ref(fileName).putFile(compressedFile);
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Successfully Uploaded'),
      ));
    } on FirebaseException catch (e) {
      print(e);
    } catch (error) {
      print(error);
    }
  }

  // This is the Function to loads all the images
  Future<List> loadImages() async {
    List<Map> files = [];
    final ListResult result = await firebaseStorage.ref().listAll();
    final List<Reference> allFiles = result.items;
    await Future.forEach(allFiles, (Reference file) async {
      final String fileUrl = await file.getDownloadURL();
      files.add({"url": fileUrl, "path": file.fullPath});
    });
    print(files);
    return files;
  }

  // This is the Function to delete  the image from firebase Storage

  Future<void> delete(String ref) async {
    await firebaseStorage.ref(ref).delete();
    setState(() {});
  }

  // Function for Compress the image while uploading

  Future<File> compressImage(File file) async {
    File compressedFile =
        await FlutterNativeImage.compressImage(file.path, quality: 50);
    print("Original size ");
    print(file.lengthSync());
    print("Compressed Size");
    print(compressedFile.lengthSync());
    return compressedFile;
  }

  // This Function is for uploading multiple images

  Future<void> uploadMultipleImages() async {
    final picker = ImagePicker();
    final List<XFile>? pickedImages = await picker.pickMultiImage();
    if (pickedImages == null) {
      return null;
    }
    setState(() {
      loading = true;
    });
    await Future.forEach(pickedImages, (XFile image) async {
      String fileName = image.name;
      File imageFile = File(image.path);

      try {
        await firebaseStorage.ref(fileName).putFile(imageFile);
      } on FirebaseException catch (e) {
        print(e);
      }
    });
    setState(() {
      loading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Multiple Images Successfully Uploaded')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload to Firebase Storage'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          uploadImage("camera");
                        },
                        icon: Icon(Icons.camera),
                        label: Text('Camera'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          uploadImage("gallery");
                        },
                        icon: Icon(Icons.library_add),
                        label: Text('Gallery'),
                      ),
                    ],
                  ),
            SizedBox(height: 30.h),
            ElevatedButton.icon(
              onPressed: () {
                uploadMultipleImages();
              },
              icon: Icon(Icons.image),
              label: Text('Multiple Images'),
            ),
            SizedBox(height: 30.h),
            Expanded(
              child: FutureBuilder(
                future: loadImages(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                      itemCount: snapshot.data.length ?? 0,
                      itemBuilder: (context, index) {
                        final Map image = snapshot.data[index];
                        return Row(
                          children: [
                            Expanded(
                              child: Card(
                                child: Container(
                                  height: 200.h,
                                  // child: Image.network(image['url']), // This Code is before using cached network image
                                  child: CachedNetworkImage(
                                    imageUrl: image['url'],
                                    placeholder: (context, url) => Image.asset(
                                        'assets/images/cachedImage.jpg'),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await delete(image['path']);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Image Deleted Successfully')));
                              },
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                            ),
                          ],
                        );
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
