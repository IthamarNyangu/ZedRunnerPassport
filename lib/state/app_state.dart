import 'package:flutter/foundation.dart';

import '../data/demo_events.dart';
import '../data/local_store.dart';
import '../domain/models.dart';
import '../domain/passport_rules.dart';

class AppState extends ChangeNotifier {
  AppState(this._store);

  final TamangaStore _store;
  final List<RaceEvent> events = demoEvents;
  Set<String> savedEventIds = {};
  List<RaceResult> results = [];
  bool includeNameOnShare = false;
  bool isLoading = true;
  String? loadError;

  List<PassportStamp> get stamps => PassportRules.deriveStamps(results);
  List<Achievement> get achievements =>
      PassportRules.deriveAchievements(results);
  Map<double, int> get repeatCounts => PassportRules.repeatCounts(results);

  Future<void> load() async {
    try {
      savedEventIds = await _store.loadSavedEventIds();
      results = await _store.loadResults();
      includeNameOnShare = await _store.loadShareNamePreference();
    } catch (_) {
      loadError =
          'Your local records could not be opened. You can still browse demo events.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleSaved(String eventId) async {
    if (!savedEventIds.add(eventId)) savedEventIds.remove(eventId);
    notifyListeners();
    await _store.saveEventIds(savedEventIds);
  }

  Future<void> addResult(RaceResult result) async {
    results = [result, ...results.where((item) => item.id != result.id)];
    notifyListeners();
    await _store.saveResults(results);
  }

  Future<void> setIncludeNameOnShare(bool value) async {
    includeNameOnShare = value;
    notifyListeners();
    await _store.saveShareNamePreference(value);
  }
}
