import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:chat_app/text_component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void _sendMessage({String text, File imgFile}) async {
    Map<String, dynamic> data = {};

    if (imgFile != null) {
      StorageUploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(imgFile);

      StorageTaskSnapshot snapshot = await uploadTask.onComplete;
      String url = await snapshot.ref.getDownloadURL();
      print(url);
      data["imgUrl"] = url;
    }

    if (text != null) {
      data["text"] = text;
    }
    Firestore.instance.collection("posts").add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Olá nobre!"),
          elevation: 0,
          backgroundColor: kPrimaryColor,
        ),
        body: Column(
          children: <Widget>[
            Expanded(child: null),
            TextComponent(_sendMessage),
          ],
        ));
  }
}
