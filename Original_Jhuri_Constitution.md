# JHURI_CONST.md
# Ekush Labs — Jhuri Development Constitution
# ঝুড়ি — Smart Grocery List
#
# THIS FILE IS THE SINGLE SOURCE OF TRUTH.
# It defines what to build, why, and how it must be architected.
# It is never modified after development begins.
# When there is a conflict between any other file and this one — this file wins.
#
# HOW THIS FILE IS USED:
# - Attach to every Claude session as context alongside JHURI_STATUS.md
# - Windsurf reads it to understand all architectural and product decisions
# - Prompts in JHURI_PLAN.md reference this file by section number
# - Do not paste this file into Windsurf directly — attach it or reference it

---

## 1. Product Identity

| Field | Value |
|---|---|
| App name (Bangla) | ঝুড়ি |
| Play Store title | Jhuri – Smart Grocery List |
| Tagline (English) | Plan Better. Shop Easier. |
| Tagline (Bangla) | বাজারের ফর্দ, হাতের মুঠোয় |
| Package name | com.ekushlabs.jhuri |
| Module path | apps/jhuri/ |
| Platform | Android-first, Flutter |
| Monetisation | AdMob — non-intrusive banner + interstitial |
| Language | Bilingual — Bangla (default) + English, switchable |

**Core promise:** A user can open the app, tap items from a pre-built list, and have a complete grocery list ready in under 20 seconds — without typing anything.

---

## 2. Monorepo Position & Package Rules

### 2.1 App Pipeline

| App | Name | Status |
|---|---|---|
| App 1 | Ekush Ponji | Production — closed testing, Play Console |
| App 2 | Jhuri | This document |
| App 3 | Shonamoni (Baby Growth Tracker) | Future |

### 2.2 Package Dependency Rules (Non-Negotiable)

These rules are inherited from the monorepo architecture established by Ekush Ponji. Jhuri follows them without exception.

- Dependencies flow downward only — no circular dependencies
- ekush_theme has no internal deps
- ekush_ui depends on ekush_theme only
- ekush_core has no internal deps
- ekush_notifications depends on ekush_core
- No UI package depends on core; no core depends on theme
- Jhuri app layer depends on packages — packages do not depend on Jhuri

### 2.3 What Jhuri Consumes from Shared Packages

| Package | What Jhuri Uses |
|---|---|
| ekush_theme | Colors, typography, theme extensions, shared constants |
| ekush_ui | Shared widgets — pickers, loaders, splash screen |
| ekush_core | BaseScreen, AppLocalizations interface, utils, services |
| ekush_models | Drift table definitions (added as part of Jhuri setup) |
| ekush_ads | AdMob integration via EkushAdConfig pattern |
| ekush_notifications | Local notifications, permission handling |
| ekush_share | Widget-to-image share card generation |

### 2.4 New Infrastructure Introduced by Jhuri

Jhuri is the first app to use Drift. This is a deliberate monorepo evolution, not a Jhuri-only concern. The setup must be done correctly because App 3+ will inherit it.

- Drift is added to ekush_models — all table definitions live there
- ekush_core receives a DatabaseInitializer base class and a base repository pattern
- apps/jhuri/pubspec.yaml adds drift_flutter
- All future apps use Drift via ekush_core + ekush_models — they do not reinitialise from scratch

> ⚠ Hive remains Ponji-only legacy. Never import Hive in Jhuri or any new app.

---

## 3. Tech Stack & Architecture

### 3.1 Stack

| Concern | Solution | Source |
|---|---|---|
| Framework | Flutter (Android-first) | — |
| Language | Dart | — |
| State management | Riverpod | Same as Ponji |
| Architecture | MVVM | Same as Ponji |
| Local DB (lists & items) | Drift | New — via ekush_models |
| Local DB (settings) | SharedPreferences | Same as Ponji |
| Notifications | flutter_local_notifications | Via ekush_notifications |
| Share as image | ekush_share | Shared package |
| Ads | AdMob | Via ekush_ads |
| Monorepo tooling | Melos | Same as Ponji |

