import 'package:flutter/material.dart';
import 'constants.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Olá nobre!"),
        elevation: 0,
        backgroundColor: kPrimaryColor,
      ),
    );
  }
}
