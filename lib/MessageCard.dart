import 'package:flutter/material.dart';
import 'package:smaSDK/SmaSDK.dart';

class MessageCard extends StatelessWidget {
  final Message message;

  MessageCard(this.message);

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
                Text(message.message),
                Padding(
                    child: Text("Url",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                    padding: EdgeInsets.only(top: 10, bottom: 10)),
                Text(message.url),
                Padding(
                    child: Text("Wachtwoord",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                    padding: EdgeInsets.only(top: 10, bottom: 10)),
                Text(message.password),
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
