import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import '../application/workspace_controller.dart';
import '../domain/workspace.dart';
import 'editors.dart';
import 'flag.dart';

const ink = Color(0xff183f35);
const muted = Color(0xff536b61);
const paper = Color(0xfff6f5ef);
const border = Color(0xffdde3da);

class SoapFactoryApp extends StatelessWidget {
  const SoapFactoryApp({super.key, required this.controller});
  final WorkspaceController controller;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) => MaterialApp(
      title: 'Soap Factory',
      debugShowCheckedModeBanner: false,
      locale: Locale(controller.state.portuguese ? 'pt' : 'en'),
      supportedLocales: const [Locale('pt'), Locale('en')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: paper,
        colorScheme: ColorScheme.fromSeed(
          seedColor: ink,
          primary: ink,
          surface: Colors.white,
          secondary: const Color(0xffa35b3b),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w700,
            color: ink,
            letterSpacing: -1,
          ),
          headlineMedium: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: ink,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: ink,
          ),
          bodyMedium: TextStyle(fontSize: 14, height: 1.5, color: ink),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: paper,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size(48, 48),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(48, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: WorkspaceScreen(controller: controller),
    ),
  );
}

class WorkspaceScreen extends StatefulWidget {
  const WorkspaceScreen({super.key, required this.controller});
  final WorkspaceController controller;
  @override
  State<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends State<WorkspaceScreen> {
  int page = 0;
  String search = '';
  WorkspaceController get c => widget.controller;
  Workspace get data => c.state;
  bool get pt => data.portuguese;
  String t(String a, String b) => pt ? a : b;
  List<String> get titles => [
    t('Visão geral', 'Overview'),
    t('Ingredientes', 'Ingredients'),
    t('Fórmulas', 'Formulas'),
    t('Produtos', 'Products'),
    t('Histórico', 'History'),
  ];
  static const icons = [
    Icons.dashboard_outlined,
    Icons.spa_outlined,
    Icons.science_outlined,
    Icons.inventory_2_outlined,
    Icons.history,
  ];
  Future<void> action(Future<void> Function() operation) async {
    try {
      await operation();
    } on FormatException catch (_) {
      if (mounted)
        message(
          t(
            'Verifique os valores, unidades e vínculos com fórmulas. Consulte os limites no campo.',
            'Check values, units and formula references. See field limits.',
          ),
        );
    } catch (_) {
      if (mounted)
        message(
          t(
            'Não foi possível salvar. Seus dados anteriores foram mantidos. Tente novamente.',
            'Could not save. Your previous data was kept. Try again.',
          ),
        );
    }
  }

  void message(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  void navigate(int index) => setState(() {
    page = index;
    search = '';
  });

  @override
  Widget build(BuildContext context) {
    if (c.loading)
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(t('Abrindo seu ateliê…', 'Opening your workshop…')),
            ],
          ),
        ),
      );
    if (c.error == 'load')
      return Scaffold(
        body: Center(
          child: SizedBox(
            width: 440,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_off_outlined, size: 48),
                  Text(
                    t(
                      'Não foi possível abrir os dados',
                      'Could not open your data',
                    ),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    t(
                      'O armazenamento está indisponível ou os dados precisam de recuperação. Nada foi sobrescrito.',
                      'Storage is unavailable or data needs recovery. Nothing was overwritten.',
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: c.load,
                    child: Text(t('Tentar novamente', 'Retry')),
                  ),
                  TextButton(
                    onPressed: backup,
                    child: Text(t('Restaurar backup', 'Restore backup')),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    return LayoutBuilder(
      builder: (context, size) {
        final desktop = size.maxWidth >= 1000;
        return Scaffold(
          bottomNavigationBar: desktop
              ? null
              : NavigationBar(
                  selectedIndex: page,
                  onDestinationSelected: c.saving ? null : navigate,
                  destinations: List.generate(
                    5,
                    (i) => NavigationDestination(
                      icon: Icon(icons[i]),
                      label: titles[i],
                    ),
                  ),
                ),
          body: SafeArea(
            child: Row(
              children: [
                if (desktop) sidebar(),
                Expanded(
                  child: Column(
                    children: [
                      header(desktop),
                      if (!desktop)
                        Container(
                          width: double.infinity,
                          color: const Color(0xffeaf0e7),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 6,
                          ),
                          child: Text(
                            t(
                              'Modo local · Dados neste navegador',
                              'Local mode · Data in this browser',
                            ),
                            style: const TextStyle(fontSize: 11, color: ink),
                          ),
                        ),
                      if (c.saving) const LinearProgressIndicator(minHeight: 3),
                      Expanded(
                        child: AbsorbPointer(
                          absorbing: c.saving,
                          child: SingleChildScrollView(
                            padding: EdgeInsets.all(desktop ? 36 : 20),
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 1180,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (page == 0)
                                      ...overview()
                                    else
                                      ...catalog(),
                                    const SizedBox(height: 32),
                                    Text(
                                      t(
                                        'FATEC-AM × DUT  ·  Conhecimento que se transforma.',
                                        'FATEC-AM × DUT  ·  Knowledge taking shape.',
                                      ),
                                      style: const TextStyle(
                                        color: muted,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget sidebar() => Container(
    width: 238,
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(right: BorderSide(color: border)),
    ),
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        brand(),
        const SizedBox(height: 48),
        Text(
          t('SEU ATELIÊ', 'YOUR WORKSHOP'),
          style: const TextStyle(
            fontSize: 11,
            letterSpacing: 2,
            color: muted,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < titles.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: page == i ? const Color(0xffeaf0e7) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                leading: Icon(icons[i], color: page == i ? ink : muted),
                title: Text(
                  titles[i],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: page == i ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
                onTap: c.saving ? null : () => navigate(i),
              ),
            ),
          ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: paper,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.devices_outlined, color: muted),
              const SizedBox(height: 10),
              Text(
                t('Um ateliê local', 'A local workshop'),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                t(
                  'Dados neste navegador. Faça backup para guardar seu trabalho.',
                  'Data in this browser. Make a backup to keep your work.',
                ),
                style: const TextStyle(fontSize: 12, color: muted),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'SOAP FACTORY / 2.0',
          style: const TextStyle(
            fontSize: 10,
            letterSpacing: 1.4,
            color: muted,
          ),
        ),
      ],
    ),
  );

  Widget brand() => const FittedBox(
    fit: BoxFit.scaleDown,
    alignment: Alignment.centerLeft,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.bubble_chart, color: ink, size: 34),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'soap factory',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.7,
              ),
            ),
            Text(
              'FORMULA & CRAFT',
              style: TextStyle(fontSize: 9, letterSpacing: 2, color: muted),
            ),
          ],
        ),
      ],
    ),
  );

  Widget header(bool desktop) => Container(
    padding: EdgeInsets.symmetric(horizontal: desktop ? 36 : 16, vertical: 14),
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(bottom: BorderSide(color: border)),
    ),
    child: Row(
      children: [
        Expanded(
          child: desktop
              ? Text(
                  t('Ateliê / ', 'Workshop / ') + titles[page],
                  style: const TextStyle(color: muted, fontSize: 13),
                )
              : brand(),
        ),
        if (desktop)
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: chip(t('●  Modo local', '●  Local mode')),
          ),
        IconButton(
          tooltip: t('Backup e restauração', 'Backup and restore'),
          onPressed: c.saving ? null : backup,
          icon: const Icon(Icons.save_alt_outlined),
        ),
        IconButton(
          tooltip: 'Português (Brasil)',
          onPressed: c.saving || pt
              ? null
              : () => action(() => c.replace(data.copy(portuguese: true))),
          icon: const LanguageFlag(brazil: true),
        ),
        IconButton(
          tooltip: 'English (United Kingdom)',
          onPressed: c.saving || !pt
              ? null
              : () => action(() => c.replace(data.copy(portuguese: false))),
          icon: const LanguageFlag(brazil: false),
        ),
      ],
    ),
  );

  Widget chip(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: const Color(0xffedf2e9),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        color: ink,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  List<Widget> overview() => [
    Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 20,
      runSpacing: 16,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t('Feito com cuidado.', 'Made with care.'),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 6),
            Text(
              t(
                'Organize suas ideias. Conheça cada custo.',
                'Organize your ideas. Know every cost.',
              ),
              style: const TextStyle(color: muted),
            ),
          ],
        ),
      ],
    ),
    const SizedBox(height: 26),
    Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: ink,
        borderRadius: BorderRadius.circular(24),
      ),
      child: LayoutBuilder(
        builder: (context, box) => Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t(
                      'DA MATÉRIA-PRIMA AO SEU PRÓXIMO LOTE',
                      'FROM RAW MATERIAL TO YOUR NEXT BATCH',
                    ),
                    style: const TextStyle(
                      color: Color(0xffd8e6c1),
                      fontSize: 10,
                      letterSpacing: 1.7,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    t('Mais clareza para criar.', 'More clarity to create.'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    t(
                      'Ingredientes, fórmulas e custos em um só lugar.\nSeu processo, na medida certa.',
                      'Ingredients, formulas and costs in one place.\nYour process, in the right measure.',
                    ),
                    style: const TextStyle(
                      color: Color(0xffe0e8de),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 22),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xffe1edcc),
                      foregroundColor: ink,
                    ),
                    onPressed: () => navigate(data.ingredients.isEmpty ? 1 : 2),
                    icon: const Icon(Icons.arrow_forward, size: 18),
                    label: Text(
                      t(
                        data.ingredients.isEmpty
                            ? 'Cadastrar ingrediente'
                            : 'Explorar fórmulas',
                        data.ingredients.isEmpty
                            ? 'Add ingredient'
                            : 'Explore formulas',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (box.maxWidth > 600)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Icon(
                  Icons.bubble_chart_outlined,
                  size: 130,
                  color: Color(0xffa8c3a5),
                ),
              ),
          ],
        ),
      ),
    ),
    const SizedBox(height: 24),
    LayoutBuilder(
      builder: (context, box) => Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          metric(
            t('Ingredientes', 'Ingredients'),
            '${data.ingredients.length}',
            Icons.spa_outlined,
            box.maxWidth,
            1,
          ),
          metric(
            t('Fórmulas ativas', 'Active formulas'),
            '${data.formulas.length}',
            Icons.science_outlined,
            box.maxWidth,
            2,
          ),
          metric(
            t('Lotes registrados', 'Recorded batches'),
            '${data.batches.length}',
            Icons.inventory_2_outlined,
            box.maxWidth,
            4,
          ),
        ],
      ),
    ),
    const SizedBox(height: 30),
    Wrap(
      spacing: 20,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          t('Seu próximo passo', 'Your next step'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        if (data.ingredients.isEmpty && data.formulas.isEmpty)
          TextButton(
            onPressed: () =>
                action(() => c.replace(Workspace.example(portuguese: pt))),
            child: Text(t('Carregar exemplo', 'Load example')),
          ),
      ],
    ),
    const SizedBox(height: 12),
    panel(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          step(
            '01',
            t('Cadastre a matéria-prima', 'Register your materials'),
            t(
              'Informe quantidade da embalagem, unidade e preço.',
              'Enter package quantity, unit and price.',
            ),
            1,
          ),
          const Divider(color: border),
          step(
            '02',
            t('Dê forma às suas ideias', 'Give shape to your ideas'),
            t(
              'Combine ingredientes e defina o produto e o rendimento.',
              'Combine ingredients and define the product and yield.',
            ),
            2,
          ),
          const Divider(color: border),
          step(
            '03',
            t('Dimensione e registre', 'Scale and record'),
            t(
              'Confira o custo do lote e guarde um retrato no histórico.',
              'Review batch cost and keep a snapshot in history.',
            ),
            2,
          ),
        ],
      ),
    ),
    const SizedBox(height: 20),
    caution(),
  ];

  Widget metric(
    String title,
    String value,
    IconData icon,
    double width,
    int destination,
  ) => SizedBox(
    width: width >= 600 ? (width - 32) / 3 : width,
    child: InkWell(
      onTap: () => navigate(destination),
      borderRadius: BorderRadius.circular(18),
      child: panel(
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: muted, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(icon, color: muted, size: 28),
          ],
        ),
      ),
    ),
  );
  Widget step(String n, String title, String subtitle, int destination) =>
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundColor: paper,
          foregroundColor: ink,
          child: Text(n, style: const TextStyle(fontSize: 12)),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: muted),
        ),
        trailing: const Icon(Icons.arrow_forward, size: 18),
        onTap: () => navigate(destination),
      );
  Widget panel(Widget child) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: border),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Material(color: Colors.transparent, child: child),
  );
  Widget caution() => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Icon(Icons.info_outline, size: 18, color: muted),
      const SizedBox(width: 10),
      Expanded(
        child: Text(
          t(
            'Gestão e aritmética de custos. Não calcula soda, índices SAP ou segurança de receitas. O exemplo é sintético e não é uma receita.',
            'Management and cost arithmetic. Does not calculate lye, SAP values or recipe safety. The synthetic example is not a recipe.',
          ),
          style: const TextStyle(color: muted, fontSize: 12),
        ),
      ),
    ],
  );

  List<Widget> catalog() {
    final ingredients = data.ingredients
        .where((i) => i.name.toLowerCase().contains(search))
        .toList();
    final formulas = data.formulas
        .where((f) => '${f.name} ${f.product}'.toLowerCase().contains(search))
        .toList();
    final batches = data.batches
        .where(
          (b) => '${b.formulaName} ${b.product}'.toLowerCase().contains(search),
        )
        .toList();
    final empty = page == 1
        ? ingredients.isEmpty
        : page == 4
        ? batches.isEmpty
        : formulas.isEmpty;
    return [
      Wrap(
        spacing: 24,
        runSpacing: 16,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titles[page],
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                [
                  '',
                  t(
                    'Cada material, na unidade certa.',
                    'Every material, in the right unit.',
                  ),
                  t(
                    'Sua composição. Seus números.',
                    'Your composition. Your numbers.',
                  ),
                  t(
                    'Produtos e rendimento por fórmula.',
                    'Products and yield per formula.',
                  ),
                  t(
                    'Um retrato fiel de cada lote.',
                    'A faithful snapshot of every batch.',
                  ),
                ][page],
                style: const TextStyle(color: muted),
              ),
            ],
          ),
          if (page != 4)
            FilledButton.icon(
              onPressed: () => page == 1 ? editIngredient() : editFormula(),
              icon: const Icon(Icons.add, size: 20),
              label: Text(
                page == 1
                    ? t('Novo ingrediente', 'New ingredient')
                    : t('Nova fórmula', 'New formula'),
              ),
            ),
        ],
      ),
      const SizedBox(height: 26),
      TextFormField(
        key: ValueKey('search-$page'),
        onChanged: (value) =>
            setState(() => search = value.trim().toLowerCase()),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          labelText: t('Buscar por nome', 'Search by name'),
        ),
      ),
      const SizedBox(height: 20),
      if (empty)
        panel(
          Column(
            children: [
              const SizedBox(height: 12),
              Icon(icons[page], size: 48, color: muted),
              const SizedBox(height: 18),
              Text(
                search.isNotEmpty
                    ? t('Nenhum resultado', 'No results')
                    : t('Tudo começa por aqui', 'It all starts here'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                search.isNotEmpty
                    ? t('Experimente outro nome.', 'Try another name.')
                    : page == 4
                    ? t(
                        'Registre um lote a partir de uma fórmula para acompanhar os custos.',
                        'Record a batch from a formula to track costs.',
                      )
                    : t(
                        'Use o botão acima para criar seu primeiro cadastro.',
                        'Use the button above to create your first entry.',
                      ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      if (page == 1)
        for (final i in ingredients)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: panel(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.spa_outlined, color: muted),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          i.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      IconButton(
                        tooltip: t('Editar ingrediente', 'Edit ingredient'),
                        onPressed: () => editIngredient(i),
                        icon: const Icon(Icons.edit_outlined),
                      ),
                      IconButton(
                        tooltip: t('Excluir ingrediente', 'Delete ingredient'),
                        onPressed: () => removeIngredient(i),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${decimal(i.packageQuantity)} ${i.unit.symbol}  ·  ${money(i.priceCents)}',
                    style: const TextStyle(color: muted),
                  ),
                ],
              ),
            ),
          ),
      if (page == 2 || page == 3)
        for (final f in formulas)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: panel(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              page == 3 ? f.product : f.name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              page == 3 ? f.name : f.product,
                              style: const TextStyle(color: muted),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: t('Editar fórmula', 'Edit formula'),
                        onPressed: () => editFormula(f),
                        icon: const Icon(Icons.edit_outlined),
                      ),
                      IconButton(
                        tooltip: t('Excluir fórmula', 'Delete formula'),
                        onPressed: () => removeFormula(f),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      chip(
                        '${f.yieldCount} ${t('produtos / lote', 'products / batch')}',
                      ),
                      chip(
                        '${f.lines.length} ${t('ingredientes', 'ingredients')}',
                      ),
                      chip(
                        '${money(calculate(f, data.ingredients, 1000).totalCents)} / ${t('lote', 'batch')}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () => batch(f),
                    icon: const Icon(Icons.tune, size: 18),
                    label: Text(t('Dimensionar lote', 'Scale batch')),
                  ),
                ],
              ),
            ),
          ),
      if (page == 4)
        for (final b in batches)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: panel(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          b.formulaName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      IconButton(
                        tooltip: t('Detalhes do lote', 'Batch details'),
                        onPressed: () => batchDetails(b),
                        icon: const Icon(Icons.open_in_new),
                      ),
                    ],
                  ),
                  Text(
                    '${b.product}  ·  ${date(b.date)}',
                    style: const TextStyle(color: muted),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      chip(
                        '${b.result.outputCount} ${t('produtos', 'products')}',
                      ),
                      chip(money(b.result.totalCents)),
                      chip('${money(b.result.unitCostCents)} / un'),
                    ],
                  ),
                ],
              ),
            ),
          ),
      const SizedBox(height: 20),
      caution(),
    ];
  }

  String date(DateTime value) {
    final local = value.toLocal();
    return '${local.day.toString().padLeft(2, '0')}/${local.month.toString().padLeft(2, '0')}/${local.year} ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }

  Future<void> editIngredient([Ingredient? ingredient]) async {
    await showDialog<void>(
      context: context,
      builder: (_) => IngredientEditor(controller: c, ingredient: ingredient),
    );
  }

  Future<void> editFormula([Formula? formula]) async {
    if (data.ingredients.isEmpty) {
      message(
        t('Cadastre um ingrediente primeiro.', 'Add an ingredient first.'),
      );
      navigate(1);
      return;
    }
    await showDialog<void>(
      context: context,
      builder: (_) => FormulaEditor(controller: c, formula: formula),
    );
  }

  Future<bool> confirm(String title, String description) async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(t('Cancelar', 'Cancel')),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(t('Confirmar', 'Confirm')),
            ),
          ],
        ),
      ) ??
      false;
  Future<void> removeIngredient(Ingredient i) async {
    if (data.formulas.any((f) => f.lines.any((l) => l.ingredientId == i.id))) {
      message(
        t(
          'Este ingrediente está em uso. Remova-o das fórmulas antes de excluir.',
          'This ingredient is in use. Remove it from formulas before deleting.',
        ),
      );
      return;
    }
    if (await confirm(
      t('Excluir ingrediente?', 'Delete ingredient?'),
      i.name,
    )) {
      await action(() => c.deleteIngredient(i.id));
    }
  }

  Future<void> removeFormula(Formula f) async {
    if (await confirm(
      t('Excluir fórmula?', 'Delete formula?'),
      t('O histórico será preservado.', 'History will be preserved.'),
    )) {
      await action(() => c.deleteFormula(f.id));
    }
  }

  Future<void> batch(Formula f) async {
    await showDialog<void>(
      context: context,
      builder: (_) => BatchEditor(controller: c, formula: f),
    );
  }

  Widget result(CostResult result) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('${t('Escala', 'Scale')}: ×${decimal(result.multiplier)}'),
      for (final line in result.lines)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            '${line.name}\n${decimal(line.quantity)} ${line.unit.symbol}  ·  ${money(line.cents)}',
          ),
        ),
      const Divider(),
      Text(
        '${result.outputCount} ${t('produtos', 'products')}  ·  ${money(result.totalCents)}',
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      Text('${money(result.unitCostCents)} / un'),
    ],
  );
  Future<void> batchDetails(Batch b) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(b.formulaName),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${b.product}\n${date(b.date)}'),
              result(b.result),
              const SizedBox(height: 12),
              Text(
                t(
                  'Valores históricos. Não incluem mão de obra, perdas ou tributos.',
                  'Historical values. Exclude labor, waste and taxes.',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t('Fechar', 'Close')),
        ),
      ],
    ),
  );

  Future<void> backup() async {
    await showDialog<void>(
      context: context,
      builder: (_) => BackupDialog(controller: c),
    );
  }
}

