import 'package:localstorage/localstorage.dart';
import 'package:smaSDK/SmaSDK.dart';

class MessagesRepository {
  final LocalStorage _storage;
  Map<String, Message> _messages;

  MessagesRepository(this._storage) {
    _messages = _initialize();
  }

  Map<String, Message> addMessage(Message message) {
    _messages[DateTime.now().microsecondsSinceEpoch.toString()] = message;

    _flush();

    return _messages;
  }

  Map<String, Message> removeMessage(String key) {
    _messages.remove(key);

    _flush();

    return _messages;
  }

  void _flush() async {
    _storage.setItem("messages", _messages);
  }

  Map<String, Message> getStoredMessages () {
    return _messages;
  }

  Map<String, Message> _initialize() {
    Map<String, dynamic> storedMessages = _storage.getItem("messages");

    if(storedMessages == null) {
      return {};
    }

    return storedMessages.map((String key, dynamic json) {
      return MapEntry(key, Message.fromJson(json));
    });
  }
}
