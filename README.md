# Localization

Package para simplificar tradução no app.

```dart
import 'package:localization/localization.dart';
```

## Configuração - Sem sistema de rotas   [[exemplo]](https://github.com/davidsdearaujo/localization/blob/master/example/README.md)

A configuração do package sem sistema de rotas é bem simples, basta colocar após o MaterialApp o seguinte código:

```dart
return MaterialApp(
  ...,
  home: LocalizationWidget(child: MyHomePage()),
);
```

Dessa forma, será carregado o arquivo de tradução no início da aplicação e seu conteúdo ficará em memória.

## Configuração - Com sistema de rotas   [[exemplo]](https://github.com/davidsdearaujo/localization/blob/master/example/README.md)

Quando a aplicação está utilizando o sistema de rotas do flutter, não é utilizada a propriedade `home` do `MaterialApp`.
Para resolver esse problema, utilize o método assíncrono estático `Localization.configuration()`.

**NOTA :** Esse método deve ser chamado antes de todas as chamadas de tradução. Geralmente, é executado na SplashScreen.

## Adicionando pastas de tradução (padrão `'assets/lang'`)
Para configurar uma lista de pastas de tradução, basta utilizar o método:
```dart
Localization.setTranslationDirectories([
  'assets/lang',
  'packages/package_example/assets/lang',
]);
```

Para adicionar uma pasta de tradução sem limpar as pastas de tradução incluídas anteriormente, basta chamar o método 
```dart
Localization.includeTranslationDirectory('assets/lang');
```

**NOTA :** Para as alterações de pasta surtirem efeito, deve chamar a seguir o método `Localization.configuration()`

## Consumindo a tradução

Para facilitar o consumo da tradução, criamos uma extension de simples utilização:

```dart
"sua-key".i18n();
```

Caso prefira, pode utilizar a tradução sem as extensions:
```dart
Localization.translate("sua-key");
```

## Definindo um idioma manualmente

Por padrão, o idioma é selecionado pela configuração `window.locale` do package `dart:ui`.
Para forçar um determinado idioma, basta utilizar o parâmetro `selectedLanguage`, dessa forma:

```dart
Localization.configuration(selectedLanguage: 'pt_BR');
```

Se os arquivos de tradução não forem encontrados, será carregado o arquivo de traduções informado em `defaultLanguage` _(padrão `pt_BR.json`)_.

Para saber qual o idioma que o dispositivo está chamando, basta importar o `dart:ui` dar um print de `window.locale`, dessa forma:

**main.dart**

```dart
import 'dart:ui';

void main(){
  print(window.locale.toString());
  runApp(MyApp());
}
```

## Parâmetros

Para enviar parâmetros para a tradução, utilize a chave `%s`, conforme o exemplo:

### No arquivo de tradução:

```json
{
  "birthday":"O aniversário de %s é no dia %s"
}
```

### No arquivo dart:

```dart
"birthday".i18n(["David Araujo", "07/03"]);
```

## Condições

Para enviar condições para a tradução, utilize a chave `%b{valor_verdadeiro:valor_falso}`, conforme o exemplo:

### No arquivo de tradução:

```json
{
  "resultado_encontrado": "%s %b{Resultados:Resultado} %b{encontrados:encontrado}"
}
```

### No arquivo dart:

```dart
'resultado_encontrado'.i18n([3], [true, true])
```

## Repetição de chaves
Quando houver repetição nas chaves, será enviada uma mensagem no log informando a chave que está duplicada:

```
flutter: [Localization System] Duplicated Key: "password-label" Path: "packages/package_example/assets/lang"
flutter: [Localization System] Carregadas keys do path packages/package_example/assets/lang
```
## Automação

Criamos uma automação que gera as chaves e suas traduções no [Slidy CLI](https://pub.dev/packages/slidy), basta utilizar o comando `slidy localization`
