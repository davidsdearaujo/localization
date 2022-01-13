## [1.1.2-dev.1] 2022-01-13
Adicionado suporte a arquivos de tradução com apenas a língua, como por exemplo `pt.json`;

```dart
await Localization.configuration(showDebugPrintMode: false);
```

## [1.1.1] 2021-11-22
deixar Log ocional, para desativa-lo basta utilizar

```dart
await Localization.configuration(showDebugPrintMode: false);
```

Você também pode setar a variavel chamando a função
```dart
Localization.setShowDebugPrintMode(false);
```

## [1.1.0] 2021-8-29

* BREAK CHANGE: Os parâmetros do método `'welcome'.i18n(["22/06"])` e `Localization.translate('welcome', ["22/06"])` estão nomeados
* BREAK CHANGE: Use `"welcome".i18n(args: ["22/06"])` ao invés de `"welcome".i18n(["22/06"])`
* BREAK CHANGE: Use `Localization.translate('welcome', args: ["22/06"])` ao invés de `Localization.translate('welcome', ["22/06"])`
### New features
* Adição de possibilidade de usar condicionais utilize o `%b{condicao_verdadeira:condição_falsa}` para configurar as suas traduções
```json
{
	'quantidade':  '%s %b{Resultados:Resultado} %b{encontrados:encontrado}'
}
```
Será necessário na parâmetro `conditions` passar uma lista de Booleanos de forma posicional
```dart
Localization.translate(
	'testeQuantidade',
	args: ['2'],
	conditions: [true, true],
)
```

```dart
'testeQuantidade'.i18n(
	args: ['1'],
	conditions: [false, false],
)
```

## [1.0.0] 2021-07-28

* Use Text("welcome".i18n(args: ["22/06"])), ao inves de Text("welcome".i18n(["22/06"])),
## [1.0.0] 2021-07-28

* Adicionada possibilidade de multiplos diretórios de tradução;

## [0.2.0-nullsafety] 2021-03-01

* Migração Nullsafety;

## [0.1.0] 2020-06-11

* Atualizado README;
* Adicionada automação no [SLIDY CLI](https://pub.dev/packages/slidy);

## [0.0.2] 2020-02-25

* Initial release.
