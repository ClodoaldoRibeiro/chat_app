import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage(this.data, this.mine);

  final Map<String, dynamic> data;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        children: <Widget>[
          !mine
              ? Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: CircleAvatar(
                      backgroundImage: NetworkImage(data['senderPhotoURL'])),
                )
              : Container(),
          Expanded(
              child: Column(
            crossAxisAlignment:
                mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              data['imgUrl'] != null
                  ? Image.network(
                      data['imgUrl'],
                      width: 230.0,
                    )
                  : Container(
                      color: kBackgroundColor,
                      child: Text(
                        data['text'],
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w300),
                        textAlign: mine ? TextAlign.justify : TextAlign.start,
                      ),
                    ),
              Text(
                data['senderName'],
                style: TextStyle(
                    fontSize: 7,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic),
              ),
            ],
          )),
          mine
              ? Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: CircleAvatar(
                      backgroundImage: NetworkImage(data['senderPhotoURL'])),
                )
              : Container()
        ],
      ),
    );
  }
}
