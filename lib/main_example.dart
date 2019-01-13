import 'package:flutter/material.dart';
import 'package:sma/AppConfig.dart';
import 'package:sma/main.dart';

void main() => runApp(AppConfig(
  child: Builder(builder: (BuildContext context) => MyApp(context)),
  apiUrl: "http://192.168.86.31:8000",
  appName: "SMA - Development version",
  clientId: "1",
  clientSecret: "Qed8wakGuCyg5li3zB1TPIa23p0N6TXCISlrzUuy",
  localStorageKey: "sma_development",
));