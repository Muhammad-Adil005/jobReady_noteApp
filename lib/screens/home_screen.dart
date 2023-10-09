import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/Note.dart';
import '../services/auth_services.dart';
import 'add_note.dart';
import 'edit_note.dart';

class HomeScreen extends StatelessWidget {
  late User user;
  HomeScreen(this.user);

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NoteBook'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.menu),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.search),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: IconButton(
                  onPressed: () async {
                    await AuthService().signOut();
                  },
                  icon: Icon(Icons.logout),
                ),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('notes')
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length > 0) {
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  NoteModel note =
                      NoteModel.fromJson(snapshot.data.docs[index]);
                  return Card(
                    color: Colors.teal,
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      leading: CachedNetworkImage(
                        imageUrl: note.image,
                        placeholder: (context, url) =>
                            Image.asset('assets/images/cachedImage.jpg'),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        width: 70.w,
                        fit: BoxFit.cover,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      title: Text(
                        note.title,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        note.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditNoteScreen(note),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text('No Notes Available'),
              );
            }
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNoteScreen(user),
              //UploadImageScreen(),
            ),
          );
        },
      ),
    );
  }
}
