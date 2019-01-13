import 'package:flutter/material.dart';
import 'package:sma/MessageCard.dart';
import 'package:smaSDK/SmaSDK.dart';

class MessageList extends StatelessWidget {
  final Map<String, Message> messages;
  final void Function(String, BuildContext) removeMessage;
  final void Function(BuildContext context, String field, String message)
      onMessagePress;
  final void Function(BuildContext context, String field, String link)
      onUrlPress;
  final void Function(BuildContext context, String field, String password)
      onPasswordPress;

  MessageList(
      {@required this.messages,
      @required this.removeMessage,
      @required this.onMessagePress,
      @required this.onUrlPress,
      @required this.onPasswordPress});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _buildRows(context),
    );
  }

  List<Widget> _buildRows(context) {
    List<Widget> rows = [];

    if (messages.length == 0) {
      return [
        Center(
            child: Text(
          "Hier komen je berichten te staan.",
          style: TextStyle(fontSize: 18),
        ))
      ];
    }

    messages.forEach((key, message) {
      rows.add(Dismissible(
        key: Key(key),
        child: MessageCard(
            message: message,
            onMessagePress: onMessagePress,
            onUrlPress: onUrlPress,
            onPasswordPress: onPasswordPress),
        onDismissed: (DismissDirection dismissDirection) =>
            removeMessage(key, context),
        direction: DismissDirection.startToEnd,
      ));
    });

    return rows;
  }
}
