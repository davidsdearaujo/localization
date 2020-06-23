import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (_) => SplashPage(),
        '/home': (_) => HomePage(),
      },
    );
  }
}

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    loadConfig();
    return Scaffold(
      appBar: AppBar(
        title: Text('Splash'),
      ),
      body: Center(
        child: Text('Loading....'),
      ),
    );
  }

  loadConfig() async {
    await Localization.configuration(selectedLanguage: 'pt_BR');
    Navigator.pushReplacementNamed(context, '/home');
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String lang = 'pt_BR';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lang),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("welcome".i18n(["22/06"])),
            TextField(
                decoration: InputDecoration(labelText: "login-label".i18n())),
            TextField(
                decoration:
                    InputDecoration(labelText: "password-label".i18n())),
            RaisedButton(
              child: Text("change-value".i18n()),
              onPressed: () async {
                setState(() {
                  if (lang == 'pt_BR')
                    lang = 'en_US';
                  else
                    lang = 'pt_BR';
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
