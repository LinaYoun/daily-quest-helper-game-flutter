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

class $StreakQuestsTable extends StreakQuests
    with TableInfo<$StreakQuestsTable, StreakQuest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StreakQuestsTable(this.attachedDatabase, [this._alias]);
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
  static const String $name = 'streak_quests';
  @override
  VerificationContext validateIntegrity(
    Insertable<StreakQuest> instance, {
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
  StreakQuest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StreakQuest(
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
  $StreakQuestsTable createAlias(String alias) {
    return $StreakQuestsTable(attachedDatabase, alias);
  }
}

class StreakQuest extends DataClass implements Insertable<StreakQuest> {
  final int id;
  final String title;
  final int progress;
  final int target;
  final String status;
  final String? iconUrl;
  final String? rewardUrl;
  const StreakQuest({
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

  StreakQuestsCompanion toCompanion(bool nullToAbsent) {
    return StreakQuestsCompanion(
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

  factory StreakQuest.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StreakQuest(
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

  StreakQuest copyWith({
    int? id,
    String? title,
    int? progress,
    int? target,
    String? status,
    Value<String?> iconUrl = const Value.absent(),
    Value<String?> rewardUrl = const Value.absent(),
  }) => StreakQuest(
    id: id ?? this.id,
    title: title ?? this.title,
    progress: progress ?? this.progress,
    target: target ?? this.target,
    status: status ?? this.status,
    iconUrl: iconUrl.present ? iconUrl.value : this.iconUrl,
    rewardUrl: rewardUrl.present ? rewardUrl.value : this.rewardUrl,
  );
  StreakQuest copyWithCompanion(StreakQuestsCompanion data) {
    return StreakQuest(
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
    return (StringBuffer('StreakQuest(')
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
      (other is StreakQuest &&
          other.id == this.id &&
          other.title == this.title &&
          other.progress == this.progress &&
          other.target == this.target &&
          other.status == this.status &&
          other.iconUrl == this.iconUrl &&
          other.rewardUrl == this.rewardUrl);
}

class StreakQuestsCompanion extends UpdateCompanion<StreakQuest> {
  final Value<int> id;
  final Value<String> title;
  final Value<int> progress;
  final Value<int> target;
  final Value<String> status;
  final Value<String?> iconUrl;
  final Value<String?> rewardUrl;
  const StreakQuestsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.progress = const Value.absent(),
    this.target = const Value.absent(),
    this.status = const Value.absent(),
    this.iconUrl = const Value.absent(),
    this.rewardUrl = const Value.absent(),
  });
  StreakQuestsCompanion.insert({
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
  static Insertable<StreakQuest> custom({
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

  StreakQuestsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<int>? progress,
    Value<int>? target,
    Value<String>? status,
    Value<String?>? iconUrl,
    Value<String?>? rewardUrl,
  }) {
    return StreakQuestsCompanion(
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
    return (StringBuffer('StreakQuestsCompanion(')
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

class $StreakStatesTable extends StreakStates
    with TableInfo<$StreakStatesTable, StreakState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StreakStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _streakDaysMeta = const VerificationMeta(
    'streakDays',
  );
  @override
  late final GeneratedColumn<int> streakDays = GeneratedColumn<int>(
    'streak_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastResetYmdMeta = const VerificationMeta(
    'lastResetYmd',
  );
  @override
  late final GeneratedColumn<String> lastResetYmd = GeneratedColumn<String>(
    'last_reset_ymd',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastCompletionYmdMeta = const VerificationMeta(
    'lastCompletionYmd',
  );
  @override
  late final GeneratedColumn<String> lastCompletionYmd =
      GeneratedColumn<String>(
        'last_completion_ymd',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    streakDays,
    lastResetYmd,
    lastCompletionYmd,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'streak_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<StreakState> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('streak_days')) {
      context.handle(
        _streakDaysMeta,
        streakDays.isAcceptableOrUnknown(data['streak_days']!, _streakDaysMeta),
      );
    }
    if (data.containsKey('last_reset_ymd')) {
      context.handle(
        _lastResetYmdMeta,
        lastResetYmd.isAcceptableOrUnknown(
          data['last_reset_ymd']!,
          _lastResetYmdMeta,
        ),
      );
    }
    if (data.containsKey('last_completion_ymd')) {
      context.handle(
        _lastCompletionYmdMeta,
        lastCompletionYmd.isAcceptableOrUnknown(
          data['last_completion_ymd']!,
          _lastCompletionYmdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StreakState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StreakState(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      streakDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}streak_days'],
      )!,
      lastResetYmd: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_reset_ymd'],
      ),
      lastCompletionYmd: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_completion_ymd'],
      ),
    );
  }

  @override
  $StreakStatesTable createAlias(String alias) {
    return $StreakStatesTable(attachedDatabase, alias);
  }
}

class StreakState extends DataClass implements Insertable<StreakState> {
  final int id;
  final int streakDays;
  final String? lastResetYmd;
  final String? lastCompletionYmd;
  const StreakState({
    required this.id,
    required this.streakDays,
    this.lastResetYmd,
    this.lastCompletionYmd,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['streak_days'] = Variable<int>(streakDays);
    if (!nullToAbsent || lastResetYmd != null) {
      map['last_reset_ymd'] = Variable<String>(lastResetYmd);
    }
    if (!nullToAbsent || lastCompletionYmd != null) {
      map['last_completion_ymd'] = Variable<String>(lastCompletionYmd);
    }
    return map;
  }

  StreakStatesCompanion toCompanion(bool nullToAbsent) {
    return StreakStatesCompanion(
      id: Value(id),
      streakDays: Value(streakDays),
      lastResetYmd: lastResetYmd == null && nullToAbsent
          ? const Value.absent()
          : Value(lastResetYmd),
      lastCompletionYmd: lastCompletionYmd == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCompletionYmd),
    );
  }

  factory StreakState.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StreakState(
      id: serializer.fromJson<int>(json['id']),
      streakDays: serializer.fromJson<int>(json['streakDays']),
      lastResetYmd: serializer.fromJson<String?>(json['lastResetYmd']),
      lastCompletionYmd: serializer.fromJson<String?>(
        json['lastCompletionYmd'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'streakDays': serializer.toJson<int>(streakDays),
      'lastResetYmd': serializer.toJson<String?>(lastResetYmd),
      'lastCompletionYmd': serializer.toJson<String?>(lastCompletionYmd),
    };
  }

  StreakState copyWith({
    int? id,
    int? streakDays,
    Value<String?> lastResetYmd = const Value.absent(),
    Value<String?> lastCompletionYmd = const Value.absent(),
  }) => StreakState(
    id: id ?? this.id,
    streakDays: streakDays ?? this.streakDays,
    lastResetYmd: lastResetYmd.present ? lastResetYmd.value : this.lastResetYmd,
    lastCompletionYmd: lastCompletionYmd.present
        ? lastCompletionYmd.value
        : this.lastCompletionYmd,
  );
  StreakState copyWithCompanion(StreakStatesCompanion data) {
    return StreakState(
      id: data.id.present ? data.id.value : this.id,
      streakDays: data.streakDays.present
          ? data.streakDays.value
          : this.streakDays,
      lastResetYmd: data.lastResetYmd.present
          ? data.lastResetYmd.value
          : this.lastResetYmd,
      lastCompletionYmd: data.lastCompletionYmd.present
          ? data.lastCompletionYmd.value
          : this.lastCompletionYmd,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StreakState(')
          ..write('id: $id, ')
          ..write('streakDays: $streakDays, ')
          ..write('lastResetYmd: $lastResetYmd, ')
          ..write('lastCompletionYmd: $lastCompletionYmd')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, streakDays, lastResetYmd, lastCompletionYmd);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StreakState &&
          other.id == this.id &&
          other.streakDays == this.streakDays &&
          other.lastResetYmd == this.lastResetYmd &&
          other.lastCompletionYmd == this.lastCompletionYmd);
}

class StreakStatesCompanion extends UpdateCompanion<StreakState> {
  final Value<int> id;
  final Value<int> streakDays;
  final Value<String?> lastResetYmd;
  final Value<String?> lastCompletionYmd;
  const StreakStatesCompanion({
    this.id = const Value.absent(),
    this.streakDays = const Value.absent(),
    this.lastResetYmd = const Value.absent(),
    this.lastCompletionYmd = const Value.absent(),
  });
  StreakStatesCompanion.insert({
    this.id = const Value.absent(),
    this.streakDays = const Value.absent(),
    this.lastResetYmd = const Value.absent(),
    this.lastCompletionYmd = const Value.absent(),
  });
  static Insertable<StreakState> custom({
    Expression<int>? id,
    Expression<int>? streakDays,
    Expression<String>? lastResetYmd,
    Expression<String>? lastCompletionYmd,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (streakDays != null) 'streak_days': streakDays,
      if (lastResetYmd != null) 'last_reset_ymd': lastResetYmd,
      if (lastCompletionYmd != null) 'last_completion_ymd': lastCompletionYmd,
    });
  }

  StreakStatesCompanion copyWith({
    Value<int>? id,
    Value<int>? streakDays,
    Value<String?>? lastResetYmd,
    Value<String?>? lastCompletionYmd,
  }) {
    return StreakStatesCompanion(
      id: id ?? this.id,
      streakDays: streakDays ?? this.streakDays,
      lastResetYmd: lastResetYmd ?? this.lastResetYmd,
      lastCompletionYmd: lastCompletionYmd ?? this.lastCompletionYmd,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (streakDays.present) {
      map['streak_days'] = Variable<int>(streakDays.value);
    }
    if (lastResetYmd.present) {
      map['last_reset_ymd'] = Variable<String>(lastResetYmd.value);
    }
    if (lastCompletionYmd.present) {
      map['last_completion_ymd'] = Variable<String>(lastCompletionYmd.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StreakStatesCompanion(')
          ..write('id: $id, ')
          ..write('streakDays: $streakDays, ')
          ..write('lastResetYmd: $lastResetYmd, ')
          ..write('lastCompletionYmd: $lastCompletionYmd')
          ..write(')'))
        .toString();
  }
}

class $OwnedItemsTable extends OwnedItems
    with TableInfo<$OwnedItemsTable, OwnedItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OwnedItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
    'count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, key, count];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'owned_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<OwnedItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
        _countMeta,
        count.isAcceptableOrUnknown(data['count']!, _countMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OwnedItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OwnedItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      count: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}count'],
      )!,
    );
  }

  @override
  $OwnedItemsTable createAlias(String alias) {
    return $OwnedItemsTable(attachedDatabase, alias);
  }
}

class OwnedItem extends DataClass implements Insertable<OwnedItem> {
  final int id;
  final String key;
  final int count;
  const OwnedItem({required this.id, required this.key, required this.count});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['key'] = Variable<String>(key);
    map['count'] = Variable<int>(count);
    return map;
  }

  OwnedItemsCompanion toCompanion(bool nullToAbsent) {
    return OwnedItemsCompanion(
      id: Value(id),
      key: Value(key),
      count: Value(count),
    );
  }

  factory OwnedItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OwnedItem(
      id: serializer.fromJson<int>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      count: serializer.fromJson<int>(json['count']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'key': serializer.toJson<String>(key),
      'count': serializer.toJson<int>(count),
    };
  }

  OwnedItem copyWith({int? id, String? key, int? count}) => OwnedItem(
    id: id ?? this.id,
    key: key ?? this.key,
    count: count ?? this.count,
  );
  OwnedItem copyWithCompanion(OwnedItemsCompanion data) {
    return OwnedItem(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      count: data.count.present ? data.count.value : this.count,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OwnedItem(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('count: $count')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, key, count);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OwnedItem &&
          other.id == this.id &&
          other.key == this.key &&
          other.count == this.count);
}

class OwnedItemsCompanion extends UpdateCompanion<OwnedItem> {
  final Value<int> id;
  final Value<String> key;
  final Value<int> count;
  const OwnedItemsCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.count = const Value.absent(),
  });
  OwnedItemsCompanion.insert({
    this.id = const Value.absent(),
    required String key,
    this.count = const Value.absent(),
  }) : key = Value(key);
  static Insertable<OwnedItem> custom({
    Expression<int>? id,
    Expression<String>? key,
    Expression<int>? count,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (count != null) 'count': count,
    });
  }

  OwnedItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? key,
    Value<int>? count,
  }) {
    return OwnedItemsCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      count: count ?? this.count,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OwnedItemsCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('count: $count')
          ..write(')'))
        .toString();
  }
}

class $BadgesTable extends Badges with TableInfo<$BadgesTable, Badge> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BadgesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _earnedAtMeta = const VerificationMeta(
    'earnedAt',
  );
  @override
  late final GeneratedColumn<String> earnedAt = GeneratedColumn<String>(
    'earned_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, key, earnedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'badges';
  @override
  VerificationContext validateIntegrity(
    Insertable<Badge> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('earned_at')) {
      context.handle(
        _earnedAtMeta,
        earnedAt.isAcceptableOrUnknown(data['earned_at']!, _earnedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Badge map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Badge(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      earnedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}earned_at'],
      ),
    );
  }

  @override
  $BadgesTable createAlias(String alias) {
    return $BadgesTable(attachedDatabase, alias);
  }
}

class Badge extends DataClass implements Insertable<Badge> {
  final int id;
  final String key;
  final String? earnedAt;
  const Badge({required this.id, required this.key, this.earnedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['key'] = Variable<String>(key);
    if (!nullToAbsent || earnedAt != null) {
      map['earned_at'] = Variable<String>(earnedAt);
    }
    return map;
  }

  BadgesCompanion toCompanion(bool nullToAbsent) {
    return BadgesCompanion(
      id: Value(id),
      key: Value(key),
      earnedAt: earnedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(earnedAt),
    );
  }

  factory Badge.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Badge(
      id: serializer.fromJson<int>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      earnedAt: serializer.fromJson<String?>(json['earnedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'key': serializer.toJson<String>(key),
      'earnedAt': serializer.toJson<String?>(earnedAt),
    };
  }

  Badge copyWith({
    int? id,
    String? key,
    Value<String?> earnedAt = const Value.absent(),
  }) => Badge(
    id: id ?? this.id,
    key: key ?? this.key,
    earnedAt: earnedAt.present ? earnedAt.value : this.earnedAt,
  );
  Badge copyWithCompanion(BadgesCompanion data) {
    return Badge(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      earnedAt: data.earnedAt.present ? data.earnedAt.value : this.earnedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Badge(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('earnedAt: $earnedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, key, earnedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Badge &&
          other.id == this.id &&
          other.key == this.key &&
          other.earnedAt == this.earnedAt);
}

class BadgesCompanion extends UpdateCompanion<Badge> {
  final Value<int> id;
  final Value<String> key;
  final Value<String?> earnedAt;
  const BadgesCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.earnedAt = const Value.absent(),
  });
  BadgesCompanion.insert({
    this.id = const Value.absent(),
    required String key,
    this.earnedAt = const Value.absent(),
  }) : key = Value(key);
  static Insertable<Badge> custom({
    Expression<int>? id,
    Expression<String>? key,
    Expression<String>? earnedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (earnedAt != null) 'earned_at': earnedAt,
    });
  }

  BadgesCompanion copyWith({
    Value<int>? id,
    Value<String>? key,
    Value<String?>? earnedAt,
  }) {
    return BadgesCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      earnedAt: earnedAt ?? this.earnedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (earnedAt.present) {
      map['earned_at'] = Variable<String>(earnedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BadgesCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('earnedAt: $earnedAt')
          ..write(')'))
        .toString();
  }
}

class $AppStatesTable extends AppStates
    with TableInfo<$AppStatesTable, AppState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppState> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppState(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      ),
    );
  }

  @override
  $AppStatesTable createAlias(String alias) {
    return $AppStatesTable(attachedDatabase, alias);
  }
}

class AppState extends DataClass implements Insertable<AppState> {
  final String key;
  final String? value;
  const AppState({required this.key, this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    return map;
  }

  AppStatesCompanion toCompanion(bool nullToAbsent) {
    return AppStatesCompanion(
      key: Value(key),
      value: value == null && nullToAbsent
          ? const Value.absent()
          : Value(value),
    );
  }

  factory AppState.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppState(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String?>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String?>(value),
    };
  }

  AppState copyWith({
    String? key,
    Value<String?> value = const Value.absent(),
  }) => AppState(
    key: key ?? this.key,
    value: value.present ? value.value : this.value,
  );
  AppState copyWithCompanion(AppStatesCompanion data) {
    return AppState(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppState(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppState && other.key == this.key && other.value == this.value);
}

class AppStatesCompanion extends UpdateCompanion<AppState> {
  final Value<String> key;
  final Value<String?> value;
  final Value<int> rowid;
  const AppStatesCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppStatesCompanion.insert({
    required String key,
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key);
  static Insertable<AppState> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppStatesCompanion copyWith({
    Value<String>? key,
    Value<String?>? value,
    Value<int>? rowid,
  }) {
    return AppStatesCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppStatesCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $QuestsTable quests = $QuestsTable(this);
  late final $WeeklyQuestsTable weeklyQuests = $WeeklyQuestsTable(this);
  late final $StreakQuestsTable streakQuests = $StreakQuestsTable(this);
  late final $StreakStatesTable streakStates = $StreakStatesTable(this);
  late final $OwnedItemsTable ownedItems = $OwnedItemsTable(this);
  late final $BadgesTable badges = $BadgesTable(this);
  late final $AppStatesTable appStates = $AppStatesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    quests,
    weeklyQuests,
    streakQuests,
    streakStates,
    ownedItems,
    badges,
    appStates,
  ];
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
typedef $$StreakQuestsTableCreateCompanionBuilder =
    StreakQuestsCompanion Function({
      Value<int> id,
      required String title,
      required int progress,
      required int target,
      required String status,
      Value<String?> iconUrl,
      Value<String?> rewardUrl,
    });
typedef $$StreakQuestsTableUpdateCompanionBuilder =
    StreakQuestsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<int> progress,
      Value<int> target,
      Value<String> status,
      Value<String?> iconUrl,
      Value<String?> rewardUrl,
    });

class $$StreakQuestsTableFilterComposer
    extends Composer<_$AppDatabase, $StreakQuestsTable> {
  $$StreakQuestsTableFilterComposer({
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

class $$StreakQuestsTableOrderingComposer
    extends Composer<_$AppDatabase, $StreakQuestsTable> {
  $$StreakQuestsTableOrderingComposer({
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

class $$StreakQuestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StreakQuestsTable> {
  $$StreakQuestsTableAnnotationComposer({
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

class $$StreakQuestsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StreakQuestsTable,
          StreakQuest,
          $$StreakQuestsTableFilterComposer,
          $$StreakQuestsTableOrderingComposer,
          $$StreakQuestsTableAnnotationComposer,
          $$StreakQuestsTableCreateCompanionBuilder,
          $$StreakQuestsTableUpdateCompanionBuilder,
          (
            StreakQuest,
            BaseReferences<_$AppDatabase, $StreakQuestsTable, StreakQuest>,
          ),
          StreakQuest,
          PrefetchHooks Function()
        > {
  $$StreakQuestsTableTableManager(_$AppDatabase db, $StreakQuestsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StreakQuestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StreakQuestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StreakQuestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> progress = const Value.absent(),
                Value<int> target = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> iconUrl = const Value.absent(),
                Value<String?> rewardUrl = const Value.absent(),
              }) => StreakQuestsCompanion(
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
              }) => StreakQuestsCompanion.insert(
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

typedef $$StreakQuestsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StreakQuestsTable,
      StreakQuest,
      $$StreakQuestsTableFilterComposer,
      $$StreakQuestsTableOrderingComposer,
      $$StreakQuestsTableAnnotationComposer,
      $$StreakQuestsTableCreateCompanionBuilder,
      $$StreakQuestsTableUpdateCompanionBuilder,
      (
        StreakQuest,
        BaseReferences<_$AppDatabase, $StreakQuestsTable, StreakQuest>,
      ),
      StreakQuest,
      PrefetchHooks Function()
    >;
typedef $$StreakStatesTableCreateCompanionBuilder =
    StreakStatesCompanion Function({
      Value<int> id,
      Value<int> streakDays,
      Value<String?> lastResetYmd,
      Value<String?> lastCompletionYmd,
    });
typedef $$StreakStatesTableUpdateCompanionBuilder =
    StreakStatesCompanion Function({
      Value<int> id,
      Value<int> streakDays,
      Value<String?> lastResetYmd,
      Value<String?> lastCompletionYmd,
    });

class $$StreakStatesTableFilterComposer
    extends Composer<_$AppDatabase, $StreakStatesTable> {
  $$StreakStatesTableFilterComposer({
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

  ColumnFilters<int> get streakDays => $composableBuilder(
    column: $table.streakDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastResetYmd => $composableBuilder(
    column: $table.lastResetYmd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastCompletionYmd => $composableBuilder(
    column: $table.lastCompletionYmd,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StreakStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $StreakStatesTable> {
  $$StreakStatesTableOrderingComposer({
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

  ColumnOrderings<int> get streakDays => $composableBuilder(
    column: $table.streakDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastResetYmd => $composableBuilder(
    column: $table.lastResetYmd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastCompletionYmd => $composableBuilder(
    column: $table.lastCompletionYmd,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StreakStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StreakStatesTable> {
  $$StreakStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get streakDays => $composableBuilder(
    column: $table.streakDays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastResetYmd => $composableBuilder(
    column: $table.lastResetYmd,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastCompletionYmd => $composableBuilder(
    column: $table.lastCompletionYmd,
    builder: (column) => column,
  );
}

class $$StreakStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StreakStatesTable,
          StreakState,
          $$StreakStatesTableFilterComposer,
          $$StreakStatesTableOrderingComposer,
          $$StreakStatesTableAnnotationComposer,
          $$StreakStatesTableCreateCompanionBuilder,
          $$StreakStatesTableUpdateCompanionBuilder,
          (
            StreakState,
            BaseReferences<_$AppDatabase, $StreakStatesTable, StreakState>,
          ),
          StreakState,
          PrefetchHooks Function()
        > {
  $$StreakStatesTableTableManager(_$AppDatabase db, $StreakStatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StreakStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StreakStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StreakStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> streakDays = const Value.absent(),
                Value<String?> lastResetYmd = const Value.absent(),
                Value<String?> lastCompletionYmd = const Value.absent(),
              }) => StreakStatesCompanion(
                id: id,
                streakDays: streakDays,
                lastResetYmd: lastResetYmd,
                lastCompletionYmd: lastCompletionYmd,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> streakDays = const Value.absent(),
                Value<String?> lastResetYmd = const Value.absent(),
                Value<String?> lastCompletionYmd = const Value.absent(),
              }) => StreakStatesCompanion.insert(
                id: id,
                streakDays: streakDays,
                lastResetYmd: lastResetYmd,
                lastCompletionYmd: lastCompletionYmd,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StreakStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StreakStatesTable,
      StreakState,
      $$StreakStatesTableFilterComposer,
      $$StreakStatesTableOrderingComposer,
      $$StreakStatesTableAnnotationComposer,
      $$StreakStatesTableCreateCompanionBuilder,
      $$StreakStatesTableUpdateCompanionBuilder,
      (
        StreakState,
        BaseReferences<_$AppDatabase, $StreakStatesTable, StreakState>,
      ),
      StreakState,
      PrefetchHooks Function()
    >;
typedef $$OwnedItemsTableCreateCompanionBuilder =
    OwnedItemsCompanion Function({
      Value<int> id,
      required String key,
      Value<int> count,
    });
typedef $$OwnedItemsTableUpdateCompanionBuilder =
    OwnedItemsCompanion Function({
      Value<int> id,
      Value<String> key,
      Value<int> count,
    });

class $$OwnedItemsTableFilterComposer
    extends Composer<_$AppDatabase, $OwnedItemsTable> {
  $$OwnedItemsTableFilterComposer({
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

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OwnedItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $OwnedItemsTable> {
  $$OwnedItemsTableOrderingComposer({
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

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OwnedItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OwnedItemsTable> {
  $$OwnedItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);
}

class $$OwnedItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OwnedItemsTable,
          OwnedItem,
          $$OwnedItemsTableFilterComposer,
          $$OwnedItemsTableOrderingComposer,
          $$OwnedItemsTableAnnotationComposer,
          $$OwnedItemsTableCreateCompanionBuilder,
          $$OwnedItemsTableUpdateCompanionBuilder,
          (
            OwnedItem,
            BaseReferences<_$AppDatabase, $OwnedItemsTable, OwnedItem>,
          ),
          OwnedItem,
          PrefetchHooks Function()
        > {
  $$OwnedItemsTableTableManager(_$AppDatabase db, $OwnedItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OwnedItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OwnedItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OwnedItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<int> count = const Value.absent(),
              }) => OwnedItemsCompanion(id: id, key: key, count: count),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String key,
                Value<int> count = const Value.absent(),
              }) => OwnedItemsCompanion.insert(id: id, key: key, count: count),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OwnedItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OwnedItemsTable,
      OwnedItem,
      $$OwnedItemsTableFilterComposer,
      $$OwnedItemsTableOrderingComposer,
      $$OwnedItemsTableAnnotationComposer,
      $$OwnedItemsTableCreateCompanionBuilder,
      $$OwnedItemsTableUpdateCompanionBuilder,
      (OwnedItem, BaseReferences<_$AppDatabase, $OwnedItemsTable, OwnedItem>),
      OwnedItem,
      PrefetchHooks Function()
    >;
typedef $$BadgesTableCreateCompanionBuilder =
    BadgesCompanion Function({
      Value<int> id,
      required String key,
      Value<String?> earnedAt,
    });
typedef $$BadgesTableUpdateCompanionBuilder =
    BadgesCompanion Function({
      Value<int> id,
      Value<String> key,
      Value<String?> earnedAt,
    });

class $$BadgesTableFilterComposer
    extends Composer<_$AppDatabase, $BadgesTable> {
  $$BadgesTableFilterComposer({
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

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get earnedAt => $composableBuilder(
    column: $table.earnedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BadgesTableOrderingComposer
    extends Composer<_$AppDatabase, $BadgesTable> {
  $$BadgesTableOrderingComposer({
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

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get earnedAt => $composableBuilder(
    column: $table.earnedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BadgesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BadgesTable> {
  $$BadgesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get earnedAt =>
      $composableBuilder(column: $table.earnedAt, builder: (column) => column);
}

class $$BadgesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BadgesTable,
          Badge,
          $$BadgesTableFilterComposer,
          $$BadgesTableOrderingComposer,
          $$BadgesTableAnnotationComposer,
          $$BadgesTableCreateCompanionBuilder,
          $$BadgesTableUpdateCompanionBuilder,
          (Badge, BaseReferences<_$AppDatabase, $BadgesTable, Badge>),
          Badge,
          PrefetchHooks Function()
        > {
  $$BadgesTableTableManager(_$AppDatabase db, $BadgesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BadgesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BadgesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BadgesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<String?> earnedAt = const Value.absent(),
              }) => BadgesCompanion(id: id, key: key, earnedAt: earnedAt),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String key,
                Value<String?> earnedAt = const Value.absent(),
              }) =>
                  BadgesCompanion.insert(id: id, key: key, earnedAt: earnedAt),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BadgesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BadgesTable,
      Badge,
      $$BadgesTableFilterComposer,
      $$BadgesTableOrderingComposer,
      $$BadgesTableAnnotationComposer,
      $$BadgesTableCreateCompanionBuilder,
      $$BadgesTableUpdateCompanionBuilder,
      (Badge, BaseReferences<_$AppDatabase, $BadgesTable, Badge>),
      Badge,
      PrefetchHooks Function()
    >;
typedef $$AppStatesTableCreateCompanionBuilder =
    AppStatesCompanion Function({
      required String key,
      Value<String?> value,
      Value<int> rowid,
    });
typedef $$AppStatesTableUpdateCompanionBuilder =
    AppStatesCompanion Function({
      Value<String> key,
      Value<String?> value,
      Value<int> rowid,
    });

class $$AppStatesTableFilterComposer
    extends Composer<_$AppDatabase, $AppStatesTable> {
  $$AppStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $AppStatesTable> {
  $$AppStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppStatesTable> {
  $$AppStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppStatesTable,
          AppState,
          $$AppStatesTableFilterComposer,
          $$AppStatesTableOrderingComposer,
          $$AppStatesTableAnnotationComposer,
          $$AppStatesTableCreateCompanionBuilder,
          $$AppStatesTableUpdateCompanionBuilder,
          (AppState, BaseReferences<_$AppDatabase, $AppStatesTable, AppState>),
          AppState,
          PrefetchHooks Function()
        > {
  $$AppStatesTableTableManager(_$AppDatabase db, $AppStatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String?> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppStatesCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                Value<String?> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppStatesCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppStatesTable,
      AppState,
      $$AppStatesTableFilterComposer,
      $$AppStatesTableOrderingComposer,
      $$AppStatesTableAnnotationComposer,
      $$AppStatesTableCreateCompanionBuilder,
      $$AppStatesTableUpdateCompanionBuilder,
      (AppState, BaseReferences<_$AppDatabase, $AppStatesTable, AppState>),
      AppState,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$QuestsTableTableManager get quests =>
      $$QuestsTableTableManager(_db, _db.quests);
  $$WeeklyQuestsTableTableManager get weeklyQuests =>
      $$WeeklyQuestsTableTableManager(_db, _db.weeklyQuests);
  $$StreakQuestsTableTableManager get streakQuests =>
      $$StreakQuestsTableTableManager(_db, _db.streakQuests);
  $$StreakStatesTableTableManager get streakStates =>
      $$StreakStatesTableTableManager(_db, _db.streakStates);
  $$OwnedItemsTableTableManager get ownedItems =>
      $$OwnedItemsTableTableManager(_db, _db.ownedItems);
  $$BadgesTableTableManager get badges =>
      $$BadgesTableTableManager(_db, _db.badges);
  $$AppStatesTableTableManager get appStates =>
      $$AppStatesTableTableManager(_db, _db.appStates);
}
