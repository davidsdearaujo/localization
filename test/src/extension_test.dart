import 'package:flutter_test/flutter_test.dart';

import 'package:localization/src/extension.dart';

void main() {
  group('Teste de da configuração', () {
    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });
    test('''
    Dado diretorio de tradução
    Quando não informado o diretorio
    Deve Carregar traduções
  ''', () async {
      var result = () async => await Localization.configuration();
      expect(result, throwsA('[Localization System] Execute o método "Localization.includeTranslationDirectory()'));
    });
  
    test('''
    Dado diretorio de tradução
    Quando o diretorio existe
    Deve Carregar traduções
  ''', () async {
      Localization.setTranslationDirectories([
        'test/assets/lang',
      ]);
      await Localization.configuration();
      expect(Localization.sentences, isNotEmpty);
    });
  });

  group('Teste de condicionais da extensão i18n', () {
    setUp(() {
      Localization.fromJson({
        'testeQuantidade': '%s %b{Resultados:Resultado} %b{encontrados:encontrado}',
      });
    });

    test('''
    Dado a localização de uma determinada chave
    Quando o valor for maior que 1
    Deve imprimir as condicionais no plural
  ''', () {
      var quantidade = 3;

      var result = Localization.translate(
        'testeQuantidade',
        [quantidade.toString()],
        [quantidade > 1, quantidade > 1],
      );
      expect(result, '3 Resultados encontrados');
    });

    test('''
    Dado a localização de uma determinada chave
    Quando o valor for igual a 1
    Deve imprimir as condicionais no singular
  ''', () {
      var quantidade = 1;

      var result = Localization.translate(
        'testeQuantidade',
        [quantidade.toString()],
        [quantidade > 1, quantidade > 1],
      );
      expect(result, '1 Resultado encontrado');
    });
    test('''
    Dado a localização de uma determinada chave
    Quando a quantidade de condições de parametros é inferior a quantidade de condições da chave
    Deve Lançar uma excessão
  ''', () {
      var result = () => Localization.translate('testeQuantidade', ['1'], [true]);
      expect(result, throwsA('[Localization System] A Quantidade de condicionais configurada na chave não condiz com os parametros.'));
    });
    test('''
    Dado a localização de uma determinada chave
    Quando a quantidade de condições de parametros é superior a quantidade de condições da chave
    Deve Lançar uma excessão
  ''', () {
      var result = () => Localization.translate('testeQuantidade', ['1'], [true, true, true]);
      expect(result, throwsA('[Localization System] A Quantidade de condicionais configurada na chave não condiz com os parametros.'));
    });
  });
}
