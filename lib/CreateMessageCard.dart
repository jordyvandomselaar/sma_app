import 'package:flutter/material.dart';
import 'package:smaSDK/SmaSDK.dart';
import 'package:validate/validate.dart';

class CreateMessageCard extends StatefulWidget {
  final Future<bool> Function(Message message) _onNewMessage;

  CreateMessageCard(this._onNewMessage);

  @override
  State<StatefulWidget> createState() {
    return new CreateMessageCardState(_onNewMessage);
  }
}

class CreateMessageCardState extends State<CreateMessageCard> {
  final Future<bool> Function(Message message) _onNewMessage;
  String _message = "";
  String _email = "";

  CreateMessageCardState(this._onNewMessage);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
            autovalidate: true,
            child: Builder(builder: (BuildContext context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    maxLines: 5,
                    decoration: InputDecoration(
                        labelText: "Het te versleutelen bericht"),
                    onSaved: (message) => _message = message,
                    keyboardType: TextInputType.multiline,
                    validator: (message) {
                      if (message.isEmpty) {
                        return "Je bericht mag niet leeg zijn";
                      }

                      return null;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                        "Wil je een e-mail ontvangen wanneer het bericht geopend wordt? Vul dan je e-mail in."),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: "Jouw e-mail", hintText: "info@example.com"),
                    onSaved: (email) => _email = email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (email) {
                      if (email.isEmpty) {
                        return null;
                      }

                      try {
                        Validate.isEmail(email);

                        return null;
                      } on ArgumentError {
                        return "Voer een geldig e-mail adres in";
                      }
                    },
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.only(top: 10),
                    child: FloatingActionButton(
                        onPressed: () async {
                          if (!Form.of(context).validate()) {
                            return;
                          }

                          Form.of(context).save();

                          bool success =
                              await _onNewMessage(Message(_message, _email));

                          if (!success) {
                            return;
                          }
                        },
                        child: Icon(Icons.send)),
                  )
                ],
              );
            })),
      ),
    );
  }
}
