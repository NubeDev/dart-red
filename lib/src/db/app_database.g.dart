// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LocationsTable extends Locations
    with TableInfo<$LocationsTable, LocationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orgIdMeta = const VerificationMeta('orgId');
  @override
  late final GeneratedColumn<String> orgId = GeneratedColumn<String>(
    'org_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastUsedMeta = const VerificationMeta(
    'lastUsed',
  );
  @override
  late final GeneratedColumn<DateTime> lastUsed = GeneratedColumn<DateTime>(
    'last_used',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    url,
    orgId,
    isActive,
    lastUsed,
    address,
    latitude,
    longitude,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'locations';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('org_id')) {
      context.handle(
        _orgIdMeta,
        orgId.isAcceptableOrUnknown(data['org_id']!, _orgIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orgIdMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('last_used')) {
      context.handle(
        _lastUsedMeta,
        lastUsed.isAcceptableOrUnknown(data['last_used']!, _lastUsedMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocationRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      orgId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}org_id'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      lastUsed: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_used'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
    );
  }

  @override
  $LocationsTable createAlias(String alias) {
    return $LocationsTable(attachedDatabase, alias);
  }
}

class LocationRow extends DataClass implements Insertable<LocationRow> {
  final String id;
  final String name;
  final String url;
  final String orgId;
  final bool isActive;
  final DateTime? lastUsed;
  final String? address;
  final double? latitude;
  final double? longitude;
  const LocationRow({
    required this.id,
    required this.name,
    required this.url,
    required this.orgId,
    required this.isActive,
    this.lastUsed,
    this.address,
    this.latitude,
    this.longitude,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['url'] = Variable<String>(url);
    map['org_id'] = Variable<String>(orgId);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || lastUsed != null) {
      map['last_used'] = Variable<DateTime>(lastUsed);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    return map;
  }

  LocationsCompanion toCompanion(bool nullToAbsent) {
    return LocationsCompanion(
      id: Value(id),
      name: Value(name),
      url: Value(url),
      orgId: Value(orgId),
      isActive: Value(isActive),
      lastUsed: lastUsed == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUsed),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
    );
  }

  factory LocationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocationRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      url: serializer.fromJson<String>(json['url']),
      orgId: serializer.fromJson<String>(json['orgId']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      lastUsed: serializer.fromJson<DateTime?>(json['lastUsed']),
      address: serializer.fromJson<String?>(json['address']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'url': serializer.toJson<String>(url),
      'orgId': serializer.toJson<String>(orgId),
      'isActive': serializer.toJson<bool>(isActive),
      'lastUsed': serializer.toJson<DateTime?>(lastUsed),
      'address': serializer.toJson<String?>(address),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
    };
  }

  LocationRow copyWith({
    String? id,
    String? name,
    String? url,
    String? orgId,
    bool? isActive,
    Value<DateTime?> lastUsed = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
  }) => LocationRow(
    id: id ?? this.id,
    name: name ?? this.name,
    url: url ?? this.url,
    orgId: orgId ?? this.orgId,
    isActive: isActive ?? this.isActive,
    lastUsed: lastUsed.present ? lastUsed.value : this.lastUsed,
    address: address.present ? address.value : this.address,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
  );
  LocationRow copyWithCompanion(LocationsCompanion data) {
    return LocationRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      url: data.url.present ? data.url.value : this.url,
      orgId: data.orgId.present ? data.orgId.value : this.orgId,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      lastUsed: data.lastUsed.present ? data.lastUsed.value : this.lastUsed,
      address: data.address.present ? data.address.value : this.address,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocationRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('url: $url, ')
          ..write('orgId: $orgId, ')
          ..write('isActive: $isActive, ')
          ..write('lastUsed: $lastUsed, ')
          ..write('address: $address, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    url,
    orgId,
    isActive,
    lastUsed,
    address,
    latitude,
    longitude,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocationRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.url == this.url &&
          other.orgId == this.orgId &&
          other.isActive == this.isActive &&
          other.lastUsed == this.lastUsed &&
          other.address == this.address &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude);
}

class LocationsCompanion extends UpdateCompanion<LocationRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> url;
  final Value<String> orgId;
  final Value<bool> isActive;
  final Value<DateTime?> lastUsed;
  final Value<String?> address;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<int> rowid;
  const LocationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.url = const Value.absent(),
    this.orgId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.lastUsed = const Value.absent(),
    this.address = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocationsCompanion.insert({
    required String id,
    required String name,
    required String url,
    required String orgId,
    this.isActive = const Value.absent(),
    this.lastUsed = const Value.absent(),
    this.address = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       url = Value(url),
       orgId = Value(orgId);
  static Insertable<LocationRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? url,
    Expression<String>? orgId,
    Expression<bool>? isActive,
    Expression<DateTime>? lastUsed,
    Expression<String>? address,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (url != null) 'url': url,
      if (orgId != null) 'org_id': orgId,
      if (isActive != null) 'is_active': isActive,
      if (lastUsed != null) 'last_used': lastUsed,
      if (address != null) 'address': address,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocationsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? url,
    Value<String>? orgId,
    Value<bool>? isActive,
    Value<DateTime?>? lastUsed,
    Value<String?>? address,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<int>? rowid,
  }) {
    return LocationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      orgId: orgId ?? this.orgId,
      isActive: isActive ?? this.isActive,
      lastUsed: lastUsed ?? this.lastUsed,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (orgId.present) {
      map['org_id'] = Variable<String>(orgId.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (lastUsed.present) {
      map['last_used'] = Variable<DateTime>(lastUsed.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('url: $url, ')
          ..write('orgId: $orgId, ')
          ..write('isActive: $isActive, ')
          ..write('lastUsed: $lastUsed, ')
          ..write('address: $address, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PinnedPagesTable extends PinnedPages
    with TableInfo<$PinnedPagesTable, PinnedPageRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PinnedPagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationIdMeta = const VerificationMeta(
    'locationId',
  );
  @override
  late final GeneratedColumn<String> locationId = GeneratedColumn<String>(
    'location_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationNameMeta = const VerificationMeta(
    'locationName',
  );
  @override
  late final GeneratedColumn<String> locationName = GeneratedColumn<String>(
    'location_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<String> nodeId = GeneratedColumn<String>(
    'node_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nodeLabelMeta = const VerificationMeta(
    'nodeLabel',
  );
  @override
  late final GeneratedColumn<String> nodeLabel = GeneratedColumn<String>(
    'node_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pageIdMeta = const VerificationMeta('pageId');
  @override
  late final GeneratedColumn<String> pageId = GeneratedColumn<String>(
    'page_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pageTitleMeta = const VerificationMeta(
    'pageTitle',
  );
  @override
  late final GeneratedColumn<String> pageTitle = GeneratedColumn<String>(
    'page_title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pinnedAtMeta = const VerificationMeta(
    'pinnedAt',
  );
  @override
  late final GeneratedColumn<DateTime> pinnedAt = GeneratedColumn<DateTime>(
    'pinned_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    locationId,
    locationName,
    nodeId,
    nodeLabel,
    pageId,
    pageTitle,
    pinnedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pinned_pages';
  @override
  VerificationContext validateIntegrity(
    Insertable<PinnedPageRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('location_id')) {
      context.handle(
        _locationIdMeta,
        locationId.isAcceptableOrUnknown(data['location_id']!, _locationIdMeta),
      );
    } else if (isInserting) {
      context.missing(_locationIdMeta);
    }
    if (data.containsKey('location_name')) {
      context.handle(
        _locationNameMeta,
        locationName.isAcceptableOrUnknown(
          data['location_name']!,
          _locationNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_locationNameMeta);
    }
    if (data.containsKey('node_id')) {
      context.handle(
        _nodeIdMeta,
        nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nodeIdMeta);
    }
    if (data.containsKey('node_label')) {
      context.handle(
        _nodeLabelMeta,
        nodeLabel.isAcceptableOrUnknown(data['node_label']!, _nodeLabelMeta),
      );
    } else if (isInserting) {
      context.missing(_nodeLabelMeta);
    }
    if (data.containsKey('page_id')) {
      context.handle(
        _pageIdMeta,
        pageId.isAcceptableOrUnknown(data['page_id']!, _pageIdMeta),
      );
    }
    if (data.containsKey('page_title')) {
      context.handle(
        _pageTitleMeta,
        pageTitle.isAcceptableOrUnknown(data['page_title']!, _pageTitleMeta),
      );
    }
    if (data.containsKey('pinned_at')) {
      context.handle(
        _pinnedAtMeta,
        pinnedAt.isAcceptableOrUnknown(data['pinned_at']!, _pinnedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_pinnedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PinnedPageRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PinnedPageRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      locationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_id'],
      )!,
      locationName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_name'],
      )!,
      nodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}node_id'],
      )!,
      nodeLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}node_label'],
      )!,
      pageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}page_id'],
      ),
      pageTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}page_title'],
      ),
      pinnedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}pinned_at'],
      )!,
    );
  }

  @override
  $PinnedPagesTable createAlias(String alias) {
    return $PinnedPagesTable(attachedDatabase, alias);
  }
}

