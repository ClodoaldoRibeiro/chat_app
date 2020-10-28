import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:chat_app/text_component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void _sendMessage(String text) {
    Firestore.instance.collection("posts").add({"text": text});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Olá nobre!"),
          elevation: 0,
          backgroundColor: kPrimaryColor,
        ),
        body: TextComponent(_sendMessage));
  }
}
