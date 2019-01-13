import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sma/AppConfig.dart';
import 'package:sma/CreateMessageCard.dart';
import 'package:sma/MessageList.dart';
import 'package:sma/Repositories/MessagesRepository.dart';
import 'package:smaSDK/SmaSDK.dart';

class MyApp extends StatefulWidget {
  final BuildContext context;

  MyApp(this.context);

  @override
  State createState() {
    return MyAppState(context);
  }
}

class MyAppState extends State<MyApp> {
  SmaSDK _sdk;
  Map<String, Message> _messages = Map();
   LocalStorage _storage;
  MessagesRepository _messagesRepository;

  MyAppState(BuildContext context){
    _storage = LocalStorage(AppConfig.of(context).localStorageKey);
  }

  initState() {
    super.initState();

    _initState();
  }

  _initState() async {
    await _storage.ready;

    _messagesRepository = new MessagesRepository(_storage);

    setState(() {
      _messages = _messagesRepository.getStoredMessages();
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    SmaSDK sdk = SmaSDK(
        baseUrl: AppConfig.of(context).apiUrl,
        clientId: AppConfig.of(context).clientId,
        clientSecret: AppConfig.of(context).clientSecret);

    var accessToken = prefs.get("access_token");

    if (accessToken == null) {
      Token token = await sdk.getAccessToken();

      sdk.token = token;
      setState(() {
        _sdk = sdk;
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
  }

  Future<bool> _addMessage(Message message) async {
    try {
      Message storedMessage = await _sdk.storeMessage(message);

      setState(() {
        _messages = _messagesRepository.addMessage(storedMessage);
      });

      return true;
    } catch (e) {
      print(e.toString());

      return false;
    }
  }

  void _removeMessage(String timestamp, BuildContext context) {
    setState(() {
      _messages = _messagesRepository.removeMessage(timestamp);
    });

    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text("Bericht verwijderd")));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.of(context).appName,
      theme: ThemeData(
          primarySwatch: Colors.red,
          backgroundColor: Colors.white10,
          cardColor: Color.fromRGBO(43, 43, 43, 1),
          accentColor: Colors.accents[0],
          brightness: Brightness.dark,
          canvasColor: Colors.transparent),
      home: MyHomePage(_addMessage, _messages, _removeMessage),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final Future<bool> Function(Message message) _onNewMessage;
  final Map<String, Message> _messages;
  final void Function(String, BuildContext) _removeMessage;

  MyHomePage(this._onNewMessage, this._messages, this._removeMessage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text("Secure Messaging App"),
        ),
        floatingActionButton: Builder(builder: (BuildContext context) {
          return FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Scaffold.of(context).showBottomSheet((BuildContext context) {
                  return CreateMessageCard((Message message) async {
                    bool success = await _onNewMessage(message);

                    if (success) {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("Bericht opgeslagen")));
                      Navigator.of(context).pop();
                    }

                    return success;
                  });
                });
              });
        }),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: MessageList(_messages, _removeMessage),
        ));
  }
}
