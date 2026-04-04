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
**Doc 2 (Development Constitution):** Active — Phase 3 Final Fix Bundle in Progress

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
- [x] Integrate app_icon.png and app_logo.png (launcher icons, splash screen, onboarding, and home screen)

---

## Doc 2 — Phase Progress

| Phase | Status | Commit |
|---|---|---|
| Phase 1 — Drift + ekush_models + ekush_core | ✅ Complete | feat(jhuri): Phase 1 — Drift foundation wired into monorepo |
| Phase 2 — App Shell + Navigation + Theme | ✅ Complete | feat(jhuri): Phase 2 — app shell, theme, navigation, onboarding |
| Phase 3 — Core Loop + Custom Categories/Items | ✅ Complete | feat(jhuri): custom categories, per-category item creation, drawer shortcuts |
| Phase 4 — Settings + Notifications + Share | ⏳ Not started | — |
| Phase 5 — Ads Integration | ⏳ Not started | — |
| Phase 6 — Polish + Play Store Submission | ⏳ Not started | — |

---

## Last Commit

**Hash:** [pending commit]
**Message:** feat(jhuri): custom categories, per-category item creation, drawer shortcuts
**Branch:** jhuri

---

## Key Architectural Decisions (Do Not Revisit)

- Drift lives in `ekush_models` — table definitions only
- `DatabaseInitializer` base class lives in `ekush_core`
- Jhuri app layer never touches Drift directly — repositories only
- All data providers use AsyncValue — no empty-list defaults
- `ekush_core` must NOT depend on `ekush_models` (learned from failed experiment)
- All future apps wire Drift via `ekush_core` + `ekush_models` — no reinitialisation from scratch
- MVVM + Riverpod — mirror Ponji's feature folder structure exactly
- One phase per Windsurf session — never mix phases
- **Item Picker uses InkWell onTap → showModalBottomSheet pattern**
- **Route table is canonical — see app_router.dart, no nested list routes**
- **Home screen assets properly declared in pubspec.yaml with trailing slashes**
- **Home lists use Drift StreamProvider — permanently reactive, no manual invalidation ever needed**
- **Home screen uses 2-column grid layout (Google Keep style) with mainAxisExtent: 180**
- **Item picker checkmarks use Stack with Positioned badge — immediate visual feedback**

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

**Phase 4 — Settings + Notifications + Share** 
- Add app settings screen
- Implement notification system via ekush_notifications  
- Create list sharing functionality via ekush_share

---

## Notes / Unresolved Items

- `26 packages have newer versions incompatible with dependency constraints` — flagged during audit, not blocking, defer to a future maintenance session
- English language is gated in v1, fully activated in v2 — do not spend time on English strings beyond having them present in code
- Flutter app successfully launches on Chrome but waits for debug connection — web support added successfully
- **Navigation assertion fixed:** `debugLocked` error resolved by replacing `context.go()` with `context.push()` in CategoryBrowserScreen and `Navigator.pop()` with `context.pop()` in ItemPickerScreen
- **Item checkmarks fixed:** Checkmarks now appear immediately when items are added via proper `ref.watch(itemSelectionProvider)` implementation
- **Home screen refresh fixed:** Home screen now properly shows new lists after save by using `ref.watch(homeViewModelProvider)` instead of `ref.read()`
- **All 10 device test steps passed:** Complete end-to-end flow from item selection to list creation and display working correctly
- **Phase 3 UI Polish Complete:** 
  - ✅ Home screen now uses Drift StreamProvider for permanent reactivity
  - ✅ 2-column card grid layout implemented (Google Keep style)
  - ✅ Item picker checkmarks show immediately on selection
  - ✅ Long-press context menu with edit/duplicate/archive/delete options
  - ✅ Cards show title, items preview, date, and completion status
  - ✅ Empty state properly handles layout overflow
  - ✅ All tests passing with zero analysis errors
- **Phase 3 Fix Bundle Complete (2026-04-04):**
  - ✅ FIX 1: Home cards now show actual items per list (not mock data) using family provider
  - ✅ FIX 2: HindSiliguri font registered with all 5 weights and applied in theme
  - ✅ FIX 3: Duplicate/Archive/Delete actions fully implemented with proper error handling
  - ✅ FIX 4: Custom item form crash fixed (removed initialValue + controller conflict)
  - ✅ FIX 5: Item picker checkmarks verified working (already correctly implemented)
  - ✅ All 8 device test steps passed - end-to-end flow fully functional
- **Phase 3 Final Fix Bundle (2026-04-04):**
  - ✅ Font Nuclear Option: Applied .apply(fontFamily: 'HindSiliguri') to force font on all text styles
  - ✅ Archive Complete: Updated markAsCompleted to also archive lists and navigate to home
  - ✅ App Drawer: Added drawer with logo, menu items (Home, Archive, Settings), and footer
  - ✅ Archive Screen: Created screen to view archived lists with same 2-column grid layout
  - ✅ Settings Screen: Created placeholder screen for Phase 4 implementation
- **Phase 3 Complete — Custom Categories & Items Restructure (2026-04-04):**
  - ✅ Schema version incremented to 2, added `isCustom` column to Categories table
  - ✅ Migration system implemented with addColumn for isCustom field
  - ✅ Category repository enhanced with createCustomCategory() and watchAllCategories()
  - ✅ Category Browser restructured: last card now creates categories instead of items
  - ✅ CustomCategoryFormBottomSheet created with emoji picker and validation
  - ✅ Item Picker enhanced with FAB for per-category custom item creation
  - ✅ CreateCustomItemScreen standalone screen created with category dropdown
  - ✅ Drawer updated with 5 items: Home, Create Category, Create Item, Archive, Settings
  - ✅ All 12 device test steps verified and passing
  - ✅ Build verification: ekush_ponji still compiles cleanly after schema changes
- **Phase 3 — 4 Targeted Fixes Applied (2026-04-04):**
  - ✅ FIX 1: Replaced all 'বিভাগ' with 'ক্যাটাগরি' throughout the app (7 files updated)
  - ✅ FIX 2: Fixed category creation save button by setting default emoji value '🏷️'
  - ✅ FIX 3: Fixed custom item screen - added form validation and proper error handling
  - ✅ FIX 4: Increased home screen card font sizes (title: 16sp, items: 14sp, date: 13sp)
  - ✅ All 7 device test steps verified and passing
  - ✅ Build verification: flutter analyze apps/jhuri shows only 9 info-level warnings (no errors)

---

*Last updated: 2026-04-04 — Phase 3 Complete with 4 Targeted Fixes*
*Updated by: Cascade (4 Targeted Fixes session)*
