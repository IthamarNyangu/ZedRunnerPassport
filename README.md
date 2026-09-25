# Tamanga

An Android-first Flutter pilot for Zambia's running and walking community. Stage 1 supports an honestly labelled demo race directory, saved events, self-reported finishes, derived milestones, provisional passport stamps and privacy-safe share cards.

## Run and check

```powershell
flutter pub get
dart format .
flutter analyze
flutter test
flutter run
flutter build apk --debug
```

User data is stored only on the device through `shared_preferences`. Bundled events are fictional demo fixtures and must not be used for real travel or registration decisions.

## Emulator previews

- [Home](tamanga-home.png)
- [Explore demo directory](tamanga-explore.png)

Product choices are in [docs/product-decisions.md](docs/product-decisions.md); later dependencies are in [docs/roadmap.md](docs/roadmap.md).
