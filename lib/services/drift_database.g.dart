// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_database.dart';

// ignore_for_file: type=lint
class $QuestsTable extends Quests with TableInfo<$QuestsTable, Quest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _progressMeta = const VerificationMeta(
    'progress',
  );
  @override
  late final GeneratedColumn<int> progress = GeneratedColumn<int>(
    'progress',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetMeta = const VerificationMeta('target');
  @override
  late final GeneratedColumn<int> target = GeneratedColumn<int>(
    'target',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconUrlMeta = const VerificationMeta(
    'iconUrl',
  );
  @override
  late final GeneratedColumn<String> iconUrl = GeneratedColumn<String>(
    'icon_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rewardUrlMeta = const VerificationMeta(
    'rewardUrl',
  );
  @override
  late final GeneratedColumn<String> rewardUrl = GeneratedColumn<String>(
    'reward_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    progress,
    target,
    status,
    iconUrl,
    rewardUrl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quests';
  @override
  VerificationContext validateIntegrity(
    Insertable<Quest> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('progress')) {
      context.handle(
        _progressMeta,
        progress.isAcceptableOrUnknown(data['progress']!, _progressMeta),
      );
    } else if (isInserting) {
      context.missing(_progressMeta);
    }
    if (data.containsKey('target')) {
      context.handle(
        _targetMeta,
        target.isAcceptableOrUnknown(data['target']!, _targetMeta),
      );
    } else if (isInserting) {
      context.missing(_targetMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('icon_url')) {
      context.handle(
        _iconUrlMeta,
        iconUrl.isAcceptableOrUnknown(data['icon_url']!, _iconUrlMeta),
      );
    }
    if (data.containsKey('reward_url')) {
      context.handle(
        _rewardUrlMeta,
        rewardUrl.isAcceptableOrUnknown(data['reward_url']!, _rewardUrlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Quest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Quest(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      progress: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}progress'],
      )!,
      target: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      iconUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_url'],
      ),
      rewardUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reward_url'],
      ),
    );
  }

  @override
  $QuestsTable createAlias(String alias) {
    return $QuestsTable(attachedDatabase, alias);
  }
}

class Quest extends DataClass implements Insertable<Quest> {
  final int id;
  final String title;
  final int progress;
  final int target;
  final String status;
  final String? iconUrl;
  final String? rewardUrl;
  const Quest({
    required this.id,
    required this.title,
    required this.progress,
    required this.target,
    required this.status,
    this.iconUrl,
    this.rewardUrl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['progress'] = Variable<int>(progress);
    map['target'] = Variable<int>(target);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || iconUrl != null) {
      map['icon_url'] = Variable<String>(iconUrl);
    }
    if (!nullToAbsent || rewardUrl != null) {
      map['reward_url'] = Variable<String>(rewardUrl);
    }
    return map;
  }

  QuestsCompanion toCompanion(bool nullToAbsent) {
    return QuestsCompanion(
      id: Value(id),
      title: Value(title),
      progress: Value(progress),
      target: Value(target),
      status: Value(status),
      iconUrl: iconUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(iconUrl),
      rewardUrl: rewardUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(rewardUrl),
    );
  }

  factory Quest.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Quest(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      progress: serializer.fromJson<int>(json['progress']),
      target: serializer.fromJson<int>(json['target']),
      status: serializer.fromJson<String>(json['status']),
      iconUrl: serializer.fromJson<String?>(json['iconUrl']),
      rewardUrl: serializer.fromJson<String?>(json['rewardUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'progress': serializer.toJson<int>(progress),
      'target': serializer.toJson<int>(target),
      'status': serializer.toJson<String>(status),
      'iconUrl': serializer.toJson<String?>(iconUrl),
      'rewardUrl': serializer.toJson<String?>(rewardUrl),
    };
  }

  Quest copyWith({
    int? id,
    String? title,
    int? progress,
    int? target,
    String? status,
    Value<String?> iconUrl = const Value.absent(),
    Value<String?> rewardUrl = const Value.absent(),
  }) => Quest(
    id: id ?? this.id,
    title: title ?? this.title,
    progress: progress ?? this.progress,
    target: target ?? this.target,
    status: status ?? this.status,
    iconUrl: iconUrl.present ? iconUrl.value : this.iconUrl,
    rewardUrl: rewardUrl.present ? rewardUrl.value : this.rewardUrl,
  );
  Quest copyWithCompanion(QuestsCompanion data) {
    return Quest(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      progress: data.progress.present ? data.progress.value : this.progress,
      target: data.target.present ? data.target.value : this.target,
      status: data.status.present ? data.status.value : this.status,
      iconUrl: data.iconUrl.present ? data.iconUrl.value : this.iconUrl,
      rewardUrl: data.rewardUrl.present ? data.rewardUrl.value : this.rewardUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Quest(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('progress: $progress, ')
          ..write('target: $target, ')
          ..write('status: $status, ')
          ..write('iconUrl: $iconUrl, ')
          ..write('rewardUrl: $rewardUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, progress, target, status, iconUrl, rewardUrl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Quest &&
          other.id == this.id &&
          other.title == this.title &&
          other.progress == this.progress &&
          other.target == this.target &&
          other.status == this.status &&
          other.iconUrl == this.iconUrl &&
          other.rewardUrl == this.rewardUrl);
}

class QuestsCompanion extends UpdateCompanion<Quest> {
  final Value<int> id;
  final Value<String> title;
  final Value<int> progress;
  final Value<int> target;
  final Value<String> status;
  final Value<String?> iconUrl;
  final Value<String?> rewardUrl;
  const QuestsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.progress = const Value.absent(),
    this.target = const Value.absent(),
    this.status = const Value.absent(),
    this.iconUrl = const Value.absent(),
    this.rewardUrl = const Value.absent(),
  });
  QuestsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required int progress,
    required int target,
    required String status,
    this.iconUrl = const Value.absent(),
    this.rewardUrl = const Value.absent(),
  }) : title = Value(title),
       progress = Value(progress),
       target = Value(target),
       status = Value(status);
  static Insertable<Quest> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<int>? progress,
    Expression<int>? target,
    Expression<String>? status,
    Expression<String>? iconUrl,
    Expression<String>? rewardUrl,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (progress != null) 'progress': progress,
      if (target != null) 'target': target,
      if (status != null) 'status': status,
      if (iconUrl != null) 'icon_url': iconUrl,
      if (rewardUrl != null) 'reward_url': rewardUrl,
    });
  }

  QuestsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<int>? progress,
    Value<int>? target,
    Value<String>? status,
    Value<String?>? iconUrl,
    Value<String?>? rewardUrl,
  }) {
    return QuestsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      progress: progress ?? this.progress,
      target: target ?? this.target,
      status: status ?? this.status,
      iconUrl: iconUrl ?? this.iconUrl,
      rewardUrl: rewardUrl ?? this.rewardUrl,
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
    if (progress.present) {
      map['progress'] = Variable<int>(progress.value);
    }
    if (target.present) {
      map['target'] = Variable<int>(target.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (iconUrl.present) {
      map['icon_url'] = Variable<String>(iconUrl.value);
    }
    if (rewardUrl.present) {
      map['reward_url'] = Variable<String>(rewardUrl.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('progress: $progress, ')
          ..write('target: $target, ')
          ..write('status: $status, ')
          ..write('iconUrl: $iconUrl, ')
          ..write('rewardUrl: $rewardUrl')
          ..write(')'))
        .toString();
  }
}

class $WeeklyQuestsTable extends WeeklyQuests
    with TableInfo<$WeeklyQuestsTable, WeeklyQuest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeeklyQuestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _progressMeta = const VerificationMeta(
    'progress',
  );
  @override
  late final GeneratedColumn<int> progress = GeneratedColumn<int>(
    'progress',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetMeta = const VerificationMeta('target');
  @override
  late final GeneratedColumn<int> target = GeneratedColumn<int>(
    'target',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconUrlMeta = const VerificationMeta(
    'iconUrl',
  );
  @override
  late final GeneratedColumn<String> iconUrl = GeneratedColumn<String>(
    'icon_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rewardUrlMeta = const VerificationMeta(
    'rewardUrl',
  );
  @override
  late final GeneratedColumn<String> rewardUrl = GeneratedColumn<String>(
    'reward_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    progress,
    target,
    status,
    iconUrl,
    rewardUrl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weekly_quests';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeeklyQuest> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('progress')) {
      context.handle(
        _progressMeta,
        progress.isAcceptableOrUnknown(data['progress']!, _progressMeta),
      );
    } else if (isInserting) {
      context.missing(_progressMeta);
    }
    if (data.containsKey('target')) {
      context.handle(
        _targetMeta,
        target.isAcceptableOrUnknown(data['target']!, _targetMeta),
      );
    } else if (isInserting) {
      context.missing(_targetMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('icon_url')) {
      context.handle(
        _iconUrlMeta,
        iconUrl.isAcceptableOrUnknown(data['icon_url']!, _iconUrlMeta),
      );
    }
    if (data.containsKey('reward_url')) {
      context.handle(
        _rewardUrlMeta,
        rewardUrl.isAcceptableOrUnknown(data['reward_url']!, _rewardUrlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeeklyQuest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeeklyQuest(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      progress: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}progress'],
      )!,
      target: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      iconUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_url'],
      ),
      rewardUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reward_url'],
      ),
    );
  }

  @override
  $WeeklyQuestsTable createAlias(String alias) {
    return $WeeklyQuestsTable(attachedDatabase, alias);
  }
}

class WeeklyQuest extends DataClass implements Insertable<WeeklyQuest> {
  final int id;
  final String title;
  final int progress;
  final int target;
  final String status;
  final String? iconUrl;
  final String? rewardUrl;
  const WeeklyQuest({
    required this.id,
    required this.title,
    required this.progress,
    required this.target,
    required this.status,
    this.iconUrl,
    this.rewardUrl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['progress'] = Variable<int>(progress);
    map['target'] = Variable<int>(target);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || iconUrl != null) {
      map['icon_url'] = Variable<String>(iconUrl);
    }
    if (!nullToAbsent || rewardUrl != null) {
      map['reward_url'] = Variable<String>(rewardUrl);
    }
    return map;
  }

  WeeklyQuestsCompanion toCompanion(bool nullToAbsent) {
    return WeeklyQuestsCompanion(
      id: Value(id),
      title: Value(title),
      progress: Value(progress),
      target: Value(target),
      status: Value(status),
      iconUrl: iconUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(iconUrl),
      rewardUrl: rewardUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(rewardUrl),
    );
  }

  factory WeeklyQuest.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeeklyQuest(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      progress: serializer.fromJson<int>(json['progress']),
      target: serializer.fromJson<int>(json['target']),
      status: serializer.fromJson<String>(json['status']),
      iconUrl: serializer.fromJson<String?>(json['iconUrl']),
      rewardUrl: serializer.fromJson<String?>(json['rewardUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'progress': serializer.toJson<int>(progress),
      'target': serializer.toJson<int>(target),
      'status': serializer.toJson<String>(status),
      'iconUrl': serializer.toJson<String?>(iconUrl),
      'rewardUrl': serializer.toJson<String?>(rewardUrl),
    };
  }

  WeeklyQuest copyWith({
    int? id,
    String? title,
    int? progress,
    int? target,
    String? status,
    Value<String?> iconUrl = const Value.absent(),
    Value<String?> rewardUrl = const Value.absent(),
  }) => WeeklyQuest(
    id: id ?? this.id,
    title: title ?? this.title,
    progress: progress ?? this.progress,
    target: target ?? this.target,
    status: status ?? this.status,
    iconUrl: iconUrl.present ? iconUrl.value : this.iconUrl,
    rewardUrl: rewardUrl.present ? rewardUrl.value : this.rewardUrl,
  );
  WeeklyQuest copyWithCompanion(WeeklyQuestsCompanion data) {
    return WeeklyQuest(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      progress: data.progress.present ? data.progress.value : this.progress,
      target: data.target.present ? data.target.value : this.target,
      status: data.status.present ? data.status.value : this.status,
      iconUrl: data.iconUrl.present ? data.iconUrl.value : this.iconUrl,
      rewardUrl: data.rewardUrl.present ? data.rewardUrl.value : this.rewardUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyQuest(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('progress: $progress, ')
          ..write('target: $target, ')
          ..write('status: $status, ')
          ..write('iconUrl: $iconUrl, ')
          ..write('rewardUrl: $rewardUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, progress, target, status, iconUrl, rewardUrl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeeklyQuest &&
          other.id == this.id &&
          other.title == this.title &&
          other.progress == this.progress &&
          other.target == this.target &&
          other.status == this.status &&
          other.iconUrl == this.iconUrl &&
          other.rewardUrl == this.rewardUrl);
}

class WeeklyQuestsCompanion extends UpdateCompanion<WeeklyQuest> {
  final Value<int> id;
  final Value<String> title;
  final Value<int> progress;
  final Value<int> target;
  final Value<String> status;
  final Value<String?> iconUrl;
  final Value<String?> rewardUrl;
  const WeeklyQuestsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.progress = const Value.absent(),
    this.target = const Value.absent(),
    this.status = const Value.absent(),
    this.iconUrl = const Value.absent(),
    this.rewardUrl = const Value.absent(),
  });
  WeeklyQuestsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required int progress,
    required int target,
    required String status,
    this.iconUrl = const Value.absent(),
    this.rewardUrl = const Value.absent(),
  }) : title = Value(title),
       progress = Value(progress),
       target = Value(target),
       status = Value(status);
  static Insertable<WeeklyQuest> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<int>? progress,
    Expression<int>? target,
    Expression<String>? status,
    Expression<String>? iconUrl,
    Expression<String>? rewardUrl,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (progress != null) 'progress': progress,
      if (target != null) 'target': target,
      if (status != null) 'status': status,
      if (iconUrl != null) 'icon_url': iconUrl,
      if (rewardUrl != null) 'reward_url': rewardUrl,
    });
  }

  WeeklyQuestsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<int>? progress,
    Value<int>? target,
    Value<String>? status,
    Value<String?>? iconUrl,
    Value<String?>? rewardUrl,
  }) {
    return WeeklyQuestsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      progress: progress ?? this.progress,
      target: target ?? this.target,
      status: status ?? this.status,
      iconUrl: iconUrl ?? this.iconUrl,
      rewardUrl: rewardUrl ?? this.rewardUrl,
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
    if (progress.present) {
      map['progress'] = Variable<int>(progress.value);
    }
    if (target.present) {
      map['target'] = Variable<int>(target.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (iconUrl.present) {
      map['icon_url'] = Variable<String>(iconUrl.value);
    }
    if (rewardUrl.present) {
      map['reward_url'] = Variable<String>(rewardUrl.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyQuestsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('progress: $progress, ')
          ..write('target: $target, ')
          ..write('status: $status, ')
          ..write('iconUrl: $iconUrl, ')
          ..write('rewardUrl: $rewardUrl')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $QuestsTable quests = $QuestsTable(this);
  late final $WeeklyQuestsTable weeklyQuests = $WeeklyQuestsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [quests, weeklyQuests];
}

typedef $$QuestsTableCreateCompanionBuilder =
    QuestsCompanion Function({
      Value<int> id,
      required String title,
      required int progress,
      required int target,
      required String status,
      Value<String?> iconUrl,
      Value<String?> rewardUrl,
    });
typedef $$QuestsTableUpdateCompanionBuilder =
    QuestsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<int> progress,
      Value<int> target,
      Value<String> status,
      Value<String?> iconUrl,
      Value<String?> rewardUrl,
    });

class $$QuestsTableFilterComposer
    extends Composer<_$AppDatabase, $QuestsTable> {
  $$QuestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconUrl => $composableBuilder(
    column: $table.iconUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rewardUrl => $composableBuilder(
    column: $table.rewardUrl,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuestsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestsTable> {
  $$QuestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconUrl => $composableBuilder(
    column: $table.iconUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rewardUrl => $composableBuilder(
    column: $table.rewardUrl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestsTable> {
  $$QuestsTableAnnotationComposer({
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

  GeneratedColumn<int> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<int> get target =>
      $composableBuilder(column: $table.target, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get iconUrl =>
      $composableBuilder(column: $table.iconUrl, builder: (column) => column);

  GeneratedColumn<String> get rewardUrl =>
      $composableBuilder(column: $table.rewardUrl, builder: (column) => column);
}

class $$QuestsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuestsTable,
          Quest,
          $$QuestsTableFilterComposer,
          $$QuestsTableOrderingComposer,
          $$QuestsTableAnnotationComposer,
          $$QuestsTableCreateCompanionBuilder,
          $$QuestsTableUpdateCompanionBuilder,
          (Quest, BaseReferences<_$AppDatabase, $QuestsTable, Quest>),
          Quest,
          PrefetchHooks Function()
        > {
  $$QuestsTableTableManager(_$AppDatabase db, $QuestsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> progress = const Value.absent(),
                Value<int> target = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> iconUrl = const Value.absent(),
                Value<String?> rewardUrl = const Value.absent(),
              }) => QuestsCompanion(
                id: id,
                title: title,
                progress: progress,
                target: target,
                status: status,
                iconUrl: iconUrl,
                rewardUrl: rewardUrl,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required int progress,
                required int target,
                required String status,
                Value<String?> iconUrl = const Value.absent(),
                Value<String?> rewardUrl = const Value.absent(),
              }) => QuestsCompanion.insert(
                id: id,
                title: title,
                progress: progress,
                target: target,
                status: status,
                iconUrl: iconUrl,
                rewardUrl: rewardUrl,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuestsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuestsTable,
      Quest,
      $$QuestsTableFilterComposer,
      $$QuestsTableOrderingComposer,
      $$QuestsTableAnnotationComposer,
      $$QuestsTableCreateCompanionBuilder,
      $$QuestsTableUpdateCompanionBuilder,
      (Quest, BaseReferences<_$AppDatabase, $QuestsTable, Quest>),
      Quest,
      PrefetchHooks Function()
    >;
typedef $$WeeklyQuestsTableCreateCompanionBuilder =
    WeeklyQuestsCompanion Function({
      Value<int> id,
      required String title,
      required int progress,
      required int target,
      required String status,
      Value<String?> iconUrl,
      Value<String?> rewardUrl,
    });
typedef $$WeeklyQuestsTableUpdateCompanionBuilder =
    WeeklyQuestsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<int> progress,
      Value<int> target,
      Value<String> status,
      Value<String?> iconUrl,
      Value<String?> rewardUrl,
    });

class $$WeeklyQuestsTableFilterComposer
    extends Composer<_$AppDatabase, $WeeklyQuestsTable> {
  $$WeeklyQuestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconUrl => $composableBuilder(
    column: $table.iconUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rewardUrl => $composableBuilder(
    column: $table.rewardUrl,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeeklyQuestsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeeklyQuestsTable> {
  $$WeeklyQuestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconUrl => $composableBuilder(
    column: $table.iconUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rewardUrl => $composableBuilder(
    column: $table.rewardUrl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeeklyQuestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeeklyQuestsTable> {
  $$WeeklyQuestsTableAnnotationComposer({
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

  GeneratedColumn<int> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<int> get target =>
      $composableBuilder(column: $table.target, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get iconUrl =>
      $composableBuilder(column: $table.iconUrl, builder: (column) => column);

  GeneratedColumn<String> get rewardUrl =>
      $composableBuilder(column: $table.rewardUrl, builder: (column) => column);
}

class $$WeeklyQuestsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeeklyQuestsTable,
          WeeklyQuest,
          $$WeeklyQuestsTableFilterComposer,
          $$WeeklyQuestsTableOrderingComposer,
          $$WeeklyQuestsTableAnnotationComposer,
          $$WeeklyQuestsTableCreateCompanionBuilder,
          $$WeeklyQuestsTableUpdateCompanionBuilder,
          (
            WeeklyQuest,
            BaseReferences<_$AppDatabase, $WeeklyQuestsTable, WeeklyQuest>,
          ),
          WeeklyQuest,
          PrefetchHooks Function()
        > {
  $$WeeklyQuestsTableTableManager(_$AppDatabase db, $WeeklyQuestsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeeklyQuestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeeklyQuestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeeklyQuestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> progress = const Value.absent(),
                Value<int> target = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> iconUrl = const Value.absent(),
                Value<String?> rewardUrl = const Value.absent(),
              }) => WeeklyQuestsCompanion(
                id: id,
                title: title,
                progress: progress,
                target: target,
                status: status,
                iconUrl: iconUrl,
                rewardUrl: rewardUrl,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required int progress,
                required int target,
                required String status,
                Value<String?> iconUrl = const Value.absent(),
                Value<String?> rewardUrl = const Value.absent(),
              }) => WeeklyQuestsCompanion.insert(
                id: id,
                title: title,
                progress: progress,
                target: target,
                status: status,
                iconUrl: iconUrl,
                rewardUrl: rewardUrl,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeeklyQuestsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeeklyQuestsTable,
      WeeklyQuest,
      $$WeeklyQuestsTableFilterComposer,
      $$WeeklyQuestsTableOrderingComposer,
      $$WeeklyQuestsTableAnnotationComposer,
      $$WeeklyQuestsTableCreateCompanionBuilder,
      $$WeeklyQuestsTableUpdateCompanionBuilder,
      (
        WeeklyQuest,
        BaseReferences<_$AppDatabase, $WeeklyQuestsTable, WeeklyQuest>,
      ),
      WeeklyQuest,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$QuestsTableTableManager get quests =>
      $$QuestsTableTableManager(_db, _db.quests);
  $$WeeklyQuestsTableTableManager get weeklyQuests =>
      $$WeeklyQuestsTableTableManager(_db, _db.weeklyQuests);
}
