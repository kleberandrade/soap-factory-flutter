import 'package:material_ui/material_ui.dart';

import 'application/workspace_controller.dart';
import 'data/workspace_repository.dart';
import 'ui/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = WorkspaceController(PreferencesWorkspaceRepository());
  runApp(SoapFactoryApp(controller: controller));
  controller.load();
}
