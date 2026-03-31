import 'package:ekush_models/ekush_models.dart';

class DatabaseService {
  DatabaseService._();

  static JhuriDatabase? _instance;

  static JhuriDatabase get instance {
    if (_instance == null) {
      throw StateError(
        'DatabaseService not initialized. '
        'Call DatabaseService.initialize() before accessing instance.',
      );
    }
    return _instance!;
  }

  static bool get isInitialized => _instance != null;

  static void initialize() {
    if (_instance != null) return;
    _instance = JhuriDatabase();
  }

  static Future<void> close() async {
    await _instance?.close();
    _instance = null;
  }
}
