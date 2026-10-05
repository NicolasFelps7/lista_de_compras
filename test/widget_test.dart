import 'package:flutter_test/flutter_test.dart';
import 'package:lista_de_compras/main.dart';

void main() {
  testWidgets(
    'Teste Lista de Compras',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MeuApp());

      expect(
        find.text('Lista de Compras'),
        findsOneWidget,
      );

      expect(
        find.text('Sua lista está vazia'),
        findsOneWidget,
      );

      expect(
        find.text('Novo item'),
        findsOneWidget,
      );
    },
  );
}