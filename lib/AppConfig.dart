import 'package:flutter/material.dart';

class AppConfig extends InheritedWidget {
  final String apiUrl;
  final String localStorageKey;
  final String clientId;
  final String clientSecret;
  final String appName;

  AppConfig(
      {@required this.apiUrl,
      @required this.localStorageKey,
      @required this.clientId,
      @required this.clientSecret,
      @required this.appName,
      @required Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static AppConfig of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(AppConfig);
}
