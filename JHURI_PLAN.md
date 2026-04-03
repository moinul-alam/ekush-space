# JHURI_PLAN.md
# Ekush Labs — Jhuri Development Execution Plan
#
# This file contains the complete phase-by-phase execution plan for building Jhuri.
# It is the operational companion to the Jhuri Development Constitution (Doc 2).
#
# IMPORTANT DISTINCTION:
# - Doc 2 (Constitution) = the what and the why — product decisions, architecture, specs. Never modified.
# - This file (Plan) = the how and the when — Windsurf prompts, gates, session workflow.
#
# HOW TO USE:
# 1. At the start of every new Claude session, paste JHURI_STATUS.md first, then attach Doc 2.
# 2. Copy the prompt for the current phase to Windsurf exactly as written.
# 3. Paste Windsurf's full output back to Claude for gate review before proceeding.
# 4. Only proceed to the next phase after Claude confirms the gate passes.
# 5. Windsurf updates JHURI_STATUS.md before the commit at the end of every phase.

---

## Pre-Development Checklist (Before Phase 1)

⚠ All items below must be done before Windsurf writes a single Flutter file.

- [x] Doc 1 (Restoration Guide) fully executed and committed
- [ ] Create `jhuri` branch off main: `git checkout -b jhuri`
- [ ] Generate 5 category images (AI, consistent style, 256×256px PNG)
- [ ] Generate 25 item icons (AI, batched by category, 256×256px PNG)
- [ ] Complete items_seed.json with all MVP items, defaults, and exact iconIdentifier values
- [ ] Verify icon file names match iconIdentifier values exactly before committing assets
- [ ] Create Jhuri AdMob IDs and store in personal cloud — never commit to repo
- [ ] Confirm Ekush Ponji APK builds clean (final pre-work safety check)

---

## Phase 1 — Monorepo Foundation (Drift + ekush_models + ekush_core)

**Goal: Drift is wired into the monorepo. Basic CRUD works. Zero UI.**

Tasks:
- Add Drift table definitions to ekush_models (all 4 tables: ShoppingLists, ListItems, ItemTemplates, Categories)
- Add DatabaseInitializer base class to ekush_core
- Add base repository pattern to ekush_core
- Create apps/jhuri/ Flutter module — pubspec.yaml with drift_flutter and all ekush_* packages
- Add to melos.yaml workspace
- Run build_runner to generate .g.dart files
- Write a smoke test (no UI): create list → add item → fetch by listId → verify

**Definition of Done**

✔ melos run analyze → zero issues across all packages
✔ flutter analyze apps/ekush_ponji → zero issues (Ponji untouched)
✔ Smoke test passes
✔ JHURI_STATUS.md updated
✔ Committed: 'feat(jhuri): Phase 1 — Drift foundation wired into monorepo'

---

### WINDSURF PROMPT — PHASE 1

```
IMPORTANT: You are working in the ekush-space monorepo at E:\App\ekush-space.
Do not reference the old ekush-ponji repository.
Active branch: jhuri

Start by reading these files — do not write any code until you have read all of them:
- JHURI_STATUS.md (current phase status and any notes from previous sessions)
- apps/ekush_ponji/lib/main.dart (Riverpod setup pattern)
- apps/ekush_ponji/pubspec.yaml (dependency pattern)
- packages/ekush_core/lib/ekush_core.dart (existing exports)
- packages/ekush_models/lib/ekush_models.dart (currently blank — single comment line)
- melos.yaml (workspace structure)

Task: Wire Drift into the monorepo as the shared database infrastructure.
Follow the architecture and patterns you observe in Ekush Ponji exactly.
Refer to the Jhuri Development Constitution for all table schemas and architectural decisions.

CRITICAL ARCHITECTURAL RULE — learned from a previous failed experiment:
- ekush_models depends on Drift — correct.
- ekush_core depends on ekush_models — FORBIDDEN. This was the exact mistake made before.
- ekush_core must have zero dependency on ekush_models in pubspec.yaml.
- The DatabaseInitializer base class in ekush_core must not import anything from ekush_models.
- The Jhuri app layer (apps/jhuri) is the only place that wires ekush_core + ekush_models together.
If you find yourself needing to import ekush_models inside ekush_core, stop and report — do not proceed.

Do not build any UI. This phase is data layer only.

End of session — in this exact order:
1. Run: melos run analyze — report full output
2. Run: flutter analyze apps/ekush_ponji — report full output
3. Both must return zero issues before this phase is done.
4. Update JHURI_STATUS.md to reflect Phase 1 complete, last commit message, and what Phase 2 must do.
5. Commit: 'feat(jhuri): Phase 1 — Drift foundation wired into monorepo'

Verify that shared dependencies remain compatible with existing apps in the monorepo.
If a conflict with Ekush Ponji is detected, do not apply changes; report immediately.
```

