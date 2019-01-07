import 'package:flutter/material.dart';
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

    if (_messages == null) {
      return [];
    }

    _messages.forEach((key, message) {
      rows.add(Text(message.email));
    });

    return rows;
  }
}