class PinnedPageRow extends DataClass implements Insertable<PinnedPageRow> {
  final String id;
  final String locationId;
  final String locationName;
  final String nodeId;
  final String nodeLabel;
  final String? pageId;
  final String? pageTitle;
  final DateTime pinnedAt;
  const PinnedPageRow({
    required this.id,
    required this.locationId,
    required this.locationName,
    required this.nodeId,
    required this.nodeLabel,
    this.pageId,
    this.pageTitle,
    required this.pinnedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['location_id'] = Variable<String>(locationId);
    map['location_name'] = Variable<String>(locationName);
    map['node_id'] = Variable<String>(nodeId);
    map['node_label'] = Variable<String>(nodeLabel);
    if (!nullToAbsent || pageId != null) {
      map['page_id'] = Variable<String>(pageId);
    }
    if (!nullToAbsent || pageTitle != null) {
      map['page_title'] = Variable<String>(pageTitle);
    }
    map['pinned_at'] = Variable<DateTime>(pinnedAt);
    return map;
  }

  PinnedPagesCompanion toCompanion(bool nullToAbsent) {
    return PinnedPagesCompanion(
      id: Value(id),
      locationId: Value(locationId),
      locationName: Value(locationName),
      nodeId: Value(nodeId),
      nodeLabel: Value(nodeLabel),
      pageId: pageId == null && nullToAbsent
          ? const Value.absent()
          : Value(pageId),
      pageTitle: pageTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(pageTitle),
      pinnedAt: Value(pinnedAt),
    );
  }

  factory PinnedPageRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PinnedPageRow(
      id: serializer.fromJson<String>(json['id']),
      locationId: serializer.fromJson<String>(json['locationId']),
      locationName: serializer.fromJson<String>(json['locationName']),
      nodeId: serializer.fromJson<String>(json['nodeId']),
      nodeLabel: serializer.fromJson<String>(json['nodeLabel']),
      pageId: serializer.fromJson<String?>(json['pageId']),
      pageTitle: serializer.fromJson<String?>(json['pageTitle']),
      pinnedAt: serializer.fromJson<DateTime>(json['pinnedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'locationId': serializer.toJson<String>(locationId),
      'locationName': serializer.toJson<String>(locationName),
      'nodeId': serializer.toJson<String>(nodeId),
      'nodeLabel': serializer.toJson<String>(nodeLabel),
      'pageId': serializer.toJson<String?>(pageId),
      'pageTitle': serializer.toJson<String?>(pageTitle),
      'pinnedAt': serializer.toJson<DateTime>(pinnedAt),
    };
  }

  PinnedPageRow copyWith({
    String? id,
    String? locationId,
    String? locationName,
    String? nodeId,
    String? nodeLabel,
    Value<String?> pageId = const Value.absent(),
    Value<String?> pageTitle = const Value.absent(),
    DateTime? pinnedAt,
  }) => PinnedPageRow(
    id: id ?? this.id,
    locationId: locationId ?? this.locationId,
    locationName: locationName ?? this.locationName,
    nodeId: nodeId ?? this.nodeId,
    nodeLabel: nodeLabel ?? this.nodeLabel,
    pageId: pageId.present ? pageId.value : this.pageId,
    pageTitle: pageTitle.present ? pageTitle.value : this.pageTitle,
    pinnedAt: pinnedAt ?? this.pinnedAt,
  );
  PinnedPageRow copyWithCompanion(PinnedPagesCompanion data) {
    return PinnedPageRow(
      id: data.id.present ? data.id.value : this.id,
      locationId: data.locationId.present
          ? data.locationId.value
          : this.locationId,
      locationName: data.locationName.present
          ? data.locationName.value
          : this.locationName,
      nodeId: data.nodeId.present ? data.nodeId.value : this.nodeId,
      nodeLabel: data.nodeLabel.present ? data.nodeLabel.value : this.nodeLabel,
      pageId: data.pageId.present ? data.pageId.value : this.pageId,
      pageTitle: data.pageTitle.present ? data.pageTitle.value : this.pageTitle,
      pinnedAt: data.pinnedAt.present ? data.pinnedAt.value : this.pinnedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PinnedPageRow(')
          ..write('id: $id, ')
          ..write('locationId: $locationId, ')
          ..write('locationName: $locationName, ')
          ..write('nodeId: $nodeId, ')
          ..write('nodeLabel: $nodeLabel, ')
          ..write('pageId: $pageId, ')
          ..write('pageTitle: $pageTitle, ')
          ..write('pinnedAt: $pinnedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    locationId,
    locationName,
    nodeId,
    nodeLabel,
    pageId,
    pageTitle,
    pinnedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PinnedPageRow &&
          other.id == this.id &&
          other.locationId == this.locationId &&
          other.locationName == this.locationName &&
          other.nodeId == this.nodeId &&
          other.nodeLabel == this.nodeLabel &&
          other.pageId == this.pageId &&
          other.pageTitle == this.pageTitle &&
          other.pinnedAt == this.pinnedAt);
}

class PinnedPagesCompanion extends UpdateCompanion<PinnedPageRow> {
  final Value<String> id;
  final Value<String> locationId;
  final Value<String> locationName;
  final Value<String> nodeId;
  final Value<String> nodeLabel;
  final Value<String?> pageId;
  final Value<String?> pageTitle;
  final Value<DateTime> pinnedAt;
  final Value<int> rowid;
  const PinnedPagesCompanion({
    this.id = const Value.absent(),
    this.locationId = const Value.absent(),
    this.locationName = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.nodeLabel = const Value.absent(),
    this.pageId = const Value.absent(),
    this.pageTitle = const Value.absent(),
    this.pinnedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PinnedPagesCompanion.insert({
    required String id,
    required String locationId,
    required String locationName,
    required String nodeId,
    required String nodeLabel,
    this.pageId = const Value.absent(),
    this.pageTitle = const Value.absent(),
    required DateTime pinnedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       locationId = Value(locationId),
       locationName = Value(locationName),
       nodeId = Value(nodeId),
       nodeLabel = Value(nodeLabel),
       pinnedAt = Value(pinnedAt);
  static Insertable<PinnedPageRow> custom({
    Expression<String>? id,
    Expression<String>? locationId,
    Expression<String>? locationName,
    Expression<String>? nodeId,
    Expression<String>? nodeLabel,
    Expression<String>? pageId,
    Expression<String>? pageTitle,
    Expression<DateTime>? pinnedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (locationId != null) 'location_id': locationId,
      if (locationName != null) 'location_name': locationName,
      if (nodeId != null) 'node_id': nodeId,
      if (nodeLabel != null) 'node_label': nodeLabel,
      if (pageId != null) 'page_id': pageId,
      if (pageTitle != null) 'page_title': pageTitle,
      if (pinnedAt != null) 'pinned_at': pinnedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PinnedPagesCompanion copyWith({
    Value<String>? id,
    Value<String>? locationId,
    Value<String>? locationName,
    Value<String>? nodeId,
    Value<String>? nodeLabel,
    Value<String?>? pageId,
    Value<String?>? pageTitle,
    Value<DateTime>? pinnedAt,
    Value<int>? rowid,
  }) {
    return PinnedPagesCompanion(
      id: id ?? this.id,
      locationId: locationId ?? this.locationId,
      locationName: locationName ?? this.locationName,
      nodeId: nodeId ?? this.nodeId,
      nodeLabel: nodeLabel ?? this.nodeLabel,
      pageId: pageId ?? this.pageId,
      pageTitle: pageTitle ?? this.pageTitle,
      pinnedAt: pinnedAt ?? this.pinnedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<String>(locationId.value);
    }
    if (locationName.present) {
      map['location_name'] = Variable<String>(locationName.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<String>(nodeId.value);
    }
    if (nodeLabel.present) {
      map['node_label'] = Variable<String>(nodeLabel.value);
    }
    if (pageId.present) {
      map['page_id'] = Variable<String>(pageId.value);
    }
    if (pageTitle.present) {
      map['page_title'] = Variable<String>(pageTitle.value);
    }
    if (pinnedAt.present) {
      map['pinned_at'] = Variable<DateTime>(pinnedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PinnedPagesCompanion(')
          ..write('id: $id, ')
          ..write('locationId: $locationId, ')
          ..write('locationName: $locationName, ')
          ..write('nodeId: $nodeId, ')
          ..write('nodeLabel: $nodeLabel, ')
          ..write('pageId: $pageId, ')
          ..write('pageTitle: $pageTitle, ')
          ..write('pinnedAt: $pinnedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NetworksTable extends Networks
    with TableInfo<$NetworksTable, NetworkRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NetworksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _protocolMeta = const VerificationMeta(
    'protocol',
  );
  @override
  late final GeneratedColumn<String> protocol = GeneratedColumn<String>(
    'protocol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('mqtt'),
  );
  static const VerificationMeta _hostMeta = const VerificationMeta('host');
  @override
  late final GeneratedColumn<String> host = GeneratedColumn<String>(
    'host',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _portMeta = const VerificationMeta('port');
  @override
  late final GeneratedColumn<int> port = GeneratedColumn<int>(
    'port',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1883),
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _passwordMeta = const VerificationMeta(
    'password',
  );
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
    'password',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _useTlsMeta = const VerificationMeta('useTls');
  @override
  late final GeneratedColumn<bool> useTls = GeneratedColumn<bool>(
    'use_tls',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("use_tls" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _prefixMeta = const VerificationMeta('prefix');
  @override
  late final GeneratedColumn<String> prefix = GeneratedColumn<String>(
    'prefix',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _settingsMeta = const VerificationMeta(
    'settings',
  );
  @override
  late final GeneratedColumn<String> settings = GeneratedColumn<String>(
    'settings',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _cloudNodeIdMeta = const VerificationMeta(
    'cloudNodeId',
  );
  @override
  late final GeneratedColumn<String> cloudNodeId = GeneratedColumn<String>(
    'cloud_node_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationIdMeta = const VerificationMeta(
    'locationId',
  );
  @override
  late final GeneratedColumn<String> locationId = GeneratedColumn<String>(
    'location_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    protocol,
    host,
    port,
    username,
    password,
    useTls,
    prefix,
    enabled,
    description,
    settings,
    cloudNodeId,
    locationId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'networks';
  @override
  VerificationContext validateIntegrity(
    Insertable<NetworkRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('protocol')) {
      context.handle(
        _protocolMeta,
        protocol.isAcceptableOrUnknown(data['protocol']!, _protocolMeta),
      );
    }
    if (data.containsKey('host')) {
      context.handle(
        _hostMeta,
        host.isAcceptableOrUnknown(data['host']!, _hostMeta),
      );
    } else if (isInserting) {
      context.missing(_hostMeta);
    }
    if (data.containsKey('port')) {
      context.handle(
        _portMeta,
        port.isAcceptableOrUnknown(data['port']!, _portMeta),
      );
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    }
    if (data.containsKey('password')) {
      context.handle(
        _passwordMeta,
        password.isAcceptableOrUnknown(data['password']!, _passwordMeta),
      );
    }
    if (data.containsKey('use_tls')) {
      context.handle(
        _useTlsMeta,
        useTls.isAcceptableOrUnknown(data['use_tls']!, _useTlsMeta),
      );
    }
    if (data.containsKey('prefix')) {
      context.handle(
        _prefixMeta,
        prefix.isAcceptableOrUnknown(data['prefix']!, _prefixMeta),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('settings')) {
      context.handle(
        _settingsMeta,
        settings.isAcceptableOrUnknown(data['settings']!, _settingsMeta),
      );
    }
    if (data.containsKey('cloud_node_id')) {
      context.handle(
        _cloudNodeIdMeta,
        cloudNodeId.isAcceptableOrUnknown(
          data['cloud_node_id']!,
          _cloudNodeIdMeta,
        ),
      );
    }
    if (data.containsKey('location_id')) {
      context.handle(
        _locationIdMeta,
        locationId.isAcceptableOrUnknown(data['location_id']!, _locationIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NetworkRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NetworkRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      protocol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}protocol'],
      )!,
      host: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}host'],
      )!,
      port: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}port'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      ),
      password: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password'],
      ),
      useTls: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}use_tls'],
      )!,
      prefix: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prefix'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      settings: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}settings'],
      )!,
      cloudNodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cloud_node_id'],
      ),
      locationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $NetworksTable createAlias(String alias) {
    return $NetworksTable(attachedDatabase, alias);
  }
}

class NetworkRow extends DataClass implements Insertable<NetworkRow> {
  final String id;
  final String name;
  final String protocol;
  final String host;
  final int port;
  final String? username;
  final String? password;
  final bool useTls;
  final String prefix;
  final bool enabled;
  final String? description;

  /// Protocol-specific config JSON (BACnet: bbmdHost, apduTimeout, etc.)
  final String settings;

  /// Cloud sync: Rubix cloud node ID (null = not synced).
  final String? cloudNodeId;

  /// Cloud sync: which location (server) to sync to.
  final String? locationId;
  final DateTime createdAt;
  const NetworkRow({
    required this.id,
    required this.name,
    required this.protocol,
    required this.host,
    required this.port,
    this.username,
    this.password,
    required this.useTls,
    required this.prefix,
    required this.enabled,
    this.description,
    required this.settings,
    this.cloudNodeId,
    this.locationId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['protocol'] = Variable<String>(protocol);
    map['host'] = Variable<String>(host);
    map['port'] = Variable<int>(port);
    if (!nullToAbsent || username != null) {
      map['username'] = Variable<String>(username);
    }
    if (!nullToAbsent || password != null) {
      map['password'] = Variable<String>(password);
    }
    map['use_tls'] = Variable<bool>(useTls);
    map['prefix'] = Variable<String>(prefix);
    map['enabled'] = Variable<bool>(enabled);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['settings'] = Variable<String>(settings);
    if (!nullToAbsent || cloudNodeId != null) {
      map['cloud_node_id'] = Variable<String>(cloudNodeId);
    }
    if (!nullToAbsent || locationId != null) {
      map['location_id'] = Variable<String>(locationId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  NetworksCompanion toCompanion(bool nullToAbsent) {
    return NetworksCompanion(
      id: Value(id),
      name: Value(name),
      protocol: Value(protocol),
      host: Value(host),
      port: Value(port),
      username: username == null && nullToAbsent
          ? const Value.absent()
          : Value(username),
      password: password == null && nullToAbsent
          ? const Value.absent()
          : Value(password),
      useTls: Value(useTls),
      prefix: Value(prefix),
      enabled: Value(enabled),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      settings: Value(settings),
      cloudNodeId: cloudNodeId == null && nullToAbsent
          ? const Value.absent()
          : Value(cloudNodeId),
      locationId: locationId == null && nullToAbsent
          ? const Value.absent()
          : Value(locationId),
      createdAt: Value(createdAt),
    );
  }

  factory NetworkRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NetworkRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      protocol: serializer.fromJson<String>(json['protocol']),
      host: serializer.fromJson<String>(json['host']),
      port: serializer.fromJson<int>(json['port']),
      username: serializer.fromJson<String?>(json['username']),
      password: serializer.fromJson<String?>(json['password']),
      useTls: serializer.fromJson<bool>(json['useTls']),
      prefix: serializer.fromJson<String>(json['prefix']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      description: serializer.fromJson<String?>(json['description']),
      settings: serializer.fromJson<String>(json['settings']),
      cloudNodeId: serializer.fromJson<String?>(json['cloudNodeId']),
      locationId: serializer.fromJson<String?>(json['locationId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'protocol': serializer.toJson<String>(protocol),
      'host': serializer.toJson<String>(host),
      'port': serializer.toJson<int>(port),
      'username': serializer.toJson<String?>(username),
      'password': serializer.toJson<String?>(password),
      'useTls': serializer.toJson<bool>(useTls),
      'prefix': serializer.toJson<String>(prefix),
      'enabled': serializer.toJson<bool>(enabled),
      'description': serializer.toJson<String?>(description),
      'settings': serializer.toJson<String>(settings),
      'cloudNodeId': serializer.toJson<String?>(cloudNodeId),
      'locationId': serializer.toJson<String?>(locationId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  NetworkRow copyWith({
    String? id,
    String? name,
    String? protocol,
    String? host,
    int? port,
    Value<String?> username = const Value.absent(),
    Value<String?> password = const Value.absent(),
    bool? useTls,
    String? prefix,
    bool? enabled,
    Value<String?> description = const Value.absent(),
    String? settings,
    Value<String?> cloudNodeId = const Value.absent(),
    Value<String?> locationId = const Value.absent(),
    DateTime? createdAt,
  }) => NetworkRow(
    id: id ?? this.id,
    name: name ?? this.name,
    protocol: protocol ?? this.protocol,
    host: host ?? this.host,
    port: port ?? this.port,
    username: username.present ? username.value : this.username,
    password: password.present ? password.value : this.password,
    useTls: useTls ?? this.useTls,
    prefix: prefix ?? this.prefix,
    enabled: enabled ?? this.enabled,
    description: description.present ? description.value : this.description,
    settings: settings ?? this.settings,
    cloudNodeId: cloudNodeId.present ? cloudNodeId.value : this.cloudNodeId,
    locationId: locationId.present ? locationId.value : this.locationId,
    createdAt: createdAt ?? this.createdAt,
  );
  NetworkRow copyWithCompanion(NetworksCompanion data) {
    return NetworkRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      protocol: data.protocol.present ? data.protocol.value : this.protocol,
      host: data.host.present ? data.host.value : this.host,
      port: data.port.present ? data.port.value : this.port,
      username: data.username.present ? data.username.value : this.username,
      password: data.password.present ? data.password.value : this.password,
      useTls: data.useTls.present ? data.useTls.value : this.useTls,
      prefix: data.prefix.present ? data.prefix.value : this.prefix,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      description: data.description.present
          ? data.description.value
          : this.description,
      settings: data.settings.present ? data.settings.value : this.settings,
      cloudNodeId: data.cloudNodeId.present
          ? data.cloudNodeId.value
          : this.cloudNodeId,
      locationId: data.locationId.present
          ? data.locationId.value
          : this.locationId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NetworkRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('protocol: $protocol, ')
          ..write('host: $host, ')
          ..write('port: $port, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('useTls: $useTls, ')
          ..write('prefix: $prefix, ')
          ..write('enabled: $enabled, ')
          ..write('description: $description, ')
          ..write('settings: $settings, ')
          ..write('cloudNodeId: $cloudNodeId, ')
          ..write('locationId: $locationId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    protocol,
    host,
    port,
    username,
    password,
    useTls,
    prefix,
    enabled,
    description,
    settings,
    cloudNodeId,
    locationId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NetworkRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.protocol == this.protocol &&
          other.host == this.host &&
          other.port == this.port &&
          other.username == this.username &&
          other.password == this.password &&
          other.useTls == this.useTls &&
          other.prefix == this.prefix &&
          other.enabled == this.enabled &&
          other.description == this.description &&
          other.settings == this.settings &&
          other.cloudNodeId == this.cloudNodeId &&
          other.locationId == this.locationId &&
          other.createdAt == this.createdAt);
}

class NetworksCompanion extends UpdateCompanion<NetworkRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> protocol;
  final Value<String> host;
  final Value<int> port;
  final Value<String?> username;
  final Value<String?> password;
  final Value<bool> useTls;
  final Value<String> prefix;
  final Value<bool> enabled;
  final Value<String?> description;
  final Value<String> settings;
  final Value<String?> cloudNodeId;
  final Value<String?> locationId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const NetworksCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.protocol = const Value.absent(),
    this.host = const Value.absent(),
    this.port = const Value.absent(),
    this.username = const Value.absent(),
    this.password = const Value.absent(),
    this.useTls = const Value.absent(),
    this.prefix = const Value.absent(),
    this.enabled = const Value.absent(),
    this.description = const Value.absent(),
    this.settings = const Value.absent(),
    this.cloudNodeId = const Value.absent(),
    this.locationId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NetworksCompanion.insert({
    required String id,
    required String name,
    this.protocol = const Value.absent(),
    required String host,
    this.port = const Value.absent(),
    this.username = const Value.absent(),
    this.password = const Value.absent(),
    this.useTls = const Value.absent(),
    this.prefix = const Value.absent(),
    this.enabled = const Value.absent(),
    this.description = const Value.absent(),
    this.settings = const Value.absent(),
    this.cloudNodeId = const Value.absent(),
    this.locationId = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       host = Value(host),
       createdAt = Value(createdAt);
  static Insertable<NetworkRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? protocol,
    Expression<String>? host,
    Expression<int>? port,
    Expression<String>? username,
    Expression<String>? password,
    Expression<bool>? useTls,
    Expression<String>? prefix,
    Expression<bool>? enabled,
    Expression<String>? description,
    Expression<String>? settings,
    Expression<String>? cloudNodeId,
    Expression<String>? locationId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (protocol != null) 'protocol': protocol,
      if (host != null) 'host': host,
      if (port != null) 'port': port,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
      if (useTls != null) 'use_tls': useTls,
      if (prefix != null) 'prefix': prefix,
      if (enabled != null) 'enabled': enabled,
      if (description != null) 'description': description,
      if (settings != null) 'settings': settings,
      if (cloudNodeId != null) 'cloud_node_id': cloudNodeId,
      if (locationId != null) 'location_id': locationId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NetworksCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? protocol,
    Value<String>? host,
    Value<int>? port,
    Value<String?>? username,
    Value<String?>? password,
    Value<bool>? useTls,
    Value<String>? prefix,
    Value<bool>? enabled,
    Value<String?>? description,
    Value<String>? settings,
    Value<String?>? cloudNodeId,
    Value<String?>? locationId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return NetworksCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      protocol: protocol ?? this.protocol,
      host: host ?? this.host,
      port: port ?? this.port,
      username: username ?? this.username,
      password: password ?? this.password,
      useTls: useTls ?? this.useTls,
      prefix: prefix ?? this.prefix,
      enabled: enabled ?? this.enabled,
      description: description ?? this.description,
      settings: settings ?? this.settings,
      cloudNodeId: cloudNodeId ?? this.cloudNodeId,
      locationId: locationId ?? this.locationId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (protocol.present) {
      map['protocol'] = Variable<String>(protocol.value);
    }
    if (host.present) {
      map['host'] = Variable<String>(host.value);
    }
    if (port.present) {
      map['port'] = Variable<int>(port.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (useTls.present) {
      map['use_tls'] = Variable<bool>(useTls.value);
    }
    if (prefix.present) {
      map['prefix'] = Variable<String>(prefix.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (settings.present) {
      map['settings'] = Variable<String>(settings.value);
    }
    if (cloudNodeId.present) {
      map['cloud_node_id'] = Variable<String>(cloudNodeId.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<String>(locationId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NetworksCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('protocol: $protocol, ')
          ..write('host: $host, ')
          ..write('port: $port, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('useTls: $useTls, ')
          ..write('prefix: $prefix, ')
          ..write('enabled: $enabled, ')
          ..write('description: $description, ')
          ..write('settings: $settings, ')
          ..write('cloudNodeId: $cloudNodeId, ')
          ..write('locationId: $locationId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DevicesTable extends Devices with TableInfo<$DevicesTable, DeviceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DevicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _networkIdMeta = const VerificationMeta(
    'networkId',
  );
  @override
  late final GeneratedColumn<String> networkId = GeneratedColumn<String>(
    'network_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES networks (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _topicPrefixMeta = const VerificationMeta(
    'topicPrefix',
  );
  @override
  late final GeneratedColumn<String> topicPrefix = GeneratedColumn<String>(
    'topic_prefix',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _hostMeta = const VerificationMeta('host');
  @override
  late final GeneratedColumn<String> host = GeneratedColumn<String>(
    'host',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _portMeta = const VerificationMeta('port');
  @override
  late final GeneratedColumn<int> port = GeneratedColumn<int>(
    'port',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serialPortMeta = const VerificationMeta(
    'serialPort',
  );
  @override
  late final GeneratedColumn<String> serialPort = GeneratedColumn<String>(
    'serial_port',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _baudRateMeta = const VerificationMeta(
    'baudRate',
  );
  @override
  late final GeneratedColumn<int> baudRate = GeneratedColumn<int>(
    'baud_rate',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _passwordMeta = const VerificationMeta(
    'password',
  );
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
    'password',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> tags =
      GeneratedColumn<String>(
        'tags',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<String>>($DevicesTable.$convertertags);
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
  metadata = GeneratedColumn<String>(
    'metadata',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  ).withConverter<Map<String, dynamic>>($DevicesTable.$convertermetadata);
  static const VerificationMeta _cloudNodeIdMeta = const VerificationMeta(
    'cloudNodeId',
  );
  @override
  late final GeneratedColumn<String> cloudNodeId = GeneratedColumn<String>(
    'cloud_node_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    networkId,
    name,
    type,
    topicPrefix,
    host,
    port,
    serialPort,
    baudRate,
    username,
    password,
    description,
    tags,
    metadata,
    cloudNodeId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'devices';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeviceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('network_id')) {
      context.handle(
        _networkIdMeta,
        networkId.isAcceptableOrUnknown(data['network_id']!, _networkIdMeta),
      );
    } else if (isInserting) {
      context.missing(_networkIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('topic_prefix')) {
      context.handle(
        _topicPrefixMeta,
        topicPrefix.isAcceptableOrUnknown(
          data['topic_prefix']!,
          _topicPrefixMeta,
        ),
      );
    }
    if (data.containsKey('host')) {
      context.handle(
        _hostMeta,
        host.isAcceptableOrUnknown(data['host']!, _hostMeta),
      );
    }
    if (data.containsKey('port')) {
      context.handle(
        _portMeta,
        port.isAcceptableOrUnknown(data['port']!, _portMeta),
      );
    }
    if (data.containsKey('serial_port')) {
      context.handle(
        _serialPortMeta,
        serialPort.isAcceptableOrUnknown(data['serial_port']!, _serialPortMeta),
      );
    }
    if (data.containsKey('baud_rate')) {
      context.handle(
        _baudRateMeta,
        baudRate.isAcceptableOrUnknown(data['baud_rate']!, _baudRateMeta),
      );
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    }
    if (data.containsKey('password')) {
      context.handle(
        _passwordMeta,
        password.isAcceptableOrUnknown(data['password']!, _passwordMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('cloud_node_id')) {
      context.handle(
        _cloudNodeIdMeta,
        cloudNodeId.isAcceptableOrUnknown(
          data['cloud_node_id']!,
          _cloudNodeIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DeviceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeviceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      networkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}network_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      ),
      topicPrefix: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic_prefix'],
      )!,
      host: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}host'],
      ),
      port: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}port'],
      ),
      serialPort: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serial_port'],
      ),
      baudRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}baud_rate'],
      ),
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      ),
      password: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      tags: $DevicesTable.$convertertags.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tags'],
        )!,
      ),
      metadata: $DevicesTable.$convertermetadata.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}metadata'],
        )!,
      ),
      cloudNodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cloud_node_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DevicesTable createAlias(String alias) {
    return $DevicesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $convertertags =
      const StringListConverter();
  static TypeConverter<Map<String, dynamic>, String> $convertermetadata =
      const JsonMapConverter();
}

class DeviceRow extends DataClass implements Insertable<DeviceRow> {
  final String id;
  final String networkId;
  final String name;
  final String? type;
  final String topicPrefix;
  final String? host;
  final int? port;
  final String? serialPort;
  final int? baudRate;
  final String? username;
  final String? password;
  final String? description;
  final List<String> tags;
  final Map<String, dynamic> metadata;

  /// Cloud sync: Rubix cloud node ID (null = not synced).
  final String? cloudNodeId;
  final DateTime createdAt;
  const DeviceRow({
    required this.id,
    required this.networkId,
    required this.name,
    this.type,
    required this.topicPrefix,
    this.host,
    this.port,
    this.serialPort,
    this.baudRate,
    this.username,
    this.password,
    this.description,
    required this.tags,
    required this.metadata,
    this.cloudNodeId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['network_id'] = Variable<String>(networkId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    map['topic_prefix'] = Variable<String>(topicPrefix);
    if (!nullToAbsent || host != null) {
      map['host'] = Variable<String>(host);
    }
    if (!nullToAbsent || port != null) {
      map['port'] = Variable<int>(port);
    }
    if (!nullToAbsent || serialPort != null) {
      map['serial_port'] = Variable<String>(serialPort);
    }
    if (!nullToAbsent || baudRate != null) {
      map['baud_rate'] = Variable<int>(baudRate);
    }
    if (!nullToAbsent || username != null) {
      map['username'] = Variable<String>(username);
    }
    if (!nullToAbsent || password != null) {
      map['password'] = Variable<String>(password);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    {
      map['tags'] = Variable<String>($DevicesTable.$convertertags.toSql(tags));
    }
    {
      map['metadata'] = Variable<String>(
        $DevicesTable.$convertermetadata.toSql(metadata),
      );
    }
    if (!nullToAbsent || cloudNodeId != null) {
      map['cloud_node_id'] = Variable<String>(cloudNodeId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DevicesCompanion toCompanion(bool nullToAbsent) {
    return DevicesCompanion(
      id: Value(id),
      networkId: Value(networkId),
      name: Value(name),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      topicPrefix: Value(topicPrefix),
      host: host == null && nullToAbsent ? const Value.absent() : Value(host),
      port: port == null && nullToAbsent ? const Value.absent() : Value(port),
      serialPort: serialPort == null && nullToAbsent
          ? const Value.absent()
          : Value(serialPort),
      baudRate: baudRate == null && nullToAbsent
          ? const Value.absent()
          : Value(baudRate),
      username: username == null && nullToAbsent
          ? const Value.absent()
          : Value(username),
      password: password == null && nullToAbsent
          ? const Value.absent()
          : Value(password),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      tags: Value(tags),
      metadata: Value(metadata),
      cloudNodeId: cloudNodeId == null && nullToAbsent
          ? const Value.absent()
          : Value(cloudNodeId),
      createdAt: Value(createdAt),
    );
  }

  factory DeviceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeviceRow(
      id: serializer.fromJson<String>(json['id']),
      networkId: serializer.fromJson<String>(json['networkId']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String?>(json['type']),
      topicPrefix: serializer.fromJson<String>(json['topicPrefix']),
      host: serializer.fromJson<String?>(json['host']),
      port: serializer.fromJson<int?>(json['port']),
      serialPort: serializer.fromJson<String?>(json['serialPort']),
      baudRate: serializer.fromJson<int?>(json['baudRate']),
      username: serializer.fromJson<String?>(json['username']),
      password: serializer.fromJson<String?>(json['password']),
      description: serializer.fromJson<String?>(json['description']),
      tags: serializer.fromJson<List<String>>(json['tags']),
      metadata: serializer.fromJson<Map<String, dynamic>>(json['metadata']),
      cloudNodeId: serializer.fromJson<String?>(json['cloudNodeId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'networkId': serializer.toJson<String>(networkId),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String?>(type),
      'topicPrefix': serializer.toJson<String>(topicPrefix),
      'host': serializer.toJson<String?>(host),
      'port': serializer.toJson<int?>(port),
      'serialPort': serializer.toJson<String?>(serialPort),
      'baudRate': serializer.toJson<int?>(baudRate),
      'username': serializer.toJson<String?>(username),
      'password': serializer.toJson<String?>(password),
      'description': serializer.toJson<String?>(description),
      'tags': serializer.toJson<List<String>>(tags),
      'metadata': serializer.toJson<Map<String, dynamic>>(metadata),
      'cloudNodeId': serializer.toJson<String?>(cloudNodeId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DeviceRow copyWith({
    String? id,
    String? networkId,
    String? name,
    Value<String?> type = const Value.absent(),
    String? topicPrefix,
    Value<String?> host = const Value.absent(),
    Value<int?> port = const Value.absent(),
    Value<String?> serialPort = const Value.absent(),
    Value<int?> baudRate = const Value.absent(),
    Value<String?> username = const Value.absent(),
    Value<String?> password = const Value.absent(),
    Value<String?> description = const Value.absent(),
    List<String>? tags,
    Map<String, dynamic>? metadata,
    Value<String?> cloudNodeId = const Value.absent(),
    DateTime? createdAt,
  }) => DeviceRow(
    id: id ?? this.id,
    networkId: networkId ?? this.networkId,
    name: name ?? this.name,
    type: type.present ? type.value : this.type,
    topicPrefix: topicPrefix ?? this.topicPrefix,
    host: host.present ? host.value : this.host,
    port: port.present ? port.value : this.port,
    serialPort: serialPort.present ? serialPort.value : this.serialPort,
    baudRate: baudRate.present ? baudRate.value : this.baudRate,
    username: username.present ? username.value : this.username,
    password: password.present ? password.value : this.password,
    description: description.present ? description.value : this.description,
    tags: tags ?? this.tags,
    metadata: metadata ?? this.metadata,
    cloudNodeId: cloudNodeId.present ? cloudNodeId.value : this.cloudNodeId,
    createdAt: createdAt ?? this.createdAt,
  );
  DeviceRow copyWithCompanion(DevicesCompanion data) {
    return DeviceRow(
      id: data.id.present ? data.id.value : this.id,
      networkId: data.networkId.present ? data.networkId.value : this.networkId,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      topicPrefix: data.topicPrefix.present
          ? data.topicPrefix.value
          : this.topicPrefix,
      host: data.host.present ? data.host.value : this.host,
      port: data.port.present ? data.port.value : this.port,
      serialPort: data.serialPort.present
          ? data.serialPort.value
          : this.serialPort,
      baudRate: data.baudRate.present ? data.baudRate.value : this.baudRate,
      username: data.username.present ? data.username.value : this.username,
      password: data.password.present ? data.password.value : this.password,
      description: data.description.present
          ? data.description.value
          : this.description,
      tags: data.tags.present ? data.tags.value : this.tags,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      cloudNodeId: data.cloudNodeId.present
          ? data.cloudNodeId.value
          : this.cloudNodeId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeviceRow(')
          ..write('id: $id, ')
          ..write('networkId: $networkId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('topicPrefix: $topicPrefix, ')
          ..write('host: $host, ')
          ..write('port: $port, ')
          ..write('serialPort: $serialPort, ')
          ..write('baudRate: $baudRate, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('description: $description, ')
          ..write('tags: $tags, ')
          ..write('metadata: $metadata, ')
          ..write('cloudNodeId: $cloudNodeId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    networkId,
    name,
    type,
    topicPrefix,
    host,
    port,
    serialPort,
    baudRate,
    username,
    password,
    description,
    tags,
    metadata,
    cloudNodeId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeviceRow &&
          other.id == this.id &&
          other.networkId == this.networkId &&
          other.name == this.name &&
          other.type == this.type &&
          other.topicPrefix == this.topicPrefix &&
          other.host == this.host &&
          other.port == this.port &&
          other.serialPort == this.serialPort &&
          other.baudRate == this.baudRate &&
          other.username == this.username &&
          other.password == this.password &&
          other.description == this.description &&
          other.tags == this.tags &&
          other.metadata == this.metadata &&
          other.cloudNodeId == this.cloudNodeId &&
          other.createdAt == this.createdAt);
}

class DevicesCompanion extends UpdateCompanion<DeviceRow> {
  final Value<String> id;
  final Value<String> networkId;
  final Value<String> name;
  final Value<String?> type;
  final Value<String> topicPrefix;
  final Value<String?> host;
  final Value<int?> port;
  final Value<String?> serialPort;
  final Value<int?> baudRate;
  final Value<String?> username;
  final Value<String?> password;
  final Value<String?> description;
  final Value<List<String>> tags;
  final Value<Map<String, dynamic>> metadata;
  final Value<String?> cloudNodeId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const DevicesCompanion({
    this.id = const Value.absent(),
    this.networkId = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.topicPrefix = const Value.absent(),
    this.host = const Value.absent(),
    this.port = const Value.absent(),
    this.serialPort = const Value.absent(),
    this.baudRate = const Value.absent(),
    this.username = const Value.absent(),
    this.password = const Value.absent(),
    this.description = const Value.absent(),
    this.tags = const Value.absent(),
    this.metadata = const Value.absent(),
    this.cloudNodeId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DevicesCompanion.insert({
    required String id,
    required String networkId,
    required String name,
    this.type = const Value.absent(),
    this.topicPrefix = const Value.absent(),
    this.host = const Value.absent(),
    this.port = const Value.absent(),
    this.serialPort = const Value.absent(),
    this.baudRate = const Value.absent(),
    this.username = const Value.absent(),
    this.password = const Value.absent(),
    this.description = const Value.absent(),
    this.tags = const Value.absent(),
    this.metadata = const Value.absent(),
    this.cloudNodeId = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       networkId = Value(networkId),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<DeviceRow> custom({
    Expression<String>? id,
    Expression<String>? networkId,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? topicPrefix,
    Expression<String>? host,
    Expression<int>? port,
    Expression<String>? serialPort,
    Expression<int>? baudRate,
    Expression<String>? username,
    Expression<String>? password,
    Expression<String>? description,
    Expression<String>? tags,
    Expression<String>? metadata,
    Expression<String>? cloudNodeId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (networkId != null) 'network_id': networkId,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (topicPrefix != null) 'topic_prefix': topicPrefix,
      if (host != null) 'host': host,
      if (port != null) 'port': port,
      if (serialPort != null) 'serial_port': serialPort,
      if (baudRate != null) 'baud_rate': baudRate,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
      if (description != null) 'description': description,
      if (tags != null) 'tags': tags,
      if (metadata != null) 'metadata': metadata,
      if (cloudNodeId != null) 'cloud_node_id': cloudNodeId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DevicesCompanion copyWith({
    Value<String>? id,
    Value<String>? networkId,
    Value<String>? name,
    Value<String?>? type,
    Value<String>? topicPrefix,
    Value<String?>? host,
    Value<int?>? port,
    Value<String?>? serialPort,
    Value<int?>? baudRate,
    Value<String?>? username,
    Value<String?>? password,
    Value<String?>? description,
    Value<List<String>>? tags,
    Value<Map<String, dynamic>>? metadata,
    Value<String?>? cloudNodeId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return DevicesCompanion(
      id: id ?? this.id,
      networkId: networkId ?? this.networkId,
      name: name ?? this.name,
      type: type ?? this.type,
      topicPrefix: topicPrefix ?? this.topicPrefix,
      host: host ?? this.host,
      port: port ?? this.port,
      serialPort: serialPort ?? this.serialPort,
      baudRate: baudRate ?? this.baudRate,
      username: username ?? this.username,
      password: password ?? this.password,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      metadata: metadata ?? this.metadata,
      cloudNodeId: cloudNodeId ?? this.cloudNodeId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (networkId.present) {
      map['network_id'] = Variable<String>(networkId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (topicPrefix.present) {
      map['topic_prefix'] = Variable<String>(topicPrefix.value);
    }
    if (host.present) {
      map['host'] = Variable<String>(host.value);
    }
    if (port.present) {
      map['port'] = Variable<int>(port.value);
    }
    if (serialPort.present) {
      map['serial_port'] = Variable<String>(serialPort.value);
    }
    if (baudRate.present) {
      map['baud_rate'] = Variable<int>(baudRate.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(
        $DevicesTable.$convertertags.toSql(tags.value),
      );
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(
        $DevicesTable.$convertermetadata.toSql(metadata.value),
      );
    }
    if (cloudNodeId.present) {
      map['cloud_node_id'] = Variable<String>(cloudNodeId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DevicesCompanion(')
          ..write('id: $id, ')
          ..write('networkId: $networkId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('topicPrefix: $topicPrefix, ')
          ..write('host: $host, ')
          ..write('port: $port, ')
          ..write('serialPort: $serialPort, ')
          ..write('baudRate: $baudRate, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('description: $description, ')
          ..write('tags: $tags, ')
          ..write('metadata: $metadata, ')
          ..write('cloudNodeId: $cloudNodeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PointsTable extends Points with TableInfo<$PointsTable, PointRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES devices (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topicMeta = const VerificationMeta('topic');
  @override
  late final GeneratedColumn<String> topic = GeneratedColumn<String>(
    'topic',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueTypeMeta = const VerificationMeta(
    'valueType',
  );
  @override
  late final GeneratedColumn<String> valueType = GeneratedColumn<String>(
    'value_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('number'),
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('rw'),
  );
  static const VerificationMeta _minMeta = const VerificationMeta('min');
  @override
  late final GeneratedColumn<double> min = GeneratedColumn<double>(
    'min',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxMeta = const VerificationMeta('max');
  @override
  late final GeneratedColumn<double> max = GeneratedColumn<double>(
    'max',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _writeWidgetMeta = const VerificationMeta(
    'writeWidget',
  );
  @override
  late final GeneratedColumn<String> writeWidget = GeneratedColumn<String>(
    'write_widget',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('numberInput'),
  );
  static const VerificationMeta _readStrategyMeta = const VerificationMeta(
    'readStrategy',
  );
  @override
  late final GeneratedColumn<String> readStrategy = GeneratedColumn<String>(
    'read_strategy',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('sub'),
  );
  static const VerificationMeta _pollIntervalSecsMeta = const VerificationMeta(
    'pollIntervalSecs',
  );
  @override
  late final GeneratedColumn<int> pollIntervalSecs = GeneratedColumn<int>(
    'poll_interval_secs',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  static const VerificationMeta _historyTypeMeta = const VerificationMeta(
    'historyType',
  );
  @override
  late final GeneratedColumn<String> historyType = GeneratedColumn<String>(
    'history_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _covThresholdMeta = const VerificationMeta(
    'covThreshold',
  );
  @override
  late final GeneratedColumn<double> covThreshold = GeneratedColumn<double>(
    'cov_threshold',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _historyIntervalSecsMeta =
      const VerificationMeta('historyIntervalSecs');
  @override
  late final GeneratedColumn<int> historyIntervalSecs = GeneratedColumn<int>(
    'history_interval_secs',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(300),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    deviceId,
    name,
    topic,
    valueType,
    mode,
    min,
    max,
    unit,
    writeWidget,
    readStrategy,
    pollIntervalSecs,
    historyType,
    covThreshold,
    historyIntervalSecs,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'points';
  @override
  VerificationContext validateIntegrity(
    Insertable<PointRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('topic')) {
      context.handle(
        _topicMeta,
        topic.isAcceptableOrUnknown(data['topic']!, _topicMeta),
      );
    } else if (isInserting) {
      context.missing(_topicMeta);
    }
    if (data.containsKey('value_type')) {
      context.handle(
        _valueTypeMeta,
        valueType.isAcceptableOrUnknown(data['value_type']!, _valueTypeMeta),
      );
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    }
    if (data.containsKey('min')) {
      context.handle(
        _minMeta,
        min.isAcceptableOrUnknown(data['min']!, _minMeta),
      );
    }
    if (data.containsKey('max')) {
      context.handle(
        _maxMeta,
        max.isAcceptableOrUnknown(data['max']!, _maxMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('write_widget')) {
      context.handle(
        _writeWidgetMeta,
        writeWidget.isAcceptableOrUnknown(
          data['write_widget']!,
          _writeWidgetMeta,
        ),
      );
    }
    if (data.containsKey('read_strategy')) {
      context.handle(
        _readStrategyMeta,
        readStrategy.isAcceptableOrUnknown(
          data['read_strategy']!,
          _readStrategyMeta,
        ),
      );
    }
    if (data.containsKey('poll_interval_secs')) {
      context.handle(
        _pollIntervalSecsMeta,
        pollIntervalSecs.isAcceptableOrUnknown(
          data['poll_interval_secs']!,
          _pollIntervalSecsMeta,
        ),
      );
    }
    if (data.containsKey('history_type')) {
      context.handle(
        _historyTypeMeta,
        historyType.isAcceptableOrUnknown(
          data['history_type']!,
          _historyTypeMeta,
        ),
      );
    }
    if (data.containsKey('cov_threshold')) {
      context.handle(
        _covThresholdMeta,
        covThreshold.isAcceptableOrUnknown(
          data['cov_threshold']!,
          _covThresholdMeta,
        ),
      );
    }
    if (data.containsKey('history_interval_secs')) {
      context.handle(
        _historyIntervalSecsMeta,
        historyIntervalSecs.isAcceptableOrUnknown(
          data['history_interval_secs']!,
          _historyIntervalSecsMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PointRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PointRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      topic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic'],
      )!,
      valueType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value_type'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      )!,
      min: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}min'],
      ),
      max: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      ),
      writeWidget: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}write_widget'],
      )!,
      readStrategy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}read_strategy'],
      )!,
      pollIntervalSecs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}poll_interval_secs'],
      )!,
      historyType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}history_type'],
      )!,
      covThreshold: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cov_threshold'],
      ),
      historyIntervalSecs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}history_interval_secs'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PointsTable createAlias(String alias) {
    return $PointsTable(attachedDatabase, alias);
  }
}

class PointRow extends DataClass implements Insertable<PointRow> {
  final String id;
  final String deviceId;
  final String name;
  final String topic;
  final String valueType;
  final String mode;
  final double? min;
  final double? max;
  final String? unit;

  /// Widget used for writing values: toggle, slider, numberInput, textInput
  final String writeWidget;
  final String readStrategy;
  final int pollIntervalSecs;

  /// History recording: none, cov, cron
  final String historyType;

  /// COV threshold — record when value changes by more than this amount.
  final double? covThreshold;

  /// Cron interval in seconds (60, 300, 900 = 1m, 5m, 15m).
  final int historyIntervalSecs;
  final DateTime createdAt;
  const PointRow({
    required this.id,
    required this.deviceId,
    required this.name,
    required this.topic,
    required this.valueType,
    required this.mode,
    this.min,
    this.max,
    this.unit,
    required this.writeWidget,
    required this.readStrategy,
    required this.pollIntervalSecs,
    required this.historyType,
    this.covThreshold,
    required this.historyIntervalSecs,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['device_id'] = Variable<String>(deviceId);
    map['name'] = Variable<String>(name);
    map['topic'] = Variable<String>(topic);
    map['value_type'] = Variable<String>(valueType);
    map['mode'] = Variable<String>(mode);
    if (!nullToAbsent || min != null) {
      map['min'] = Variable<double>(min);
    }
    if (!nullToAbsent || max != null) {
      map['max'] = Variable<double>(max);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    map['write_widget'] = Variable<String>(writeWidget);
    map['read_strategy'] = Variable<String>(readStrategy);
    map['poll_interval_secs'] = Variable<int>(pollIntervalSecs);
    map['history_type'] = Variable<String>(historyType);
    if (!nullToAbsent || covThreshold != null) {
      map['cov_threshold'] = Variable<double>(covThreshold);
    }
    map['history_interval_secs'] = Variable<int>(historyIntervalSecs);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PointsCompanion toCompanion(bool nullToAbsent) {
    return PointsCompanion(
      id: Value(id),
      deviceId: Value(deviceId),
      name: Value(name),
      topic: Value(topic),
      valueType: Value(valueType),
      mode: Value(mode),
      min: min == null && nullToAbsent ? const Value.absent() : Value(min),
      max: max == null && nullToAbsent ? const Value.absent() : Value(max),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      writeWidget: Value(writeWidget),
      readStrategy: Value(readStrategy),
      pollIntervalSecs: Value(pollIntervalSecs),
      historyType: Value(historyType),
      covThreshold: covThreshold == null && nullToAbsent
          ? const Value.absent()
          : Value(covThreshold),
      historyIntervalSecs: Value(historyIntervalSecs),
      createdAt: Value(createdAt),
    );
  }

  factory PointRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PointRow(
      id: serializer.fromJson<String>(json['id']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      name: serializer.fromJson<String>(json['name']),
      topic: serializer.fromJson<String>(json['topic']),
      valueType: serializer.fromJson<String>(json['valueType']),
      mode: serializer.fromJson<String>(json['mode']),
      min: serializer.fromJson<double?>(json['min']),
      max: serializer.fromJson<double?>(json['max']),
      unit: serializer.fromJson<String?>(json['unit']),
      writeWidget: serializer.fromJson<String>(json['writeWidget']),
      readStrategy: serializer.fromJson<String>(json['readStrategy']),
      pollIntervalSecs: serializer.fromJson<int>(json['pollIntervalSecs']),
      historyType: serializer.fromJson<String>(json['historyType']),
      covThreshold: serializer.fromJson<double?>(json['covThreshold']),
      historyIntervalSecs: serializer.fromJson<int>(
        json['historyIntervalSecs'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'deviceId': serializer.toJson<String>(deviceId),
      'name': serializer.toJson<String>(name),
      'topic': serializer.toJson<String>(topic),
      'valueType': serializer.toJson<String>(valueType),
      'mode': serializer.toJson<String>(mode),
      'min': serializer.toJson<double?>(min),
      'max': serializer.toJson<double?>(max),
      'unit': serializer.toJson<String?>(unit),
      'writeWidget': serializer.toJson<String>(writeWidget),
      'readStrategy': serializer.toJson<String>(readStrategy),
      'pollIntervalSecs': serializer.toJson<int>(pollIntervalSecs),
      'historyType': serializer.toJson<String>(historyType),
      'covThreshold': serializer.toJson<double?>(covThreshold),
      'historyIntervalSecs': serializer.toJson<int>(historyIntervalSecs),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PointRow copyWith({
    String? id,
    String? deviceId,
    String? name,
    String? topic,
    String? valueType,
    String? mode,
    Value<double?> min = const Value.absent(),
    Value<double?> max = const Value.absent(),
    Value<String?> unit = const Value.absent(),
    String? writeWidget,
    String? readStrategy,
    int? pollIntervalSecs,
    String? historyType,
    Value<double?> covThreshold = const Value.absent(),
    int? historyIntervalSecs,
    DateTime? createdAt,
  }) => PointRow(
    id: id ?? this.id,
    deviceId: deviceId ?? this.deviceId,
    name: name ?? this.name,
    topic: topic ?? this.topic,
    valueType: valueType ?? this.valueType,
    mode: mode ?? this.mode,
    min: min.present ? min.value : this.min,
    max: max.present ? max.value : this.max,
    unit: unit.present ? unit.value : this.unit,
    writeWidget: writeWidget ?? this.writeWidget,
    readStrategy: readStrategy ?? this.readStrategy,
    pollIntervalSecs: pollIntervalSecs ?? this.pollIntervalSecs,
    historyType: historyType ?? this.historyType,
    covThreshold: covThreshold.present ? covThreshold.value : this.covThreshold,
    historyIntervalSecs: historyIntervalSecs ?? this.historyIntervalSecs,
    createdAt: createdAt ?? this.createdAt,
  );
  PointRow copyWithCompanion(PointsCompanion data) {
    return PointRow(
      id: data.id.present ? data.id.value : this.id,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      name: data.name.present ? data.name.value : this.name,
      topic: data.topic.present ? data.topic.value : this.topic,
      valueType: data.valueType.present ? data.valueType.value : this.valueType,
      mode: data.mode.present ? data.mode.value : this.mode,
      min: data.min.present ? data.min.value : this.min,
      max: data.max.present ? data.max.value : this.max,
      unit: data.unit.present ? data.unit.value : this.unit,
      writeWidget: data.writeWidget.present
          ? data.writeWidget.value
          : this.writeWidget,
      readStrategy: data.readStrategy.present
          ? data.readStrategy.value
          : this.readStrategy,
      pollIntervalSecs: data.pollIntervalSecs.present
          ? data.pollIntervalSecs.value
          : this.pollIntervalSecs,
      historyType: data.historyType.present
          ? data.historyType.value
          : this.historyType,
      covThreshold: data.covThreshold.present
          ? data.covThreshold.value
          : this.covThreshold,
      historyIntervalSecs: data.historyIntervalSecs.present
          ? data.historyIntervalSecs.value
          : this.historyIntervalSecs,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PointRow(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('name: $name, ')
          ..write('topic: $topic, ')
          ..write('valueType: $valueType, ')
          ..write('mode: $mode, ')
          ..write('min: $min, ')
          ..write('max: $max, ')
          ..write('unit: $unit, ')
          ..write('writeWidget: $writeWidget, ')
          ..write('readStrategy: $readStrategy, ')
          ..write('pollIntervalSecs: $pollIntervalSecs, ')
          ..write('historyType: $historyType, ')
          ..write('covThreshold: $covThreshold, ')
          ..write('historyIntervalSecs: $historyIntervalSecs, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    deviceId,
    name,
    topic,
    valueType,
    mode,
    min,
    max,
    unit,
    writeWidget,
    readStrategy,
    pollIntervalSecs,
    historyType,
    covThreshold,
    historyIntervalSecs,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PointRow &&
          other.id == this.id &&
          other.deviceId == this.deviceId &&
          other.name == this.name &&
          other.topic == this.topic &&
          other.valueType == this.valueType &&
          other.mode == this.mode &&
          other.min == this.min &&
          other.max == this.max &&
          other.unit == this.unit &&
          other.writeWidget == this.writeWidget &&
          other.readStrategy == this.readStrategy &&
          other.pollIntervalSecs == this.pollIntervalSecs &&
          other.historyType == this.historyType &&
          other.covThreshold == this.covThreshold &&
          other.historyIntervalSecs == this.historyIntervalSecs &&
          other.createdAt == this.createdAt);
}

class PointsCompanion extends UpdateCompanion<PointRow> {
  final Value<String> id;
  final Value<String> deviceId;
  final Value<String> name;
  final Value<String> topic;
  final Value<String> valueType;
  final Value<String> mode;
  final Value<double?> min;
  final Value<double?> max;
  final Value<String?> unit;
  final Value<String> writeWidget;
  final Value<String> readStrategy;
  final Value<int> pollIntervalSecs;
  final Value<String> historyType;
  final Value<double?> covThreshold;
  final Value<int> historyIntervalSecs;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PointsCompanion({
    this.id = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.name = const Value.absent(),
    this.topic = const Value.absent(),
    this.valueType = const Value.absent(),
    this.mode = const Value.absent(),
    this.min = const Value.absent(),
    this.max = const Value.absent(),
    this.unit = const Value.absent(),
    this.writeWidget = const Value.absent(),
    this.readStrategy = const Value.absent(),
    this.pollIntervalSecs = const Value.absent(),
    this.historyType = const Value.absent(),
    this.covThreshold = const Value.absent(),
    this.historyIntervalSecs = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PointsCompanion.insert({
    required String id,
    required String deviceId,
    required String name,
    required String topic,
    this.valueType = const Value.absent(),
    this.mode = const Value.absent(),
    this.min = const Value.absent(),
    this.max = const Value.absent(),
    this.unit = const Value.absent(),
    this.writeWidget = const Value.absent(),
    this.readStrategy = const Value.absent(),
    this.pollIntervalSecs = const Value.absent(),
    this.historyType = const Value.absent(),
    this.covThreshold = const Value.absent(),
    this.historyIntervalSecs = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       deviceId = Value(deviceId),
       name = Value(name),
       topic = Value(topic),
       createdAt = Value(createdAt);
  static Insertable<PointRow> custom({
    Expression<String>? id,
    Expression<String>? deviceId,
    Expression<String>? name,
    Expression<String>? topic,
    Expression<String>? valueType,
    Expression<String>? mode,
    Expression<double>? min,
    Expression<double>? max,
    Expression<String>? unit,
    Expression<String>? writeWidget,
    Expression<String>? readStrategy,
    Expression<int>? pollIntervalSecs,
    Expression<String>? historyType,
    Expression<double>? covThreshold,
    Expression<int>? historyIntervalSecs,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deviceId != null) 'device_id': deviceId,
      if (name != null) 'name': name,
      if (topic != null) 'topic': topic,
      if (valueType != null) 'value_type': valueType,
      if (mode != null) 'mode': mode,
      if (min != null) 'min': min,
      if (max != null) 'max': max,
      if (unit != null) 'unit': unit,
      if (writeWidget != null) 'write_widget': writeWidget,
      if (readStrategy != null) 'read_strategy': readStrategy,
      if (pollIntervalSecs != null) 'poll_interval_secs': pollIntervalSecs,
      if (historyType != null) 'history_type': historyType,
      if (covThreshold != null) 'cov_threshold': covThreshold,
      if (historyIntervalSecs != null)
        'history_interval_secs': historyIntervalSecs,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PointsCompanion copyWith({
    Value<String>? id,
    Value<String>? deviceId,
    Value<String>? name,
    Value<String>? topic,
    Value<String>? valueType,
    Value<String>? mode,
    Value<double?>? min,
    Value<double?>? max,
    Value<String?>? unit,
    Value<String>? writeWidget,
    Value<String>? readStrategy,
    Value<int>? pollIntervalSecs,
    Value<String>? historyType,
    Value<double?>? covThreshold,
    Value<int>? historyIntervalSecs,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PointsCompanion(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      name: name ?? this.name,
      topic: topic ?? this.topic,
      valueType: valueType ?? this.valueType,
      mode: mode ?? this.mode,
      min: min ?? this.min,
      max: max ?? this.max,
      unit: unit ?? this.unit,
      writeWidget: writeWidget ?? this.writeWidget,
      readStrategy: readStrategy ?? this.readStrategy,
      pollIntervalSecs: pollIntervalSecs ?? this.pollIntervalSecs,
      historyType: historyType ?? this.historyType,
      covThreshold: covThreshold ?? this.covThreshold,
      historyIntervalSecs: historyIntervalSecs ?? this.historyIntervalSecs,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (topic.present) {
      map['topic'] = Variable<String>(topic.value);
    }
    if (valueType.present) {
      map['value_type'] = Variable<String>(valueType.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (min.present) {
      map['min'] = Variable<double>(min.value);
    }
    if (max.present) {
      map['max'] = Variable<double>(max.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (writeWidget.present) {
      map['write_widget'] = Variable<String>(writeWidget.value);
    }
    if (readStrategy.present) {
      map['read_strategy'] = Variable<String>(readStrategy.value);
    }
    if (pollIntervalSecs.present) {
      map['poll_interval_secs'] = Variable<int>(pollIntervalSecs.value);
    }
    if (historyType.present) {
      map['history_type'] = Variable<String>(historyType.value);
    }
    if (covThreshold.present) {
      map['cov_threshold'] = Variable<double>(covThreshold.value);
    }
    if (historyIntervalSecs.present) {
      map['history_interval_secs'] = Variable<int>(historyIntervalSecs.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PointsCompanion(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('name: $name, ')
          ..write('topic: $topic, ')
          ..write('valueType: $valueType, ')
          ..write('mode: $mode, ')
          ..write('min: $min, ')
          ..write('max: $max, ')
          ..write('unit: $unit, ')
          ..write('writeWidget: $writeWidget, ')
          ..write('readStrategy: $readStrategy, ')
          ..write('pollIntervalSecs: $pollIntervalSecs, ')
          ..write('historyType: $historyType, ')
          ..write('covThreshold: $covThreshold, ')
          ..write('historyIntervalSecs: $historyIntervalSecs, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScheduleEntriesTable extends ScheduleEntries
    with TableInfo<$ScheduleEntriesTable, ScheduleEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScheduleEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Schedule, String> schedule =
      GeneratedColumn<String>(
        'schedule',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Schedule>($ScheduleEntriesTable.$converterschedule);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, schedule, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schedule_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScheduleEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScheduleEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduleEntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      schedule: $ScheduleEntriesTable.$converterschedule.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}schedule'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ScheduleEntriesTable createAlias(String alias) {
    return $ScheduleEntriesTable(attachedDatabase, alias);
  }

  static TypeConverter<Schedule, String> $converterschedule =
      const ScheduleConverter();
}

class ScheduleEntryRow extends DataClass
    implements Insertable<ScheduleEntryRow> {
  final String id;
  final String name;
  final Schedule schedule;
  final DateTime createdAt;
  const ScheduleEntryRow({
    required this.id,
    required this.name,
    required this.schedule,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    {
      map['schedule'] = Variable<String>(
        $ScheduleEntriesTable.$converterschedule.toSql(schedule),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ScheduleEntriesCompanion toCompanion(bool nullToAbsent) {
    return ScheduleEntriesCompanion(
      id: Value(id),
      name: Value(name),
      schedule: Value(schedule),
      createdAt: Value(createdAt),
    );
  }

  factory ScheduleEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduleEntryRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      schedule: serializer.fromJson<Schedule>(json['schedule']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'schedule': serializer.toJson<Schedule>(schedule),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ScheduleEntryRow copyWith({
    String? id,
    String? name,
    Schedule? schedule,
    DateTime? createdAt,
  }) => ScheduleEntryRow(
    id: id ?? this.id,
    name: name ?? this.name,
    schedule: schedule ?? this.schedule,
    createdAt: createdAt ?? this.createdAt,
  );
  ScheduleEntryRow copyWithCompanion(ScheduleEntriesCompanion data) {
    return ScheduleEntryRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      schedule: data.schedule.present ? data.schedule.value : this.schedule,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleEntryRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('schedule: $schedule, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, schedule, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduleEntryRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.schedule == this.schedule &&
          other.createdAt == this.createdAt);
}

class ScheduleEntriesCompanion extends UpdateCompanion<ScheduleEntryRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<Schedule> schedule;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ScheduleEntriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.schedule = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScheduleEntriesCompanion.insert({
    required String id,
    required String name,
    required Schedule schedule,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       schedule = Value(schedule),
       createdAt = Value(createdAt);
  static Insertable<ScheduleEntryRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? schedule,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (schedule != null) 'schedule': schedule,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScheduleEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<Schedule>? schedule,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ScheduleEntriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      schedule: schedule ?? this.schedule,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (schedule.present) {
      map['schedule'] = Variable<String>(
        $ScheduleEntriesTable.$converterschedule.toSql(schedule.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleEntriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('schedule: $schedule, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScheduleBindingsTable extends ScheduleBindings
    with TableInfo<$ScheduleBindingsTable, ScheduleBindingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScheduleBindingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduleIdMeta = const VerificationMeta(
    'scheduleId',
  );
  @override
  late final GeneratedColumn<String> scheduleId = GeneratedColumn<String>(
    'schedule_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES schedule_entries (id)',
    ),
  );
  static const VerificationMeta _pointIdMeta = const VerificationMeta(
    'pointId',
  );
  @override
  late final GeneratedColumn<String> pointId = GeneratedColumn<String>(
    'point_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES points (id)',
    ),
  );
  static const VerificationMeta _activeValueMeta = const VerificationMeta(
    'activeValue',
  );
  @override
  late final GeneratedColumn<String> activeValue = GeneratedColumn<String>(
    'active_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inactiveValueMeta = const VerificationMeta(
    'inactiveValue',
  );
  @override
  late final GeneratedColumn<String> inactiveValue = GeneratedColumn<String>(
    'inactive_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    scheduleId,
    pointId,
    activeValue,
    inactiveValue,
    enabled,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schedule_bindings';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScheduleBindingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('schedule_id')) {
      context.handle(
        _scheduleIdMeta,
        scheduleId.isAcceptableOrUnknown(data['schedule_id']!, _scheduleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_scheduleIdMeta);
    }
    if (data.containsKey('point_id')) {
      context.handle(
        _pointIdMeta,
        pointId.isAcceptableOrUnknown(data['point_id']!, _pointIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pointIdMeta);
    }
    if (data.containsKey('active_value')) {
      context.handle(
        _activeValueMeta,
        activeValue.isAcceptableOrUnknown(
          data['active_value']!,
          _activeValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_activeValueMeta);
    }
    if (data.containsKey('inactive_value')) {
      context.handle(
        _inactiveValueMeta,
        inactiveValue.isAcceptableOrUnknown(
          data['inactive_value']!,
          _inactiveValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inactiveValueMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScheduleBindingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduleBindingRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      scheduleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}schedule_id'],
      )!,
      pointId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}point_id'],
      )!,
      activeValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}active_value'],
      )!,
      inactiveValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}inactive_value'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ScheduleBindingsTable createAlias(String alias) {
    return $ScheduleBindingsTable(attachedDatabase, alias);
  }
}

class ScheduleBindingRow extends DataClass
    implements Insertable<ScheduleBindingRow> {
  final String id;
  final String scheduleId;
  final String pointId;
  final String activeValue;
  final String inactiveValue;
  final bool enabled;
  final DateTime createdAt;
  const ScheduleBindingRow({
    required this.id,
    required this.scheduleId,
    required this.pointId,
    required this.activeValue,
    required this.inactiveValue,
    required this.enabled,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['schedule_id'] = Variable<String>(scheduleId);
    map['point_id'] = Variable<String>(pointId);
    map['active_value'] = Variable<String>(activeValue);
    map['inactive_value'] = Variable<String>(inactiveValue);
    map['enabled'] = Variable<bool>(enabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ScheduleBindingsCompanion toCompanion(bool nullToAbsent) {
    return ScheduleBindingsCompanion(
      id: Value(id),
      scheduleId: Value(scheduleId),
      pointId: Value(pointId),
      activeValue: Value(activeValue),
      inactiveValue: Value(inactiveValue),
      enabled: Value(enabled),
      createdAt: Value(createdAt),
    );
  }

  factory ScheduleBindingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduleBindingRow(
      id: serializer.fromJson<String>(json['id']),
      scheduleId: serializer.fromJson<String>(json['scheduleId']),
      pointId: serializer.fromJson<String>(json['pointId']),
      activeValue: serializer.fromJson<String>(json['activeValue']),
      inactiveValue: serializer.fromJson<String>(json['inactiveValue']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'scheduleId': serializer.toJson<String>(scheduleId),
      'pointId': serializer.toJson<String>(pointId),
      'activeValue': serializer.toJson<String>(activeValue),
      'inactiveValue': serializer.toJson<String>(inactiveValue),
      'enabled': serializer.toJson<bool>(enabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ScheduleBindingRow copyWith({
    String? id,
    String? scheduleId,
    String? pointId,
    String? activeValue,
    String? inactiveValue,
    bool? enabled,
    DateTime? createdAt,
  }) => ScheduleBindingRow(
    id: id ?? this.id,
    scheduleId: scheduleId ?? this.scheduleId,
    pointId: pointId ?? this.pointId,
    activeValue: activeValue ?? this.activeValue,
    inactiveValue: inactiveValue ?? this.inactiveValue,
    enabled: enabled ?? this.enabled,
    createdAt: createdAt ?? this.createdAt,
  );
  ScheduleBindingRow copyWithCompanion(ScheduleBindingsCompanion data) {
    return ScheduleBindingRow(
      id: data.id.present ? data.id.value : this.id,
      scheduleId: data.scheduleId.present
          ? data.scheduleId.value
          : this.scheduleId,
      pointId: data.pointId.present ? data.pointId.value : this.pointId,
      activeValue: data.activeValue.present
          ? data.activeValue.value
          : this.activeValue,
      inactiveValue: data.inactiveValue.present
          ? data.inactiveValue.value
          : this.inactiveValue,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleBindingRow(')
          ..write('id: $id, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('pointId: $pointId, ')
          ..write('activeValue: $activeValue, ')
          ..write('inactiveValue: $inactiveValue, ')
          ..write('enabled: $enabled, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    scheduleId,
    pointId,
    activeValue,
    inactiveValue,
    enabled,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduleBindingRow &&
          other.id == this.id &&
          other.scheduleId == this.scheduleId &&
          other.pointId == this.pointId &&
          other.activeValue == this.activeValue &&
          other.inactiveValue == this.inactiveValue &&
          other.enabled == this.enabled &&
          other.createdAt == this.createdAt);
}

class ScheduleBindingsCompanion extends UpdateCompanion<ScheduleBindingRow> {
  final Value<String> id;
  final Value<String> scheduleId;
  final Value<String> pointId;
  final Value<String> activeValue;
  final Value<String> inactiveValue;
  final Value<bool> enabled;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ScheduleBindingsCompanion({
    this.id = const Value.absent(),
    this.scheduleId = const Value.absent(),
    this.pointId = const Value.absent(),
    this.activeValue = const Value.absent(),
    this.inactiveValue = const Value.absent(),
    this.enabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScheduleBindingsCompanion.insert({
    required String id,
    required String scheduleId,
    required String pointId,
    required String activeValue,
    required String inactiveValue,
    this.enabled = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       scheduleId = Value(scheduleId),
       pointId = Value(pointId),
       activeValue = Value(activeValue),
       inactiveValue = Value(inactiveValue),
       createdAt = Value(createdAt);
  static Insertable<ScheduleBindingRow> custom({
    Expression<String>? id,
    Expression<String>? scheduleId,
    Expression<String>? pointId,
    Expression<String>? activeValue,
    Expression<String>? inactiveValue,
    Expression<bool>? enabled,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (scheduleId != null) 'schedule_id': scheduleId,
      if (pointId != null) 'point_id': pointId,
      if (activeValue != null) 'active_value': activeValue,
      if (inactiveValue != null) 'inactive_value': inactiveValue,
      if (enabled != null) 'enabled': enabled,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScheduleBindingsCompanion copyWith({
    Value<String>? id,
    Value<String>? scheduleId,
    Value<String>? pointId,
    Value<String>? activeValue,
    Value<String>? inactiveValue,
    Value<bool>? enabled,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ScheduleBindingsCompanion(
      id: id ?? this.id,
      scheduleId: scheduleId ?? this.scheduleId,
      pointId: pointId ?? this.pointId,
      activeValue: activeValue ?? this.activeValue,
      inactiveValue: inactiveValue ?? this.inactiveValue,
      enabled: enabled ?? this.enabled,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (scheduleId.present) {
      map['schedule_id'] = Variable<String>(scheduleId.value);
    }
    if (pointId.present) {
      map['point_id'] = Variable<String>(pointId.value);
    }
    if (activeValue.present) {
      map['active_value'] = Variable<String>(activeValue.value);
    }
    if (inactiveValue.present) {
      map['inactive_value'] = Variable<String>(inactiveValue.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleBindingsCompanion(')
          ..write('id: $id, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('pointId: $pointId, ')
          ..write('activeValue: $activeValue, ')
          ..write('inactiveValue: $inactiveValue, ')
          ..write('enabled: $enabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AlarmsTable extends Alarms with TableInfo<$AlarmsTable, AlarmRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlarmsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pointIdMeta = const VerificationMeta(
    'pointId',
  );
  @override
  late final GeneratedColumn<String> pointId = GeneratedColumn<String>(
    'point_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _networkIdMeta = const VerificationMeta(
    'networkId',
  );
  @override
  late final GeneratedColumn<String> networkId = GeneratedColumn<String>(
    'network_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _severityMeta = const VerificationMeta(
    'severity',
  );
  @override
  late final GeneratedColumn<String> severity = GeneratedColumn<String>(
    'severity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('warning'),
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _acknowledgedAtMeta = const VerificationMeta(
    'acknowledgedAt',
  );
  @override
  late final GeneratedColumn<DateTime> acknowledgedAt =
      GeneratedColumn<DateTime>(
        'acknowledged_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    pointId,
    networkId,
    type,
    severity,
    message,
    acknowledgedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alarms';
  @override
  VerificationContext validateIntegrity(
    Insertable<AlarmRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('point_id')) {
      context.handle(
        _pointIdMeta,
        pointId.isAcceptableOrUnknown(data['point_id']!, _pointIdMeta),
      );
    }
    if (data.containsKey('network_id')) {
      context.handle(
        _networkIdMeta,
        networkId.isAcceptableOrUnknown(data['network_id']!, _networkIdMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(
        _severityMeta,
        severity.isAcceptableOrUnknown(data['severity']!, _severityMeta),
      );
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('acknowledged_at')) {
      context.handle(
        _acknowledgedAtMeta,
        acknowledgedAt.isAcceptableOrUnknown(
          data['acknowledged_at']!,
          _acknowledgedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AlarmRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlarmRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      pointId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}point_id'],
      ),
      networkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}network_id'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      severity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}severity'],
      )!,
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      )!,
      acknowledgedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}acknowledged_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AlarmsTable createAlias(String alias) {
    return $AlarmsTable(attachedDatabase, alias);
  }
}

class AlarmRow extends DataClass implements Insertable<AlarmRow> {
  final String id;
  final String? pointId;
  final String? networkId;
  final String type;
  final String severity;
  final String message;
  final DateTime? acknowledgedAt;
  final DateTime createdAt;
  const AlarmRow({
    required this.id,
    this.pointId,
    this.networkId,
    required this.type,
    required this.severity,
    required this.message,
    this.acknowledgedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || pointId != null) {
      map['point_id'] = Variable<String>(pointId);
    }
    if (!nullToAbsent || networkId != null) {
      map['network_id'] = Variable<String>(networkId);
    }
    map['type'] = Variable<String>(type);
    map['severity'] = Variable<String>(severity);
    map['message'] = Variable<String>(message);
    if (!nullToAbsent || acknowledgedAt != null) {
      map['acknowledged_at'] = Variable<DateTime>(acknowledgedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AlarmsCompanion toCompanion(bool nullToAbsent) {
    return AlarmsCompanion(
      id: Value(id),
      pointId: pointId == null && nullToAbsent
          ? const Value.absent()
          : Value(pointId),
      networkId: networkId == null && nullToAbsent
          ? const Value.absent()
          : Value(networkId),
      type: Value(type),
      severity: Value(severity),
      message: Value(message),
      acknowledgedAt: acknowledgedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(acknowledgedAt),
      createdAt: Value(createdAt),
    );
  }

  factory AlarmRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlarmRow(
      id: serializer.fromJson<String>(json['id']),
      pointId: serializer.fromJson<String?>(json['pointId']),
      networkId: serializer.fromJson<String?>(json['networkId']),
      type: serializer.fromJson<String>(json['type']),
      severity: serializer.fromJson<String>(json['severity']),
      message: serializer.fromJson<String>(json['message']),
      acknowledgedAt: serializer.fromJson<DateTime?>(json['acknowledgedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'pointId': serializer.toJson<String?>(pointId),
      'networkId': serializer.toJson<String?>(networkId),
      'type': serializer.toJson<String>(type),
      'severity': serializer.toJson<String>(severity),
      'message': serializer.toJson<String>(message),
      'acknowledgedAt': serializer.toJson<DateTime?>(acknowledgedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AlarmRow copyWith({
    String? id,
    Value<String?> pointId = const Value.absent(),
    Value<String?> networkId = const Value.absent(),
    String? type,
    String? severity,
    String? message,
    Value<DateTime?> acknowledgedAt = const Value.absent(),
    DateTime? createdAt,
  }) => AlarmRow(
    id: id ?? this.id,
    pointId: pointId.present ? pointId.value : this.pointId,
    networkId: networkId.present ? networkId.value : this.networkId,
    type: type ?? this.type,
    severity: severity ?? this.severity,
    message: message ?? this.message,
    acknowledgedAt: acknowledgedAt.present
        ? acknowledgedAt.value
        : this.acknowledgedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  AlarmRow copyWithCompanion(AlarmsCompanion data) {
    return AlarmRow(
      id: data.id.present ? data.id.value : this.id,
      pointId: data.pointId.present ? data.pointId.value : this.pointId,
      networkId: data.networkId.present ? data.networkId.value : this.networkId,
      type: data.type.present ? data.type.value : this.type,
      severity: data.severity.present ? data.severity.value : this.severity,
      message: data.message.present ? data.message.value : this.message,
      acknowledgedAt: data.acknowledgedAt.present
          ? data.acknowledgedAt.value
          : this.acknowledgedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AlarmRow(')
          ..write('id: $id, ')
          ..write('pointId: $pointId, ')
          ..write('networkId: $networkId, ')
          ..write('type: $type, ')
          ..write('severity: $severity, ')
          ..write('message: $message, ')
          ..write('acknowledgedAt: $acknowledgedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    pointId,
    networkId,
    type,
    severity,
    message,
    acknowledgedAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlarmRow &&
          other.id == this.id &&
          other.pointId == this.pointId &&
          other.networkId == this.networkId &&
          other.type == this.type &&
          other.severity == this.severity &&
          other.message == this.message &&
          other.acknowledgedAt == this.acknowledgedAt &&
          other.createdAt == this.createdAt);
}

class AlarmsCompanion extends UpdateCompanion<AlarmRow> {
  final Value<String> id;
  final Value<String?> pointId;
  final Value<String?> networkId;
  final Value<String> type;
  final Value<String> severity;
  final Value<String> message;
  final Value<DateTime?> acknowledgedAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AlarmsCompanion({
    this.id = const Value.absent(),
    this.pointId = const Value.absent(),
    this.networkId = const Value.absent(),
    this.type = const Value.absent(),
    this.severity = const Value.absent(),
    this.message = const Value.absent(),
    this.acknowledgedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AlarmsCompanion.insert({
    required String id,
    this.pointId = const Value.absent(),
    this.networkId = const Value.absent(),
    required String type,
    this.severity = const Value.absent(),
    required String message,
    this.acknowledgedAt = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       message = Value(message),
       createdAt = Value(createdAt);
  static Insertable<AlarmRow> custom({
    Expression<String>? id,
    Expression<String>? pointId,
    Expression<String>? networkId,
    Expression<String>? type,
    Expression<String>? severity,
    Expression<String>? message,
    Expression<DateTime>? acknowledgedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pointId != null) 'point_id': pointId,
      if (networkId != null) 'network_id': networkId,
      if (type != null) 'type': type,
      if (severity != null) 'severity': severity,
      if (message != null) 'message': message,
      if (acknowledgedAt != null) 'acknowledged_at': acknowledgedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AlarmsCompanion copyWith({
    Value<String>? id,
    Value<String?>? pointId,
    Value<String?>? networkId,
    Value<String>? type,
    Value<String>? severity,
    Value<String>? message,
    Value<DateTime?>? acknowledgedAt,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return AlarmsCompanion(
      id: id ?? this.id,
      pointId: pointId ?? this.pointId,
      networkId: networkId ?? this.networkId,
      type: type ?? this.type,
      severity: severity ?? this.severity,
      message: message ?? this.message,
      acknowledgedAt: acknowledgedAt ?? this.acknowledgedAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (pointId.present) {
      map['point_id'] = Variable<String>(pointId.value);
    }
    if (networkId.present) {
      map['network_id'] = Variable<String>(networkId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (severity.present) {
      map['severity'] = Variable<String>(severity.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (acknowledgedAt.present) {
      map['acknowledged_at'] = Variable<DateTime>(acknowledgedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlarmsCompanion(')
          ..write('id: $id, ')
          ..write('pointId: $pointId, ')
          ..write('networkId: $networkId, ')
          ..write('type: $type, ')
          ..write('severity: $severity, ')
          ..write('message: $message, ')
          ..write('acknowledgedAt: $acknowledgedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PagesTable extends Pages with TableInfo<$PagesTable, PageRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, icon, sortOrder, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pages';
  @override
  VerificationContext validateIntegrity(
    Insertable<PageRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PageRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PageRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PagesTable createAlias(String alias) {
    return $PagesTable(attachedDatabase, alias);
  }
}

class PageRow extends DataClass implements Insertable<PageRow> {
  final String id;
  final String name;
  final String? icon;
  final int sortOrder;
  final DateTime createdAt;
  const PageRow({
    required this.id,
    required this.name,
    this.icon,
    required this.sortOrder,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PagesCompanion toCompanion(bool nullToAbsent) {
    return PagesCompanion(
      id: Value(id),
      name: Value(name),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
    );
  }

  factory PageRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PageRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String?>(json['icon']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String?>(icon),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PageRow copyWith({
    String? id,
    String? name,
    Value<String?> icon = const Value.absent(),
    int? sortOrder,
    DateTime? createdAt,
  }) => PageRow(
    id: id ?? this.id,
    name: name ?? this.name,
    icon: icon.present ? icon.value : this.icon,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
  );
  PageRow copyWithCompanion(PagesCompanion data) {
    return PageRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PageRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, icon, sortOrder, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PageRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt);
}

class PagesCompanion extends UpdateCompanion<PageRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> icon;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PagesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PagesCompanion.insert({
    required String id,
    required String name,
    this.icon = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<PageRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PagesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? icon,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PagesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PagesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WidgetsTable extends Widgets with TableInfo<$WidgetsTable, WidgetRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WidgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pageIdMeta = const VerificationMeta('pageId');
  @override
  late final GeneratedColumn<String> pageId = GeneratedColumn<String>(
    'page_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pages (id)',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pointIdMeta = const VerificationMeta(
    'pointId',
  );
  @override
  late final GeneratedColumn<String> pointId = GeneratedColumn<String>(
    'point_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scheduleIdMeta = const VerificationMeta(
    'scheduleId',
  );
  @override
  late final GeneratedColumn<String> scheduleId = GeneratedColumn<String>(
    'schedule_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
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
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
  config = GeneratedColumn<String>(
    'config',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  ).withConverter<Map<String, dynamic>>($WidgetsTable.$converterconfig);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    pageId,
    type,
    pointId,
    scheduleId,
    title,
    sortOrder,
    config,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'widgets';
  @override
  VerificationContext validateIntegrity(
    Insertable<WidgetRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('page_id')) {
      context.handle(
        _pageIdMeta,
        pageId.isAcceptableOrUnknown(data['page_id']!, _pageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pageIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('point_id')) {
      context.handle(
        _pointIdMeta,
        pointId.isAcceptableOrUnknown(data['point_id']!, _pointIdMeta),
      );
    }
    if (data.containsKey('schedule_id')) {
      context.handle(
        _scheduleIdMeta,
        scheduleId.isAcceptableOrUnknown(data['schedule_id']!, _scheduleIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WidgetRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WidgetRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      pageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}page_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      pointId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}point_id'],
      ),
      scheduleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}schedule_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      config: $WidgetsTable.$converterconfig.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}config'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WidgetsTable createAlias(String alias) {
    return $WidgetsTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $converterconfig =
      const JsonMapConverter();
}

class WidgetRow extends DataClass implements Insertable<WidgetRow> {
  final String id;
  final String pageId;
  final String type;
  final String? pointId;
  final String? scheduleId;
  final String title;
  final int sortOrder;
  final Map<String, dynamic> config;
  final DateTime createdAt;
  const WidgetRow({
    required this.id,
    required this.pageId,
    required this.type,
    this.pointId,
    this.scheduleId,
    required this.title,
    required this.sortOrder,
    required this.config,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['page_id'] = Variable<String>(pageId);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || pointId != null) {
      map['point_id'] = Variable<String>(pointId);
    }
    if (!nullToAbsent || scheduleId != null) {
      map['schedule_id'] = Variable<String>(scheduleId);
    }
    map['title'] = Variable<String>(title);
    map['sort_order'] = Variable<int>(sortOrder);
    {
      map['config'] = Variable<String>(
        $WidgetsTable.$converterconfig.toSql(config),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WidgetsCompanion toCompanion(bool nullToAbsent) {
    return WidgetsCompanion(
      id: Value(id),
      pageId: Value(pageId),
      type: Value(type),
      pointId: pointId == null && nullToAbsent
          ? const Value.absent()
          : Value(pointId),
      scheduleId: scheduleId == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduleId),
      title: Value(title),
      sortOrder: Value(sortOrder),
      config: Value(config),
      createdAt: Value(createdAt),
    );
  }

  factory WidgetRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WidgetRow(
      id: serializer.fromJson<String>(json['id']),
      pageId: serializer.fromJson<String>(json['pageId']),
      type: serializer.fromJson<String>(json['type']),
      pointId: serializer.fromJson<String?>(json['pointId']),
      scheduleId: serializer.fromJson<String?>(json['scheduleId']),
      title: serializer.fromJson<String>(json['title']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      config: serializer.fromJson<Map<String, dynamic>>(json['config']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'pageId': serializer.toJson<String>(pageId),
      'type': serializer.toJson<String>(type),
      'pointId': serializer.toJson<String?>(pointId),
      'scheduleId': serializer.toJson<String?>(scheduleId),
      'title': serializer.toJson<String>(title),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'config': serializer.toJson<Map<String, dynamic>>(config),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WidgetRow copyWith({
    String? id,
    String? pageId,
    String? type,
    Value<String?> pointId = const Value.absent(),
    Value<String?> scheduleId = const Value.absent(),
    String? title,
    int? sortOrder,
    Map<String, dynamic>? config,
    DateTime? createdAt,
  }) => WidgetRow(
    id: id ?? this.id,
    pageId: pageId ?? this.pageId,
    type: type ?? this.type,
    pointId: pointId.present ? pointId.value : this.pointId,
    scheduleId: scheduleId.present ? scheduleId.value : this.scheduleId,
    title: title ?? this.title,
    sortOrder: sortOrder ?? this.sortOrder,
    config: config ?? this.config,
    createdAt: createdAt ?? this.createdAt,
  );
  WidgetRow copyWithCompanion(WidgetsCompanion data) {
    return WidgetRow(
      id: data.id.present ? data.id.value : this.id,
      pageId: data.pageId.present ? data.pageId.value : this.pageId,
      type: data.type.present ? data.type.value : this.type,
      pointId: data.pointId.present ? data.pointId.value : this.pointId,
      scheduleId: data.scheduleId.present
          ? data.scheduleId.value
          : this.scheduleId,
      title: data.title.present ? data.title.value : this.title,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      config: data.config.present ? data.config.value : this.config,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WidgetRow(')
          ..write('id: $id, ')
          ..write('pageId: $pageId, ')
          ..write('type: $type, ')
          ..write('pointId: $pointId, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('title: $title, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('config: $config, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    pageId,
    type,
    pointId,
    scheduleId,
    title,
    sortOrder,
    config,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WidgetRow &&
          other.id == this.id &&
          other.pageId == this.pageId &&
          other.type == this.type &&
          other.pointId == this.pointId &&
          other.scheduleId == this.scheduleId &&
          other.title == this.title &&
          other.sortOrder == this.sortOrder &&
          other.config == this.config &&
          other.createdAt == this.createdAt);
}

class WidgetsCompanion extends UpdateCompanion<WidgetRow> {
  final Value<String> id;
  final Value<String> pageId;
  final Value<String> type;
  final Value<String?> pointId;
  final Value<String?> scheduleId;
  final Value<String> title;
  final Value<int> sortOrder;
  final Value<Map<String, dynamic>> config;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const WidgetsCompanion({
    this.id = const Value.absent(),
    this.pageId = const Value.absent(),
    this.type = const Value.absent(),
    this.pointId = const Value.absent(),
    this.scheduleId = const Value.absent(),
    this.title = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.config = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WidgetsCompanion.insert({
    required String id,
    required String pageId,
    required String type,
    this.pointId = const Value.absent(),
    this.scheduleId = const Value.absent(),
    required String title,
    this.sortOrder = const Value.absent(),
    this.config = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       pageId = Value(pageId),
       type = Value(type),
       title = Value(title),
       createdAt = Value(createdAt);
  static Insertable<WidgetRow> custom({
    Expression<String>? id,
    Expression<String>? pageId,
    Expression<String>? type,
    Expression<String>? pointId,
    Expression<String>? scheduleId,
    Expression<String>? title,
    Expression<int>? sortOrder,
    Expression<String>? config,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pageId != null) 'page_id': pageId,
      if (type != null) 'type': type,
      if (pointId != null) 'point_id': pointId,
      if (scheduleId != null) 'schedule_id': scheduleId,
      if (title != null) 'title': title,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (config != null) 'config': config,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WidgetsCompanion copyWith({
    Value<String>? id,
    Value<String>? pageId,
    Value<String>? type,
    Value<String?>? pointId,
    Value<String?>? scheduleId,
    Value<String>? title,
    Value<int>? sortOrder,
    Value<Map<String, dynamic>>? config,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return WidgetsCompanion(
      id: id ?? this.id,
      pageId: pageId ?? this.pageId,
      type: type ?? this.type,
      pointId: pointId ?? this.pointId,
      scheduleId: scheduleId ?? this.scheduleId,
      title: title ?? this.title,
      sortOrder: sortOrder ?? this.sortOrder,
      config: config ?? this.config,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (pageId.present) {
      map['page_id'] = Variable<String>(pageId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (pointId.present) {
      map['point_id'] = Variable<String>(pointId.value);
    }
    if (scheduleId.present) {
      map['schedule_id'] = Variable<String>(scheduleId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (config.present) {
      map['config'] = Variable<String>(
        $WidgetsTable.$converterconfig.toSql(config.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WidgetsCompanion(')
          ..write('id: $id, ')
          ..write('pageId: $pageId, ')
          ..write('type: $type, ')
          ..write('pointId: $pointId, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('title: $title, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('config: $config, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PointHistoryTable extends PointHistory
    with TableInfo<$PointHistoryTable, PointHistoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PointHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _pointIdMeta = const VerificationMeta(
    'pointId',
  );
  @override
  late final GeneratedColumn<String> pointId = GeneratedColumn<String>(
    'point_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stringValueMeta = const VerificationMeta(
    'stringValue',
  );
  @override
  late final GeneratedColumn<String> stringValue = GeneratedColumn<String>(
    'string_value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    pointId,
    value,
    stringValue,
    timestamp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'point_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<PointHistoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('point_id')) {
      context.handle(
        _pointIdMeta,
        pointId.isAcceptableOrUnknown(data['point_id']!, _pointIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pointIdMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    if (data.containsKey('string_value')) {
      context.handle(
        _stringValueMeta,
        stringValue.isAcceptableOrUnknown(
          data['string_value']!,
          _stringValueMeta,
        ),
      );
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PointHistoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PointHistoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      pointId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}point_id'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      ),
      stringValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}string_value'],
      ),
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $PointHistoryTable createAlias(String alias) {
    return $PointHistoryTable(attachedDatabase, alias);
  }
}

class PointHistoryRow extends DataClass implements Insertable<PointHistoryRow> {
  final int id;
  final String pointId;
  final double? value;
  final String? stringValue;
  final DateTime timestamp;
  const PointHistoryRow({
    required this.id,
    required this.pointId,
    this.value,
    this.stringValue,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['point_id'] = Variable<String>(pointId);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<double>(value);
    }
    if (!nullToAbsent || stringValue != null) {
      map['string_value'] = Variable<String>(stringValue);
    }
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  PointHistoryCompanion toCompanion(bool nullToAbsent) {
    return PointHistoryCompanion(
      id: Value(id),
      pointId: Value(pointId),
      value: value == null && nullToAbsent
          ? const Value.absent()
          : Value(value),
      stringValue: stringValue == null && nullToAbsent
          ? const Value.absent()
          : Value(stringValue),
      timestamp: Value(timestamp),
    );
  }

  factory PointHistoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PointHistoryRow(
      id: serializer.fromJson<int>(json['id']),
      pointId: serializer.fromJson<String>(json['pointId']),
      value: serializer.fromJson<double?>(json['value']),
      stringValue: serializer.fromJson<String?>(json['stringValue']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pointId': serializer.toJson<String>(pointId),
      'value': serializer.toJson<double?>(value),
      'stringValue': serializer.toJson<String?>(stringValue),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  PointHistoryRow copyWith({
    int? id,
    String? pointId,
    Value<double?> value = const Value.absent(),
    Value<String?> stringValue = const Value.absent(),
    DateTime? timestamp,
  }) => PointHistoryRow(
    id: id ?? this.id,
    pointId: pointId ?? this.pointId,
    value: value.present ? value.value : this.value,
    stringValue: stringValue.present ? stringValue.value : this.stringValue,
    timestamp: timestamp ?? this.timestamp,
  );
  PointHistoryRow copyWithCompanion(PointHistoryCompanion data) {
    return PointHistoryRow(
      id: data.id.present ? data.id.value : this.id,
      pointId: data.pointId.present ? data.pointId.value : this.pointId,
      value: data.value.present ? data.value.value : this.value,
      stringValue: data.stringValue.present
          ? data.stringValue.value
          : this.stringValue,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PointHistoryRow(')
          ..write('id: $id, ')
          ..write('pointId: $pointId, ')
          ..write('value: $value, ')
          ..write('stringValue: $stringValue, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, pointId, value, stringValue, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PointHistoryRow &&
          other.id == this.id &&
          other.pointId == this.pointId &&
          other.value == this.value &&
          other.stringValue == this.stringValue &&
          other.timestamp == this.timestamp);
}

class PointHistoryCompanion extends UpdateCompanion<PointHistoryRow> {
  final Value<int> id;
  final Value<String> pointId;
  final Value<double?> value;
  final Value<String?> stringValue;
  final Value<DateTime> timestamp;
  const PointHistoryCompanion({
    this.id = const Value.absent(),
    this.pointId = const Value.absent(),
    this.value = const Value.absent(),
    this.stringValue = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  PointHistoryCompanion.insert({
    this.id = const Value.absent(),
    required String pointId,
    this.value = const Value.absent(),
    this.stringValue = const Value.absent(),
    required DateTime timestamp,
  }) : pointId = Value(pointId),
       timestamp = Value(timestamp);
  static Insertable<PointHistoryRow> custom({
    Expression<int>? id,
    Expression<String>? pointId,
    Expression<double>? value,
    Expression<String>? stringValue,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pointId != null) 'point_id': pointId,
      if (value != null) 'value': value,
      if (stringValue != null) 'string_value': stringValue,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  PointHistoryCompanion copyWith({
    Value<int>? id,
    Value<String>? pointId,
    Value<double?>? value,
    Value<String?>? stringValue,
    Value<DateTime>? timestamp,
  }) {
    return PointHistoryCompanion(
      id: id ?? this.id,
      pointId: pointId ?? this.pointId,
      value: value ?? this.value,
      stringValue: stringValue ?? this.stringValue,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pointId.present) {
      map['point_id'] = Variable<String>(pointId.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (stringValue.present) {
      map['string_value'] = Variable<String>(stringValue.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PointHistoryCompanion(')
          ..write('id: $id, ')
          ..write('pointId: $pointId, ')
          ..write('value: $value, ')
          ..write('stringValue: $stringValue, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

class $RuntimeFlowsTable extends RuntimeFlows
    with TableInfo<$RuntimeFlowsTable, RuntimeFlowRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RuntimeFlowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Default Flow'),
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    enabled,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'runtime_flows';
  @override
  VerificationContext validateIntegrity(
    Insertable<RuntimeFlowRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RuntimeFlowRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RuntimeFlowRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RuntimeFlowsTable createAlias(String alias) {
    return $RuntimeFlowsTable(attachedDatabase, alias);
  }
}

class RuntimeFlowRow extends DataClass implements Insertable<RuntimeFlowRow> {
  final String id;
  final String name;
  final bool enabled;
  final DateTime createdAt;
  final DateTime updatedAt;
  const RuntimeFlowRow({
    required this.id,
    required this.name,
    required this.enabled,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['enabled'] = Variable<bool>(enabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RuntimeFlowsCompanion toCompanion(bool nullToAbsent) {
    return RuntimeFlowsCompanion(
      id: Value(id),
      name: Value(name),
      enabled: Value(enabled),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RuntimeFlowRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RuntimeFlowRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'enabled': serializer.toJson<bool>(enabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RuntimeFlowRow copyWith({
    String? id,
    String? name,
    bool? enabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => RuntimeFlowRow(
    id: id ?? this.id,
    name: name ?? this.name,
    enabled: enabled ?? this.enabled,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RuntimeFlowRow copyWithCompanion(RuntimeFlowsCompanion data) {
    return RuntimeFlowRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RuntimeFlowRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('enabled: $enabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, enabled, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RuntimeFlowRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.enabled == this.enabled &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RuntimeFlowsCompanion extends UpdateCompanion<RuntimeFlowRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<bool> enabled;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RuntimeFlowsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.enabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RuntimeFlowsCompanion.insert({
    required String id,
    this.name = const Value.absent(),
    this.enabled = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<RuntimeFlowRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<bool>? enabled,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (enabled != null) 'enabled': enabled,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RuntimeFlowsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<bool>? enabled,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RuntimeFlowsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      enabled: enabled ?? this.enabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RuntimeFlowsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('enabled: $enabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RuntimeNodesTable extends RuntimeNodes
    with TableInfo<$RuntimeNodesTable, RuntimeNodeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RuntimeNodesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _flowIdMeta = const VerificationMeta('flowId');
  @override
  late final GeneratedColumn<String> flowId = GeneratedColumn<String>(
    'flow_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES runtime_flows (id)',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('stale'),
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
  settings = GeneratedColumn<String>(
    'settings',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  ).withConverter<Map<String, dynamic>>($RuntimeNodesTable.$convertersettings);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _posXMeta = const VerificationMeta('posX');
  @override
  late final GeneratedColumn<double> posX = GeneratedColumn<double>(
    'pos_x',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _posYMeta = const VerificationMeta('posY');
  @override
  late final GeneratedColumn<double> posY = GeneratedColumn<double>(
    'pos_y',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    flowId,
    type,
    category,
    status,
    value,
    settings,
    label,
    parentId,
    posX,
    posY,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'runtime_nodes';
  @override
  VerificationContext validateIntegrity(
    Insertable<RuntimeNodeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('flow_id')) {
      context.handle(
        _flowIdMeta,
        flowId.isAcceptableOrUnknown(data['flow_id']!, _flowIdMeta),
      );
    } else if (isInserting) {
      context.missing(_flowIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('pos_x')) {
      context.handle(
        _posXMeta,
        posX.isAcceptableOrUnknown(data['pos_x']!, _posXMeta),
      );
    }
    if (data.containsKey('pos_y')) {
      context.handle(
        _posYMeta,
        posY.isAcceptableOrUnknown(data['pos_y']!, _posYMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RuntimeNodeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RuntimeNodeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      flowId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}flow_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      settings: $RuntimeNodesTable.$convertersettings.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}settings'],
        )!,
      ),
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      ),
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      posX: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pos_x'],
      )!,
      posY: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pos_y'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RuntimeNodesTable createAlias(String alias) {
    return $RuntimeNodesTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $convertersettings =
      const JsonMapConverter();
}

class RuntimeNodeRow extends DataClass implements Insertable<RuntimeNodeRow> {
  final String id;
  final String flowId;

  /// Node type identifier, e.g. "mqtt.subscribe", "math.add", "system.constant"
  final String type;

  /// Category: "source", "transform", or "sink"
  final String category;

  /// Runtime status: "ok", "stale", "error", "disabled"
  final String status;

  /// Current output value(s) as JSON — persisted on every change.
  final String value;

  /// Node-specific configuration as JSON (e.g. {"topic": "sensor/a"})
  final Map<String, dynamic> settings;

  /// Optional display label
  final String? label;

  /// Parent node ID for containment hierarchy.
  /// null = root node. Examples: device → network, point → device,
  /// subscribe → broker, display → page.
  final String? parentId;

  /// Canvas position (persisted so the UI can restore node layout).
  final double posX;
  final double posY;
  final DateTime createdAt;
  const RuntimeNodeRow({
    required this.id,
    required this.flowId,
    required this.type,
    required this.category,
    required this.status,
    required this.value,
    required this.settings,
    this.label,
    this.parentId,
    required this.posX,
    required this.posY,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['flow_id'] = Variable<String>(flowId);
    map['type'] = Variable<String>(type);
    map['category'] = Variable<String>(category);
    map['status'] = Variable<String>(status);
    map['value'] = Variable<String>(value);
    {
      map['settings'] = Variable<String>(
        $RuntimeNodesTable.$convertersettings.toSql(settings),
      );
    }
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['pos_x'] = Variable<double>(posX);
    map['pos_y'] = Variable<double>(posY);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RuntimeNodesCompanion toCompanion(bool nullToAbsent) {
    return RuntimeNodesCompanion(
      id: Value(id),
      flowId: Value(flowId),
      type: Value(type),
      category: Value(category),
      status: Value(status),
      value: Value(value),
      settings: Value(settings),
      label: label == null && nullToAbsent
          ? const Value.absent()
          : Value(label),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      posX: Value(posX),
      posY: Value(posY),
      createdAt: Value(createdAt),
    );
  }

  factory RuntimeNodeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RuntimeNodeRow(
      id: serializer.fromJson<String>(json['id']),
      flowId: serializer.fromJson<String>(json['flowId']),
      type: serializer.fromJson<String>(json['type']),
      category: serializer.fromJson<String>(json['category']),
      status: serializer.fromJson<String>(json['status']),
      value: serializer.fromJson<String>(json['value']),
      settings: serializer.fromJson<Map<String, dynamic>>(json['settings']),
      label: serializer.fromJson<String?>(json['label']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      posX: serializer.fromJson<double>(json['posX']),
      posY: serializer.fromJson<double>(json['posY']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'flowId': serializer.toJson<String>(flowId),
      'type': serializer.toJson<String>(type),
      'category': serializer.toJson<String>(category),
      'status': serializer.toJson<String>(status),
      'value': serializer.toJson<String>(value),
      'settings': serializer.toJson<Map<String, dynamic>>(settings),
      'label': serializer.toJson<String?>(label),
      'parentId': serializer.toJson<String?>(parentId),
      'posX': serializer.toJson<double>(posX),
      'posY': serializer.toJson<double>(posY),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RuntimeNodeRow copyWith({
    String? id,
    String? flowId,
    String? type,
    String? category,
    String? status,
    String? value,
    Map<String, dynamic>? settings,
    Value<String?> label = const Value.absent(),
    Value<String?> parentId = const Value.absent(),
    double? posX,
    double? posY,
    DateTime? createdAt,
  }) => RuntimeNodeRow(
    id: id ?? this.id,
    flowId: flowId ?? this.flowId,
    type: type ?? this.type,
    category: category ?? this.category,
    status: status ?? this.status,
    value: value ?? this.value,
    settings: settings ?? this.settings,
    label: label.present ? label.value : this.label,
    parentId: parentId.present ? parentId.value : this.parentId,
    posX: posX ?? this.posX,
    posY: posY ?? this.posY,
    createdAt: createdAt ?? this.createdAt,
  );
  RuntimeNodeRow copyWithCompanion(RuntimeNodesCompanion data) {
    return RuntimeNodeRow(
      id: data.id.present ? data.id.value : this.id,
      flowId: data.flowId.present ? data.flowId.value : this.flowId,
      type: data.type.present ? data.type.value : this.type,
      category: data.category.present ? data.category.value : this.category,
      status: data.status.present ? data.status.value : this.status,
      value: data.value.present ? data.value.value : this.value,
      settings: data.settings.present ? data.settings.value : this.settings,
      label: data.label.present ? data.label.value : this.label,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      posX: data.posX.present ? data.posX.value : this.posX,
      posY: data.posY.present ? data.posY.value : this.posY,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RuntimeNodeRow(')
          ..write('id: $id, ')
          ..write('flowId: $flowId, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('status: $status, ')
          ..write('value: $value, ')
          ..write('settings: $settings, ')
          ..write('label: $label, ')
          ..write('parentId: $parentId, ')
          ..write('posX: $posX, ')
          ..write('posY: $posY, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    flowId,
    type,
    category,
    status,
    value,
    settings,
    label,
    parentId,
    posX,
    posY,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RuntimeNodeRow &&
          other.id == this.id &&
          other.flowId == this.flowId &&
          other.type == this.type &&
          other.category == this.category &&
          other.status == this.status &&
          other.value == this.value &&
          other.settings == this.settings &&
          other.label == this.label &&
          other.parentId == this.parentId &&
          other.posX == this.posX &&
          other.posY == this.posY &&
          other.createdAt == this.createdAt);
}

class RuntimeNodesCompanion extends UpdateCompanion<RuntimeNodeRow> {
  final Value<String> id;
  final Value<String> flowId;
  final Value<String> type;
  final Value<String> category;
  final Value<String> status;
  final Value<String> value;
  final Value<Map<String, dynamic>> settings;
  final Value<String?> label;
  final Value<String?> parentId;
  final Value<double> posX;
  final Value<double> posY;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RuntimeNodesCompanion({
    this.id = const Value.absent(),
    this.flowId = const Value.absent(),
    this.type = const Value.absent(),
    this.category = const Value.absent(),
    this.status = const Value.absent(),
    this.value = const Value.absent(),
    this.settings = const Value.absent(),
    this.label = const Value.absent(),
    this.parentId = const Value.absent(),
    this.posX = const Value.absent(),
    this.posY = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RuntimeNodesCompanion.insert({
    required String id,
    required String flowId,
    required String type,
    required String category,
    this.status = const Value.absent(),
    this.value = const Value.absent(),
    this.settings = const Value.absent(),
    this.label = const Value.absent(),
    this.parentId = const Value.absent(),
    this.posX = const Value.absent(),
    this.posY = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       flowId = Value(flowId),
       type = Value(type),
       category = Value(category),
       createdAt = Value(createdAt);
  static Insertable<RuntimeNodeRow> custom({
    Expression<String>? id,
    Expression<String>? flowId,
    Expression<String>? type,
    Expression<String>? category,
    Expression<String>? status,
    Expression<String>? value,
    Expression<String>? settings,
    Expression<String>? label,
    Expression<String>? parentId,
    Expression<double>? posX,
    Expression<double>? posY,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (flowId != null) 'flow_id': flowId,
      if (type != null) 'type': type,
      if (category != null) 'category': category,
      if (status != null) 'status': status,
      if (value != null) 'value': value,
      if (settings != null) 'settings': settings,
      if (label != null) 'label': label,
      if (parentId != null) 'parent_id': parentId,
      if (posX != null) 'pos_x': posX,
      if (posY != null) 'pos_y': posY,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RuntimeNodesCompanion copyWith({
    Value<String>? id,
    Value<String>? flowId,
    Value<String>? type,
    Value<String>? category,
    Value<String>? status,
    Value<String>? value,
    Value<Map<String, dynamic>>? settings,
    Value<String?>? label,
    Value<String?>? parentId,
    Value<double>? posX,
    Value<double>? posY,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return RuntimeNodesCompanion(
      id: id ?? this.id,
      flowId: flowId ?? this.flowId,
      type: type ?? this.type,
      category: category ?? this.category,
      status: status ?? this.status,
      value: value ?? this.value,
      settings: settings ?? this.settings,
      label: label ?? this.label,
      parentId: parentId ?? this.parentId,
      posX: posX ?? this.posX,
      posY: posY ?? this.posY,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (flowId.present) {
      map['flow_id'] = Variable<String>(flowId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (settings.present) {
      map['settings'] = Variable<String>(
        $RuntimeNodesTable.$convertersettings.toSql(settings.value),
      );
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (posX.present) {
      map['pos_x'] = Variable<double>(posX.value);
    }
    if (posY.present) {
      map['pos_y'] = Variable<double>(posY.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RuntimeNodesCompanion(')
          ..write('id: $id, ')
          ..write('flowId: $flowId, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('status: $status, ')
          ..write('value: $value, ')
          ..write('settings: $settings, ')
          ..write('label: $label, ')
          ..write('parentId: $parentId, ')
          ..write('posX: $posX, ')
          ..write('posY: $posY, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RuntimeEdgesTable extends RuntimeEdges
    with TableInfo<$RuntimeEdgesTable, RuntimeEdgeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RuntimeEdgesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _flowIdMeta = const VerificationMeta('flowId');
  @override
  late final GeneratedColumn<String> flowId = GeneratedColumn<String>(
    'flow_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES runtime_flows (id)',
    ),
  );
  static const VerificationMeta _sourceNodeIdMeta = const VerificationMeta(
    'sourceNodeId',
  );
  @override
  late final GeneratedColumn<String> sourceNodeId = GeneratedColumn<String>(
    'source_node_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES runtime_nodes (id)',
    ),
  );
  static const VerificationMeta _sourcePortMeta = const VerificationMeta(
    'sourcePort',
  );
  @override
  late final GeneratedColumn<String> sourcePort = GeneratedColumn<String>(
    'source_port',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetNodeIdMeta = const VerificationMeta(
    'targetNodeId',
  );
  @override
  late final GeneratedColumn<String> targetNodeId = GeneratedColumn<String>(
    'target_node_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES runtime_nodes (id)',
    ),
  );
  static const VerificationMeta _targetPortMeta = const VerificationMeta(
    'targetPort',
  );
  @override
  late final GeneratedColumn<String> targetPort = GeneratedColumn<String>(
    'target_port',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hiddenMeta = const VerificationMeta('hidden');
  @override
  late final GeneratedColumn<bool> hidden = GeneratedColumn<bool>(
    'hidden',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("hidden" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    flowId,
    sourceNodeId,
    sourcePort,
    targetNodeId,
    targetPort,
    hidden,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'runtime_edges';
  @override
  VerificationContext validateIntegrity(
    Insertable<RuntimeEdgeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('flow_id')) {
      context.handle(
        _flowIdMeta,
        flowId.isAcceptableOrUnknown(data['flow_id']!, _flowIdMeta),
      );
    } else if (isInserting) {
      context.missing(_flowIdMeta);
    }
    if (data.containsKey('source_node_id')) {
      context.handle(
        _sourceNodeIdMeta,
        sourceNodeId.isAcceptableOrUnknown(
          data['source_node_id']!,
          _sourceNodeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceNodeIdMeta);
    }
    if (data.containsKey('source_port')) {
      context.handle(
        _sourcePortMeta,
        sourcePort.isAcceptableOrUnknown(data['source_port']!, _sourcePortMeta),
      );
    } else if (isInserting) {
      context.missing(_sourcePortMeta);
    }
    if (data.containsKey('target_node_id')) {
      context.handle(
        _targetNodeIdMeta,
        targetNodeId.isAcceptableOrUnknown(
          data['target_node_id']!,
          _targetNodeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetNodeIdMeta);
    }
    if (data.containsKey('target_port')) {
      context.handle(
        _targetPortMeta,
        targetPort.isAcceptableOrUnknown(data['target_port']!, _targetPortMeta),
      );
    } else if (isInserting) {
      context.missing(_targetPortMeta);
    }
    if (data.containsKey('hidden')) {
      context.handle(
        _hiddenMeta,
        hidden.isAcceptableOrUnknown(data['hidden']!, _hiddenMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RuntimeEdgeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RuntimeEdgeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      flowId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}flow_id'],
      )!,
      sourceNodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_node_id'],
      )!,
      sourcePort: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_port'],
      )!,
      targetNodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_node_id'],
      )!,
      targetPort: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_port'],
      )!,
      hidden: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}hidden'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RuntimeEdgesTable createAlias(String alias) {
    return $RuntimeEdgesTable(attachedDatabase, alias);
  }
}

class RuntimeEdgeRow extends DataClass implements Insertable<RuntimeEdgeRow> {
  final String id;
  final String flowId;
  final String sourceNodeId;
  final String sourcePort;
  final String targetNodeId;
  final String targetPort;
  final bool hidden;
  final DateTime createdAt;
  const RuntimeEdgeRow({
    required this.id,
    required this.flowId,
    required this.sourceNodeId,
    required this.sourcePort,
    required this.targetNodeId,
    required this.targetPort,
    required this.hidden,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['flow_id'] = Variable<String>(flowId);
    map['source_node_id'] = Variable<String>(sourceNodeId);
    map['source_port'] = Variable<String>(sourcePort);
    map['target_node_id'] = Variable<String>(targetNodeId);
    map['target_port'] = Variable<String>(targetPort);
    map['hidden'] = Variable<bool>(hidden);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RuntimeEdgesCompanion toCompanion(bool nullToAbsent) {
    return RuntimeEdgesCompanion(
      id: Value(id),
      flowId: Value(flowId),
      sourceNodeId: Value(sourceNodeId),
      sourcePort: Value(sourcePort),
      targetNodeId: Value(targetNodeId),
      targetPort: Value(targetPort),
      hidden: Value(hidden),
      createdAt: Value(createdAt),
    );
  }

  factory RuntimeEdgeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RuntimeEdgeRow(
      id: serializer.fromJson<String>(json['id']),
      flowId: serializer.fromJson<String>(json['flowId']),
      sourceNodeId: serializer.fromJson<String>(json['sourceNodeId']),
      sourcePort: serializer.fromJson<String>(json['sourcePort']),
      targetNodeId: serializer.fromJson<String>(json['targetNodeId']),
      targetPort: serializer.fromJson<String>(json['targetPort']),
      hidden: serializer.fromJson<bool>(json['hidden']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'flowId': serializer.toJson<String>(flowId),
      'sourceNodeId': serializer.toJson<String>(sourceNodeId),
      'sourcePort': serializer.toJson<String>(sourcePort),
      'targetNodeId': serializer.toJson<String>(targetNodeId),
      'targetPort': serializer.toJson<String>(targetPort),
      'hidden': serializer.toJson<bool>(hidden),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RuntimeEdgeRow copyWith({
    String? id,
    String? flowId,
    String? sourceNodeId,
    String? sourcePort,
    String? targetNodeId,
    String? targetPort,
    bool? hidden,
    DateTime? createdAt,
  }) => RuntimeEdgeRow(
    id: id ?? this.id,
    flowId: flowId ?? this.flowId,
    sourceNodeId: sourceNodeId ?? this.sourceNodeId,
    sourcePort: sourcePort ?? this.sourcePort,
    targetNodeId: targetNodeId ?? this.targetNodeId,
    targetPort: targetPort ?? this.targetPort,
    hidden: hidden ?? this.hidden,
    createdAt: createdAt ?? this.createdAt,
  );
  RuntimeEdgeRow copyWithCompanion(RuntimeEdgesCompanion data) {
    return RuntimeEdgeRow(
      id: data.id.present ? data.id.value : this.id,
      flowId: data.flowId.present ? data.flowId.value : this.flowId,
      sourceNodeId: data.sourceNodeId.present
          ? data.sourceNodeId.value
          : this.sourceNodeId,
      sourcePort: data.sourcePort.present
          ? data.sourcePort.value
          : this.sourcePort,
      targetNodeId: data.targetNodeId.present
          ? data.targetNodeId.value
          : this.targetNodeId,
      targetPort: data.targetPort.present
          ? data.targetPort.value
          : this.targetPort,
      hidden: data.hidden.present ? data.hidden.value : this.hidden,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RuntimeEdgeRow(')
          ..write('id: $id, ')
          ..write('flowId: $flowId, ')
          ..write('sourceNodeId: $sourceNodeId, ')
          ..write('sourcePort: $sourcePort, ')
          ..write('targetNodeId: $targetNodeId, ')
          ..write('targetPort: $targetPort, ')
          ..write('hidden: $hidden, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    flowId,
    sourceNodeId,
    sourcePort,
    targetNodeId,
    targetPort,
    hidden,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RuntimeEdgeRow &&
          other.id == this.id &&
          other.flowId == this.flowId &&
          other.sourceNodeId == this.sourceNodeId &&
          other.sourcePort == this.sourcePort &&
          other.targetNodeId == this.targetNodeId &&
          other.targetPort == this.targetPort &&
          other.hidden == this.hidden &&
          other.createdAt == this.createdAt);
}

class RuntimeEdgesCompanion extends UpdateCompanion<RuntimeEdgeRow> {
  final Value<String> id;
  final Value<String> flowId;
  final Value<String> sourceNodeId;
  final Value<String> sourcePort;
  final Value<String> targetNodeId;
  final Value<String> targetPort;
  final Value<bool> hidden;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RuntimeEdgesCompanion({
    this.id = const Value.absent(),
    this.flowId = const Value.absent(),
    this.sourceNodeId = const Value.absent(),
    this.sourcePort = const Value.absent(),
    this.targetNodeId = const Value.absent(),
    this.targetPort = const Value.absent(),
    this.hidden = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RuntimeEdgesCompanion.insert({
    required String id,
    required String flowId,
    required String sourceNodeId,
    required String sourcePort,
    required String targetNodeId,
    required String targetPort,
    this.hidden = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       flowId = Value(flowId),
       sourceNodeId = Value(sourceNodeId),
       sourcePort = Value(sourcePort),
       targetNodeId = Value(targetNodeId),
       targetPort = Value(targetPort),
       createdAt = Value(createdAt);
  static Insertable<RuntimeEdgeRow> custom({
    Expression<String>? id,
    Expression<String>? flowId,
    Expression<String>? sourceNodeId,
    Expression<String>? sourcePort,
    Expression<String>? targetNodeId,
    Expression<String>? targetPort,
    Expression<bool>? hidden,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (flowId != null) 'flow_id': flowId,
      if (sourceNodeId != null) 'source_node_id': sourceNodeId,
      if (sourcePort != null) 'source_port': sourcePort,
      if (targetNodeId != null) 'target_node_id': targetNodeId,
      if (targetPort != null) 'target_port': targetPort,
      if (hidden != null) 'hidden': hidden,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RuntimeEdgesCompanion copyWith({
    Value<String>? id,
    Value<String>? flowId,
    Value<String>? sourceNodeId,
    Value<String>? sourcePort,
    Value<String>? targetNodeId,
    Value<String>? targetPort,
    Value<bool>? hidden,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return RuntimeEdgesCompanion(
      id: id ?? this.id,
      flowId: flowId ?? this.flowId,
      sourceNodeId: sourceNodeId ?? this.sourceNodeId,
      sourcePort: sourcePort ?? this.sourcePort,
      targetNodeId: targetNodeId ?? this.targetNodeId,
      targetPort: targetPort ?? this.targetPort,
      hidden: hidden ?? this.hidden,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (flowId.present) {
      map['flow_id'] = Variable<String>(flowId.value);
    }
    if (sourceNodeId.present) {
      map['source_node_id'] = Variable<String>(sourceNodeId.value);
    }
    if (sourcePort.present) {
      map['source_port'] = Variable<String>(sourcePort.value);
    }
    if (targetNodeId.present) {
      map['target_node_id'] = Variable<String>(targetNodeId.value);
    }
    if (targetPort.present) {
      map['target_port'] = Variable<String>(targetPort.value);
    }
    if (hidden.present) {
      map['hidden'] = Variable<bool>(hidden.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RuntimeEdgesCompanion(')
          ..write('id: $id, ')
          ..write('flowId: $flowId, ')
          ..write('sourceNodeId: $sourceNodeId, ')
          ..write('sourcePort: $sourcePort, ')
          ..write('targetNodeId: $targetNodeId, ')
          ..write('targetPort: $targetPort, ')
          ..write('hidden: $hidden, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RuntimeHistoryTable extends RuntimeHistory
    with TableInfo<$RuntimeHistoryTable, RuntimeHistoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RuntimeHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<String> nodeId = GeneratedColumn<String>(
    'node_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES runtime_nodes (id)',
    ),
  );
  static const VerificationMeta _numValueMeta = const VerificationMeta(
    'numValue',
  );
  @override
  late final GeneratedColumn<double> numValue = GeneratedColumn<double>(
    'num_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _boolValueMeta = const VerificationMeta(
    'boolValue',
  );
  @override
  late final GeneratedColumn<bool> boolValue = GeneratedColumn<bool>(
    'bool_value',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("bool_value" IN (0, 1))',
    ),
  );
  static const VerificationMeta _strValueMeta = const VerificationMeta(
    'strValue',
  );
  @override
  late final GeneratedColumn<String> strValue = GeneratedColumn<String>(
    'str_value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nodeId,
    numValue,
    boolValue,
    strValue,
    timestamp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'runtime_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<RuntimeHistoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('node_id')) {
      context.handle(
        _nodeIdMeta,
        nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nodeIdMeta);
    }
    if (data.containsKey('num_value')) {
      context.handle(
        _numValueMeta,
        numValue.isAcceptableOrUnknown(data['num_value']!, _numValueMeta),
      );
    }
    if (data.containsKey('bool_value')) {
      context.handle(
        _boolValueMeta,
        boolValue.isAcceptableOrUnknown(data['bool_value']!, _boolValueMeta),
      );
    }
    if (data.containsKey('str_value')) {
      context.handle(
        _strValueMeta,
        strValue.isAcceptableOrUnknown(data['str_value']!, _strValueMeta),
      );
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RuntimeHistoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RuntimeHistoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}node_id'],
      )!,
      numValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}num_value'],
      ),
      boolValue: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}bool_value'],
      ),
      strValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}str_value'],
      ),
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $RuntimeHistoryTable createAlias(String alias) {
    return $RuntimeHistoryTable(attachedDatabase, alias);
  }
}

class RuntimeHistoryRow extends DataClass
    implements Insertable<RuntimeHistoryRow> {
  final int id;
  final String nodeId;

  /// Numeric value (temperature, setpoint, count, etc.)
  final double? numValue;

  /// Boolean value (on/off, active/inactive, alarm state)
  final bool? boolValue;

  /// String value (status text, mode name, etc.)
  final String? strValue;
  final DateTime timestamp;
  const RuntimeHistoryRow({
    required this.id,
    required this.nodeId,
    this.numValue,
    this.boolValue,
    this.strValue,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['node_id'] = Variable<String>(nodeId);
    if (!nullToAbsent || numValue != null) {
      map['num_value'] = Variable<double>(numValue);
    }
    if (!nullToAbsent || boolValue != null) {
      map['bool_value'] = Variable<bool>(boolValue);
    }
    if (!nullToAbsent || strValue != null) {
      map['str_value'] = Variable<String>(strValue);
    }
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  RuntimeHistoryCompanion toCompanion(bool nullToAbsent) {
    return RuntimeHistoryCompanion(
      id: Value(id),
      nodeId: Value(nodeId),
      numValue: numValue == null && nullToAbsent
          ? const Value.absent()
          : Value(numValue),
      boolValue: boolValue == null && nullToAbsent
          ? const Value.absent()
          : Value(boolValue),
      strValue: strValue == null && nullToAbsent
          ? const Value.absent()
          : Value(strValue),
      timestamp: Value(timestamp),
    );
  }

  factory RuntimeHistoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RuntimeHistoryRow(
      id: serializer.fromJson<int>(json['id']),
      nodeId: serializer.fromJson<String>(json['nodeId']),
      numValue: serializer.fromJson<double?>(json['numValue']),
      boolValue: serializer.fromJson<bool?>(json['boolValue']),
      strValue: serializer.fromJson<String?>(json['strValue']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nodeId': serializer.toJson<String>(nodeId),
      'numValue': serializer.toJson<double?>(numValue),
      'boolValue': serializer.toJson<bool?>(boolValue),
      'strValue': serializer.toJson<String?>(strValue),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  RuntimeHistoryRow copyWith({
    int? id,
    String? nodeId,
    Value<double?> numValue = const Value.absent(),
    Value<bool?> boolValue = const Value.absent(),
    Value<String?> strValue = const Value.absent(),
    DateTime? timestamp,
  }) => RuntimeHistoryRow(
    id: id ?? this.id,
    nodeId: nodeId ?? this.nodeId,
    numValue: numValue.present ? numValue.value : this.numValue,
    boolValue: boolValue.present ? boolValue.value : this.boolValue,
    strValue: strValue.present ? strValue.value : this.strValue,
    timestamp: timestamp ?? this.timestamp,
  );
  RuntimeHistoryRow copyWithCompanion(RuntimeHistoryCompanion data) {
    return RuntimeHistoryRow(
      id: data.id.present ? data.id.value : this.id,
      nodeId: data.nodeId.present ? data.nodeId.value : this.nodeId,
      numValue: data.numValue.present ? data.numValue.value : this.numValue,
      boolValue: data.boolValue.present ? data.boolValue.value : this.boolValue,
      strValue: data.strValue.present ? data.strValue.value : this.strValue,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RuntimeHistoryRow(')
          ..write('id: $id, ')
          ..write('nodeId: $nodeId, ')
          ..write('numValue: $numValue, ')
          ..write('boolValue: $boolValue, ')
          ..write('strValue: $strValue, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nodeId, numValue, boolValue, strValue, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RuntimeHistoryRow &&
          other.id == this.id &&
          other.nodeId == this.nodeId &&
          other.numValue == this.numValue &&
          other.boolValue == this.boolValue &&
          other.strValue == this.strValue &&
          other.timestamp == this.timestamp);
}

class RuntimeHistoryCompanion extends UpdateCompanion<RuntimeHistoryRow> {
  final Value<int> id;
  final Value<String> nodeId;
  final Value<double?> numValue;
  final Value<bool?> boolValue;
  final Value<String?> strValue;
  final Value<DateTime> timestamp;
  const RuntimeHistoryCompanion({
    this.id = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.numValue = const Value.absent(),
    this.boolValue = const Value.absent(),
    this.strValue = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  RuntimeHistoryCompanion.insert({
    this.id = const Value.absent(),
    required String nodeId,
    this.numValue = const Value.absent(),
    this.boolValue = const Value.absent(),
    this.strValue = const Value.absent(),
    required DateTime timestamp,
  }) : nodeId = Value(nodeId),
       timestamp = Value(timestamp);
  static Insertable<RuntimeHistoryRow> custom({
    Expression<int>? id,
    Expression<String>? nodeId,
    Expression<double>? numValue,
    Expression<bool>? boolValue,
    Expression<String>? strValue,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nodeId != null) 'node_id': nodeId,
      if (numValue != null) 'num_value': numValue,
      if (boolValue != null) 'bool_value': boolValue,
      if (strValue != null) 'str_value': strValue,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  RuntimeHistoryCompanion copyWith({
    Value<int>? id,
    Value<String>? nodeId,
    Value<double?>? numValue,
    Value<bool?>? boolValue,
    Value<String?>? strValue,
    Value<DateTime>? timestamp,
  }) {
    return RuntimeHistoryCompanion(
      id: id ?? this.id,
      nodeId: nodeId ?? this.nodeId,
      numValue: numValue ?? this.numValue,
      boolValue: boolValue ?? this.boolValue,
      strValue: strValue ?? this.strValue,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<String>(nodeId.value);
    }
    if (numValue.present) {
      map['num_value'] = Variable<double>(numValue.value);
    }
    if (boolValue.present) {
      map['bool_value'] = Variable<bool>(boolValue.value);
    }
    if (strValue.present) {
      map['str_value'] = Variable<String>(strValue.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RuntimeHistoryCompanion(')
          ..write('id: $id, ')
          ..write('nodeId: $nodeId, ')
          ..write('numValue: $numValue, ')
          ..write('boolValue: $boolValue, ')
          ..write('strValue: $strValue, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

class $RuntimeInsightsTable extends RuntimeInsights
    with TableInfo<$RuntimeInsightsTable, RuntimeInsightRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RuntimeInsightsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<String> nodeId = GeneratedColumn<String>(
    'node_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES runtime_nodes (id)',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _severityMeta = const VerificationMeta(
    'severity',
  );
  @override
  late final GeneratedColumn<String> severity = GeneratedColumn<String>(
    'severity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _triggerValueMeta = const VerificationMeta(
    'triggerValue',
  );
  @override
  late final GeneratedColumn<double> triggerValue = GeneratedColumn<double>(
    'trigger_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _thresholdValueMeta = const VerificationMeta(
    'thresholdValue',
  );
  @override
  late final GeneratedColumn<double> thresholdValue = GeneratedColumn<double>(
    'threshold_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _triggeredAtMeta = const VerificationMeta(
    'triggeredAt',
  );
  @override
  late final GeneratedColumn<DateTime> triggeredAt = GeneratedColumn<DateTime>(
    'triggered_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clearedAtMeta = const VerificationMeta(
    'clearedAt',
  );
  @override
  late final GeneratedColumn<DateTime> clearedAt = GeneratedColumn<DateTime>(
    'cleared_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _acknowledgedAtMeta = const VerificationMeta(
    'acknowledgedAt',
  );
  @override
  late final GeneratedColumn<DateTime> acknowledgedAt =
      GeneratedColumn<DateTime>(
        'acknowledged_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _metadataMeta = const VerificationMeta(
    'metadata',
  );
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
    'metadata',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nodeId,
    type,
    severity,
    state,
    title,
    message,
    triggerValue,
    thresholdValue,
    triggeredAt,
    clearedAt,
    acknowledgedAt,
    metadata,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'runtime_insights';
  @override
  VerificationContext validateIntegrity(
    Insertable<RuntimeInsightRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('node_id')) {
      context.handle(
        _nodeIdMeta,
        nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nodeIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(
        _severityMeta,
        severity.isAcceptableOrUnknown(data['severity']!, _severityMeta),
      );
    } else if (isInserting) {
      context.missing(_severityMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    }
    if (data.containsKey('trigger_value')) {
      context.handle(
        _triggerValueMeta,
        triggerValue.isAcceptableOrUnknown(
          data['trigger_value']!,
          _triggerValueMeta,
        ),
      );
    }
    if (data.containsKey('threshold_value')) {
      context.handle(
        _thresholdValueMeta,
        thresholdValue.isAcceptableOrUnknown(
          data['threshold_value']!,
          _thresholdValueMeta,
        ),
      );
    }
    if (data.containsKey('triggered_at')) {
      context.handle(
        _triggeredAtMeta,
        triggeredAt.isAcceptableOrUnknown(
          data['triggered_at']!,
          _triggeredAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_triggeredAtMeta);
    }
    if (data.containsKey('cleared_at')) {
      context.handle(
        _clearedAtMeta,
        clearedAt.isAcceptableOrUnknown(data['cleared_at']!, _clearedAtMeta),
      );
    }
    if (data.containsKey('acknowledged_at')) {
      context.handle(
        _acknowledgedAtMeta,
        acknowledgedAt.isAcceptableOrUnknown(
          data['acknowledged_at']!,
          _acknowledgedAtMeta,
        ),
      );
    }
    if (data.containsKey('metadata')) {
      context.handle(
        _metadataMeta,
        metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RuntimeInsightRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RuntimeInsightRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}node_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      severity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}severity'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      ),
      triggerValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}trigger_value'],
      ),
      thresholdValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}threshold_value'],
      ),
      triggeredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}triggered_at'],
      )!,
      clearedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cleared_at'],
      ),
      acknowledgedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}acknowledged_at'],
      ),
      metadata: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata'],
      )!,
    );
  }

  @override
  $RuntimeInsightsTable createAlias(String alias) {
    return $RuntimeInsightsTable(attachedDatabase, alias);
  }
}

class RuntimeInsightRow extends DataClass
    implements Insertable<RuntimeInsightRow> {
  /// Primary key — UUID assigned when the insight is created.
  final String id;

  /// The insight node that generated this event.
  final String nodeId;

  /// Insight category: 'alarm', 'alert', 'notification', 'energy', 'action'.
  final String type;

  /// Severity level: 'critical', 'high', 'medium', 'low', 'info'.
  final String severity;

  /// Lifecycle state: 'active', 'acknowledged', 'cleared', 'inhibited'.
  final String state;

  /// Short human-readable title, e.g. "High Room Temperature".
  final String title;

  /// Optional detail message, e.g. "Zone 3 hit 28°C while AC running".
  final String? message;

  /// The value that triggered the insight (if numeric).
  final double? triggerValue;

  /// The configured threshold that was breached (if applicable).
  final double? thresholdValue;

  /// When the insight was first triggered.
  final DateTime triggeredAt;

  /// When the insight was cleared (condition no longer met).
  final DateTime? clearedAt;

  /// When a user acknowledged the insight.
  final DateTime? acknowledgedAt;

  /// Extensible JSON bag for alarm-specific context:
  /// deadband, inhibit duration, expression, input snapshot, etc.
  final String metadata;
  const RuntimeInsightRow({
    required this.id,
    required this.nodeId,
    required this.type,
    required this.severity,
    required this.state,
    required this.title,
    this.message,
    this.triggerValue,
    this.thresholdValue,
    required this.triggeredAt,
    this.clearedAt,
    this.acknowledgedAt,
    required this.metadata,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['node_id'] = Variable<String>(nodeId);
    map['type'] = Variable<String>(type);
    map['severity'] = Variable<String>(severity);
    map['state'] = Variable<String>(state);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || message != null) {
      map['message'] = Variable<String>(message);
    }
    if (!nullToAbsent || triggerValue != null) {
      map['trigger_value'] = Variable<double>(triggerValue);
    }
    if (!nullToAbsent || thresholdValue != null) {
      map['threshold_value'] = Variable<double>(thresholdValue);
    }
    map['triggered_at'] = Variable<DateTime>(triggeredAt);
    if (!nullToAbsent || clearedAt != null) {
      map['cleared_at'] = Variable<DateTime>(clearedAt);
    }
    if (!nullToAbsent || acknowledgedAt != null) {
      map['acknowledged_at'] = Variable<DateTime>(acknowledgedAt);
    }
    map['metadata'] = Variable<String>(metadata);
    return map;
  }

  RuntimeInsightsCompanion toCompanion(bool nullToAbsent) {
    return RuntimeInsightsCompanion(
      id: Value(id),
      nodeId: Value(nodeId),
      type: Value(type),
      severity: Value(severity),
      state: Value(state),
      title: Value(title),
      message: message == null && nullToAbsent
          ? const Value.absent()
          : Value(message),
      triggerValue: triggerValue == null && nullToAbsent
          ? const Value.absent()
          : Value(triggerValue),
      thresholdValue: thresholdValue == null && nullToAbsent
          ? const Value.absent()
          : Value(thresholdValue),
      triggeredAt: Value(triggeredAt),
      clearedAt: clearedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(clearedAt),
      acknowledgedAt: acknowledgedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(acknowledgedAt),
      metadata: Value(metadata),
    );
  }

  factory RuntimeInsightRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RuntimeInsightRow(
      id: serializer.fromJson<String>(json['id']),
      nodeId: serializer.fromJson<String>(json['nodeId']),
      type: serializer.fromJson<String>(json['type']),
      severity: serializer.fromJson<String>(json['severity']),
      state: serializer.fromJson<String>(json['state']),
      title: serializer.fromJson<String>(json['title']),
      message: serializer.fromJson<String?>(json['message']),
      triggerValue: serializer.fromJson<double?>(json['triggerValue']),
      thresholdValue: serializer.fromJson<double?>(json['thresholdValue']),
      triggeredAt: serializer.fromJson<DateTime>(json['triggeredAt']),
      clearedAt: serializer.fromJson<DateTime?>(json['clearedAt']),
      acknowledgedAt: serializer.fromJson<DateTime?>(json['acknowledgedAt']),
      metadata: serializer.fromJson<String>(json['metadata']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nodeId': serializer.toJson<String>(nodeId),
      'type': serializer.toJson<String>(type),
      'severity': serializer.toJson<String>(severity),
      'state': serializer.toJson<String>(state),
      'title': serializer.toJson<String>(title),
      'message': serializer.toJson<String?>(message),
      'triggerValue': serializer.toJson<double?>(triggerValue),
      'thresholdValue': serializer.toJson<double?>(thresholdValue),
      'triggeredAt': serializer.toJson<DateTime>(triggeredAt),
      'clearedAt': serializer.toJson<DateTime?>(clearedAt),
      'acknowledgedAt': serializer.toJson<DateTime?>(acknowledgedAt),
      'metadata': serializer.toJson<String>(metadata),
    };
  }

  RuntimeInsightRow copyWith({
    String? id,
    String? nodeId,
    String? type,
    String? severity,
    String? state,
    String? title,
    Value<String?> message = const Value.absent(),
    Value<double?> triggerValue = const Value.absent(),
    Value<double?> thresholdValue = const Value.absent(),
    DateTime? triggeredAt,
    Value<DateTime?> clearedAt = const Value.absent(),
    Value<DateTime?> acknowledgedAt = const Value.absent(),
    String? metadata,
  }) => RuntimeInsightRow(
    id: id ?? this.id,
    nodeId: nodeId ?? this.nodeId,
    type: type ?? this.type,
    severity: severity ?? this.severity,
    state: state ?? this.state,
    title: title ?? this.title,
    message: message.present ? message.value : this.message,
    triggerValue: triggerValue.present ? triggerValue.value : this.triggerValue,
    thresholdValue: thresholdValue.present
        ? thresholdValue.value
        : this.thresholdValue,
    triggeredAt: triggeredAt ?? this.triggeredAt,
    clearedAt: clearedAt.present ? clearedAt.value : this.clearedAt,
    acknowledgedAt: acknowledgedAt.present
        ? acknowledgedAt.value
        : this.acknowledgedAt,
    metadata: metadata ?? this.metadata,
  );
  RuntimeInsightRow copyWithCompanion(RuntimeInsightsCompanion data) {
    return RuntimeInsightRow(
      id: data.id.present ? data.id.value : this.id,
      nodeId: data.nodeId.present ? data.nodeId.value : this.nodeId,
      type: data.type.present ? data.type.value : this.type,
      severity: data.severity.present ? data.severity.value : this.severity,
      state: data.state.present ? data.state.value : this.state,
      title: data.title.present ? data.title.value : this.title,
      message: data.message.present ? data.message.value : this.message,
      triggerValue: data.triggerValue.present
          ? data.triggerValue.value
          : this.triggerValue,
      thresholdValue: data.thresholdValue.present
          ? data.thresholdValue.value
          : this.thresholdValue,
      triggeredAt: data.triggeredAt.present
          ? data.triggeredAt.value
          : this.triggeredAt,
      clearedAt: data.clearedAt.present ? data.clearedAt.value : this.clearedAt,
      acknowledgedAt: data.acknowledgedAt.present
          ? data.acknowledgedAt.value
          : this.acknowledgedAt,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RuntimeInsightRow(')
          ..write('id: $id, ')
          ..write('nodeId: $nodeId, ')
          ..write('type: $type, ')
          ..write('severity: $severity, ')
          ..write('state: $state, ')
          ..write('title: $title, ')
          ..write('message: $message, ')
          ..write('triggerValue: $triggerValue, ')
          ..write('thresholdValue: $thresholdValue, ')
          ..write('triggeredAt: $triggeredAt, ')
          ..write('clearedAt: $clearedAt, ')
          ..write('acknowledgedAt: $acknowledgedAt, ')
          ..write('metadata: $metadata')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nodeId,
    type,
    severity,
    state,
    title,
    message,
    triggerValue,
    thresholdValue,
    triggeredAt,
    clearedAt,
    acknowledgedAt,
    metadata,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RuntimeInsightRow &&
          other.id == this.id &&
          other.nodeId == this.nodeId &&
          other.type == this.type &&
          other.severity == this.severity &&
          other.state == this.state &&
          other.title == this.title &&
          other.message == this.message &&
          other.triggerValue == this.triggerValue &&
          other.thresholdValue == this.thresholdValue &&
          other.triggeredAt == this.triggeredAt &&
          other.clearedAt == this.clearedAt &&
          other.acknowledgedAt == this.acknowledgedAt &&
          other.metadata == this.metadata);
}

class RuntimeInsightsCompanion extends UpdateCompanion<RuntimeInsightRow> {
  final Value<String> id;
  final Value<String> nodeId;
  final Value<String> type;
  final Value<String> severity;
  final Value<String> state;
  final Value<String> title;
  final Value<String?> message;
  final Value<double?> triggerValue;
  final Value<double?> thresholdValue;
  final Value<DateTime> triggeredAt;
  final Value<DateTime?> clearedAt;
  final Value<DateTime?> acknowledgedAt;
  final Value<String> metadata;
  final Value<int> rowid;
  const RuntimeInsightsCompanion({
    this.id = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.type = const Value.absent(),
    this.severity = const Value.absent(),
    this.state = const Value.absent(),
    this.title = const Value.absent(),
    this.message = const Value.absent(),
    this.triggerValue = const Value.absent(),
    this.thresholdValue = const Value.absent(),
    this.triggeredAt = const Value.absent(),
    this.clearedAt = const Value.absent(),
    this.acknowledgedAt = const Value.absent(),
    this.metadata = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RuntimeInsightsCompanion.insert({
    required String id,
    required String nodeId,
    required String type,
    required String severity,
    required String state,
    required String title,
    this.message = const Value.absent(),
    this.triggerValue = const Value.absent(),
    this.thresholdValue = const Value.absent(),
    required DateTime triggeredAt,
    this.clearedAt = const Value.absent(),
    this.acknowledgedAt = const Value.absent(),
    this.metadata = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nodeId = Value(nodeId),
       type = Value(type),
       severity = Value(severity),
       state = Value(state),
       title = Value(title),
       triggeredAt = Value(triggeredAt);
  static Insertable<RuntimeInsightRow> custom({
    Expression<String>? id,
    Expression<String>? nodeId,
    Expression<String>? type,
    Expression<String>? severity,
    Expression<String>? state,
    Expression<String>? title,
    Expression<String>? message,
    Expression<double>? triggerValue,
    Expression<double>? thresholdValue,
    Expression<DateTime>? triggeredAt,
    Expression<DateTime>? clearedAt,
    Expression<DateTime>? acknowledgedAt,
    Expression<String>? metadata,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nodeId != null) 'node_id': nodeId,
      if (type != null) 'type': type,
      if (severity != null) 'severity': severity,
      if (state != null) 'state': state,
      if (title != null) 'title': title,
      if (message != null) 'message': message,
      if (triggerValue != null) 'trigger_value': triggerValue,
      if (thresholdValue != null) 'threshold_value': thresholdValue,
      if (triggeredAt != null) 'triggered_at': triggeredAt,
      if (clearedAt != null) 'cleared_at': clearedAt,
      if (acknowledgedAt != null) 'acknowledged_at': acknowledgedAt,
      if (metadata != null) 'metadata': metadata,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RuntimeInsightsCompanion copyWith({
    Value<String>? id,
    Value<String>? nodeId,
    Value<String>? type,
    Value<String>? severity,
    Value<String>? state,
    Value<String>? title,
    Value<String?>? message,
    Value<double?>? triggerValue,
    Value<double?>? thresholdValue,
    Value<DateTime>? triggeredAt,
    Value<DateTime?>? clearedAt,
    Value<DateTime?>? acknowledgedAt,
    Value<String>? metadata,
    Value<int>? rowid,
  }) {
    return RuntimeInsightsCompanion(
      id: id ?? this.id,
      nodeId: nodeId ?? this.nodeId,
      type: type ?? this.type,
      severity: severity ?? this.severity,
      state: state ?? this.state,
      title: title ?? this.title,
      message: message ?? this.message,
      triggerValue: triggerValue ?? this.triggerValue,
      thresholdValue: thresholdValue ?? this.thresholdValue,
      triggeredAt: triggeredAt ?? this.triggeredAt,
      clearedAt: clearedAt ?? this.clearedAt,
      acknowledgedAt: acknowledgedAt ?? this.acknowledgedAt,
      metadata: metadata ?? this.metadata,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<String>(nodeId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (severity.present) {
      map['severity'] = Variable<String>(severity.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (triggerValue.present) {
      map['trigger_value'] = Variable<double>(triggerValue.value);
    }
    if (thresholdValue.present) {
      map['threshold_value'] = Variable<double>(thresholdValue.value);
    }
    if (triggeredAt.present) {
      map['triggered_at'] = Variable<DateTime>(triggeredAt.value);
    }
    if (clearedAt.present) {
      map['cleared_at'] = Variable<DateTime>(clearedAt.value);
    }
    if (acknowledgedAt.present) {
      map['acknowledged_at'] = Variable<DateTime>(acknowledgedAt.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RuntimeInsightsCompanion(')
          ..write('id: $id, ')
          ..write('nodeId: $nodeId, ')
          ..write('type: $type, ')
          ..write('severity: $severity, ')
          ..write('state: $state, ')
          ..write('title: $title, ')
          ..write('message: $message, ')
          ..write('triggerValue: $triggerValue, ')
          ..write('thresholdValue: $thresholdValue, ')
          ..write('triggeredAt: $triggeredAt, ')
          ..write('clearedAt: $clearedAt, ')
          ..write('acknowledgedAt: $acknowledgedAt, ')
          ..write('metadata: $metadata, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocationsTable locations = $LocationsTable(this);
  late final $PinnedPagesTable pinnedPages = $PinnedPagesTable(this);
  late final $NetworksTable networks = $NetworksTable(this);
  late final $DevicesTable devices = $DevicesTable(this);
  late final $PointsTable points = $PointsTable(this);
  late final $ScheduleEntriesTable scheduleEntries = $ScheduleEntriesTable(
    this,
  );
  late final $ScheduleBindingsTable scheduleBindings = $ScheduleBindingsTable(
    this,
  );
  late final $AlarmsTable alarms = $AlarmsTable(this);
  late final $PagesTable pages = $PagesTable(this);
  late final $WidgetsTable widgets = $WidgetsTable(this);
  late final $PointHistoryTable pointHistory = $PointHistoryTable(this);
  late final $RuntimeFlowsTable runtimeFlows = $RuntimeFlowsTable(this);
  late final $RuntimeNodesTable runtimeNodes = $RuntimeNodesTable(this);
  late final $RuntimeEdgesTable runtimeEdges = $RuntimeEdgesTable(this);
  late final $RuntimeHistoryTable runtimeHistory = $RuntimeHistoryTable(this);
  late final $RuntimeInsightsTable runtimeInsights = $RuntimeInsightsTable(
    this,
  );
  late final LocationDao locationDao = LocationDao(this as AppDatabase);
  late final PinnedPageDao pinnedPageDao = PinnedPageDao(this as AppDatabase);
  late final NetworkDao networkDao = NetworkDao(this as AppDatabase);
  late final DeviceDao deviceDao = DeviceDao(this as AppDatabase);
  late final PointDao pointDao = PointDao(this as AppDatabase);
  late final ScheduleDao scheduleDao = ScheduleDao(this as AppDatabase);
  late final AlarmDao alarmDao = AlarmDao(this as AppDatabase);
  late final PageDao pageDao = PageDao(this as AppDatabase);
  late final PointHistoryDao pointHistoryDao = PointHistoryDao(
    this as AppDatabase,
  );
  late final RuntimeDao runtimeDao = RuntimeDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    locations,
    pinnedPages,
    networks,
    devices,
    points,
    scheduleEntries,
    scheduleBindings,
    alarms,
    pages,
    widgets,
    pointHistory,
    runtimeFlows,
    runtimeNodes,
    runtimeEdges,
    runtimeHistory,
    runtimeInsights,
  ];
}

typedef $$LocationsTableCreateCompanionBuilder =
    LocationsCompanion Function({
      required String id,
      required String name,
      required String url,
      required String orgId,
      Value<bool> isActive,
      Value<DateTime?> lastUsed,
      Value<String?> address,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<int> rowid,
    });
typedef $$LocationsTableUpdateCompanionBuilder =
    LocationsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> url,
      Value<String> orgId,
      Value<bool> isActive,
      Value<DateTime?> lastUsed,
      Value<String?> address,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<int> rowid,
    });

class $$LocationsTableFilterComposer
    extends Composer<_$AppDatabase, $LocationsTable> {
  $$LocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUsed => $composableBuilder(
    column: $table.lastUsed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocationsTable> {
  $$LocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orgId => $composableBuilder(
    column: $table.orgId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUsed => $composableBuilder(
    column: $table.lastUsed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocationsTable> {
  $$LocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get orgId =>
      $composableBuilder(column: $table.orgId, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUsed =>
      $composableBuilder(column: $table.lastUsed, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);
}

class $$LocationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocationsTable,
          LocationRow,
          $$LocationsTableFilterComposer,
          $$LocationsTableOrderingComposer,
          $$LocationsTableAnnotationComposer,
          $$LocationsTableCreateCompanionBuilder,
          $$LocationsTableUpdateCompanionBuilder,
          (
            LocationRow,
            BaseReferences<_$AppDatabase, $LocationsTable, LocationRow>,
          ),
          LocationRow,
          PrefetchHooks Function()
        > {
  $$LocationsTableTableManager(_$AppDatabase db, $LocationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<String> orgId = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> lastUsed = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocationsCompanion(
                id: id,
                name: name,
                url: url,
                orgId: orgId,
                isActive: isActive,
                lastUsed: lastUsed,
                address: address,
                latitude: latitude,
                longitude: longitude,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String url,
                required String orgId,
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> lastUsed = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocationsCompanion.insert(
                id: id,
                name: name,
                url: url,
                orgId: orgId,
                isActive: isActive,
                lastUsed: lastUsed,
                address: address,
                latitude: latitude,
                longitude: longitude,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocationsTable,
      LocationRow,
      $$LocationsTableFilterComposer,
      $$LocationsTableOrderingComposer,
      $$LocationsTableAnnotationComposer,
      $$LocationsTableCreateCompanionBuilder,
      $$LocationsTableUpdateCompanionBuilder,
      (
        LocationRow,
        BaseReferences<_$AppDatabase, $LocationsTable, LocationRow>,
      ),
      LocationRow,
      PrefetchHooks Function()
    >;
typedef $$PinnedPagesTableCreateCompanionBuilder =
    PinnedPagesCompanion Function({
      required String id,
      required String locationId,
      required String locationName,
      required String nodeId,
      required String nodeLabel,
      Value<String?> pageId,
      Value<String?> pageTitle,
      required DateTime pinnedAt,
      Value<int> rowid,
    });
typedef $$PinnedPagesTableUpdateCompanionBuilder =
    PinnedPagesCompanion Function({
      Value<String> id,
      Value<String> locationId,
      Value<String> locationName,
      Value<String> nodeId,
      Value<String> nodeLabel,
      Value<String?> pageId,
      Value<String?> pageTitle,
      Value<DateTime> pinnedAt,
      Value<int> rowid,
    });

class $$PinnedPagesTableFilterComposer
    extends Composer<_$AppDatabase, $PinnedPagesTable> {
  $$PinnedPagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locationName => $composableBuilder(
    column: $table.locationName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nodeId => $composableBuilder(
    column: $table.nodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nodeLabel => $composableBuilder(
    column: $table.nodeLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pageId => $composableBuilder(
    column: $table.pageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pageTitle => $composableBuilder(
    column: $table.pageTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get pinnedAt => $composableBuilder(
    column: $table.pinnedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PinnedPagesTableOrderingComposer
    extends Composer<_$AppDatabase, $PinnedPagesTable> {
  $$PinnedPagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locationName => $composableBuilder(
    column: $table.locationName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nodeId => $composableBuilder(
    column: $table.nodeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nodeLabel => $composableBuilder(
    column: $table.nodeLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pageId => $composableBuilder(
    column: $table.pageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pageTitle => $composableBuilder(
    column: $table.pageTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get pinnedAt => $composableBuilder(
    column: $table.pinnedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PinnedPagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PinnedPagesTable> {
  $$PinnedPagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get locationName => $composableBuilder(
    column: $table.locationName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nodeId =>
      $composableBuilder(column: $table.nodeId, builder: (column) => column);

  GeneratedColumn<String> get nodeLabel =>
      $composableBuilder(column: $table.nodeLabel, builder: (column) => column);

  GeneratedColumn<String> get pageId =>
      $composableBuilder(column: $table.pageId, builder: (column) => column);

  GeneratedColumn<String> get pageTitle =>
      $composableBuilder(column: $table.pageTitle, builder: (column) => column);

  GeneratedColumn<DateTime> get pinnedAt =>
      $composableBuilder(column: $table.pinnedAt, builder: (column) => column);
}

class $$PinnedPagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PinnedPagesTable,
          PinnedPageRow,
          $$PinnedPagesTableFilterComposer,
          $$PinnedPagesTableOrderingComposer,
          $$PinnedPagesTableAnnotationComposer,
          $$PinnedPagesTableCreateCompanionBuilder,
          $$PinnedPagesTableUpdateCompanionBuilder,
          (
            PinnedPageRow,
            BaseReferences<_$AppDatabase, $PinnedPagesTable, PinnedPageRow>,
          ),
          PinnedPageRow,
          PrefetchHooks Function()
        > {
  $$PinnedPagesTableTableManager(_$AppDatabase db, $PinnedPagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PinnedPagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PinnedPagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PinnedPagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> locationId = const Value.absent(),
                Value<String> locationName = const Value.absent(),
                Value<String> nodeId = const Value.absent(),
                Value<String> nodeLabel = const Value.absent(),
                Value<String?> pageId = const Value.absent(),
                Value<String?> pageTitle = const Value.absent(),
                Value<DateTime> pinnedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PinnedPagesCompanion(
                id: id,
                locationId: locationId,
                locationName: locationName,
                nodeId: nodeId,
                nodeLabel: nodeLabel,
                pageId: pageId,
                pageTitle: pageTitle,
                pinnedAt: pinnedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String locationId,
                required String locationName,
                required String nodeId,
                required String nodeLabel,
                Value<String?> pageId = const Value.absent(),
                Value<String?> pageTitle = const Value.absent(),
                required DateTime pinnedAt,
                Value<int> rowid = const Value.absent(),
              }) => PinnedPagesCompanion.insert(
                id: id,
                locationId: locationId,
                locationName: locationName,
                nodeId: nodeId,
                nodeLabel: nodeLabel,
                pageId: pageId,
                pageTitle: pageTitle,
                pinnedAt: pinnedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PinnedPagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PinnedPagesTable,
      PinnedPageRow,
      $$PinnedPagesTableFilterComposer,
      $$PinnedPagesTableOrderingComposer,
      $$PinnedPagesTableAnnotationComposer,
      $$PinnedPagesTableCreateCompanionBuilder,
      $$PinnedPagesTableUpdateCompanionBuilder,
      (
        PinnedPageRow,
        BaseReferences<_$AppDatabase, $PinnedPagesTable, PinnedPageRow>,
      ),
      PinnedPageRow,
      PrefetchHooks Function()
    >;
typedef $$NetworksTableCreateCompanionBuilder =
    NetworksCompanion Function({
      required String id,
      required String name,
      Value<String> protocol,
      required String host,
      Value<int> port,
      Value<String?> username,
      Value<String?> password,
      Value<bool> useTls,
      Value<String> prefix,
      Value<bool> enabled,
      Value<String?> description,
      Value<String> settings,
      Value<String?> cloudNodeId,
      Value<String?> locationId,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$NetworksTableUpdateCompanionBuilder =
    NetworksCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> protocol,
      Value<String> host,
      Value<int> port,
      Value<String?> username,
      Value<String?> password,
      Value<bool> useTls,
      Value<String> prefix,
      Value<bool> enabled,
      Value<String?> description,
      Value<String> settings,
      Value<String?> cloudNodeId,
      Value<String?> locationId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$NetworksTableReferences
    extends BaseReferences<_$AppDatabase, $NetworksTable, NetworkRow> {
  $$NetworksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DevicesTable, List<DeviceRow>> _devicesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.devices,
    aliasName: $_aliasNameGenerator(db.networks.id, db.devices.networkId),
  );

  $$DevicesTableProcessedTableManager get devicesRefs {
    final manager = $$DevicesTableTableManager(
      $_db,
      $_db.devices,
    ).filter((f) => f.networkId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_devicesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$NetworksTableFilterComposer
    extends Composer<_$AppDatabase, $NetworksTable> {
  $$NetworksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get protocol => $composableBuilder(
    column: $table.protocol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get host => $composableBuilder(
    column: $table.host,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get useTls => $composableBuilder(
    column: $table.useTls,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prefix => $composableBuilder(
    column: $table.prefix,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get settings => $composableBuilder(
    column: $table.settings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cloudNodeId => $composableBuilder(
    column: $table.cloudNodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> devicesRefs(
    Expression<bool> Function($$DevicesTableFilterComposer f) f,
  ) {
    final $$DevicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.networkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableFilterComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NetworksTableOrderingComposer
    extends Composer<_$AppDatabase, $NetworksTable> {
  $$NetworksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get protocol => $composableBuilder(
    column: $table.protocol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get host => $composableBuilder(
    column: $table.host,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get useTls => $composableBuilder(
    column: $table.useTls,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prefix => $composableBuilder(
    column: $table.prefix,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get settings => $composableBuilder(
    column: $table.settings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cloudNodeId => $composableBuilder(
    column: $table.cloudNodeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NetworksTableAnnotationComposer
    extends Composer<_$AppDatabase, $NetworksTable> {
  $$NetworksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get protocol =>
      $composableBuilder(column: $table.protocol, builder: (column) => column);

  GeneratedColumn<String> get host =>
      $composableBuilder(column: $table.host, builder: (column) => column);

  GeneratedColumn<int> get port =>
      $composableBuilder(column: $table.port, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<bool> get useTls =>
      $composableBuilder(column: $table.useTls, builder: (column) => column);

  GeneratedColumn<String> get prefix =>
      $composableBuilder(column: $table.prefix, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get settings =>
      $composableBuilder(column: $table.settings, builder: (column) => column);

  GeneratedColumn<String> get cloudNodeId => $composableBuilder(
    column: $table.cloudNodeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> devicesRefs<T extends Object>(
    Expression<T> Function($$DevicesTableAnnotationComposer a) f,
  ) {
    final $$DevicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.networkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableAnnotationComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NetworksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NetworksTable,
          NetworkRow,
          $$NetworksTableFilterComposer,
          $$NetworksTableOrderingComposer,
          $$NetworksTableAnnotationComposer,
          $$NetworksTableCreateCompanionBuilder,
          $$NetworksTableUpdateCompanionBuilder,
          (NetworkRow, $$NetworksTableReferences),
          NetworkRow,
          PrefetchHooks Function({bool devicesRefs})
        > {
  $$NetworksTableTableManager(_$AppDatabase db, $NetworksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NetworksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NetworksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NetworksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> protocol = const Value.absent(),
                Value<String> host = const Value.absent(),
                Value<int> port = const Value.absent(),
                Value<String?> username = const Value.absent(),
                Value<String?> password = const Value.absent(),
                Value<bool> useTls = const Value.absent(),
                Value<String> prefix = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> settings = const Value.absent(),
                Value<String?> cloudNodeId = const Value.absent(),
                Value<String?> locationId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NetworksCompanion(
                id: id,
                name: name,
                protocol: protocol,
                host: host,
                port: port,
                username: username,
                password: password,
                useTls: useTls,
                prefix: prefix,
                enabled: enabled,
                description: description,
                settings: settings,
                cloudNodeId: cloudNodeId,
                locationId: locationId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> protocol = const Value.absent(),
                required String host,
                Value<int> port = const Value.absent(),
                Value<String?> username = const Value.absent(),
                Value<String?> password = const Value.absent(),
                Value<bool> useTls = const Value.absent(),
                Value<String> prefix = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> settings = const Value.absent(),
                Value<String?> cloudNodeId = const Value.absent(),
                Value<String?> locationId = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => NetworksCompanion.insert(
                id: id,
                name: name,
                protocol: protocol,
                host: host,
                port: port,
                username: username,
                password: password,
                useTls: useTls,
                prefix: prefix,
                enabled: enabled,
                description: description,
                settings: settings,
                cloudNodeId: cloudNodeId,
                locationId: locationId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$NetworksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({devicesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (devicesRefs) db.devices],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (devicesRefs)
                    await $_getPrefetchedData<
                      NetworkRow,
                      $NetworksTable,
                      DeviceRow
                    >(
                      currentTable: table,
                      referencedTable: $$NetworksTableReferences
                          ._devicesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$NetworksTableReferences(db, table, p0).devicesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.networkId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$NetworksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NetworksTable,
      NetworkRow,
      $$NetworksTableFilterComposer,
      $$NetworksTableOrderingComposer,
      $$NetworksTableAnnotationComposer,
      $$NetworksTableCreateCompanionBuilder,
      $$NetworksTableUpdateCompanionBuilder,
      (NetworkRow, $$NetworksTableReferences),
      NetworkRow,
      PrefetchHooks Function({bool devicesRefs})
    >;
typedef $$DevicesTableCreateCompanionBuilder =
    DevicesCompanion Function({
      required String id,
      required String networkId,
      required String name,
      Value<String?> type,
      Value<String> topicPrefix,
      Value<String?> host,
      Value<int?> port,
      Value<String?> serialPort,
      Value<int?> baudRate,
      Value<String?> username,
      Value<String?> password,
      Value<String?> description,
      Value<List<String>> tags,
      Value<Map<String, dynamic>> metadata,
      Value<String?> cloudNodeId,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$DevicesTableUpdateCompanionBuilder =
    DevicesCompanion Function({
      Value<String> id,
      Value<String> networkId,
      Value<String> name,
      Value<String?> type,
      Value<String> topicPrefix,
      Value<String?> host,
      Value<int?> port,
      Value<String?> serialPort,
      Value<int?> baudRate,
      Value<String?> username,
      Value<String?> password,
      Value<String?> description,
      Value<List<String>> tags,
      Value<Map<String, dynamic>> metadata,
      Value<String?> cloudNodeId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$DevicesTableReferences
    extends BaseReferences<_$AppDatabase, $DevicesTable, DeviceRow> {
  $$DevicesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NetworksTable _networkIdTable(_$AppDatabase db) => db.networks
      .createAlias($_aliasNameGenerator(db.devices.networkId, db.networks.id));

  $$NetworksTableProcessedTableManager get networkId {
    final $_column = $_itemColumn<String>('network_id')!;

    final manager = $$NetworksTableTableManager(
      $_db,
      $_db.networks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_networkIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PointsTable, List<PointRow>> _pointsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.points,
    aliasName: $_aliasNameGenerator(db.devices.id, db.points.deviceId),
  );

  $$PointsTableProcessedTableManager get pointsRefs {
    final manager = $$PointsTableTableManager(
      $_db,
      $_db.points,
    ).filter((f) => f.deviceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_pointsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DevicesTableFilterComposer
    extends Composer<_$AppDatabase, $DevicesTable> {
  $$DevicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topicPrefix => $composableBuilder(
    column: $table.topicPrefix,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get host => $composableBuilder(
    column: $table.host,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serialPort => $composableBuilder(
    column: $table.serialPort,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get baudRate => $composableBuilder(
    column: $table.baudRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String> get tags =>
      $composableBuilder(
        column: $table.tags,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<
    Map<String, dynamic>,
    Map<String, dynamic>,
    String
  >
  get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get cloudNodeId => $composableBuilder(
    column: $table.cloudNodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$NetworksTableFilterComposer get networkId {
    final $$NetworksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.networkId,
      referencedTable: $db.networks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NetworksTableFilterComposer(
            $db: $db,
            $table: $db.networks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> pointsRefs(
    Expression<bool> Function($$PointsTableFilterComposer f) f,
  ) {
    final $$PointsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.points,
      getReferencedColumn: (t) => t.deviceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PointsTableFilterComposer(
            $db: $db,
            $table: $db.points,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DevicesTableOrderingComposer
    extends Composer<_$AppDatabase, $DevicesTable> {
  $$DevicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topicPrefix => $composableBuilder(
    column: $table.topicPrefix,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get host => $composableBuilder(
    column: $table.host,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serialPort => $composableBuilder(
    column: $table.serialPort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baudRate => $composableBuilder(
    column: $table.baudRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cloudNodeId => $composableBuilder(
    column: $table.cloudNodeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$NetworksTableOrderingComposer get networkId {
    final $$NetworksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.networkId,
      referencedTable: $db.networks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NetworksTableOrderingComposer(
            $db: $db,
            $table: $db.networks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DevicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DevicesTable> {
  $$DevicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get topicPrefix => $composableBuilder(
    column: $table.topicPrefix,
    builder: (column) => column,
  );

  GeneratedColumn<String> get host =>
      $composableBuilder(column: $table.host, builder: (column) => column);

  GeneratedColumn<int> get port =>
      $composableBuilder(column: $table.port, builder: (column) => column);

  GeneratedColumn<String> get serialPort => $composableBuilder(
    column: $table.serialPort,
    builder: (column) => column,
  );

  GeneratedColumn<int> get baudRate =>
      $composableBuilder(column: $table.baudRate, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>, String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<String> get cloudNodeId => $composableBuilder(
    column: $table.cloudNodeId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$NetworksTableAnnotationComposer get networkId {
    final $$NetworksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.networkId,
      referencedTable: $db.networks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NetworksTableAnnotationComposer(
            $db: $db,
            $table: $db.networks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> pointsRefs<T extends Object>(
    Expression<T> Function($$PointsTableAnnotationComposer a) f,
  ) {
    final $$PointsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.points,
      getReferencedColumn: (t) => t.deviceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PointsTableAnnotationComposer(
            $db: $db,
            $table: $db.points,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DevicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DevicesTable,
          DeviceRow,
          $$DevicesTableFilterComposer,
          $$DevicesTableOrderingComposer,
          $$DevicesTableAnnotationComposer,
          $$DevicesTableCreateCompanionBuilder,
          $$DevicesTableUpdateCompanionBuilder,
          (DeviceRow, $$DevicesTableReferences),
          DeviceRow,
          PrefetchHooks Function({bool networkId, bool pointsRefs})
        > {
  $$DevicesTableTableManager(_$AppDatabase db, $DevicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DevicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DevicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DevicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> networkId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> type = const Value.absent(),
                Value<String> topicPrefix = const Value.absent(),
                Value<String?> host = const Value.absent(),
                Value<int?> port = const Value.absent(),
                Value<String?> serialPort = const Value.absent(),
                Value<int?> baudRate = const Value.absent(),
                Value<String?> username = const Value.absent(),
                Value<String?> password = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<List<String>> tags = const Value.absent(),
                Value<Map<String, dynamic>> metadata = const Value.absent(),
                Value<String?> cloudNodeId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DevicesCompanion(
                id: id,
                networkId: networkId,
                name: name,
                type: type,
                topicPrefix: topicPrefix,
                host: host,
                port: port,
                serialPort: serialPort,
                baudRate: baudRate,
                username: username,
                password: password,
                description: description,
                tags: tags,
                metadata: metadata,
                cloudNodeId: cloudNodeId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String networkId,
                required String name,
                Value<String?> type = const Value.absent(),
                Value<String> topicPrefix = const Value.absent(),
                Value<String?> host = const Value.absent(),
                Value<int?> port = const Value.absent(),
                Value<String?> serialPort = const Value.absent(),
                Value<int?> baudRate = const Value.absent(),
                Value<String?> username = const Value.absent(),
                Value<String?> password = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<List<String>> tags = const Value.absent(),
                Value<Map<String, dynamic>> metadata = const Value.absent(),
                Value<String?> cloudNodeId = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => DevicesCompanion.insert(
                id: id,
                networkId: networkId,
                name: name,
                type: type,
                topicPrefix: topicPrefix,
                host: host,
                port: port,
                serialPort: serialPort,
                baudRate: baudRate,
                username: username,
                password: password,
                description: description,
                tags: tags,
                metadata: metadata,
                cloudNodeId: cloudNodeId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DevicesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({networkId = false, pointsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (pointsRefs) db.points],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (networkId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.networkId,
                                referencedTable: $$DevicesTableReferences
                                    ._networkIdTable(db),
                                referencedColumn: $$DevicesTableReferences
                                    ._networkIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (pointsRefs)
                    await $_getPrefetchedData<
                      DeviceRow,
                      $DevicesTable,
                      PointRow
                    >(
                      currentTable: table,
                      referencedTable: $$DevicesTableReferences
                          ._pointsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DevicesTableReferences(db, table, p0).pointsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.deviceId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DevicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DevicesTable,
      DeviceRow,
      $$DevicesTableFilterComposer,
      $$DevicesTableOrderingComposer,
      $$DevicesTableAnnotationComposer,
      $$DevicesTableCreateCompanionBuilder,
      $$DevicesTableUpdateCompanionBuilder,
      (DeviceRow, $$DevicesTableReferences),
      DeviceRow,
      PrefetchHooks Function({bool networkId, bool pointsRefs})
    >;
typedef $$PointsTableCreateCompanionBuilder =
    PointsCompanion Function({
      required String id,
      required String deviceId,
      required String name,
      required String topic,
      Value<String> valueType,
      Value<String> mode,
      Value<double?> min,
      Value<double?> max,
      Value<String?> unit,
      Value<String> writeWidget,
      Value<String> readStrategy,
      Value<int> pollIntervalSecs,
      Value<String> historyType,
      Value<double?> covThreshold,
      Value<int> historyIntervalSecs,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$PointsTableUpdateCompanionBuilder =
    PointsCompanion Function({
      Value<String> id,
      Value<String> deviceId,
      Value<String> name,
      Value<String> topic,
      Value<String> valueType,
      Value<String> mode,
      Value<double?> min,
      Value<double?> max,
      Value<String?> unit,
      Value<String> writeWidget,
      Value<String> readStrategy,
      Value<int> pollIntervalSecs,
      Value<String> historyType,
      Value<double?> covThreshold,
      Value<int> historyIntervalSecs,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$PointsTableReferences
    extends BaseReferences<_$AppDatabase, $PointsTable, PointRow> {
  $$PointsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DevicesTable _deviceIdTable(_$AppDatabase db) => db.devices
      .createAlias($_aliasNameGenerator(db.points.deviceId, db.devices.id));

  $$DevicesTableProcessedTableManager get deviceId {
    final $_column = $_itemColumn<String>('device_id')!;

    final manager = $$DevicesTableTableManager(
      $_db,
      $_db.devices,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_deviceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ScheduleBindingsTable, List<ScheduleBindingRow>>
  _scheduleBindingsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.scheduleBindings,
    aliasName: $_aliasNameGenerator(db.points.id, db.scheduleBindings.pointId),
  );

  $$ScheduleBindingsTableProcessedTableManager get scheduleBindingsRefs {
    final manager = $$ScheduleBindingsTableTableManager(
      $_db,
      $_db.scheduleBindings,
    ).filter((f) => f.pointId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _scheduleBindingsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PointsTableFilterComposer
    extends Composer<_$AppDatabase, $PointsTable> {
  $$PointsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topic => $composableBuilder(
    column: $table.topic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valueType => $composableBuilder(
    column: $table.valueType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get min => $composableBuilder(
    column: $table.min,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get max => $composableBuilder(
    column: $table.max,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get writeWidget => $composableBuilder(
    column: $table.writeWidget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get readStrategy => $composableBuilder(
    column: $table.readStrategy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pollIntervalSecs => $composableBuilder(
    column: $table.pollIntervalSecs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get historyType => $composableBuilder(
    column: $table.historyType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get covThreshold => $composableBuilder(
    column: $table.covThreshold,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get historyIntervalSecs => $composableBuilder(
    column: $table.historyIntervalSecs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DevicesTableFilterComposer get deviceId {
    final $$DevicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deviceId,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableFilterComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> scheduleBindingsRefs(
    Expression<bool> Function($$ScheduleBindingsTableFilterComposer f) f,
  ) {
    final $$ScheduleBindingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scheduleBindings,
      getReferencedColumn: (t) => t.pointId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduleBindingsTableFilterComposer(
            $db: $db,
            $table: $db.scheduleBindings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PointsTableOrderingComposer
    extends Composer<_$AppDatabase, $PointsTable> {
  $$PointsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topic => $composableBuilder(
    column: $table.topic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueType => $composableBuilder(
    column: $table.valueType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get min => $composableBuilder(
    column: $table.min,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get max => $composableBuilder(
    column: $table.max,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get writeWidget => $composableBuilder(
    column: $table.writeWidget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get readStrategy => $composableBuilder(
    column: $table.readStrategy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pollIntervalSecs => $composableBuilder(
    column: $table.pollIntervalSecs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get historyType => $composableBuilder(
    column: $table.historyType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get covThreshold => $composableBuilder(
    column: $table.covThreshold,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get historyIntervalSecs => $composableBuilder(
    column: $table.historyIntervalSecs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DevicesTableOrderingComposer get deviceId {
    final $$DevicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deviceId,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableOrderingComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PointsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PointsTable> {
  $$PointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get topic =>
      $composableBuilder(column: $table.topic, builder: (column) => column);

  GeneratedColumn<String> get valueType =>
      $composableBuilder(column: $table.valueType, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<double> get min =>
      $composableBuilder(column: $table.min, builder: (column) => column);

  GeneratedColumn<double> get max =>
      $composableBuilder(column: $table.max, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get writeWidget => $composableBuilder(
    column: $table.writeWidget,
    builder: (column) => column,
  );

  GeneratedColumn<String> get readStrategy => $composableBuilder(
    column: $table.readStrategy,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pollIntervalSecs => $composableBuilder(
    column: $table.pollIntervalSecs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get historyType => $composableBuilder(
    column: $table.historyType,
    builder: (column) => column,
  );

  GeneratedColumn<double> get covThreshold => $composableBuilder(
    column: $table.covThreshold,
    builder: (column) => column,
  );

  GeneratedColumn<int> get historyIntervalSecs => $composableBuilder(
    column: $table.historyIntervalSecs,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$DevicesTableAnnotationComposer get deviceId {
    final $$DevicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deviceId,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableAnnotationComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> scheduleBindingsRefs<T extends Object>(
    Expression<T> Function($$ScheduleBindingsTableAnnotationComposer a) f,
  ) {
    final $$ScheduleBindingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scheduleBindings,
      getReferencedColumn: (t) => t.pointId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduleBindingsTableAnnotationComposer(
            $db: $db,
            $table: $db.scheduleBindings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PointsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PointsTable,
          PointRow,
          $$PointsTableFilterComposer,
          $$PointsTableOrderingComposer,
          $$PointsTableAnnotationComposer,
          $$PointsTableCreateCompanionBuilder,
          $$PointsTableUpdateCompanionBuilder,
          (PointRow, $$PointsTableReferences),
          PointRow,
          PrefetchHooks Function({bool deviceId, bool scheduleBindingsRefs})
        > {
  $$PointsTableTableManager(_$AppDatabase db, $PointsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PointsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PointsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> topic = const Value.absent(),
                Value<String> valueType = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<double?> min = const Value.absent(),
                Value<double?> max = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<String> writeWidget = const Value.absent(),
                Value<String> readStrategy = const Value.absent(),
                Value<int> pollIntervalSecs = const Value.absent(),
                Value<String> historyType = const Value.absent(),
                Value<double?> covThreshold = const Value.absent(),
                Value<int> historyIntervalSecs = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PointsCompanion(
                id: id,
                deviceId: deviceId,
                name: name,
                topic: topic,
                valueType: valueType,
                mode: mode,
                min: min,
                max: max,
                unit: unit,
                writeWidget: writeWidget,
                readStrategy: readStrategy,
                pollIntervalSecs: pollIntervalSecs,
                historyType: historyType,
                covThreshold: covThreshold,
                historyIntervalSecs: historyIntervalSecs,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String deviceId,
                required String name,
                required String topic,
                Value<String> valueType = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<double?> min = const Value.absent(),
                Value<double?> max = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<String> writeWidget = const Value.absent(),
                Value<String> readStrategy = const Value.absent(),
                Value<int> pollIntervalSecs = const Value.absent(),
                Value<String> historyType = const Value.absent(),
                Value<double?> covThreshold = const Value.absent(),
                Value<int> historyIntervalSecs = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => PointsCompanion.insert(
                id: id,
                deviceId: deviceId,
                name: name,
                topic: topic,
                valueType: valueType,
                mode: mode,
                min: min,
                max: max,
                unit: unit,
                writeWidget: writeWidget,
                readStrategy: readStrategy,
                pollIntervalSecs: pollIntervalSecs,
                historyType: historyType,
                covThreshold: covThreshold,
                historyIntervalSecs: historyIntervalSecs,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$PointsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({deviceId = false, scheduleBindingsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (scheduleBindingsRefs) db.scheduleBindings,
                  ],
                  addJoins:
                      <
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
                          dynamic
                        >
                      >(state) {
                        if (deviceId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.deviceId,
                                    referencedTable: $$PointsTableReferences
                                        ._deviceIdTable(db),
                                    referencedColumn: $$PointsTableReferences
                                        ._deviceIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (scheduleBindingsRefs)
                        await $_getPrefetchedData<
                          PointRow,
                          $PointsTable,
                          ScheduleBindingRow
                        >(
                          currentTable: table,
                          referencedTable: $$PointsTableReferences
                              ._scheduleBindingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PointsTableReferences(
                                db,
                                table,
                                p0,
                              ).scheduleBindingsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.pointId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PointsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PointsTable,
      PointRow,
      $$PointsTableFilterComposer,
      $$PointsTableOrderingComposer,
      $$PointsTableAnnotationComposer,
      $$PointsTableCreateCompanionBuilder,
      $$PointsTableUpdateCompanionBuilder,
      (PointRow, $$PointsTableReferences),
      PointRow,
      PrefetchHooks Function({bool deviceId, bool scheduleBindingsRefs})
    >;
typedef $$ScheduleEntriesTableCreateCompanionBuilder =
    ScheduleEntriesCompanion Function({
      required String id,
      required String name,
      required Schedule schedule,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ScheduleEntriesTableUpdateCompanionBuilder =
    ScheduleEntriesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<Schedule> schedule,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$ScheduleEntriesTableReferences
    extends
        BaseReferences<_$AppDatabase, $ScheduleEntriesTable, ScheduleEntryRow> {
  $$ScheduleEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ScheduleBindingsTable, List<ScheduleBindingRow>>
  _scheduleBindingsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.scheduleBindings,
    aliasName: $_aliasNameGenerator(
      db.scheduleEntries.id,
      db.scheduleBindings.scheduleId,
    ),
  );

  $$ScheduleBindingsTableProcessedTableManager get scheduleBindingsRefs {
    final manager = $$ScheduleBindingsTableTableManager(
      $_db,
      $_db.scheduleBindings,
    ).filter((f) => f.scheduleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _scheduleBindingsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ScheduleEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ScheduleEntriesTable> {
  $$ScheduleEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Schedule, Schedule, String> get schedule =>
      $composableBuilder(
        column: $table.schedule,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> scheduleBindingsRefs(
    Expression<bool> Function($$ScheduleBindingsTableFilterComposer f) f,
  ) {
    final $$ScheduleBindingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scheduleBindings,
      getReferencedColumn: (t) => t.scheduleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduleBindingsTableFilterComposer(
            $db: $db,
            $table: $db.scheduleBindings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ScheduleEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ScheduleEntriesTable> {
  $$ScheduleEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get schedule => $composableBuilder(
    column: $table.schedule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ScheduleEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScheduleEntriesTable> {
  $$ScheduleEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Schedule, String> get schedule =>
      $composableBuilder(column: $table.schedule, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> scheduleBindingsRefs<T extends Object>(
    Expression<T> Function($$ScheduleBindingsTableAnnotationComposer a) f,
  ) {
    final $$ScheduleBindingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scheduleBindings,
      getReferencedColumn: (t) => t.scheduleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduleBindingsTableAnnotationComposer(
            $db: $db,
            $table: $db.scheduleBindings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ScheduleEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScheduleEntriesTable,
          ScheduleEntryRow,
          $$ScheduleEntriesTableFilterComposer,
          $$ScheduleEntriesTableOrderingComposer,
          $$ScheduleEntriesTableAnnotationComposer,
          $$ScheduleEntriesTableCreateCompanionBuilder,
          $$ScheduleEntriesTableUpdateCompanionBuilder,
          (ScheduleEntryRow, $$ScheduleEntriesTableReferences),
          ScheduleEntryRow,
          PrefetchHooks Function({bool scheduleBindingsRefs})
        > {
  $$ScheduleEntriesTableTableManager(
    _$AppDatabase db,
    $ScheduleEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScheduleEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScheduleEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScheduleEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<Schedule> schedule = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScheduleEntriesCompanion(
                id: id,
                name: name,
                schedule: schedule,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required Schedule schedule,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ScheduleEntriesCompanion.insert(
                id: id,
                name: name,
                schedule: schedule,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ScheduleEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({scheduleBindingsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (scheduleBindingsRefs) db.scheduleBindings,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (scheduleBindingsRefs)
                    await $_getPrefetchedData<
                      ScheduleEntryRow,
                      $ScheduleEntriesTable,
                      ScheduleBindingRow
                    >(
                      currentTable: table,
                      referencedTable: $$ScheduleEntriesTableReferences
                          ._scheduleBindingsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ScheduleEntriesTableReferences(
                            db,
                            table,
                            p0,
                          ).scheduleBindingsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.scheduleId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ScheduleEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScheduleEntriesTable,
      ScheduleEntryRow,
      $$ScheduleEntriesTableFilterComposer,
      $$ScheduleEntriesTableOrderingComposer,
      $$ScheduleEntriesTableAnnotationComposer,
      $$ScheduleEntriesTableCreateCompanionBuilder,
      $$ScheduleEntriesTableUpdateCompanionBuilder,
      (ScheduleEntryRow, $$ScheduleEntriesTableReferences),
      ScheduleEntryRow,
      PrefetchHooks Function({bool scheduleBindingsRefs})
    >;
typedef $$ScheduleBindingsTableCreateCompanionBuilder =
    ScheduleBindingsCompanion Function({
      required String id,
      required String scheduleId,
      required String pointId,
      required String activeValue,
      required String inactiveValue,
      Value<bool> enabled,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ScheduleBindingsTableUpdateCompanionBuilder =
    ScheduleBindingsCompanion Function({
      Value<String> id,
      Value<String> scheduleId,
      Value<String> pointId,
      Value<String> activeValue,
      Value<String> inactiveValue,
      Value<bool> enabled,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$ScheduleBindingsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ScheduleBindingsTable,
          ScheduleBindingRow
        > {
  $$ScheduleBindingsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ScheduleEntriesTable _scheduleIdTable(_$AppDatabase db) =>
      db.scheduleEntries.createAlias(
        $_aliasNameGenerator(
          db.scheduleBindings.scheduleId,
          db.scheduleEntries.id,
        ),
      );

  $$ScheduleEntriesTableProcessedTableManager get scheduleId {
    final $_column = $_itemColumn<String>('schedule_id')!;

    final manager = $$ScheduleEntriesTableTableManager(
      $_db,
      $_db.scheduleEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_scheduleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PointsTable _pointIdTable(_$AppDatabase db) => db.points.createAlias(
    $_aliasNameGenerator(db.scheduleBindings.pointId, db.points.id),
  );

  $$PointsTableProcessedTableManager get pointId {
    final $_column = $_itemColumn<String>('point_id')!;

    final manager = $$PointsTableTableManager(
      $_db,
      $_db.points,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pointIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ScheduleBindingsTableFilterComposer
    extends Composer<_$AppDatabase, $ScheduleBindingsTable> {
  $$ScheduleBindingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activeValue => $composableBuilder(
    column: $table.activeValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inactiveValue => $composableBuilder(
    column: $table.inactiveValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ScheduleEntriesTableFilterComposer get scheduleId {
    final $$ScheduleEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scheduleId,
      referencedTable: $db.scheduleEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduleEntriesTableFilterComposer(
            $db: $db,
            $table: $db.scheduleEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PointsTableFilterComposer get pointId {
    final $$PointsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pointId,
      referencedTable: $db.points,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PointsTableFilterComposer(
            $db: $db,
            $table: $db.points,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScheduleBindingsTableOrderingComposer
    extends Composer<_$AppDatabase, $ScheduleBindingsTable> {
  $$ScheduleBindingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activeValue => $composableBuilder(
    column: $table.activeValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inactiveValue => $composableBuilder(
    column: $table.inactiveValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ScheduleEntriesTableOrderingComposer get scheduleId {
    final $$ScheduleEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scheduleId,
      referencedTable: $db.scheduleEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduleEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.scheduleEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PointsTableOrderingComposer get pointId {
    final $$PointsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pointId,
      referencedTable: $db.points,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PointsTableOrderingComposer(
            $db: $db,
            $table: $db.points,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScheduleBindingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScheduleBindingsTable> {
  $$ScheduleBindingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get activeValue => $composableBuilder(
    column: $table.activeValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get inactiveValue => $composableBuilder(
    column: $table.inactiveValue,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ScheduleEntriesTableAnnotationComposer get scheduleId {
    final $$ScheduleEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scheduleId,
      referencedTable: $db.scheduleEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduleEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.scheduleEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PointsTableAnnotationComposer get pointId {
    final $$PointsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pointId,
      referencedTable: $db.points,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PointsTableAnnotationComposer(
            $db: $db,
            $table: $db.points,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScheduleBindingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScheduleBindingsTable,
          ScheduleBindingRow,
          $$ScheduleBindingsTableFilterComposer,
          $$ScheduleBindingsTableOrderingComposer,
          $$ScheduleBindingsTableAnnotationComposer,
          $$ScheduleBindingsTableCreateCompanionBuilder,
          $$ScheduleBindingsTableUpdateCompanionBuilder,
          (ScheduleBindingRow, $$ScheduleBindingsTableReferences),
          ScheduleBindingRow,
          PrefetchHooks Function({bool scheduleId, bool pointId})
        > {
  $$ScheduleBindingsTableTableManager(
    _$AppDatabase db,
    $ScheduleBindingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScheduleBindingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScheduleBindingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScheduleBindingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> scheduleId = const Value.absent(),
                Value<String> pointId = const Value.absent(),
                Value<String> activeValue = const Value.absent(),
                Value<String> inactiveValue = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScheduleBindingsCompanion(
                id: id,
                scheduleId: scheduleId,
                pointId: pointId,
                activeValue: activeValue,
                inactiveValue: inactiveValue,
                enabled: enabled,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String scheduleId,
                required String pointId,
                required String activeValue,
                required String inactiveValue,
                Value<bool> enabled = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ScheduleBindingsCompanion.insert(
                id: id,
                scheduleId: scheduleId,
                pointId: pointId,
                activeValue: activeValue,
                inactiveValue: inactiveValue,
                enabled: enabled,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ScheduleBindingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({scheduleId = false, pointId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (scheduleId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.scheduleId,
                                referencedTable:
                                    $$ScheduleBindingsTableReferences
                                        ._scheduleIdTable(db),
                                referencedColumn:
                                    $$ScheduleBindingsTableReferences
                                        ._scheduleIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (pointId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.pointId,
                                referencedTable:
                                    $$ScheduleBindingsTableReferences
                                        ._pointIdTable(db),
                                referencedColumn:
                                    $$ScheduleBindingsTableReferences
                                        ._pointIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ScheduleBindingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScheduleBindingsTable,
      ScheduleBindingRow,
      $$ScheduleBindingsTableFilterComposer,
      $$ScheduleBindingsTableOrderingComposer,
      $$ScheduleBindingsTableAnnotationComposer,
      $$ScheduleBindingsTableCreateCompanionBuilder,
      $$ScheduleBindingsTableUpdateCompanionBuilder,
      (ScheduleBindingRow, $$ScheduleBindingsTableReferences),
      ScheduleBindingRow,
      PrefetchHooks Function({bool scheduleId, bool pointId})
    >;
typedef $$AlarmsTableCreateCompanionBuilder =
    AlarmsCompanion Function({
      required String id,
      Value<String?> pointId,
      Value<String?> networkId,
      required String type,
      Value<String> severity,
      required String message,
      Value<DateTime?> acknowledgedAt,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$AlarmsTableUpdateCompanionBuilder =
    AlarmsCompanion Function({
      Value<String> id,
      Value<String?> pointId,
      Value<String?> networkId,
      Value<String> type,
      Value<String> severity,
      Value<String> message,
      Value<DateTime?> acknowledgedAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$AlarmsTableFilterComposer
    extends Composer<_$AppDatabase, $AlarmsTable> {
  $$AlarmsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pointId => $composableBuilder(
    column: $table.pointId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get networkId => $composableBuilder(
    column: $table.networkId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get acknowledgedAt => $composableBuilder(
    column: $table.acknowledgedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AlarmsTableOrderingComposer
    extends Composer<_$AppDatabase, $AlarmsTable> {
  $$AlarmsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pointId => $composableBuilder(
    column: $table.pointId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get networkId => $composableBuilder(
    column: $table.networkId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get acknowledgedAt => $composableBuilder(
    column: $table.acknowledgedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AlarmsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlarmsTable> {
  $$AlarmsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get pointId =>
      $composableBuilder(column: $table.pointId, builder: (column) => column);

  GeneratedColumn<String> get networkId =>
      $composableBuilder(column: $table.networkId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<DateTime> get acknowledgedAt => $composableBuilder(
    column: $table.acknowledgedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AlarmsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AlarmsTable,
          AlarmRow,
          $$AlarmsTableFilterComposer,
          $$AlarmsTableOrderingComposer,
          $$AlarmsTableAnnotationComposer,
          $$AlarmsTableCreateCompanionBuilder,
          $$AlarmsTableUpdateCompanionBuilder,
          (AlarmRow, BaseReferences<_$AppDatabase, $AlarmsTable, AlarmRow>),
          AlarmRow,
          PrefetchHooks Function()
        > {
  $$AlarmsTableTableManager(_$AppDatabase db, $AlarmsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlarmsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlarmsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlarmsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> pointId = const Value.absent(),
                Value<String?> networkId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> severity = const Value.absent(),
                Value<String> message = const Value.absent(),
                Value<DateTime?> acknowledgedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AlarmsCompanion(
                id: id,
                pointId: pointId,
                networkId: networkId,
                type: type,
                severity: severity,
                message: message,
                acknowledgedAt: acknowledgedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> pointId = const Value.absent(),
                Value<String?> networkId = const Value.absent(),
                required String type,
                Value<String> severity = const Value.absent(),
                required String message,
                Value<DateTime?> acknowledgedAt = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => AlarmsCompanion.insert(
                id: id,
                pointId: pointId,
                networkId: networkId,
                type: type,
                severity: severity,
                message: message,
                acknowledgedAt: acknowledgedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AlarmsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AlarmsTable,
      AlarmRow,
      $$AlarmsTableFilterComposer,
      $$AlarmsTableOrderingComposer,
      $$AlarmsTableAnnotationComposer,
      $$AlarmsTableCreateCompanionBuilder,
      $$AlarmsTableUpdateCompanionBuilder,
      (AlarmRow, BaseReferences<_$AppDatabase, $AlarmsTable, AlarmRow>),
      AlarmRow,
      PrefetchHooks Function()
    >;
typedef $$PagesTableCreateCompanionBuilder =
    PagesCompanion Function({
      required String id,
      required String name,
      Value<String?> icon,
      Value<int> sortOrder,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$PagesTableUpdateCompanionBuilder =
    PagesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> icon,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$PagesTableReferences
    extends BaseReferences<_$AppDatabase, $PagesTable, PageRow> {
  $$PagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WidgetsTable, List<WidgetRow>> _widgetsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.widgets,
    aliasName: $_aliasNameGenerator(db.pages.id, db.widgets.pageId),
  );

  $$WidgetsTableProcessedTableManager get widgetsRefs {
    final manager = $$WidgetsTableTableManager(
      $_db,
      $_db.widgets,
    ).filter((f) => f.pageId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_widgetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PagesTableFilterComposer extends Composer<_$AppDatabase, $PagesTable> {
  $$PagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> widgetsRefs(
    Expression<bool> Function($$WidgetsTableFilterComposer f) f,
  ) {
    final $$WidgetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.widgets,
      getReferencedColumn: (t) => t.pageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WidgetsTableFilterComposer(
            $db: $db,
            $table: $db.widgets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PagesTableOrderingComposer
    extends Composer<_$AppDatabase, $PagesTable> {
  $$PagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PagesTable> {
  $$PagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> widgetsRefs<T extends Object>(
    Expression<T> Function($$WidgetsTableAnnotationComposer a) f,
  ) {
    final $$WidgetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.widgets,
      getReferencedColumn: (t) => t.pageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WidgetsTableAnnotationComposer(
            $db: $db,
            $table: $db.widgets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PagesTable,
          PageRow,
          $$PagesTableFilterComposer,
          $$PagesTableOrderingComposer,
          $$PagesTableAnnotationComposer,
          $$PagesTableCreateCompanionBuilder,
          $$PagesTableUpdateCompanionBuilder,
          (PageRow, $$PagesTableReferences),
          PageRow,
          PrefetchHooks Function({bool widgetsRefs})
        > {
  $$PagesTableTableManager(_$AppDatabase db, $PagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PagesCompanion(
                id: id,
                name: name,
                icon: icon,
                sortOrder: sortOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> icon = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => PagesCompanion.insert(
                id: id,
                name: name,
                icon: icon,
                sortOrder: sortOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$PagesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({widgetsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (widgetsRefs) db.widgets],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (widgetsRefs)
                    await $_getPrefetchedData<PageRow, $PagesTable, WidgetRow>(
                      currentTable: table,
                      referencedTable: $$PagesTableReferences._widgetsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$PagesTableReferences(db, table, p0).widgetsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.pageId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PagesTable,
      PageRow,
      $$PagesTableFilterComposer,
      $$PagesTableOrderingComposer,
      $$PagesTableAnnotationComposer,
      $$PagesTableCreateCompanionBuilder,
      $$PagesTableUpdateCompanionBuilder,
      (PageRow, $$PagesTableReferences),
      PageRow,
      PrefetchHooks Function({bool widgetsRefs})
    >;
typedef $$WidgetsTableCreateCompanionBuilder =
    WidgetsCompanion Function({
      required String id,
      required String pageId,
      required String type,
      Value<String?> pointId,
      Value<String?> scheduleId,
      required String title,
      Value<int> sortOrder,
      Value<Map<String, dynamic>> config,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$WidgetsTableUpdateCompanionBuilder =
    WidgetsCompanion Function({
      Value<String> id,
      Value<String> pageId,
      Value<String> type,
      Value<String?> pointId,
      Value<String?> scheduleId,
      Value<String> title,
      Value<int> sortOrder,
      Value<Map<String, dynamic>> config,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$WidgetsTableReferences
    extends BaseReferences<_$AppDatabase, $WidgetsTable, WidgetRow> {
  $$WidgetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PagesTable _pageIdTable(_$AppDatabase db) => db.pages.createAlias(
    $_aliasNameGenerator(db.widgets.pageId, db.pages.id),
  );

  $$PagesTableProcessedTableManager get pageId {
    final $_column = $_itemColumn<String>('page_id')!;

    final manager = $$PagesTableTableManager(
      $_db,
      $_db.pages,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WidgetsTableFilterComposer
    extends Composer<_$AppDatabase, $WidgetsTable> {
  $$WidgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pointId => $composableBuilder(
    column: $table.pointId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scheduleId => $composableBuilder(
    column: $table.scheduleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, dynamic>,
    Map<String, dynamic>,
    String
  >
  get config => $composableBuilder(
    column: $table.config,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PagesTableFilterComposer get pageId {
    final $$PagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pageId,
      referencedTable: $db.pages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PagesTableFilterComposer(
            $db: $db,
            $table: $db.pages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WidgetsTableOrderingComposer
    extends Composer<_$AppDatabase, $WidgetsTable> {
  $$WidgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pointId => $composableBuilder(
    column: $table.pointId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scheduleId => $composableBuilder(
    column: $table.scheduleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get config => $composableBuilder(
    column: $table.config,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PagesTableOrderingComposer get pageId {
    final $$PagesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pageId,
      referencedTable: $db.pages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PagesTableOrderingComposer(
            $db: $db,
            $table: $db.pages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WidgetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WidgetsTable> {
  $$WidgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get pointId =>
      $composableBuilder(column: $table.pointId, builder: (column) => column);

  GeneratedColumn<String> get scheduleId => $composableBuilder(
    column: $table.scheduleId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String> get config =>
      $composableBuilder(column: $table.config, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$PagesTableAnnotationComposer get pageId {
    final $$PagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pageId,
      referencedTable: $db.pages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PagesTableAnnotationComposer(
            $db: $db,
            $table: $db.pages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WidgetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WidgetsTable,
          WidgetRow,
          $$WidgetsTableFilterComposer,
          $$WidgetsTableOrderingComposer,
          $$WidgetsTableAnnotationComposer,
          $$WidgetsTableCreateCompanionBuilder,
          $$WidgetsTableUpdateCompanionBuilder,
          (WidgetRow, $$WidgetsTableReferences),
          WidgetRow,
          PrefetchHooks Function({bool pageId})
        > {
  $$WidgetsTableTableManager(_$AppDatabase db, $WidgetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WidgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WidgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WidgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> pageId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> pointId = const Value.absent(),
                Value<String?> scheduleId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<Map<String, dynamic>> config = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WidgetsCompanion(
                id: id,
                pageId: pageId,
                type: type,
                pointId: pointId,
                scheduleId: scheduleId,
                title: title,
                sortOrder: sortOrder,
                config: config,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String pageId,
                required String type,
                Value<String?> pointId = const Value.absent(),
                Value<String?> scheduleId = const Value.absent(),
                required String title,
                Value<int> sortOrder = const Value.absent(),
                Value<Map<String, dynamic>> config = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => WidgetsCompanion.insert(
                id: id,
                pageId: pageId,
                type: type,
                pointId: pointId,
                scheduleId: scheduleId,
                title: title,
                sortOrder: sortOrder,
                config: config,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WidgetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({pageId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (pageId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.pageId,
                                referencedTable: $$WidgetsTableReferences
                                    ._pageIdTable(db),
                                referencedColumn: $$WidgetsTableReferences
                                    ._pageIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WidgetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WidgetsTable,
      WidgetRow,
      $$WidgetsTableFilterComposer,
      $$WidgetsTableOrderingComposer,
      $$WidgetsTableAnnotationComposer,
      $$WidgetsTableCreateCompanionBuilder,
      $$WidgetsTableUpdateCompanionBuilder,
      (WidgetRow, $$WidgetsTableReferences),
      WidgetRow,
      PrefetchHooks Function({bool pageId})
    >;
typedef $$PointHistoryTableCreateCompanionBuilder =
    PointHistoryCompanion Function({
      Value<int> id,
      required String pointId,
      Value<double?> value,
      Value<String?> stringValue,
      required DateTime timestamp,
    });
typedef $$PointHistoryTableUpdateCompanionBuilder =
    PointHistoryCompanion Function({
      Value<int> id,
      Value<String> pointId,
      Value<double?> value,
      Value<String?> stringValue,
      Value<DateTime> timestamp,
    });

class $$PointHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $PointHistoryTable> {
  $$PointHistoryTableFilterComposer({
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

  ColumnFilters<String> get pointId => $composableBuilder(
    column: $table.pointId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stringValue => $composableBuilder(
    column: $table.stringValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PointHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $PointHistoryTable> {
  $$PointHistoryTableOrderingComposer({
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

  ColumnOrderings<String> get pointId => $composableBuilder(
    column: $table.pointId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stringValue => $composableBuilder(
    column: $table.stringValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PointHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $PointHistoryTable> {
  $$PointHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get pointId =>
      $composableBuilder(column: $table.pointId, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get stringValue => $composableBuilder(
    column: $table.stringValue,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$PointHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PointHistoryTable,
          PointHistoryRow,
          $$PointHistoryTableFilterComposer,
          $$PointHistoryTableOrderingComposer,
          $$PointHistoryTableAnnotationComposer,
          $$PointHistoryTableCreateCompanionBuilder,
          $$PointHistoryTableUpdateCompanionBuilder,
          (
            PointHistoryRow,
            BaseReferences<_$AppDatabase, $PointHistoryTable, PointHistoryRow>,
          ),
          PointHistoryRow,
          PrefetchHooks Function()
        > {
  $$PointHistoryTableTableManager(_$AppDatabase db, $PointHistoryTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PointHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PointHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PointHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> pointId = const Value.absent(),
                Value<double?> value = const Value.absent(),
                Value<String?> stringValue = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => PointHistoryCompanion(
                id: id,
                pointId: pointId,
                value: value,
                stringValue: stringValue,
                timestamp: timestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String pointId,
                Value<double?> value = const Value.absent(),
                Value<String?> stringValue = const Value.absent(),
                required DateTime timestamp,
              }) => PointHistoryCompanion.insert(
                id: id,
                pointId: pointId,
                value: value,
                stringValue: stringValue,
                timestamp: timestamp,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PointHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PointHistoryTable,
      PointHistoryRow,
      $$PointHistoryTableFilterComposer,
      $$PointHistoryTableOrderingComposer,
      $$PointHistoryTableAnnotationComposer,
      $$PointHistoryTableCreateCompanionBuilder,
      $$PointHistoryTableUpdateCompanionBuilder,
      (
        PointHistoryRow,
        BaseReferences<_$AppDatabase, $PointHistoryTable, PointHistoryRow>,
      ),
      PointHistoryRow,
      PrefetchHooks Function()
    >;
typedef $$RuntimeFlowsTableCreateCompanionBuilder =
    RuntimeFlowsCompanion Function({
      required String id,
      Value<String> name,
      Value<bool> enabled,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$RuntimeFlowsTableUpdateCompanionBuilder =
    RuntimeFlowsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<bool> enabled,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$RuntimeFlowsTableReferences
    extends BaseReferences<_$AppDatabase, $RuntimeFlowsTable, RuntimeFlowRow> {
  $$RuntimeFlowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RuntimeNodesTable, List<RuntimeNodeRow>>
  _runtimeNodesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.runtimeNodes,
    aliasName: $_aliasNameGenerator(db.runtimeFlows.id, db.runtimeNodes.flowId),
  );

  $$RuntimeNodesTableProcessedTableManager get runtimeNodesRefs {
    final manager = $$RuntimeNodesTableTableManager(
      $_db,
      $_db.runtimeNodes,
    ).filter((f) => f.flowId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_runtimeNodesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RuntimeEdgesTable, List<RuntimeEdgeRow>>
  _runtimeEdgesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.runtimeEdges,
    aliasName: $_aliasNameGenerator(db.runtimeFlows.id, db.runtimeEdges.flowId),
  );

  $$RuntimeEdgesTableProcessedTableManager get runtimeEdgesRefs {
    final manager = $$RuntimeEdgesTableTableManager(
      $_db,
      $_db.runtimeEdges,
    ).filter((f) => f.flowId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_runtimeEdgesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RuntimeFlowsTableFilterComposer
    extends Composer<_$AppDatabase, $RuntimeFlowsTable> {
  $$RuntimeFlowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> runtimeNodesRefs(
    Expression<bool> Function($$RuntimeNodesTableFilterComposer f) f,
  ) {
    final $$RuntimeNodesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.runtimeNodes,
      getReferencedColumn: (t) => t.flowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RuntimeNodesTableFilterComposer(
            $db: $db,
            $table: $db.runtimeNodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> runtimeEdgesRefs(
    Expression<bool> Function($$RuntimeEdgesTableFilterComposer f) f,
  ) {
    final $$RuntimeEdgesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.runtimeEdges,
      getReferencedColumn: (t) => t.flowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RuntimeEdgesTableFilterComposer(
            $db: $db,
            $table: $db.runtimeEdges,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RuntimeFlowsTableOrderingComposer
    extends Composer<_$AppDatabase, $RuntimeFlowsTable> {
  $$RuntimeFlowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RuntimeFlowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RuntimeFlowsTable> {
  $$RuntimeFlowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> runtimeNodesRefs<T extends Object>(
    Expression<T> Function($$RuntimeNodesTableAnnotationComposer a) f,
  ) {
    final $$RuntimeNodesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.runtimeNodes,
      getReferencedColumn: (t) => t.flowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RuntimeNodesTableAnnotationComposer(
            $db: $db,
            $table: $db.runtimeNodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> runtimeEdgesRefs<T extends Object>(
    Expression<T> Function($$RuntimeEdgesTableAnnotationComposer a) f,
  ) {
    final $$RuntimeEdgesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.runtimeEdges,
      getReferencedColumn: (t) => t.flowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RuntimeEdgesTableAnnotationComposer(
            $db: $db,
            $table: $db.runtimeEdges,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RuntimeFlowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RuntimeFlowsTable,
          RuntimeFlowRow,
          $$RuntimeFlowsTableFilterComposer,
          $$RuntimeFlowsTableOrderingComposer,
          $$RuntimeFlowsTableAnnotationComposer,
          $$RuntimeFlowsTableCreateCompanionBuilder,
          $$RuntimeFlowsTableUpdateCompanionBuilder,
          (RuntimeFlowRow, $$RuntimeFlowsTableReferences),
          RuntimeFlowRow,
          PrefetchHooks Function({bool runtimeNodesRefs, bool runtimeEdgesRefs})
        > {
  $$RuntimeFlowsTableTableManager(_$AppDatabase db, $RuntimeFlowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RuntimeFlowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RuntimeFlowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RuntimeFlowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RuntimeFlowsCompanion(
                id: id,
                name: name,
                enabled: enabled,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> name = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RuntimeFlowsCompanion.insert(
                id: id,
                name: name,
                enabled: enabled,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RuntimeFlowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({runtimeNodesRefs = false, runtimeEdgesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (runtimeNodesRefs) db.runtimeNodes,
                    if (runtimeEdgesRefs) db.runtimeEdges,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (runtimeNodesRefs)
                        await $_getPrefetchedData<
                          RuntimeFlowRow,
                          $RuntimeFlowsTable,
                          RuntimeNodeRow
                        >(
                          currentTable: table,
                          referencedTable: $$RuntimeFlowsTableReferences
                              ._runtimeNodesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RuntimeFlowsTableReferences(
                                db,
                                table,
                                p0,
                              ).runtimeNodesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.flowId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (runtimeEdgesRefs)
                        await $_getPrefetchedData<
                          RuntimeFlowRow,
                          $RuntimeFlowsTable,
                          RuntimeEdgeRow
                        >(
                          currentTable: table,
                          referencedTable: $$RuntimeFlowsTableReferences
                              ._runtimeEdgesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RuntimeFlowsTableReferences(
                                db,
                                table,
                                p0,
                              ).runtimeEdgesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.flowId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RuntimeFlowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RuntimeFlowsTable,
      RuntimeFlowRow,
      $$RuntimeFlowsTableFilterComposer,
      $$RuntimeFlowsTableOrderingComposer,
      $$RuntimeFlowsTableAnnotationComposer,
      $$RuntimeFlowsTableCreateCompanionBuilder,
      $$RuntimeFlowsTableUpdateCompanionBuilder,
      (RuntimeFlowRow, $$RuntimeFlowsTableReferences),
      RuntimeFlowRow,
      PrefetchHooks Function({bool runtimeNodesRefs, bool runtimeEdgesRefs})
    >;
typedef $$RuntimeNodesTableCreateCompanionBuilder =
    RuntimeNodesCompanion Function({
      required String id,
      required String flowId,
      required String type,
      required String category,
      Value<String> status,
      Value<String> value,
      Value<Map<String, dynamic>> settings,
      Value<String?> label,
      Value<String?> parentId,
      Value<double> posX,
      Value<double> posY,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$RuntimeNodesTableUpdateCompanionBuilder =
    RuntimeNodesCompanion Function({
      Value<String> id,
      Value<String> flowId,
      Value<String> type,
      Value<String> category,
      Value<String> status,
      Value<String> value,
      Value<Map<String, dynamic>> settings,
      Value<String?> label,
      Value<String?> parentId,
      Value<double> posX,
      Value<double> posY,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$RuntimeNodesTableReferences
    extends BaseReferences<_$AppDatabase, $RuntimeNodesTable, RuntimeNodeRow> {
  $$RuntimeNodesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RuntimeFlowsTable _flowIdTable(_$AppDatabase db) =>
      db.runtimeFlows.createAlias(
        $_aliasNameGenerator(db.runtimeNodes.flowId, db.runtimeFlows.id),
      );

  $$RuntimeFlowsTableProcessedTableManager get flowId {
    final $_column = $_itemColumn<String>('flow_id')!;

    final manager = $$RuntimeFlowsTableTableManager(
      $_db,
      $_db.runtimeFlows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_flowIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$RuntimeHistoryTable, List<RuntimeHistoryRow>>
  _runtimeHistoryRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.runtimeHistory,
    aliasName: $_aliasNameGenerator(
      db.runtimeNodes.id,
      db.runtimeHistory.nodeId,
    ),
  );

  $$RuntimeHistoryTableProcessedTableManager get runtimeHistoryRefs {
    final manager = $$RuntimeHistoryTableTableManager(
      $_db,
      $_db.runtimeHistory,
    ).filter((f) => f.nodeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_runtimeHistoryRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RuntimeInsightsTable, List<RuntimeInsightRow>>
  _runtimeInsightsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.runtimeInsights,
    aliasName: $_aliasNameGenerator(
      db.runtimeNodes.id,
      db.runtimeInsights.nodeId,
    ),
  );

  $$RuntimeInsightsTableProcessedTableManager get runtimeInsightsRefs {
    final manager = $$RuntimeInsightsTableTableManager(
      $_db,
      $_db.runtimeInsights,
    ).filter((f) => f.nodeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _runtimeInsightsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RuntimeNodesTableFilterComposer
    extends Composer<_$AppDatabase, $RuntimeNodesTable> {
  $$RuntimeNodesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, dynamic>,
    Map<String, dynamic>,
    String
  >
  get settings => $composableBuilder(
    column: $table.settings,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get posX => $composableBuilder(
    column: $table.posX,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get posY => $composableBuilder(
    column: $table.posY,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$RuntimeFlowsTableFilterComposer get flowId {
    final $$RuntimeFlowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.flowId,
      referencedTable: $db.runtimeFlows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RuntimeFlowsTableFilterComposer(
            $db: $db,
            $table: $db.runtimeFlows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> runtimeHistoryRefs(
    Expression<bool> Function($$RuntimeHistoryTableFilterComposer f) f,
  ) {
    final $$RuntimeHistoryTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.runtimeHistory,
      getReferencedColumn: (t) => t.nodeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RuntimeHistoryTableFilterComposer(
            $db: $db,
            $table: $db.runtimeHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> runtimeInsightsRefs(
    Expression<bool> Function($$RuntimeInsightsTableFilterComposer f) f,
  ) {
    final $$RuntimeInsightsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.runtimeInsights,
      getReferencedColumn: (t) => t.nodeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RuntimeInsightsTableFilterComposer(
            $db: $db,
            $table: $db.runtimeInsights,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RuntimeNodesTableOrderingComposer
    extends Composer<_$AppDatabase, $RuntimeNodesTable> {
  $$RuntimeNodesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get settings => $composableBuilder(
    column: $table.settings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get posX => $composableBuilder(
    column: $table.posX,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get posY => $composableBuilder(
    column: $table.posY,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$RuntimeFlowsTableOrderingComposer get flowId {
    final $$RuntimeFlowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.flowId,
      referencedTable: $db.runtimeFlows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RuntimeFlowsTableOrderingComposer(
            $db: $db,
            $table: $db.runtimeFlows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RuntimeNodesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RuntimeNodesTable> {
  $$RuntimeNodesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String> get settings =>
      $composableBuilder(column: $table.settings, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<double> get posX =>
      $composableBuilder(column: $table.posX, builder: (column) => column);

  GeneratedColumn<double> get posY =>
      $composableBuilder(column: $table.posY, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$RuntimeFlowsTableAnnotationComposer get flowId {
    final $$RuntimeFlowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.flowId,
      referencedTable: $db.runtimeFlows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RuntimeFlowsTableAnnotationComposer(
            $db: $db,
            $table: $db.runtimeFlows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> runtimeHistoryRefs<T extends Object>(
    Expression<T> Function($$RuntimeHistoryTableAnnotationComposer a) f,
  ) {
    final $$RuntimeHistoryTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.runtimeHistory,
      getReferencedColumn: (t) => t.nodeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RuntimeHistoryTableAnnotationComposer(
            $db: $db,
            $table: $db.runtimeHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> runtimeInsightsRefs<T extends Object>(
    Expression<T> Function($$RuntimeInsightsTableAnnotationComposer a) f,
  ) {
    final $$RuntimeInsightsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.runtimeInsights,
      getReferencedColumn: (t) => t.nodeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RuntimeInsightsTableAnnotationComposer(
            $db: $db,
            $table: $db.runtimeInsights,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RuntimeNodesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RuntimeNodesTable,
          RuntimeNodeRow,
          $$RuntimeNodesTableFilterComposer,
          $$RuntimeNodesTableOrderingComposer,
          $$RuntimeNodesTableAnnotationComposer,
          $$RuntimeNodesTableCreateCompanionBuilder,
          $$RuntimeNodesTableUpdateCompanionBuilder,
          (RuntimeNodeRow, $$RuntimeNodesTableReferences),
          RuntimeNodeRow,
          PrefetchHooks Function({
            bool flowId,
            bool runtimeHistoryRefs,
            bool runtimeInsightsRefs,
          })
        > {
  $$RuntimeNodesTableTableManager(_$AppDatabase db, $RuntimeNodesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RuntimeNodesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RuntimeNodesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RuntimeNodesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> flowId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<Map<String, dynamic>> settings = const Value.absent(),
                Value<String?> label = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<double> posX = const Value.absent(),
                Value<double> posY = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RuntimeNodesCompanion(
                id: id,
                flowId: flowId,
                type: type,
                category: category,
                status: status,
                value: value,
                settings: settings,
                label: label,
                parentId: parentId,
                posX: posX,
                posY: posY,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String flowId,
                required String type,
                required String category,
                Value<String> status = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<Map<String, dynamic>> settings = const Value.absent(),
                Value<String?> label = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<double> posX = const Value.absent(),
                Value<double> posY = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => RuntimeNodesCompanion.insert(
                id: id,
                flowId: flowId,
                type: type,
                category: category,
                status: status,
                value: value,
                settings: settings,
                label: label,
                parentId: parentId,
                posX: posX,
                posY: posY,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RuntimeNodesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                flowId = false,
                runtimeHistoryRefs = false,
                runtimeInsightsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (runtimeHistoryRefs) db.runtimeHistory,
                    if (runtimeInsightsRefs) db.runtimeInsights,
                  ],
                  addJoins:
                      <
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
                          dynamic
                        >
                      >(state) {
                        if (flowId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.flowId,
                                    referencedTable:
                                        $$RuntimeNodesTableReferences
                                            ._flowIdTable(db),
                                    referencedColumn:
                                        $$RuntimeNodesTableReferences
                                            ._flowIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (runtimeHistoryRefs)
                        await $_getPrefetchedData<
                          RuntimeNodeRow,
                          $RuntimeNodesTable,
                          RuntimeHistoryRow
                        >(
                          currentTable: table,
                          referencedTable: $$RuntimeNodesTableReferences
                              ._runtimeHistoryRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RuntimeNodesTableReferences(
                                db,
                                table,
                                p0,
                              ).runtimeHistoryRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.nodeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (runtimeInsightsRefs)
                        await $_getPrefetchedData<
                          RuntimeNodeRow,
                          $RuntimeNodesTable,
                          RuntimeInsightRow
                        >(
                          currentTable: table,
                          referencedTable: $$RuntimeNodesTableReferences
                              ._runtimeInsightsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RuntimeNodesTableReferences(
                                db,
                                table,
                                p0,
                              ).runtimeInsightsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.nodeId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RuntimeNodesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RuntimeNodesTable,
      RuntimeNodeRow,
      $$RuntimeNodesTableFilterComposer,
      $$RuntimeNodesTableOrderingComposer,
      $$RuntimeNodesTableAnnotationComposer,
      $$RuntimeNodesTableCreateCompanionBuilder,
      $$RuntimeNodesTableUpdateCompanionBuilder,
      (RuntimeNodeRow, $$RuntimeNodesTableReferences),
      RuntimeNodeRow,
      PrefetchHooks Function({
        bool flowId,
        bool runtimeHistoryRefs,
        bool runtimeInsightsRefs,
      })
    >;
typedef $$RuntimeEdgesTableCreateCompanionBuilder =
    RuntimeEdgesCompanion Function({
      required String id,
      required String flowId,
      required String sourceNodeId,
      required String sourcePort,
      required String targetNodeId,
      required String targetPort,
      Value<bool> hidden,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$RuntimeEdgesTableUpdateCompanionBuilder =
    RuntimeEdgesCompanion Function({
      Value<String> id,
      Value<String> flowId,
      Value<String> sourceNodeId,
      Value<String> sourcePort,
      Value<String> targetNodeId,
      Value<String> targetPort,
      Value<bool> hidden,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$RuntimeEdgesTableReferences
    extends BaseReferences<_$AppDatabase, $RuntimeEdgesTable, RuntimeEdgeRow> {
  $$RuntimeEdgesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RuntimeFlowsTable _flowIdTable(_$AppDatabase db) =>
      db.runtimeFlows.createAlias(
        $_aliasNameGenerator(db.runtimeEdges.flowId, db.runtimeFlows.id),
      );

  $$RuntimeFlowsTableProcessedTableManager get flowId {
    final $_column = $_itemColumn<String>('flow_id')!;

    final manager = $$RuntimeFlowsTableTableManager(
      $_db,
      $_db.runtimeFlows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_flowIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RuntimeNodesTable _sourceNodeIdTable(_$AppDatabase db) =>
      db.runtimeNodes.createAlias(
        $_aliasNameGenerator(db.runtimeEdges.sourceNodeId, db.runtimeNodes.id),
      );

  $$RuntimeNodesTableProcessedTableManager get sourceNodeId {
    final $_column = $_itemColumn<String>('source_node_id')!;

    final manager = $$RuntimeNodesTableTableManager(
      $_db,
      $_db.runtimeNodes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceNodeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RuntimeNodesTable _targetNodeIdTable(_$AppDatabase db) =>
      db.runtimeNodes.createAlias(
        $_aliasNameGenerator(db.runtimeEdges.targetNodeId, db.runtimeNodes.id),
      );

  $$RuntimeNodesTableProcessedTableManager get targetNodeId {
    final $_column = $_itemColumn<String>('target_node_id')!;

    final manager = $$RuntimeNodesTableTableManager(
      $_db,
      $_db.runtimeNodes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_targetNodeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RuntimeEdgesTableFilterComposer
    extends Composer<_$AppDatabase, $RuntimeEdgesTable> {
  $$RuntimeEdgesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourcePort => $composableBuilder(
    column: $table.sourcePort,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetPort => $composableBuilder(
    column: $table.targetPort,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hidden => $composableBuilder(
    column: $table.hidden,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$RuntimeFlowsTableFilterComposer get flowId {
    final $$RuntimeFlowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.flowId,
      referencedTable: $db.runtimeFlows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RuntimeFlowsTableFilterComposer(
            $db: $db,
            $table: $db.runtimeFlows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RuntimeNodesTableFilterComposer get sourceNodeId {
    final $$RuntimeNodesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceNodeId,
      referencedTable: $db.runtimeNodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RuntimeNodesTableFilterComposer(
            $db: $db,
            $table: $db.runtimeNodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RuntimeNodesTableFilterComposer get targetNodeId {
    final $$RuntimeNodesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetNodeId,
      referencedTable: $db.runtimeNodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RuntimeNodesTableFilterComposer(
            $db: $db,
            $table: $db.runtimeNodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RuntimeEdgesTableOrderingComposer
    extends Composer<_$AppDatabase, $RuntimeEdgesTable> {
  $$RuntimeEdgesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourcePort => $composableBuilder(
    column: $table.sourcePort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetPort => $composableBuilder(
    column: $table.targetPort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hidden => $composableBuilder(
    column: $table.hidden,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$RuntimeFlowsTableOrderingComposer get flowId {
    final $$RuntimeFlowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.flowId,
      referencedTable: $db.runtimeFlows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RuntimeFlowsTableOrderingComposer(
            $db: $db,
            $table: $db.runtimeFlows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RuntimeNodesTableOrderingComposer get sourceNodeId {
    final $$RuntimeNodesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceNodeId,
      referencedTable: $db.runtimeNodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RuntimeNodesTableOrderingComposer(
            $db: $db,
            $table: $db.runtimeNodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RuntimeNodesTableOrderingComposer get targetNodeId {
    final $$RuntimeNodesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetNodeId,
      referencedTable: $db.runtimeNodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RuntimeNodesTableOrderingComposer(
            $db: $db,
            $table: $db.runtimeNodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RuntimeEdgesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RuntimeEdgesTable> {
  $$RuntimeEdgesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourcePort => $composableBuilder(
    column: $table.sourcePort,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetPort => $composableBuilder(
    column: $table.targetPort,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hidden =>
      $composableBuilder(column: $table.hidden, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$RuntimeFlowsTableAnnotationComposer get flowId {
    final $$RuntimeFlowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.flowId,
      referencedTable: $db.runtimeFlows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RuntimeFlowsTableAnnotationComposer(
            $db: $db,
            $table: $db.runtimeFlows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RuntimeNodesTableAnnotationComposer get sourceNodeId {
    final $$RuntimeNodesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceNodeId,
      referencedTable: $db.runtimeNodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RuntimeNodesTableAnnotationComposer(
            $db: $db,
            $table: $db.runtimeNodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RuntimeNodesTableAnnotationComposer get targetNodeId {
    final $$RuntimeNodesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetNodeId,
      referencedTable: $db.runtimeNodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RuntimeNodesTableAnnotationComposer(
            $db: $db,
            $table: $db.runtimeNodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RuntimeEdgesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RuntimeEdgesTable,
          RuntimeEdgeRow,
          $$RuntimeEdgesTableFilterComposer,
          $$RuntimeEdgesTableOrderingComposer,
          $$RuntimeEdgesTableAnnotationComposer,
          $$RuntimeEdgesTableCreateCompanionBuilder,
          $$RuntimeEdgesTableUpdateCompanionBuilder,
          (RuntimeEdgeRow, $$RuntimeEdgesTableReferences),
          RuntimeEdgeRow,
          PrefetchHooks Function({
            bool flowId,
            bool sourceNodeId,
            bool targetNodeId,
          })
        > {
  $$RuntimeEdgesTableTableManager(_$AppDatabase db, $RuntimeEdgesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RuntimeEdgesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RuntimeEdgesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RuntimeEdgesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> flowId = const Value.absent(),
                Value<String> sourceNodeId = const Value.absent(),
                Value<String> sourcePort = const Value.absent(),
                Value<String> targetNodeId = const Value.absent(),
                Value<String> targetPort = const Value.absent(),
                Value<bool> hidden = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RuntimeEdgesCompanion(
                id: id,
                flowId: flowId,
                sourceNodeId: sourceNodeId,
                sourcePort: sourcePort,
                targetNodeId: targetNodeId,
                targetPort: targetPort,
                hidden: hidden,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String flowId,
                required String sourceNodeId,
                required String sourcePort,
                required String targetNodeId,
                required String targetPort,
                Value<bool> hidden = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => RuntimeEdgesCompanion.insert(
                id: id,
                flowId: flowId,
                sourceNodeId: sourceNodeId,
                sourcePort: sourcePort,
                targetNodeId: targetNodeId,
                targetPort: targetPort,
                hidden: hidden,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RuntimeEdgesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({flowId = false, sourceNodeId = false, targetNodeId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
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
                          dynamic
                        >
                      >(state) {
                        if (flowId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.flowId,
                                    referencedTable:
                                        $$RuntimeEdgesTableReferences
                                            ._flowIdTable(db),
                                    referencedColumn:
                                        $$RuntimeEdgesTableReferences
                                            ._flowIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (sourceNodeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sourceNodeId,
                                    referencedTable:
                                        $$RuntimeEdgesTableReferences
                                            ._sourceNodeIdTable(db),
                                    referencedColumn:
                                        $$RuntimeEdgesTableReferences
                                            ._sourceNodeIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (targetNodeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.targetNodeId,
                                    referencedTable:
                                        $$RuntimeEdgesTableReferences
                                            ._targetNodeIdTable(db),
                                    referencedColumn:
                                        $$RuntimeEdgesTableReferences
                                            ._targetNodeIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$RuntimeEdgesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RuntimeEdgesTable,
      RuntimeEdgeRow,
      $$RuntimeEdgesTableFilterComposer,
      $$RuntimeEdgesTableOrderingComposer,
      $$RuntimeEdgesTableAnnotationComposer,
      $$RuntimeEdgesTableCreateCompanionBuilder,
      $$RuntimeEdgesTableUpdateCompanionBuilder,
      (RuntimeEdgeRow, $$RuntimeEdgesTableReferences),
      RuntimeEdgeRow,
      PrefetchHooks Function({
        bool flowId,
        bool sourceNodeId,
        bool targetNodeId,
      })
    >;
typedef $$RuntimeHistoryTableCreateCompanionBuilder =
    RuntimeHistoryCompanion Function({
      Value<int> id,
      required String nodeId,
      Value<double?> numValue,
      Value<bool?> boolValue,
      Value<String?> strValue,
      required DateTime timestamp,
    });
typedef $$RuntimeHistoryTableUpdateCompanionBuilder =
    RuntimeHistoryCompanion Function({
      Value<int> id,
      Value<String> nodeId,
      Value<double?> numValue,
      Value<bool?> boolValue,
      Value<String?> strValue,
      Value<DateTime> timestamp,
    });

final class $$RuntimeHistoryTableReferences
    extends
        BaseReferences<_$AppDatabase, $RuntimeHistoryTable, RuntimeHistoryRow> {
  $$RuntimeHistoryTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RuntimeNodesTable _nodeIdTable(_$AppDatabase db) =>
      db.runtimeNodes.createAlias(
        $_aliasNameGenerator(db.runtimeHistory.nodeId, db.runtimeNodes.id),
      );

  $$RuntimeNodesTableProcessedTableManager get nodeId {
    final $_column = $_itemColumn<String>('node_id')!;

    final manager = $$RuntimeNodesTableTableManager(
      $_db,
      $_db.runtimeNodes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_nodeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RuntimeHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $RuntimeHistoryTable> {
  $$RuntimeHistoryTableFilterComposer({
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

  ColumnFilters<double> get numValue => $composableBuilder(
    column: $table.numValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get boolValue => $composableBuilder(
    column: $table.boolValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get strValue => $composableBuilder(
    column: $table.strValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  $$RuntimeNodesTableFilterComposer get nodeId {
    final $$RuntimeNodesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nodeId,
      referencedTable: $db.runtimeNodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RuntimeNodesTableFilterComposer(
            $db: $db,
            $table: $db.runtimeNodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RuntimeHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $RuntimeHistoryTable> {
  $$RuntimeHistoryTableOrderingComposer({
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

  ColumnOrderings<double> get numValue => $composableBuilder(
    column: $table.numValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get boolValue => $composableBuilder(
    column: $table.boolValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get strValue => $composableBuilder(
    column: $table.strValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  $$RuntimeNodesTableOrderingComposer get nodeId {
    final $$RuntimeNodesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nodeId,
      referencedTable: $db.runtimeNodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RuntimeNodesTableOrderingComposer(
            $db: $db,
            $table: $db.runtimeNodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RuntimeHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $RuntimeHistoryTable> {
  $$RuntimeHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get numValue =>
      $composableBuilder(column: $table.numValue, builder: (column) => column);

  GeneratedColumn<bool> get boolValue =>
      $composableBuilder(column: $table.boolValue, builder: (column) => column);

  GeneratedColumn<String> get strValue =>
      $composableBuilder(column: $table.strValue, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  $$RuntimeNodesTableAnnotationComposer get nodeId {
    final $$RuntimeNodesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nodeId,
      referencedTable: $db.runtimeNodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RuntimeNodesTableAnnotationComposer(
            $db: $db,
            $table: $db.runtimeNodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RuntimeHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RuntimeHistoryTable,
          RuntimeHistoryRow,
          $$RuntimeHistoryTableFilterComposer,
          $$RuntimeHistoryTableOrderingComposer,
          $$RuntimeHistoryTableAnnotationComposer,
          $$RuntimeHistoryTableCreateCompanionBuilder,
          $$RuntimeHistoryTableUpdateCompanionBuilder,
          (RuntimeHistoryRow, $$RuntimeHistoryTableReferences),
          RuntimeHistoryRow,
          PrefetchHooks Function({bool nodeId})
        > {
  $$RuntimeHistoryTableTableManager(
    _$AppDatabase db,
    $RuntimeHistoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RuntimeHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RuntimeHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RuntimeHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nodeId = const Value.absent(),
                Value<double?> numValue = const Value.absent(),
                Value<bool?> boolValue = const Value.absent(),
                Value<String?> strValue = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => RuntimeHistoryCompanion(
                id: id,
                nodeId: nodeId,
                numValue: numValue,
                boolValue: boolValue,
                strValue: strValue,
                timestamp: timestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nodeId,
                Value<double?> numValue = const Value.absent(),
                Value<bool?> boolValue = const Value.absent(),
                Value<String?> strValue = const Value.absent(),
                required DateTime timestamp,
              }) => RuntimeHistoryCompanion.insert(
                id: id,
                nodeId: nodeId,
                numValue: numValue,
                boolValue: boolValue,
                strValue: strValue,
                timestamp: timestamp,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RuntimeHistoryTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({nodeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (nodeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.nodeId,
                                referencedTable: $$RuntimeHistoryTableReferences
                                    ._nodeIdTable(db),
                                referencedColumn:
                                    $$RuntimeHistoryTableReferences
                                        ._nodeIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RuntimeHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RuntimeHistoryTable,
      RuntimeHistoryRow,
      $$RuntimeHistoryTableFilterComposer,
      $$RuntimeHistoryTableOrderingComposer,
      $$RuntimeHistoryTableAnnotationComposer,
      $$RuntimeHistoryTableCreateCompanionBuilder,
      $$RuntimeHistoryTableUpdateCompanionBuilder,
      (RuntimeHistoryRow, $$RuntimeHistoryTableReferences),
      RuntimeHistoryRow,
      PrefetchHooks Function({bool nodeId})
    >;
typedef $$RuntimeInsightsTableCreateCompanionBuilder =
    RuntimeInsightsCompanion Function({
      required String id,
      required String nodeId,
      required String type,
      required String severity,
      required String state,
      required String title,
      Value<String?> message,
      Value<double?> triggerValue,
      Value<double?> thresholdValue,
      required DateTime triggeredAt,
      Value<DateTime?> clearedAt,
      Value<DateTime?> acknowledgedAt,
      Value<String> metadata,
      Value<int> rowid,
    });
typedef $$RuntimeInsightsTableUpdateCompanionBuilder =
    RuntimeInsightsCompanion Function({
      Value<String> id,
      Value<String> nodeId,
      Value<String> type,
      Value<String> severity,
      Value<String> state,
      Value<String> title,
      Value<String?> message,
      Value<double?> triggerValue,
      Value<double?> thresholdValue,
      Value<DateTime> triggeredAt,
      Value<DateTime?> clearedAt,
      Value<DateTime?> acknowledgedAt,
      Value<String> metadata,
      Value<int> rowid,
    });

final class $$RuntimeInsightsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RuntimeInsightsTable,
          RuntimeInsightRow
        > {
  $$RuntimeInsightsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RuntimeNodesTable _nodeIdTable(_$AppDatabase db) =>
      db.runtimeNodes.createAlias(
        $_aliasNameGenerator(db.runtimeInsights.nodeId, db.runtimeNodes.id),
      );

  $$RuntimeNodesTableProcessedTableManager get nodeId {
    final $_column = $_itemColumn<String>('node_id')!;

    final manager = $$RuntimeNodesTableTableManager(
      $_db,
      $_db.runtimeNodes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_nodeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RuntimeInsightsTableFilterComposer
    extends Composer<_$AppDatabase, $RuntimeInsightsTable> {
  $$RuntimeInsightsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get triggerValue => $composableBuilder(
    column: $table.triggerValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get thresholdValue => $composableBuilder(
    column: $table.thresholdValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get triggeredAt => $composableBuilder(
    column: $table.triggeredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get clearedAt => $composableBuilder(
    column: $table.clearedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get acknowledgedAt => $composableBuilder(
    column: $table.acknowledgedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnFilters(column),
  );

  $$RuntimeNodesTableFilterComposer get nodeId {
    final $$RuntimeNodesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nodeId,
      referencedTable: $db.runtimeNodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RuntimeNodesTableFilterComposer(
            $db: $db,
            $table: $db.runtimeNodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RuntimeInsightsTableOrderingComposer
    extends Composer<_$AppDatabase, $RuntimeInsightsTable> {
  $$RuntimeInsightsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get triggerValue => $composableBuilder(
    column: $table.triggerValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get thresholdValue => $composableBuilder(
    column: $table.thresholdValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get triggeredAt => $composableBuilder(
    column: $table.triggeredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get clearedAt => $composableBuilder(
    column: $table.clearedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get acknowledgedAt => $composableBuilder(
    column: $table.acknowledgedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnOrderings(column),
  );

  $$RuntimeNodesTableOrderingComposer get nodeId {
    final $$RuntimeNodesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nodeId,
      referencedTable: $db.runtimeNodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RuntimeNodesTableOrderingComposer(
            $db: $db,
            $table: $db.runtimeNodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RuntimeInsightsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RuntimeInsightsTable> {
  $$RuntimeInsightsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<double> get triggerValue => $composableBuilder(
    column: $table.triggerValue,
    builder: (column) => column,
  );

  GeneratedColumn<double> get thresholdValue => $composableBuilder(
    column: $table.thresholdValue,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get triggeredAt => $composableBuilder(
    column: $table.triggeredAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get clearedAt =>
      $composableBuilder(column: $table.clearedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get acknowledgedAt => $composableBuilder(
    column: $table.acknowledgedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  $$RuntimeNodesTableAnnotationComposer get nodeId {
    final $$RuntimeNodesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nodeId,
      referencedTable: $db.runtimeNodes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RuntimeNodesTableAnnotationComposer(
            $db: $db,
            $table: $db.runtimeNodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RuntimeInsightsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RuntimeInsightsTable,
          RuntimeInsightRow,
          $$RuntimeInsightsTableFilterComposer,
          $$RuntimeInsightsTableOrderingComposer,
          $$RuntimeInsightsTableAnnotationComposer,
          $$RuntimeInsightsTableCreateCompanionBuilder,
          $$RuntimeInsightsTableUpdateCompanionBuilder,
          (RuntimeInsightRow, $$RuntimeInsightsTableReferences),
          RuntimeInsightRow,
          PrefetchHooks Function({bool nodeId})
        > {
  $$RuntimeInsightsTableTableManager(
    _$AppDatabase db,
    $RuntimeInsightsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RuntimeInsightsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RuntimeInsightsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RuntimeInsightsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nodeId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> severity = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> message = const Value.absent(),
                Value<double?> triggerValue = const Value.absent(),
                Value<double?> thresholdValue = const Value.absent(),
                Value<DateTime> triggeredAt = const Value.absent(),
                Value<DateTime?> clearedAt = const Value.absent(),
                Value<DateTime?> acknowledgedAt = const Value.absent(),
                Value<String> metadata = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RuntimeInsightsCompanion(
                id: id,
                nodeId: nodeId,
                type: type,
                severity: severity,
                state: state,
                title: title,
                message: message,
                triggerValue: triggerValue,
                thresholdValue: thresholdValue,
                triggeredAt: triggeredAt,
                clearedAt: clearedAt,
                acknowledgedAt: acknowledgedAt,
                metadata: metadata,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nodeId,
                required String type,
                required String severity,
                required String state,
                required String title,
                Value<String?> message = const Value.absent(),
                Value<double?> triggerValue = const Value.absent(),
                Value<double?> thresholdValue = const Value.absent(),
                required DateTime triggeredAt,
                Value<DateTime?> clearedAt = const Value.absent(),
                Value<DateTime?> acknowledgedAt = const Value.absent(),
                Value<String> metadata = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RuntimeInsightsCompanion.insert(
                id: id,
                nodeId: nodeId,
                type: type,
                severity: severity,
                state: state,
                title: title,
                message: message,
                triggerValue: triggerValue,
                thresholdValue: thresholdValue,
                triggeredAt: triggeredAt,
                clearedAt: clearedAt,
                acknowledgedAt: acknowledgedAt,
                metadata: metadata,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RuntimeInsightsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({nodeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (nodeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.nodeId,
                                referencedTable:
                                    $$RuntimeInsightsTableReferences
                                        ._nodeIdTable(db),
                                referencedColumn:
                                    $$RuntimeInsightsTableReferences
                                        ._nodeIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RuntimeInsightsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RuntimeInsightsTable,
      RuntimeInsightRow,
      $$RuntimeInsightsTableFilterComposer,
      $$RuntimeInsightsTableOrderingComposer,
      $$RuntimeInsightsTableAnnotationComposer,
      $$RuntimeInsightsTableCreateCompanionBuilder,
      $$RuntimeInsightsTableUpdateCompanionBuilder,
      (RuntimeInsightRow, $$RuntimeInsightsTableReferences),
      RuntimeInsightRow,
      PrefetchHooks Function({bool nodeId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocationsTableTableManager get locations =>
      $$LocationsTableTableManager(_db, _db.locations);
  $$PinnedPagesTableTableManager get pinnedPages =>
      $$PinnedPagesTableTableManager(_db, _db.pinnedPages);
  $$NetworksTableTableManager get networks =>
      $$NetworksTableTableManager(_db, _db.networks);
  $$DevicesTableTableManager get devices =>
      $$DevicesTableTableManager(_db, _db.devices);
  $$PointsTableTableManager get points =>
      $$PointsTableTableManager(_db, _db.points);
  $$ScheduleEntriesTableTableManager get scheduleEntries =>
      $$ScheduleEntriesTableTableManager(_db, _db.scheduleEntries);
  $$ScheduleBindingsTableTableManager get scheduleBindings =>
      $$ScheduleBindingsTableTableManager(_db, _db.scheduleBindings);
  $$AlarmsTableTableManager get alarms =>
      $$AlarmsTableTableManager(_db, _db.alarms);
  $$PagesTableTableManager get pages =>
      $$PagesTableTableManager(_db, _db.pages);
  $$WidgetsTableTableManager get widgets =>
      $$WidgetsTableTableManager(_db, _db.widgets);
  $$PointHistoryTableTableManager get pointHistory =>
      $$PointHistoryTableTableManager(_db, _db.pointHistory);
  $$RuntimeFlowsTableTableManager get runtimeFlows =>
      $$RuntimeFlowsTableTableManager(_db, _db.runtimeFlows);
  $$RuntimeNodesTableTableManager get runtimeNodes =>
      $$RuntimeNodesTableTableManager(_db, _db.runtimeNodes);
  $$RuntimeEdgesTableTableManager get runtimeEdges =>
      $$RuntimeEdgesTableTableManager(_db, _db.runtimeEdges);
  $$RuntimeHistoryTableTableManager get runtimeHistory =>
      $$RuntimeHistoryTableTableManager(_db, _db.runtimeHistory);
  $$RuntimeInsightsTableTableManager get runtimeInsights =>
      $$RuntimeInsightsTableTableManager(_db, _db.runtimeInsights);
}
