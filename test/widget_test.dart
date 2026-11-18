import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soap_factory/application/workspace_controller.dart';
import 'package:soap_factory/ui/app.dart';
import 'package:soap_factory/domain/workspace.dart';

import 'controller_test.dart' show MemoryRepository;

void main() {
  testWidgets(
    'mobile: empty workspace, example, scale validation, history and language',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final c = WorkspaceController(MemoryRepository());
      await c.load();
      await tester.pumpWidget(SoapFactoryApp(controller: c));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text('Carregar exemplo'), 250);
      await tester.tap(find.text('Carregar exemplo'));
      await tester.pumpAndSettle();
      expect(c.state.ingredients.length, 2);
      await tester.tap(find.byType(NavigationDestination).at(2));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Dimensionar lote'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextField, 'Multiplicador do lote'),
        '0',
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Registrar lote'),
            )
            .onPressed,
        isNull,
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Multiplicador do lote'),
        '1,5',
      );
      await tester.pumpAndSettle();
      expect(find.text('R\$ 60.00 / lote'), findsOneWidget);
      await tester.tap(find.text('Registrar lote'));
      await tester.pumpAndSettle();
      expect(c.state.batches.single.result.outputCount, 15);
      await tester.tap(find.byType(NavigationDestination).at(4));
      await tester.pumpAndSettle();
      expect(find.text('R\$ 60.00'), findsOneWidget);
      await tester.tap(find.byTooltip('English (United Kingdom)'));
      await tester.pumpAndSettle();
      expect(find.text('History'), findsNWidgets(2));
      expect(c.state.batches.length, 1);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'desktop: ingredient and formula creation, guarded delete and editing',
    (tester) async {
      tester.view.physicalSize = const Size(1440, 1100);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final c = WorkspaceController(MemoryRepository());
      await c.load();
      await tester.pumpWidget(SoapFactoryApp(controller: c));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ingredientes').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Novo ingrediente'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nome'),
        'Base',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Quantidade por embalagem'),
        '1000',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Preço da embalagem (BRL)'),
        '32',
      );
      await tester.tap(find.text('Salvar ingrediente'));
      await tester.pumpAndSettle();
      expect(c.state.ingredients.length, 1);
      await tester.tap(find.text('Fórmulas').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Nova fórmula'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nome da fórmula'),
        'Study',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nome do produto'),
        'Bar',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Quantidade no lote'),
        '1000',
      );
      await tester.tap(find.text('Salvar fórmula'));
      await tester.pumpAndSettle();
      expect(c.state.formulas.length, 1);
      await tester.tap(find.byTooltip('Editar fórmula'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nome do produto'),
        'New bar',
      );
      await tester.tap(find.text('Salvar fórmula'));
      await tester.pumpAndSettle();
      expect(c.state.formulas.single.product, 'New bar');
      await tester.tap(find.text('Ingredientes').first);
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Excluir ingrediente'));
      await tester.pumpAndSettle();
      expect(c.state.ingredients.length, 1);
      expect(
        find.textContaining('Este ingrediente está em uso'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('corrupt storage shows recovery state, without fake data', (
    tester,
  ) async {
    final repository = MemoryRepository()..document = 'bad';
    final c = WorkspaceController(repository);
    await c.load();
    await tester.pumpWidget(SoapFactoryApp(controller: c));
    await tester.pumpAndSettle();
    expect(find.text('Não foi possível abrir os dados'), findsOneWidget);
    expect(find.text('Tentar novamente'), findsOneWidget);
    expect(c.state.ingredients, isEmpty);
  });
  testWidgets(
    'backup restore validates before replacing and supports recovery',
    (tester) async {
      final repository = MemoryRepository()..document = 'corrupt';
      final c = WorkspaceController(repository);
      await c.load();
      await tester.pumpWidget(SoapFactoryApp(controller: c));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Restaurar backup'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'invalid');
      await tester.tap(find.text('Restaurar…'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Backup inválido'), findsOneWidget);
      expect(repository.document, 'corrupt');
      await tester.enterText(
        find.byType(TextField),
        Workspace.example().encode(),
      );
      await tester.tap(find.text('Restaurar…'));
      await tester.pumpAndSettle();
      expect(find.text('Substituir todos os dados?'), findsOneWidget);
      expect(repository.document, 'corrupt');
      await tester.tap(find.text('Substituir'));
      await tester.pumpAndSettle();
      expect(c.error, isNull);
      expect(c.state.ingredients.length, 2);
      expect(
        Workspace.decode(repository.document!).formulas.single.yieldCount,
        10,
      );
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('narrow screen supports larger text and labelled touch targets', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final c = WorkspaceController(MemoryRepository());
    await c.load();
    await tester.pumpWidget(SoapFactoryApp(controller: c));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Carregar exemplo'), 250);
    final semantics = tester.ensureSemantics();
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    semantics.dispose();
  });
}
