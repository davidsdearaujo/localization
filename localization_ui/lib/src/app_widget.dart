import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

import 'home/domain/services/file_service.dart';
import 'home/domain/usecases/read_json.dart';
import 'home/domain/usecases/save_json.dart';
import 'home/infra/services/file_service.dart';
import 'home/presenter/home_page.dart';
import 'home/presenter/stores/file_store.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FileService>(create: (context) => FileServiceImpl()),
        Provider<ReadJson>(create: (context) => ReadJsonImpl(context.read())),
        Provider<SaveJson>(create: (context) => SaveJsonImpl(context.read())),
        ChangeNotifierProvider(create: (context) => FileStore(context.read(), context.read())),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        locale: Locale('es'),
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          LocalJsonLocalization.delegate,
        ],
        supportedLocales: [
          Locale('en', ''),
          Locale('es', ''),
          Locale('pt', ''),
        ],
        home: HomePage(),
      ),
    );
  }
}
