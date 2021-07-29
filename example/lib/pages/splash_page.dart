import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<void> configFuture;
  Future<void> loadConfig() async {
    Localization.setTranslationDirectories([
      'assets/lang',
      'packages/package_example/assets/lang',
    ]);
    await Localization.configuration(selectedLanguage: 'pt_BR');
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  void initState() {
    configFuture = loadConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: configFuture,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Splash'),
          ),
          body: Center(
            child: Text('Loading....'),
          ),
        );
      },
    );
  }
}