### 3.2 Architecture Pattern — Follow Ponji Exactly

Jhuri must mirror Ekush Ponji's proven MVVM + Riverpod structure. Windsurf must read Ponji's feature folders before writing any Jhuri screen. The pattern is not redefined here — it is inherited.

- Each feature: screen → viewmodel → repository → data source
- Screens extend JhuriBaseScreen, which extends BaseScreen from ekush_core
- Providers are defined per feature, not globally dumped in one file
- No business logic inside widgets — everything goes through ViewModel
- Riverpod StateNotifier or AsyncNotifier depending on async needs

### 3.3 Data Storage Decisions

| Data | Storage | Reason |
|---|---|---|
| Shopping lists | Drift | Relational — lists have items |
| List items | Drift | FK to ShoppingLists, queried by list |
| Item templates (~200) | Drift (seeded from JSON) | Queried by category, usage count |
| Categories (9) | Drift (seeded from JSON) | FK from ItemTemplates |
| App settings | SharedPreferences | Flat key-value, same as Ponji |
| Usage counts | Drift (on ItemTemplates) | Needed for v2 suggestions |

---

## 4. Design System

### 4.1 Colour Palette — Jhuri Theme

Jhuri has its own theme, independent of Ponji. The palette evokes a warm Bangladeshi bazar — fresh, earthy, and inviting.

| Token | Light Mode | Dark Mode |
|---|---|---|
| Primary | #2D6A4F (deep sap green) | same |
| Accent | #E9A23B (warm turmeric orange) | same |
| Background | #FDFAF4 (soft cream) | #1A1A1A (deep charcoal) |
| Surface | #FFFFFF | #242424 |
| Error | #D62828 | same |
| Text primary | #1C1C1C | #F5F5F5 |
| Text secondary | #6B7280 | same |

### 4.2 Typography

- **Display / headings:** Hind Siliguri (excellent Bangla + Latin support, warm feel)
- **Body:** Noto Sans Bengali (maximum Bangla readability)
- **Prices and numbers:** Tabular figures for alignment

### 4.3 Elevation & Surfaces

| Element | Elevation | Border Radius |
|---|---|---|
| Cards | 2dp | 12px |
| Bottom sheets | — | 16px top corners |
| FAB | 6dp | — |
| Modals | Full bottom sheet — never dialog | 16px top corners |

### 4.4 Motion

- Page transitions: Shared element where possible, otherwise fade + slide
- Item selection: Scale pulse (0.95 → 1.0) + colour fill
- Item bought animation: Strikethrough with colour fade to muted
- List completion: Confetti burst + '✓' overlay, auto-dismisses after 2 seconds
- List archive: Slide out left with fade

---

## 5. Data Models (Drift Tables — ekush_models)

All Drift table class definitions live in packages/ekush_models. The Drift database class lives in packages/ekush_core. Jhuri's app layer only uses repositories — it never touches Drift directly.

### 5.1 ShoppingLists

```
id             → autoincrement primary key
title          → text, default empty string
buyDate        → dateTime (the intended shopping date)
reminderTime   → dateTime, nullable
isReminderOn   → bool, default false
isCompleted    → bool, default false
isArchived     → bool, default false
createdAt      → dateTime
completedAt    → dateTime, nullable
sourceListId   → int, nullable (set when duplicated from another list)
// No unique constraint on buyDate — multiple lists per date are allowed
```

### 5.2 ListItems

```
id             → autoincrement primary key
listId         → int, FK to ShoppingLists
templateId     → int, nullable, FK to ItemTemplates (null if custom freetext)
nameBangla     → text (stored directly, not just a reference)
nameEnglish    → text
quantity       → real, default 1.0
unit           → text
price          → real, nullable
isBought       → bool, default false
sortOrder      → int
addedAt        → dateTime
```

### 5.3 ItemTemplates

