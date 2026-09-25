import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tamanga/app.dart';
import 'package:tamanga/data/local_store.dart';
import 'package:tamanga/domain/models.dart';
import 'package:tamanga/state/app_state.dart';

void main() {
  testWidgets('shows demo directory and four primary destinations', (
    tester,
  ) async {
    final state = AppState(MemoryStore());
    await state.load();
    await tester.pumpWidget(TamangaApp(state: state));
    await tester.pumpAndSettle();

    expect(find.text('Move well. Keep the story.'), findsOneWidget);
    expect(find.byType(NavigationDestination), findsNWidgets(4));
    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Demo directory'), findsOneWidget);
  });
}

class MemoryStore implements TamangaStore {
  @override
  Future<Set<String>> loadSavedEventIds() async => {};
  @override
  Future<List<RaceResult>> loadResults() async => [];
  @override
  Future<bool> loadShareNamePreference() async => false;
  @override
  Future<void> saveEventIds(Set<String> ids) async {}
  @override
  Future<void> saveResults(List<RaceResult> results) async {}
  @override
  Future<void> saveShareNamePreference(bool value) async {}
}
