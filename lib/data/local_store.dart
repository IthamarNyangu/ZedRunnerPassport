import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/models.dart';

abstract interface class TamangaStore {
  Future<Set<String>> loadSavedEventIds();
  Future<List<RaceResult>> loadResults();
  Future<bool> loadShareNamePreference();
  Future<void> saveEventIds(Set<String> ids);
  Future<void> saveResults(List<RaceResult> results);
  Future<void> saveShareNamePreference(bool value);
}

class LocalTamangaStore implements TamangaStore {
  static const _savedEventsKey = 'saved_event_ids_v1';
  static const _resultsKey = 'race_results_v1';
  static const _shareNameKey = 'share_name_v1';

  Future<SharedPreferences> get _preferences => SharedPreferences.getInstance();

  @override
  Future<Set<String>> loadSavedEventIds() async =>
      (await _preferences).getStringList(_savedEventsKey)?.toSet() ?? {};

  @override
  Future<List<RaceResult>> loadResults() async {
    final raw = (await _preferences).getString(_resultsKey);
    if (raw == null) return [];
    final values = jsonDecode(raw) as List<Object?>;
    return values
        .map(
          (value) =>
              RaceResult.fromJson((value! as Map).cast<String, Object?>()),
        )
        .toList();
  }

  @override
  Future<bool> loadShareNamePreference() async =>
      (await _preferences).getBool(_shareNameKey) ?? false;

  @override
  Future<void> saveEventIds(Set<String> ids) async =>
      (await _preferences).setStringList(_savedEventsKey, ids.toList());

  @override
  Future<void> saveResults(List<RaceResult> results) async =>
      (await _preferences).setString(
        _resultsKey,
        jsonEncode(results.map((result) => result.toJson()).toList()),
      );

  @override
  Future<void> saveShareNamePreference(bool value) async =>
      (await _preferences).setBool(_shareNameKey, value);
}
