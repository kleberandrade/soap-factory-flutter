# Modernization work log

## 2026-11-17

1. Read root AGENTS, shared modernization standard and requested reduced-principles workflow. Checked the expected checkout; none existed. Cloned the authorized repository, verified clean status and origin before editing.
2. Inspected source, manifest, lockfile, native hosts, Git history and original README. Found a login prototype, empty home page, duplicate invalid legacy lockfile entries and no implemented chemistry or management model. Preserved original README and all team/institutional credits.
3. Selected current stable Flutter 3.50.0 / Dart 3.14.0 from official release documentation. Created an isolated copy-on-write SDK/cache; did not change the shared SDK or accept mobile SDK legal terms.
4. Authored independent domain expectations before implementation. Initial attempts hit telemetry permissions and local test-socket restrictions; suppressed telemetry and used approved local test execution. Confirmed missing-domain compilation failure, then implemented integer unit/scale/cost rules and obtained passing domain tests.
5. Removed obsolete login-only Firebase/social/MobX code and dependencies from the active path; original authorship/source remain in history. Added a replaceable local repository and explicit local-mode UI instead of fake sign-in.
6. Implemented ingredients, formula product/yield management, compatible unit selection, deterministic previews and immutable history. Added language persistence, guarded deletes, backup export/restore, failed-write protection and failed-load recovery.
7. Updated to current standalone Material UI imports/localizations after the analyzer identified the deprecated framework import. Rebuilt the lockfile after Web scaffolding and upgraded the remaining resolvable transitive dependency. Recorded the two SDK constraints in the dependency audit.
8. Added current Web scaffolding. Automatic review rejected deleting/regenerating the entire Android/iOS trees because of configuration-loss risk. Used a safer incremental migration of Gradle, manifest and iOS deployment settings instead; no native-build claim is made. No work remains dependent on that rejected replacement.
9. Tested and corrected real UI issues: a desktop brand overflow, hidden ListTile ink effects and a narrow layout with larger text. Added behavioral controller/widget and backup recovery tests. All 15 tests now pass, alongside clean analysis and a release Web build, run sequentially.
10. Inspected the compiled application in a real browser at desktop/mobile viewport sizes, recorded a synthetic scaled batch, reloaded to check actual browser persistence, switched languages without losing data, and captured current screenshots. Added a locally authored conceptual cover and original bubble icons.
11. Preserved the original MIT copyright/grant as LICENSE; wrote English README, architecture/rule glossary, contribution guide, changelog, validation/limits and a concrete lesson with exactly five final exercises.
12. Searched the repository and public Medium results for a linked user-owned lesson. No target URL/editorial destination was found. Saved the teaching revision and exact blocker; did not publish, create a replacement article or send newsletters.
13. The GitHub connector did not expose description/topics editing, so used the authenticated browser to update and verify the description and eight relevant topics. No public app host, service, store, release or package publication was created.

The final delivery records the commits, push and actual verification status. Crapper/dryer/mutator tools were unavailable; their results are not claimed. No other checkouts or uncommitted user work were removed.

## Delivery status

Implementation committed as `8b5029a`; documentation/credits committed as `c809562`. Attempted `git push origin master` only after the checks and browser inspection were complete. Automatic approval review rejected the push because the trusted modernization request did not explicitly authorize changing the remote default branch. No workaround was attempted. The commits remain local and ready for explicit push approval. GitHub description/topics changes were separately authorized and completed; application hosting, stores, packages and production backend were not deployed. CI has not run for these unpushed commits.
