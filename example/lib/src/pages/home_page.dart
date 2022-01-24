import 'package:example/src/my_app.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return Scaffold(
      appBar: AppBar(title: Text("home-title".i18n([locale.toString()]))),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("welcome".i18n(["22/06"])),
            Text("package-key-value".i18n()),
            TextField(decoration: InputDecoration(labelText: "login-label".i18n())),
            TextField(decoration: InputDecoration(labelText: "password-label".i18n())),
            ElevatedButton(
              child: Text("change-value".i18n()),
              onPressed: () {
                final myApp = context.findAncestorStateOfType<MyAppState>()!;
                myApp.changeLocale(locale == Locale('pt', 'BR') ? Locale('en', 'US') : Locale('pt', 'BR'));
              },
            ),
          ],
        ),
      ),
    );
  }
}