```
id               → autoincrement primary key
nameBangla       → text
nameEnglish      → text (internal only, never shown to user)
categoryId       → int, FK to Categories
defaultQuantity  → real
defaultUnit      → text
iconIdentifier   → text (e.g. 'vegetable_potato' → assets/icons/items/vegetable_potato.png)
isCustom         → bool, default false
usageCount       → int, default 0
lastUsedAt       → dateTime
createdAt        → dateTime, nullable (null for seeded items, set for custom)
```

### 5.4 Categories

```
id               → autoincrement primary key
nameBangla       → text
nameEnglish      → text (internal only)
imageIdentifier  → text (e.g. 'vegetables' → assets/images/categories/vegetables.png)
iconIdentifier   → text (fallback if image fails)
sortOrder        → int
```

### 5.5 AppSettings (Singleton — SharedPreferences, not Drift)

Stored in SharedPreferences as flat key-value pairs. Keys mirror the field names below.

```
themeMode             → string: 'system' | 'light' | 'dark', default 'system'
language              → string: 'bangla' | 'english', default 'bangla'
showPriceTotal        → bool, default true
defaultUnit           → string, default 'কেজি'
currencySymbol        → string, default '৳'
notificationsEnabled  → bool, default true
defaultReminderTime   → string, default '18:00'
listSortOrder         → string: 'dateDesc' | 'dateAsc', default 'dateDesc'
appOpenCount          → int, default 0
lastInterstitialShown → string (ISO datetime), nullable
onboardingComplete    → bool, default false
reviewPrompted        → bool, default false
```

---

## 6. Item Database & Seed Data

### 6.1 Seed Strategy

- Seed file ships as apps/jhuri/assets/data/items_seed.json
- Seeded into Drift tables on first launch only, checked via onboardingComplete flag in SharedPreferences
- Seeded items are never modified by the app — user edits create new ItemTemplates rows with isCustom = true
- Seeded items have createdAt = null to distinguish them from user-created templates

### 6.2 MVP Categories (5 — expandable to 9 post-MVP)

| ID | Bangla | English | Sort |
|---|---|---|---|
| 1 | শাকসবজি | Vegetables | 1 |
| 2 | মাছ | Fish | 2 |
| 3 | মাংস | Meat | 3 |
| 4 | চাল ও আটা | Rice & Flour | 4 |
| 5 | ডাল ও মশলা | Lentils & Spices | 5 |

> ⚠ After MVP is verified stable, expand to full 9 categories: add Oil & Sauce, Dairy & Eggs, Fruits, Household. No schema change needed — just add rows to seed data.

### 6.3 MVP Items (5 per category — 25 total for MVP)

| Category | Items (Bangla) |
|---|---|
| শাকসবজি | আলু, পেঁয়াজ, রসুন, আদা, টমেটো |
| মাছ | রুই, ইলিশ, কাতলা, চিংড়ি, পাঙ্গাস |
| মাংস | মুরগি, গরু, খাসি, কলিজা, ডিম |
| চাল ও আটা | চাল, আটা, ময়দা, চিড়া, সুজি |
| ডাল ও মশলা | মসুর ডাল, মুগ ডাল, হলুদ, মরিচ, ধনিয়া |

### 6.4 Fixed Unit Set

These are the only units available across the entire app. No free-text unit entry.

```
কেজি · গ্রাম · লিটার · মিলিলিটার · পিস · হালি · আঁটি · ডজন · প্যাকেট · বোতল · কৌটা
```

---

## 7. Feature Roadmap — v1, v2, v3

Features are split across three releases. The v1 data model and architecture must support v2 and v3 features without structural refactoring. If a v2 feature requires a new DB column, add it as nullable in v1.

### v1 — MVP (First Release)

**A working, shippable app. The core loop must be smooth. Nothing else matters until this is perfect.**

**Core Loop**
- Create a new shopping list with a date
- Browse categories and tap to select pre-built items
- Adjust quantity and unit per item (price optional)
- View and edit items in the list before saving
- Shopping mode — checklist view, tap to mark bought
- Running total when prices are filled (optional display)

