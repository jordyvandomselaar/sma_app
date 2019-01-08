import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sma/CreateMessageCard.dart';
import 'package:sma/MessageList.dart';
import 'package:smaSDK/SmaSDK.dart';

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

  MyAppState() {
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      SmaSDK sdk = SmaSDK(
          baseUrl: "http://192.168.1.58:8000",
          clientId: "1",
          clientSecret: "gZU2EAUZo4tlKaanBl8zvrb8n6DZNsBoMTMyqUO7");

      var accessToken = prefs.get("access_token");

      if (accessToken == null) {
        sdk.getAccessToken().then((Token token) {
          sdk.token = token;
          setState(() {
            _sdk = sdk;
          });
        });

        return;
      }

      Token token = Token(
        accessToken: prefs.get("access_token"),
        expiresAt: prefs.get("expires_at"),
      );
      sdk.token = token;

      setState(() {
        _sdk = sdk;
      });
    });
  }

  Future<bool> _addMessage(Message message) async {
    try {
      Message storedMessage = await _sdk.storeMessage(message);

      setState(() {
        _messages[DateTime.now().millisecondsSinceEpoch] = storedMessage;
      });
    } catch (e) {
      print(e.toString());

      return false;
    }

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
      floatingActionButton: Builder(builder: (BuildContext context) {
        return FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Scaffold.of(context).showBottomSheet((BuildContext context) {
                return CreateMessageCard((Message message) {
                  Navigator.of(context).pop();

                  return _onNewMessage(message);
                });
              });
            });
      }),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[Expanded(child: MessageList(_messages))],
        ),
      ),
    );
  }
}
