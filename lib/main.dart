import 'package:flutter/material.dart';
import 'package:sma/CreateMessageCard.dart';
import 'package:sma/MessageList.dart';
import 'package:smaSDK/SmaSDK.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  SmaSDK _sdk;
  Map<int, Message> _messages = Map();


  Future<bool> _addMessage (Message message) async {
    setState(() {
      _messages[DateTime.now().millisecondsSinceEpoch] = message;
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(_addMessage, _messages),
    );
  }

  @override
  void initState() {
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      SmaSDK sdk = SmaSDK(
          baseUrl: "http://192.168.86.31:8000",
          clientId: "1",
          clientSecret: "gZU2EAUZo4tlKaanBl8zvrb8n6DZNsBoMTMyqUO7");

      var accessToken = prefs.get("access_token");

      if (accessToken != null) {
        Token token = Token(
            accessToken: prefs.get("access_token"),
            expiresAt: prefs.get("expires_at"),
            refreshToken: prefs.get("refresh_token"));

        sdk.token = token;

        setState(() {
          _sdk = sdk;
        });
      } else {
        sdk.getAccessToken().then((Token token) {
          sdk.token = token;

          setState(() {
            _sdk = sdk;
          });
        });
      }
    });
  }
}

class MyHomePage extends StatelessWidget {
  final Future<bool> Function(Message message) _onNewMessage;
  final Map<int, Message> _messages;


  MyHomePage(this._onNewMessage, this._messages);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Secure Messaging App"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[CreateMessageCard(_onNewMessage), Expanded(child: MessageList(_messages))],
        ),
      ),
    );
  }
}