**App Infrastructure**
- Bilingual — Bangla default, English switchable
- Light and dark mode — system default, switchable
- Onboarding — 3 screens (welcome, language, notification permission)
- Settings screen — theme, language, default unit, currency symbol, notifications
- Banner ads on Home and Shopping Mode (via ekush_ads)
- Interstitial ad after list save and after share (max 3 per session, 5-min interval)

**List Management**
- Multiple lists — one per intended shopping date
- Home screen — lists grouped by date (Today, Upcoming, Past)
- Long press on card — Edit, Duplicate, Archive, Delete
- Swipe left to delete (undo snackbar), swipe right to complete/reopen
- Auto-archive when all items are marked bought
- Duplicate list (Reuse flow) — copies all items, resets bought state, date set to today

**Custom Items**
- Add custom item from Item Picker — name, category, quantity, unit, price
- Custom items saved to personal library (isCustom = true) — appear in category grid
- Delete custom items from Settings → Personal Items

**Share**
- Share list as image card via ekush_share
- Card shows: date, items grouped by category, total if prices filled, Jhuri watermark

**Notifications**
- Optional reminder per list — time picker, defaults to 6:00 PM
- Notification fires on buyDate at reminderTime
- Tap notification → deep link to that list in Shopping Mode
- If permission denied, reminder toggle is disabled with explanation tooltip
- Delete list with reminder → cancel the notification before deletion

### v2 — Refinement Release

**Quality improvements and the first intelligence layer. No structural changes to the data model.**

- Usage-based item suggestions — items sorted by score (usageCount × recencyWeight) instead of alphabetical. Data tracked from v1 launch, algorithm applied in v2.
- Missed reminder — if list not completed by reminder time, one follow-up notification fires at same time next day. Never repeats again.
- Native ad cards — after every 4th list card on Home screen
- Full 9-category item database — add Oil & Sauce, Dairy & Eggs, Fruits, Household
- Expand item library — target ~100 items total across all categories
- In-app review prompt — triggered at appOpenCount = 10, one-time only
- English language fully activated (gated in v1, complete in v2)

### v3 — Beta / Feature Complete

**Export, data portability, and polish for a stable beta release.**

- Export / Import — .jhuri file format (JSON with custom extension), includes lists + custom items + settings
- Full ~200 item library across all categories
- Archived lists screen — accessible from Settings
- Data management in Settings — clear lists, clear custom items
- Performance audit and cold start optimisation
- Play Store full production release after v3 beta validation

---

## 8. Screen Specifications

All screen behaviour is specified here. Windsurf reads this section per screen before building. UI layout details follow Ponji's patterns unless explicitly stated otherwise.

### 8.1 Onboarding (First Launch Only)

Three screens. Mirrors Ponji onboarding flow, Jhuri-themed.

1. Welcome — Jhuri logo, app name, tagline in Bangla, 'শুরু করুন' button
2. Language Selection — বাংলা (default, selected), English (shows 'শীঘ্রই আসছে' toast, stays on Bangla in v1)
3. Notification Permission — friendly Bangla explanation, 'অনুমতি দিন' + 'এখন না' buttons, requests POST_NOTIFICATIONS

On complete: set onboardingComplete = true in SharedPreferences, navigate to Home.

### 8.2 Home Screen

**Layout**
- App bar: 'ঝুড়ি' title, settings icon top right
- Body: scrollable list cards, grouped by date
- FAB: '+' bottom right — creates new list
- Bottom: banner ad via ekush_ads

**List Card Shows**
- Date in Bangla ('আজ', 'আগামীকাল', or formatted date)
- List title or 'বাজারের ফর্দ' if empty
- Item count: '৭টি আইটেম'
- Estimated total if any prices filled: '≈ ৳ ১,২৫০'
- Completion ring: e.g. 3/7 bought
- Reminder badge if reminder is on

