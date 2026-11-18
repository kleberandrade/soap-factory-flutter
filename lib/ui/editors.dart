import 'package:material_ui/material_ui.dart';

import '../application/workspace_controller.dart';
import '../domain/workspace.dart';

String? validateText(String? value, bool pt) {
  try {
    label(value ?? '');
    return null;
  } catch (_) {
    return pt ? 'Use de 1 a 100 caracteres.' : 'Use 1–100 characters.';
  }
}

String? validateQuantity(String? value, bool pt) {
  try {
    parseQuantity(value ?? '');
    return null;
  } catch (_) {
    return pt
        ? 'Valor > 0 até 1.000.000; até 3 decimais.'
        : 'Value > 0 up to 1,000,000; up to 3 decimals.';
  }
}

String? validateMoney(String? value, bool pt) {
  try {
    parseMoney(value ?? '');
    return null;
  } catch (_) {
    return pt
        ? 'Preço ≥ 0; até 7 dígitos e 2 decimais.'
        : 'Price ≥ 0; up to 7 digits and 2 decimals.';
  }
}

String? validateYield(String? value, bool pt) {
  final number = int.tryParse(value ?? '');
  return number != null && number > 0 && number <= 1000000
      ? null
      : pt
      ? 'Use de 1 a 1.000.000 produtos inteiros.'
      : 'Use 1–1,000,000 whole products.';
}

Widget gap() => const SizedBox(height: 16);
Widget errorText(BuildContext context, String? error) => error == null
    ? const SizedBox.shrink()
    : Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Semantics(
          liveRegion: true,
          child: Text(
            error,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      );
const numberKeyboard = TextInputType.numberWithOptions(decimal: true);

class IngredientEditor extends StatefulWidget {
  const IngredientEditor({
    super.key,
    required this.controller,
    this.ingredient,
  });
  final WorkspaceController controller;
  final Ingredient? ingredient;
  @override
  State<IngredientEditor> createState() => _IngredientEditorState();
}

class _IngredientEditorState extends State<IngredientEditor> {
  final form = GlobalKey<FormState>();
  late final name = TextEditingController(text: widget.ingredient?.name ?? '');
  late final quantity = TextEditingController(
    text: widget.ingredient == null
        ? ''
        : decimal(widget.ingredient!.packageQuantity),
  );
  late final price = TextEditingController(
    text: widget.ingredient == null
        ? ''
        : (widget.ingredient!.priceCents / 100).toStringAsFixed(2),
  );
  late Measure unit = widget.ingredient?.unit ?? Measure.g;
  bool busy = false;
  String? error;
  bool get pt => widget.controller.state.portuguese;
  String t(String a, String b) => pt ? a : b;
  @override
  void dispose() {
    name.dispose();
    quantity.dispose();
    price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(
      widget.ingredient == null
          ? t('Novo ingrediente', 'New ingredient')
          : t('Editar ingrediente', 'Edit ingredient'),
    ),
    content: SizedBox(
      width: 500,
      child: SingleChildScrollView(
        child: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: name,
                autofocus: true,
                maxLength: 100,
                decoration: InputDecoration(labelText: t('Nome', 'Name')),
                validator: (v) => validateText(v, pt),
              ),
              gap(),
              DropdownButtonFormField<Measure>(
                initialValue: unit,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: t('Unidade da embalagem', 'Package unit'),
                ),
                items: Measure.values
                    .map(
                      (u) => DropdownMenuItem(value: u, child: Text(u.symbol)),
                    )
                    .toList(),
                onChanged: busy ? null : (u) => setState(() => unit = u!),
              ),
              gap(),
              TextFormField(
                controller: quantity,
                keyboardType: numberKeyboard,
                decoration: InputDecoration(
                  labelText: t(
                    'Quantidade por embalagem',
                    'Quantity per package',
                  ),
                ),
                validator: (v) => validateQuantity(v, pt),
              ),
              gap(),
              TextFormField(
                controller: price,
                keyboardType: numberKeyboard,
                decoration: InputDecoration(
                  labelText: t(
                    'Preço da embalagem (BRL)',
                    'Package price (BRL)',
                  ),
                ),
                validator: (v) => validateMoney(v, pt),
              ),
              gap(),
              Text(
                t(
                  'Sem conversão entre massa, volume e unidades. Use unidades inteiras para embalagens.',
                  'No conversion between mass, volume and count. Use whole counts for packaging.',
                ),
              ),
              errorText(context, error),
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: busy ? null : () => Navigator.pop(context),
        child: Text(t('Cancelar', 'Cancel')),
      ),
      FilledButton(
        onPressed: busy ? null : save,
        child: Text(
          busy
              ? t('Salvando…', 'Saving…')
              : t('Salvar ingrediente', 'Save ingredient'),
        ),
      ),
    ],
  );
  Future<void> save() async {
    if (!form.currentState!.validate()) return;
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final ingredient = Ingredient(
        id: widget.ingredient?.id ?? widget.controller.nextId(),
        name: name.text,
        unit: unit,
        packageQuantity: parseQuantity(quantity.text),
        priceCents: parseMoney(price.text),
      );
      await widget.controller.saveIngredient(ingredient);
      if (mounted) Navigator.pop(context);
    } on FormatException {
      if (mounted)
        setState(() {
          busy = false;
          error = t(
            'Unidade incompatível com uma fórmula, contagem fracionada ou custo fora dos limites. Confira os dados.',
            'Unit incompatible with a formula, fractional count or cost outside limits. Check your data.',
          );
        });
    } catch (_) {
      if (mounted)
        setState(() {
          busy = false;
          error = t(
            'Falha ao salvar. Tente novamente.',
            'Save failed. Try again.',
          );
        });
    }
  }
}

