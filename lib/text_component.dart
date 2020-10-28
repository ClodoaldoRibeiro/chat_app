import 'package:flutter/material.dart';

class TextComponent extends StatefulWidget {
  TextComponent(this.sendMensage);

  Function(String) sendMensage;

  @override
  _TextComponentState createState() => _TextComponentState();
}

class _TextComponentState extends State<TextComponent> {
  final TextEditingController _controller = TextEditingController();
  bool _digitando = false;

  void _reset() {
    _controller.clear();
    setState(() {
      _digitando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          IconButton(icon: Icon(Icons.photo_camera), onPressed: () {}),
          Expanded(
              child: TextField(
            controller: _controller,
            decoration:
                InputDecoration.collapsed(hintText: "Enviar uma mensagem"),
            onChanged: (text) {
              setState(() {
                _digitando = text.isNotEmpty;
              });
            },
            onSubmitted: (text) {
              widget.sendMensage(text);
              _reset();
            },
          )),
          IconButton(
              icon: Icon(Icons.send),
              onPressed: _digitando
                  ? () {
                      widget.sendMensage(_controller.text);
                      _reset();
                    }
                  : null),
        ],
      ),
    );
  }
}
