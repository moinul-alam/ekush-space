// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameBanglaMeta =
      const VerificationMeta('nameBangla');
  @override
  late final GeneratedColumn<String> nameBangla = GeneratedColumn<String>(
      'name_bangla', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameEnglishMeta =
      const VerificationMeta('nameEnglish');
  @override
  late final GeneratedColumn<String> nameEnglish = GeneratedColumn<String>(
      'name_english', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _imageIdentifierMeta =
      const VerificationMeta('imageIdentifier');
  @override
  late final GeneratedColumn<String> imageIdentifier = GeneratedColumn<String>(
      'image_identifier', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconIdentifierMeta =
      const VerificationMeta('iconIdentifier');
  @override
  late final GeneratedColumn<String> iconIdentifier = GeneratedColumn<String>(
      'icon_identifier', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isCustomMeta =
      const VerificationMeta('isCustom');
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
      'is_custom', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_custom" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        nameBangla,
        nameEnglish,
        imageIdentifier,
        iconIdentifier,
        sortOrder,
        isCustom,
        isActive
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name_bangla')) {
      context.handle(
          _nameBanglaMeta,
          nameBangla.isAcceptableOrUnknown(
              data['name_bangla']!, _nameBanglaMeta));
    } else if (isInserting) {
      context.missing(_nameBanglaMeta);
    }
    if (data.containsKey('name_english')) {
      context.handle(
          _nameEnglishMeta,
          nameEnglish.isAcceptableOrUnknown(
              data['name_english']!, _nameEnglishMeta));
    } else if (isInserting) {
      context.missing(_nameEnglishMeta);
    }
    if (data.containsKey('image_identifier')) {
      context.handle(
          _imageIdentifierMeta,
          imageIdentifier.isAcceptableOrUnknown(
              data['image_identifier']!, _imageIdentifierMeta));
    } else if (isInserting) {
      context.missing(_imageIdentifierMeta);
    }
    if (data.containsKey('icon_identifier')) {
      context.handle(
          _iconIdentifierMeta,
          iconIdentifier.isAcceptableOrUnknown(
              data['icon_identifier']!, _iconIdentifierMeta));
    } else if (isInserting) {
      context.missing(_iconIdentifierMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('is_custom')) {
      context.handle(_isCustomMeta,
          isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nameBangla: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_bangla'])!,
      nameEnglish: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_english'])!,
      imageIdentifier: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}image_identifier'])!,
      iconIdentifier: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}icon_identifier'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      isCustom: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_custom'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String nameBangla;
  final String nameEnglish;
  final String imageIdentifier;
  final String iconIdentifier;
  final int sortOrder;
  final bool isCustom;
  final bool isActive;
  const Category(
      {required this.id,
      required this.nameBangla,
      required this.nameEnglish,
      required this.imageIdentifier,
      required this.iconIdentifier,
      required this.sortOrder,
      required this.isCustom,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name_bangla'] = Variable<String>(nameBangla);
    map['name_english'] = Variable<String>(nameEnglish);
    map['image_identifier'] = Variable<String>(imageIdentifier);
    map['icon_identifier'] = Variable<String>(iconIdentifier);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_custom'] = Variable<bool>(isCustom);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      nameBangla: Value(nameBangla),
      nameEnglish: Value(nameEnglish),
      imageIdentifier: Value(imageIdentifier),
      iconIdentifier: Value(iconIdentifier),
      sortOrder: Value(sortOrder),
      isCustom: Value(isCustom),
      isActive: Value(isActive),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      nameBangla: serializer.fromJson<String>(json['nameBangla']),
      nameEnglish: serializer.fromJson<String>(json['nameEnglish']),
      imageIdentifier: serializer.fromJson<String>(json['imageIdentifier']),
      iconIdentifier: serializer.fromJson<String>(json['iconIdentifier']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nameBangla': serializer.toJson<String>(nameBangla),
      'nameEnglish': serializer.toJson<String>(nameEnglish),
      'imageIdentifier': serializer.toJson<String>(imageIdentifier),
      'iconIdentifier': serializer.toJson<String>(iconIdentifier),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isCustom': serializer.toJson<bool>(isCustom),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Category copyWith(
          {int? id,
          String? nameBangla,
          String? nameEnglish,
          String? imageIdentifier,
          String? iconIdentifier,
          int? sortOrder,
          bool? isCustom,
          bool? isActive}) =>
      Category(
        id: id ?? this.id,
        nameBangla: nameBangla ?? this.nameBangla,
        nameEnglish: nameEnglish ?? this.nameEnglish,
        imageIdentifier: imageIdentifier ?? this.imageIdentifier,
        iconIdentifier: iconIdentifier ?? this.iconIdentifier,
        sortOrder: sortOrder ?? this.sortOrder,
        isCustom: isCustom ?? this.isCustom,
        isActive: isActive ?? this.isActive,
      );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      nameBangla:
          data.nameBangla.present ? data.nameBangla.value : this.nameBangla,
      nameEnglish:
          data.nameEnglish.present ? data.nameEnglish.value : this.nameEnglish,
      imageIdentifier: data.imageIdentifier.present
          ? data.imageIdentifier.value
          : this.imageIdentifier,
      iconIdentifier: data.iconIdentifier.present
          ? data.iconIdentifier.value
          : this.iconIdentifier,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('nameBangla: $nameBangla, ')
          ..write('nameEnglish: $nameEnglish, ')
          ..write('imageIdentifier: $imageIdentifier, ')
          ..write('iconIdentifier: $iconIdentifier, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isCustom: $isCustom, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nameBangla, nameEnglish, imageIdentifier,
      iconIdentifier, sortOrder, isCustom, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.nameBangla == this.nameBangla &&
          other.nameEnglish == this.nameEnglish &&
          other.imageIdentifier == this.imageIdentifier &&
          other.iconIdentifier == this.iconIdentifier &&
          other.sortOrder == this.sortOrder &&
          other.isCustom == this.isCustom &&
          other.isActive == this.isActive);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> nameBangla;
  final Value<String> nameEnglish;
  final Value<String> imageIdentifier;
  final Value<String> iconIdentifier;
  final Value<int> sortOrder;
  final Value<bool> isCustom;
  final Value<bool> isActive;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.nameBangla = const Value.absent(),
    this.nameEnglish = const Value.absent(),
    this.imageIdentifier = const Value.absent(),
    this.iconIdentifier = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String nameBangla,
    required String nameEnglish,
    required String imageIdentifier,
    required String iconIdentifier,
    required int sortOrder,
    this.isCustom = const Value.absent(),
    this.isActive = const Value.absent(),
  })  : nameBangla = Value(nameBangla),
        nameEnglish = Value(nameEnglish),
        imageIdentifier = Value(imageIdentifier),
        iconIdentifier = Value(iconIdentifier),
        sortOrder = Value(sortOrder);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? nameBangla,
    Expression<String>? nameEnglish,
    Expression<String>? imageIdentifier,
    Expression<String>? iconIdentifier,
    Expression<int>? sortOrder,
    Expression<bool>? isCustom,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameBangla != null) 'name_bangla': nameBangla,
      if (nameEnglish != null) 'name_english': nameEnglish,
      if (imageIdentifier != null) 'image_identifier': imageIdentifier,
      if (iconIdentifier != null) 'icon_identifier': iconIdentifier,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isCustom != null) 'is_custom': isCustom,
      if (isActive != null) 'is_active': isActive,
    });
  }

  CategoriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? nameBangla,
      Value<String>? nameEnglish,
      Value<String>? imageIdentifier,
      Value<String>? iconIdentifier,
      Value<int>? sortOrder,
      Value<bool>? isCustom,
      Value<bool>? isActive}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      nameBangla: nameBangla ?? this.nameBangla,
      nameEnglish: nameEnglish ?? this.nameEnglish,
      imageIdentifier: imageIdentifier ?? this.imageIdentifier,
      iconIdentifier: iconIdentifier ?? this.iconIdentifier,
      sortOrder: sortOrder ?? this.sortOrder,
      isCustom: isCustom ?? this.isCustom,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nameBangla.present) {
      map['name_bangla'] = Variable<String>(nameBangla.value);
    }
    if (nameEnglish.present) {
      map['name_english'] = Variable<String>(nameEnglish.value);
    }
    if (imageIdentifier.present) {
      map['image_identifier'] = Variable<String>(imageIdentifier.value);
    }
    if (iconIdentifier.present) {
      map['icon_identifier'] = Variable<String>(iconIdentifier.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('nameBangla: $nameBangla, ')
          ..write('nameEnglish: $nameEnglish, ')
          ..write('imageIdentifier: $imageIdentifier, ')
          ..write('iconIdentifier: $iconIdentifier, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isCustom: $isCustom, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $ItemTemplatesTable extends ItemTemplates
    with TableInfo<$ItemTemplatesTable, ItemTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameBanglaMeta =
      const VerificationMeta('nameBangla');
  @override
  late final GeneratedColumn<String> nameBangla = GeneratedColumn<String>(
      'name_bangla', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameEnglishMeta =
      const VerificationMeta('nameEnglish');
  @override
  late final GeneratedColumn<String> nameEnglish = GeneratedColumn<String>(
      'name_english', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneticNameMeta =
      const VerificationMeta('phoneticName');
  @override
  late final GeneratedColumn<String> phoneticName = GeneratedColumn<String>(
      'phonetic_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES categories (id)'));
  static const VerificationMeta _defaultQuantityMeta =
      const VerificationMeta('defaultQuantity');
  @override
  late final GeneratedColumn<double> defaultQuantity = GeneratedColumn<double>(
      'default_quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _defaultUnitMeta =
      const VerificationMeta('defaultUnit');
  @override
  late final GeneratedColumn<String> defaultUnit = GeneratedColumn<String>(
      'default_unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconIdentifierMeta =
      const VerificationMeta('iconIdentifier');
  @override
  late final GeneratedColumn<String> iconIdentifier = GeneratedColumn<String>(
      'icon_identifier', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
      'emoji', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('🛒'));
  static const VerificationMeta _isCustomMeta =
      const VerificationMeta('isCustom');
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
      'is_custom', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_custom" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _usageCountMeta =
      const VerificationMeta('usageCount');
  @override
  late final GeneratedColumn<int> usageCount = GeneratedColumn<int>(
      'usage_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastUsedAtMeta =
      const VerificationMeta('lastUsedAt');
  @override
  late final GeneratedColumn<DateTime> lastUsedAt = GeneratedColumn<DateTime>(
      'last_used_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        nameBangla,
        nameEnglish,
        phoneticName,
        categoryId,
        defaultQuantity,
        defaultUnit,
        iconIdentifier,
        emoji,
        isCustom,
        isActive,
        usageCount,
        sortOrder,
        lastUsedAt,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'item_templates';
  @override
  VerificationContext validateIntegrity(Insertable<ItemTemplate> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name_bangla')) {
      context.handle(
          _nameBanglaMeta,
          nameBangla.isAcceptableOrUnknown(
              data['name_bangla']!, _nameBanglaMeta));
    } else if (isInserting) {
      context.missing(_nameBanglaMeta);
    }
    if (data.containsKey('name_english')) {
      context.handle(
          _nameEnglishMeta,
          nameEnglish.isAcceptableOrUnknown(
              data['name_english']!, _nameEnglishMeta));
    } else if (isInserting) {
      context.missing(_nameEnglishMeta);
    }
    if (data.containsKey('phonetic_name')) {
      context.handle(
          _phoneticNameMeta,
          phoneticName.isAcceptableOrUnknown(
              data['phonetic_name']!, _phoneticNameMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('default_quantity')) {
      context.handle(
          _defaultQuantityMeta,
          defaultQuantity.isAcceptableOrUnknown(
              data['default_quantity']!, _defaultQuantityMeta));
    } else if (isInserting) {
      context.missing(_defaultQuantityMeta);
    }
    if (data.containsKey('default_unit')) {
      context.handle(
          _defaultUnitMeta,
          defaultUnit.isAcceptableOrUnknown(
              data['default_unit']!, _defaultUnitMeta));
    } else if (isInserting) {
      context.missing(_defaultUnitMeta);
    }
    if (data.containsKey('icon_identifier')) {
      context.handle(
          _iconIdentifierMeta,
          iconIdentifier.isAcceptableOrUnknown(
              data['icon_identifier']!, _iconIdentifierMeta));
    }
    if (data.containsKey('emoji')) {
      context.handle(
          _emojiMeta, emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta));
    }
    if (data.containsKey('is_custom')) {
      context.handle(_isCustomMeta,
          isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('usage_count')) {
      context.handle(
          _usageCountMeta,
          usageCount.isAcceptableOrUnknown(
              data['usage_count']!, _usageCountMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('last_used_at')) {
      context.handle(
          _lastUsedAtMeta,
          lastUsedAt.isAcceptableOrUnknown(
              data['last_used_at']!, _lastUsedAtMeta));
    } else if (isInserting) {
      context.missing(_lastUsedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ItemTemplate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemTemplate(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nameBangla: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_bangla'])!,
      nameEnglish: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_english'])!,
      phoneticName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phonetic_name']),
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
      defaultQuantity: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}default_quantity'])!,
      defaultUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}default_unit'])!,
      iconIdentifier: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon_identifier']),
      emoji: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}emoji'])!,
      isCustom: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_custom'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      usageCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}usage_count'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      lastUsedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_used_at'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
    );
  }

  @override
  $ItemTemplatesTable createAlias(String alias) {
    return $ItemTemplatesTable(attachedDatabase, alias);
  }
}

class ItemTemplate extends DataClass implements Insertable<ItemTemplate> {
  final int id;
  final String nameBangla;
  final String nameEnglish;
  final String? phoneticName;
  final int categoryId;
  final double defaultQuantity;
  final String defaultUnit;
  final String? iconIdentifier;
  final String emoji;
  final bool isCustom;
  final bool isActive;
  final int usageCount;
  final int sortOrder;
  final DateTime lastUsedAt;
  final DateTime? createdAt;
  const ItemTemplate(
      {required this.id,
      required this.nameBangla,
      required this.nameEnglish,
      this.phoneticName,
      required this.categoryId,
      required this.defaultQuantity,
      required this.defaultUnit,
      this.iconIdentifier,
      required this.emoji,
      required this.isCustom,
      required this.isActive,
      required this.usageCount,
      required this.sortOrder,
      required this.lastUsedAt,
      this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name_bangla'] = Variable<String>(nameBangla);
    map['name_english'] = Variable<String>(nameEnglish);
    if (!nullToAbsent || phoneticName != null) {
      map['phonetic_name'] = Variable<String>(phoneticName);
    }
    map['category_id'] = Variable<int>(categoryId);
    map['default_quantity'] = Variable<double>(defaultQuantity);
    map['default_unit'] = Variable<String>(defaultUnit);
    if (!nullToAbsent || iconIdentifier != null) {
      map['icon_identifier'] = Variable<String>(iconIdentifier);
    }
    map['emoji'] = Variable<String>(emoji);
    map['is_custom'] = Variable<bool>(isCustom);
    map['is_active'] = Variable<bool>(isActive);
    map['usage_count'] = Variable<int>(usageCount);
    map['sort_order'] = Variable<int>(sortOrder);
    map['last_used_at'] = Variable<DateTime>(lastUsedAt);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  ItemTemplatesCompanion toCompanion(bool nullToAbsent) {
    return ItemTemplatesCompanion(
      id: Value(id),
      nameBangla: Value(nameBangla),
      nameEnglish: Value(nameEnglish),
      phoneticName: phoneticName == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneticName),
      categoryId: Value(categoryId),
      defaultQuantity: Value(defaultQuantity),
      defaultUnit: Value(defaultUnit),
      iconIdentifier: iconIdentifier == null && nullToAbsent
          ? const Value.absent()
          : Value(iconIdentifier),
      emoji: Value(emoji),
      isCustom: Value(isCustom),
      isActive: Value(isActive),
      usageCount: Value(usageCount),
      sortOrder: Value(sortOrder),
      lastUsedAt: Value(lastUsedAt),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory ItemTemplate.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemTemplate(
      id: serializer.fromJson<int>(json['id']),
      nameBangla: serializer.fromJson<String>(json['nameBangla']),
      nameEnglish: serializer.fromJson<String>(json['nameEnglish']),
      phoneticName: serializer.fromJson<String?>(json['phoneticName']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      defaultQuantity: serializer.fromJson<double>(json['defaultQuantity']),
      defaultUnit: serializer.fromJson<String>(json['defaultUnit']),
      iconIdentifier: serializer.fromJson<String?>(json['iconIdentifier']),
      emoji: serializer.fromJson<String>(json['emoji']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      usageCount: serializer.fromJson<int>(json['usageCount']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      lastUsedAt: serializer.fromJson<DateTime>(json['lastUsedAt']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nameBangla': serializer.toJson<String>(nameBangla),
      'nameEnglish': serializer.toJson<String>(nameEnglish),
      'phoneticName': serializer.toJson<String?>(phoneticName),
      'categoryId': serializer.toJson<int>(categoryId),
      'defaultQuantity': serializer.toJson<double>(defaultQuantity),
      'defaultUnit': serializer.toJson<String>(defaultUnit),
      'iconIdentifier': serializer.toJson<String?>(iconIdentifier),
      'emoji': serializer.toJson<String>(emoji),
      'isCustom': serializer.toJson<bool>(isCustom),
      'isActive': serializer.toJson<bool>(isActive),
      'usageCount': serializer.toJson<int>(usageCount),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'lastUsedAt': serializer.toJson<DateTime>(lastUsedAt),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  ItemTemplate copyWith(
          {int? id,
          String? nameBangla,
          String? nameEnglish,
          Value<String?> phoneticName = const Value.absent(),
          int? categoryId,
          double? defaultQuantity,
          String? defaultUnit,
          Value<String?> iconIdentifier = const Value.absent(),
          String? emoji,
          bool? isCustom,
          bool? isActive,
          int? usageCount,
          int? sortOrder,
          DateTime? lastUsedAt,
          Value<DateTime?> createdAt = const Value.absent()}) =>
      ItemTemplate(
        id: id ?? this.id,
        nameBangla: nameBangla ?? this.nameBangla,
        nameEnglish: nameEnglish ?? this.nameEnglish,
        phoneticName:
            phoneticName.present ? phoneticName.value : this.phoneticName,
        categoryId: categoryId ?? this.categoryId,
        defaultQuantity: defaultQuantity ?? this.defaultQuantity,
        defaultUnit: defaultUnit ?? this.defaultUnit,
        iconIdentifier:
            iconIdentifier.present ? iconIdentifier.value : this.iconIdentifier,
        emoji: emoji ?? this.emoji,
        isCustom: isCustom ?? this.isCustom,
        isActive: isActive ?? this.isActive,
        usageCount: usageCount ?? this.usageCount,
        sortOrder: sortOrder ?? this.sortOrder,
        lastUsedAt: lastUsedAt ?? this.lastUsedAt,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
      );
  ItemTemplate copyWithCompanion(ItemTemplatesCompanion data) {
    return ItemTemplate(
      id: data.id.present ? data.id.value : this.id,
      nameBangla:
          data.nameBangla.present ? data.nameBangla.value : this.nameBangla,
      nameEnglish:
          data.nameEnglish.present ? data.nameEnglish.value : this.nameEnglish,
      phoneticName: data.phoneticName.present
          ? data.phoneticName.value
          : this.phoneticName,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      defaultQuantity: data.defaultQuantity.present
          ? data.defaultQuantity.value
          : this.defaultQuantity,
      defaultUnit:
          data.defaultUnit.present ? data.defaultUnit.value : this.defaultUnit,
      iconIdentifier: data.iconIdentifier.present
          ? data.iconIdentifier.value
          : this.iconIdentifier,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      usageCount:
          data.usageCount.present ? data.usageCount.value : this.usageCount,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      lastUsedAt:
          data.lastUsedAt.present ? data.lastUsedAt.value : this.lastUsedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemTemplate(')
          ..write('id: $id, ')
          ..write('nameBangla: $nameBangla, ')
          ..write('nameEnglish: $nameEnglish, ')
          ..write('phoneticName: $phoneticName, ')
          ..write('categoryId: $categoryId, ')
          ..write('defaultQuantity: $defaultQuantity, ')
          ..write('defaultUnit: $defaultUnit, ')
          ..write('iconIdentifier: $iconIdentifier, ')
          ..write('emoji: $emoji, ')
          ..write('isCustom: $isCustom, ')
          ..write('isActive: $isActive, ')
          ..write('usageCount: $usageCount, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      nameBangla,
      nameEnglish,
      phoneticName,
      categoryId,
      defaultQuantity,
      defaultUnit,
      iconIdentifier,
      emoji,
      isCustom,
      isActive,
      usageCount,
      sortOrder,
      lastUsedAt,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemTemplate &&
          other.id == this.id &&
          other.nameBangla == this.nameBangla &&
          other.nameEnglish == this.nameEnglish &&
          other.phoneticName == this.phoneticName &&
          other.categoryId == this.categoryId &&
          other.defaultQuantity == this.defaultQuantity &&
          other.defaultUnit == this.defaultUnit &&
          other.iconIdentifier == this.iconIdentifier &&
          other.emoji == this.emoji &&
          other.isCustom == this.isCustom &&
          other.isActive == this.isActive &&
          other.usageCount == this.usageCount &&
          other.sortOrder == this.sortOrder &&
          other.lastUsedAt == this.lastUsedAt &&
          other.createdAt == this.createdAt);
}

class ItemTemplatesCompanion extends UpdateCompanion<ItemTemplate> {
  final Value<int> id;
  final Value<String> nameBangla;
  final Value<String> nameEnglish;
  final Value<String?> phoneticName;
  final Value<int> categoryId;
  final Value<double> defaultQuantity;
  final Value<String> defaultUnit;
  final Value<String?> iconIdentifier;
  final Value<String> emoji;
  final Value<bool> isCustom;
  final Value<bool> isActive;
  final Value<int> usageCount;
  final Value<int> sortOrder;
  final Value<DateTime> lastUsedAt;
  final Value<DateTime?> createdAt;
  const ItemTemplatesCompanion({
    this.id = const Value.absent(),
    this.nameBangla = const Value.absent(),
    this.nameEnglish = const Value.absent(),
    this.phoneticName = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.defaultQuantity = const Value.absent(),
    this.defaultUnit = const Value.absent(),
    this.iconIdentifier = const Value.absent(),
    this.emoji = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.isActive = const Value.absent(),
    this.usageCount = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ItemTemplatesCompanion.insert({
    this.id = const Value.absent(),
    required String nameBangla,
    required String nameEnglish,
    this.phoneticName = const Value.absent(),
    required int categoryId,
    required double defaultQuantity,
    required String defaultUnit,
    this.iconIdentifier = const Value.absent(),
    this.emoji = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.isActive = const Value.absent(),
    this.usageCount = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime lastUsedAt,
    this.createdAt = const Value.absent(),
  })  : nameBangla = Value(nameBangla),
        nameEnglish = Value(nameEnglish),
        categoryId = Value(categoryId),
        defaultQuantity = Value(defaultQuantity),
        defaultUnit = Value(defaultUnit),
        lastUsedAt = Value(lastUsedAt);
  static Insertable<ItemTemplate> custom({
    Expression<int>? id,
    Expression<String>? nameBangla,
    Expression<String>? nameEnglish,
    Expression<String>? phoneticName,
    Expression<int>? categoryId,
    Expression<double>? defaultQuantity,
    Expression<String>? defaultUnit,
    Expression<String>? iconIdentifier,
    Expression<String>? emoji,
    Expression<bool>? isCustom,
    Expression<bool>? isActive,
    Expression<int>? usageCount,
    Expression<int>? sortOrder,
    Expression<DateTime>? lastUsedAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameBangla != null) 'name_bangla': nameBangla,
      if (nameEnglish != null) 'name_english': nameEnglish,
      if (phoneticName != null) 'phonetic_name': phoneticName,
      if (categoryId != null) 'category_id': categoryId,
      if (defaultQuantity != null) 'default_quantity': defaultQuantity,
      if (defaultUnit != null) 'default_unit': defaultUnit,
      if (iconIdentifier != null) 'icon_identifier': iconIdentifier,
      if (emoji != null) 'emoji': emoji,
      if (isCustom != null) 'is_custom': isCustom,
      if (isActive != null) 'is_active': isActive,
      if (usageCount != null) 'usage_count': usageCount,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (lastUsedAt != null) 'last_used_at': lastUsedAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ItemTemplatesCompanion copyWith(
      {Value<int>? id,
      Value<String>? nameBangla,
      Value<String>? nameEnglish,
      Value<String?>? phoneticName,
      Value<int>? categoryId,
      Value<double>? defaultQuantity,
      Value<String>? defaultUnit,
      Value<String?>? iconIdentifier,
      Value<String>? emoji,
      Value<bool>? isCustom,
      Value<bool>? isActive,
      Value<int>? usageCount,
      Value<int>? sortOrder,
      Value<DateTime>? lastUsedAt,
      Value<DateTime?>? createdAt}) {
    return ItemTemplatesCompanion(
      id: id ?? this.id,
      nameBangla: nameBangla ?? this.nameBangla,
      nameEnglish: nameEnglish ?? this.nameEnglish,
      phoneticName: phoneticName ?? this.phoneticName,
      categoryId: categoryId ?? this.categoryId,
      defaultQuantity: defaultQuantity ?? this.defaultQuantity,
      defaultUnit: defaultUnit ?? this.defaultUnit,
      iconIdentifier: iconIdentifier ?? this.iconIdentifier,
      emoji: emoji ?? this.emoji,
      isCustom: isCustom ?? this.isCustom,
      isActive: isActive ?? this.isActive,
      usageCount: usageCount ?? this.usageCount,
      sortOrder: sortOrder ?? this.sortOrder,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nameBangla.present) {
      map['name_bangla'] = Variable<String>(nameBangla.value);
    }
    if (nameEnglish.present) {
      map['name_english'] = Variable<String>(nameEnglish.value);
    }
    if (phoneticName.present) {
      map['phonetic_name'] = Variable<String>(phoneticName.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (defaultQuantity.present) {
      map['default_quantity'] = Variable<double>(defaultQuantity.value);
    }
    if (defaultUnit.present) {
      map['default_unit'] = Variable<String>(defaultUnit.value);
    }
    if (iconIdentifier.present) {
      map['icon_identifier'] = Variable<String>(iconIdentifier.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (usageCount.present) {
      map['usage_count'] = Variable<int>(usageCount.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (lastUsedAt.present) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('nameBangla: $nameBangla, ')
          ..write('nameEnglish: $nameEnglish, ')
          ..write('phoneticName: $phoneticName, ')
          ..write('categoryId: $categoryId, ')
          ..write('defaultQuantity: $defaultQuantity, ')
          ..write('defaultUnit: $defaultUnit, ')
          ..write('iconIdentifier: $iconIdentifier, ')
          ..write('emoji: $emoji, ')
          ..write('isCustom: $isCustom, ')
          ..write('isActive: $isActive, ')
          ..write('usageCount: $usageCount, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ShoppingListsTable extends ShoppingLists
    with TableInfo<$ShoppingListsTable, ShoppingList> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShoppingListsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _buyDateMeta =
      const VerificationMeta('buyDate');
  @override
  late final GeneratedColumn<DateTime> buyDate = GeneratedColumn<DateTime>(
      'buy_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _reminderTimeMeta =
      const VerificationMeta('reminderTime');
  @override
  late final GeneratedColumn<DateTime> reminderTime = GeneratedColumn<DateTime>(
      'reminder_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isReminderOnMeta =
      const VerificationMeta('isReminderOn');
  @override
  late final GeneratedColumn<bool> isReminderOn = GeneratedColumn<bool>(
      'is_reminder_on', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_reminder_on" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isArchivedMeta =
      const VerificationMeta('isArchived');
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
      'is_archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_archived" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _sourceListIdMeta =
      const VerificationMeta('sourceListId');
  @override
  late final GeneratedColumn<int> sourceListId = GeneratedColumn<int>(
      'source_list_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        buyDate,
        reminderTime,
        isReminderOn,
        isCompleted,
        isArchived,
        createdAt,
        completedAt,
        sourceListId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_lists';
  @override
  VerificationContext validateIntegrity(Insertable<ShoppingList> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('buy_date')) {
      context.handle(_buyDateMeta,
          buyDate.isAcceptableOrUnknown(data['buy_date']!, _buyDateMeta));
    } else if (isInserting) {
      context.missing(_buyDateMeta);
    }
    if (data.containsKey('reminder_time')) {
      context.handle(
          _reminderTimeMeta,
          reminderTime.isAcceptableOrUnknown(
              data['reminder_time']!, _reminderTimeMeta));
    }
    if (data.containsKey('is_reminder_on')) {
      context.handle(
          _isReminderOnMeta,
          isReminderOn.isAcceptableOrUnknown(
              data['is_reminder_on']!, _isReminderOnMeta));
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    if (data.containsKey('is_archived')) {
      context.handle(
          _isArchivedMeta,
          isArchived.isAcceptableOrUnknown(
              data['is_archived']!, _isArchivedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('source_list_id')) {
      context.handle(
          _sourceListIdMeta,
          sourceListId.isAcceptableOrUnknown(
              data['source_list_id']!, _sourceListIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingList map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingList(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      buyDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}buy_date'])!,
      reminderTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}reminder_time']),
      isReminderOn: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_reminder_on'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      isArchived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_archived'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      sourceListId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}source_list_id']),
    );
  }

  @override
  $ShoppingListsTable createAlias(String alias) {
    return $ShoppingListsTable(attachedDatabase, alias);
  }
}

class ShoppingList extends DataClass implements Insertable<ShoppingList> {
  final int id;
  final String title;
  final DateTime buyDate;
  final DateTime? reminderTime;
  final bool isReminderOn;
  final bool isCompleted;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime? completedAt;
  final int? sourceListId;
  const ShoppingList(
      {required this.id,
      required this.title,
      required this.buyDate,
      this.reminderTime,
      required this.isReminderOn,
      required this.isCompleted,
      required this.isArchived,
      required this.createdAt,
      this.completedAt,
      this.sourceListId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['buy_date'] = Variable<DateTime>(buyDate);
    if (!nullToAbsent || reminderTime != null) {
      map['reminder_time'] = Variable<DateTime>(reminderTime);
    }
    map['is_reminder_on'] = Variable<bool>(isReminderOn);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || sourceListId != null) {
      map['source_list_id'] = Variable<int>(sourceListId);
    }
    return map;
  }

  ShoppingListsCompanion toCompanion(bool nullToAbsent) {
    return ShoppingListsCompanion(
      id: Value(id),
      title: Value(title),
      buyDate: Value(buyDate),
      reminderTime: reminderTime == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderTime),
      isReminderOn: Value(isReminderOn),
      isCompleted: Value(isCompleted),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      sourceListId: sourceListId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceListId),
    );
  }

  factory ShoppingList.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingList(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      buyDate: serializer.fromJson<DateTime>(json['buyDate']),
      reminderTime: serializer.fromJson<DateTime?>(json['reminderTime']),
      isReminderOn: serializer.fromJson<bool>(json['isReminderOn']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      sourceListId: serializer.fromJson<int?>(json['sourceListId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'buyDate': serializer.toJson<DateTime>(buyDate),
      'reminderTime': serializer.toJson<DateTime?>(reminderTime),
      'isReminderOn': serializer.toJson<bool>(isReminderOn),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'sourceListId': serializer.toJson<int?>(sourceListId),
    };
  }

  ShoppingList copyWith(
          {int? id,
          String? title,
          DateTime? buyDate,
          Value<DateTime?> reminderTime = const Value.absent(),
          bool? isReminderOn,
          bool? isCompleted,
          bool? isArchived,
          DateTime? createdAt,
          Value<DateTime?> completedAt = const Value.absent(),
          Value<int?> sourceListId = const Value.absent()}) =>
      ShoppingList(
        id: id ?? this.id,
        title: title ?? this.title,
        buyDate: buyDate ?? this.buyDate,
        reminderTime:
            reminderTime.present ? reminderTime.value : this.reminderTime,
        isReminderOn: isReminderOn ?? this.isReminderOn,
        isCompleted: isCompleted ?? this.isCompleted,
        isArchived: isArchived ?? this.isArchived,
        createdAt: createdAt ?? this.createdAt,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        sourceListId:
            sourceListId.present ? sourceListId.value : this.sourceListId,
      );
  ShoppingList copyWithCompanion(ShoppingListsCompanion data) {
    return ShoppingList(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      buyDate: data.buyDate.present ? data.buyDate.value : this.buyDate,
      reminderTime: data.reminderTime.present
          ? data.reminderTime.value
          : this.reminderTime,
      isReminderOn: data.isReminderOn.present
          ? data.isReminderOn.value
          : this.isReminderOn,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      isArchived:
          data.isArchived.present ? data.isArchived.value : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      sourceListId: data.sourceListId.present
          ? data.sourceListId.value
          : this.sourceListId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingList(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('buyDate: $buyDate, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('isReminderOn: $isReminderOn, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('sourceListId: $sourceListId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      buyDate,
      reminderTime,
      isReminderOn,
      isCompleted,
      isArchived,
      createdAt,
      completedAt,
      sourceListId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingList &&
          other.id == this.id &&
          other.title == this.title &&
          other.buyDate == this.buyDate &&
          other.reminderTime == this.reminderTime &&
          other.isReminderOn == this.isReminderOn &&
          other.isCompleted == this.isCompleted &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt &&
          other.completedAt == this.completedAt &&
          other.sourceListId == this.sourceListId);
}

class ShoppingListsCompanion extends UpdateCompanion<ShoppingList> {
  final Value<int> id;
  final Value<String> title;
  final Value<DateTime> buyDate;
  final Value<DateTime?> reminderTime;
  final Value<bool> isReminderOn;
  final Value<bool> isCompleted;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  final Value<DateTime?> completedAt;
  final Value<int?> sourceListId;
  const ShoppingListsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.buyDate = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.isReminderOn = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.sourceListId = const Value.absent(),
  });
  ShoppingListsCompanion.insert({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    required DateTime buyDate,
    this.reminderTime = const Value.absent(),
    this.isReminderOn = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.isArchived = const Value.absent(),
    required DateTime createdAt,
    this.completedAt = const Value.absent(),
    this.sourceListId = const Value.absent(),
  })  : buyDate = Value(buyDate),
        createdAt = Value(createdAt);
  static Insertable<ShoppingList> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<DateTime>? buyDate,
    Expression<DateTime>? reminderTime,
    Expression<bool>? isReminderOn,
    Expression<bool>? isCompleted,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? completedAt,
    Expression<int>? sourceListId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (buyDate != null) 'buy_date': buyDate,
      if (reminderTime != null) 'reminder_time': reminderTime,
      if (isReminderOn != null) 'is_reminder_on': isReminderOn,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (sourceListId != null) 'source_list_id': sourceListId,
    });
  }

  ShoppingListsCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<DateTime>? buyDate,
      Value<DateTime?>? reminderTime,
      Value<bool>? isReminderOn,
      Value<bool>? isCompleted,
      Value<bool>? isArchived,
      Value<DateTime>? createdAt,
      Value<DateTime?>? completedAt,
      Value<int?>? sourceListId}) {
    return ShoppingListsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      buyDate: buyDate ?? this.buyDate,
      reminderTime: reminderTime ?? this.reminderTime,
      isReminderOn: isReminderOn ?? this.isReminderOn,
      isCompleted: isCompleted ?? this.isCompleted,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      sourceListId: sourceListId ?? this.sourceListId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (buyDate.present) {
      map['buy_date'] = Variable<DateTime>(buyDate.value);
    }
    if (reminderTime.present) {
      map['reminder_time'] = Variable<DateTime>(reminderTime.value);
    }
    if (isReminderOn.present) {
      map['is_reminder_on'] = Variable<bool>(isReminderOn.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (sourceListId.present) {
      map['source_list_id'] = Variable<int>(sourceListId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('buyDate: $buyDate, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('isReminderOn: $isReminderOn, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('sourceListId: $sourceListId')
          ..write(')'))
        .toString();
  }
}

class $ListItemsTable extends ListItems
    with TableInfo<$ListItemsTable, ListItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ListItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _listIdMeta = const VerificationMeta('listId');
  @override
  late final GeneratedColumn<int> listId = GeneratedColumn<int>(
      'list_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES shopping_lists (id)'));
  static const VerificationMeta _templateIdMeta =
      const VerificationMeta('templateId');
  @override
  late final GeneratedColumn<int> templateId = GeneratedColumn<int>(
      'template_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES item_templates (id)'));
  static const VerificationMeta _nameBanglaMeta =
      const VerificationMeta('nameBangla');
  @override
  late final GeneratedColumn<String> nameBangla = GeneratedColumn<String>(
      'name_bangla', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameEnglishMeta =
      const VerificationMeta('nameEnglish');
  @override
  late final GeneratedColumn<String> nameEnglish = GeneratedColumn<String>(
      'name_english', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.0));
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _isBoughtMeta =
      const VerificationMeta('isBought');
  @override
  late final GeneratedColumn<bool> isBought = GeneratedColumn<bool>(
      'is_bought', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_bought" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _addedAtMeta =
      const VerificationMeta('addedAt');
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
      'added_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        listId,
        templateId,
        nameBangla,
        nameEnglish,
        quantity,
        unit,
        price,
        isBought,
        sortOrder,
        addedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'list_items';
  @override
  VerificationContext validateIntegrity(Insertable<ListItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('list_id')) {
      context.handle(_listIdMeta,
          listId.isAcceptableOrUnknown(data['list_id']!, _listIdMeta));
    } else if (isInserting) {
      context.missing(_listIdMeta);
    }
    if (data.containsKey('template_id')) {
      context.handle(
          _templateIdMeta,
          templateId.isAcceptableOrUnknown(
              data['template_id']!, _templateIdMeta));
    }
    if (data.containsKey('name_bangla')) {
      context.handle(
          _nameBanglaMeta,
          nameBangla.isAcceptableOrUnknown(
              data['name_bangla']!, _nameBanglaMeta));
    } else if (isInserting) {
      context.missing(_nameBanglaMeta);
    }
    if (data.containsKey('name_english')) {
      context.handle(
          _nameEnglishMeta,
          nameEnglish.isAcceptableOrUnknown(
              data['name_english']!, _nameEnglishMeta));
    } else if (isInserting) {
      context.missing(_nameEnglishMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    }
    if (data.containsKey('is_bought')) {
      context.handle(_isBoughtMeta,
          isBought.isAcceptableOrUnknown(data['is_bought']!, _isBoughtMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('added_at')) {
      context.handle(_addedAtMeta,
          addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta));
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ListItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ListItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      listId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}list_id'])!,
      templateId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}template_id']),
      nameBangla: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_bangla'])!,
      nameEnglish: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_english'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price']),
      isBought: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_bought'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      addedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}added_at'])!,
    );
  }

  @override
  $ListItemsTable createAlias(String alias) {
    return $ListItemsTable(attachedDatabase, alias);
  }
}

class ListItem extends DataClass implements Insertable<ListItem> {
  final int id;
  final int listId;
  final int? templateId;
  final String nameBangla;
  final String nameEnglish;
  final double quantity;
  final String unit;
  final double? price;
  final bool isBought;
  final int sortOrder;
  final DateTime addedAt;
  const ListItem(
      {required this.id,
      required this.listId,
      this.templateId,
      required this.nameBangla,
      required this.nameEnglish,
      required this.quantity,
      required this.unit,
      this.price,
      required this.isBought,
      required this.sortOrder,
      required this.addedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['list_id'] = Variable<int>(listId);
    if (!nullToAbsent || templateId != null) {
      map['template_id'] = Variable<int>(templateId);
    }
    map['name_bangla'] = Variable<String>(nameBangla);
    map['name_english'] = Variable<String>(nameEnglish);
    map['quantity'] = Variable<double>(quantity);
    map['unit'] = Variable<String>(unit);
    if (!nullToAbsent || price != null) {
      map['price'] = Variable<double>(price);
    }
    map['is_bought'] = Variable<bool>(isBought);
    map['sort_order'] = Variable<int>(sortOrder);
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  ListItemsCompanion toCompanion(bool nullToAbsent) {
    return ListItemsCompanion(
      id: Value(id),
      listId: Value(listId),
      templateId: templateId == null && nullToAbsent
          ? const Value.absent()
          : Value(templateId),
      nameBangla: Value(nameBangla),
      nameEnglish: Value(nameEnglish),
      quantity: Value(quantity),
      unit: Value(unit),
      price:
          price == null && nullToAbsent ? const Value.absent() : Value(price),
      isBought: Value(isBought),
      sortOrder: Value(sortOrder),
      addedAt: Value(addedAt),
    );
  }

  factory ListItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ListItem(
      id: serializer.fromJson<int>(json['id']),
      listId: serializer.fromJson<int>(json['listId']),
      templateId: serializer.fromJson<int?>(json['templateId']),
      nameBangla: serializer.fromJson<String>(json['nameBangla']),
      nameEnglish: serializer.fromJson<String>(json['nameEnglish']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unit: serializer.fromJson<String>(json['unit']),
      price: serializer.fromJson<double?>(json['price']),
      isBought: serializer.fromJson<bool>(json['isBought']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'listId': serializer.toJson<int>(listId),
      'templateId': serializer.toJson<int?>(templateId),
      'nameBangla': serializer.toJson<String>(nameBangla),
      'nameEnglish': serializer.toJson<String>(nameEnglish),
      'quantity': serializer.toJson<double>(quantity),
      'unit': serializer.toJson<String>(unit),
      'price': serializer.toJson<double?>(price),
      'isBought': serializer.toJson<bool>(isBought),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  ListItem copyWith(
          {int? id,
          int? listId,
          Value<int?> templateId = const Value.absent(),
          String? nameBangla,
          String? nameEnglish,
          double? quantity,
          String? unit,
          Value<double?> price = const Value.absent(),
          bool? isBought,
          int? sortOrder,
          DateTime? addedAt}) =>
      ListItem(
        id: id ?? this.id,
        listId: listId ?? this.listId,
        templateId: templateId.present ? templateId.value : this.templateId,
        nameBangla: nameBangla ?? this.nameBangla,
        nameEnglish: nameEnglish ?? this.nameEnglish,
        quantity: quantity ?? this.quantity,
        unit: unit ?? this.unit,
        price: price.present ? price.value : this.price,
        isBought: isBought ?? this.isBought,
        sortOrder: sortOrder ?? this.sortOrder,
        addedAt: addedAt ?? this.addedAt,
      );
  ListItem copyWithCompanion(ListItemsCompanion data) {
    return ListItem(
      id: data.id.present ? data.id.value : this.id,
      listId: data.listId.present ? data.listId.value : this.listId,
      templateId:
          data.templateId.present ? data.templateId.value : this.templateId,
      nameBangla:
          data.nameBangla.present ? data.nameBangla.value : this.nameBangla,
      nameEnglish:
          data.nameEnglish.present ? data.nameEnglish.value : this.nameEnglish,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      price: data.price.present ? data.price.value : this.price,
      isBought: data.isBought.present ? data.isBought.value : this.isBought,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ListItem(')
          ..write('id: $id, ')
          ..write('listId: $listId, ')
          ..write('templateId: $templateId, ')
          ..write('nameBangla: $nameBangla, ')
          ..write('nameEnglish: $nameEnglish, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('price: $price, ')
          ..write('isBought: $isBought, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, listId, templateId, nameBangla,
      nameEnglish, quantity, unit, price, isBought, sortOrder, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ListItem &&
          other.id == this.id &&
          other.listId == this.listId &&
          other.templateId == this.templateId &&
          other.nameBangla == this.nameBangla &&
          other.nameEnglish == this.nameEnglish &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.price == this.price &&
          other.isBought == this.isBought &&
          other.sortOrder == this.sortOrder &&
          other.addedAt == this.addedAt);
}

class ListItemsCompanion extends UpdateCompanion<ListItem> {
  final Value<int> id;
  final Value<int> listId;
  final Value<int?> templateId;
  final Value<String> nameBangla;
  final Value<String> nameEnglish;
  final Value<double> quantity;
  final Value<String> unit;
  final Value<double?> price;
  final Value<bool> isBought;
  final Value<int> sortOrder;
  final Value<DateTime> addedAt;
  const ListItemsCompanion({
    this.id = const Value.absent(),
    this.listId = const Value.absent(),
    this.templateId = const Value.absent(),
    this.nameBangla = const Value.absent(),
    this.nameEnglish = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.price = const Value.absent(),
    this.isBought = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.addedAt = const Value.absent(),
  });
  ListItemsCompanion.insert({
    this.id = const Value.absent(),
    required int listId,
    this.templateId = const Value.absent(),
    required String nameBangla,
    required String nameEnglish,
    this.quantity = const Value.absent(),
    required String unit,
    this.price = const Value.absent(),
    this.isBought = const Value.absent(),
    required int sortOrder,
    required DateTime addedAt,
  })  : listId = Value(listId),
        nameBangla = Value(nameBangla),
        nameEnglish = Value(nameEnglish),
        unit = Value(unit),
        sortOrder = Value(sortOrder),
        addedAt = Value(addedAt);
  static Insertable<ListItem> custom({
    Expression<int>? id,
    Expression<int>? listId,
    Expression<int>? templateId,
    Expression<String>? nameBangla,
    Expression<String>? nameEnglish,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<double>? price,
    Expression<bool>? isBought,
    Expression<int>? sortOrder,
    Expression<DateTime>? addedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (listId != null) 'list_id': listId,
      if (templateId != null) 'template_id': templateId,
      if (nameBangla != null) 'name_bangla': nameBangla,
      if (nameEnglish != null) 'name_english': nameEnglish,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (price != null) 'price': price,
      if (isBought != null) 'is_bought': isBought,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (addedAt != null) 'added_at': addedAt,
    });
  }

  ListItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? listId,
      Value<int?>? templateId,
      Value<String>? nameBangla,
      Value<String>? nameEnglish,
      Value<double>? quantity,
      Value<String>? unit,
      Value<double?>? price,
      Value<bool>? isBought,
      Value<int>? sortOrder,
      Value<DateTime>? addedAt}) {
    return ListItemsCompanion(
      id: id ?? this.id,
      listId: listId ?? this.listId,
      templateId: templateId ?? this.templateId,
      nameBangla: nameBangla ?? this.nameBangla,
      nameEnglish: nameEnglish ?? this.nameEnglish,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      price: price ?? this.price,
      isBought: isBought ?? this.isBought,
      sortOrder: sortOrder ?? this.sortOrder,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (listId.present) {
      map['list_id'] = Variable<int>(listId.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<int>(templateId.value);
    }
    if (nameBangla.present) {
      map['name_bangla'] = Variable<String>(nameBangla.value);
    }
    if (nameEnglish.present) {
      map['name_english'] = Variable<String>(nameEnglish.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (isBought.present) {
      map['is_bought'] = Variable<bool>(isBought.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ListItemsCompanion(')
          ..write('id: $id, ')
          ..write('listId: $listId, ')
          ..write('templateId: $templateId, ')
          ..write('nameBangla: $nameBangla, ')
          ..write('nameEnglish: $nameEnglish, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('price: $price, ')
          ..write('isBought: $isBought, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$JhuriDatabase extends GeneratedDatabase {
  _$JhuriDatabase(QueryExecutor e) : super(e);
  $JhuriDatabaseManager get managers => $JhuriDatabaseManager(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $ItemTemplatesTable itemTemplates = $ItemTemplatesTable(this);
  late final $ShoppingListsTable shoppingLists = $ShoppingListsTable(this);
  late final $ListItemsTable listItems = $ListItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [categories, itemTemplates, shoppingLists, listItems];
}

typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  required String nameBangla,
  required String nameEnglish,
  required String imageIdentifier,
  required String iconIdentifier,
  required int sortOrder,
  Value<bool> isCustom,
  Value<bool> isActive,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  Value<String> nameBangla,
  Value<String> nameEnglish,
  Value<String> imageIdentifier,
  Value<String> iconIdentifier,
  Value<int> sortOrder,
  Value<bool> isCustom,
  Value<bool> isActive,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$JhuriDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ItemTemplatesTable, List<ItemTemplate>>
      _itemTemplatesRefsTable(_$JhuriDatabase db) =>
          MultiTypedResultKey.fromTable(db.itemTemplates,
              aliasName: $_aliasNameGenerator(
                  db.categories.id, db.itemTemplates.categoryId));

  $$ItemTemplatesTableProcessedTableManager get itemTemplatesRefs {
    final manager = $$ItemTemplatesTableTableManager($_db, $_db.itemTemplates)
        .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemTemplatesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$JhuriDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameBangla => $composableBuilder(
      column: $table.nameBangla, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEnglish => $composableBuilder(
      column: $table.nameEnglish, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageIdentifier => $composableBuilder(
      column: $table.imageIdentifier,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get iconIdentifier => $composableBuilder(
      column: $table.iconIdentifier,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCustom => $composableBuilder(
      column: $table.isCustom, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  Expression<bool> itemTemplatesRefs(
      Expression<bool> Function($$ItemTemplatesTableFilterComposer f) f) {
    final $$ItemTemplatesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.itemTemplates,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemTemplatesTableFilterComposer(
              $db: $db,
              $table: $db.itemTemplates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$JhuriDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameBangla => $composableBuilder(
      column: $table.nameBangla, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEnglish => $composableBuilder(
      column: $table.nameEnglish, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageIdentifier => $composableBuilder(
      column: $table.imageIdentifier,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get iconIdentifier => $composableBuilder(
      column: $table.iconIdentifier,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCustom => $composableBuilder(
      column: $table.isCustom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$JhuriDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameBangla => $composableBuilder(
      column: $table.nameBangla, builder: (column) => column);

  GeneratedColumn<String> get nameEnglish => $composableBuilder(
      column: $table.nameEnglish, builder: (column) => column);

  GeneratedColumn<String> get imageIdentifier => $composableBuilder(
      column: $table.imageIdentifier, builder: (column) => column);

  GeneratedColumn<String> get iconIdentifier => $composableBuilder(
      column: $table.iconIdentifier, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> itemTemplatesRefs<T extends Object>(
      Expression<T> Function($$ItemTemplatesTableAnnotationComposer a) f) {
    final $$ItemTemplatesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.itemTemplates,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemTemplatesTableAnnotationComposer(
              $db: $db,
              $table: $db.itemTemplates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoriesTableTableManager extends RootTableManager<
    _$JhuriDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, $$CategoriesTableReferences),
    Category,
    PrefetchHooks Function({bool itemTemplatesRefs})> {
  $$CategoriesTableTableManager(_$JhuriDatabase db, $CategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nameBangla = const Value.absent(),
            Value<String> nameEnglish = const Value.absent(),
            Value<String> imageIdentifier = const Value.absent(),
            Value<String> iconIdentifier = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<bool> isCustom = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              CategoriesCompanion(
            id: id,
            nameBangla: nameBangla,
            nameEnglish: nameEnglish,
            imageIdentifier: imageIdentifier,
            iconIdentifier: iconIdentifier,
            sortOrder: sortOrder,
            isCustom: isCustom,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nameBangla,
            required String nameEnglish,
            required String imageIdentifier,
            required String iconIdentifier,
            required int sortOrder,
            Value<bool> isCustom = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              CategoriesCompanion.insert(
            id: id,
            nameBangla: nameBangla,
            nameEnglish: nameEnglish,
            imageIdentifier: imageIdentifier,
            iconIdentifier: iconIdentifier,
            sortOrder: sortOrder,
            isCustom: isCustom,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CategoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({itemTemplatesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (itemTemplatesRefs) db.itemTemplates
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (itemTemplatesRefs)
                    await $_getPrefetchedData<Category, $CategoriesTable,
                            ItemTemplate>(
                        currentTable: table,
                        referencedTable: $$CategoriesTableReferences
                            ._itemTemplatesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoriesTableReferences(db, table, p0)
                                .itemTemplatesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CategoriesTableProcessedTableManager = ProcessedTableManager<
    _$JhuriDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, $$CategoriesTableReferences),
    Category,
    PrefetchHooks Function({bool itemTemplatesRefs})>;
typedef $$ItemTemplatesTableCreateCompanionBuilder = ItemTemplatesCompanion
    Function({
  Value<int> id,
  required String nameBangla,
  required String nameEnglish,
  Value<String?> phoneticName,
  required int categoryId,
  required double defaultQuantity,
  required String defaultUnit,
  Value<String?> iconIdentifier,
  Value<String> emoji,
  Value<bool> isCustom,
  Value<bool> isActive,
  Value<int> usageCount,
  Value<int> sortOrder,
  required DateTime lastUsedAt,
  Value<DateTime?> createdAt,
});
typedef $$ItemTemplatesTableUpdateCompanionBuilder = ItemTemplatesCompanion
    Function({
  Value<int> id,
  Value<String> nameBangla,
  Value<String> nameEnglish,
  Value<String?> phoneticName,
  Value<int> categoryId,
  Value<double> defaultQuantity,
  Value<String> defaultUnit,
  Value<String?> iconIdentifier,
  Value<String> emoji,
  Value<bool> isCustom,
  Value<bool> isActive,
  Value<int> usageCount,
  Value<int> sortOrder,
  Value<DateTime> lastUsedAt,
  Value<DateTime?> createdAt,
});

final class $$ItemTemplatesTableReferences
    extends BaseReferences<_$JhuriDatabase, $ItemTemplatesTable, ItemTemplate> {
  $$ItemTemplatesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$JhuriDatabase db) =>
      db.categories.createAlias(
          $_aliasNameGenerator(db.itemTemplates.categoryId, db.categories.id));

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager($_db, $_db.categories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$ListItemsTable, List<ListItem>>
      _listItemsRefsTable(_$JhuriDatabase db) =>
          MultiTypedResultKey.fromTable(db.listItems,
              aliasName: $_aliasNameGenerator(
                  db.itemTemplates.id, db.listItems.templateId));

  $$ListItemsTableProcessedTableManager get listItemsRefs {
    final manager = $$ListItemsTableTableManager($_db, $_db.listItems)
        .filter((f) => f.templateId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_listItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ItemTemplatesTableFilterComposer
    extends Composer<_$JhuriDatabase, $ItemTemplatesTable> {
  $$ItemTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameBangla => $composableBuilder(
      column: $table.nameBangla, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEnglish => $composableBuilder(
      column: $table.nameEnglish, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phoneticName => $composableBuilder(
      column: $table.phoneticName, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get defaultQuantity => $composableBuilder(
      column: $table.defaultQuantity,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get defaultUnit => $composableBuilder(
      column: $table.defaultUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get iconIdentifier => $composableBuilder(
      column: $table.iconIdentifier,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get emoji => $composableBuilder(
      column: $table.emoji, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCustom => $composableBuilder(
      column: $table.isCustom, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get usageCount => $composableBuilder(
      column: $table.usageCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastUsedAt => $composableBuilder(
      column: $table.lastUsedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableFilterComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> listItemsRefs(
      Expression<bool> Function($$ListItemsTableFilterComposer f) f) {
    final $$ListItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.listItems,
        getReferencedColumn: (t) => t.templateId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ListItemsTableFilterComposer(
              $db: $db,
              $table: $db.listItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ItemTemplatesTableOrderingComposer
    extends Composer<_$JhuriDatabase, $ItemTemplatesTable> {
  $$ItemTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameBangla => $composableBuilder(
      column: $table.nameBangla, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEnglish => $composableBuilder(
      column: $table.nameEnglish, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phoneticName => $composableBuilder(
      column: $table.phoneticName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get defaultQuantity => $composableBuilder(
      column: $table.defaultQuantity,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get defaultUnit => $composableBuilder(
      column: $table.defaultUnit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get iconIdentifier => $composableBuilder(
      column: $table.iconIdentifier,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get emoji => $composableBuilder(
      column: $table.emoji, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCustom => $composableBuilder(
      column: $table.isCustom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get usageCount => $composableBuilder(
      column: $table.usageCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastUsedAt => $composableBuilder(
      column: $table.lastUsedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableOrderingComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ItemTemplatesTableAnnotationComposer
    extends Composer<_$JhuriDatabase, $ItemTemplatesTable> {
  $$ItemTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameBangla => $composableBuilder(
      column: $table.nameBangla, builder: (column) => column);

  GeneratedColumn<String> get nameEnglish => $composableBuilder(
      column: $table.nameEnglish, builder: (column) => column);

  GeneratedColumn<String> get phoneticName => $composableBuilder(
      column: $table.phoneticName, builder: (column) => column);

  GeneratedColumn<double> get defaultQuantity => $composableBuilder(
      column: $table.defaultQuantity, builder: (column) => column);

  GeneratedColumn<String> get defaultUnit => $composableBuilder(
      column: $table.defaultUnit, builder: (column) => column);

  GeneratedColumn<String> get iconIdentifier => $composableBuilder(
      column: $table.iconIdentifier, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get usageCount => $composableBuilder(
      column: $table.usageCount, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUsedAt => $composableBuilder(
      column: $table.lastUsedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> listItemsRefs<T extends Object>(
      Expression<T> Function($$ListItemsTableAnnotationComposer a) f) {
    final $$ListItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.listItems,
        getReferencedColumn: (t) => t.templateId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ListItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.listItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ItemTemplatesTableTableManager extends RootTableManager<
    _$JhuriDatabase,
    $ItemTemplatesTable,
    ItemTemplate,
    $$ItemTemplatesTableFilterComposer,
    $$ItemTemplatesTableOrderingComposer,
    $$ItemTemplatesTableAnnotationComposer,
    $$ItemTemplatesTableCreateCompanionBuilder,
    $$ItemTemplatesTableUpdateCompanionBuilder,
    (ItemTemplate, $$ItemTemplatesTableReferences),
    ItemTemplate,
    PrefetchHooks Function({bool categoryId, bool listItemsRefs})> {
  $$ItemTemplatesTableTableManager(
      _$JhuriDatabase db, $ItemTemplatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemTemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nameBangla = const Value.absent(),
            Value<String> nameEnglish = const Value.absent(),
            Value<String?> phoneticName = const Value.absent(),
            Value<int> categoryId = const Value.absent(),
            Value<double> defaultQuantity = const Value.absent(),
            Value<String> defaultUnit = const Value.absent(),
            Value<String?> iconIdentifier = const Value.absent(),
            Value<String> emoji = const Value.absent(),
            Value<bool> isCustom = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> usageCount = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<DateTime> lastUsedAt = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              ItemTemplatesCompanion(
            id: id,
            nameBangla: nameBangla,
            nameEnglish: nameEnglish,
            phoneticName: phoneticName,
            categoryId: categoryId,
            defaultQuantity: defaultQuantity,
            defaultUnit: defaultUnit,
            iconIdentifier: iconIdentifier,
            emoji: emoji,
            isCustom: isCustom,
            isActive: isActive,
            usageCount: usageCount,
            sortOrder: sortOrder,
            lastUsedAt: lastUsedAt,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nameBangla,
            required String nameEnglish,
            Value<String?> phoneticName = const Value.absent(),
            required int categoryId,
            required double defaultQuantity,
            required String defaultUnit,
            Value<String?> iconIdentifier = const Value.absent(),
            Value<String> emoji = const Value.absent(),
            Value<bool> isCustom = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> usageCount = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            required DateTime lastUsedAt,
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              ItemTemplatesCompanion.insert(
            id: id,
            nameBangla: nameBangla,
            nameEnglish: nameEnglish,
            phoneticName: phoneticName,
            categoryId: categoryId,
            defaultQuantity: defaultQuantity,
            defaultUnit: defaultUnit,
            iconIdentifier: iconIdentifier,
            emoji: emoji,
            isCustom: isCustom,
            isActive: isActive,
            usageCount: usageCount,
            sortOrder: sortOrder,
            lastUsedAt: lastUsedAt,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ItemTemplatesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({categoryId = false, listItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (listItemsRefs) db.listItems],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $$ItemTemplatesTableReferences._categoryIdTable(db),
                    referencedColumn:
                        $$ItemTemplatesTableReferences._categoryIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (listItemsRefs)
                    await $_getPrefetchedData<ItemTemplate, $ItemTemplatesTable,
                            ListItem>(
                        currentTable: table,
                        referencedTable: $$ItemTemplatesTableReferences
                            ._listItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ItemTemplatesTableReferences(db, table, p0)
                                .listItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.templateId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ItemTemplatesTableProcessedTableManager = ProcessedTableManager<
    _$JhuriDatabase,
    $ItemTemplatesTable,
    ItemTemplate,
    $$ItemTemplatesTableFilterComposer,
    $$ItemTemplatesTableOrderingComposer,
    $$ItemTemplatesTableAnnotationComposer,
    $$ItemTemplatesTableCreateCompanionBuilder,
    $$ItemTemplatesTableUpdateCompanionBuilder,
    (ItemTemplate, $$ItemTemplatesTableReferences),
    ItemTemplate,
    PrefetchHooks Function({bool categoryId, bool listItemsRefs})>;
typedef $$ShoppingListsTableCreateCompanionBuilder = ShoppingListsCompanion
    Function({
  Value<int> id,
  Value<String> title,
  required DateTime buyDate,
  Value<DateTime?> reminderTime,
  Value<bool> isReminderOn,
  Value<bool> isCompleted,
  Value<bool> isArchived,
  required DateTime createdAt,
  Value<DateTime?> completedAt,
  Value<int?> sourceListId,
});
typedef $$ShoppingListsTableUpdateCompanionBuilder = ShoppingListsCompanion
    Function({
  Value<int> id,
  Value<String> title,
  Value<DateTime> buyDate,
  Value<DateTime?> reminderTime,
  Value<bool> isReminderOn,
  Value<bool> isCompleted,
  Value<bool> isArchived,
  Value<DateTime> createdAt,
  Value<DateTime?> completedAt,
  Value<int?> sourceListId,
});

final class $$ShoppingListsTableReferences
    extends BaseReferences<_$JhuriDatabase, $ShoppingListsTable, ShoppingList> {
  $$ShoppingListsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ListItemsTable, List<ListItem>>
      _listItemsRefsTable(_$JhuriDatabase db) => MultiTypedResultKey.fromTable(
          db.listItems,
          aliasName:
              $_aliasNameGenerator(db.shoppingLists.id, db.listItems.listId));

  $$ListItemsTableProcessedTableManager get listItemsRefs {
    final manager = $$ListItemsTableTableManager($_db, $_db.listItems)
        .filter((f) => f.listId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_listItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ShoppingListsTableFilterComposer
    extends Composer<_$JhuriDatabase, $ShoppingListsTable> {
  $$ShoppingListsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get buyDate => $composableBuilder(
      column: $table.buyDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get reminderTime => $composableBuilder(
      column: $table.reminderTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isReminderOn => $composableBuilder(
      column: $table.isReminderOn, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sourceListId => $composableBuilder(
      column: $table.sourceListId, builder: (column) => ColumnFilters(column));

  Expression<bool> listItemsRefs(
      Expression<bool> Function($$ListItemsTableFilterComposer f) f) {
    final $$ListItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.listItems,
        getReferencedColumn: (t) => t.listId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ListItemsTableFilterComposer(
              $db: $db,
              $table: $db.listItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ShoppingListsTableOrderingComposer
    extends Composer<_$JhuriDatabase, $ShoppingListsTable> {
  $$ShoppingListsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get buyDate => $composableBuilder(
      column: $table.buyDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get reminderTime => $composableBuilder(
      column: $table.reminderTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isReminderOn => $composableBuilder(
      column: $table.isReminderOn,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sourceListId => $composableBuilder(
      column: $table.sourceListId,
      builder: (column) => ColumnOrderings(column));
}

class $$ShoppingListsTableAnnotationComposer
    extends Composer<_$JhuriDatabase, $ShoppingListsTable> {
  $$ShoppingListsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get buyDate =>
      $composableBuilder(column: $table.buyDate, builder: (column) => column);

  GeneratedColumn<DateTime> get reminderTime => $composableBuilder(
      column: $table.reminderTime, builder: (column) => column);

  GeneratedColumn<bool> get isReminderOn => $composableBuilder(
      column: $table.isReminderOn, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<int> get sourceListId => $composableBuilder(
      column: $table.sourceListId, builder: (column) => column);

  Expression<T> listItemsRefs<T extends Object>(
      Expression<T> Function($$ListItemsTableAnnotationComposer a) f) {
    final $$ListItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.listItems,
        getReferencedColumn: (t) => t.listId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ListItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.listItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ShoppingListsTableTableManager extends RootTableManager<
    _$JhuriDatabase,
    $ShoppingListsTable,
    ShoppingList,
    $$ShoppingListsTableFilterComposer,
    $$ShoppingListsTableOrderingComposer,
    $$ShoppingListsTableAnnotationComposer,
    $$ShoppingListsTableCreateCompanionBuilder,
    $$ShoppingListsTableUpdateCompanionBuilder,
    (ShoppingList, $$ShoppingListsTableReferences),
    ShoppingList,
    PrefetchHooks Function({bool listItemsRefs})> {
  $$ShoppingListsTableTableManager(
      _$JhuriDatabase db, $ShoppingListsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShoppingListsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShoppingListsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShoppingListsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<DateTime> buyDate = const Value.absent(),
            Value<DateTime?> reminderTime = const Value.absent(),
            Value<bool> isReminderOn = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<int?> sourceListId = const Value.absent(),
          }) =>
              ShoppingListsCompanion(
            id: id,
            title: title,
            buyDate: buyDate,
            reminderTime: reminderTime,
            isReminderOn: isReminderOn,
            isCompleted: isCompleted,
            isArchived: isArchived,
            createdAt: createdAt,
            completedAt: completedAt,
            sourceListId: sourceListId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            required DateTime buyDate,
            Value<DateTime?> reminderTime = const Value.absent(),
            Value<bool> isReminderOn = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            required DateTime createdAt,
            Value<DateTime?> completedAt = const Value.absent(),
            Value<int?> sourceListId = const Value.absent(),
          }) =>
              ShoppingListsCompanion.insert(
            id: id,
            title: title,
            buyDate: buyDate,
            reminderTime: reminderTime,
            isReminderOn: isReminderOn,
            isCompleted: isCompleted,
            isArchived: isArchived,
            createdAt: createdAt,
            completedAt: completedAt,
            sourceListId: sourceListId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ShoppingListsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({listItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (listItemsRefs) db.listItems],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (listItemsRefs)
                    await $_getPrefetchedData<ShoppingList, $ShoppingListsTable,
                            ListItem>(
                        currentTable: table,
                        referencedTable: $$ShoppingListsTableReferences
                            ._listItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ShoppingListsTableReferences(db, table, p0)
                                .listItemsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.listId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ShoppingListsTableProcessedTableManager = ProcessedTableManager<
    _$JhuriDatabase,
    $ShoppingListsTable,
    ShoppingList,
    $$ShoppingListsTableFilterComposer,
    $$ShoppingListsTableOrderingComposer,
    $$ShoppingListsTableAnnotationComposer,
    $$ShoppingListsTableCreateCompanionBuilder,
    $$ShoppingListsTableUpdateCompanionBuilder,
    (ShoppingList, $$ShoppingListsTableReferences),
    ShoppingList,
    PrefetchHooks Function({bool listItemsRefs})>;
typedef $$ListItemsTableCreateCompanionBuilder = ListItemsCompanion Function({
  Value<int> id,
  required int listId,
  Value<int?> templateId,
  required String nameBangla,
  required String nameEnglish,
  Value<double> quantity,
  required String unit,
  Value<double?> price,
  Value<bool> isBought,
  required int sortOrder,
  required DateTime addedAt,
});
typedef $$ListItemsTableUpdateCompanionBuilder = ListItemsCompanion Function({
  Value<int> id,
  Value<int> listId,
  Value<int?> templateId,
  Value<String> nameBangla,
  Value<String> nameEnglish,
  Value<double> quantity,
  Value<String> unit,
  Value<double?> price,
  Value<bool> isBought,
  Value<int> sortOrder,
  Value<DateTime> addedAt,
});

final class $$ListItemsTableReferences
    extends BaseReferences<_$JhuriDatabase, $ListItemsTable, ListItem> {
  $$ListItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ShoppingListsTable _listIdTable(_$JhuriDatabase db) =>
      db.shoppingLists.createAlias(
          $_aliasNameGenerator(db.listItems.listId, db.shoppingLists.id));

  $$ShoppingListsTableProcessedTableManager get listId {
    final $_column = $_itemColumn<int>('list_id')!;

    final manager = $$ShoppingListsTableTableManager($_db, $_db.shoppingLists)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_listIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ItemTemplatesTable _templateIdTable(_$JhuriDatabase db) =>
      db.itemTemplates.createAlias(
          $_aliasNameGenerator(db.listItems.templateId, db.itemTemplates.id));

  $$ItemTemplatesTableProcessedTableManager? get templateId {
    final $_column = $_itemColumn<int>('template_id');
    if ($_column == null) return null;
    final manager = $$ItemTemplatesTableTableManager($_db, $_db.itemTemplates)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_templateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ListItemsTableFilterComposer
    extends Composer<_$JhuriDatabase, $ListItemsTable> {
  $$ListItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameBangla => $composableBuilder(
      column: $table.nameBangla, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEnglish => $composableBuilder(
      column: $table.nameEnglish, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isBought => $composableBuilder(
      column: $table.isBought, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
      column: $table.addedAt, builder: (column) => ColumnFilters(column));

  $$ShoppingListsTableFilterComposer get listId {
    final $$ShoppingListsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.listId,
        referencedTable: $db.shoppingLists,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShoppingListsTableFilterComposer(
              $db: $db,
              $table: $db.shoppingLists,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ItemTemplatesTableFilterComposer get templateId {
    final $$ItemTemplatesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.templateId,
        referencedTable: $db.itemTemplates,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemTemplatesTableFilterComposer(
              $db: $db,
              $table: $db.itemTemplates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ListItemsTableOrderingComposer
    extends Composer<_$JhuriDatabase, $ListItemsTable> {
  $$ListItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameBangla => $composableBuilder(
      column: $table.nameBangla, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEnglish => $composableBuilder(
      column: $table.nameEnglish, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isBought => $composableBuilder(
      column: $table.isBought, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
      column: $table.addedAt, builder: (column) => ColumnOrderings(column));

  $$ShoppingListsTableOrderingComposer get listId {
    final $$ShoppingListsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.listId,
        referencedTable: $db.shoppingLists,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShoppingListsTableOrderingComposer(
              $db: $db,
              $table: $db.shoppingLists,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ItemTemplatesTableOrderingComposer get templateId {
    final $$ItemTemplatesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.templateId,
        referencedTable: $db.itemTemplates,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemTemplatesTableOrderingComposer(
              $db: $db,
              $table: $db.itemTemplates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ListItemsTableAnnotationComposer
    extends Composer<_$JhuriDatabase, $ListItemsTable> {
  $$ListItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameBangla => $composableBuilder(
      column: $table.nameBangla, builder: (column) => column);

  GeneratedColumn<String> get nameEnglish => $composableBuilder(
      column: $table.nameEnglish, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<bool> get isBought =>
      $composableBuilder(column: $table.isBought, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  $$ShoppingListsTableAnnotationComposer get listId {
    final $$ShoppingListsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.listId,
        referencedTable: $db.shoppingLists,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShoppingListsTableAnnotationComposer(
              $db: $db,
              $table: $db.shoppingLists,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ItemTemplatesTableAnnotationComposer get templateId {
    final $$ItemTemplatesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.templateId,
        referencedTable: $db.itemTemplates,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemTemplatesTableAnnotationComposer(
              $db: $db,
              $table: $db.itemTemplates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ListItemsTableTableManager extends RootTableManager<
    _$JhuriDatabase,
    $ListItemsTable,
    ListItem,
    $$ListItemsTableFilterComposer,
    $$ListItemsTableOrderingComposer,
    $$ListItemsTableAnnotationComposer,
    $$ListItemsTableCreateCompanionBuilder,
    $$ListItemsTableUpdateCompanionBuilder,
    (ListItem, $$ListItemsTableReferences),
    ListItem,
    PrefetchHooks Function({bool listId, bool templateId})> {
  $$ListItemsTableTableManager(_$JhuriDatabase db, $ListItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ListItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ListItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ListItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> listId = const Value.absent(),
            Value<int?> templateId = const Value.absent(),
            Value<String> nameBangla = const Value.absent(),
            Value<String> nameEnglish = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<double?> price = const Value.absent(),
            Value<bool> isBought = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<DateTime> addedAt = const Value.absent(),
          }) =>
              ListItemsCompanion(
            id: id,
            listId: listId,
            templateId: templateId,
            nameBangla: nameBangla,
            nameEnglish: nameEnglish,
            quantity: quantity,
            unit: unit,
            price: price,
            isBought: isBought,
            sortOrder: sortOrder,
            addedAt: addedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int listId,
            Value<int?> templateId = const Value.absent(),
            required String nameBangla,
            required String nameEnglish,
            Value<double> quantity = const Value.absent(),
            required String unit,
            Value<double?> price = const Value.absent(),
            Value<bool> isBought = const Value.absent(),
            required int sortOrder,
            required DateTime addedAt,
          }) =>
              ListItemsCompanion.insert(
            id: id,
            listId: listId,
            templateId: templateId,
            nameBangla: nameBangla,
            nameEnglish: nameEnglish,
            quantity: quantity,
            unit: unit,
            price: price,
            isBought: isBought,
            sortOrder: sortOrder,
            addedAt: addedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ListItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({listId = false, templateId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (listId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.listId,
                    referencedTable:
                        $$ListItemsTableReferences._listIdTable(db),
                    referencedColumn:
                        $$ListItemsTableReferences._listIdTable(db).id,
                  ) as T;
                }
                if (templateId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.templateId,
                    referencedTable:
                        $$ListItemsTableReferences._templateIdTable(db),
                    referencedColumn:
                        $$ListItemsTableReferences._templateIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ListItemsTableProcessedTableManager = ProcessedTableManager<
    _$JhuriDatabase,
    $ListItemsTable,
    ListItem,
    $$ListItemsTableFilterComposer,
    $$ListItemsTableOrderingComposer,
    $$ListItemsTableAnnotationComposer,
    $$ListItemsTableCreateCompanionBuilder,
    $$ListItemsTableUpdateCompanionBuilder,
    (ListItem, $$ListItemsTableReferences),
    ListItem,
    PrefetchHooks Function({bool listId, bool templateId})>;

class $JhuriDatabaseManager {
  final _$JhuriDatabase _db;
  $JhuriDatabaseManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$ItemTemplatesTableTableManager get itemTemplates =>
      $$ItemTemplatesTableTableManager(_db, _db.itemTemplates);
  $$ShoppingListsTableTableManager get shoppingLists =>
      $$ShoppingListsTableTableManager(_db, _db.shoppingLists);
  $$ListItemsTableTableManager get listItems =>
      $$ListItemsTableTableManager(_db, _db.listItems);
}
