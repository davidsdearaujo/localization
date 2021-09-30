import 'package:flutter_test/flutter_test.dart';

import 'package:localization/src/extension.dart';

void main() {
  group('Teste de Translate', () {
    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });
    test('''
    Dado a chave de tradução
    Quando não tiver sido carregado ainda o arquivo de tradução
    Então lançar excessão
  ''', () async {
      var result = () => Localization.translate('teste');
      expect(
          result,
          throwsA(
              '[Localization System] Nenhuma chave de tradução encontrada. Tente executar o método Localization.configuration() antes de buscar alguma tradução.'));
    });
  });
  group('Teste da configuração', () {
    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });
    test('''
    Dado carregamento de traduções
    Quando não informado o diretorio
    Então lançar excessão
  ''', () async {
      var result = () async => await Localization.configuration();
      expect(
          result,
          throwsA(
              '[Localization System] Execute o método "Localization.includeTranslationDirectory()'));
    });

    test('''
    Dado carregamento de traduções
    Quando o diretorio existe
    Então deve Carregar traduções
  ''', () async {
      Localization.setTranslationDirectories([
        'test/assets/unexist',
      ]);
      await Localization.configuration();
      expect(Localization.sentences, isEmpty);
    });

    test('''
    Dado carregamento de traduções
    Quando o diretorio existe
    Então deve Carregar traduções
  ''', () async {
      Localization.setTranslationDirectories([
        'test/assets/lang',
      ]);
      await Localization.configuration();
      var json = Localization.toJson();
      expect(Localization.sentences, isNotEmpty);
      expect(json, isNotNull);
    });

    test('''
    Dado carregamento de traduções
    Quando a linguagem selecionada não existir
    Então deve Carregar a linguagem padrão pt_BR
  ''', () async {
      Localization.setTranslationDirectories([
        'test/assets/lang',
      ]);
      await Localization.configuration(selectedLanguage: 'es_ES');
      var json = Localization.toJson();
      expect(Localization.sentences, isNotEmpty);
      expect(json, isNotNull);
    });

    test('''
    Dado carregamento de traduções
    Quando Solicitado a adição de mais diretorios de tradução
    Então deve conter mais que um diretorio
  ''', () async {
      Localization.setTranslationDirectories([
        'test/assets/lang',
      ]);
      // ignore: deprecated_member_use_from_same_package
      await Localization.configuration(translationLocale: 'test/assets/lang2');
      var json = Localization.toJson();
      expect(Localization.sentences, isNotEmpty);
      expect(json, isNotNull);
      expect(Localization.translationLocales?.length ?? 0, greaterThan(1));
    });

    test('''
    Dado carregamento de traduções
    Quando Solicitado a adição de mais diretorios de tradução
    Então deve conter mais que um diretorio
  ''', () async {
      Localization.translationLocales = null;
      Localization.includeTranslationDirectory('test/assets/lang2');

      expect(Localization.translationLocales?.length ?? 0, greaterThan(0));
    });
  });

  group('Teste de condicionais da extensão i18n', () {
    setUp(() {
      Localization.fromJson({
        'testeQuantidade':
            '%s %b{Resultados:Resultado} %b{encontrados:encontrado}',
      });
    });

    test('''
    Dado a localização de uma determinada chave
    Quando não houver nenhuma condicional na chave
    Então deve lançar uma excess~~ao
  ''', () {
      Localization.fromJson({
        'testeQuantidade': '%s Resultados encontrado',
      });

      var result = () => Localization.translate(
            'testeQuantidade',
            args: ['1'],
            conditions: [true, true, true],
          );
      expect(
          result,
          throwsA(
              '[Localization System] A Quantidade de condicionais configurada na chave não condiz com os parametros.'));
    });

    test('''
    Dado a localização de uma determinada chave
    Quando o valor for maior que 1
    Então deve retornar as condicionais no plural
  ''', () {
      var quantidade = 3;

      var result = Localization.translate(
        'testeQuantidade',
        args: [quantidade.toString()],
        conditions: [quantidade > 1, quantidade > 1],
      );
      expect(result, '3 Resultados encontrados');
    });

    test('''
    Dado a localização de uma determinada chave
    Quando o valor for igual a 1
    Então deve retornar  as condicionais no singular
  ''', () {
      var quantidade = 1;

      var result = 'testeQuantidade'.i18n(
        args: [quantidade.toString()],
        conditions: [quantidade > 1, quantidade > 1],
      );
      expect(result, '1 Resultado encontrado');
    });
    test('''
    Dado a localização de uma determinada chave
    Quando a quantidade de condições de parametros é inferior a quantidade de condições da chave
    Então deve lançar uma excessão
  ''', () {
      var result = () => Localization.translate(
            'testeQuantidade',
            args: ['1'],
            conditions: [true],
          );
      expect(
          result,
          throwsA(
              '[Localization System] A Quantidade de condicionais configurada na chave não condiz com os parametros.'));
    });

    test('''
    Dado a localização de uma determinada chave
    Quando a quantidade de condições de parametros é superior a quantidade de condições da chave
    Então deve lançar uma excessão
  ''', () {
      var result = () => Localization.translate(
            'testeQuantidade',
            args: ['1'],
            conditions: [true, true, true],
          );
      expect(
          result,
          throwsA(
              '[Localization System] A Quantidade de condicionais configurada na chave não condiz com os parametros.'));
    });
  });
}