---

## Phase 2 — App Shell + Navigation + Theme

**Goal: Jhuri launches, shows a screen, navigation works, Jhuri theme applied.**

Tasks:
- main.dart: ProviderScope, Drift init, SharedPreferences init, theme setup
- JhuriBaseScreen extending BaseScreen from ekush_core
- JhuriLocalizations implementing AppLocalizations — all MVP strings in both Bangla and English
- JhuriConstants file with all constants from Constitution Section 11
- App router setup (go_router or Navigator 2.0 following Ponji pattern)
- Jhuri theme registered (colours, typography from Constitution Section 4)
- Onboarding flow — 3 screens, sets onboardingComplete in SharedPreferences
- Home screen shell (empty state only, no real data yet)

**Definition of Done**

✔ App launches on device/emulator
✔ Onboarding flows through all 3 screens
✔ Home screen shows empty state
✔ Theme colours visible and correct
✔ melos run analyze → zero issues
✔ JHURI_STATUS.md updated
✔ Committed: 'feat(jhuri): Phase 2 — app shell, theme, navigation, onboarding'

---

### WINDSURF PROMPT — PHASE 2

```
IMPORTANT: You are working in the ekush-space monorepo at E:\App\ekush-space.
Do not reference the old ekush-ponji repository.
Active branch: jhuri

Start by reading these files — do not write any code until you have read all of them:
- JHURI_STATUS.md (current phase status and any notes from previous sessions)
- apps/ekush_ponji/lib/main.dart
- apps/ekush_ponji/lib/l10n/ponji_localizations.dart
- apps/ekush_ponji/lib/config/ponji_constants.dart
- apps/ekush_ponji/lib/features/onboarding/ (entire folder)
- packages/ekush_core/lib/ (entire package)
- packages/ekush_theme/lib/ (entire package)

Task: Build the Jhuri app shell. Follow Ponji's patterns exactly for:
main.dart structure, base screen, localizations, constants, and routing.
Refer to the Jhuri Development Constitution for all Jhuri-specific values
(colours, strings, constants, screen specs).

Do not build any real data features yet. Home screen shows empty state only.
Do not modify anything in apps/ekush_ponji/ or any shared package interface.

End of session — in this exact order:
1. Run: melos run analyze — report full output
2. Run: flutter analyze apps/ekush_ponji — report full output
3. App must launch and onboarding must complete on a physical device or emulator.
4. Both analyze commands must return zero issues before this phase is done.
5. Update JHURI_STATUS.md to reflect Phase 2 complete, last commit message, and what Phase 3 must do.
6. Commit: 'feat(jhuri): Phase 2 — app shell, theme, navigation, onboarding'

Verify that shared dependencies remain compatible with existing apps in the monorepo.
If a conflict with Ekush Ponji is detected, do not apply changes; report immediately.
```

---

## Phase 3 — Core Loop (Home + Create List + Item Picker + Shopping Mode)

**Goal: The 20-second list creation flow works end-to-end. This is the heart of the app.**

Tasks:
- Seed items_seed.json into Drift on first launch (gated by onboardingComplete flag)
- Home screen — real data, list cards, date grouping, empty state
- Create/Edit List screen — bottom sheet, all fields, reminder toggle
- Category Browser — grid of category cards with images
- Item Picker — grid of items, quantity bottom sheet, unit chips, add to list
- Custom item form
- Shopping Mode — checklist, progress bar, mark bought animation
- Completion animation — confetti, overlay, auto-archive
- List management — long press context menu, swipe gestures, duplicate flow

**Definition of Done**

✔ Complete flow: new list → browse category → select items → shopping mode → all bought → archived
✔ Duplicate list flow works
✔ Custom item creation and reuse works
✔ melos run analyze → zero issues
✔ JHURI_STATUS.md updated
✔ Committed: 'feat(jhuri): Phase 3 — core loop complete'

---

### WINDSURF PROMPT — PHASE 3

