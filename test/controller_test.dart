import 'package:flutter_test/flutter_test.dart';
import 'package:soap_factory/application/workspace_controller.dart';
import 'package:soap_factory/data/workspace_repository.dart';
import 'package:soap_factory/domain/workspace.dart';

class MemoryRepository implements WorkspaceRepository {
  String? document;
  bool fail = false;
  @override
  Future<Workspace> load() async {
    if (fail) throw StateError('Unavailable');
    return document == null ? Workspace() : Workspace.decode(document!);
  }

  @override
  Future<void> save(Workspace state) async {
    if (fail) throw StateError('Quota exceeded');
    document = state.encode();
  }
}

void main() {
  test(
    'save, reload, language changes and history preserve the workspace',
    () async {
      final repository = MemoryRepository();
      final c = WorkspaceController(repository);
      await c.load();
      await c.replace(Workspace.example());
      await c.recordBatch(c.state.formulas.single, 1500);
      expect(c.state.batches.single.result.totalCents, 6000);
      await c.replace(c.state.copy(portuguese: false));
      final next = WorkspaceController(repository);
      await next.load();
      expect(next.state.portuguese, isFalse);
      expect(next.state.ingredients.length, 2);
      expect(next.state.batches.single.result.outputCount, 15);
      final i = next.state.ingredients.first;
      await next.saveIngredient(
        Ingredient(
          id: i.id,
          name: 'New price',
          unit: i.unit,
          packageQuantity: i.packageQuantity,
          priceCents: 6400,
        ),
      );
      expect(next.state.batches.single.result.totalCents, 6000);
      expect(
        calculate(
          next.state.formulas.single,
          next.state.ingredients,
          1000,
        ).totalCents,
        7200,
      );
      await next.deleteFormula(next.state.formulas.single.id);
      expect(next.state.batches.length, 1);
      await next.deleteIngredient(i.id);
      expect(next.state.ingredients.length, 1);
    },
  );
  test(
    'failed writes keep previous data; failed loads prevent overwrite',
    () async {
      final repository = MemoryRepository();
      final c = WorkspaceController(repository);
      await c.load();
      await c.replace(Workspace.example());
      repository.fail = true;
      await expectLater(c.replace(Workspace()), throwsStateError);
      expect(c.state.ingredients.length, 2);
      expect(c.saving, isFalse);
      final other = WorkspaceController(repository);
      await other.load();
      expect(other.error, 'load');
      await expectLater(other.replace(Workspace()), throwsStateError);
    },
  );
  test(
    'used ingredients and incompatible unit edits cannot invalidate formulas',
    () async {
      final c = WorkspaceController(MemoryRepository());
      await c.load();
      await c.replace(Workspace.example());
      expect(() => c.deleteIngredient('base'), throwsFormatException);
      expect(
        () => c.saveIngredient(
          Ingredient(
            id: 'base',
            name: 'Base',
            unit: Measure.l,
            packageQuantity: 1000,
            priceCents: 1000,
          ),
        ),
        throwsFormatException,
      );
      expect(c.state.ingredients.first.unit, Measure.kg);
    },
  );
  test('backup validation rejects dangling references, duplicate IDs and fractional counts', () {
    final original = Workspace.example().encode();
    expect(
      () => Workspace.decode(
        original.replaceFirst('"ingredient":"base"', '"ingredient":"missing"'),
      ),
      throwsFormatException,
    );
    expect(
      () =>
          Workspace.decode(original.replaceFirst('"id":"wrap"', '"id":"base"')),
      throwsFormatException,
    );
    expect(
      () => FormulaLine('wrap', Measure.piece, 1500),
      throwsFormatException,
    );
  });
}
