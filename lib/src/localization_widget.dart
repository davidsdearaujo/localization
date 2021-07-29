import 'dart:async';

import 'package:flutter/material.dart';

import 'extension.dart';

class LocalizationWidget extends StatefulWidget {
  @deprecated
  final String? translationLocale;
  final String defaultLang;
  final Widget child;
  final String? selectedLanguage;
  final List<String> translationLocales;

  LocalizationWidget({
    Key? key,
    @deprecated this.translationLocale,
    this.defaultLang = "pt_BR",
    required this.child,
    this.selectedLanguage,
    this.translationLocales = const ["assets/lang"],
  }) : super(key: key);

  @override
  _LocalizationWidgetState createState() => _LocalizationWidgetState();
}

class _LocalizationWidgetState extends State<LocalizationWidget> {
  late Future<void> future;
  late Timer timeoutTimer;

  @override
  void initState() {
    super.initState();
    widget.translationLocales.forEach((locale) => Localization.includeTranslationDirectory(locale));
    future = Localization.configuration(
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
        if (snapshot.connectionState != ConnectionState.done || timeoutTimer.isActive) {
          return Material(child: Center(child: CircularProgressIndicator()));
        } else {
          return widget.child;
        }
      },
    );
  }
}
