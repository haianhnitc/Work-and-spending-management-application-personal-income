// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BudgetModel _$BudgetModelFromJson(Map<String, dynamic> json) {
  return _BudgetModel.fromJson(json);
}

/// @nodoc
mixin _$BudgetModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  double get spentAmount => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  String get period => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  Map<String, double> get categoryLimits => throw _privateConstructorUsedError;
  List<BudgetAlertModel> get alerts => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BudgetModelCopyWith<BudgetModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetModelCopyWith<$Res> {
  factory $BudgetModelCopyWith(
          BudgetModel value, $Res Function(BudgetModel) then) =
      _$BudgetModelCopyWithImpl<$Res, BudgetModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String name,
      String category,
      double amount,
      double spentAmount,
      DateTime startDate,
      DateTime endDate,
      String period,
      List<String> tags,
      bool isActive,
      DateTime createdAt,
      DateTime updatedAt,
      Map<String, double> categoryLimits,
      List<BudgetAlertModel> alerts});
}

/// @nodoc
class _$BudgetModelCopyWithImpl<$Res, $Val extends BudgetModel>
    implements $BudgetModelCopyWith<$Res> {
  _$BudgetModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? category = null,
    Object? amount = null,
    Object? spentAmount = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? period = null,
    Object? tags = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? categoryLimits = null,
    Object? alerts = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      spentAmount: null == spentAmount
          ? _value.spentAmount
          : spentAmount // ignore: cast_nullable_to_non_nullable
              as double,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      categoryLimits: null == categoryLimits
          ? _value.categoryLimits
          : categoryLimits // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      alerts: null == alerts
          ? _value.alerts
          : alerts // ignore: cast_nullable_to_non_nullable
              as List<BudgetAlertModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BudgetModelImplCopyWith<$Res>
    implements $BudgetModelCopyWith<$Res> {
  factory _$$BudgetModelImplCopyWith(
          _$BudgetModelImpl value, $Res Function(_$BudgetModelImpl) then) =
      __$$BudgetModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String name,
      String category,
      double amount,
      double spentAmount,
      DateTime startDate,
      DateTime endDate,
      String period,
      List<String> tags,
      bool isActive,
      DateTime createdAt,
      DateTime updatedAt,
      Map<String, double> categoryLimits,
      List<BudgetAlertModel> alerts});
}

/// @nodoc
class __$$BudgetModelImplCopyWithImpl<$Res>
    extends _$BudgetModelCopyWithImpl<$Res, _$BudgetModelImpl>
    implements _$$BudgetModelImplCopyWith<$Res> {
  __$$BudgetModelImplCopyWithImpl(
      _$BudgetModelImpl _value, $Res Function(_$BudgetModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? category = null,
    Object? amount = null,
    Object? spentAmount = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? period = null,
    Object? tags = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? categoryLimits = null,
    Object? alerts = null,
  }) {
    return _then(_$BudgetModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      spentAmount: null == spentAmount
          ? _value.spentAmount
          : spentAmount // ignore: cast_nullable_to_non_nullable
              as double,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      categoryLimits: null == categoryLimits
          ? _value._categoryLimits
          : categoryLimits // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      alerts: null == alerts
          ? _value._alerts
          : alerts // ignore: cast_nullable_to_non_nullable
              as List<BudgetAlertModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BudgetModelImpl implements _BudgetModel {
  const _$BudgetModelImpl(
      {required this.id,
      required this.userId,
      required this.name,
      required this.category,
      required this.amount,
      this.spentAmount = 0.0,
      required this.startDate,
      required this.endDate,
      this.period = 'monthly',
      final List<String> tags = const [],
      this.isActive = true,
      required this.createdAt,
      required this.updatedAt,
      final Map<String, double> categoryLimits = const {},
      final List<BudgetAlertModel> alerts = const []})
      : _tags = tags,
        _categoryLimits = categoryLimits,
        _alerts = alerts;

  factory _$BudgetModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BudgetModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String name;
  @override
  final String category;
  @override
  final double amount;
  @override
  @JsonKey()
  final double spentAmount;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  @JsonKey()
  final String period;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final Map<String, double> _categoryLimits;
  @override
  @JsonKey()
  Map<String, double> get categoryLimits {
    if (_categoryLimits is EqualUnmodifiableMapView) return _categoryLimits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_categoryLimits);
  }

  final List<BudgetAlertModel> _alerts;
  @override
  @JsonKey()
  List<BudgetAlertModel> get alerts {
    if (_alerts is EqualUnmodifiableListView) return _alerts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_alerts);
  }

  @override
  String toString() {
    return 'BudgetModel(id: $id, userId: $userId, name: $name, category: $category, amount: $amount, spentAmount: $spentAmount, startDate: $startDate, endDate: $endDate, period: $period, tags: $tags, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, categoryLimits: $categoryLimits, alerts: $alerts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BudgetModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.spentAmount, spentAmount) ||
                other.spentAmount == spentAmount) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.period, period) || other.period == period) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._categoryLimits, _categoryLimits) &&
            const DeepCollectionEquality().equals(other._alerts, _alerts));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      name,
      category,
      amount,
      spentAmount,
      startDate,
      endDate,
      period,
      const DeepCollectionEquality().hash(_tags),
      isActive,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_categoryLimits),
      const DeepCollectionEquality().hash(_alerts));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BudgetModelImplCopyWith<_$BudgetModelImpl> get copyWith =>
      __$$BudgetModelImplCopyWithImpl<_$BudgetModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BudgetModelImplToJson(
      this,
    );
  }
}

