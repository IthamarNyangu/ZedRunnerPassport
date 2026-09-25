# Tamanga product decisions

## Confirmed for this Stage 1 slice

- Android-first Flutter app with Home, Explore, Passport and Profile destinations.
- All bundled listings are visibly labelled fictional demo data. There is no claim that dates, organizers or prices are live.
- Price is a three-state value: `free`, `paid` or `unknown`. Unknown is never treated as free.
- Manual finishes are `selfReported`, carry a manual-entry source, and cannot become verified without a later explicit verification record.
- Manual finishes capture an explicit Race, Run or Walk type and a user-selected activity date. Older local records migrate as Race entries.
- Event and province stamps derived from self-reported finishes are visibly provisional.
- Distance milestones use configured categories (5, 10, 15, 21.1 and 42.2 km) and a small tolerance; first-distance and repeat achievements are separate.
- Saved events, race results and the optional share-name preference persist locally using `shared_preferences`.
- Share cards omit exact date, province, route and finish time. Displaying a generic runner name is opt-in and off by default.
- Bright-outdoor legibility, large touch targets, metric units, ZMW labels and Zambia-oriented place language guide the interface.
- Brand tokens use green `#188038`, deep green `#143D2B`, off-white `#F8F8F2`, orange `#E57A22`, restrained red `#C4473D` and near-black `#17231C`. Manrope is bundled locally under the SIL Open Font License.

## Technical choices

- Domain models and deterministic rules have no Flutter UI dependency, so they can move behind an API later.
- `TamangaStore` is the persistence boundary. `LocalTamangaStore` is the Stage 1 implementation; a remote/offline-sync repository can implement the same contract later.
- Demo event fixtures are immutable app data. User-generated state is stored separately and survives restarts.
- The interface uses original geometric treatments and a forest/copper/sun/sand palette inspired by Zambia's landscape and material culture. Reference app screens were used only for hierarchy and tone.

## Decisions still needed

1. What exactly qualifies a province stamp: organizer-verified finish, check-in, another evidence path, or more than one route?
2. Should Stage 1 collect a preferred display name and home province, and what account/auth provider is acceptable?
3. Which real event sources and organizers can authorize listings, edits, registration links and result verification?
4. What tolerance should each distance category use, especially trail events and device-measured activities?
5. Should sharing export a rendered image through the platform share sheet? This slice provides an in-app visual card and privacy-safe copied text without requesting media/file permissions.
6. What result-edit/deletion and backup policy should the pilot use before local records become cloud-synced?
