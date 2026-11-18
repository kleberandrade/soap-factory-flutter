# Changelog

## 2.0.0 — 2026-11-17

- Replace the incomplete legacy sign-in prototype with an explicit local workspace; remove obsolete Firebase, social-login and MobX APIs and generated stores.
- Adopt Flutter 3.50.0, Dart 3.14.0, the standalone Material UI package and current compatible dependencies.
- Add ingredient create/edit/delete, package prices and dimension-safe g/kg, mL/L and count units.
- Add formula composition and product/yield management; prevent dangling references and duplicate ingredients.
- Add deterministic scaling, line cost rounding, batch cost and unit cost; preserve immutable historical snapshots.
- Add local persistence, JSON backup validation and confirmed restore, storage failure recovery and language persistence.
- Add responsive PT-BR/EN navigation, locally drawn circular flags and accessible form labels.
- Add Web host, current browser captures, arithmetic/controller/widget tests, CI verification and an English documentation set.
- Migrate Android Gradle integration incrementally and raise iOS deployment target; native builds/devices remain unvalidated.
- Preserve original team, institutional credits and original MIT grant in a standalone LICENSE.

## Original prototype — 2019–2020

Academic collaborative Flutter application with Firebase email/Google login experiments. The original material is retained in `docs/ORIGINAL_README.md`; original source and authorship remain in Git history. It is not the current setup guide.
