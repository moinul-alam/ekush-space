import 'package:drift/drift.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';

class CategoryRepository extends BaseRepository {
  CategoryRepository(this._db);
  final JhuriDatabase _db;

  Future<List<Category>> getAllSorted() {
    return (_db.select(_db.categories)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  Future<Category?> getById(int id) {
    return (_db.select(_db.categories)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> insert(CategoriesCompanion entry) {
    return _db.into(_db.categories).insert(entry);
  }

  Future<int> countAll() {
    return _db.categories.count().getSingle();
  }
}
