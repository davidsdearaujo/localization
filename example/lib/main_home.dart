import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LocalizationWidget(
        child: HomePage(),
        // selectedLanguage: 'en_US',
        // selectedLanguage: 'pt_BR',
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("homeTitle".i18n()), 
      ),
    );
  }
}
