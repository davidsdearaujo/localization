import 'package:flutter_test/flutter_test.dart';

import 'package:localization/src/extension.dart';

void main() {
  setUp(() {
    Localization.fromJson({
      'testeQuantidade': '%s %b{Resultados:Resultado} %b{encontrados:encontrado}',
    });
  });
  group('Teste de condicionais da extensão i18n', () {
    test('''
    Dado a localização de uma determinada chave
    Quando o valor for maior que 1
    Deve imprimir as condicionais no plural
  ''', () {
      var quantidade = 3;

      var result = 'testeQuantidade'.i18n(
        [quantidade.toString()],
        [quantidade > 1, quantidade > 1],
      );
      var result2 = Localization.translate(
        'testeQuantidade',
        [quantidade.toString()],
        [quantidade > 1, quantidade > 1],
      );
      expect(result, '3 Resultados encontrados');
      expect(result2, '3 Resultados encontrados');
    });

    test('''
    Dado a localização de uma determinada chave
    Quando o valor for igual a 1
    Deve imprimir as condicionais no singular
  ''', () {
      var quantidade = 1;

      var result = 'testeQuantidade'.i18n(
        [quantidade.toString()],
        [quantidade > 1, quantidade > 1],
      );

      var result2 = Localization.translate(
        'testeQuantidade',
        [quantidade.toString()],
        [quantidade > 1, quantidade > 1],
      );
      expect(result, '1 Resultado encontrado');
      expect(result2, '1 Resultado encontrado');
    });
  });
}
