import 'package:flutter/foundation.dart';

import '../domain/workspace.dart';
import '../data/workspace_repository.dart';

class WorkspaceController extends ChangeNotifier {
  WorkspaceController(this.repository);
  final WorkspaceRepository repository;
  Workspace state = Workspace();
  bool loading = true, saving = false;
  String? error;
  int _sequence = 0;
  String nextId() => '${DateTime.now().microsecondsSinceEpoch}-${_sequence++}';

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      state = await repository.load();
    } catch (_) {
      error = 'load';
    }
    loading = false;
    notifyListeners();
  }

  Future<void> replace(Workspace next, {bool recovery = false}) async {
    if (saving || loading || (error == 'load' && !recovery)) {
      throw StateError('Workspace is not ready.');
    }
    saving = true;
    notifyListeners();
    try {
      await repository.save(next);
      state = next;
      error = null;
    } finally {
      saving = false;
      notifyListeners();
    }
  }

  Future<void> saveIngredient(Ingredient ingredient) {
    // Workspace validation also rejects dimension changes used by formulas.
    return replace(
      state.copy(
        ingredients: [
          for (final old in state.ingredients)
            if (old.id != ingredient.id) old,
          ingredient,
        ],
      ),
    );
  }

  Future<void> deleteIngredient(String id) {
    require(
      !state.formulas.any((f) => f.lines.any((l) => l.ingredientId == id)),
      'Ingredient is used in a formula.',
    );
    return replace(
      state.copy(
        ingredients: state.ingredients.where((i) => i.id != id).toList(),
      ),
    );
  }

  Future<void> saveFormula(Formula formula) => replace(
    state.copy(
      formulas: [
        for (final old in state.formulas)
          if (old.id != formula.id) old,
        formula,
      ],
    ),
  );
  Future<void> deleteFormula(String id) => replace(
    state.copy(formulas: state.formulas.where((f) => f.id != id).toList()),
  );
  Future<void> recordBatch(Formula formula, int multiplier) => replace(
    state.copy(
      batches: [
        Batch(
          id: nextId(),
          date: DateTime.now().toUtc(),
          formulaName: formula.name,
          product: formula.product,
          result: calculate(formula, state.ingredients, multiplier),
        ),
        ...state.batches,
      ],
    ),
  );
}