class _LineDraft {
  _LineDraft(this.ingredientId, this.unit, String amount)
    : quantity = TextEditingController(text: amount);
  String ingredientId;
  Measure unit;
  final TextEditingController quantity;
  void dispose() => quantity.dispose();
}

class FormulaEditor extends StatefulWidget {
  const FormulaEditor({super.key, required this.controller, this.formula});
  final WorkspaceController controller;
  final Formula? formula;
  @override
  State<FormulaEditor> createState() => _FormulaEditorState();
}

class _FormulaEditorState extends State<FormulaEditor> {
  final form = GlobalKey<FormState>();
  late final name = TextEditingController(text: widget.formula?.name ?? '');
  late final product = TextEditingController(
    text: widget.formula?.product ?? '',
  );
  late final yieldCount = TextEditingController(
    text: widget.formula?.yieldCount.toString() ?? '10',
  );
  late final List<_LineDraft> lines =
      widget.formula?.lines
          .map((l) => _LineDraft(l.ingredientId, l.unit, decimal(l.quantity)))
          .toList() ??
      [_LineDraft(ingredients.first.id, ingredients.first.unit, '')];
  bool busy = false;
  String? error;
  bool get pt => widget.controller.state.portuguese;
  String t(String a, String b) => pt ? a : b;
  List<Ingredient> get ingredients => widget.controller.state.ingredients;
  _LineDraft freshLine() {
    final unused =
        ingredients
            .where((i) => !lines.any((l) => l.ingredientId == i.id))
            .firstOrNull ??
        ingredients.first;
    return _LineDraft(unused.id, unused.unit, '');
  }

  @override
  void dispose() {
    name.dispose();
    product.dispose();
    yieldCount.dispose();
    for (final l in lines) {
      l.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(
      widget.formula == null
          ? t('Nova fórmula', 'New formula')
          : t('Editar fórmula', 'Edit formula'),
    ),
    content: SizedBox(
      width: 600,
      child: SingleChildScrollView(
        child: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: name,
                maxLength: 100,
                decoration: InputDecoration(
                  labelText: t('Nome da fórmula', 'Formula name'),
                ),
                validator: (v) => validateText(v, pt),
              ),
              gap(),
              TextFormField(
                controller: product,
                maxLength: 100,
                decoration: InputDecoration(
                  labelText: t('Nome do produto', 'Product name'),
                ),
                validator: (v) => validateText(v, pt),
              ),
              gap(),
              TextFormField(
                controller: yieldCount,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: t(
                    'Rendimento: produtos por lote',
                    'Yield: products per batch',
                  ),
                ),
                validator: (v) => validateYield(v, pt),
              ),
              gap(),
              Text(
                t('Composição de referência', 'Reference composition'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              gap(),
              for (var index = 0; index < lines.length; index++)
                lineEditor(index),
              OutlinedButton.icon(
                onPressed:
                    busy ||
                        lines.length >= ingredients.length ||
                        lines.length >= 100
                    ? null
                    : () => setState(() => lines.add(freshLine())),
                icon: const Icon(Icons.add),
                label: Text(t('Adicionar ingrediente', 'Add ingredient')),
              ),
              gap(),
              Text(
                t(
                  'Composição informada por você. Este app não verifica química ou segurança. Custos incluem apenas ingredientes cadastrados.',
                  'Composition provided by you. This app does not verify chemistry or safety. Costs include only registered materials.',
                ),
              ),
              errorText(context, error),
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: busy ? null : () => Navigator.pop(context),
        child: Text(t('Cancelar', 'Cancel')),
      ),
      FilledButton(
        onPressed: busy ? null : save,
        child: Text(
          busy
              ? t('Salvando…', 'Saving…')
              : t('Salvar fórmula', 'Save formula'),
        ),
      ),
    ],
  );
  Widget lineEditor(int index) {
    final line = lines[index];
    final ingredient = ingredients.firstWhere((i) => i.id == line.ingredientId);
    return Padding(
      key: ObjectKey(line),
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: line.ingredientId,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: t('Ingrediente', 'Ingredient'),
                  ),
                  items: ingredients
                      .map(
                        (i) => DropdownMenuItem(
                          value: i.id,
                          child: Text(i.name, overflow: TextOverflow.ellipsis),
                        ),
                      )
                      .toList(),
                  onChanged: busy
                      ? null
                      : (id) => setState(() {
                          line.ingredientId = id!;
                          line.unit = ingredients
                              .firstWhere((i) => i.id == id)
                              .unit;
                        }),
                ),
              ),
              IconButton(
                tooltip: t('Remover linha', 'Remove line'),
                onPressed: busy || lines.length <= 1
                    ? null
                    : () => setState(() {
                        lines.removeAt(index).dispose();
                      }),
                icon: const Icon(Icons.remove_circle_outline),
              ),
            ],
          ),
          gap(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: line.quantity,
                  keyboardType: numberKeyboard,
                  decoration: InputDecoration(
                    labelText: t('Quantidade no lote', 'Batch quantity'),
                  ),
                  validator: (v) => validateQuantity(v, pt),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<Measure>(
                  key: ValueKey('${line.ingredientId}-${line.unit.name}'),
                  initialValue: line.unit,
                  decoration: InputDecoration(labelText: t('Unidade', 'Unit')),
                  items: Measure.values
                      .where((u) => u.dimension == ingredient.unit.dimension)
                      .map(
                        (u) =>
                            DropdownMenuItem(value: u, child: Text(u.symbol)),
                      )
                      .toList(),
                  onChanged: busy
                      ? null
                      : (u) => setState(() => line.unit = u!),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> save() async {
    if (!form.currentState!.validate()) return;
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final formula = Formula(
        id: widget.formula?.id ?? widget.controller.nextId(),
        name: name.text,
        product: product.text,
        yieldCount: int.parse(yieldCount.text),
        lines: lines
            .map(
              (l) => FormulaLine(
                l.ingredientId,
                l.unit,
                parseQuantity(l.quantity.text),
              ),
            )
            .toList(),
      );
      await widget.controller.saveFormula(formula);
      if (mounted) Navigator.pop(context);
    } on FormatException {
      if (mounted)
        setState(() {
          busy = false;
          error = t(
            'Não repita ingredientes; use contagens inteiras e custos dentro dos limites.',
            'Do not repeat ingredients; use whole counts and costs within limits.',
          );
        });
    } catch (_) {
      if (mounted)
        setState(() {
          busy = false;
          error = t(
            'Falha ao salvar. Tente novamente.',
            'Save failed. Try again.',
          );
        });
    }
  }
}

