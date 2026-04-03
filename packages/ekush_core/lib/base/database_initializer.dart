import 'dart:async';

/// Base class for database initialization
/// 
/// Each app should implement this class to initialize their specific database
/// This class lives in ekush_core to provide a common interface across apps
/// without depending on specific database implementations
abstract class DatabaseInitializer {
  const DatabaseInitializer();

  /// Initialize the database
  /// 
  /// Returns true if initialization was successful, false otherwise
  Future<bool> initialize();

  /// Close the database connection
  /// 
  /// Called when the app is shutting down
  Future<void> close();

  /// Check if the database is initialized and ready
  /// 
  /// Returns true if the database is ready for operations
  bool get isInitialized;

  /// Get the database initialization status
  /// 
  /// Returns a stream that emits the initialization status
  Stream<bool> get initializationStatus;
}
