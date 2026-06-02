# mad_news_flutter

MadNews

## Getting Started

### android/key.properties

Signing config for release builds (committed for CI in a private repo):

```
storePassword=[pass]
keyPassword=[pass]
keyAlias=rootfox
storeFile=keystore/rootfox.jks
```

Keystore path is relative to the `android/` directory.

### Versioning

`pubspec.yaml` holds the local dev version (e.g. `2.0.7+27` — `versionName` + `versionCode`).

CI does not edit `pubspec.yaml`. GitHub Actions passes version via Flutter flags:

- `--build-name` — version name (e.g. `2.0.7`)
- `--build-number` — monotonic build number (`49 + github.run_number`, first CI build = `50`)

### Local development

```bash
# To run the app:
flutter run

# To run the app showing Arabic:
flutter run lib/arabic.dart

# Release:
flutter clean && flutter build appbundle --release
```

## CI (GitHub Actions)

| Workflow | Trigger | Output |
|----------|---------|--------|
| [build-android.yml](.github/workflows/build-android.yml) | Push to `master` | `app-release.aab` artifact (`madnews-android-<build>`) |
| [build-ios.yml](.github/workflows/build-ios.yml) | Manual (`workflow_dispatch`) | `*.ipa` artifact (requires Apple signing setup) |

After push to `master` on GitHub, download the `.aab` from the Actions run → Artifacts.
