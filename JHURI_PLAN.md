# JHURI_PLAN.md
# Ekush Labs — Jhuri Execution Plan
# Prompts + Usage Instructions
#
# ─────────────────────────────────────────────────────────────
# HOW TO USE THIS FILE
# ─────────────────────────────────────────────────────────────
#
# This file contains one Windsurf prompt per development phase.
# It is the only file you open when starting a Windsurf session.
# Do not attach this file to Claude — it is not context, it is a prompt source.
#
# EVERY SESSION FOLLOWS THIS LOOP:
#
#   1. Open new Claude chat
#      → Paste JHURI_STATUS.md (the memory bridge)
#      → Attach JHURI_CONST.md (the constitution — all decisions live there)
#      → Tell Claude which phase you are starting
#      → Claude confirms it is safe to proceed
#
#   2. Open Windsurf
#      → Copy the prompt for the current phase from this file
#      → Paste it into Windsurf exactly as written
#      → Do not modify the prompt before pasting
#
#   3. Windsurf executes the phase
#      → You watch but do not intervene unless Windsurf raises an alarm
#      → If Windsurf stops and reports an unexpected problem: stop, paste the alarm to Claude, wait for instruction
#      → Never let Windsurf improvise or continue past an alarm without Claude's go-ahead
#
#   4. Paste Windsurf's full output to Claude
#      → Claude reviews the output
#      → Claude confirms the gate passes or flags issues
#      → Only commit after Claude confirms
#      → Never proceed to the next phase without Claude's go-ahead
#
#   5. Windsurf updates JHURI_STATUS.md and commits
#      → Commit message is specified at the end of each prompt
#      → One commit per phase — never bundle phases
#
# IF CLAUDE SESSION LIMIT HITS MID-PHASE:
#   → Tell Windsurf to stop immediately
#   → Run analyze — if clean, commit with message: wip(jhuri): Phase N partial — [where you stopped]
#   → Update JHURI_STATUS.md manually with exactly where you stopped and what decisions were made
#   → Wait for Claude limit to reset, start new session with JHURI_STATUS.md + JHURI_CONST.md
#
# IF A PONJI BUG FIX IS NEEDED DURING JHURI DEVELOPMENT:
#   → Stop the Jhuri session cleanly — commit or stash what exists
#   → git checkout main → git checkout -b ponji-fix-[description]
#   → Fix, test, merge to main
#   → git checkout jhuri → continue
#   → Never fix Ponji on the jhuri branch
#
# ─────────────────────────────────────────────────────────────
# GATE SUMMARY
# ─────────────────────────────────────────────────────────────
#
# | Phase | Analyze Gate                    | Ponji Gate                              | Extra Gate                        |
# |-------|---------------------------------|-----------------------------------------|-----------------------------------|
# | 1     | melos run analyze → zero issues | flutter analyze ekush_ponji → zero issues | Smoke test passes                 |
# | 2     | melos run analyze → zero issues | flutter analyze ekush_ponji → zero issues | App launches on device            |
# | 3     | melos run analyze → zero issues | flutter analyze ekush_ponji → zero issues | Full flow works on device         |
# | 4     | melos run analyze → zero issues | flutter analyze ekush_ponji → zero issues | Notification fires, share works   |
# | 5     | melos run analyze → zero issues | flutter analyze ekush_ponji → zero issues | Banners and interstitial fire     |
# | 6     | melos run analyze → zero issues | flutter analyze ekush_ponji → zero issues | Release AAB builds clean          |
#
# ─────────────────────────────────────────────────────────────

---

## PHASE 1 — Monorepo Foundation (Drift + ekush_models + ekush_core)

```
IMPORTANT: You are working in the ekush-space monorepo at E:\App\ekush-space.
Do not reference the old ekush-ponji repository.
Active branch: jhuri

Start by reading these files — do not write any code until you have read all of them:
- JHURI_STATUS.md (current phase status and notes from previous sessions)
- JHURI_CONST.md (the development constitution — all architectural decisions)
- apps/ekush_ponji/lib/main.dart (Riverpod setup pattern)
- apps/ekush_ponji/pubspec.yaml (dependency pattern)
- packages/ekush_core/lib/ekush_core.dart (existing exports)
- packages/ekush_models/lib/ekush_models.dart (currently blank — single comment line)
- melos.yaml (workspace structure)

Task: Wire Drift into the monorepo as the shared database infrastructure.
Follow the architecture and patterns you observe in Ekush Ponji exactly.
Refer to JHURI_CONST.md Section 5 for all table schemas.
Refer to JHURI_CONST.md Section 2.4 for infrastructure decisions.
Refer to JHURI_CONST.md Section 3 for architecture pattern.

CRITICAL ARCHITECTURAL RULE — learned from a previous failed experiment:
- ekush_models depends on Drift — correct.
- ekush_core depends on ekush_models — FORBIDDEN. This was the exact mistake made before.
- ekush_core must have zero dependency on ekush_models in pubspec.yaml.
- The DatabaseInitializer base class in ekush_core must not import anything from ekush_models.
- apps/jhuri is the only place that wires ekush_core + ekush_models together.
If you find yourself needing to import ekush_models inside ekush_core, stop and report — do not proceed.

Do not build any UI. This phase is data layer only.

End of session — in this exact order:
1. Run: melos run analyze — report full output
2. Run: flutter analyze apps/ekush_ponji — report full output
3. Both must return zero issues before this phase is done.
4. Update JHURI_STATUS.md: phase complete, last commit message, what Phase 2 must do.
5. Commit: 'feat(jhuri): Phase 1 — Drift foundation wired into monorepo'

Verify that shared dependencies remain compatible with existing apps in the monorepo.
If a conflict with Ekush Ponji is detected, do not apply changes; report immediately.
```

