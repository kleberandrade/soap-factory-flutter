import 'dart:convert';

const maxValue = 1000000000;

void require(bool condition, String message) {
  if (!condition) throw FormatException(message);
}

String label(String value) {
  final text = value.trim();
  require(text.isNotEmpty && text.length <= 100, 'Use 1–100 characters.');
  return text;
}

/// Parses up to three decimal places, without binary floating-point arithmetic.
int parseQuantity(String text) {
  final value = text.trim().replaceAll(',', '.');
  require(
    RegExp(r'^\d{1,7}(\.\d{1,3})?$').hasMatch(value),
    'Use a positive number with up to 3 decimals.',
  );
  final parts = value.split('.');
  final result =
      int.parse(parts[0]) * 1000 +
      (parts.length == 2 ? int.parse(parts[1].padRight(3, '0')) : 0);
  require(
    result > 0 && result <= maxValue,
    'Quantity must be > 0 and ≤ 1,000,000.',
  );
  return result;
}

int parseMoney(String text) {
  final value = text.trim().replaceAll(',', '.');
  require(
    RegExp(r'^\d{1,7}(\.\d{1,2})?$').hasMatch(value),
    'Use a nonnegative price with up to 2 decimals.',
  );
  final parts = value.split('.');
  return int.parse(parts[0]) * 100 +
      (parts.length == 2 ? int.parse(parts[1].padRight(2, '0')) : 0);
}

String decimal(int thousandths) {
  final whole = thousandths ~/ 1000;
  final fraction = (thousandths % 1000).toString().padLeft(3, '0');
  return fraction == '000'
      ? '$whole'
      : '$whole.${fraction.replaceFirst(RegExp(r'0+$'), '')}';
}

String money(int cents) => 'R\$ ${(cents / 100).toStringAsFixed(2)}';

int roundRatio(int numerator, int denominator) {
  require(numerator >= 0 && denominator > 0, 'Invalid ratio.');
  return ((BigInt.from(numerator) * BigInt.two + BigInt.from(denominator)) ~/
          (BigInt.from(denominator) * BigInt.two))
      .toInt();
}

int multiplyRatio(int value, int numerator, int denominator) {
  require(value >= 0 && numerator >= 0 && denominator > 0, 'Invalid ratio.');
  final n = BigInt.from(value) * BigInt.from(numerator);
  return ((n * BigInt.two + BigInt.from(denominator)) ~/
          (BigInt.from(denominator) * BigInt.two))
      .toInt();
}

enum Measure {
  g('g', 'mass', 1),
  kg('kg', 'mass', 1000),
  ml('mL', 'volume', 1),
  l('L', 'volume', 1000),
  piece('un', 'count', 1);

  const Measure(this.symbol, this.dimension, this.factor);
  final String symbol;
  final String dimension;
  final int factor;
  int toBase(int quantity) => quantity * factor;
}

class Ingredient {
  Ingredient({
    required this.id,
    required String name,
    required this.unit,
    required this.packageQuantity,
    required this.priceCents,
  }) : name = label(name) {
    label(id);
    require(
      packageQuantity > 0 && packageQuantity <= maxValue,
      'Invalid package quantity.',
    );
    require(priceCents >= 0 && priceCents <= maxValue, 'Invalid price.');
    require(
      unit != Measure.piece || packageQuantity % 1000 == 0,
      'Use whole units.',
    );
  }
  final String id, name;
  final Measure unit;
  final int packageQuantity, priceCents;
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'unit': unit.name,
    'quantity': packageQuantity,
    'price': priceCents,
  };
  factory Ingredient.fromJson(Map<String, dynamic> j) => Ingredient(
    id: j['id'] as String,
    name: j['name'] as String,
    unit: Measure.values.byName(j['unit'] as String),
    packageQuantity: j['quantity'] as int,
    priceCents: j['price'] as int,
  );
}

class FormulaLine {
  FormulaLine(this.ingredientId, this.unit, this.quantity) {
    label(ingredientId);
    require(quantity > 0 && quantity <= maxValue, 'Invalid line quantity.');
    require(unit != Measure.piece || quantity % 1000 == 0, 'Use whole units.');
  }
  final String ingredientId;
  final Measure unit;
  final int quantity;
  Map<String, dynamic> toJson() => {
    'ingredient': ingredientId,
    'unit': unit.name,
    'quantity': quantity,
  };
  factory FormulaLine.fromJson(Map<String, dynamic> j) => FormulaLine(
    j['ingredient'] as String,
    Measure.values.byName(j['unit'] as String),
    j['quantity'] as int,
  );
}

