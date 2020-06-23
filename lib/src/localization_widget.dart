import 'dart:async';

import 'package:flutter/material.dart';

import 'extension.dart';

class LocalizationWidget extends StatefulWidget {
  final String translationLocale;
  final String defaultLang;
  final Widget child;
  final String selectedLanguage;

  LocalizationWidget({
    Key key,
    this.translationLocale = "assets/lang",
    this.defaultLang = "pt_BR",
    @required this.child,
    this.selectedLanguage = '',
  })  : assert(
          child != null,
          "The field 'child' cannot be null.",
        ),
        super(key: key);

  @override
  _LocalizationWidgetState createState() => _LocalizationWidgetState();
}

class _LocalizationWidgetState extends State<LocalizationWidget> {
  Future<void> future;
  Timer timeoutTimer;

  @override
  void initState() {
    super.initState();

    future = Localization.configuration(
      translationLocale: widget.translationLocale,
      defaultLang: widget.defaultLang,
      selectedLanguage: widget.selectedLanguage,
    );

    timeoutTimer = Timer(Duration(seconds: 2), () {
      setState(() {
        timeoutTimer.cancel();
      });
    });
  }

  @override
  void dispose() {
    timeoutTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done ||
            timeoutTimer.isActive) {
          return Material(
            child: Center(child: CircularProgressIndicator()),
          );
        } else {
          return widget.child;
        }
      },
    );
  }
}