**Date Grouping**
- Today — top, highlighted section
- Upcoming — next section
- Past incomplete — collapsed by default, expandable
- Archived — not shown on Home; accessible via Settings in v3

**Empty State**
'বাজারের কোনো ফর্দ নেই / "+" বাটন চেপে নতুন ফর্দ তৈরি করুন' — warm illustration, not clinical.

**Interactions**
- Tap card → Shopping Mode
- Long press → context menu: Edit / Duplicate / Archive / Delete
- Swipe left → Delete with undo snackbar
- Swipe right → Mark complete / Reopen

### 8.3 Create / Edit List Screen

Full-height bottom sheet.

**Fields**
1. Title — optional, hint: 'যেমন: সাপ্তাহিক বাজার'
2. Buy Date — date picker, auto-filled to today, shows Bangla date alongside English
3. Reminder toggle — on/off
4. Reminder time — visible only when toggle is on, default 18:00 from settings
5. Items section — added items as cards
6. 'আইটেম যোগ করুন' button → opens Category Browser

**Item Card (in list)**
- Icon + Bangla name + quantity + unit + optional price
- Tap → edit quantity/price inline
- Swipe to remove

**Running Total**
Shown at bottom only if at least one price is filled. Format: 'মোট আনুমানিক: ৳ ১,২৫০'

**Save Behaviour**
- Validates at least 1 item added — error: 'অন্তত একটি আইটেম যোগ করুন'
- On save → interstitial ad (per ad rules) → back to Home, new card with animation

**Duplicate / Reuse Flow**
- Opens screen pre-filled from existing list
- Date auto-set to today (editable)
- Title appended with '(কপি)' — editable
- All items copied, none marked bought

### 8.4 Category Browser

- Full screen, title: 'কী কিনবেন?'
- 3-column grid of category cards
- Each card: full-bleed category image + Bangla label overlay (bottom, semi-transparent gradient)
- Last card: '➕ কাস্টম' — triggers custom item form
- Card spec: square ~110dp, 12px radius, subtle shadow
- Bottom: 'সম্পন্ন' button — returns to Create List with selections applied

### 8.5 Item Picker

- App bar: category name in Bangla + back button
- 3-column grid: icon + Bangla name below
- v1: items sorted alphabetically by nameBangla. v2: usage score sorting

**Search (Conditional)**
- Hidden by default
- Visible only when category has 10 or more items (searchVisibleThreshold constant)
- Triggered by pull-down gesture — search bar floats in from top
- Real-time filter on nameBangla
- Dismiss: scroll up or tap outside

**Item Selection**
- Tap item → quantity input bottom sheet: icon + name, quantity stepper, unit chips, optional price, 'যোগ করুন' button
- Smart defaults pre-filled from ItemTemplates
- Already-added items show a checkmark badge on grid card

**Custom Item Form**
- Fields: Bangla name (required), English name (optional), category (pre-selected), quantity, unit, price
- Saved permanently to ItemTemplates with isCustom = true
- Appears in category grid for all future lists

### 8.6 Shopping Mode (Active List View)

- App bar: list title + buy date
- Progress bar: '৩/৭ কেনা হয়েছে' with animated fill
- Items grouped by category
- Share button: top right
- Bottom: banner ad

**Item Row**
- Icon + name + quantity + unit + price (if filled)
- Tap → mark bought: strikethrough animation + colour fade to muted
- Tap again → unmark

**Completion**
- When all items tapped bought: confetti burst, 'সব কেনা হয়েছে! 🎉' overlay (auto-dismisses after 2s)
- List auto-archived 3 seconds after completion, navigate back to Home

### 8.7 Share as Image

Triggered from Shopping Mode share button via ekush_share.

- Portrait card, warm cream background, green accents
- Shows: Jhuri logo (subtle), Bangla date, items grouped by category, price per item if filled, total if any price filled
- Watermark: 'Jhuri দিয়ে তৈরি 🛒' for organic marketing
- On generation: interstitial ad (per ad rules)
- On failure: toast 'শেয়ার করতে সমস্যা হয়েছে। আবার চেষ্টা করুন'

