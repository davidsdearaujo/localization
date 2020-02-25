# localization

Package para simplificar tradução no app.


## Configuração

A configuração do package é bem simples, basta colocar após o MaterialApp o seguinte código:
```dart
return MaterialApp(
  ...,
  home: LocalizationWidget(child: MyHomePage()),
);
```

Dessa forma, será carregado o arquivo de tradução e seu conteúdo ficará em memória.



## Getting Started

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
