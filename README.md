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

- Before: [Home](tamanga-home.png) · [Explore](before-explore.png) · [Passport](before-passport.png)
- After: [Home](after-home.png) · [Explore](after-explore.png) · [Passport](after-passport.png) · [Finish form](after-finish-form.png) · [Share card](after-share-card.png)

Manrope is bundled in `assets/fonts` for offline use under the included SIL Open Font License.

Product choices are in [docs/product-decisions.md](docs/product-decisions.md); later dependencies are in [docs/roadmap.md](docs/roadmap.md).