### 8.8 Settings Screen

Sections: Display · Shopping · Notifications · Lists · Personal Items · About

| Section | Settings |
|---|---|
| প্রদর্শনী (Display) | Theme: System / Light / Dark. Language: বাংলা / English (English gated in v1) |
| বাজার (Shopping) | Show price total toggle. Default unit selector. Currency symbol text field (default ৳) |
| বিজ্ঞপ্তি (Notifications) | Notifications enabled toggle. Default reminder time picker |
| তালিকা (Lists) | List sort order: Newest first / Oldest first |
| ব্যক্তিগত আইটেম (Personal Items) | Shows user's custom items. Delete individual items |
| সম্পর্কে (About) | App version (name only, e.g. 1.0.0). Ekush Labs branding. Privacy policy link |

---

## 9. Ad Placement Rules

Non-aggressive. Ads appear at natural pause points, never during active tasks.

| Type | Placement | Trigger / Rule |
|---|---|---|
| Banner | Home screen bottom | Always visible on Home |
| Banner | Shopping Mode bottom | Always visible while shopping |
| Interstitial | After list saved | Max 1 per creation flow |
| Interstitial | After share image generated | Natural completion moment |

**Interstitial Session Rules**
- Max 3 per session
- 5-minute minimum interval between interstitials (enforced via lastInterstitialShown in SharedPreferences)
- Never on cold launch
- Never during Shopping Mode

> ⚠ v2 adds native ads after every 4th list card on Home. Not in v1.

---

## 10. Notification Specification

| Field | Value |
|---|---|
| Title | আজ বাজার আছে |
| Body | আপনার ফর্দে [N]টি আইটেম আছে |
| Trigger | reminderTime on buyDate |
| Timezone | Asia/Dhaka |
| Deep link | Tap → open that list in Shopping Mode |
| On list delete | Cancel scheduled notification before deletion |
| Permission denied | Reminder toggle disabled, tooltip explains why |

> ⚠ v2 adds: missed reminder fires one follow-up at same time next day if list not completed. Never repeats.

---

## 11. App Constants (jhuri_constants.dart)

All tunable values live here. Windsurf must not hardcode any of these values inline.

```dart
// Suggestions algorithm (v2)
recencyWeight7Days   = 1.0
recencyWeight30Days  = 0.7
recencyWeight90Days  = 0.4
recencyWeightOlder   = 0.1

// UI behaviour
searchVisibleThreshold = 10   // categories with 10+ items show search

// Ad rules
interstitialSessionMax         = 3
interstitialMinIntervalMinutes = 5

// Engagement
reviewPromptAppOpenCount = 10

// v2+
nativeAdEveryNCards = 4

// Defaults
defaultReminderTime   = '18:00'
defaultUnit           = 'কেজি'
defaultCurrencySymbol = '৳'
```

---

## 12. Edge Cases & Error States

| Scenario | Behaviour |
|---|---|
| Save list with 0 items | Validation error: 'অন্তত একটি আইটেম যোগ করুন' |
| Notification permission denied | Reminder toggle disabled, tooltip explains — never crash |
| No items in a category | 'এই বিভাগে কোনো আইটেম নেই। কাস্টম আইটেম যোগ করুন' |
| Delete list with reminder | Cancel scheduled notification before deleting — always |
| Share image generation fails | Toast: 'শেয়ার করতে সমস্যা হয়েছে। আবার চেষ্টা করুন' |
| Drift init failure on launch | Fallback error screen: 'অ্যাপ পুনরায় চালু করুন' |
| English selected in v1 | Toast: 'শীঘ্রই আসছে' — app remains in Bangla |
| Import file corrupted (v3) | 'ফাইলটি পড়া যাচ্ছে না। সঠিক Jhuri ফাইল বেছে নিন' |

---

## 13. Asset Structure

