import 'package:flutter/material.dart';
import 'package:localization_ui/home/domain/services/file_service.dart';
import 'package:localization_ui/home/domain/usecases/read_json.dart';
import 'package:localization_ui/home/presenter/stores/file_store.dart';
import 'package:provider/provider.dart';

import 'home/domain/usecases/save_json.dart';
import 'home/infra/services/file_service.dart';
import 'home/presenter/home_page.dart';

void main() {
  runApp(MyApp());
}

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
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      ),
    );
  }
}
