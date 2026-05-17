# Mood Tracker

A Flutter web app for logging your mood. Faces are drawn with `CustomPainter` using only canvas primitives — no emoji, no icons, no images.

## Live demo
_TODO: paste the deployed URL here_

## Features
- Tap one of five faces (Excited, Happy, Neutral, Sad, Angry) to log how you feel
- Horizontal timeline of the last 7 entries with date, time, and the drawn face
- Tap any past entry to replay a brief bounce + tilt animation
- Entries persist across reloads via `shared_preferences`

## Stack
- Flutter 3.27+, Dart 3.6+
- `flutter_riverpod` for state management
- `shared_preferences` for persistence
- `intl` for date formatting
- `uuid` for entry ids

## Run locally
```bash
flutter pub get
flutter run -d chrome
```

## Build for the web
```bash
flutter build web --release
```
Output goes to `build/web`.

## Deploy

### Firebase Hosting
```bash
flutter build web --release
firebase deploy --only hosting
```
`firebase.json` is included with public dir, SPA rewrites, and cache headers wired up. First-time setup: `firebase login && firebase init hosting` and point it at an existing project.

### Vercel
Vercel's default build image doesn't ship Flutter, so build locally and deploy the static output:
```bash
flutter build web --release
npx vercel deploy --prod
```
`vercel.json` declares `build/web` as the output directory and adds SPA rewrites. No `buildCommand` is set, so Vercel won't try to run Flutter.

## Notes on the implementation

### State
A single `StateNotifier<List<MoodEntry>>` owns the list. It hydrates from `shared_preferences` on construction and writes after every mutation. `SharedPreferences` is injected through an overridable `Provider` so tests can substitute a fake without globals. The 7-entry timeline is a derived `Provider` that calls `take(7)` on the full list.

### The painter
`MoodFacePainter` composes each face from three primitives:
- `drawCircle` — face outline and eyes
- `drawArc` — every mouth (the neutral one is just a very shallow arc so all five mouths share the same primitive)
- `drawPath` with `quadraticBezierTo` — eyebrows on excited, sad, and angry

Everything is keyed off a normalised `center` and `radius`, so the same painter renders the 76px selector face and the 64px timeline thumbnail without any per-size tweaks.

### Animation
Each timeline card owns an `AnimationController` driving a `TweenSequence`. Scale bounces 1.0 → 1.18 → 0.96 → 1.0; rotation wobbles ±0.08 rad. Tapping the card replays it. New entries auto-play once on first build via a post-frame callback so the log feels acknowledged.

## What I'd add with more time
- Swap `shared_preferences` for IndexedDB via Drift so the full history (not just 7 entries) is queryable and chartable
- Per-day grouping in the timeline ("Today", "Yesterday", "Mon 12 May") instead of per-entry timestamps
- Golden tests for each face — the painter is the most fragile part of the codebase and a stray coordinate would silently break the visuals