class Formula {
  Formula({
    required this.id,
    required String name,
    required String product,
    required this.yieldCount,
    required List<FormulaLine> lines,
  }) : name = label(name),
       product = label(product),
       lines = List.unmodifiable(lines) {
    label(id);
    require(
      yieldCount > 0 && yieldCount <= 1000000,
      'Use 1–1,000,000 whole products.',
    );
    require(lines.isNotEmpty && lines.length <= 100, 'Use 1–100 ingredients.');
    require(
      lines.map((l) => l.ingredientId).toSet().length == lines.length,
      'Duplicate ingredient.',
    );
  }
  final String id, name, product;
  final int yieldCount;
  final List<FormulaLine> lines;
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'product': product,
    'yield': yieldCount,
    'lines': lines.map((l) => l.toJson()).toList(),
  };
  factory Formula.fromJson(Map<String, dynamic> j) => Formula(
    id: j['id'] as String,
    name: j['name'] as String,
    product: j['product'] as String,
    yieldCount: j['yield'] as int,
    lines: (j['lines'] as List)
        .map((l) => FormulaLine.fromJson(l as Map<String, dynamic>))
        .toList(),
  );
}

class CostLine {
  CostLine({
    required this.name,
    required this.unit,
    required this.quantity,
    required this.cents,
  });
  final String name;
  final Measure unit;
  final int quantity, cents;
  Map<String, dynamic> toJson() => {
    'name': name,
    'unit': unit.name,
    'quantity': quantity,
    'cents': cents,
  };
  factory CostLine.fromJson(Map<String, dynamic> j) {
    final unit = Measure.values.byName(j['unit'] as String);
    final quantity = j['quantity'] as int;
    final cents = j['cents'] as int;
    require(
      quantity > 0 && quantity <= maxValue && cents >= 0 && cents <= maxValue,
      'Invalid snapshot.',
    );
    require(unit != Measure.piece || quantity % 1000 == 0, 'Invalid count.');
    return CostLine(
      name: label(j['name'] as String),
      unit: unit,
      quantity: quantity,
      cents: cents,
    );
  }
}

class CostResult {
  CostResult({
    required List<CostLine> lines,
    required this.outputCount,
    required this.multiplier,
  }) : lines = List.unmodifiable(lines);
  final List<CostLine> lines;
  final int outputCount, multiplier;
  int get totalCents => lines.fold(0, (sum, l) => sum + l.cents);
  int get unitCostCents => roundRatio(totalCents, outputCount);
  Map<String, dynamic> toJson() => {
    'lines': lines.map((l) => l.toJson()).toList(),
    'output': outputCount,
    'multiplier': multiplier,
  };
  factory CostResult.fromJson(Map<String, dynamic> j) {
    final output = j['output'] as int;
    final multiplier = j['multiplier'] as int;
    final lines = (j['lines'] as List)
        .map((l) => CostLine.fromJson(l as Map<String, dynamic>))
        .toList();
    require(
      output > 0 &&
          output <= 1000000 &&
          multiplier > 0 &&
          multiplier <= 1000000 &&
          lines.isNotEmpty &&
          lines.length <= 100,
      'Invalid snapshot.',
    );
    return CostResult(
      lines: lines,
      outputCount: output,
      multiplier: multiplier,
    );
  }
}

CostResult calculate(
  Formula formula,
  List<Ingredient> ingredients,
  int multiplier,
) {
  require(
    multiplier > 0 && multiplier <= 1000000,
    'Scale must be > 0 and ≤ 1,000.',
  );
  final output = formula.yieldCount * multiplier;
  require(
    output % 1000 == 0 && output ~/ 1000 <= 1000000,
    'Scale must produce a whole number of products (≤ 1,000,000).',
  );
  final byId = {
    for (final ingredient in ingredients) ingredient.id: ingredient,
  };
  final lines = formula.lines.map((line) {
    final ingredient = byId[line.ingredientId];
    require(ingredient != null, 'Ingredient no longer exists.');
    require(
      ingredient!.unit.dimension == line.unit.dimension,
      'Incompatible units.',
    );
    final quantity = multiplyRatio(line.quantity, multiplier, 1000);
    require(
      quantity > 0 && quantity <= maxValue,
      'Scaled quantity is outside supported limits.',
    );
    require(
      line.unit != Measure.piece || quantity % 1000 == 0,
      'Scale must use whole units.',
    );
    final cents = multiplyRatio(
      ingredient.priceCents,
      line.unit.toBase(quantity),
      ingredient.unit.toBase(ingredient.packageQuantity),
    );
    require(cents <= maxValue, 'Cost is outside supported limits.');
    return CostLine(
      name: ingredient.name,
      unit: line.unit,
      quantity: quantity,
      cents: cents,
    );
  }).toList();
  return CostResult(
    lines: lines,
    outputCount: output ~/ 1000,
    multiplier: multiplier,
  );
}

