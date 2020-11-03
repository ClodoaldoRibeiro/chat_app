import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'constants.dart';
import 'package:chat_app/text_component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_message.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  FirebaseUser _firebaseUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      setState(() {
        _firebaseUser = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        appBar: AppBar(
          title: Text(_firebaseUser != null
              ? 'Olá,  ${_firebaseUser.displayName}'
              : 'Chat com flutter'),
          centerTitle: true,
          elevation: 0,
          actions: <Widget>[
            _firebaseUser != null
                ? IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      googleSignIn.signOut();

                      globalKey.currentState.showSnackBar(SnackBar(
                        content: Text('Logo-of efetuado com sucesso!'),
                        backgroundColor: kPrimaryColor,
                      ));
                    },
                  )
                : Container(),
          ],
          backgroundColor: kPrimaryColor,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection("posts")
                  .orderBy('time')
                  .snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());

                  default:
                    List<DocumentSnapshot> documents =
                        snapshot.data.documents.reversed.toList();

                    return ListView.builder(
                        itemCount: documents.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          return ChatMessage(
                              documents[index].data,
                              documents[index].data['uid'] ==
                                  _firebaseUser?.uid);
                        });
                }
              },
            )),
            _isLoading ? LinearProgressIndicator() : Container(),
            TextComponent(_sendMessage),
          ],
        ));
  }

  /// Envia um dados para o servidor firebase do Google.
  ///
  /// Envia uma mensagem para o sistema de armazenamento firebase,
  /// os parâmetros[text] e [imgFile] são opcionais, mas caso não seja passado
  /// nada para o para como parâmetros, então a mensagem não será emviada!
  ///
  void _sendMessage({String text, File imgFile}) async {
    final FirebaseUser user = await _getUser();

    if (user == null) {
      globalKey.currentState.showSnackBar(SnackBar(
        content: Text("Erro ao fazer login. Tente novamente!"),
        backgroundColor: kPrimaryColor,
      ));
    }
    Map<String, dynamic> data = {
      "uid": user.uid,
      "senderName": user.displayName,
      "senderPhotoURL": user.photoUrl,
      "time": Timestamp.now()
    };

    /// Fazer o Upload da imagem
    if (imgFile != null) {
      StorageUploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(imgFile);
      setState(() {
        _isLoading = true;
      });
      StorageTaskSnapshot snapshot = await uploadTask.onComplete;
      String url = await snapshot.ref.getDownloadURL();
      print(url);
      data["imgUrl"] = url;

      setState(() {
        _isLoading = false;
      });
    }

    if (text != null) {
      data["text"] = text;
    }

    /// O atributo [posts] será o nome da nosso coleção do Firebase.
    ///
    if ((text != null) || (imgFile != null)) {
      Firestore.instance.collection("posts").add(data);
    }
  }

  Future<FirebaseUser> _getUser() async {
    if (_firebaseUser != null) {
      return _firebaseUser;
    }

    try {
      final GoogleSignInAccount googleSignInAccount =
          await this.googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential authCredential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      final AuthResult authResult =
          await FirebaseAuth.instance.signInWithCredential(authCredential);

      final FirebaseUser user = authResult.user;

      return user;
    } catch (error) {
      return null;
    }
  }
}
