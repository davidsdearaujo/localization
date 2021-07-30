import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String lang = Localization.selectedLanguage.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("home-title".i18n([lang]))),
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
              onPressed: () async {
                setState(() {
                  lang = lang == 'pt_BR' ? 'en_US' : 'pt_BR';
                });
                await Localization.configuration(selectedLanguage: lang);
              },
            ),
          ],
        ),
      ),
    );
  }
}