---

## PHASE 2 — App Shell + Navigation + Theme

```
IMPORTANT: You are working in the ekush-space monorepo at E:\App\ekush-space.
Do not reference the old ekush-ponji repository.
Active branch: jhuri

Start by reading these files — do not write any code until you have read all of them:
- JHURI_STATUS.md (current phase status and notes from previous sessions)
- JHURI_CONST.md (the development constitution — all architectural decisions)
- apps/ekush_ponji/lib/main.dart
- apps/ekush_ponji/lib/l10n/ponji_localizations.dart
- apps/ekush_ponji/lib/config/ponji_constants.dart
- apps/ekush_ponji/lib/features/onboarding/ (entire folder)
- packages/ekush_core/lib/ (entire package)
- packages/ekush_theme/lib/ (entire package)

Task: Build the Jhuri app shell. Follow Ponji's patterns exactly for:
main.dart structure, base screen, localizations, constants, and routing.

Refer to JHURI_CONST.md for all Jhuri-specific values:
- Section 4 for colours and typography
- Section 8.1 for onboarding screen specs
- Section 8.2 for home screen empty state spec
- Section 11 for all constants
- Section 16 for localisation rules

Do not build any real data features yet. Home screen shows empty state only.
Do not modify anything in apps/ekush_ponji/ or any shared package interface.

End of session — in this exact order:
1. Run: melos run analyze — report full output
2. Run: flutter analyze apps/ekush_ponji — report full output
3. App must launch and onboarding must complete on a physical device or emulator.
4. Both analyze commands must return zero issues before this phase is done.
5. Update JHURI_STATUS.md: phase complete, last commit message, what Phase 3 must do.
6. Commit: 'feat(jhuri): Phase 2 — app shell, theme, navigation, onboarding'

Verify that shared dependencies remain compatible with existing apps in the monorepo.
If a conflict with Ekush Ponji is detected, do not apply changes; report immediately.
```

---

## PHASE 3 — Core Loop (Home + Create List + Item Picker + Shopping Mode)

```
IMPORTANT: You are working in the ekush-space monorepo at E:\App\ekush-space.
Do not reference the old ekush-ponji repository.
Active branch: jhuri

Start by reading these files — do not write any code until you have read all of them:
- JHURI_STATUS.md (current phase status and notes from previous sessions)
- JHURI_CONST.md (the development constitution — all architectural decisions)
- apps/ekush_ponji/lib/features/ (study the full MVVM feature folder structure)
- packages/ekush_models/lib/ (Drift tables wired in Phase 1)
- packages/ekush_core/lib/ (base repository, base screen)
- apps/jhuri/lib/ (everything built in Phase 2)

Task: Build the Jhuri core loop.
Follow Ponji's MVVM feature folder structure exactly.
One folder per feature. Screen → ViewModel → Repository → Drift.
No business logic inside widgets — everything through ViewModel.

Refer to JHURI_CONST.md for all screen specs and behaviour:
- Section 6 for seed data strategy and items_seed.json structure
- Section 8.2 for Home screen (real data, date grouping, card spec, interactions)
- Section 8.3 for Create/Edit List screen
- Section 8.4 for Category Browser
- Section 8.5 for Item Picker and custom item form
- Section 8.6 for Shopping Mode and completion behaviour
- Section 4.4 for all animations and motion specs
- Section 12 for edge cases that must be handled

Build in this exact order within the session:
1. Seed service (items_seed.json → Drift on first launch)
2. Home screen (real data)
3. Create/Edit List (bottom sheet)
4. Category Browser
5. Item Picker + quantity sheet
6. Shopping Mode

Do not modify anything in apps/ekush_ponji/ or any shared package interface.

End of session — in this exact order:
1. Run: melos run analyze — report full output
2. Run: flutter analyze apps/ekush_ponji — report full output
3. Full flow must work on a physical device or emulator end-to-end.
4. Both analyze commands must return zero issues before this phase is done.
5. Update JHURI_STATUS.md: phase complete, last commit message, what Phase 4 must do.
6. Commit: 'feat(jhuri): Phase 3 — core loop complete'

Verify that shared dependencies remain compatible with existing apps in the monorepo.
If a conflict with Ekush Ponji is detected, do not apply changes; report immediately.
```

---

## PHASE 4 — Settings + Notifications + Share

