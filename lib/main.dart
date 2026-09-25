import 'package:flutter/material.dart';

import 'app.dart';
import 'data/local_store.dart';
import 'state/app_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final state = AppState(LocalTamangaStore());
  runApp(TamangaApp(state: state));
  state.load();
}
