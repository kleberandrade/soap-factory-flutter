import 'package:flutter_test/flutter_test.dart';
import 'package:soap_factory/domain/workspace.dart';

void main() {
  final oil = Ingredient(
    id: 'oil',
    name: 'Oil',
    unit: Measure.kg,
    packageQuantity: 1000,
    priceCents: 2050,
  );
  final recipe = Formula(
    id: 'f',
    name: 'Sample',
    product: 'Bar',
    yieldCount: 10,
    lines: [FormulaLine('oil', Measure.g, 500000)],
  );
  test('unit conversion and half-up rounding are exact', () {
    expect(parseQuantity('1,250'), 1250);
    expect(Measure.kg.toBase(1250), 1250000);
    expect(roundRatio(1, 2), 1);
    expect(roundRatio(1000000000000, 3), 333333333333);
  });
  test('cost and scale use package quantities, not unit labels', () {
    final result = calculate(recipe, [oil], 1500);
    expect(result.lines.single.quantity, 750000);
    expect(result.totalCents, 1538);
    expect(result.outputCount, 15);
    expect(result.unitCostCents, 103);
  });
  test('incompatible units and missing ingredients are rejected', () {
    final wrong = Formula(
      id: 'bad',
      name: 'Bad',
      product: 'Bar',
      yieldCount: 1,
      lines: [FormulaLine('oil', Measure.ml, 1000)],
    );
    expect(() => calculate(wrong, [oil], 1000), throwsFormatException);
    expect(() => calculate(recipe, [], 1000), throwsFormatException);
  });
  test(
    'invalid quantities, nonfinite input and excess precision are rejected',
    () {
      for (final value in [
        '0',
        '-1',
        'NaN',
        'Infinity',
        '1.0001',
        '1,2.3',
        '1000001',
      ]) {
        expect(
          () => parseQuantity(value),
          throwsFormatException,
          reason: value,
        );
      }
      expect(() => calculate(recipe, [oil], 0), throwsFormatException);
      expect(
        () => Ingredient(
          id: 'x',
          name: '',
          unit: Measure.g,
          packageQuantity: 1000,
          priceCents: -1,
        ),
        throwsFormatException,
      );
      expect(
        () =>
            Formula(id: 'x', name: 'x', product: 'x', yieldCount: 0, lines: []),
        throwsFormatException,
      );
    },
  );
  test('batch snapshot survives ingredient changes and JSON round trip', () {
    final batch = Batch(
      id: 'b',
      date: DateTime.utc(2026, 11, 17),
      formulaName: recipe.name,
      product: recipe.product,
      result: calculate(recipe, [oil], 1000),
    );
    final state = Workspace(
      ingredients: [oil],
      formulas: [recipe],
      batches: [batch],
    );
    final restored = Workspace.decode(state.encode());
    expect(restored.batches.single.result.totalCents, 1025);
    expect(restored.batches.single.result.lines.single.name, 'Oil');
    expect(restored.batches.single.date, batch.date);
    expect(() => Workspace.decode('{"schema":99}'), throwsFormatException);
    expect(() => Workspace.decode('broken'), throwsFormatException);
  });
  test(
    'small scale that erases a quantity or yields fractions is rejected',
    () {
      expect(() => calculate(recipe, [oil], 1), throwsFormatException);
      final tiny = Formula(
        id: 't',
        name: 'Tiny',
        product: 'x',
        yieldCount: 1000,
        lines: [FormulaLine('oil', Measure.g, 1)],
      );
      expect(() => calculate(tiny, [oil], 1), throwsFormatException);
    },
  );
}