```
IMPORTANT: You are working in the ekush-space monorepo at E:\App\ekush-space.
Do not reference the old ekush-ponji repository.
Active branch: jhuri

Start by reading these files — do not write any code until you have read all of them:
- JHURI_STATUS.md (current phase status and notes from previous sessions)
- JHURI_CONST.md (the development constitution — all architectural decisions)
- apps/ekush_ponji/lib/features/settings/ (settings pattern)
- packages/ekush_notifications/lib/ (notification service API)
- packages/ekush_share/lib/ (share service API)
- apps/jhuri/lib/ (everything built so far)

Task: Build Settings screen, notification scheduling, and share-as-image.
Follow Ponji's patterns exactly.

Refer to JHURI_CONST.md for all specs:
- Section 8.7 for share card spec
- Section 8.8 for settings screen sections and fields
- Section 10 for notification spec (title, body, trigger, deep link, timezone)
- Section 4.1 for share card colours
- Section 12 for edge cases (notification permission denied, share failure)

Do not modify anything in apps/ekush_ponji/ or any shared package interface.

End of session — in this exact order:
1. Run: melos run analyze — report full output
2. Run: flutter analyze apps/ekush_ponji — report full output
3. Both must return zero issues before this phase is done.
4. Update JHURI_STATUS.md: phase complete, last commit message, what Phase 5 must do.
5. Commit: 'feat(jhuri): Phase 4 — settings, notifications, share'

Verify that shared dependencies remain compatible with existing apps in the monorepo.
If a conflict with Ekush Ponji is detected, do not apply changes; report immediately.
```

---

## PHASE 5 — Ads Integration

```
IMPORTANT: You are working in the ekush-space monorepo at E:\App\ekush-space.
Do not reference the old ekush-ponji repository.
Active branch: jhuri

Start by reading these files — do not write any code until you have read all of them:
- JHURI_STATUS.md (current phase status and notes from previous sessions)
- JHURI_CONST.md (the development constitution — all architectural decisions)
- packages/ekush_ads/lib/ (EkushAdConfig pattern)
- apps/ekush_ponji/lib/main.dart (how Ponji wires ad config)
- apps/ekush_ponji/ (how Ponji places banners and interstitials)
- apps/jhuri/lib/ (everything built so far)

Task: Wire AdMob into Jhuri following the EkushAdConfig pattern exactly.

Refer to JHURI_CONST.md for all ad rules:
- Section 9 for all placement rules and interstitial session logic
- Section 11 for interstitialSessionMax and interstitialMinIntervalMinutes constants
- Section 5.5 for lastInterstitialShown in SharedPreferences

AdMob IDs will be provided separately — use test placeholder IDs for this build.

Do not modify anything in apps/ekush_ponji/ or any shared package interface.

End of session — in this exact order:
1. Run: melos run analyze — report full output
2. Run: flutter analyze apps/ekush_ponji — report full output
3. Both must return zero issues before this phase is done.
4. Update JHURI_STATUS.md: phase complete, last commit message, what Phase 6 must do.
5. Commit: 'feat(jhuri): Phase 5 — ads integration'

Verify that shared dependencies remain compatible with existing apps in the monorepo.
If a conflict with Ekush Ponji is detected, do not apply changes; report immediately.
```

---

## PHASE 6 — Polish + Play Store Submission

```
IMPORTANT: You are working in the ekush-space monorepo at E:\App\ekush-space.
Do not reference the old ekush-ponji repository.
Active branch: jhuri

Start by reading these files — do not write any code until you have read all of them:
- JHURI_STATUS.md (current phase status and notes from previous sessions)
- JHURI_CONST.md (the development constitution — all architectural decisions)
- apps/jhuri/lib/ (everything built so far)
- apps/jhuri/assets/ (verify all icons and images are in place)

Task: Polish and prepare Jhuri for Play Store submission.
Work through these in order:
1. Replace all placeholder icons and images with final AI-generated assets
   Refer to JHURI_CONST.md Section 13 for asset structure and naming conventions
2. Verify all 25 MVP items are in items_seed.json with correct iconIdentifier values
   Refer to JHURI_CONST.md Section 6.3 for the full MVP item list
3. Finalize app icon and splash screen
4. Review every user-facing Bangla string for correctness and natural tone
5. Test every edge case listed in JHURI_CONST.md Section 12 — report results per case
6. Run: flutter build appbundle --release
   Report full output. Fix any build errors before proceeding.

Do not modify anything in apps/ekush_ponji/ or any shared package interface.

End of session — in this exact order:
1. Run: melos run analyze — report full output
2. Run: flutter analyze apps/ekush_ponji — report full output
3. Run: flutter build appbundle --release — report full output
4. All three must pass before this phase is done.
5. Update JHURI_STATUS.md: v1.0.0 ready, build status, submission status.
6. Commit: 'release(jhuri): v1.0.0 — Play Store submission'

Verify that shared dependencies remain compatible with existing apps in the monorepo.
If a conflict with Ekush Ponji is detected, do not apply changes; report immediately.
```
