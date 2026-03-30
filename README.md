# ekush-space

Flutter monorepo for **Ekush Labs** — a portfolio of simple, elegant Android apps monetized through non-intrusive ads.

Built and maintained by a solo developer using AI-assisted development (Claude + Windsurf).

---

## Studio

**Ekush Labs** builds utility apps for Bangladeshi users. Each app is simple, polished, and generates steady passive income through moderate ads. Target: ~10 apps over time.

---

## App Pipeline

| # | App | Status |
|---|-----|--------|
| 1 | Ekush Ponji — Bangla Calendar | Google Play closed testing |
| 2 | Prayer Time + Qibla | Planned May–Jul 2026 |
| 3 | Baby Growth Tracker | Planned Aug–Sep 2026 |
| 4 | Grocery List (BD-localized) | Planned Oct–Nov 2026 |
| 5 | Student Exam Planner | Stretch Dec 2026 |

---

## Repository Structure

```
ekush-space/
├── apps/
│   └── ekush_ponji/          # App 1 — Bangla Calendar
├── packages/
│   ├── ekush_theme/          # Colors, typography, theme extensions, shared constants
│   ├── ekush_ui/             # Shared widgets — pickers, loaders, error screens, splash
│   ├── ekush_core/           # Base classes, localization interface, utils, services
│   ├── ekush_models/         # Shared data models — scaffold for App 2+
│   ├── ekush_ads/            # AdMob integration, EkushAdConfig pattern
│   ├── ekush_notifications/  # Local notifications, permission handling
│   └── ekush_share/          # Widget-to-image sharing
├── melos.yaml                # Monorepo scripts
└── pubspec.yaml              # Workspace root
```

---

## Package Dependency Graph

```
ekush_theme        → no internal deps
ekush_ui           → ekush_theme
ekush_core         → no internal deps
ekush_ads          → no internal deps
ekush_notifications → ekush_core
ekush_share        → no internal deps
```

**Rule:** Dependencies only flow downward. No circular deps. No UI packages depending on core. No core depending on theme.

---

## Architecture Principles

### Localization
- `ekush_core` contains `AppLocalizations` — an **abstract interface only**
- Each app provides its own concrete implementation
- Ekush Ponji: `apps/ekush_ponji/lib/l10n/ponji_localizations.dart`
- New apps: implement `AppLocalizations`, provide their own strings

### Ad Configuration
- `ekush_ads` contains `EkushAdConfig` — an abstract config pattern
- Each app provides its own AdMob IDs via `ProviderScope` override
- `ad_config.dart` is **gitignored** — kept in personal cloud, never committed

### Constants
- Truly shared constants live in `packages/ekush_theme/lib/core/constants/app_constants.dart`
- App-specific constants live in the app layer (e.g. `apps/ekush_ponji/lib/config/ponji_constants.dart`)

### Base Screen Pattern
- `BaseScreen` (ekush_core) — generic base for all screens
- `PonjiBaseScreen` (ekush_ponji) — Ponji-specific extension with `NotificationPromptMixin`
- New apps create their own `AppBaseScreen` extending `BaseScreen`

### Notifications
- `LocalNotificationService` is router-agnostic
- Tap routing handled via callback injection at the app layer
- Timezone fallback is configurable — Ponji passes `'Asia/Dhaka'`

---

## Tech Stack

- **Flutter** — cross-platform, Android-first
- **Dart** — language
- **Riverpod** — state management
- **MVVM** — architecture pattern
- **Melos** — monorepo tooling
- **AdMob** — ad monetization
- **Windsurf** — AI coding assistant (Cascade)

---

## Melos Scripts

```bash
melos run analyze        # dart analyze --no-fatal-warnings
melos run test           # run all tests
melos run build:android  # build Android APK
melos run clean          # flutter clean all packages
```

---

## Development Workflow

### Session Start (Every Time)
```bash
git checkout monorepo-extraction   # or main if starting fresh feature
git pull origin <branch>
```

### During Work
```bash
# make changes in Windsurf
melos run analyze                  # must be zero issues
flutter build apk --debug          # must succeed
git add .
git commit -m "type: description"
```

### Session End
```bash
git push origin <branch>
```

### Branch Rules
- `main` — stable only, never work directly here
- `monorepo-extraction` — active development branch (merge to main when stable)
- New features — create a new branch from main

---

## Windsurf (AI Coding) Guidelines

- **One project per Cascade session** — never mix ekush-ponji and ekush-space
- **Always start fresh Cascade** when switching projects
- **Every prompt must include** the repo context line:
  ```
  IMPORTANT: You are working in the ekush-space monorepo at E:\App\ekush-space.
  Do not reference the old ekush-ponji repository.
  ```
- **Always verify after Windsurf changes:**
  ```bash
  melos run analyze     # zero issues required
  flutter build apk --debug   # must succeed
  ```
- **Commit before starting next task** — never leave Windsurf changes uncommitted

---

## Adding a New App

1. Create `apps/<app_name>/` with standard Flutter structure
2. Add to `melos.yaml` workspace packages
3. Implement `AppLocalizations` — create `lib/l10n/<app>_localizations.dart`
4. Provide `EkushAdConfig` via `ProviderScope` override in `main.dart`
5. Create app-specific constants in `lib/config/<app>_constants.dart`
6. Extend `BaseScreen` for app-specific base screen needs
7. All shared UI, theme, ads, notifications — import from packages

---

## Related Repositories

| Repo | Purpose |
|------|---------|
| `ekush-ponji` | Original repo — frozen, used for production releases until monorepo stabilizes |
| `ekush-labs-web` | Static site for ekushlabs.com |
| `ekush-hub` | JSON data source for app sync |

---

## Ad Philosophy

Non-aggressive monetization:
- Banner ads — bottom of screen, non-intrusive
- Native ads — blended into content lists
- Interstitial — max 3 per session, 5-minute minimum interval
- **No forced video ads. No full-screen on every tap.**

---

*Ekush Labs — simple apps, steady income.*
