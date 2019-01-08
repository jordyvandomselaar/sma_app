import 'package:flutter/material.dart';
import 'package:sma/MessageCard.dart';
import 'package:smaSDK/SmaSDK.dart';

class MessageList extends StatelessWidget {
  final Map<int, Message> _messages;

  MessageList(this._messages);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _buildRows(),
    );
  }

  List<Widget> _buildRows() {
    List<Widget> rows = [];

    if (_messages.length == 0) {
      return [
        Center(
            child: Text(
          "Hier komen je berichten te staan.",
          style: TextStyle(fontSize: 18),
        ))
      ];
    }

    _messages.forEach((key, message) {
      rows.add(MessageCard(message));
    });

    return rows;
  }
}
