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

### iOS signing (local)

Requires Xcode on macOS and an Apple Developer account with:

- App ID: `cc.rootfox.madnews`
- Apple Distribution certificate
- App Store provisioning profile for that App ID

Open `ios/Runner.xcworkspace` in Xcode, select your Team under **Signing & Capabilities**, then:

```bash
flutter build ipa --release --export-options-plist=ios/ExportOptions.plist
```

The IPA is written to `build/ios/ipa/`. Upload via **Transporter** or Xcode Organizer.

### Versioning

`pubspec.yaml` holds the local dev version (e.g. `2.0.7+27` — `versionName` + `versionCode`).

CI does not edit `pubspec.yaml`. GitHub Actions passes version via Flutter flags:

- `--build-name` — version name (e.g. `2.0.7`)
- `--build-number` — monotonic build number (`49 + github.run_number`, first CI build = `50`)

### Local development

```bash
flutter run
flutter clean && flutter build appbundle --release
flutter build ipa --release --export-options-plist=ios/ExportOptions.plist
```

## CI (GitHub Actions)

| Workflow | Trigger | Output |
|----------|---------|--------|
| [build-android.yml](.github/workflows/build-android.yml) | Push to `master` | `app-release.aab` artifact |
| [build-ios.yml](.github/workflows/build-ios.yml) | Manual | Signed `*.ipa` artifact |

### Where to put secrets (public repo)

**Do not commit** `key.properties`, `.jks`, `.p12`, provisioning profiles, or passwords.

On GitHub: **Repository → Settings → Secrets and variables → Actions → New repository secret**

#### Android

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

#### iOS

| Secret name | Value |
|-------------|--------|
| `APPLE_TEAM_ID` | 10-character Team ID from Apple Developer |
| `IOS_CERTIFICATE_BASE64` | Apple Distribution `.p12`, base64-encoded (one line) |
| `IOS_CERTIFICATE_PASSWORD` | Password for the `.p12` export |
| `IOS_PROVISIONING_PROFILE_BASE64` | App Store provisioning profile for `cc.rootfox.madnews`, base64-encoded |

Encode certificate and profile locally:

```bash
base64 -i path/to/dist.p12 | tr -d '\n' | pbcopy          # macOS
base64 -i path/to/profile.mobileprovision | tr -d '\n' | pbcopy
```

After secrets are configured, run **Actions → Build iOS → Run workflow**, download the IPA artifact, and upload to App Store Connect with Transporter.

### Security note

If signing files were ever pushed to a **public** repo, treat the key as exposed: rotate passwords if possible and consider a **new upload key** in Play Console (Android) or re-issue certificates (iOS). Old commits may still contain secrets until history is rewritten (`git filter-repo` / GitHub support).
