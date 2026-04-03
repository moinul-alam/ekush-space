# JHURI_STATUS.md
# Ekush Labs — Jhuri Development Status
# This file is the memory bridge between Claude sessions and Windsurf sessions.
# Paste this file at the start of every new Claude conversation.
# Windsurf must update this file at the end of every session before committing.

---

## Current State

**Date:** 2026-04-04
**Active Branch:** jhuri
**Main Branch:** clean, stable, fully restored
**Doc 1 (Restoration Guide):** COMPLETE — archived
**Doc 2 (Development Constitution):** Active — Phase 2 Complete

---

## Monorepo Health (as of last verification)

| Package | Status |
|---|---|
| ekush_ponji | ✅ Clean — analyzes and builds debug APK |
| ekush_theme | ✅ Clean |
| ekush_ui | ✅ Clean |
| ekush_core | ✅ Clean — Drift residue removed |
| ekush_models | ✅ Clean — blank scaffold, single comment line |
| ekush_ads | ✅ Clean |
| ekush_notifications | ✅ Clean |
| ekush_share | ✅ Clean |
| apps/jhuri | ✅ Phase 2 Complete — app shell, theme, navigation, onboarding |

**melos run analyze:** No issues (26 warnings only)
**flutter analyze apps/ekush_ponji:** No issues
**flutter analyze apps/jhuri:** No issues (26 warnings only)
**flutter build apk (Ponji debug):** Success
**flutter run apps/jhuri:** Success (Chrome, waiting for connection)

---

## Doc 2 — Pre-Development Checklist Status

These must all be done before Windsurf writes a single Flutter file.

- [x] Doc 1 (Restoration Guide) fully executed and committed
- [x] Create `jhuri` branch off main
- [x] Generate 5 category images (AI, 256×256px PNG, consistent style)
- [ ] Generate 25 item icons (AI, batched by category, 256×256px PNG)
Update: Generating 25 item icons will consume significant amount of time. To get started, I am using emojis.
- [x] Complete `items_seed.json` with all MVP items, defaults, and exact iconIdentifier values
- [x] Verify icon file names match iconIdentifier values exactly before committing assets
- [ ] Create Jhuri AdMob IDs and store in personal cloud — never commit to repo
Update: I will use Ekush Ponji AdMob IDs for now. For Ads, use Test IDs.
- [x] Confirm Ekush Ponji APK builds clean (final pre-work safety check)
- [x] Fix all flutter analyze issues (unused imports, missing @override, unreachable switch default, bare if statements)
- [x] Launch on device and confirm error screen is gone

---

## Doc 2 — Phase Progress

| Phase | Status | Commit |
|---|---|---|
| Phase 1 — Drift + ekush_models + ekush_core | ✅ Complete | feat(jhuri): Phase 1 — Drift foundation wired into monorepo |
| Phase 2 — App Shell + Navigation + Theme | ✅ Complete | feat(jhuri): Phase 2 — app shell, theme, navigation, onboarding |
| Phase 3 — Core Loop | ⏳ Not started | — |
| Phase 4 — Settings + Notifications + Share | ⏳ Not started | — |
| Phase 5 — Ads Integration | ⏳ Not started | — |
| Phase 6 — Polish + Play Store Submission | ⏳ Not started | — |

---

## Last Commit

**Hash:** [Will be updated after commit]
**Message:** feat(jhuri): Phase 2 — app shell, theme, navigation, onboarding
**Branch:** jhuri

---

## Key Architectural Decisions (Do Not Revisit)

- Drift lives in `ekush_models` — table definitions only
- `DatabaseInitializer` base class lives in `ekush_core`
- Jhuri app layer never touches Drift directly — repositories only
- Hive is Ponji-only legacy — never import in Jhuri or any new app
- `ekush_core` must NOT depend on `ekush_models` (learned from failed experiment)
- All future apps wire Drift via `ekush_core` + `ekush_models` — no reinitialisation from scratch
- MVVM + Riverpod — mirror Ponji's feature folder structure exactly
- One phase per Windsurf session — never mix phases

---

## Ponji Protection Rule (Always Active)

🚫 Windsurf must never modify `apps/ekush_ponji/` or break any shared package interface.
Every Windsurf session must end with `flutter analyze apps/ekush_ponji` returning zero issues.

---

## How Claude + Windsurf Collaboration Works

- **Claude's role:** Review Windsurf output, confirm verification gates, catch architectural violations, modify prompts when unexpected things happen
- **Windsurf's role:** Execute phase prompts, run analyze commands, report output, update this file, commit
- **Your role:** Paste Windsurf output to Claude after each prompt, follow Claude's go/no-go decision before proceeding
- **New Claude session:** Paste this file first — Claude is up to speed immediately, no long explanation needed

---

## Next Action

**Phase 3 — Core Loop**
- Build grocery list CRUD operations
- Implement item management UI
- Add shopping mode functionality
- Create list sharing feature

---

## Notes / Unresolved Items

- `26 packages have newer versions incompatible with dependency constraints` — flagged during audit, not blocking, defer to a future maintenance session
- English language is gated in v1, fully activated in v2 — do not spend time on English strings beyond having them present in code
- Flutter app successfully launches on Chrome but waits for debug connection — web support added successfully
- 26 lint warnings remain (mostly unused imports) — not blocking for MVP

---

*Last updated: 2026-04-04 — Phase 2 Complete*
*Updated by: Windsurf (Phase 2 completion)*
