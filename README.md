# mad_news_flutter

MadNews

## Getting Started

### Android signing (local)

Create `android/key.properties` locally (not in git):

```
storePassword=[pass]
keyPassword=[pass]
keyAlias=rootfox
storeFile=/absolute/or/relative/path/to/release.jks
```

Paths in `storeFile` are resolved from the **`android/`** directory (not `android/app/`). For example, use `storeFile=keystore/release.jks` with the `.jks` file under `android/keystore/` (also gitignored).

### Versioning

`pubspec.yaml` holds the local dev version (e.g. `2.0.7+27` — `versionName` + `versionCode`).

CI does not edit `pubspec.yaml`. GitHub Actions passes version via Flutter flags:

- `--build-name` — version name (e.g. `2.0.7`)
- `--build-number` — monotonic build number (`49 + github.run_number`, first CI build = `50`)

### Local development

```bash
flutter run
flutter run lib/arabic.dart
flutter clean && flutter build appbundle --release
```

## CI (GitHub Actions)

| Workflow | Trigger | Output |
|----------|---------|--------|
| [build-android.yml](.github/workflows/build-android.yml) | Push to `master` | `app-release.aab` artifact |
| [build-ios.yml](.github/workflows/build-ios.yml) | Manual | `*.ipa` (Apple signing via secrets, TBD) |

### Where to put secrets (public repo)

**Do not commit** `key.properties`, `.jks`, or passwords.

On GitHub: **Repository → Settings → Secrets and variables → Actions → New repository secret**

| Secret name | Value |
|-------------|--------|
| `ANDROID_KEYSTORE_BASE64` | Your `.jks` file, base64-encoded (one line) |
| `ANDROID_KEYSTORE_PASSWORD` | Keystore password (`storePassword`) |
| `ANDROID_KEY_PASSWORD` | Key password (`keyPassword`) |
| `ANDROID_KEY_ALIAS` | Key alias (e.g. `rootfox`) |

Encode keystore locally:

```bash
base64 -i path/to/release.jks | tr -d '\n' | pbcopy   # macOS
```

Paste into the `ANDROID_KEYSTORE_BASE64` secret (no newlines in the value).

### Security note

If signing files were ever pushed to a **public** repo, treat the key as exposed: rotate passwords if possible and consider a **new upload key** in Play Console. Old commits may still contain secrets until history is rewritten (`git filter-repo` / GitHub support).
