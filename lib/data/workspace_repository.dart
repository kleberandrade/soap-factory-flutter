import 'package:shared_preferences/shared_preferences.dart';

import '../domain/workspace.dart';

abstract interface class WorkspaceRepository {
  Future<Workspace> load();
  Future<void> save(Workspace workspace);
}

/// One versioned document: ingredients, formulas, snapshots and UI language.
class PreferencesWorkspaceRepository implements WorkspaceRepository {
  PreferencesWorkspaceRepository({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();
  final SharedPreferencesAsync _preferences;
  static const key = 'soap_factory.workspace.v1';
  @override
  Future<Workspace> load() async {
    final text = await _preferences.getString(key);
    return text == null ? Workspace() : Workspace.decode(text);
  }

  @override
  Future<void> save(Workspace workspace) async {
    final text = workspace.encode();
    require(text.length <= 5000000, 'Workspace exceeds backup size limit.');
    await _preferences.setString(key, text);
  }
}
