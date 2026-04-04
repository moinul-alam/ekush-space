import 'package:drift/drift.dart';

// Categories table
@DataClassName('Category')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nameBangla => text()();
  TextColumn get nameEnglish => text()();
  TextColumn get imageIdentifier => text()();
  TextColumn get iconIdentifier => text()();
  IntColumn get sortOrder => integer()();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
}

// ItemTemplates table
@DataClassName('ItemTemplate')
class ItemTemplates extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nameBangla => text()();
  TextColumn get nameEnglish => text()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  RealColumn get defaultQuantity => real()();
  TextColumn get defaultUnit => text()();
  TextColumn get iconIdentifier => text()();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
  IntColumn get usageCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastUsedAt => dateTime()();
  DateTimeColumn get createdAt => dateTime().nullable()();
}

// ShoppingLists table
@DataClassName('ShoppingList')
class ShoppingLists extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withDefault(const Constant(''))();
  DateTimeColumn get buyDate => dateTime()();
  DateTimeColumn get reminderTime => dateTime().nullable()();
  BoolColumn get isReminderOn => boolean().withDefault(const Constant(false))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get sourceListId => integer().nullable()();
}

// ListItems table
@DataClassName('ListItem')
class ListItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get listId => integer().references(ShoppingLists, #id)();
  IntColumn get templateId =>
      integer().nullable().references(ItemTemplates, #id)();
  TextColumn get nameBangla => text()();
  TextColumn get nameEnglish => text()();
  RealColumn get quantity => real().withDefault(const Constant(1.0))();
  TextColumn get unit => text()();
  RealColumn get price => real().nullable()();
  BoolColumn get isBought => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer()();
  DateTimeColumn get addedAt => dateTime()();
}