```
IMPORTANT: You are working in the ekush-space monorepo at E:\App\ekush-space.
Do not reference the old ekush-ponji repository.
Active branch: jhuri

Start by reading these files — do not write any code until you have read all of them:
- JHURI_STATUS.md (current phase status and any notes from previous sessions)
- apps/ekush_ponji/lib/features/ (study the full MVVM feature folder structure)
- packages/ekush_models/lib/ (Drift tables wired in Phase 1)
- packages/ekush_core/lib/ (base repository, base screen)
- apps/jhuri/lib/ (everything built in Phase 2)

Task: Build the Jhuri core loop as specified in the Development Constitution Section 8 (screens).
Follow Ponji's MVVM feature folder structure exactly.
One folder per feature. Screen → ViewModel → Repository → Drift.
No business logic inside widgets — everything through ViewModel.

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
5. Update JHURI_STATUS.md to reflect Phase 3 complete, last commit message, and what Phase 4 must do.
6. Commit: 'feat(jhuri): Phase 3 — core loop complete'

Verify that shared dependencies remain compatible with existing apps in the monorepo.
If a conflict with Ekush Ponji is detected, do not apply changes; report immediately.
```

---

## Phase 4 — Settings + Notifications + Share

**Goal: Supporting features complete. App is functionally whole.**

Tasks:
- Settings screen — all sections from Constitution Section 8.8
- Theme switching (light/dark/system) — live update without restart
- Language switching — Bangla/English live update
- Notification scheduling via ekush_notifications — reminder per list
- Cancel notification on list delete
- Share as image via ekush_share — card spec from Constitution Section 8.7

**Definition of Done**

✔ Settings changes apply immediately
✔ Reminder notification fires at correct time, deep links to list
✔ Share card generates and shares correctly
✔ melos run analyze → zero issues
✔ JHURI_STATUS.md updated
✔ Committed: 'feat(jhuri): Phase 4 — settings, notifications, share'

---

### WINDSURF PROMPT — PHASE 4

```
IMPORTANT: You are working in the ekush-space monorepo at E:\App\ekush-space.
Do not reference the old ekush-ponji repository.
Active branch: jhuri

Start by reading these files — do not write any code until you have read all of them:
- JHURI_STATUS.md (current phase status and any notes from previous sessions)
- apps/ekush_ponji/lib/features/settings/ (settings pattern)
- packages/ekush_notifications/lib/ (notification service API)
- packages/ekush_share/lib/ (share service API)
- apps/jhuri/lib/ (everything built so far)

Task: Build Settings screen, notification scheduling, and share-as-image.
Follow Ponji's patterns exactly.
Refer to Constitution Section 8.7 (share card spec), Section 8.8 (settings screen), and Section 10 (notification spec).

Do not modify anything in apps/ekush_ponji/ or any shared package interface.

End of session — in this exact order:
1. Run: melos run analyze — report full output
2. Run: flutter analyze apps/ekush_ponji — report full output
3. Both must return zero issues before this phase is done.
4. Update JHURI_STATUS.md to reflect Phase 4 complete, last commit message, and what Phase 5 must do.
5. Commit: 'feat(jhuri): Phase 4 — settings, notifications, share'

Verify that shared dependencies remain compatible with existing apps in the monorepo.
If a conflict with Ekush Ponji is detected, do not apply changes; report immediately.
```

---

## Phase 5 — Ads Integration

**Goal: AdMob wired in. All ad placements active per Constitution Section 9.**

Tasks:
- EkushAdConfig implementation for Jhuri with Jhuri AdMob IDs (from personal cloud)
- Banner ads: Home screen bottom, Shopping Mode bottom
- Interstitial: after list save, after share
- Session cap and interval logic (via lastInterstitialShown in SharedPreferences)

**Definition of Done**

✔ Banners visible on correct screens
✔ Interstitial fires after list save (respecting session cap and interval)
✔ melos run analyze → zero issues
✔ JHURI_STATUS.md updated
✔ Committed: 'feat(jhuri): Phase 5 — ads integration'

---

### WINDSURF PROMPT — PHASE 5

```
IMPORTANT: You are working in the ekush-space monorepo at E:\App\ekush-space.
Do not reference the old ekush-ponji repository.
Active branch: jhuri

Start by reading these files — do not write any code until you have read all of them:
- JHURI_STATUS.md (current phase status and any notes from previous sessions)
- packages/ekush_ads/lib/ (EkushAdConfig pattern)
- apps/ekush_ponji/lib/main.dart (how Ponji wires ad config)
- apps/ekush_ponji/ (how Ponji places banners and interstitials)
- apps/jhuri/lib/ (everything built so far)

Task: Wire AdMob into Jhuri following the EkushAdConfig pattern exactly.
Ad placement rules are in Constitution Section 9.
AdMob IDs will be provided separately — use test placeholder IDs for this build.

Do not modify anything in apps/ekush_ponji/ or any shared package interface.

End of session — in this exact order:
1. Run: melos run analyze — report full output
2. Run: flutter analyze apps/ekush_ponji — report full output
3. Both must return zero issues before this phase is done.
4. Update JHURI_STATUS.md to reflect Phase 5 complete, last commit message, and what Phase 6 must do.
5. Commit: 'feat(jhuri): Phase 5 — ads integration'

Verify that shared dependencies remain compatible with existing apps in the monorepo.
If a conflict with Ekush Ponji is detected, do not apply changes; report immediately.
```