```
apps/jhuri/assets/
├── data/
│   └── items_seed.json
├── images/
│   └── categories/
│       ├── vegetables.png
│       ├── fish.png
│       ├── meat.png
│       ├── rice_flour.png
│       └── lentils_spices.png   (5 for MVP; 4 more added in v2)
└── icons/
    └── items/
        ├── vegetable_potato.png
        ├── vegetable_onion.png
        ├── ... (~25 for MVP, ~100 in v2, ~200 in v3)
```

**AI Image Generation Spec**

Category Images:
`'Flat lay food photography style illustration of [category], warm natural lighting, earthy tones, green and orange accents, Bangladesh market aesthetic, square format, no text'`

Item Icons:
`'Flat vector icon of [item name in English], minimal style, soft shadow, consistent line weight, warm earthy palette, white background, centered, square format, 256x256'`

> ⚠ Generate all icons in one session per category batch for style consistency. Export all as PNG, 256×256px.

---

## 14. Development Phases — Overview

This section defines what each phase must accomplish and its definition of done. Windsurf prompts for each phase live in JHURI_PLAN.md.

### Pre-Development Checklist (Before Phase 1)

> ⚠ All items below must be done before Windsurf writes a single Flutter file.

- [ ] Doc 1 (Restoration Guide) fully executed and committed
- [ ] Create `jhuri` branch off main: `git checkout -b jhuri`
- [ ] Generate 5 category images (AI, consistent style, 256×256px PNG)
- [ ] Generate 25 item icons (AI, batched by category, 256×256px PNG)
- [ ] Complete items_seed.json with all MVP items, defaults, and exact iconIdentifier values
- [ ] Verify icon file names match iconIdentifier values exactly before committing assets
- [ ] Create Jhuri AdMob IDs and store in personal cloud — never commit to repo
- [ ] Confirm Ekush Ponji APK builds clean (final pre-work safety check)

### Phase 1 — Monorepo Foundation (Drift + ekush_models + ekush_core)

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
- [ ] melos run analyze → zero issues across all packages
- [ ] flutter analyze apps/ekush_ponji → zero issues (Ponji untouched)
- [ ] Smoke test passes
- [ ] JHURI_STATUS.md updated
- [ ] Committed: `feat(jhuri): Phase 1 — Drift foundation wired into monorepo`

### Phase 2 — App Shell + Navigation + Theme

**Goal: Jhuri launches, shows a screen, navigation works, Jhuri theme applied.**

Tasks:
- main.dart: ProviderScope, Drift init, SharedPreferences init, theme setup
- JhuriBaseScreen extending BaseScreen from ekush_core
- JhuriLocalizations implementing AppLocalizations — all MVP strings in both Bangla and English
- JhuriConstants file with all constants from Section 11
- App router setup (go_router or Navigator 2.0 following Ponji pattern)
- Jhuri theme registered (colours, typography from Section 4)
- Onboarding flow — 3 screens, sets onboardingComplete in SharedPreferences
- Home screen shell (empty state only, no real data yet)

**Definition of Done**
- [ ] App launches on device/emulator
- [ ] Onboarding flows through all 3 screens
- [ ] Home screen shows empty state
- [ ] Theme colours visible and correct
- [ ] melos run analyze → zero issues
- [ ] JHURI_STATUS.md updated
- [ ] Committed: `feat(jhuri): Phase 2 — app shell, theme, navigation, onboarding`

### Phase 3 — Core Loop (Home + Create List + Item Picker + Shopping Mode)

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
- [ ] Complete flow: new list → browse category → select items → shopping mode → all bought → archived
- [ ] Duplicate list flow works
- [ ] Custom item creation and reuse works
- [ ] melos run analyze → zero issues
- [ ] JHURI_STATUS.md updated
- [ ] Committed: `feat(jhuri): Phase 3 — core loop complete`

### Phase 4 — Settings + Notifications + Share

**Goal: Supporting features complete. App is functionally whole.**

