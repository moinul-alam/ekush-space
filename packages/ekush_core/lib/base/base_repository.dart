import 'dart:async';

/// Base repository class that provides common database operations
///
/// This class defines the interface that all repositories should follow
/// It provides generic CRUD operations that can be implemented by specific repositories
abstract class BaseRepository<T> {
  const BaseRepository();

  /// Get all items
  Future<List<T>> getAll();

  /// Get item by ID
  Future<T?> getById(int id);

  /// Create a new item
  Future<int> create(T item);

  /// Update an existing item
  Future<bool> update(T item);

  /// Delete an item by ID
  Future<bool> delete(int id);

  /// Delete multiple items by IDs
  Future<bool> deleteAll(List<int> ids);

  /// Count total items
  Future<int> count();

  /// Check if an item exists by ID
  Future<bool> exists(int id);

  /// Get items with pagination
  Future<List<T>> getWithPagination({
    int limit = 20,
    int offset = 0,
    String? orderBy,
    bool ascending = true,
  });
}

/// Base repository for items that need soft delete functionality
abstract class SoftDeleteRepository<T> extends BaseRepository<T> {
  /// Get only active (non-deleted) items
  Future<List<T>> getActive();

  /// Get only archived (deleted) items
  Future<List<T>> getArchived();

  /// Soft delete an item (mark as archived)
  Future<bool> archive(int id);

  /// Restore an archived item
  Future<bool> restore(int id);

  /// Permanently delete an item
  Future<bool> permanentDelete(int id);
}
