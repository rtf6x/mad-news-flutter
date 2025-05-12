# mad_news_flutter

MadNews

## Getting Started:

### android/key.properties:
```
storePassword=[pass]
keyPassword=[pass]
keyAlias=release
storeFile=/path/to/[key].jks
```

### pubspec.yaml (1.0.8 = versionName, 8 = versionCode):

```
version: 1.0.8+8
```

```
# To run the app:
flutter run

# To run the app showing Arabic:
flutter run lib/arabic.dart

# Release:
flutter clean && flutter build appbundle --release
```