Tasks:
- Settings screen — all sections from Section 8.8
- Theme switching (light/dark/system) — live update without restart
- Language switching — Bangla/English live update
- Notification scheduling via ekush_notifications — reminder per list
- Cancel notification on list delete
- Share as image via ekush_share — card spec from Section 8.7

**Definition of Done**
- [ ] Settings changes apply immediately
- [ ] Reminder notification fires at correct time, deep links to list
- [ ] Share card generates and shares correctly
- [ ] melos run analyze → zero issues
- [ ] JHURI_STATUS.md updated
- [ ] Committed: `feat(jhuri): Phase 4 — settings, notifications, share`

### Phase 5 — Ads Integration

**Goal: AdMob wired in. All ad placements active per Section 9.**

Tasks:
- EkushAdConfig implementation for Jhuri with Jhuri AdMob IDs (from personal cloud)
- Banner ads: Home screen bottom, Shopping Mode bottom
- Interstitial: after list save, after share
- Session cap and interval logic (via lastInterstitialShown in SharedPreferences)

**Definition of Done**
- [ ] Banners visible on correct screens
- [ ] Interstitial fires after list save (respecting session cap and interval)
- [ ] melos run analyze → zero issues
- [ ] JHURI_STATUS.md updated
- [ ] Committed: `feat(jhuri): Phase 5 — ads integration`

### Phase 6 — Polish + Play Store Submission

**Goal: App is release-quality. Submitted to Play Store internal testing.**

Tasks:
- Replace all placeholder icons with final AI-generated assets
- Expand item library to full MVP set (5 categories × 5 items minimum)
- App icon and splash screen finalized
- Review all Bangla strings for correctness and naturalness
- Test all edge cases from Section 12
- flutter build appbundle --release
- Submit to Play Store internal testing track

**Definition of Done**
- [ ] Release APK/AAB builds without errors
- [ ] All edge cases handled and tested
- [ ] Submitted to Play Console internal testing
- [ ] JHURI_STATUS.md updated to reflect v1.0.0 submitted
- [ ] Committed: `release(jhuri): v1.0.0 — Play Store submission`

---

## 15. Windsurf Operating Protocol

These rules apply to every Windsurf session, every prompt, without exception.

### 15.1 Session Rules

1. One phase per Windsurf session. Never mix phases.
2. Start every session by reading JHURI_STATUS.md before touching any file.
3. Read the Ponji reference files listed in the phase prompt before writing any code.
4. Never modify anything in apps/ekush_ponji/ unless explicitly instructed.
5. Run melos run analyze at the end of every session. Zero issues required before committing.
6. Update JHURI_STATUS.md before committing at the end of every session.
7. Commit at the end of every phase using the exact commit label provided.
8. If an unexpected file or error is found, stop and report — do not improvise.

### 15.2 The Ekush Ponji Protection Clause

🚫 **Windsurf is strictly forbidden from modifying, downgrading, or refactoring any code inside apps/ekush_ponji/ or its directly related files unless explicitly instructed by the developer.**

- Before touching any shared package, check if the change affects Ponji
- If a shared package change is required and it could break Ponji, stop and report
- Never change a shared package interface without verifying Ponji still compiles

### 15.3 Mandatory Prompt Footer

Every prompt given to Windsurf must end with this line verbatim:

```
Verify that shared dependencies remain compatible with the existing apps in the monorepo.
If a conflict with Ekush Ponji is detected, do not apply changes; report immediately.
```

---

## 16. Localisation

- JhuriLocalizations implements AppLocalizations from ekush_core
- All user-facing strings in Bangla by default
- English strings present in code from day one — gated behind language toggle in v1, fully activated in v2
- Bangla date formatting uses utilities from ekush_core (extracted from Ponji)
- Currency symbol configurable in settings, default '৳'

---

## 17. The North Star

***A user can create a complete grocery list in under 20 seconds, without typing a single character.***

Every decision — feature cuts, data model choices, phase ordering, Windsurf prompts — is evaluated against this north star. If a feature does not serve it, it waits for v2. If a technical decision slows it down, it is reconsidered.
