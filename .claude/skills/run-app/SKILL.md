---
name: run-app
description: Launch and build the Facility Management App (Flutter). Use when asked to run, build, or launch this app, or when a build fails with "Error when reading '...assets.gen.dart': No such file or directory" or "'SvgGenImage' isn't a type" / "Undefined name 'Assets'".
---

# Running facility_management_app

Flutter app. Two codegen steps are required before `flutter run`/`flutter build` will compile — both produce **gitignored** output, so a fresh checkout or clean clone always needs both regenerated.

## 1. flutter_gen (assets.gen.dart, fonts.gen.dart)

Generates `lib/src/presentation/core/gen/assets.gen.dart` and `fonts.gen.dart` from `pubspec.yaml`'s `flutter_gen:`/`flutter: assets:` config. Nothing else produces these files — `build_runner` does NOT generate them (`flutter_gen_runner` is commented out in `pubspec.yaml`).

**Symptom when missing/stale:** compile errors like
```
Error when reading 'lib/src/presentation/core/gen/assets.gen.dart': No such file or directory
Error: Type 'SvgGenImage' not found.
Error: Undefined name 'Assets'.
```

**Fix:**
```bash
fluttergen
```
(installed via `dart pub global activate flutter_gen`; binary at `$HOME/.pub-cache/bin/fluttergen`, typically already on `PATH`). Re-run this any time an asset is added/removed under `assets/images/` or `assets/icons/`, or after a clean clone.

## 2. build_runner (*.g.dart, *.mapper.dart, *.freezed.dart)

Generates riverpod providers (`*.g.dart`), dart_mappable models (`*.mapper.dart`), freezed unions (`*.freezed.dart`), and the retrofit client (`rest_client.g.dart`).

```bash
dart run build_runner build --delete-conflicting-outputs
```

Known pre-existing failures unrelated to normal feature work (dot-shorthands syntax, tracked separately — not caused by codegen config):
- `lib/src/presentation/features/occurrence/view/occurrence_checklist_page.dart`
- `lib/src/presentation/features/occurrence/view/occurrence_page.dart`

These print `E retrofit_generator ... This requires the 'dot-shorthands' language feature to be enabled.` but do not block the rest of the build — check that the specific files you touched got their outputs written (build log ends with `wrote N outputs`), not that the overall exit code is 0.

## 3. Run

```bash
flutter pub get        # if pubspec.lock is stale
fluttergen              # step 1
dart run build_runner build --delete-conflicting-outputs   # step 2
flutter run              # or: flutter build apk --debug --target lib/main.dart
```

Pick a device with `flutter devices` if more than one is attached.