class BackupDialog extends StatefulWidget {
  const BackupDialog({super.key, required this.controller});
  final WorkspaceController controller;
  @override
  State<BackupDialog> createState() => _BackupDialogState();
}

class _BackupDialogState extends State<BackupDialog> {
  final input = TextEditingController();
  String? error;
  bool busy = false, copied = false;
  String t(String a, String b) => widget.controller.state.portuguese ? a : b;
  @override
  void dispose() {
    input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(t('Backup do ateliê', 'Workshop backup')),
    content: SizedBox(
      width: 500,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.controller.error != 'load') ...[
              Text(
                t(
                  'Dados locais, sem conta ou sincronização. Copie o JSON e guarde em um arquivo seguro. A restauração substitui todos os dados deste navegador.',
                  'Local data, without accounts or sync. Copy the JSON and keep it in a safe file. Restore replaces all data in this browser.',
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: busy
                    ? null
                    : () async {
                        try {
                          await Clipboard.setData(
                            ClipboardData(
                              text: widget.controller.state.encode(),
                            ),
                          );
                          if (mounted) setState(() => copied = true);
                        } catch (_) {
                          if (mounted)
                            setState(
                              () => error = t(
                                'Falha ao copiar. Use o texto abaixo.',
                                'Copy failed. Use the text below.',
                              ),
                            );
                        }
                      },
                icon: const Icon(Icons.copy),
                label: Text(
                  copied
                      ? t('Copiado', 'Copied')
                      : t('Copiar backup', 'Copy backup'),
                ),
              ),
              ExpansionTile(
                title: Text(t('Ver JSON para copiar', 'View JSON to copy')),
                children: [SelectableText(widget.controller.state.encode())],
              ),
            ],
            Text(
              t(
                'A restauração substitui os dados atuais por um backup válido.',
                'Restore replaces current data with a valid backup.',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: input,
              minLines: 3,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: t(
                  'Cole um backup para restaurar',
                  'Paste a backup to restore',
                ),
              ),
            ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: busy ? null : () => Navigator.pop(context),
        child: Text(t('Fechar', 'Close')),
      ),
      FilledButton(
        onPressed: busy ? null : restore,
        child: Text(t('Restaurar…', 'Restore…')),
      ),
    ],
  );
  Future<void> restore() async {
    Workspace next;
    try {
      next = Workspace.decode(input.text);
    } catch (_) {
      setState(
        () => error = t(
          'Backup inválido ou versão incompatível. Dados mantidos.',
          'Invalid backup or incompatible version. Data kept.',
        ),
      );
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t('Substituir todos os dados?', 'Replace all data?')),
        content: Text(
          t(
            'Faça uma cópia do backup atual antes de continuar.',
            'Make a copy of the current backup before continuing.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t('Cancelar', 'Cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(t('Substituir', 'Replace')),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    setState(() => busy = true);
    try {
      await widget.controller.replace(next, recovery: true);
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted)
        setState(() {
          busy = false;
          error = t(
            'Falha ao salvar. Dados mantidos.',
            'Save failed. Data kept.',
          );
        });
    }
  }
}
