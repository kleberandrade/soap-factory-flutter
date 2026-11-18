# Validation record — 2026-11-17

## Environment and scope

Flutter 3.50.0 (revision `ab2912035e160d9cad6306df307576da6128ebdb`), Dart 3.14.0, isolated project SDK/cache. The shared Homebrew Flutter SDK was not changed. No Android SDK licenses were accepted. Release Web was served only on `127.0.0.1:18773`; no public deployment was made.

## Completed checks

- `dart format --output=none --set-exit-if-changed lib test`: clean.
- `flutter analyze --no-pub`: no issues.
- `flutter test --no-pub --coverage`: 15 passing behavior tests.
- `flutter build web --release --no-pub --no-web-resources-cdn`: passed. JS release output; the compiler's Wasm compatibility dry run also succeeded, but Wasm output was not launched or certified.
- Dependency get/upgrade and official registry outdated audit: all currently resolvable stable versions installed; two SDK-constrained transitive catalog differences documented in README and JSON audit.

Unit fixtures verify comma parsing, unit conversion, half-up rounding, exact large-integer division, package-cost conversion, batch/unit cost, incompatible dimensions, missing materials, zero/negative/NaN/infinite/excess-precision inputs, zero/fractional output, tiny scaled lines and immutable history serialization.

Controller fixtures verify save/reload, persisted language, saved batch history, current-price changes versus historical cost, safe deletion, incompatible ingredient edits, write failure retaining data, load failure blocking ordinary overwrite and backup reference/schema/type/ID validation.

Widget flows verify empty states, optional example, formula creation/editing, ingredient creation, guarded deletion, invalid/valid scale, batch recording, language preservation, failed-load recovery, invalid backup rejection, explicit valid recovery confirmation, and a 320 × 900 viewport with 150% text plus labelled tap targets.

## Browser observations

The compiled application was opened in a real browser at a 1280 × 720 desktop viewport and a 390 × 844 mobile viewport. Enabled Flutter accessibility semantics and verified navigation and readable content. The synthetic reference batch was scaled by 1.5: 1500 g base, 15 wrapping units, 15 output products, R$60.00 batch cost and R$4.00 per product. After recording and reloading, the workspace still contained two ingredients, one formula and one historical batch. Switching PT-BR to EN retained all records. Narrow navigation and the history view were inspected visually.

Captured images in `screenshots/` are real browser captures using synthetic data; they are not generated UI mockups or device-test claims. The standalone SVG cover is conceptual artwork. GitHub description and eight topics were updated and visually verified separately.

## Coverage and review

LCOV line coverage from the 15 tests: domain 228/229 (99.6%); controller 51/51 (100%); local preferences adapter 0/9; app UI 470/560 (83.9%); editors 301/342 (88.0%); flags 42/44 (95.5%). Coverage is evidence of exercised lines, not proof that every possible combination is correct. The actual Web storage adapter was checked through browser persistence, not through a mocked platform integration test. Remaining UI branches include clipboard failure and some dialog cancellation/storage failures. Native preferences implementations were not exercised.

Self-review focused on domain invariants, immutable history, storage failures, untrusted JSON, dimension safety, overflow-safe arithmetic and separation from chemistry. No outstanding critical/high findings were identified in that review. Known limitations remain explicit below. Crapper, dryer and mutator tools referenced by the requested working approach were not available in this session; no such scores or mutation testing results are claimed.

## Known limits and unverified behavior

- No native Android/iOS build, emulator, simulator, physical device, signing or store submission. Native files received an incremental migration only; old launch assets and identifiers remain.
- No complete screen-reader assistive-technology audit or physical mobile keyboard/browser testing; semantics and labelled targets were inspected/tested.
- No encrypted storage, server auth, backend, multi-user/multi-tab synchronization, Firebase emulators or production data access. Firebase was removed from the active path.
- Local preferences is not an archival database. Browser eviction/quota and crash durability follow platform behavior. Export JSON backups; use a single editing tab.
- Product management is a formula product description/yield view. No separate SKU, stock level, inventory consumption, sales or purchase history ledger.
- Chemistry, regulatory claims, recipe safety, labor, loss, overhead and taxes are outside scope. Historical line costs and quantities are copied; original supplier quotations are not separate retained audit documents.
- Medium: no matching user-owned article/editorial destination identified; concrete teaching revision prepared, not published.

CI is defined separately and must be assessed by its actual GitHub run. Local success does not imply a CI or deployment outcome.