---

## Phase 6 — Polish + Play Store Submission

**Goal: App is release-quality. Submitted to Play Store internal testing.**

Tasks:
- Replace all placeholder icons with final AI-generated assets
- Expand item library to full MVP set (5 categories × 5 items minimum)
- App icon and splash screen finalized
- Review all Bangla strings for correctness and naturalness
- Test all edge cases from Constitution Section 12
- flutter build appbundle --release
- Submit to Play Store internal testing track

**Definition of Done**

✔ Release APK/AAB builds without errors
✔ All edge cases handled and tested
✔ Submitted to Play Console internal testing
✔ JHURI_STATUS.md updated to reflect v1.0.0 submitted
✔ Committed: 'release(jhuri): v1.0.0 — Play Store submission'

---

### WINDSURF PROMPT — PHASE 6

```
IMPORTANT: You are working in the ekush-space monorepo at E:\App\ekush-space.
Do not reference the old ekush-ponji repository.
Active branch: jhuri

Start by reading these files — do not write any code until you have read all of them:
- JHURI_STATUS.md (current phase status and any notes from previous sessions)
- apps/jhuri/lib/ (everything built so far)
- apps/jhuri/assets/ (verify all icons and images are in place)

Task: Polish and prepare Jhuri for Play Store submission.
Work through these in order:
1. Replace all placeholder icons and images with final AI-generated assets
2. Verify all 25 MVP items are in items_seed.json with correct iconIdentifier values
3. Finalize app icon and splash screen
4. Review every user-facing Bangla string for correctness and natural tone
5. Test every edge case listed in Constitution Section 12 — report results
6. Run: flutter build appbundle --release
   Report full output. Fix any build errors before proceeding.

Do not modify anything in apps/ekush_ponji/ or any shared package interface.

End of session — in this exact order:
1. Run: melos run analyze — report full output
2. Run: flutter analyze apps/ekush_ponji — report full output
3. Run: flutter build appbundle --release — report full output
4. All three must pass before this phase is done.
5. Update JHURI_STATUS.md to reflect v1.0.0 ready, build status, and submission status.
6. Commit: 'release(jhuri): v1.0.0 — Play Store submission'

Verify that shared dependencies remain compatible with existing apps in the monorepo.
If a conflict with Ekush Ponji is detected, do not apply changes; report immediately.
```

---

## Claude + Windsurf Collaboration Protocol

This is how every phase works. Follow this without deviation.

**Before sending a prompt to Windsurf:**
- Paste JHURI_STATUS.md to Claude first
- Attach Doc 2 (Constitution)
- Ask Claude to review the phase prompt if anything unexpected has come up
- Claude confirms it is safe to proceed

**After Windsurf completes a phase:**
- Paste Windsurf's full output to Claude
- Claude reviews the output and confirms the gate passes or flags issues
- Only commit after Claude confirms
- Never proceed to the next phase without Claude's go-ahead

**If Windsurf raises an alarm mid-session:**
- Stop Windsurf
- Paste the alarm to Claude
- Wait for instruction — do not let Windsurf improvise

**One phase per Windsurf session. Never mix phases.**

---

## Gate Summary

| Phase | Analyze Gate | Ponji Gate | Extra Gate |
|---|---|---|---|
| Phase 1 | melos run analyze → zero issues | flutter analyze ekush_ponji → zero issues | Smoke test passes |
| Phase 2 | melos run analyze → zero issues | flutter analyze ekush_ponji → zero issues | App launches on device |
| Phase 3 | melos run analyze → zero issues | flutter analyze ekush_ponji → zero issues | Full flow works on device |
| Phase 4 | melos run analyze → zero issues | flutter analyze ekush_ponji → zero issues | Notification fires, share works |
| Phase 5 | melos run analyze → zero issues | flutter analyze ekush_ponji → zero issues | Banners and interstitial fire correctly |
| Phase 6 | melos run analyze → zero issues | flutter analyze ekush_ponji → zero issues | Release AAB builds clean |

---

*This file does not replace Doc 2. It operationalises it.*
*Doc 2 is the authority on all product and architecture decisions.*
*When in doubt, Doc 2 wins.*