abstract class _BudgetModel implements BudgetModel {
  const factory _BudgetModel(
      {required final String id,
      required final String userId,
      required final String name,
      required final String category,
      required final double amount,
      final double spentAmount,
      required final DateTime startDate,
      required final DateTime endDate,
      final String period,
      final List<String> tags,
      final bool isActive,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final Map<String, double> categoryLimits,
      final List<BudgetAlertModel> alerts}) = _$BudgetModelImpl;

  factory _BudgetModel.fromJson(Map<String, dynamic> json) =
      _$BudgetModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get name;
  @override
  String get category;
  @override
  double get amount;
  @override
  double get spentAmount;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  String get period;
  @override
  List<String> get tags;
  @override
  bool get isActive;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  Map<String, double> get categoryLimits;
  @override
  List<BudgetAlertModel> get alerts;
  @override
  @JsonKey(ignore: true)
  _$$BudgetModelImplCopyWith<_$BudgetModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BudgetAlertModel _$BudgetAlertModelFromJson(Map<String, dynamic> json) {
  return _BudgetAlertModel.fromJson(json);
}

/// @nodoc
mixin _$BudgetAlertModel {
  String get id => throw _privateConstructorUsedError;
  String get budgetId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BudgetAlertModelCopyWith<BudgetAlertModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetAlertModelCopyWith<$Res> {
  factory $BudgetAlertModelCopyWith(
          BudgetAlertModel value, $Res Function(BudgetAlertModel) then) =
      _$BudgetAlertModelCopyWithImpl<$Res, BudgetAlertModel>;
  @useResult
  $Res call(
      {String id,
      String budgetId,
      String type,
      String message,
      DateTime createdAt,
      bool isRead});
}

/// @nodoc
class _$BudgetAlertModelCopyWithImpl<$Res, $Val extends BudgetAlertModel>
    implements $BudgetAlertModelCopyWith<$Res> {
  _$BudgetAlertModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? type = null,
    Object? message = null,
    Object? createdAt = null,
    Object? isRead = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      budgetId: null == budgetId
          ? _value.budgetId
          : budgetId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BudgetAlertModelImplCopyWith<$Res>
    implements $BudgetAlertModelCopyWith<$Res> {
  factory _$$BudgetAlertModelImplCopyWith(_$BudgetAlertModelImpl value,
          $Res Function(_$BudgetAlertModelImpl) then) =
      __$$BudgetAlertModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String budgetId,
      String type,
      String message,
      DateTime createdAt,
      bool isRead});
}

/// @nodoc
class __$$BudgetAlertModelImplCopyWithImpl<$Res>
    extends _$BudgetAlertModelCopyWithImpl<$Res, _$BudgetAlertModelImpl>
    implements _$$BudgetAlertModelImplCopyWith<$Res> {
  __$$BudgetAlertModelImplCopyWithImpl(_$BudgetAlertModelImpl _value,
      $Res Function(_$BudgetAlertModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? type = null,
    Object? message = null,
    Object? createdAt = null,
    Object? isRead = null,
  }) {
    return _then(_$BudgetAlertModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      budgetId: null == budgetId
          ? _value.budgetId
          : budgetId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BudgetAlertModelImpl implements _BudgetAlertModel {
  const _$BudgetAlertModelImpl(
      {required this.id,
      required this.budgetId,
      required this.type,
      required this.message,
      required this.createdAt,
      this.isRead = false});

  factory _$BudgetAlertModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BudgetAlertModelImplFromJson(json);

  @override
  final String id;
  @override
  final String budgetId;
  @override
  final String type;
  @override
  final String message;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final bool isRead;

  @override
  String toString() {
    return 'BudgetAlertModel(id: $id, budgetId: $budgetId, type: $type, message: $message, createdAt: $createdAt, isRead: $isRead)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BudgetAlertModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isRead, isRead) || other.isRead == isRead));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, budgetId, type, message, createdAt, isRead);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BudgetAlertModelImplCopyWith<_$BudgetAlertModelImpl> get copyWith =>
      __$$BudgetAlertModelImplCopyWithImpl<_$BudgetAlertModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BudgetAlertModelImplToJson(
      this,
    );
  }
}

abstract class _BudgetAlertModel implements BudgetAlertModel {
  const factory _BudgetAlertModel(
      {required final String id,
      required final String budgetId,
      required final String type,
      required final String message,
      required final DateTime createdAt,
      final bool isRead}) = _$BudgetAlertModelImpl;

  factory _BudgetAlertModel.fromJson(Map<String, dynamic> json) =
      _$BudgetAlertModelImpl.fromJson;

  @override
  String get id;
  @override
  String get budgetId;
  @override
  String get type;
  @override
  String get message;
  @override
  DateTime get createdAt;
  @override
  bool get isRead;
  @override
  @JsonKey(ignore: true)
  _$$BudgetAlertModelImplCopyWith<_$BudgetAlertModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BudgetReportModel _$BudgetReportModelFromJson(Map<String, dynamic> json) {
  return _BudgetReportModel.fromJson(json);
}

/// @nodoc
mixin _$BudgetReportModel {
  String get budgetId => throw _privateConstructorUsedError;
  String get budgetName => throw _privateConstructorUsedError;
  double get totalBudget => throw _privateConstructorUsedError;
  double get totalSpent => throw _privateConstructorUsedError;
  double get remainingAmount => throw _privateConstructorUsedError;
  double get usagePercentage => throw _privateConstructorUsedError;
  List<CategorySpendingModel> get categorySpending =>
      throw _privateConstructorUsedError;
  List<BudgetAlertModel> get alerts => throw _privateConstructorUsedError;
  DateTime get reportDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BudgetReportModelCopyWith<BudgetReportModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetReportModelCopyWith<$Res> {
  factory $BudgetReportModelCopyWith(
          BudgetReportModel value, $Res Function(BudgetReportModel) then) =
      _$BudgetReportModelCopyWithImpl<$Res, BudgetReportModel>;
  @useResult
  $Res call(
      {String budgetId,
      String budgetName,
      double totalBudget,
      double totalSpent,
      double remainingAmount,
      double usagePercentage,
      List<CategorySpendingModel> categorySpending,
      List<BudgetAlertModel> alerts,
      DateTime reportDate});
}

/// @nodoc
class _$BudgetReportModelCopyWithImpl<$Res, $Val extends BudgetReportModel>
    implements $BudgetReportModelCopyWith<$Res> {
  _$BudgetReportModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? budgetId = null,
    Object? budgetName = null,
    Object? totalBudget = null,
    Object? totalSpent = null,
    Object? remainingAmount = null,
    Object? usagePercentage = null,
    Object? categorySpending = null,
    Object? alerts = null,
    Object? reportDate = null,
  }) {
    return _then(_value.copyWith(
      budgetId: null == budgetId
          ? _value.budgetId
          : budgetId // ignore: cast_nullable_to_non_nullable
              as String,
      budgetName: null == budgetName
          ? _value.budgetName
          : budgetName // ignore: cast_nullable_to_non_nullable
              as String,
      totalBudget: null == totalBudget
          ? _value.totalBudget
          : totalBudget // ignore: cast_nullable_to_non_nullable
              as double,
      totalSpent: null == totalSpent
          ? _value.totalSpent
          : totalSpent // ignore: cast_nullable_to_non_nullable
              as double,
      remainingAmount: null == remainingAmount
          ? _value.remainingAmount
          : remainingAmount // ignore: cast_nullable_to_non_nullable
              as double,
      usagePercentage: null == usagePercentage
          ? _value.usagePercentage
          : usagePercentage // ignore: cast_nullable_to_non_nullable
              as double,
      categorySpending: null == categorySpending
          ? _value.categorySpending
          : categorySpending // ignore: cast_nullable_to_non_nullable
              as List<CategorySpendingModel>,
      alerts: null == alerts
          ? _value.alerts
          : alerts // ignore: cast_nullable_to_non_nullable
              as List<BudgetAlertModel>,
      reportDate: null == reportDate
          ? _value.reportDate
          : reportDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BudgetReportModelImplCopyWith<$Res>
    implements $BudgetReportModelCopyWith<$Res> {
  factory _$$BudgetReportModelImplCopyWith(_$BudgetReportModelImpl value,
          $Res Function(_$BudgetReportModelImpl) then) =
      __$$BudgetReportModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String budgetId,
      String budgetName,
      double totalBudget,
      double totalSpent,
      double remainingAmount,
      double usagePercentage,
      List<CategorySpendingModel> categorySpending,
      List<BudgetAlertModel> alerts,
      DateTime reportDate});
}

/// @nodoc
class __$$BudgetReportModelImplCopyWithImpl<$Res>
    extends _$BudgetReportModelCopyWithImpl<$Res, _$BudgetReportModelImpl>
    implements _$$BudgetReportModelImplCopyWith<$Res> {
  __$$BudgetReportModelImplCopyWithImpl(_$BudgetReportModelImpl _value,
      $Res Function(_$BudgetReportModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? budgetId = null,
    Object? budgetName = null,
    Object? totalBudget = null,
    Object? totalSpent = null,
    Object? remainingAmount = null,
    Object? usagePercentage = null,
    Object? categorySpending = null,
    Object? alerts = null,
    Object? reportDate = null,
  }) {
    return _then(_$BudgetReportModelImpl(
      budgetId: null == budgetId
          ? _value.budgetId
          : budgetId // ignore: cast_nullable_to_non_nullable
              as String,
      budgetName: null == budgetName
          ? _value.budgetName
          : budgetName // ignore: cast_nullable_to_non_nullable
              as String,
      totalBudget: null == totalBudget
          ? _value.totalBudget
          : totalBudget // ignore: cast_nullable_to_non_nullable
              as double,
      totalSpent: null == totalSpent
          ? _value.totalSpent
          : totalSpent // ignore: cast_nullable_to_non_nullable
              as double,
      remainingAmount: null == remainingAmount
          ? _value.remainingAmount
          : remainingAmount // ignore: cast_nullable_to_non_nullable
              as double,
      usagePercentage: null == usagePercentage
          ? _value.usagePercentage
          : usagePercentage // ignore: cast_nullable_to_non_nullable
              as double,
      categorySpending: null == categorySpending
          ? _value._categorySpending
          : categorySpending // ignore: cast_nullable_to_non_nullable
              as List<CategorySpendingModel>,
      alerts: null == alerts
          ? _value._alerts
          : alerts // ignore: cast_nullable_to_non_nullable
              as List<BudgetAlertModel>,
      reportDate: null == reportDate
          ? _value.reportDate
          : reportDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BudgetReportModelImpl implements _BudgetReportModel {
  const _$BudgetReportModelImpl(
      {required this.budgetId,
      required this.budgetName,
      required this.totalBudget,
      required this.totalSpent,
      required this.remainingAmount,
      required this.usagePercentage,
      required final List<CategorySpendingModel> categorySpending,
      required final List<BudgetAlertModel> alerts,
      required this.reportDate})
      : _categorySpending = categorySpending,
        _alerts = alerts;

  factory _$BudgetReportModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BudgetReportModelImplFromJson(json);

  @override
  final String budgetId;
  @override
  final String budgetName;
  @override
  final double totalBudget;
  @override
  final double totalSpent;
  @override
  final double remainingAmount;
  @override
  final double usagePercentage;
  final List<CategorySpendingModel> _categorySpending;
  @override
  List<CategorySpendingModel> get categorySpending {
    if (_categorySpending is EqualUnmodifiableListView)
      return _categorySpending;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categorySpending);
  }

  final List<BudgetAlertModel> _alerts;
  @override
  List<BudgetAlertModel> get alerts {
    if (_alerts is EqualUnmodifiableListView) return _alerts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_alerts);
  }

  @override
  final DateTime reportDate;

  @override
  String toString() {
    return 'BudgetReportModel(budgetId: $budgetId, budgetName: $budgetName, totalBudget: $totalBudget, totalSpent: $totalSpent, remainingAmount: $remainingAmount, usagePercentage: $usagePercentage, categorySpending: $categorySpending, alerts: $alerts, reportDate: $reportDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BudgetReportModelImpl &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.budgetName, budgetName) ||
                other.budgetName == budgetName) &&
            (identical(other.totalBudget, totalBudget) ||
                other.totalBudget == totalBudget) &&
            (identical(other.totalSpent, totalSpent) ||
                other.totalSpent == totalSpent) &&
            (identical(other.remainingAmount, remainingAmount) ||
                other.remainingAmount == remainingAmount) &&
            (identical(other.usagePercentage, usagePercentage) ||
                other.usagePercentage == usagePercentage) &&
            const DeepCollectionEquality()
                .equals(other._categorySpending, _categorySpending) &&
            const DeepCollectionEquality().equals(other._alerts, _alerts) &&
            (identical(other.reportDate, reportDate) ||
                other.reportDate == reportDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      budgetId,
      budgetName,
      totalBudget,
      totalSpent,
      remainingAmount,
      usagePercentage,
      const DeepCollectionEquality().hash(_categorySpending),
      const DeepCollectionEquality().hash(_alerts),
      reportDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BudgetReportModelImplCopyWith<_$BudgetReportModelImpl> get copyWith =>
      __$$BudgetReportModelImplCopyWithImpl<_$BudgetReportModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BudgetReportModelImplToJson(
      this,
    );
  }
}

abstract class _BudgetReportModel implements BudgetReportModel {
  const factory _BudgetReportModel(
      {required final String budgetId,
      required final String budgetName,
      required final double totalBudget,
      required final double totalSpent,
      required final double remainingAmount,
      required final double usagePercentage,
      required final List<CategorySpendingModel> categorySpending,
      required final List<BudgetAlertModel> alerts,
      required final DateTime reportDate}) = _$BudgetReportModelImpl;

  factory _BudgetReportModel.fromJson(Map<String, dynamic> json) =
      _$BudgetReportModelImpl.fromJson;

  @override
  String get budgetId;
  @override
  String get budgetName;
  @override
  double get totalBudget;
  @override
  double get totalSpent;
  @override
  double get remainingAmount;
  @override
  double get usagePercentage;
  @override
  List<CategorySpendingModel> get categorySpending;
  @override
  List<BudgetAlertModel> get alerts;
  @override
  DateTime get reportDate;
  @override
  @JsonKey(ignore: true)
  _$$BudgetReportModelImplCopyWith<_$BudgetReportModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CategorySpendingModel _$CategorySpendingModelFromJson(
    Map<String, dynamic> json) {
  return _CategorySpendingModel.fromJson(json);
}

/// @nodoc
mixin _$CategorySpendingModel {
  String get category => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  double get percentage => throw _privateConstructorUsedError;
  int get transactionCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CategorySpendingModelCopyWith<CategorySpendingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategorySpendingModelCopyWith<$Res> {
  factory $CategorySpendingModelCopyWith(CategorySpendingModel value,
          $Res Function(CategorySpendingModel) then) =
      _$CategorySpendingModelCopyWithImpl<$Res, CategorySpendingModel>;
  @useResult
  $Res call(
      {String category,
      double amount,
      double percentage,
      int transactionCount});
}

/// @nodoc
class _$CategorySpendingModelCopyWithImpl<$Res,
        $Val extends CategorySpendingModel>
    implements $CategorySpendingModelCopyWith<$Res> {
  _$CategorySpendingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? amount = null,
    Object? percentage = null,
    Object? transactionCount = null,
  }) {
    return _then(_value.copyWith(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategorySpendingModelImplCopyWith<$Res>
    implements $CategorySpendingModelCopyWith<$Res> {
  factory _$$CategorySpendingModelImplCopyWith(
          _$CategorySpendingModelImpl value,
          $Res Function(_$CategorySpendingModelImpl) then) =
      __$$CategorySpendingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String category,
      double amount,
      double percentage,
      int transactionCount});
}

/// @nodoc
class __$$CategorySpendingModelImplCopyWithImpl<$Res>
    extends _$CategorySpendingModelCopyWithImpl<$Res,
        _$CategorySpendingModelImpl>
    implements _$$CategorySpendingModelImplCopyWith<$Res> {
  __$$CategorySpendingModelImplCopyWithImpl(_$CategorySpendingModelImpl _value,
      $Res Function(_$CategorySpendingModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? amount = null,
    Object? percentage = null,
    Object? transactionCount = null,
  }) {
    return _then(_$CategorySpendingModelImpl(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CategorySpendingModelImpl implements _CategorySpendingModel {
  const _$CategorySpendingModelImpl(
      {required this.category,
      required this.amount,
      required this.percentage,
      required this.transactionCount});

  factory _$CategorySpendingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategorySpendingModelImplFromJson(json);

  @override
  final String category;
  @override
  final double amount;
  @override
  final double percentage;
  @override
  final int transactionCount;

  @override
  String toString() {
    return 'CategorySpendingModel(category: $category, amount: $amount, percentage: $percentage, transactionCount: $transactionCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategorySpendingModelImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, category, amount, percentage, transactionCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CategorySpendingModelImplCopyWith<_$CategorySpendingModelImpl>
      get copyWith => __$$CategorySpendingModelImplCopyWithImpl<
          _$CategorySpendingModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategorySpendingModelImplToJson(
      this,
    );
  }
}

abstract class _CategorySpendingModel implements CategorySpendingModel {
  const factory _CategorySpendingModel(
      {required final String category,
      required final double amount,
      required final double percentage,
      required final int transactionCount}) = _$CategorySpendingModelImpl;

  factory _CategorySpendingModel.fromJson(Map<String, dynamic> json) =
      _$CategorySpendingModelImpl.fromJson;

  @override
  String get category;
  @override
  double get amount;
  @override
  double get percentage;
  @override
  int get transactionCount;
  @override
  @JsonKey(ignore: true)
  _$$CategorySpendingModelImplCopyWith<_$CategorySpendingModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