class Batch {
  Batch({
    required this.id,
    required this.date,
    required String formulaName,
    required String product,
    required this.result,
  }) : formulaName = label(formulaName),
       product = label(product) {
    label(id);
  }
  final String id, formulaName, product;
  final DateTime date;
  final CostResult result;
  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'formula': formulaName,
    'product': product,
    'result': result.toJson(),
  };
  factory Batch.fromJson(Map<String, dynamic> j) => Batch(
    id: j['id'] as String,
    date: DateTime.parse(j['date'] as String),
    formulaName: j['formula'] as String,
    product: j['product'] as String,
    result: CostResult.fromJson(j['result'] as Map<String, dynamic>),
  );
}

class Workspace {
  Workspace({
    List<Ingredient> ingredients = const [],
    List<Formula> formulas = const [],
    List<Batch> batches = const [],
    this.portuguese = true,
  }) : ingredients = List.unmodifiable(ingredients),
       formulas = List.unmodifiable(formulas),
       batches = List.unmodifiable(batches) {
    require(
      ingredients.length <= 1000 &&
          formulas.length <= 1000 &&
          batches.length <= 5000,
      'Workspace limit exceeded.',
    );
    for (final ids in [
      ingredients.map((i) => i.id),
      formulas.map((f) => f.id),
      batches.map((b) => b.id),
    ]) {
      require(ids.toSet().length == ids.length, 'Duplicate identifier.');
    }
    for (final f in formulas) {
      calculate(f, ingredients, 1000);
    }
  }
  final List<Ingredient> ingredients;
  final List<Formula> formulas;
  final List<Batch> batches;
  final bool portuguese;
  Workspace copy({
    List<Ingredient>? ingredients,
    List<Formula>? formulas,
    List<Batch>? batches,
    bool? portuguese,
  }) => Workspace(
    ingredients: ingredients ?? this.ingredients,
    formulas: formulas ?? this.formulas,
    batches: batches ?? this.batches,
    portuguese: portuguese ?? this.portuguese,
  );
  String encode() => jsonEncode({
    'schema': 1,
    'portuguese': portuguese,
    'ingredients': ingredients.map((i) => i.toJson()).toList(),
    'formulas': formulas.map((f) => f.toJson()).toList(),
    'batches': batches.map((b) => b.toJson()).toList(),
  });
  factory Workspace.decode(String text) {
    try {
      require(text.length <= 5000000, 'Backup too large.');
      final j = jsonDecode(text) as Map<String, dynamic>;
      require(j['schema'] == 1, 'Unsupported backup version.');
      return Workspace(
        portuguese: j['portuguese'] as bool,
        ingredients: (j['ingredients'] as List)
            .map((i) => Ingredient.fromJson(i as Map<String, dynamic>))
            .toList(),
        formulas: (j['formulas'] as List)
            .map((f) => Formula.fromJson(f as Map<String, dynamic>))
            .toList(),
        batches: (j['batches'] as List)
            .map((b) => Batch.fromJson(b as Map<String, dynamic>))
            .toList(),
      );
    } catch (_) {
      throw const FormatException('Invalid or unsupported workspace backup.');
    }
  }
  factory Workspace.example({bool portuguese = true}) => Workspace(
    portuguese: portuguese,
    ingredients: [
      Ingredient(
        id: 'base',
        name: 'Base glicerinada / Glycerin base',
        unit: Measure.kg,
        packageQuantity: 1000,
        priceCents: 3200,
      ),
      Ingredient(
        id: 'wrap',
        name: 'Embalagem / Wrapping',
        unit: Measure.piece,
        packageQuantity: 10000,
        priceCents: 800,
      ),
    ],
    formulas: [
      Formula(
        id: 'sample',
        name: 'Estudo de custo / Cost study',
        product: 'Barra de 100 g / 100 g bar',
        yieldCount: 10,
        lines: [
          FormulaLine('base', Measure.g, 1000000),
          FormulaLine('wrap', Measure.piece, 10000),
        ],
      ),
    ],
  );
}
