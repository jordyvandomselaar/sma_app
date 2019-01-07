import 'package:flutter/material.dart';
import 'package:smaSDK/SmaSDK.dart';

class CreateMessageCard extends StatelessWidget {
  final Future<bool> Function(Message message) _onNewMessage;
  TextEditingController _messageController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  CreateMessageCard(this._onNewMessage);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _messageController,
            maxLines: null,
            decoration:
                InputDecoration(labelText: "Het te versleutelen bericht"),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
                "Wil je een e-mail ontvangen wanneer het bericht geopend wordt? Vul dan je e-mail in."),
          ),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: "Jouw e-mail"),
          ),
          Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.only(top: 10),
            child: FloatingActionButton(
                onPressed: () async {
                  bool success = await _onNewMessage(
                      Message(_messageController.text, _emailController.text));

                  if (!success) {
                    return;
                  }

                  _messageController.text = "";
                  _emailController.text = "";
                },
                child: Icon(Icons.send)),
          )
        ],
      ),
    ));
  }
}
