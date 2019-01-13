import 'package:flutter/material.dart';
import 'package:smaSDK/SmaSDK.dart';

class MessageCard extends StatelessWidget {
  final Message message;
  final void Function(BuildContext context, String field, String message)
      onMessagePress;
  final void Function(BuildContext context, String field, String link)
      onUrlPress;
  final void Function(BuildContext context, String field, String password)
      onPasswordPress;

  MessageCard(
      {@required this.message,
      @required this.onMessagePress,
      @required this.onUrlPress,
      @required this.onPasswordPress});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(10),
              child: Column(children: <Widget>[
                Padding(
                  child: Text("Je bericht",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  padding: EdgeInsets.only(bottom: 10),
                ),
                FlatButton(
                  child: Text(message.message),
                  onPressed: () =>
                      onMessagePress(context, "bericht", message.message),
                ),
                Padding(
                    child: Text("Url",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                    padding: EdgeInsets.only(top: 10, bottom: 10)),
                FlatButton(
                  child: Text(message.url),
                  onPressed: () => onUrlPress(context, "url", message.url),
                ),
                Padding(
                    child: Text("Wachtwoord",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                    padding: EdgeInsets.only(top: 10, bottom: 10)),
                FlatButton(
                  child: Text(message.password),
                  onPressed: () =>
                      onPasswordPress(context, "wachtwoord", message.password),
                ),
              ])),
          Container(
            height: 5,
            color:
                this.message.isValid() ? Colors.blueAccent : Colors.redAccent,
          )
        ],
      ),
    );
  }
}
