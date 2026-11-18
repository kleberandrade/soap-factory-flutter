# Contributing

Soap Factory is an academic collaboration between FATEC-AM and DUT. Keep the original team credits and the MIT copyright notice in distributions.

Use Flutter 3.50.0 / Dart 3.14.0 and install the committed lockfile:

```sh
flutter pub get --enforce-lockfile
```

Start with a failing behavior test for a bug or a new domain rule. Keep calculation logic in `lib/domain`, storage behind `WorkspaceRepository`, and widgets free of conversion or costing formulas. Use synthetic data only. Do not add credentials, analytics, fake sign-in, or production Firebase access.

Before proposing changes:

```sh
dart format lib test
flutter analyze --no-pub
flutter test --no-pub --coverage
flutter build web --release --no-pub --no-web-resources-cdn
```

Run tests and Web builds sequentially. Inspect narrow and wide browser layouts, keyboard access, visible focus, readable errors and both UI languages. Explain the behavior, validation and platform limitations in the pull request. Refresh screenshots if the UI changes.

Do not infer density, SAP values, lye ratios or recipe safety from an ingredient name. Any future chemistry feature needs an identified primary source, explicit units, limits, independent fixtures and qualified review. This management application intentionally contains none.

Dependency updates must update the lockfile and `docs/dependency-audit.json`, explain SDK-imposed limits, and pass the same checks. Avoid dependency overrides. A server-backed repository also requires real authentication, authorization, conflict handling and emulator tests before enabling it.

Reporting a bug: include the version, browser, reproduction steps and synthetic backup if useful. Never attach private formulas, credentials or personal data. For security issues, contact the repository owner privately using the contact details on their GitHub profile.