class BatchEditor extends StatefulWidget {
  const BatchEditor({
    super.key,
    required this.controller,
    required this.formula,
  });
  final WorkspaceController controller;
  final Formula formula;
  @override
  State<BatchEditor> createState() => _BatchEditorState();
}

class _BatchEditorState extends State<BatchEditor> {
  final scale = TextEditingController(text: '1');
  bool busy = false;
  String? saveError;
  String t(String a, String b) => widget.controller.state.portuguese ? a : b;
  @override
  void dispose() {
    scale.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CostResult? preview;
    String? error;
    try {
      preview = calculate(
        widget.formula,
        widget.controller.state.ingredients,
        parseQuantity(scale.text),
      );
    } catch (_) {
      error = t(
        'Escala > 0 até 1.000, com até 3 decimais. O resultado deve ter produtos e unidades inteiros, sem quantidades zeradas e dentro dos limites.',
        'Scale > 0 up to 1,000, with up to 3 decimals. Output and counts must be whole, quantities nonzero and within limits.',
      );
    }
    return AlertDialog(
      title: Text(t('Dimensionar lote', 'Scale batch')),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.formula.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(widget.formula.product),
              gap(),
              TextField(
                controller: scale,
                keyboardType: numberKeyboard,
                onChanged: (_) => setState(() => saveError = null),
                decoration: InputDecoration(
                  labelText: t('Multiplicador do lote', 'Batch multiplier'),
                  helperText: t(
                    '1 = lote de referência; 1,5 = 150%',
                    '1 = reference batch; 1.5 = 150%',
                  ),
                ),
              ),
              gap(),
              if (preview != null) ...[
                for (final line in preview.lines)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      '${line.name}\n${decimal(line.quantity)} ${line.unit.symbol}  ·  ${money(line.cents)}',
                    ),
                  ),
                const Divider(),
                Text(
                  '${preview.outputCount} ${t('produtos', 'products')}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '${money(preview.totalCents)} / ${t('lote', 'batch')}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text('${money(preview.unitCostCents)} / un'),
                gap(),
              ],
              Text(
                t(
                  'Custos arredondados por linha ao centavo, metade para cima. Não incluem mão de obra, perdas, tributos ou análise química.',
                  'Line costs rounded to cents, half up. Exclude labor, waste, taxes and chemical analysis.',
                ),
              ),
              errorText(context, error ?? saveError),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: busy ? null : () => Navigator.pop(context),
          child: Text(t('Cancelar', 'Cancel')),
        ),
        FilledButton(
          onPressed: busy || preview == null ? null : record,
          child: Text(
            busy
                ? t('Salvando…', 'Saving…')
                : t('Registrar lote', 'Record batch'),
          ),
        ),
      ],
    );
  }

  Future<void> record() async {
    setState(() => busy = true);
    try {
      await widget.controller.recordBatch(
        widget.formula,
        parseQuantity(scale.text),
      );
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted)
        setState(() {
          busy = false;
          saveError = t(
            'Falha ao salvar. Tente novamente.',
            'Save failed. Try again.',
          );
        });
    }
  }
}
