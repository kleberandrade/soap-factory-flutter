# Architecture and domain rules

## Responsibilities

`lib/domain/workspace.dart` is pure Dart. It defines immutable ingredients, formula lines, formula/product/yield records, cost results and historical batches. Constructors enforce invariants. JSON is parsed at the repository/backup boundary; invalid schemas, types, references and quantities fail as one invalid document.

`lib/data/workspace_repository.dart` exposes `WorkspaceRepository.load/save`. The supplied adapter uses `SharedPreferencesAsync` and one versioned JSON key. A real service can implement this interface without changing cost arithmetic. There is deliberately no authentication facade or cloud fixture adapter.

`lib/application/workspace_controller.dart` handles load/write state and operations. It commits new in-memory state only after a successful awaited write. A failed load blocks normal writes. Explicit, confirmed backup recovery may replace a broken document. A single controller prevents overlapping writes in one app instance.

`lib/ui` contains the app shell, responsive catalogs, editors, backup dialog and locally painted flags. Desktop uses a sidebar; narrow screens use bottom navigation and a local-mode notice. Product name and yield belong to a formula: the Products view is a view of those records, not a separate stock, sales or SKU ledger.

## Glossary

- Ingredient: a purchased material with a package amount, package unit and BRL package price. Packaging can be counted as an ingredient.
- Formula: a named reference composition, linked product description and whole output count.
- Batch: a recorded arithmetic projection with timestamp, copied formula/product names and immutable cost/quantity lines. It does not certify actual production or consume inventory.
- Package quantity: how much material the stated price purchases; it is not current stock.
- Multiplier: thousandths of a reference batch, e.g. 1.5 is stored as 1500.

## Exact arithmetic

Amounts are integers representing thousandths of the displayed unit. Input accepts dot or comma as decimal separator, no thousands separator, at most three decimals. Money is integer BRL cents, at most two decimals. Price zero is allowed; amount zero is rejected.

Conversions use three dimensions: mass (`g`, `kg`, factor 1000), volume (`mL`, `L`, factor 1000), and count (`un`). No density is assumed. Counts must be whole, including after scale. Labels are 1–100 trimmed characters. A formula has 1–100 unique ingredients and an integer yield of 1–1,000,000 products.

1. Scaled line amount = reference amount × multiplier / 1000, rounded half up to the nearest thousandth of the line's unit.
2. Line cost in cents = package cents × scaled line base amount / package base amount, rounded half up to a cent.
3. Batch cost = sum of rounded line costs. There is no alternate hidden total rounding.
4. Unit cost = batch cents / whole output count, rounded half up. Multiplying the displayed unit cost back by yield can differ from the batch total.

Multiplication and division use `BigInt` intermediates for consistent Dart VM and JavaScript behavior. No binary decimal parsing or floating-point cost multiplication is used. Formatting money uses two decimal digits; currency remains BRL in both languages.

Independent fixture: R$20.50 per 1 kg, 500 g per 10 products, scale 1.5: 750 g, R$15.375 unrounded, R$15.38 line/batch, 15 products, R$1.03 displayed per product. This fixture is arithmetic, not a soap recipe.

## Limits and rounding boundaries

An entered or scaled line quantity is >0 and ≤1,000,000 displayed units. A scaled line that rounds to zero fails. Scale is >0 and ≤1,000, with up to three decimals. Scale must yield a whole number of products ≤1,000,000. Count materials must remain whole. A price or individual line cost is at most 1,000,000,000 cents (the price input allows at most seven whole digits). Base conversion can reach 10^12 integer thousandths; intermediates use BigInt.

A workspace has ≤1,000 ingredients, ≤1,000 formulas and ≤5,000 batches. Saved/imported JSON is limited to 5,000,000 characters; actual browser quotas can be lower. Operations that exceed these limits fail visibly and preserve the previous in-memory state. Formula validation recalculates at scale 1, so incompatible ingredient edits are rejected before saving.

## Persistence and trust boundaries

Web data belongs to the browser profile and exact origin (scheme, host and port). Changing port, clearing site data, private browsing and browser eviction can remove access. Shared preferences is convenience persistence, not a secure database or durable archival system. Export backups regularly. No encryption or cross-tab conflict coordination is provided; use one open editing tab. A later tab write can overwrite an earlier tab's document. A crash during a storage operation has the platform's storage guarantees, not a database transaction guarantee.

Backup schema 1 stores the entire workspace and language. Restore validates everything before an explicit replace confirmation. Backups are untrusted input, not executable content. Restoring does not merge records. History intentionally survives ingredient price changes and formula deletion. Historical snapshots include scaled amount, unit, copied ingredient name, rounded cost, multiplier and yield; original package quotations are not retained as separate audit documents.

## Chemistry boundary

There is no chemical calculation in the original active management implementation to preserve. Neither the original authentication prototype nor this revision supplies validated SAP fixtures. No lye, SAP index, superfat, water ratio, curing time, process instruction or safety claim is generated. User-entered formulas and the synthetic sample are not certified recipes. Labor, waste, taxes, stock depletion and selling-price recommendations are outside the cost model.
