import 'package:flutter/material.dart';
import 'package:sma/MessageCard.dart';
import 'package:smaSDK/SmaSDK.dart';

class MessageList extends StatelessWidget {
  final Map<String, Message> _messages;
  final void Function(String, BuildContext) _removeMessage;

  MessageList(this._messages, this._removeMessage);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _buildRows(context),
    );
  }

  List<Widget> _buildRows(context) {
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
      rows.add(
        Dismissible(key: Key(key), child: MessageCard(message), onDismissed: (DismissDirection dismissDirection) => _removeMessage(key, context), direction: DismissDirection.startToEnd,)
      );
    });

    return rows;
  }
}
