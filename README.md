# facility_management_app

A new Flutter project.

## Running the app (flavors)

The app has two Android flavors, `dev` and `stage`. The `--flavor` flag alone
selects the app name and the API base URL (see `lib/src/core/config/app_config.dart`).

| Flavor | API                                                        |
| ------ | ---------------------------------------------------------- |
| dev    | `http://3.108.132.91/api/backend`                          |
| stage  | `https://stage-api.bhumijosmartmanagement.com/api/backend` |

Run the commands from this folder (`app/`).

**Run (debug)**

```
flutter run --flavor dev
flutter run --flavor stage
```

**Build APK**

```
flutter build apk --release --flavor dev
flutter build apk --release --flavor stage
```

The APK is written to `build/app/outputs/flutter-apk/app-<flavor>-release.apk`.

**VS Code**

Pick `Facility-App (dev)`, `Facility-App (stage)` or `Facility-App (stage release)`
in the Run and Debug dropdown.

**Notes**

- Every request sends the header `X-Client-Type: bhumijo-facility-app`.
- Running without `--flavor` (and `flutter test`) uses the dev URL.
- To point a build at another server (local or tunnel), add
  `--dart-define=API_BASE_URL=https://host/api/backend`. It overrides the flavor URL.
- **Uninstall the installed flavor before installing a different one.** Both
  flavors use the same application ID (`com.bhumijo.facilityapp`), so only one
  can be installed at a time. Installing the other over it replaces the app but
  keeps the old login and local data, which belong to the other server.
- Before the first run on a fresh clone, generate the code first. See
  `.claude/skills/run-app/SKILL.md` for the steps.
- More detail: `docs/FLAVORS.md`.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
