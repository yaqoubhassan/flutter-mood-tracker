# Mood Tracker

Flutter web app. One screen, tap a face to log your mood, see the last 7 entries in a horizontal timeline, tap any past entry to replay a bounce animation. Faces are drawn with `CustomPainter` (no emoji, no icons, no images).

## Live demo
https://flutter-mood-tracker.vercel.app

## Features

- Five moods: Excited, Happy, Neutral, Sad, Angry
- Horizontal timeline showing the most recent 7 entries (date, time, face, accent color)
- Tap a past entry to replay a bounce + tilt animation
- Entries persist across reloads (shared_preferences)

## Stack

- Flutter 3.27+, Dart 3.6+
- flutter_riverpod for state
- shared_preferences for persistence
- intl, uuid

## Running

```bash
flutter pub get
flutter run -d chrome
```

## Building

```bash
flutter build web --release
```

Output: `build/web`.

## Deploying

### Firebase

```bash
flutter build web --release
firebase deploy --only hosting
```

`firebase.json` already has the public dir, SPA rewrites and cache headers. First time: `firebase login` then `firebase init hosting` against an existing project.

### Vercel

Vercel doesn't ship Flutter on its default build image, so build locally and let Vercel serve the static output.

```bash
flutter build web --release
cd build/web
npx vercel --prod
```

## How it works

**State.** One `StateNotifier<List<MoodEntry>>` owns the list. Hydrates from `shared_preferences` on construction, writes after every mutation. `SharedPreferences` is injected via an overridable `Provider` so tests can swap it. The timeline reads from a derived provider that just calls `.take(7)` on the full list.

**The painter.** `MoodFacePainter` uses three primitives:

- `drawCircle` for the face outline and eyes
- `drawArc` for every mouth (the "flat" neutral mouth is a very shallow arc so all five share the same primitive)
- `drawPath` + `quadraticBezierTo` for the eyebrows on Excited / Sad / Angry

All coordinates derive from a normalized `center` and `radius`, so the same painter renders the 76px selector face and the 64px timeline thumbnail.

**Animation.** Each timeline card has its own `AnimationController` driving a `TweenSequence`: scale bounces 1.0 → 1.18 → 0.96 → 1.0, rotation wobbles ±0.08 rad. Tapping the card replays it. Just-logged entries auto-play once via a post-frame callback.

## What I'd add with more time

- Swap shared_preferences for IndexedDB via Drift, so the full history is queryable and chartable (not just the last 7)
- Group timeline entries by day ("Today", "Yesterday", "Mon 12 May") instead of per-entry timestamps
- Golden tests for each face. The painter is fragile by nature and golden diffs would catch any pixel regression
