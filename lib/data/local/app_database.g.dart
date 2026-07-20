// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProjetosTable extends Projetos with TableInfo<$ProjetosTable, Projeto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjetosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
      'nome', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _municipioMeta =
      const VerificationMeta('municipio');
  @override
  late final GeneratedColumn<String> municipio = GeneratedColumn<String>(
      'municipio', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
      'estado', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Amapá'));
  static const VerificationMeta _bairroMeta = const VerificationMeta('bairro');
  @override
  late final GeneratedColumn<String> bairro = GeneratedColumn<String>(
      'bairro', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _modalidadeReurbMeta =
      const VerificationMeta('modalidadeReurb');
  @override
  late final GeneratedColumn<String> modalidadeReurb = GeneratedColumn<String>(
      'modalidade_reurb', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _areaHaMeta = const VerificationMeta('areaHa');
  @override
  late final GeneratedColumn<double> areaHa = GeneratedColumn<double>(
      'area_ha', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _lotesEstimadosMeta =
      const VerificationMeta('lotesEstimados');
  @override
  late final GeneratedColumn<int> lotesEstimados = GeneratedColumn<int>(
      'lotes_estimados', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('em_execucao'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        nome,
        municipio,
        estado,
        bairro,
        modalidadeReurb,
        areaHa,
        lotesEstimados,
        status,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projetos';
  @override
  VerificationContext validateIntegrity(Insertable<Projeto> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
          _nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('municipio')) {
      context.handle(_municipioMeta,
          municipio.isAcceptableOrUnknown(data['municipio']!, _municipioMeta));
    } else if (isInserting) {
      context.missing(_municipioMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(_estadoMeta,
          estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta));
    }
    if (data.containsKey('bairro')) {
      context.handle(_bairroMeta,
          bairro.isAcceptableOrUnknown(data['bairro']!, _bairroMeta));
    } else if (isInserting) {
      context.missing(_bairroMeta);
    }
    if (data.containsKey('modalidade_reurb')) {
      context.handle(
          _modalidadeReurbMeta,
          modalidadeReurb.isAcceptableOrUnknown(
              data['modalidade_reurb']!, _modalidadeReurbMeta));
    }
    if (data.containsKey('area_ha')) {
      context.handle(_areaHaMeta,
          areaHa.isAcceptableOrUnknown(data['area_ha']!, _areaHaMeta));
    }
    if (data.containsKey('lotes_estimados')) {
      context.handle(
          _lotesEstimadosMeta,
          lotesEstimados.isAcceptableOrUnknown(
              data['lotes_estimados']!, _lotesEstimadosMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
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
  Projeto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Projeto(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      nome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
      municipio: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}municipio'])!,
      estado: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}estado'])!,
      bairro: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bairro'])!,
      modalidadeReurb: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}modalidade_reurb']),
      areaHa: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}area_ha']),
      lotesEstimados: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}lotes_estimados']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ProjetosTable createAlias(String alias) {
    return $ProjetosTable(attachedDatabase, alias);
  }
}

class Projeto extends DataClass implements Insertable<Projeto> {
  final String id;
  final String nome;
  final String municipio;
  final String estado;
  final String bairro;
  final String? modalidadeReurb;
  final double? areaHa;
  final int? lotesEstimados;
  final String status;
  final DateTime createdAt;
  const Projeto(
      {required this.id,
      required this.nome,
      required this.municipio,
      required this.estado,
      required this.bairro,
      this.modalidadeReurb,
      this.areaHa,
      this.lotesEstimados,
      required this.status,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nome'] = Variable<String>(nome);
    map['municipio'] = Variable<String>(municipio);
    map['estado'] = Variable<String>(estado);
    map['bairro'] = Variable<String>(bairro);
    if (!nullToAbsent || modalidadeReurb != null) {
      map['modalidade_reurb'] = Variable<String>(modalidadeReurb);
    }
    if (!nullToAbsent || areaHa != null) {
      map['area_ha'] = Variable<double>(areaHa);
    }
    if (!nullToAbsent || lotesEstimados != null) {
      map['lotes_estimados'] = Variable<int>(lotesEstimados);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProjetosCompanion toCompanion(bool nullToAbsent) {
    return ProjetosCompanion(
      id: Value(id),
      nome: Value(nome),
      municipio: Value(municipio),
      estado: Value(estado),
      bairro: Value(bairro),
      modalidadeReurb: modalidadeReurb == null && nullToAbsent
          ? const Value.absent()
          : Value(modalidadeReurb),
      areaHa:
          areaHa == null && nullToAbsent ? const Value.absent() : Value(areaHa),
      lotesEstimados: lotesEstimados == null && nullToAbsent
          ? const Value.absent()
          : Value(lotesEstimados),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory Projeto.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Projeto(
      id: serializer.fromJson<String>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      municipio: serializer.fromJson<String>(json['municipio']),
      estado: serializer.fromJson<String>(json['estado']),
      bairro: serializer.fromJson<String>(json['bairro']),
      modalidadeReurb: serializer.fromJson<String?>(json['modalidadeReurb']),
      areaHa: serializer.fromJson<double?>(json['areaHa']),
      lotesEstimados: serializer.fromJson<int?>(json['lotesEstimados']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nome': serializer.toJson<String>(nome),
      'municipio': serializer.toJson<String>(municipio),
      'estado': serializer.toJson<String>(estado),
      'bairro': serializer.toJson<String>(bairro),
      'modalidadeReurb': serializer.toJson<String?>(modalidadeReurb),
      'areaHa': serializer.toJson<double?>(areaHa),
      'lotesEstimados': serializer.toJson<int?>(lotesEstimados),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Projeto copyWith(
          {String? id,
          String? nome,
          String? municipio,
          String? estado,
          String? bairro,
          Value<String?> modalidadeReurb = const Value.absent(),
          Value<double?> areaHa = const Value.absent(),
          Value<int?> lotesEstimados = const Value.absent(),
          String? status,
          DateTime? createdAt}) =>
      Projeto(
        id: id ?? this.id,
        nome: nome ?? this.nome,
        municipio: municipio ?? this.municipio,
        estado: estado ?? this.estado,
        bairro: bairro ?? this.bairro,
        modalidadeReurb: modalidadeReurb.present
            ? modalidadeReurb.value
            : this.modalidadeReurb,
        areaHa: areaHa.present ? areaHa.value : this.areaHa,
        lotesEstimados:
            lotesEstimados.present ? lotesEstimados.value : this.lotesEstimados,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
      );
  Projeto copyWithCompanion(ProjetosCompanion data) {
    return Projeto(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      municipio: data.municipio.present ? data.municipio.value : this.municipio,
      estado: data.estado.present ? data.estado.value : this.estado,
      bairro: data.bairro.present ? data.bairro.value : this.bairro,
      modalidadeReurb: data.modalidadeReurb.present
          ? data.modalidadeReurb.value
          : this.modalidadeReurb,
      areaHa: data.areaHa.present ? data.areaHa.value : this.areaHa,
      lotesEstimados: data.lotesEstimados.present
          ? data.lotesEstimados.value
          : this.lotesEstimados,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Projeto(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('municipio: $municipio, ')
          ..write('estado: $estado, ')
          ..write('bairro: $bairro, ')
          ..write('modalidadeReurb: $modalidadeReurb, ')
          ..write('areaHa: $areaHa, ')
          ..write('lotesEstimados: $lotesEstimados, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nome, municipio, estado, bairro,
      modalidadeReurb, areaHa, lotesEstimados, status, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Projeto &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.municipio == this.municipio &&
          other.estado == this.estado &&
          other.bairro == this.bairro &&
          other.modalidadeReurb == this.modalidadeReurb &&
          other.areaHa == this.areaHa &&
          other.lotesEstimados == this.lotesEstimados &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class ProjetosCompanion extends UpdateCompanion<Projeto> {
  final Value<String> id;
  final Value<String> nome;
  final Value<String> municipio;
  final Value<String> estado;
  final Value<String> bairro;
  final Value<String?> modalidadeReurb;
  final Value<double?> areaHa;
  final Value<int?> lotesEstimados;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ProjetosCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.municipio = const Value.absent(),
    this.estado = const Value.absent(),
    this.bairro = const Value.absent(),
    this.modalidadeReurb = const Value.absent(),
    this.areaHa = const Value.absent(),
    this.lotesEstimados = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjetosCompanion.insert({
    required String id,
    required String nome,
    required String municipio,
    this.estado = const Value.absent(),
    required String bairro,
    this.modalidadeReurb = const Value.absent(),
    this.areaHa = const Value.absent(),
    this.lotesEstimados = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        nome = Value(nome),
        municipio = Value(municipio),
        bairro = Value(bairro);
  static Insertable<Projeto> custom({
    Expression<String>? id,
    Expression<String>? nome,
    Expression<String>? municipio,
    Expression<String>? estado,
    Expression<String>? bairro,
    Expression<String>? modalidadeReurb,
    Expression<double>? areaHa,
    Expression<int>? lotesEstimados,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (municipio != null) 'municipio': municipio,
      if (estado != null) 'estado': estado,
      if (bairro != null) 'bairro': bairro,
      if (modalidadeReurb != null) 'modalidade_reurb': modalidadeReurb,
      if (areaHa != null) 'area_ha': areaHa,
      if (lotesEstimados != null) 'lotes_estimados': lotesEstimados,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjetosCompanion copyWith(
      {Value<String>? id,
      Value<String>? nome,
      Value<String>? municipio,
      Value<String>? estado,
      Value<String>? bairro,
      Value<String?>? modalidadeReurb,
      Value<double?>? areaHa,
      Value<int?>? lotesEstimados,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ProjetosCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      municipio: municipio ?? this.municipio,
      estado: estado ?? this.estado,
      bairro: bairro ?? this.bairro,
      modalidadeReurb: modalidadeReurb ?? this.modalidadeReurb,
      areaHa: areaHa ?? this.areaHa,
      lotesEstimados: lotesEstimados ?? this.lotesEstimados,
      status: status ?? this.status,
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
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (municipio.present) {
      map['municipio'] = Variable<String>(municipio.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (bairro.present) {
      map['bairro'] = Variable<String>(bairro.value);
    }
    if (modalidadeReurb.present) {
      map['modalidade_reurb'] = Variable<String>(modalidadeReurb.value);
    }
    if (areaHa.present) {
      map['area_ha'] = Variable<double>(areaHa.value);
    }
    if (lotesEstimados.present) {
      map['lotes_estimados'] = Variable<int>(lotesEstimados.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
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
    return (StringBuffer('ProjetosCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('municipio: $municipio, ')
          ..write('estado: $estado, ')
          ..write('bairro: $bairro, ')
          ..write('modalidadeReurb: $modalidadeReurb, ')
          ..write('areaHa: $areaHa, ')
          ..write('lotesEstimados: $lotesEstimados, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LotesTable extends Lotes with TableInfo<$LotesTable, Lote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _projetoIdMeta =
      const VerificationMeta('projetoId');
  @override
  late final GeneratedColumn<String> projetoId = GeneratedColumn<String>(
      'projeto_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
      'codigo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quadraMeta = const VerificationMeta('quadra');
  @override
  late final GeneratedColumn<String> quadra = GeneratedColumn<String>(
      'quadra', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _areaM2Meta = const VerificationMeta('areaM2');
  @override
  late final GeneratedColumn<double> areaM2 = GeneratedColumn<double>(
      'area_m2', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pendente'));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, projetoId, codigo, quadra, areaM2, status, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lotes';
  @override
  VerificationContext validateIntegrity(Insertable<Lote> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('projeto_id')) {
      context.handle(_projetoIdMeta,
          projetoId.isAcceptableOrUnknown(data['projeto_id']!, _projetoIdMeta));
    } else if (isInserting) {
      context.missing(_projetoIdMeta);
    }
    if (data.containsKey('codigo')) {
      context.handle(_codigoMeta,
          codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta));
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('quadra')) {
      context.handle(_quadraMeta,
          quadra.isAcceptableOrUnknown(data['quadra']!, _quadraMeta));
    }
    if (data.containsKey('area_m2')) {
      context.handle(_areaM2Meta,
          areaM2.isAcceptableOrUnknown(data['area_m2']!, _areaM2Meta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Lote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Lote(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      projetoId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}projeto_id'])!,
      codigo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}codigo'])!,
      quadra: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}quadra']),
      areaM2: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}area_m2']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $LotesTable createAlias(String alias) {
    return $LotesTable(attachedDatabase, alias);
  }
}

class Lote extends DataClass implements Insertable<Lote> {
  final String id;
  final String projetoId;
  final String codigo;
  final String? quadra;
  final double? areaM2;
  final String status;
  final DateTime updatedAt;
  const Lote(
      {required this.id,
      required this.projetoId,
      required this.codigo,
      this.quadra,
      this.areaM2,
      required this.status,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['projeto_id'] = Variable<String>(projetoId);
    map['codigo'] = Variable<String>(codigo);
    if (!nullToAbsent || quadra != null) {
      map['quadra'] = Variable<String>(quadra);
    }
    if (!nullToAbsent || areaM2 != null) {
      map['area_m2'] = Variable<double>(areaM2);
    }
    map['status'] = Variable<String>(status);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LotesCompanion toCompanion(bool nullToAbsent) {
    return LotesCompanion(
      id: Value(id),
      projetoId: Value(projetoId),
      codigo: Value(codigo),
      quadra:
          quadra == null && nullToAbsent ? const Value.absent() : Value(quadra),
      areaM2:
          areaM2 == null && nullToAbsent ? const Value.absent() : Value(areaM2),
      status: Value(status),
      updatedAt: Value(updatedAt),
    );
  }

  factory Lote.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Lote(
      id: serializer.fromJson<String>(json['id']),
      projetoId: serializer.fromJson<String>(json['projetoId']),
      codigo: serializer.fromJson<String>(json['codigo']),
      quadra: serializer.fromJson<String?>(json['quadra']),
      areaM2: serializer.fromJson<double?>(json['areaM2']),
      status: serializer.fromJson<String>(json['status']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projetoId': serializer.toJson<String>(projetoId),
      'codigo': serializer.toJson<String>(codigo),
      'quadra': serializer.toJson<String?>(quadra),
      'areaM2': serializer.toJson<double?>(areaM2),
      'status': serializer.toJson<String>(status),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Lote copyWith(
          {String? id,
          String? projetoId,
          String? codigo,
          Value<String?> quadra = const Value.absent(),
          Value<double?> areaM2 = const Value.absent(),
          String? status,
          DateTime? updatedAt}) =>
      Lote(
        id: id ?? this.id,
        projetoId: projetoId ?? this.projetoId,
        codigo: codigo ?? this.codigo,
        quadra: quadra.present ? quadra.value : this.quadra,
        areaM2: areaM2.present ? areaM2.value : this.areaM2,
        status: status ?? this.status,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Lote copyWithCompanion(LotesCompanion data) {
    return Lote(
      id: data.id.present ? data.id.value : this.id,
      projetoId: data.projetoId.present ? data.projetoId.value : this.projetoId,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      quadra: data.quadra.present ? data.quadra.value : this.quadra,
      areaM2: data.areaM2.present ? data.areaM2.value : this.areaM2,
      status: data.status.present ? data.status.value : this.status,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Lote(')
          ..write('id: $id, ')
          ..write('projetoId: $projetoId, ')
          ..write('codigo: $codigo, ')
          ..write('quadra: $quadra, ')
          ..write('areaM2: $areaM2, ')
          ..write('status: $status, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, projetoId, codigo, quadra, areaM2, status, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Lote &&
          other.id == this.id &&
          other.projetoId == this.projetoId &&
          other.codigo == this.codigo &&
          other.quadra == this.quadra &&
          other.areaM2 == this.areaM2 &&
          other.status == this.status &&
          other.updatedAt == this.updatedAt);
}

class LotesCompanion extends UpdateCompanion<Lote> {
  final Value<String> id;
  final Value<String> projetoId;
  final Value<String> codigo;
  final Value<String?> quadra;
  final Value<double?> areaM2;
  final Value<String> status;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LotesCompanion({
    this.id = const Value.absent(),
    this.projetoId = const Value.absent(),
    this.codigo = const Value.absent(),
    this.quadra = const Value.absent(),
    this.areaM2 = const Value.absent(),
    this.status = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LotesCompanion.insert({
    required String id,
    required String projetoId,
    required String codigo,
    this.quadra = const Value.absent(),
    this.areaM2 = const Value.absent(),
    this.status = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        projetoId = Value(projetoId),
        codigo = Value(codigo);
  static Insertable<Lote> custom({
    Expression<String>? id,
    Expression<String>? projetoId,
    Expression<String>? codigo,
    Expression<String>? quadra,
    Expression<double>? areaM2,
    Expression<String>? status,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projetoId != null) 'projeto_id': projetoId,
      if (codigo != null) 'codigo': codigo,
      if (quadra != null) 'quadra': quadra,
      if (areaM2 != null) 'area_m2': areaM2,
      if (status != null) 'status': status,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LotesCompanion copyWith(
      {Value<String>? id,
      Value<String>? projetoId,
      Value<String>? codigo,
      Value<String?>? quadra,
      Value<double?>? areaM2,
      Value<String>? status,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return LotesCompanion(
      id: id ?? this.id,
      projetoId: projetoId ?? this.projetoId,
      codigo: codigo ?? this.codigo,
      quadra: quadra ?? this.quadra,
      areaM2: areaM2 ?? this.areaM2,
      status: status ?? this.status,
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
    if (projetoId.present) {
      map['projeto_id'] = Variable<String>(projetoId.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (quadra.present) {
      map['quadra'] = Variable<String>(quadra.value);
    }
    if (areaM2.present) {
      map['area_m2'] = Variable<double>(areaM2.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
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
    return (StringBuffer('LotesCompanion(')
          ..write('id: $id, ')
          ..write('projetoId: $projetoId, ')
          ..write('codigo: $codigo, ')
          ..write('quadra: $quadra, ')
          ..write('areaM2: $areaM2, ')
          ..write('status: $status, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BeneficiariosTable extends Beneficiarios
    with TableInfo<$BeneficiariosTable, Beneficiario> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BeneficiariosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _loteIdMeta = const VerificationMeta('loteId');
  @override
  late final GeneratedColumn<String> loteId = GeneratedColumn<String>(
      'lote_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nomeResponsavelMeta =
      const VerificationMeta('nomeResponsavel');
  @override
  late final GeneratedColumn<String> nomeResponsavel = GeneratedColumn<String>(
      'nome_responsavel', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cpfMeta = const VerificationMeta('cpf');
  @override
  late final GeneratedColumn<String> cpf = GeneratedColumn<String>(
      'cpf', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _telefoneMeta =
      const VerificationMeta('telefone');
  @override
  late final GeneratedColumn<String> telefone = GeneratedColumn<String>(
      'telefone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusDocumentalMeta =
      const VerificationMeta('statusDocumental');
  @override
  late final GeneratedColumn<String> statusDocumental = GeneratedColumn<String>(
      'status_documental', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, loteId, nomeResponsavel, cpf, telefone, statusDocumental, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'beneficiarios';
  @override
  VerificationContext validateIntegrity(Insertable<Beneficiario> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('lote_id')) {
      context.handle(_loteIdMeta,
          loteId.isAcceptableOrUnknown(data['lote_id']!, _loteIdMeta));
    } else if (isInserting) {
      context.missing(_loteIdMeta);
    }
    if (data.containsKey('nome_responsavel')) {
      context.handle(
          _nomeResponsavelMeta,
          nomeResponsavel.isAcceptableOrUnknown(
              data['nome_responsavel']!, _nomeResponsavelMeta));
    } else if (isInserting) {
      context.missing(_nomeResponsavelMeta);
    }
    if (data.containsKey('cpf')) {
      context.handle(
          _cpfMeta, cpf.isAcceptableOrUnknown(data['cpf']!, _cpfMeta));
    }
    if (data.containsKey('telefone')) {
      context.handle(_telefoneMeta,
          telefone.isAcceptableOrUnknown(data['telefone']!, _telefoneMeta));
    }
    if (data.containsKey('status_documental')) {
      context.handle(
          _statusDocumentalMeta,
          statusDocumental.isAcceptableOrUnknown(
              data['status_documental']!, _statusDocumentalMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Beneficiario map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Beneficiario(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      loteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lote_id'])!,
      nomeResponsavel: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}nome_responsavel'])!,
      cpf: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cpf']),
      telefone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}telefone']),
      statusDocumental: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}status_documental']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $BeneficiariosTable createAlias(String alias) {
    return $BeneficiariosTable(attachedDatabase, alias);
  }
}

class Beneficiario extends DataClass implements Insertable<Beneficiario> {
  final String id;
  final String loteId;
  final String nomeResponsavel;
  final String? cpf;
  final String? telefone;
  final String? statusDocumental;
  final DateTime updatedAt;
  const Beneficiario(
      {required this.id,
      required this.loteId,
      required this.nomeResponsavel,
      this.cpf,
      this.telefone,
      this.statusDocumental,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['lote_id'] = Variable<String>(loteId);
    map['nome_responsavel'] = Variable<String>(nomeResponsavel);
    if (!nullToAbsent || cpf != null) {
      map['cpf'] = Variable<String>(cpf);
    }
    if (!nullToAbsent || telefone != null) {
      map['telefone'] = Variable<String>(telefone);
    }
    if (!nullToAbsent || statusDocumental != null) {
      map['status_documental'] = Variable<String>(statusDocumental);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BeneficiariosCompanion toCompanion(bool nullToAbsent) {
    return BeneficiariosCompanion(
      id: Value(id),
      loteId: Value(loteId),
      nomeResponsavel: Value(nomeResponsavel),
      cpf: cpf == null && nullToAbsent ? const Value.absent() : Value(cpf),
      telefone: telefone == null && nullToAbsent
          ? const Value.absent()
          : Value(telefone),
      statusDocumental: statusDocumental == null && nullToAbsent
          ? const Value.absent()
          : Value(statusDocumental),
      updatedAt: Value(updatedAt),
    );
  }

  factory Beneficiario.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Beneficiario(
      id: serializer.fromJson<String>(json['id']),
      loteId: serializer.fromJson<String>(json['loteId']),
      nomeResponsavel: serializer.fromJson<String>(json['nomeResponsavel']),
      cpf: serializer.fromJson<String?>(json['cpf']),
      telefone: serializer.fromJson<String?>(json['telefone']),
      statusDocumental: serializer.fromJson<String?>(json['statusDocumental']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'loteId': serializer.toJson<String>(loteId),
      'nomeResponsavel': serializer.toJson<String>(nomeResponsavel),
      'cpf': serializer.toJson<String?>(cpf),
      'telefone': serializer.toJson<String?>(telefone),
      'statusDocumental': serializer.toJson<String?>(statusDocumental),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Beneficiario copyWith(
          {String? id,
          String? loteId,
          String? nomeResponsavel,
          Value<String?> cpf = const Value.absent(),
          Value<String?> telefone = const Value.absent(),
          Value<String?> statusDocumental = const Value.absent(),
          DateTime? updatedAt}) =>
      Beneficiario(
        id: id ?? this.id,
        loteId: loteId ?? this.loteId,
        nomeResponsavel: nomeResponsavel ?? this.nomeResponsavel,
        cpf: cpf.present ? cpf.value : this.cpf,
        telefone: telefone.present ? telefone.value : this.telefone,
        statusDocumental: statusDocumental.present
            ? statusDocumental.value
            : this.statusDocumental,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Beneficiario copyWithCompanion(BeneficiariosCompanion data) {
    return Beneficiario(
      id: data.id.present ? data.id.value : this.id,
      loteId: data.loteId.present ? data.loteId.value : this.loteId,
      nomeResponsavel: data.nomeResponsavel.present
          ? data.nomeResponsavel.value
          : this.nomeResponsavel,
      cpf: data.cpf.present ? data.cpf.value : this.cpf,
      telefone: data.telefone.present ? data.telefone.value : this.telefone,
      statusDocumental: data.statusDocumental.present
          ? data.statusDocumental.value
          : this.statusDocumental,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Beneficiario(')
          ..write('id: $id, ')
          ..write('loteId: $loteId, ')
          ..write('nomeResponsavel: $nomeResponsavel, ')
          ..write('cpf: $cpf, ')
          ..write('telefone: $telefone, ')
          ..write('statusDocumental: $statusDocumental, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, loteId, nomeResponsavel, cpf, telefone, statusDocumental, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Beneficiario &&
          other.id == this.id &&
          other.loteId == this.loteId &&
          other.nomeResponsavel == this.nomeResponsavel &&
          other.cpf == this.cpf &&
          other.telefone == this.telefone &&
          other.statusDocumental == this.statusDocumental &&
          other.updatedAt == this.updatedAt);
}

class BeneficiariosCompanion extends UpdateCompanion<Beneficiario> {
  final Value<String> id;
  final Value<String> loteId;
  final Value<String> nomeResponsavel;
  final Value<String?> cpf;
  final Value<String?> telefone;
  final Value<String?> statusDocumental;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BeneficiariosCompanion({
    this.id = const Value.absent(),
    this.loteId = const Value.absent(),
    this.nomeResponsavel = const Value.absent(),
    this.cpf = const Value.absent(),
    this.telefone = const Value.absent(),
    this.statusDocumental = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BeneficiariosCompanion.insert({
    required String id,
    required String loteId,
    required String nomeResponsavel,
    this.cpf = const Value.absent(),
    this.telefone = const Value.absent(),
    this.statusDocumental = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        loteId = Value(loteId),
        nomeResponsavel = Value(nomeResponsavel);
  static Insertable<Beneficiario> custom({
    Expression<String>? id,
    Expression<String>? loteId,
    Expression<String>? nomeResponsavel,
    Expression<String>? cpf,
    Expression<String>? telefone,
    Expression<String>? statusDocumental,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (loteId != null) 'lote_id': loteId,
      if (nomeResponsavel != null) 'nome_responsavel': nomeResponsavel,
      if (cpf != null) 'cpf': cpf,
      if (telefone != null) 'telefone': telefone,
      if (statusDocumental != null) 'status_documental': statusDocumental,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BeneficiariosCompanion copyWith(
      {Value<String>? id,
      Value<String>? loteId,
      Value<String>? nomeResponsavel,
      Value<String?>? cpf,
      Value<String?>? telefone,
      Value<String?>? statusDocumental,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return BeneficiariosCompanion(
      id: id ?? this.id,
      loteId: loteId ?? this.loteId,
      nomeResponsavel: nomeResponsavel ?? this.nomeResponsavel,
      cpf: cpf ?? this.cpf,
      telefone: telefone ?? this.telefone,
      statusDocumental: statusDocumental ?? this.statusDocumental,
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
    if (loteId.present) {
      map['lote_id'] = Variable<String>(loteId.value);
    }
    if (nomeResponsavel.present) {
      map['nome_responsavel'] = Variable<String>(nomeResponsavel.value);
    }
    if (cpf.present) {
      map['cpf'] = Variable<String>(cpf.value);
    }
    if (telefone.present) {
      map['telefone'] = Variable<String>(telefone.value);
    }
    if (statusDocumental.present) {
      map['status_documental'] = Variable<String>(statusDocumental.value);
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
    return (StringBuffer('BeneficiariosCompanion(')
          ..write('id: $id, ')
          ..write('loteId: $loteId, ')
          ..write('nomeResponsavel: $nomeResponsavel, ')
          ..write('cpf: $cpf, ')
          ..write('telefone: $telefone, ')
          ..write('statusDocumental: $statusDocumental, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SelagensTable extends Selagens with TableInfo<$SelagensTable, Selagen> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SelagensTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _projetoIdMeta =
      const VerificationMeta('projetoId');
  @override
  late final GeneratedColumn<String> projetoId = GeneratedColumn<String>(
      'projeto_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _loteIdMeta = const VerificationMeta('loteId');
  @override
  late final GeneratedColumn<String> loteId = GeneratedColumn<String>(
      'lote_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lotePreliminarIdMeta =
      const VerificationMeta('lotePreliminarId');
  @override
  late final GeneratedColumn<String> lotePreliminarId = GeneratedColumn<String>(
      'lote_preliminar_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _codigoLotePreliminarMeta =
      const VerificationMeta('codigoLotePreliminar');
  @override
  late final GeneratedColumn<String> codigoLotePreliminar =
      GeneratedColumn<String>('codigo_lote_preliminar', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusVinculoGeograficoMeta =
      const VerificationMeta('statusVinculoGeografico');
  @override
  late final GeneratedColumn<String> statusVinculoGeografico =
      GeneratedColumn<String>('status_vinculo_geografico', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('nao_validado'));
  static const VerificationMeta _necessitaValidacaoRtkMeta =
      const VerificationMeta('necessitaValidacaoRtk');
  @override
  late final GeneratedColumn<bool> necessitaValidacaoRtk =
      GeneratedColumn<bool>('necessita_validacao_rtk', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'CHECK ("necessita_validacao_rtk" IN (0, 1))'),
          defaultValue: const Constant(false));
  static const VerificationMeta _observacaoGeoespacialMeta =
      const VerificationMeta('observacaoGeoespacial');
  @override
  late final GeneratedColumn<String> observacaoGeoespacial =
      GeneratedColumn<String>('observacao_geoespacial', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _codigoSeloMeta =
      const VerificationMeta('codigoSelo');
  @override
  late final GeneratedColumn<String> codigoSelo = GeneratedColumn<String>(
      'codigo_selo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _situacaoMeta =
      const VerificationMeta('situacao');
  @override
  late final GeneratedColumn<String> situacao = GeneratedColumn<String>(
      'situacao', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _moradorPresenteMeta =
      const VerificationMeta('moradorPresente');
  @override
  late final GeneratedColumn<bool> moradorPresente = GeneratedColumn<bool>(
      'morador_presente', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("morador_presente" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _moradiaOcupadaMeta =
      const VerificationMeta('moradiaOcupada');
  @override
  late final GeneratedColumn<bool> moradiaOcupada = GeneratedColumn<bool>(
      'moradia_ocupada', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("moradia_ocupada" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _situacaoAtendimentoMeta =
      const VerificationMeta('situacaoAtendimento');
  @override
  late final GeneratedColumn<String> situacaoAtendimento =
      GeneratedColumn<String>('situacao_atendimento', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tipoUnidadeMeta =
      const VerificationMeta('tipoUnidade');
  @override
  late final GeneratedColumn<String> tipoUnidade = GeneratedColumn<String>(
      'tipo_unidade', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _usoImovelMeta =
      const VerificationMeta('usoImovel');
  @override
  late final GeneratedColumn<String> usoImovel = GeneratedColumn<String>(
      'uso_imovel', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nomeInformanteMeta =
      const VerificationMeta('nomeInformante');
  @override
  late final GeneratedColumn<String> nomeInformante = GeneratedColumn<String>(
      'nome_informante', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _telefoneInformanteMeta =
      const VerificationMeta('telefoneInformante');
  @override
  late final GeneratedColumn<String> telefoneInformante =
      GeneratedColumn<String>('telefone_informante', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _relacaoInformanteMeta =
      const VerificationMeta('relacaoInformante');
  @override
  late final GeneratedColumn<String> relacaoInformante =
      GeneratedColumn<String>('relacao_informante', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _revisitaNecessariaMeta =
      const VerificationMeta('revisitaNecessaria');
  @override
  late final GeneratedColumn<bool> revisitaNecessaria = GeneratedColumn<bool>(
      'revisita_necessaria', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("revisita_necessaria" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _precisaoGpsMeta =
      const VerificationMeta('precisaoGps');
  @override
  late final GeneratedColumn<double> precisaoGps = GeneratedColumn<double>(
      'precisao_gps', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _fotoFachadaPathMeta =
      const VerificationMeta('fotoFachadaPath');
  @override
  late final GeneratedColumn<String> fotoFachadaPath = GeneratedColumn<String>(
      'foto_fachada_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _observacoesMeta =
      const VerificationMeta('observacoes');
  @override
  late final GeneratedColumn<String> observacoes = GeneratedColumn<String>(
      'observacoes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
      'server_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourceDeviceIdMeta =
      const VerificationMeta('sourceDeviceId');
  @override
  late final GeneratedColumn<String> sourceDeviceId = GeneratedColumn<String>(
      'source_device_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _syncAttemptsMeta =
      const VerificationMeta('syncAttempts');
  @override
  late final GeneratedColumn<int> syncAttempts = GeneratedColumn<int>(
      'sync_attempts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _syncErrorMeta =
      const VerificationMeta('syncError');
  @override
  late final GeneratedColumn<String> syncError = GeneratedColumn<String>(
      'sync_error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastSyncAttemptAtMeta =
      const VerificationMeta('lastSyncAttemptAt');
  @override
  late final GeneratedColumn<DateTime> lastSyncAttemptAt =
      GeneratedColumn<DateTime>('last_sync_attempt_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _localUpdatedAtMeta =
      const VerificationMeta('localUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> localUpdatedAt =
      GeneratedColumn<DateTime>('local_updated_at', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  static const VerificationMeta _serverUpdatedAtMeta =
      const VerificationMeta('serverUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>('server_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _syncVersionMeta =
      const VerificationMeta('syncVersion');
  @override
  late final GeneratedColumn<int> syncVersion = GeneratedColumn<int>(
      'sync_version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _deletedLocallyMeta =
      const VerificationMeta('deletedLocally');
  @override
  late final GeneratedColumn<bool> deletedLocally = GeneratedColumn<bool>(
      'deleted_locally', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("deleted_locally" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        projetoId,
        loteId,
        lotePreliminarId,
        codigoLotePreliminar,
        statusVinculoGeografico,
        necessitaValidacaoRtk,
        observacaoGeoespacial,
        codigoSelo,
        situacao,
        moradorPresente,
        moradiaOcupada,
        situacaoAtendimento,
        tipoUnidade,
        usoImovel,
        nomeInformante,
        telefoneInformante,
        relacaoInformante,
        revisitaNecessaria,
        latitude,
        longitude,
        precisaoGps,
        fotoFachadaPath,
        observacoes,
        synced,
        serverId,
        sourceDeviceId,
        syncStatus,
        syncAttempts,
        syncError,
        lastSyncAttemptAt,
        syncedAt,
        localUpdatedAt,
        serverUpdatedAt,
        syncVersion,
        deletedLocally,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'selagens';
  @override
  VerificationContext validateIntegrity(Insertable<Selagen> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('projeto_id')) {
      context.handle(_projetoIdMeta,
          projetoId.isAcceptableOrUnknown(data['projeto_id']!, _projetoIdMeta));
    }
    if (data.containsKey('lote_id')) {
      context.handle(_loteIdMeta,
          loteId.isAcceptableOrUnknown(data['lote_id']!, _loteIdMeta));
    }
    if (data.containsKey('lote_preliminar_id')) {
      context.handle(
          _lotePreliminarIdMeta,
          lotePreliminarId.isAcceptableOrUnknown(
              data['lote_preliminar_id']!, _lotePreliminarIdMeta));
    }
    if (data.containsKey('codigo_lote_preliminar')) {
      context.handle(
          _codigoLotePreliminarMeta,
          codigoLotePreliminar.isAcceptableOrUnknown(
              data['codigo_lote_preliminar']!, _codigoLotePreliminarMeta));
    }
    if (data.containsKey('status_vinculo_geografico')) {
      context.handle(
          _statusVinculoGeograficoMeta,
          statusVinculoGeografico.isAcceptableOrUnknown(
              data['status_vinculo_geografico']!,
              _statusVinculoGeograficoMeta));
    }
    if (data.containsKey('necessita_validacao_rtk')) {
      context.handle(
          _necessitaValidacaoRtkMeta,
          necessitaValidacaoRtk.isAcceptableOrUnknown(
              data['necessita_validacao_rtk']!, _necessitaValidacaoRtkMeta));
    }
    if (data.containsKey('observacao_geoespacial')) {
      context.handle(
          _observacaoGeoespacialMeta,
          observacaoGeoespacial.isAcceptableOrUnknown(
              data['observacao_geoespacial']!, _observacaoGeoespacialMeta));
    }
    if (data.containsKey('codigo_selo')) {
      context.handle(
          _codigoSeloMeta,
          codigoSelo.isAcceptableOrUnknown(
              data['codigo_selo']!, _codigoSeloMeta));
    } else if (isInserting) {
      context.missing(_codigoSeloMeta);
    }
    if (data.containsKey('situacao')) {
      context.handle(_situacaoMeta,
          situacao.isAcceptableOrUnknown(data['situacao']!, _situacaoMeta));
    } else if (isInserting) {
      context.missing(_situacaoMeta);
    }
    if (data.containsKey('morador_presente')) {
      context.handle(
          _moradorPresenteMeta,
          moradorPresente.isAcceptableOrUnknown(
              data['morador_presente']!, _moradorPresenteMeta));
    }
    if (data.containsKey('moradia_ocupada')) {
      context.handle(
          _moradiaOcupadaMeta,
          moradiaOcupada.isAcceptableOrUnknown(
              data['moradia_ocupada']!, _moradiaOcupadaMeta));
    }
    if (data.containsKey('situacao_atendimento')) {
      context.handle(
          _situacaoAtendimentoMeta,
          situacaoAtendimento.isAcceptableOrUnknown(
              data['situacao_atendimento']!, _situacaoAtendimentoMeta));
    }
    if (data.containsKey('tipo_unidade')) {
      context.handle(
          _tipoUnidadeMeta,
          tipoUnidade.isAcceptableOrUnknown(
              data['tipo_unidade']!, _tipoUnidadeMeta));
    }
    if (data.containsKey('uso_imovel')) {
      context.handle(_usoImovelMeta,
          usoImovel.isAcceptableOrUnknown(data['uso_imovel']!, _usoImovelMeta));
    }
    if (data.containsKey('nome_informante')) {
      context.handle(
          _nomeInformanteMeta,
          nomeInformante.isAcceptableOrUnknown(
              data['nome_informante']!, _nomeInformanteMeta));
    }
    if (data.containsKey('telefone_informante')) {
      context.handle(
          _telefoneInformanteMeta,
          telefoneInformante.isAcceptableOrUnknown(
              data['telefone_informante']!, _telefoneInformanteMeta));
    }
    if (data.containsKey('relacao_informante')) {
      context.handle(
          _relacaoInformanteMeta,
          relacaoInformante.isAcceptableOrUnknown(
              data['relacao_informante']!, _relacaoInformanteMeta));
    }
    if (data.containsKey('revisita_necessaria')) {
      context.handle(
          _revisitaNecessariaMeta,
          revisitaNecessaria.isAcceptableOrUnknown(
              data['revisita_necessaria']!, _revisitaNecessariaMeta));
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    }
    if (data.containsKey('precisao_gps')) {
      context.handle(
          _precisaoGpsMeta,
          precisaoGps.isAcceptableOrUnknown(
              data['precisao_gps']!, _precisaoGpsMeta));
    }
    if (data.containsKey('foto_fachada_path')) {
      context.handle(
          _fotoFachadaPathMeta,
          fotoFachadaPath.isAcceptableOrUnknown(
              data['foto_fachada_path']!, _fotoFachadaPathMeta));
    }
    if (data.containsKey('observacoes')) {
      context.handle(
          _observacoesMeta,
          observacoes.isAcceptableOrUnknown(
              data['observacoes']!, _observacoesMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    }
    if (data.containsKey('source_device_id')) {
      context.handle(
          _sourceDeviceIdMeta,
          sourceDeviceId.isAcceptableOrUnknown(
              data['source_device_id']!, _sourceDeviceIdMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('sync_attempts')) {
      context.handle(
          _syncAttemptsMeta,
          syncAttempts.isAcceptableOrUnknown(
              data['sync_attempts']!, _syncAttemptsMeta));
    }
    if (data.containsKey('sync_error')) {
      context.handle(_syncErrorMeta,
          syncError.isAcceptableOrUnknown(data['sync_error']!, _syncErrorMeta));
    }
    if (data.containsKey('last_sync_attempt_at')) {
      context.handle(
          _lastSyncAttemptAtMeta,
          lastSyncAttemptAt.isAcceptableOrUnknown(
              data['last_sync_attempt_at']!, _lastSyncAttemptAtMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    if (data.containsKey('local_updated_at')) {
      context.handle(
          _localUpdatedAtMeta,
          localUpdatedAt.isAcceptableOrUnknown(
              data['local_updated_at']!, _localUpdatedAtMeta));
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
          _serverUpdatedAtMeta,
          serverUpdatedAt.isAcceptableOrUnknown(
              data['server_updated_at']!, _serverUpdatedAtMeta));
    }
    if (data.containsKey('sync_version')) {
      context.handle(
          _syncVersionMeta,
          syncVersion.isAcceptableOrUnknown(
              data['sync_version']!, _syncVersionMeta));
    }
    if (data.containsKey('deleted_locally')) {
      context.handle(
          _deletedLocallyMeta,
          deletedLocally.isAcceptableOrUnknown(
              data['deleted_locally']!, _deletedLocallyMeta));
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
  Selagen map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Selagen(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      projetoId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}projeto_id']),
      loteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lote_id']),
      lotePreliminarId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}lote_preliminar_id']),
      codigoLotePreliminar: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}codigo_lote_preliminar']),
      statusVinculoGeografico: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status_vinculo_geografico'])!,
      necessitaValidacaoRtk: attachedDatabase.typeMapping.read(
          DriftSqlType.bool,
          data['${effectivePrefix}necessita_validacao_rtk'])!,
      observacaoGeoespacial: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}observacao_geoespacial']),
      codigoSelo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}codigo_selo'])!,
      situacao: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}situacao'])!,
      moradorPresente: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}morador_presente'])!,
      moradiaOcupada: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}moradia_ocupada'])!,
      situacaoAtendimento: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}situacao_atendimento']),
      tipoUnidade: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tipo_unidade']),
      usoImovel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uso_imovel']),
      nomeInformante: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome_informante']),
      telefoneInformante: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}telefone_informante']),
      relacaoInformante: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}relacao_informante']),
      revisitaNecessaria: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}revisita_necessaria'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude']),
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude']),
      precisaoGps: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}precisao_gps']),
      fotoFachadaPath: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}foto_fachada_path']),
      observacoes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}observacoes']),
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}server_id']),
      sourceDeviceId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}source_device_id']),
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      syncAttempts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sync_attempts'])!,
      syncError: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_error']),
      lastSyncAttemptAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}last_sync_attempt_at']),
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
      localUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}local_updated_at'])!,
      serverUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}server_updated_at']),
      syncVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sync_version'])!,
      deletedLocally: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted_locally'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SelagensTable createAlias(String alias) {
    return $SelagensTable(attachedDatabase, alias);
  }
}

class Selagen extends DataClass implements Insertable<Selagen> {
  final String id;
  final String? projetoId;
  final String? loteId;
  final String? lotePreliminarId;
  final String? codigoLotePreliminar;
  final String statusVinculoGeografico;
  final bool necessitaValidacaoRtk;
  final String? observacaoGeoespacial;
  final String codigoSelo;
  final String situacao;
  final bool moradorPresente;
  final bool moradiaOcupada;
  final String? situacaoAtendimento;
  final String? tipoUnidade;
  final String? usoImovel;
  final String? nomeInformante;
  final String? telefoneInformante;
  final String? relacaoInformante;
  final bool revisitaNecessaria;
  final double? latitude;
  final double? longitude;
  final double? precisaoGps;
  final String? fotoFachadaPath;
  final String? observacoes;
  final bool synced;
  final String? serverId;
  final String? sourceDeviceId;
  final String syncStatus;
  final int syncAttempts;
  final String? syncError;
  final DateTime? lastSyncAttemptAt;
  final DateTime? syncedAt;
  final DateTime localUpdatedAt;
  final DateTime? serverUpdatedAt;
  final int syncVersion;
  final bool deletedLocally;
  final DateTime createdAt;
  const Selagen(
      {required this.id,
      this.projetoId,
      this.loteId,
      this.lotePreliminarId,
      this.codigoLotePreliminar,
      required this.statusVinculoGeografico,
      required this.necessitaValidacaoRtk,
      this.observacaoGeoespacial,
      required this.codigoSelo,
      required this.situacao,
      required this.moradorPresente,
      required this.moradiaOcupada,
      this.situacaoAtendimento,
      this.tipoUnidade,
      this.usoImovel,
      this.nomeInformante,
      this.telefoneInformante,
      this.relacaoInformante,
      required this.revisitaNecessaria,
      this.latitude,
      this.longitude,
      this.precisaoGps,
      this.fotoFachadaPath,
      this.observacoes,
      required this.synced,
      this.serverId,
      this.sourceDeviceId,
      required this.syncStatus,
      required this.syncAttempts,
      this.syncError,
      this.lastSyncAttemptAt,
      this.syncedAt,
      required this.localUpdatedAt,
      this.serverUpdatedAt,
      required this.syncVersion,
      required this.deletedLocally,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || projetoId != null) {
      map['projeto_id'] = Variable<String>(projetoId);
    }
    if (!nullToAbsent || loteId != null) {
      map['lote_id'] = Variable<String>(loteId);
    }
    if (!nullToAbsent || lotePreliminarId != null) {
      map['lote_preliminar_id'] = Variable<String>(lotePreliminarId);
    }
    if (!nullToAbsent || codigoLotePreliminar != null) {
      map['codigo_lote_preliminar'] = Variable<String>(codigoLotePreliminar);
    }
    map['status_vinculo_geografico'] =
        Variable<String>(statusVinculoGeografico);
    map['necessita_validacao_rtk'] = Variable<bool>(necessitaValidacaoRtk);
    if (!nullToAbsent || observacaoGeoespacial != null) {
      map['observacao_geoespacial'] = Variable<String>(observacaoGeoespacial);
    }
    map['codigo_selo'] = Variable<String>(codigoSelo);
    map['situacao'] = Variable<String>(situacao);
    map['morador_presente'] = Variable<bool>(moradorPresente);
    map['moradia_ocupada'] = Variable<bool>(moradiaOcupada);
    if (!nullToAbsent || situacaoAtendimento != null) {
      map['situacao_atendimento'] = Variable<String>(situacaoAtendimento);
    }
    if (!nullToAbsent || tipoUnidade != null) {
      map['tipo_unidade'] = Variable<String>(tipoUnidade);
    }
    if (!nullToAbsent || usoImovel != null) {
      map['uso_imovel'] = Variable<String>(usoImovel);
    }
    if (!nullToAbsent || nomeInformante != null) {
      map['nome_informante'] = Variable<String>(nomeInformante);
    }
    if (!nullToAbsent || telefoneInformante != null) {
      map['telefone_informante'] = Variable<String>(telefoneInformante);
    }
    if (!nullToAbsent || relacaoInformante != null) {
      map['relacao_informante'] = Variable<String>(relacaoInformante);
    }
    map['revisita_necessaria'] = Variable<bool>(revisitaNecessaria);
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || precisaoGps != null) {
      map['precisao_gps'] = Variable<double>(precisaoGps);
    }
    if (!nullToAbsent || fotoFachadaPath != null) {
      map['foto_fachada_path'] = Variable<String>(fotoFachadaPath);
    }
    if (!nullToAbsent || observacoes != null) {
      map['observacoes'] = Variable<String>(observacoes);
    }
    map['synced'] = Variable<bool>(synced);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    if (!nullToAbsent || sourceDeviceId != null) {
      map['source_device_id'] = Variable<String>(sourceDeviceId);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['sync_attempts'] = Variable<int>(syncAttempts);
    if (!nullToAbsent || syncError != null) {
      map['sync_error'] = Variable<String>(syncError);
    }
    if (!nullToAbsent || lastSyncAttemptAt != null) {
      map['last_sync_attempt_at'] = Variable<DateTime>(lastSyncAttemptAt);
    }
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['local_updated_at'] = Variable<DateTime>(localUpdatedAt);
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    }
    map['sync_version'] = Variable<int>(syncVersion);
    map['deleted_locally'] = Variable<bool>(deletedLocally);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SelagensCompanion toCompanion(bool nullToAbsent) {
    return SelagensCompanion(
      id: Value(id),
      projetoId: projetoId == null && nullToAbsent
          ? const Value.absent()
          : Value(projetoId),
      loteId:
          loteId == null && nullToAbsent ? const Value.absent() : Value(loteId),
      lotePreliminarId: lotePreliminarId == null && nullToAbsent
          ? const Value.absent()
          : Value(lotePreliminarId),
      codigoLotePreliminar: codigoLotePreliminar == null && nullToAbsent
          ? const Value.absent()
          : Value(codigoLotePreliminar),
      statusVinculoGeografico: Value(statusVinculoGeografico),
      necessitaValidacaoRtk: Value(necessitaValidacaoRtk),
      observacaoGeoespacial: observacaoGeoespacial == null && nullToAbsent
          ? const Value.absent()
          : Value(observacaoGeoespacial),
      codigoSelo: Value(codigoSelo),
      situacao: Value(situacao),
      moradorPresente: Value(moradorPresente),
      moradiaOcupada: Value(moradiaOcupada),
      situacaoAtendimento: situacaoAtendimento == null && nullToAbsent
          ? const Value.absent()
          : Value(situacaoAtendimento),
      tipoUnidade: tipoUnidade == null && nullToAbsent
          ? const Value.absent()
          : Value(tipoUnidade),
      usoImovel: usoImovel == null && nullToAbsent
          ? const Value.absent()
          : Value(usoImovel),
      nomeInformante: nomeInformante == null && nullToAbsent
          ? const Value.absent()
          : Value(nomeInformante),
      telefoneInformante: telefoneInformante == null && nullToAbsent
          ? const Value.absent()
          : Value(telefoneInformante),
      relacaoInformante: relacaoInformante == null && nullToAbsent
          ? const Value.absent()
          : Value(relacaoInformante),
      revisitaNecessaria: Value(revisitaNecessaria),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      precisaoGps: precisaoGps == null && nullToAbsent
          ? const Value.absent()
          : Value(precisaoGps),
      fotoFachadaPath: fotoFachadaPath == null && nullToAbsent
          ? const Value.absent()
          : Value(fotoFachadaPath),
      observacoes: observacoes == null && nullToAbsent
          ? const Value.absent()
          : Value(observacoes),
      synced: Value(synced),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      sourceDeviceId: sourceDeviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceDeviceId),
      syncStatus: Value(syncStatus),
      syncAttempts: Value(syncAttempts),
      syncError: syncError == null && nullToAbsent
          ? const Value.absent()
          : Value(syncError),
      lastSyncAttemptAt: lastSyncAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAttemptAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      localUpdatedAt: Value(localUpdatedAt),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      syncVersion: Value(syncVersion),
      deletedLocally: Value(deletedLocally),
      createdAt: Value(createdAt),
    );
  }

  factory Selagen.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Selagen(
      id: serializer.fromJson<String>(json['id']),
      projetoId: serializer.fromJson<String?>(json['projetoId']),
      loteId: serializer.fromJson<String?>(json['loteId']),
      lotePreliminarId: serializer.fromJson<String?>(json['lotePreliminarId']),
      codigoLotePreliminar:
          serializer.fromJson<String?>(json['codigoLotePreliminar']),
      statusVinculoGeografico:
          serializer.fromJson<String>(json['statusVinculoGeografico']),
      necessitaValidacaoRtk:
          serializer.fromJson<bool>(json['necessitaValidacaoRtk']),
      observacaoGeoespacial:
          serializer.fromJson<String?>(json['observacaoGeoespacial']),
      codigoSelo: serializer.fromJson<String>(json['codigoSelo']),
      situacao: serializer.fromJson<String>(json['situacao']),
      moradorPresente: serializer.fromJson<bool>(json['moradorPresente']),
      moradiaOcupada: serializer.fromJson<bool>(json['moradiaOcupada']),
      situacaoAtendimento:
          serializer.fromJson<String?>(json['situacaoAtendimento']),
      tipoUnidade: serializer.fromJson<String?>(json['tipoUnidade']),
      usoImovel: serializer.fromJson<String?>(json['usoImovel']),
      nomeInformante: serializer.fromJson<String?>(json['nomeInformante']),
      telefoneInformante:
          serializer.fromJson<String?>(json['telefoneInformante']),
      relacaoInformante:
          serializer.fromJson<String?>(json['relacaoInformante']),
      revisitaNecessaria: serializer.fromJson<bool>(json['revisitaNecessaria']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      precisaoGps: serializer.fromJson<double?>(json['precisaoGps']),
      fotoFachadaPath: serializer.fromJson<String?>(json['fotoFachadaPath']),
      observacoes: serializer.fromJson<String?>(json['observacoes']),
      synced: serializer.fromJson<bool>(json['synced']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      sourceDeviceId: serializer.fromJson<String?>(json['sourceDeviceId']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      syncAttempts: serializer.fromJson<int>(json['syncAttempts']),
      syncError: serializer.fromJson<String?>(json['syncError']),
      lastSyncAttemptAt:
          serializer.fromJson<DateTime?>(json['lastSyncAttemptAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      localUpdatedAt: serializer.fromJson<DateTime>(json['localUpdatedAt']),
      serverUpdatedAt: serializer.fromJson<DateTime?>(json['serverUpdatedAt']),
      syncVersion: serializer.fromJson<int>(json['syncVersion']),
      deletedLocally: serializer.fromJson<bool>(json['deletedLocally']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projetoId': serializer.toJson<String?>(projetoId),
      'loteId': serializer.toJson<String?>(loteId),
      'lotePreliminarId': serializer.toJson<String?>(lotePreliminarId),
      'codigoLotePreliminar': serializer.toJson<String?>(codigoLotePreliminar),
      'statusVinculoGeografico':
          serializer.toJson<String>(statusVinculoGeografico),
      'necessitaValidacaoRtk': serializer.toJson<bool>(necessitaValidacaoRtk),
      'observacaoGeoespacial':
          serializer.toJson<String?>(observacaoGeoespacial),
      'codigoSelo': serializer.toJson<String>(codigoSelo),
      'situacao': serializer.toJson<String>(situacao),
      'moradorPresente': serializer.toJson<bool>(moradorPresente),
      'moradiaOcupada': serializer.toJson<bool>(moradiaOcupada),
      'situacaoAtendimento': serializer.toJson<String?>(situacaoAtendimento),
      'tipoUnidade': serializer.toJson<String?>(tipoUnidade),
      'usoImovel': serializer.toJson<String?>(usoImovel),
      'nomeInformante': serializer.toJson<String?>(nomeInformante),
      'telefoneInformante': serializer.toJson<String?>(telefoneInformante),
      'relacaoInformante': serializer.toJson<String?>(relacaoInformante),
      'revisitaNecessaria': serializer.toJson<bool>(revisitaNecessaria),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'precisaoGps': serializer.toJson<double?>(precisaoGps),
      'fotoFachadaPath': serializer.toJson<String?>(fotoFachadaPath),
      'observacoes': serializer.toJson<String?>(observacoes),
      'synced': serializer.toJson<bool>(synced),
      'serverId': serializer.toJson<String?>(serverId),
      'sourceDeviceId': serializer.toJson<String?>(sourceDeviceId),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'syncAttempts': serializer.toJson<int>(syncAttempts),
      'syncError': serializer.toJson<String?>(syncError),
      'lastSyncAttemptAt': serializer.toJson<DateTime?>(lastSyncAttemptAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'localUpdatedAt': serializer.toJson<DateTime>(localUpdatedAt),
      'serverUpdatedAt': serializer.toJson<DateTime?>(serverUpdatedAt),
      'syncVersion': serializer.toJson<int>(syncVersion),
      'deletedLocally': serializer.toJson<bool>(deletedLocally),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Selagen copyWith(
          {String? id,
          Value<String?> projetoId = const Value.absent(),
          Value<String?> loteId = const Value.absent(),
          Value<String?> lotePreliminarId = const Value.absent(),
          Value<String?> codigoLotePreliminar = const Value.absent(),
          String? statusVinculoGeografico,
          bool? necessitaValidacaoRtk,
          Value<String?> observacaoGeoespacial = const Value.absent(),
          String? codigoSelo,
          String? situacao,
          bool? moradorPresente,
          bool? moradiaOcupada,
          Value<String?> situacaoAtendimento = const Value.absent(),
          Value<String?> tipoUnidade = const Value.absent(),
          Value<String?> usoImovel = const Value.absent(),
          Value<String?> nomeInformante = const Value.absent(),
          Value<String?> telefoneInformante = const Value.absent(),
          Value<String?> relacaoInformante = const Value.absent(),
          bool? revisitaNecessaria,
          Value<double?> latitude = const Value.absent(),
          Value<double?> longitude = const Value.absent(),
          Value<double?> precisaoGps = const Value.absent(),
          Value<String?> fotoFachadaPath = const Value.absent(),
          Value<String?> observacoes = const Value.absent(),
          bool? synced,
          Value<String?> serverId = const Value.absent(),
          Value<String?> sourceDeviceId = const Value.absent(),
          String? syncStatus,
          int? syncAttempts,
          Value<String?> syncError = const Value.absent(),
          Value<DateTime?> lastSyncAttemptAt = const Value.absent(),
          Value<DateTime?> syncedAt = const Value.absent(),
          DateTime? localUpdatedAt,
          Value<DateTime?> serverUpdatedAt = const Value.absent(),
          int? syncVersion,
          bool? deletedLocally,
          DateTime? createdAt}) =>
      Selagen(
        id: id ?? this.id,
        projetoId: projetoId.present ? projetoId.value : this.projetoId,
        loteId: loteId.present ? loteId.value : this.loteId,
        lotePreliminarId: lotePreliminarId.present
            ? lotePreliminarId.value
            : this.lotePreliminarId,
        codigoLotePreliminar: codigoLotePreliminar.present
            ? codigoLotePreliminar.value
            : this.codigoLotePreliminar,
        statusVinculoGeografico:
            statusVinculoGeografico ?? this.statusVinculoGeografico,
        necessitaValidacaoRtk:
            necessitaValidacaoRtk ?? this.necessitaValidacaoRtk,
        observacaoGeoespacial: observacaoGeoespacial.present
            ? observacaoGeoespacial.value
            : this.observacaoGeoespacial,
        codigoSelo: codigoSelo ?? this.codigoSelo,
        situacao: situacao ?? this.situacao,
        moradorPresente: moradorPresente ?? this.moradorPresente,
        moradiaOcupada: moradiaOcupada ?? this.moradiaOcupada,
        situacaoAtendimento: situacaoAtendimento.present
            ? situacaoAtendimento.value
            : this.situacaoAtendimento,
        tipoUnidade: tipoUnidade.present ? tipoUnidade.value : this.tipoUnidade,
        usoImovel: usoImovel.present ? usoImovel.value : this.usoImovel,
        nomeInformante:
            nomeInformante.present ? nomeInformante.value : this.nomeInformante,
        telefoneInformante: telefoneInformante.present
            ? telefoneInformante.value
            : this.telefoneInformante,
        relacaoInformante: relacaoInformante.present
            ? relacaoInformante.value
            : this.relacaoInformante,
        revisitaNecessaria: revisitaNecessaria ?? this.revisitaNecessaria,
        latitude: latitude.present ? latitude.value : this.latitude,
        longitude: longitude.present ? longitude.value : this.longitude,
        precisaoGps: precisaoGps.present ? precisaoGps.value : this.precisaoGps,
        fotoFachadaPath: fotoFachadaPath.present
            ? fotoFachadaPath.value
            : this.fotoFachadaPath,
        observacoes: observacoes.present ? observacoes.value : this.observacoes,
        synced: synced ?? this.synced,
        serverId: serverId.present ? serverId.value : this.serverId,
        sourceDeviceId:
            sourceDeviceId.present ? sourceDeviceId.value : this.sourceDeviceId,
        syncStatus: syncStatus ?? this.syncStatus,
        syncAttempts: syncAttempts ?? this.syncAttempts,
        syncError: syncError.present ? syncError.value : this.syncError,
        lastSyncAttemptAt: lastSyncAttemptAt.present
            ? lastSyncAttemptAt.value
            : this.lastSyncAttemptAt,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
        localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
        serverUpdatedAt: serverUpdatedAt.present
            ? serverUpdatedAt.value
            : this.serverUpdatedAt,
        syncVersion: syncVersion ?? this.syncVersion,
        deletedLocally: deletedLocally ?? this.deletedLocally,
        createdAt: createdAt ?? this.createdAt,
      );
  Selagen copyWithCompanion(SelagensCompanion data) {
    return Selagen(
      id: data.id.present ? data.id.value : this.id,
      projetoId: data.projetoId.present ? data.projetoId.value : this.projetoId,
      loteId: data.loteId.present ? data.loteId.value : this.loteId,
      lotePreliminarId: data.lotePreliminarId.present
          ? data.lotePreliminarId.value
          : this.lotePreliminarId,
      codigoLotePreliminar: data.codigoLotePreliminar.present
          ? data.codigoLotePreliminar.value
          : this.codigoLotePreliminar,
      statusVinculoGeografico: data.statusVinculoGeografico.present
          ? data.statusVinculoGeografico.value
          : this.statusVinculoGeografico,
      necessitaValidacaoRtk: data.necessitaValidacaoRtk.present
          ? data.necessitaValidacaoRtk.value
          : this.necessitaValidacaoRtk,
      observacaoGeoespacial: data.observacaoGeoespacial.present
          ? data.observacaoGeoespacial.value
          : this.observacaoGeoespacial,
      codigoSelo:
          data.codigoSelo.present ? data.codigoSelo.value : this.codigoSelo,
      situacao: data.situacao.present ? data.situacao.value : this.situacao,
      moradorPresente: data.moradorPresente.present
          ? data.moradorPresente.value
          : this.moradorPresente,
      moradiaOcupada: data.moradiaOcupada.present
          ? data.moradiaOcupada.value
          : this.moradiaOcupada,
      situacaoAtendimento: data.situacaoAtendimento.present
          ? data.situacaoAtendimento.value
          : this.situacaoAtendimento,
      tipoUnidade:
          data.tipoUnidade.present ? data.tipoUnidade.value : this.tipoUnidade,
      usoImovel: data.usoImovel.present ? data.usoImovel.value : this.usoImovel,
      nomeInformante: data.nomeInformante.present
          ? data.nomeInformante.value
          : this.nomeInformante,
      telefoneInformante: data.telefoneInformante.present
          ? data.telefoneInformante.value
          : this.telefoneInformante,
      relacaoInformante: data.relacaoInformante.present
          ? data.relacaoInformante.value
          : this.relacaoInformante,
      revisitaNecessaria: data.revisitaNecessaria.present
          ? data.revisitaNecessaria.value
          : this.revisitaNecessaria,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      precisaoGps:
          data.precisaoGps.present ? data.precisaoGps.value : this.precisaoGps,
      fotoFachadaPath: data.fotoFachadaPath.present
          ? data.fotoFachadaPath.value
          : this.fotoFachadaPath,
      observacoes:
          data.observacoes.present ? data.observacoes.value : this.observacoes,
      synced: data.synced.present ? data.synced.value : this.synced,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      sourceDeviceId: data.sourceDeviceId.present
          ? data.sourceDeviceId.value
          : this.sourceDeviceId,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      syncAttempts: data.syncAttempts.present
          ? data.syncAttempts.value
          : this.syncAttempts,
      syncError: data.syncError.present ? data.syncError.value : this.syncError,
      lastSyncAttemptAt: data.lastSyncAttemptAt.present
          ? data.lastSyncAttemptAt.value
          : this.lastSyncAttemptAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      localUpdatedAt: data.localUpdatedAt.present
          ? data.localUpdatedAt.value
          : this.localUpdatedAt,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      syncVersion:
          data.syncVersion.present ? data.syncVersion.value : this.syncVersion,
      deletedLocally: data.deletedLocally.present
          ? data.deletedLocally.value
          : this.deletedLocally,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Selagen(')
          ..write('id: $id, ')
          ..write('projetoId: $projetoId, ')
          ..write('loteId: $loteId, ')
          ..write('lotePreliminarId: $lotePreliminarId, ')
          ..write('codigoLotePreliminar: $codigoLotePreliminar, ')
          ..write('statusVinculoGeografico: $statusVinculoGeografico, ')
          ..write('necessitaValidacaoRtk: $necessitaValidacaoRtk, ')
          ..write('observacaoGeoespacial: $observacaoGeoespacial, ')
          ..write('codigoSelo: $codigoSelo, ')
          ..write('situacao: $situacao, ')
          ..write('moradorPresente: $moradorPresente, ')
          ..write('moradiaOcupada: $moradiaOcupada, ')
          ..write('situacaoAtendimento: $situacaoAtendimento, ')
          ..write('tipoUnidade: $tipoUnidade, ')
          ..write('usoImovel: $usoImovel, ')
          ..write('nomeInformante: $nomeInformante, ')
          ..write('telefoneInformante: $telefoneInformante, ')
          ..write('relacaoInformante: $relacaoInformante, ')
          ..write('revisitaNecessaria: $revisitaNecessaria, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('precisaoGps: $precisaoGps, ')
          ..write('fotoFachadaPath: $fotoFachadaPath, ')
          ..write('observacoes: $observacoes, ')
          ..write('synced: $synced, ')
          ..write('serverId: $serverId, ')
          ..write('sourceDeviceId: $sourceDeviceId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncAttempts: $syncAttempts, ')
          ..write('syncError: $syncError, ')
          ..write('lastSyncAttemptAt: $lastSyncAttemptAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('deletedLocally: $deletedLocally, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        projetoId,
        loteId,
        lotePreliminarId,
        codigoLotePreliminar,
        statusVinculoGeografico,
        necessitaValidacaoRtk,
        observacaoGeoespacial,
        codigoSelo,
        situacao,
        moradorPresente,
        moradiaOcupada,
        situacaoAtendimento,
        tipoUnidade,
        usoImovel,
        nomeInformante,
        telefoneInformante,
        relacaoInformante,
        revisitaNecessaria,
        latitude,
        longitude,
        precisaoGps,
        fotoFachadaPath,
        observacoes,
        synced,
        serverId,
        sourceDeviceId,
        syncStatus,
        syncAttempts,
        syncError,
        lastSyncAttemptAt,
        syncedAt,
        localUpdatedAt,
        serverUpdatedAt,
        syncVersion,
        deletedLocally,
        createdAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Selagen &&
          other.id == this.id &&
          other.projetoId == this.projetoId &&
          other.loteId == this.loteId &&
          other.lotePreliminarId == this.lotePreliminarId &&
          other.codigoLotePreliminar == this.codigoLotePreliminar &&
          other.statusVinculoGeografico == this.statusVinculoGeografico &&
          other.necessitaValidacaoRtk == this.necessitaValidacaoRtk &&
          other.observacaoGeoespacial == this.observacaoGeoespacial &&
          other.codigoSelo == this.codigoSelo &&
          other.situacao == this.situacao &&
          other.moradorPresente == this.moradorPresente &&
          other.moradiaOcupada == this.moradiaOcupada &&
          other.situacaoAtendimento == this.situacaoAtendimento &&
          other.tipoUnidade == this.tipoUnidade &&
          other.usoImovel == this.usoImovel &&
          other.nomeInformante == this.nomeInformante &&
          other.telefoneInformante == this.telefoneInformante &&
          other.relacaoInformante == this.relacaoInformante &&
          other.revisitaNecessaria == this.revisitaNecessaria &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.precisaoGps == this.precisaoGps &&
          other.fotoFachadaPath == this.fotoFachadaPath &&
          other.observacoes == this.observacoes &&
          other.synced == this.synced &&
          other.serverId == this.serverId &&
          other.sourceDeviceId == this.sourceDeviceId &&
          other.syncStatus == this.syncStatus &&
          other.syncAttempts == this.syncAttempts &&
          other.syncError == this.syncError &&
          other.lastSyncAttemptAt == this.lastSyncAttemptAt &&
          other.syncedAt == this.syncedAt &&
          other.localUpdatedAt == this.localUpdatedAt &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.syncVersion == this.syncVersion &&
          other.deletedLocally == this.deletedLocally &&
          other.createdAt == this.createdAt);
}

class SelagensCompanion extends UpdateCompanion<Selagen> {
  final Value<String> id;
  final Value<String?> projetoId;
  final Value<String?> loteId;
  final Value<String?> lotePreliminarId;
  final Value<String?> codigoLotePreliminar;
  final Value<String> statusVinculoGeografico;
  final Value<bool> necessitaValidacaoRtk;
  final Value<String?> observacaoGeoespacial;
  final Value<String> codigoSelo;
  final Value<String> situacao;
  final Value<bool> moradorPresente;
  final Value<bool> moradiaOcupada;
  final Value<String?> situacaoAtendimento;
  final Value<String?> tipoUnidade;
  final Value<String?> usoImovel;
  final Value<String?> nomeInformante;
  final Value<String?> telefoneInformante;
  final Value<String?> relacaoInformante;
  final Value<bool> revisitaNecessaria;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<double?> precisaoGps;
  final Value<String?> fotoFachadaPath;
  final Value<String?> observacoes;
  final Value<bool> synced;
  final Value<String?> serverId;
  final Value<String?> sourceDeviceId;
  final Value<String> syncStatus;
  final Value<int> syncAttempts;
  final Value<String?> syncError;
  final Value<DateTime?> lastSyncAttemptAt;
  final Value<DateTime?> syncedAt;
  final Value<DateTime> localUpdatedAt;
  final Value<DateTime?> serverUpdatedAt;
  final Value<int> syncVersion;
  final Value<bool> deletedLocally;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SelagensCompanion({
    this.id = const Value.absent(),
    this.projetoId = const Value.absent(),
    this.loteId = const Value.absent(),
    this.lotePreliminarId = const Value.absent(),
    this.codigoLotePreliminar = const Value.absent(),
    this.statusVinculoGeografico = const Value.absent(),
    this.necessitaValidacaoRtk = const Value.absent(),
    this.observacaoGeoespacial = const Value.absent(),
    this.codigoSelo = const Value.absent(),
    this.situacao = const Value.absent(),
    this.moradorPresente = const Value.absent(),
    this.moradiaOcupada = const Value.absent(),
    this.situacaoAtendimento = const Value.absent(),
    this.tipoUnidade = const Value.absent(),
    this.usoImovel = const Value.absent(),
    this.nomeInformante = const Value.absent(),
    this.telefoneInformante = const Value.absent(),
    this.relacaoInformante = const Value.absent(),
    this.revisitaNecessaria = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.precisaoGps = const Value.absent(),
    this.fotoFachadaPath = const Value.absent(),
    this.observacoes = const Value.absent(),
    this.synced = const Value.absent(),
    this.serverId = const Value.absent(),
    this.sourceDeviceId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncAttempts = const Value.absent(),
    this.syncError = const Value.absent(),
    this.lastSyncAttemptAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.deletedLocally = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SelagensCompanion.insert({
    required String id,
    this.projetoId = const Value.absent(),
    this.loteId = const Value.absent(),
    this.lotePreliminarId = const Value.absent(),
    this.codigoLotePreliminar = const Value.absent(),
    this.statusVinculoGeografico = const Value.absent(),
    this.necessitaValidacaoRtk = const Value.absent(),
    this.observacaoGeoespacial = const Value.absent(),
    required String codigoSelo,
    required String situacao,
    this.moradorPresente = const Value.absent(),
    this.moradiaOcupada = const Value.absent(),
    this.situacaoAtendimento = const Value.absent(),
    this.tipoUnidade = const Value.absent(),
    this.usoImovel = const Value.absent(),
    this.nomeInformante = const Value.absent(),
    this.telefoneInformante = const Value.absent(),
    this.relacaoInformante = const Value.absent(),
    this.revisitaNecessaria = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.precisaoGps = const Value.absent(),
    this.fotoFachadaPath = const Value.absent(),
    this.observacoes = const Value.absent(),
    this.synced = const Value.absent(),
    this.serverId = const Value.absent(),
    this.sourceDeviceId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncAttempts = const Value.absent(),
    this.syncError = const Value.absent(),
    this.lastSyncAttemptAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.deletedLocally = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        codigoSelo = Value(codigoSelo),
        situacao = Value(situacao);
  static Insertable<Selagen> custom({
    Expression<String>? id,
    Expression<String>? projetoId,
    Expression<String>? loteId,
    Expression<String>? lotePreliminarId,
    Expression<String>? codigoLotePreliminar,
    Expression<String>? statusVinculoGeografico,
    Expression<bool>? necessitaValidacaoRtk,
    Expression<String>? observacaoGeoespacial,
    Expression<String>? codigoSelo,
    Expression<String>? situacao,
    Expression<bool>? moradorPresente,
    Expression<bool>? moradiaOcupada,
    Expression<String>? situacaoAtendimento,
    Expression<String>? tipoUnidade,
    Expression<String>? usoImovel,
    Expression<String>? nomeInformante,
    Expression<String>? telefoneInformante,
    Expression<String>? relacaoInformante,
    Expression<bool>? revisitaNecessaria,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? precisaoGps,
    Expression<String>? fotoFachadaPath,
    Expression<String>? observacoes,
    Expression<bool>? synced,
    Expression<String>? serverId,
    Expression<String>? sourceDeviceId,
    Expression<String>? syncStatus,
    Expression<int>? syncAttempts,
    Expression<String>? syncError,
    Expression<DateTime>? lastSyncAttemptAt,
    Expression<DateTime>? syncedAt,
    Expression<DateTime>? localUpdatedAt,
    Expression<DateTime>? serverUpdatedAt,
    Expression<int>? syncVersion,
    Expression<bool>? deletedLocally,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projetoId != null) 'projeto_id': projetoId,
      if (loteId != null) 'lote_id': loteId,
      if (lotePreliminarId != null) 'lote_preliminar_id': lotePreliminarId,
      if (codigoLotePreliminar != null)
        'codigo_lote_preliminar': codigoLotePreliminar,
      if (statusVinculoGeografico != null)
        'status_vinculo_geografico': statusVinculoGeografico,
      if (necessitaValidacaoRtk != null)
        'necessita_validacao_rtk': necessitaValidacaoRtk,
      if (observacaoGeoespacial != null)
        'observacao_geoespacial': observacaoGeoespacial,
      if (codigoSelo != null) 'codigo_selo': codigoSelo,
      if (situacao != null) 'situacao': situacao,
      if (moradorPresente != null) 'morador_presente': moradorPresente,
      if (moradiaOcupada != null) 'moradia_ocupada': moradiaOcupada,
      if (situacaoAtendimento != null)
        'situacao_atendimento': situacaoAtendimento,
      if (tipoUnidade != null) 'tipo_unidade': tipoUnidade,
      if (usoImovel != null) 'uso_imovel': usoImovel,
      if (nomeInformante != null) 'nome_informante': nomeInformante,
      if (telefoneInformante != null) 'telefone_informante': telefoneInformante,
      if (relacaoInformante != null) 'relacao_informante': relacaoInformante,
      if (revisitaNecessaria != null) 'revisita_necessaria': revisitaNecessaria,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (precisaoGps != null) 'precisao_gps': precisaoGps,
      if (fotoFachadaPath != null) 'foto_fachada_path': fotoFachadaPath,
      if (observacoes != null) 'observacoes': observacoes,
      if (synced != null) 'synced': synced,
      if (serverId != null) 'server_id': serverId,
      if (sourceDeviceId != null) 'source_device_id': sourceDeviceId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncAttempts != null) 'sync_attempts': syncAttempts,
      if (syncError != null) 'sync_error': syncError,
      if (lastSyncAttemptAt != null) 'last_sync_attempt_at': lastSyncAttemptAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (localUpdatedAt != null) 'local_updated_at': localUpdatedAt,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (syncVersion != null) 'sync_version': syncVersion,
      if (deletedLocally != null) 'deleted_locally': deletedLocally,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SelagensCompanion copyWith(
      {Value<String>? id,
      Value<String?>? projetoId,
      Value<String?>? loteId,
      Value<String?>? lotePreliminarId,
      Value<String?>? codigoLotePreliminar,
      Value<String>? statusVinculoGeografico,
      Value<bool>? necessitaValidacaoRtk,
      Value<String?>? observacaoGeoespacial,
      Value<String>? codigoSelo,
      Value<String>? situacao,
      Value<bool>? moradorPresente,
      Value<bool>? moradiaOcupada,
      Value<String?>? situacaoAtendimento,
      Value<String?>? tipoUnidade,
      Value<String?>? usoImovel,
      Value<String?>? nomeInformante,
      Value<String?>? telefoneInformante,
      Value<String?>? relacaoInformante,
      Value<bool>? revisitaNecessaria,
      Value<double?>? latitude,
      Value<double?>? longitude,
      Value<double?>? precisaoGps,
      Value<String?>? fotoFachadaPath,
      Value<String?>? observacoes,
      Value<bool>? synced,
      Value<String?>? serverId,
      Value<String?>? sourceDeviceId,
      Value<String>? syncStatus,
      Value<int>? syncAttempts,
      Value<String?>? syncError,
      Value<DateTime?>? lastSyncAttemptAt,
      Value<DateTime?>? syncedAt,
      Value<DateTime>? localUpdatedAt,
      Value<DateTime?>? serverUpdatedAt,
      Value<int>? syncVersion,
      Value<bool>? deletedLocally,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return SelagensCompanion(
      id: id ?? this.id,
      projetoId: projetoId ?? this.projetoId,
      loteId: loteId ?? this.loteId,
      lotePreliminarId: lotePreliminarId ?? this.lotePreliminarId,
      codigoLotePreliminar: codigoLotePreliminar ?? this.codigoLotePreliminar,
      statusVinculoGeografico:
          statusVinculoGeografico ?? this.statusVinculoGeografico,
      necessitaValidacaoRtk:
          necessitaValidacaoRtk ?? this.necessitaValidacaoRtk,
      observacaoGeoespacial:
          observacaoGeoespacial ?? this.observacaoGeoespacial,
      codigoSelo: codigoSelo ?? this.codigoSelo,
      situacao: situacao ?? this.situacao,
      moradorPresente: moradorPresente ?? this.moradorPresente,
      moradiaOcupada: moradiaOcupada ?? this.moradiaOcupada,
      situacaoAtendimento: situacaoAtendimento ?? this.situacaoAtendimento,
      tipoUnidade: tipoUnidade ?? this.tipoUnidade,
      usoImovel: usoImovel ?? this.usoImovel,
      nomeInformante: nomeInformante ?? this.nomeInformante,
      telefoneInformante: telefoneInformante ?? this.telefoneInformante,
      relacaoInformante: relacaoInformante ?? this.relacaoInformante,
      revisitaNecessaria: revisitaNecessaria ?? this.revisitaNecessaria,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      precisaoGps: precisaoGps ?? this.precisaoGps,
      fotoFachadaPath: fotoFachadaPath ?? this.fotoFachadaPath,
      observacoes: observacoes ?? this.observacoes,
      synced: synced ?? this.synced,
      serverId: serverId ?? this.serverId,
      sourceDeviceId: sourceDeviceId ?? this.sourceDeviceId,
      syncStatus: syncStatus ?? this.syncStatus,
      syncAttempts: syncAttempts ?? this.syncAttempts,
      syncError: syncError ?? this.syncError,
      lastSyncAttemptAt: lastSyncAttemptAt ?? this.lastSyncAttemptAt,
      syncedAt: syncedAt ?? this.syncedAt,
      localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      syncVersion: syncVersion ?? this.syncVersion,
      deletedLocally: deletedLocally ?? this.deletedLocally,
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
    if (projetoId.present) {
      map['projeto_id'] = Variable<String>(projetoId.value);
    }
    if (loteId.present) {
      map['lote_id'] = Variable<String>(loteId.value);
    }
    if (lotePreliminarId.present) {
      map['lote_preliminar_id'] = Variable<String>(lotePreliminarId.value);
    }
    if (codigoLotePreliminar.present) {
      map['codigo_lote_preliminar'] =
          Variable<String>(codigoLotePreliminar.value);
    }
    if (statusVinculoGeografico.present) {
      map['status_vinculo_geografico'] =
          Variable<String>(statusVinculoGeografico.value);
    }
    if (necessitaValidacaoRtk.present) {
      map['necessita_validacao_rtk'] =
          Variable<bool>(necessitaValidacaoRtk.value);
    }
    if (observacaoGeoespacial.present) {
      map['observacao_geoespacial'] =
          Variable<String>(observacaoGeoespacial.value);
    }
    if (codigoSelo.present) {
      map['codigo_selo'] = Variable<String>(codigoSelo.value);
    }
    if (situacao.present) {
      map['situacao'] = Variable<String>(situacao.value);
    }
    if (moradorPresente.present) {
      map['morador_presente'] = Variable<bool>(moradorPresente.value);
    }
    if (moradiaOcupada.present) {
      map['moradia_ocupada'] = Variable<bool>(moradiaOcupada.value);
    }
    if (situacaoAtendimento.present) {
      map['situacao_atendimento'] = Variable<String>(situacaoAtendimento.value);
    }
    if (tipoUnidade.present) {
      map['tipo_unidade'] = Variable<String>(tipoUnidade.value);
    }
    if (usoImovel.present) {
      map['uso_imovel'] = Variable<String>(usoImovel.value);
    }
    if (nomeInformante.present) {
      map['nome_informante'] = Variable<String>(nomeInformante.value);
    }
    if (telefoneInformante.present) {
      map['telefone_informante'] = Variable<String>(telefoneInformante.value);
    }
    if (relacaoInformante.present) {
      map['relacao_informante'] = Variable<String>(relacaoInformante.value);
    }
    if (revisitaNecessaria.present) {
      map['revisita_necessaria'] = Variable<bool>(revisitaNecessaria.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (precisaoGps.present) {
      map['precisao_gps'] = Variable<double>(precisaoGps.value);
    }
    if (fotoFachadaPath.present) {
      map['foto_fachada_path'] = Variable<String>(fotoFachadaPath.value);
    }
    if (observacoes.present) {
      map['observacoes'] = Variable<String>(observacoes.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (sourceDeviceId.present) {
      map['source_device_id'] = Variable<String>(sourceDeviceId.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (syncAttempts.present) {
      map['sync_attempts'] = Variable<int>(syncAttempts.value);
    }
    if (syncError.present) {
      map['sync_error'] = Variable<String>(syncError.value);
    }
    if (lastSyncAttemptAt.present) {
      map['last_sync_attempt_at'] = Variable<DateTime>(lastSyncAttemptAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (localUpdatedAt.present) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (syncVersion.present) {
      map['sync_version'] = Variable<int>(syncVersion.value);
    }
    if (deletedLocally.present) {
      map['deleted_locally'] = Variable<bool>(deletedLocally.value);
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
    return (StringBuffer('SelagensCompanion(')
          ..write('id: $id, ')
          ..write('projetoId: $projetoId, ')
          ..write('loteId: $loteId, ')
          ..write('lotePreliminarId: $lotePreliminarId, ')
          ..write('codigoLotePreliminar: $codigoLotePreliminar, ')
          ..write('statusVinculoGeografico: $statusVinculoGeografico, ')
          ..write('necessitaValidacaoRtk: $necessitaValidacaoRtk, ')
          ..write('observacaoGeoespacial: $observacaoGeoespacial, ')
          ..write('codigoSelo: $codigoSelo, ')
          ..write('situacao: $situacao, ')
          ..write('moradorPresente: $moradorPresente, ')
          ..write('moradiaOcupada: $moradiaOcupada, ')
          ..write('situacaoAtendimento: $situacaoAtendimento, ')
          ..write('tipoUnidade: $tipoUnidade, ')
          ..write('usoImovel: $usoImovel, ')
          ..write('nomeInformante: $nomeInformante, ')
          ..write('telefoneInformante: $telefoneInformante, ')
          ..write('relacaoInformante: $relacaoInformante, ')
          ..write('revisitaNecessaria: $revisitaNecessaria, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('precisaoGps: $precisaoGps, ')
          ..write('fotoFachadaPath: $fotoFachadaPath, ')
          ..write('observacoes: $observacoes, ')
          ..write('synced: $synced, ')
          ..write('serverId: $serverId, ')
          ..write('sourceDeviceId: $sourceDeviceId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncAttempts: $syncAttempts, ')
          ..write('syncError: $syncError, ')
          ..write('lastSyncAttemptAt: $lastSyncAttemptAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('deletedLocally: $deletedLocally, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CadastrosFisicosTable extends CadastrosFisicos
    with TableInfo<$CadastrosFisicosTable, CadastrosFisico> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CadastrosFisicosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _projetoIdMeta =
      const VerificationMeta('projetoId');
  @override
  late final GeneratedColumn<String> projetoId = GeneratedColumn<String>(
      'projeto_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _selagemIdMeta =
      const VerificationMeta('selagemId');
  @override
  late final GeneratedColumn<String> selagemId = GeneratedColumn<String>(
      'selagem_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _codigoSeloMeta =
      const VerificationMeta('codigoSelo');
  @override
  late final GeneratedColumn<String> codigoSelo = GeneratedColumn<String>(
      'codigo_selo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tipoImovelMeta =
      const VerificationMeta('tipoImovel');
  @override
  late final GeneratedColumn<String> tipoImovel = GeneratedColumn<String>(
      'tipo_imovel', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _usoImovelMeta =
      const VerificationMeta('usoImovel');
  @override
  late final GeneratedColumn<String> usoImovel = GeneratedColumn<String>(
      'uso_imovel', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _materialParedesMeta =
      const VerificationMeta('materialParedes');
  @override
  late final GeneratedColumn<String> materialParedes = GeneratedColumn<String>(
      'material_paredes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tipoCoberturaMeta =
      const VerificationMeta('tipoCobertura');
  @override
  late final GeneratedColumn<String> tipoCobertura = GeneratedColumn<String>(
      'tipo_cobertura', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tipoPisoMeta =
      const VerificationMeta('tipoPiso');
  @override
  late final GeneratedColumn<String> tipoPiso = GeneratedColumn<String>(
      'tipo_piso', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _numeroPavimentosMeta =
      const VerificationMeta('numeroPavimentos');
  @override
  late final GeneratedColumn<int> numeroPavimentos = GeneratedColumn<int>(
      'numero_pavimentos', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _numeroComodosMeta =
      const VerificationMeta('numeroComodos');
  @override
  late final GeneratedColumn<int> numeroComodos = GeneratedColumn<int>(
      'numero_comodos', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _numeroBanheirosMeta =
      const VerificationMeta('numeroBanheiros');
  @override
  late final GeneratedColumn<int> numeroBanheiros = GeneratedColumn<int>(
      'numero_banheiros', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _possuiEnergiaMeta =
      const VerificationMeta('possuiEnergia');
  @override
  late final GeneratedColumn<bool> possuiEnergia = GeneratedColumn<bool>(
      'possui_energia', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("possui_energia" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _possuiAguaMeta =
      const VerificationMeta('possuiAgua');
  @override
  late final GeneratedColumn<bool> possuiAgua = GeneratedColumn<bool>(
      'possui_agua', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("possui_agua" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _possuiEsgotoMeta =
      const VerificationMeta('possuiEsgoto');
  @override
  late final GeneratedColumn<bool> possuiEsgoto = GeneratedColumn<bool>(
      'possui_esgoto', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("possui_esgoto" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _possuiBanheiroMeta =
      const VerificationMeta('possuiBanheiro');
  @override
  late final GeneratedColumn<bool> possuiBanheiro = GeneratedColumn<bool>(
      'possui_banheiro', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("possui_banheiro" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _condicaoHabitabilidadeMeta =
      const VerificationMeta('condicaoHabitabilidade');
  @override
  late final GeneratedColumn<String> condicaoHabitabilidade =
      GeneratedColumn<String>('condicao_habitabilidade', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _areaRiscoMeta =
      const VerificationMeta('areaRisco');
  @override
  late final GeneratedColumn<bool> areaRisco = GeneratedColumn<bool>(
      'area_risco', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("area_risco" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _sujeitoInundacaoMeta =
      const VerificationMeta('sujeitoInundacao');
  @override
  late final GeneratedColumn<bool> sujeitoInundacao = GeneratedColumn<bool>(
      'sujeito_inundacao', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("sujeito_inundacao" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _observacoesMeta =
      const VerificationMeta('observacoes');
  @override
  late final GeneratedColumn<String> observacoes = GeneratedColumn<String>(
      'observacoes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        projetoId,
        selagemId,
        codigoSelo,
        tipoImovel,
        usoImovel,
        materialParedes,
        tipoCobertura,
        tipoPiso,
        numeroPavimentos,
        numeroComodos,
        numeroBanheiros,
        possuiEnergia,
        possuiAgua,
        possuiEsgoto,
        possuiBanheiro,
        condicaoHabitabilidade,
        areaRisco,
        sujeitoInundacao,
        observacoes,
        synced,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cadastros_fisicos';
  @override
  VerificationContext validateIntegrity(Insertable<CadastrosFisico> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('projeto_id')) {
      context.handle(_projetoIdMeta,
          projetoId.isAcceptableOrUnknown(data['projeto_id']!, _projetoIdMeta));
    } else if (isInserting) {
      context.missing(_projetoIdMeta);
    }
    if (data.containsKey('selagem_id')) {
      context.handle(_selagemIdMeta,
          selagemId.isAcceptableOrUnknown(data['selagem_id']!, _selagemIdMeta));
    }
    if (data.containsKey('codigo_selo')) {
      context.handle(
          _codigoSeloMeta,
          codigoSelo.isAcceptableOrUnknown(
              data['codigo_selo']!, _codigoSeloMeta));
    } else if (isInserting) {
      context.missing(_codigoSeloMeta);
    }
    if (data.containsKey('tipo_imovel')) {
      context.handle(
          _tipoImovelMeta,
          tipoImovel.isAcceptableOrUnknown(
              data['tipo_imovel']!, _tipoImovelMeta));
    }
    if (data.containsKey('uso_imovel')) {
      context.handle(_usoImovelMeta,
          usoImovel.isAcceptableOrUnknown(data['uso_imovel']!, _usoImovelMeta));
    }
    if (data.containsKey('material_paredes')) {
      context.handle(
          _materialParedesMeta,
          materialParedes.isAcceptableOrUnknown(
              data['material_paredes']!, _materialParedesMeta));
    }
    if (data.containsKey('tipo_cobertura')) {
      context.handle(
          _tipoCoberturaMeta,
          tipoCobertura.isAcceptableOrUnknown(
              data['tipo_cobertura']!, _tipoCoberturaMeta));
    }
    if (data.containsKey('tipo_piso')) {
      context.handle(_tipoPisoMeta,
          tipoPiso.isAcceptableOrUnknown(data['tipo_piso']!, _tipoPisoMeta));
    }
    if (data.containsKey('numero_pavimentos')) {
      context.handle(
          _numeroPavimentosMeta,
          numeroPavimentos.isAcceptableOrUnknown(
              data['numero_pavimentos']!, _numeroPavimentosMeta));
    }
    if (data.containsKey('numero_comodos')) {
      context.handle(
          _numeroComodosMeta,
          numeroComodos.isAcceptableOrUnknown(
              data['numero_comodos']!, _numeroComodosMeta));
    }
    if (data.containsKey('numero_banheiros')) {
      context.handle(
          _numeroBanheirosMeta,
          numeroBanheiros.isAcceptableOrUnknown(
              data['numero_banheiros']!, _numeroBanheirosMeta));
    }
    if (data.containsKey('possui_energia')) {
      context.handle(
          _possuiEnergiaMeta,
          possuiEnergia.isAcceptableOrUnknown(
              data['possui_energia']!, _possuiEnergiaMeta));
    }
    if (data.containsKey('possui_agua')) {
      context.handle(
          _possuiAguaMeta,
          possuiAgua.isAcceptableOrUnknown(
              data['possui_agua']!, _possuiAguaMeta));
    }
    if (data.containsKey('possui_esgoto')) {
      context.handle(
          _possuiEsgotoMeta,
          possuiEsgoto.isAcceptableOrUnknown(
              data['possui_esgoto']!, _possuiEsgotoMeta));
    }
    if (data.containsKey('possui_banheiro')) {
      context.handle(
          _possuiBanheiroMeta,
          possuiBanheiro.isAcceptableOrUnknown(
              data['possui_banheiro']!, _possuiBanheiroMeta));
    }
    if (data.containsKey('condicao_habitabilidade')) {
      context.handle(
          _condicaoHabitabilidadeMeta,
          condicaoHabitabilidade.isAcceptableOrUnknown(
              data['condicao_habitabilidade']!, _condicaoHabitabilidadeMeta));
    }
    if (data.containsKey('area_risco')) {
      context.handle(_areaRiscoMeta,
          areaRisco.isAcceptableOrUnknown(data['area_risco']!, _areaRiscoMeta));
    }
    if (data.containsKey('sujeito_inundacao')) {
      context.handle(
          _sujeitoInundacaoMeta,
          sujeitoInundacao.isAcceptableOrUnknown(
              data['sujeito_inundacao']!, _sujeitoInundacaoMeta));
    }
    if (data.containsKey('observacoes')) {
      context.handle(
          _observacoesMeta,
          observacoes.isAcceptableOrUnknown(
              data['observacoes']!, _observacoesMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
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
  CadastrosFisico map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CadastrosFisico(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      projetoId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}projeto_id'])!,
      selagemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}selagem_id']),
      codigoSelo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}codigo_selo'])!,
      tipoImovel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tipo_imovel']),
      usoImovel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uso_imovel']),
      materialParedes: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}material_paredes']),
      tipoCobertura: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tipo_cobertura']),
      tipoPiso: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tipo_piso']),
      numeroPavimentos: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}numero_pavimentos']),
      numeroComodos: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}numero_comodos']),
      numeroBanheiros: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}numero_banheiros']),
      possuiEnergia: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}possui_energia'])!,
      possuiAgua: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}possui_agua'])!,
      possuiEsgoto: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}possui_esgoto'])!,
      possuiBanheiro: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}possui_banheiro'])!,
      condicaoHabitabilidade: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}condicao_habitabilidade']),
      areaRisco: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}area_risco'])!,
      sujeitoInundacao: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}sujeito_inundacao'])!,
      observacoes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}observacoes']),
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CadastrosFisicosTable createAlias(String alias) {
    return $CadastrosFisicosTable(attachedDatabase, alias);
  }
}

class CadastrosFisico extends DataClass implements Insertable<CadastrosFisico> {
  final String id;
  final String projetoId;
  final String? selagemId;
  final String codigoSelo;
  final String? tipoImovel;
  final String? usoImovel;
  final String? materialParedes;
  final String? tipoCobertura;
  final String? tipoPiso;
  final int? numeroPavimentos;
  final int? numeroComodos;
  final int? numeroBanheiros;
  final bool possuiEnergia;
  final bool possuiAgua;
  final bool possuiEsgoto;
  final bool possuiBanheiro;
  final String? condicaoHabitabilidade;
  final bool areaRisco;
  final bool sujeitoInundacao;
  final String? observacoes;
  final bool synced;
  final DateTime createdAt;
  const CadastrosFisico(
      {required this.id,
      required this.projetoId,
      this.selagemId,
      required this.codigoSelo,
      this.tipoImovel,
      this.usoImovel,
      this.materialParedes,
      this.tipoCobertura,
      this.tipoPiso,
      this.numeroPavimentos,
      this.numeroComodos,
      this.numeroBanheiros,
      required this.possuiEnergia,
      required this.possuiAgua,
      required this.possuiEsgoto,
      required this.possuiBanheiro,
      this.condicaoHabitabilidade,
      required this.areaRisco,
      required this.sujeitoInundacao,
      this.observacoes,
      required this.synced,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['projeto_id'] = Variable<String>(projetoId);
    if (!nullToAbsent || selagemId != null) {
      map['selagem_id'] = Variable<String>(selagemId);
    }
    map['codigo_selo'] = Variable<String>(codigoSelo);
    if (!nullToAbsent || tipoImovel != null) {
      map['tipo_imovel'] = Variable<String>(tipoImovel);
    }
    if (!nullToAbsent || usoImovel != null) {
      map['uso_imovel'] = Variable<String>(usoImovel);
    }
    if (!nullToAbsent || materialParedes != null) {
      map['material_paredes'] = Variable<String>(materialParedes);
    }
    if (!nullToAbsent || tipoCobertura != null) {
      map['tipo_cobertura'] = Variable<String>(tipoCobertura);
    }
    if (!nullToAbsent || tipoPiso != null) {
      map['tipo_piso'] = Variable<String>(tipoPiso);
    }
    if (!nullToAbsent || numeroPavimentos != null) {
      map['numero_pavimentos'] = Variable<int>(numeroPavimentos);
    }
    if (!nullToAbsent || numeroComodos != null) {
      map['numero_comodos'] = Variable<int>(numeroComodos);
    }
    if (!nullToAbsent || numeroBanheiros != null) {
      map['numero_banheiros'] = Variable<int>(numeroBanheiros);
    }
    map['possui_energia'] = Variable<bool>(possuiEnergia);
    map['possui_agua'] = Variable<bool>(possuiAgua);
    map['possui_esgoto'] = Variable<bool>(possuiEsgoto);
    map['possui_banheiro'] = Variable<bool>(possuiBanheiro);
    if (!nullToAbsent || condicaoHabitabilidade != null) {
      map['condicao_habitabilidade'] = Variable<String>(condicaoHabitabilidade);
    }
    map['area_risco'] = Variable<bool>(areaRisco);
    map['sujeito_inundacao'] = Variable<bool>(sujeitoInundacao);
    if (!nullToAbsent || observacoes != null) {
      map['observacoes'] = Variable<String>(observacoes);
    }
    map['synced'] = Variable<bool>(synced);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CadastrosFisicosCompanion toCompanion(bool nullToAbsent) {
    return CadastrosFisicosCompanion(
      id: Value(id),
      projetoId: Value(projetoId),
      selagemId: selagemId == null && nullToAbsent
          ? const Value.absent()
          : Value(selagemId),
      codigoSelo: Value(codigoSelo),
      tipoImovel: tipoImovel == null && nullToAbsent
          ? const Value.absent()
          : Value(tipoImovel),
      usoImovel: usoImovel == null && nullToAbsent
          ? const Value.absent()
          : Value(usoImovel),
      materialParedes: materialParedes == null && nullToAbsent
          ? const Value.absent()
          : Value(materialParedes),
      tipoCobertura: tipoCobertura == null && nullToAbsent
          ? const Value.absent()
          : Value(tipoCobertura),
      tipoPiso: tipoPiso == null && nullToAbsent
          ? const Value.absent()
          : Value(tipoPiso),
      numeroPavimentos: numeroPavimentos == null && nullToAbsent
          ? const Value.absent()
          : Value(numeroPavimentos),
      numeroComodos: numeroComodos == null && nullToAbsent
          ? const Value.absent()
          : Value(numeroComodos),
      numeroBanheiros: numeroBanheiros == null && nullToAbsent
          ? const Value.absent()
          : Value(numeroBanheiros),
      possuiEnergia: Value(possuiEnergia),
      possuiAgua: Value(possuiAgua),
      possuiEsgoto: Value(possuiEsgoto),
      possuiBanheiro: Value(possuiBanheiro),
      condicaoHabitabilidade: condicaoHabitabilidade == null && nullToAbsent
          ? const Value.absent()
          : Value(condicaoHabitabilidade),
      areaRisco: Value(areaRisco),
      sujeitoInundacao: Value(sujeitoInundacao),
      observacoes: observacoes == null && nullToAbsent
          ? const Value.absent()
          : Value(observacoes),
      synced: Value(synced),
      createdAt: Value(createdAt),
    );
  }

  factory CadastrosFisico.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CadastrosFisico(
      id: serializer.fromJson<String>(json['id']),
      projetoId: serializer.fromJson<String>(json['projetoId']),
      selagemId: serializer.fromJson<String?>(json['selagemId']),
      codigoSelo: serializer.fromJson<String>(json['codigoSelo']),
      tipoImovel: serializer.fromJson<String?>(json['tipoImovel']),
      usoImovel: serializer.fromJson<String?>(json['usoImovel']),
      materialParedes: serializer.fromJson<String?>(json['materialParedes']),
      tipoCobertura: serializer.fromJson<String?>(json['tipoCobertura']),
      tipoPiso: serializer.fromJson<String?>(json['tipoPiso']),
      numeroPavimentos: serializer.fromJson<int?>(json['numeroPavimentos']),
      numeroComodos: serializer.fromJson<int?>(json['numeroComodos']),
      numeroBanheiros: serializer.fromJson<int?>(json['numeroBanheiros']),
      possuiEnergia: serializer.fromJson<bool>(json['possuiEnergia']),
      possuiAgua: serializer.fromJson<bool>(json['possuiAgua']),
      possuiEsgoto: serializer.fromJson<bool>(json['possuiEsgoto']),
      possuiBanheiro: serializer.fromJson<bool>(json['possuiBanheiro']),
      condicaoHabitabilidade:
          serializer.fromJson<String?>(json['condicaoHabitabilidade']),
      areaRisco: serializer.fromJson<bool>(json['areaRisco']),
      sujeitoInundacao: serializer.fromJson<bool>(json['sujeitoInundacao']),
      observacoes: serializer.fromJson<String?>(json['observacoes']),
      synced: serializer.fromJson<bool>(json['synced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projetoId': serializer.toJson<String>(projetoId),
      'selagemId': serializer.toJson<String?>(selagemId),
      'codigoSelo': serializer.toJson<String>(codigoSelo),
      'tipoImovel': serializer.toJson<String?>(tipoImovel),
      'usoImovel': serializer.toJson<String?>(usoImovel),
      'materialParedes': serializer.toJson<String?>(materialParedes),
      'tipoCobertura': serializer.toJson<String?>(tipoCobertura),
      'tipoPiso': serializer.toJson<String?>(tipoPiso),
      'numeroPavimentos': serializer.toJson<int?>(numeroPavimentos),
      'numeroComodos': serializer.toJson<int?>(numeroComodos),
      'numeroBanheiros': serializer.toJson<int?>(numeroBanheiros),
      'possuiEnergia': serializer.toJson<bool>(possuiEnergia),
      'possuiAgua': serializer.toJson<bool>(possuiAgua),
      'possuiEsgoto': serializer.toJson<bool>(possuiEsgoto),
      'possuiBanheiro': serializer.toJson<bool>(possuiBanheiro),
      'condicaoHabitabilidade':
          serializer.toJson<String?>(condicaoHabitabilidade),
      'areaRisco': serializer.toJson<bool>(areaRisco),
      'sujeitoInundacao': serializer.toJson<bool>(sujeitoInundacao),
      'observacoes': serializer.toJson<String?>(observacoes),
      'synced': serializer.toJson<bool>(synced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CadastrosFisico copyWith(
          {String? id,
          String? projetoId,
          Value<String?> selagemId = const Value.absent(),
          String? codigoSelo,
          Value<String?> tipoImovel = const Value.absent(),
          Value<String?> usoImovel = const Value.absent(),
          Value<String?> materialParedes = const Value.absent(),
          Value<String?> tipoCobertura = const Value.absent(),
          Value<String?> tipoPiso = const Value.absent(),
          Value<int?> numeroPavimentos = const Value.absent(),
          Value<int?> numeroComodos = const Value.absent(),
          Value<int?> numeroBanheiros = const Value.absent(),
          bool? possuiEnergia,
          bool? possuiAgua,
          bool? possuiEsgoto,
          bool? possuiBanheiro,
          Value<String?> condicaoHabitabilidade = const Value.absent(),
          bool? areaRisco,
          bool? sujeitoInundacao,
          Value<String?> observacoes = const Value.absent(),
          bool? synced,
          DateTime? createdAt}) =>
      CadastrosFisico(
        id: id ?? this.id,
        projetoId: projetoId ?? this.projetoId,
        selagemId: selagemId.present ? selagemId.value : this.selagemId,
        codigoSelo: codigoSelo ?? this.codigoSelo,
        tipoImovel: tipoImovel.present ? tipoImovel.value : this.tipoImovel,
        usoImovel: usoImovel.present ? usoImovel.value : this.usoImovel,
        materialParedes: materialParedes.present
            ? materialParedes.value
            : this.materialParedes,
        tipoCobertura:
            tipoCobertura.present ? tipoCobertura.value : this.tipoCobertura,
        tipoPiso: tipoPiso.present ? tipoPiso.value : this.tipoPiso,
        numeroPavimentos: numeroPavimentos.present
            ? numeroPavimentos.value
            : this.numeroPavimentos,
        numeroComodos:
            numeroComodos.present ? numeroComodos.value : this.numeroComodos,
        numeroBanheiros: numeroBanheiros.present
            ? numeroBanheiros.value
            : this.numeroBanheiros,
        possuiEnergia: possuiEnergia ?? this.possuiEnergia,
        possuiAgua: possuiAgua ?? this.possuiAgua,
        possuiEsgoto: possuiEsgoto ?? this.possuiEsgoto,
        possuiBanheiro: possuiBanheiro ?? this.possuiBanheiro,
        condicaoHabitabilidade: condicaoHabitabilidade.present
            ? condicaoHabitabilidade.value
            : this.condicaoHabitabilidade,
        areaRisco: areaRisco ?? this.areaRisco,
        sujeitoInundacao: sujeitoInundacao ?? this.sujeitoInundacao,
        observacoes: observacoes.present ? observacoes.value : this.observacoes,
        synced: synced ?? this.synced,
        createdAt: createdAt ?? this.createdAt,
      );
  CadastrosFisico copyWithCompanion(CadastrosFisicosCompanion data) {
    return CadastrosFisico(
      id: data.id.present ? data.id.value : this.id,
      projetoId: data.projetoId.present ? data.projetoId.value : this.projetoId,
      selagemId: data.selagemId.present ? data.selagemId.value : this.selagemId,
      codigoSelo:
          data.codigoSelo.present ? data.codigoSelo.value : this.codigoSelo,
      tipoImovel:
          data.tipoImovel.present ? data.tipoImovel.value : this.tipoImovel,
      usoImovel: data.usoImovel.present ? data.usoImovel.value : this.usoImovel,
      materialParedes: data.materialParedes.present
          ? data.materialParedes.value
          : this.materialParedes,
      tipoCobertura: data.tipoCobertura.present
          ? data.tipoCobertura.value
          : this.tipoCobertura,
      tipoPiso: data.tipoPiso.present ? data.tipoPiso.value : this.tipoPiso,
      numeroPavimentos: data.numeroPavimentos.present
          ? data.numeroPavimentos.value
          : this.numeroPavimentos,
      numeroComodos: data.numeroComodos.present
          ? data.numeroComodos.value
          : this.numeroComodos,
      numeroBanheiros: data.numeroBanheiros.present
          ? data.numeroBanheiros.value
          : this.numeroBanheiros,
      possuiEnergia: data.possuiEnergia.present
          ? data.possuiEnergia.value
          : this.possuiEnergia,
      possuiAgua:
          data.possuiAgua.present ? data.possuiAgua.value : this.possuiAgua,
      possuiEsgoto: data.possuiEsgoto.present
          ? data.possuiEsgoto.value
          : this.possuiEsgoto,
      possuiBanheiro: data.possuiBanheiro.present
          ? data.possuiBanheiro.value
          : this.possuiBanheiro,
      condicaoHabitabilidade: data.condicaoHabitabilidade.present
          ? data.condicaoHabitabilidade.value
          : this.condicaoHabitabilidade,
      areaRisco: data.areaRisco.present ? data.areaRisco.value : this.areaRisco,
      sujeitoInundacao: data.sujeitoInundacao.present
          ? data.sujeitoInundacao.value
          : this.sujeitoInundacao,
      observacoes:
          data.observacoes.present ? data.observacoes.value : this.observacoes,
      synced: data.synced.present ? data.synced.value : this.synced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CadastrosFisico(')
          ..write('id: $id, ')
          ..write('projetoId: $projetoId, ')
          ..write('selagemId: $selagemId, ')
          ..write('codigoSelo: $codigoSelo, ')
          ..write('tipoImovel: $tipoImovel, ')
          ..write('usoImovel: $usoImovel, ')
          ..write('materialParedes: $materialParedes, ')
          ..write('tipoCobertura: $tipoCobertura, ')
          ..write('tipoPiso: $tipoPiso, ')
          ..write('numeroPavimentos: $numeroPavimentos, ')
          ..write('numeroComodos: $numeroComodos, ')
          ..write('numeroBanheiros: $numeroBanheiros, ')
          ..write('possuiEnergia: $possuiEnergia, ')
          ..write('possuiAgua: $possuiAgua, ')
          ..write('possuiEsgoto: $possuiEsgoto, ')
          ..write('possuiBanheiro: $possuiBanheiro, ')
          ..write('condicaoHabitabilidade: $condicaoHabitabilidade, ')
          ..write('areaRisco: $areaRisco, ')
          ..write('sujeitoInundacao: $sujeitoInundacao, ')
          ..write('observacoes: $observacoes, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        projetoId,
        selagemId,
        codigoSelo,
        tipoImovel,
        usoImovel,
        materialParedes,
        tipoCobertura,
        tipoPiso,
        numeroPavimentos,
        numeroComodos,
        numeroBanheiros,
        possuiEnergia,
        possuiAgua,
        possuiEsgoto,
        possuiBanheiro,
        condicaoHabitabilidade,
        areaRisco,
        sujeitoInundacao,
        observacoes,
        synced,
        createdAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CadastrosFisico &&
          other.id == this.id &&
          other.projetoId == this.projetoId &&
          other.selagemId == this.selagemId &&
          other.codigoSelo == this.codigoSelo &&
          other.tipoImovel == this.tipoImovel &&
          other.usoImovel == this.usoImovel &&
          other.materialParedes == this.materialParedes &&
          other.tipoCobertura == this.tipoCobertura &&
          other.tipoPiso == this.tipoPiso &&
          other.numeroPavimentos == this.numeroPavimentos &&
          other.numeroComodos == this.numeroComodos &&
          other.numeroBanheiros == this.numeroBanheiros &&
          other.possuiEnergia == this.possuiEnergia &&
          other.possuiAgua == this.possuiAgua &&
          other.possuiEsgoto == this.possuiEsgoto &&
          other.possuiBanheiro == this.possuiBanheiro &&
          other.condicaoHabitabilidade == this.condicaoHabitabilidade &&
          other.areaRisco == this.areaRisco &&
          other.sujeitoInundacao == this.sujeitoInundacao &&
          other.observacoes == this.observacoes &&
          other.synced == this.synced &&
          other.createdAt == this.createdAt);
}

class CadastrosFisicosCompanion extends UpdateCompanion<CadastrosFisico> {
  final Value<String> id;
  final Value<String> projetoId;
  final Value<String?> selagemId;
  final Value<String> codigoSelo;
  final Value<String?> tipoImovel;
  final Value<String?> usoImovel;
  final Value<String?> materialParedes;
  final Value<String?> tipoCobertura;
  final Value<String?> tipoPiso;
  final Value<int?> numeroPavimentos;
  final Value<int?> numeroComodos;
  final Value<int?> numeroBanheiros;
  final Value<bool> possuiEnergia;
  final Value<bool> possuiAgua;
  final Value<bool> possuiEsgoto;
  final Value<bool> possuiBanheiro;
  final Value<String?> condicaoHabitabilidade;
  final Value<bool> areaRisco;
  final Value<bool> sujeitoInundacao;
  final Value<String?> observacoes;
  final Value<bool> synced;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CadastrosFisicosCompanion({
    this.id = const Value.absent(),
    this.projetoId = const Value.absent(),
    this.selagemId = const Value.absent(),
    this.codigoSelo = const Value.absent(),
    this.tipoImovel = const Value.absent(),
    this.usoImovel = const Value.absent(),
    this.materialParedes = const Value.absent(),
    this.tipoCobertura = const Value.absent(),
    this.tipoPiso = const Value.absent(),
    this.numeroPavimentos = const Value.absent(),
    this.numeroComodos = const Value.absent(),
    this.numeroBanheiros = const Value.absent(),
    this.possuiEnergia = const Value.absent(),
    this.possuiAgua = const Value.absent(),
    this.possuiEsgoto = const Value.absent(),
    this.possuiBanheiro = const Value.absent(),
    this.condicaoHabitabilidade = const Value.absent(),
    this.areaRisco = const Value.absent(),
    this.sujeitoInundacao = const Value.absent(),
    this.observacoes = const Value.absent(),
    this.synced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CadastrosFisicosCompanion.insert({
    required String id,
    required String projetoId,
    this.selagemId = const Value.absent(),
    required String codigoSelo,
    this.tipoImovel = const Value.absent(),
    this.usoImovel = const Value.absent(),
    this.materialParedes = const Value.absent(),
    this.tipoCobertura = const Value.absent(),
    this.tipoPiso = const Value.absent(),
    this.numeroPavimentos = const Value.absent(),
    this.numeroComodos = const Value.absent(),
    this.numeroBanheiros = const Value.absent(),
    this.possuiEnergia = const Value.absent(),
    this.possuiAgua = const Value.absent(),
    this.possuiEsgoto = const Value.absent(),
    this.possuiBanheiro = const Value.absent(),
    this.condicaoHabitabilidade = const Value.absent(),
    this.areaRisco = const Value.absent(),
    this.sujeitoInundacao = const Value.absent(),
    this.observacoes = const Value.absent(),
    this.synced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        projetoId = Value(projetoId),
        codigoSelo = Value(codigoSelo);
  static Insertable<CadastrosFisico> custom({
    Expression<String>? id,
    Expression<String>? projetoId,
    Expression<String>? selagemId,
    Expression<String>? codigoSelo,
    Expression<String>? tipoImovel,
    Expression<String>? usoImovel,
    Expression<String>? materialParedes,
    Expression<String>? tipoCobertura,
    Expression<String>? tipoPiso,
    Expression<int>? numeroPavimentos,
    Expression<int>? numeroComodos,
    Expression<int>? numeroBanheiros,
    Expression<bool>? possuiEnergia,
    Expression<bool>? possuiAgua,
    Expression<bool>? possuiEsgoto,
    Expression<bool>? possuiBanheiro,
    Expression<String>? condicaoHabitabilidade,
    Expression<bool>? areaRisco,
    Expression<bool>? sujeitoInundacao,
    Expression<String>? observacoes,
    Expression<bool>? synced,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projetoId != null) 'projeto_id': projetoId,
      if (selagemId != null) 'selagem_id': selagemId,
      if (codigoSelo != null) 'codigo_selo': codigoSelo,
      if (tipoImovel != null) 'tipo_imovel': tipoImovel,
      if (usoImovel != null) 'uso_imovel': usoImovel,
      if (materialParedes != null) 'material_paredes': materialParedes,
      if (tipoCobertura != null) 'tipo_cobertura': tipoCobertura,
      if (tipoPiso != null) 'tipo_piso': tipoPiso,
      if (numeroPavimentos != null) 'numero_pavimentos': numeroPavimentos,
      if (numeroComodos != null) 'numero_comodos': numeroComodos,
      if (numeroBanheiros != null) 'numero_banheiros': numeroBanheiros,
      if (possuiEnergia != null) 'possui_energia': possuiEnergia,
      if (possuiAgua != null) 'possui_agua': possuiAgua,
      if (possuiEsgoto != null) 'possui_esgoto': possuiEsgoto,
      if (possuiBanheiro != null) 'possui_banheiro': possuiBanheiro,
      if (condicaoHabitabilidade != null)
        'condicao_habitabilidade': condicaoHabitabilidade,
      if (areaRisco != null) 'area_risco': areaRisco,
      if (sujeitoInundacao != null) 'sujeito_inundacao': sujeitoInundacao,
      if (observacoes != null) 'observacoes': observacoes,
      if (synced != null) 'synced': synced,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CadastrosFisicosCompanion copyWith(
      {Value<String>? id,
      Value<String>? projetoId,
      Value<String?>? selagemId,
      Value<String>? codigoSelo,
      Value<String?>? tipoImovel,
      Value<String?>? usoImovel,
      Value<String?>? materialParedes,
      Value<String?>? tipoCobertura,
      Value<String?>? tipoPiso,
      Value<int?>? numeroPavimentos,
      Value<int?>? numeroComodos,
      Value<int?>? numeroBanheiros,
      Value<bool>? possuiEnergia,
      Value<bool>? possuiAgua,
      Value<bool>? possuiEsgoto,
      Value<bool>? possuiBanheiro,
      Value<String?>? condicaoHabitabilidade,
      Value<bool>? areaRisco,
      Value<bool>? sujeitoInundacao,
      Value<String?>? observacoes,
      Value<bool>? synced,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return CadastrosFisicosCompanion(
      id: id ?? this.id,
      projetoId: projetoId ?? this.projetoId,
      selagemId: selagemId ?? this.selagemId,
      codigoSelo: codigoSelo ?? this.codigoSelo,
      tipoImovel: tipoImovel ?? this.tipoImovel,
      usoImovel: usoImovel ?? this.usoImovel,
      materialParedes: materialParedes ?? this.materialParedes,
      tipoCobertura: tipoCobertura ?? this.tipoCobertura,
      tipoPiso: tipoPiso ?? this.tipoPiso,
      numeroPavimentos: numeroPavimentos ?? this.numeroPavimentos,
      numeroComodos: numeroComodos ?? this.numeroComodos,
      numeroBanheiros: numeroBanheiros ?? this.numeroBanheiros,
      possuiEnergia: possuiEnergia ?? this.possuiEnergia,
      possuiAgua: possuiAgua ?? this.possuiAgua,
      possuiEsgoto: possuiEsgoto ?? this.possuiEsgoto,
      possuiBanheiro: possuiBanheiro ?? this.possuiBanheiro,
      condicaoHabitabilidade:
          condicaoHabitabilidade ?? this.condicaoHabitabilidade,
      areaRisco: areaRisco ?? this.areaRisco,
      sujeitoInundacao: sujeitoInundacao ?? this.sujeitoInundacao,
      observacoes: observacoes ?? this.observacoes,
      synced: synced ?? this.synced,
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
    if (projetoId.present) {
      map['projeto_id'] = Variable<String>(projetoId.value);
    }
    if (selagemId.present) {
      map['selagem_id'] = Variable<String>(selagemId.value);
    }
    if (codigoSelo.present) {
      map['codigo_selo'] = Variable<String>(codigoSelo.value);
    }
    if (tipoImovel.present) {
      map['tipo_imovel'] = Variable<String>(tipoImovel.value);
    }
    if (usoImovel.present) {
      map['uso_imovel'] = Variable<String>(usoImovel.value);
    }
    if (materialParedes.present) {
      map['material_paredes'] = Variable<String>(materialParedes.value);
    }
    if (tipoCobertura.present) {
      map['tipo_cobertura'] = Variable<String>(tipoCobertura.value);
    }
    if (tipoPiso.present) {
      map['tipo_piso'] = Variable<String>(tipoPiso.value);
    }
    if (numeroPavimentos.present) {
      map['numero_pavimentos'] = Variable<int>(numeroPavimentos.value);
    }
    if (numeroComodos.present) {
      map['numero_comodos'] = Variable<int>(numeroComodos.value);
    }
    if (numeroBanheiros.present) {
      map['numero_banheiros'] = Variable<int>(numeroBanheiros.value);
    }
    if (possuiEnergia.present) {
      map['possui_energia'] = Variable<bool>(possuiEnergia.value);
    }
    if (possuiAgua.present) {
      map['possui_agua'] = Variable<bool>(possuiAgua.value);
    }
    if (possuiEsgoto.present) {
      map['possui_esgoto'] = Variable<bool>(possuiEsgoto.value);
    }
    if (possuiBanheiro.present) {
      map['possui_banheiro'] = Variable<bool>(possuiBanheiro.value);
    }
    if (condicaoHabitabilidade.present) {
      map['condicao_habitabilidade'] =
          Variable<String>(condicaoHabitabilidade.value);
    }
    if (areaRisco.present) {
      map['area_risco'] = Variable<bool>(areaRisco.value);
    }
    if (sujeitoInundacao.present) {
      map['sujeito_inundacao'] = Variable<bool>(sujeitoInundacao.value);
    }
    if (observacoes.present) {
      map['observacoes'] = Variable<String>(observacoes.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
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
    return (StringBuffer('CadastrosFisicosCompanion(')
          ..write('id: $id, ')
          ..write('projetoId: $projetoId, ')
          ..write('selagemId: $selagemId, ')
          ..write('codigoSelo: $codigoSelo, ')
          ..write('tipoImovel: $tipoImovel, ')
          ..write('usoImovel: $usoImovel, ')
          ..write('materialParedes: $materialParedes, ')
          ..write('tipoCobertura: $tipoCobertura, ')
          ..write('tipoPiso: $tipoPiso, ')
          ..write('numeroPavimentos: $numeroPavimentos, ')
          ..write('numeroComodos: $numeroComodos, ')
          ..write('numeroBanheiros: $numeroBanheiros, ')
          ..write('possuiEnergia: $possuiEnergia, ')
          ..write('possuiAgua: $possuiAgua, ')
          ..write('possuiEsgoto: $possuiEsgoto, ')
          ..write('possuiBanheiro: $possuiBanheiro, ')
          ..write('condicaoHabitabilidade: $condicaoHabitabilidade, ')
          ..write('areaRisco: $areaRisco, ')
          ..write('sujeitoInundacao: $sujeitoInundacao, ')
          ..write('observacoes: $observacoes, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CadastrosSociaisTable extends CadastrosSociais
    with TableInfo<$CadastrosSociaisTable, CadastrosSociai> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CadastrosSociaisTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _projetoIdMeta =
      const VerificationMeta('projetoId');
  @override
  late final GeneratedColumn<String> projetoId = GeneratedColumn<String>(
      'projeto_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _selagemIdMeta =
      const VerificationMeta('selagemId');
  @override
  late final GeneratedColumn<String> selagemId = GeneratedColumn<String>(
      'selagem_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _codigoSeloMeta =
      const VerificationMeta('codigoSelo');
  @override
  late final GeneratedColumn<String> codigoSelo = GeneratedColumn<String>(
      'codigo_selo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nomeResponsavelMeta =
      const VerificationMeta('nomeResponsavel');
  @override
  late final GeneratedColumn<String> nomeResponsavel = GeneratedColumn<String>(
      'nome_responsavel', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cpfResponsavelMeta =
      const VerificationMeta('cpfResponsavel');
  @override
  late final GeneratedColumn<String> cpfResponsavel = GeneratedColumn<String>(
      'cpf_responsavel', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _rgResponsavelMeta =
      const VerificationMeta('rgResponsavel');
  @override
  late final GeneratedColumn<String> rgResponsavel = GeneratedColumn<String>(
      'rg_responsavel', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _orgaoEmissorMeta =
      const VerificationMeta('orgaoEmissor');
  @override
  late final GeneratedColumn<String> orgaoEmissor = GeneratedColumn<String>(
      'orgao_emissor', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _estadoCivilMeta =
      const VerificationMeta('estadoCivil');
  @override
  late final GeneratedColumn<String> estadoCivil = GeneratedColumn<String>(
      'estado_civil', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _profissaoMeta =
      const VerificationMeta('profissao');
  @override
  late final GeneratedColumn<String> profissao = GeneratedColumn<String>(
      'profissao', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _telefoneMeta =
      const VerificationMeta('telefone');
  @override
  late final GeneratedColumn<String> telefone = GeneratedColumn<String>(
      'telefone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _quantidadeMoradoresMeta =
      const VerificationMeta('quantidadeMoradores');
  @override
  late final GeneratedColumn<int> quantidadeMoradores = GeneratedColumn<int>(
      'quantidade_moradores', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _rendaFamiliarMeta =
      const VerificationMeta('rendaFamiliar');
  @override
  late final GeneratedColumn<double> rendaFamiliar = GeneratedColumn<double>(
      'renda_familiar', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _recebeProgramaSocialMeta =
      const VerificationMeta('recebeProgramaSocial');
  @override
  late final GeneratedColumn<bool> recebeProgramaSocial = GeneratedColumn<bool>(
      'recebe_programa_social', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("recebe_programa_social" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _programaSocialMeta =
      const VerificationMeta('programaSocial');
  @override
  late final GeneratedColumn<String> programaSocial = GeneratedColumn<String>(
      'programa_social', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tempoOcupacaoAnosMeta =
      const VerificationMeta('tempoOcupacaoAnos');
  @override
  late final GeneratedColumn<int> tempoOcupacaoAnos = GeneratedColumn<int>(
      'tempo_ocupacao_anos', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _formaOcupacaoMeta =
      const VerificationMeta('formaOcupacao');
  @override
  late final GeneratedColumn<String> formaOcupacao = GeneratedColumn<String>(
      'forma_ocupacao', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _documentoPosseMeta =
      const VerificationMeta('documentoPosse');
  @override
  late final GeneratedColumn<String> documentoPosse = GeneratedColumn<String>(
      'documento_posse', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _possuiOutroImovelMeta =
      const VerificationMeta('possuiOutroImovel');
  @override
  late final GeneratedColumn<bool> possuiOutroImovel = GeneratedColumn<bool>(
      'possui_outro_imovel', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("possui_outro_imovel" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _possuiConflitoMeta =
      const VerificationMeta('possuiConflito');
  @override
  late final GeneratedColumn<bool> possuiConflito = GeneratedColumn<bool>(
      'possui_conflito', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("possui_conflito" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _observacoesMeta =
      const VerificationMeta('observacoes');
  @override
  late final GeneratedColumn<String> observacoes = GeneratedColumn<String>(
      'observacoes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        projetoId,
        selagemId,
        codigoSelo,
        nomeResponsavel,
        cpfResponsavel,
        rgResponsavel,
        orgaoEmissor,
        estadoCivil,
        profissao,
        telefone,
        quantidadeMoradores,
        rendaFamiliar,
        recebeProgramaSocial,
        programaSocial,
        tempoOcupacaoAnos,
        formaOcupacao,
        documentoPosse,
        possuiOutroImovel,
        possuiConflito,
        observacoes,
        synced,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cadastros_sociais';
  @override
  VerificationContext validateIntegrity(Insertable<CadastrosSociai> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('projeto_id')) {
      context.handle(_projetoIdMeta,
          projetoId.isAcceptableOrUnknown(data['projeto_id']!, _projetoIdMeta));
    } else if (isInserting) {
      context.missing(_projetoIdMeta);
    }
    if (data.containsKey('selagem_id')) {
      context.handle(_selagemIdMeta,
          selagemId.isAcceptableOrUnknown(data['selagem_id']!, _selagemIdMeta));
    }
    if (data.containsKey('codigo_selo')) {
      context.handle(
          _codigoSeloMeta,
          codigoSelo.isAcceptableOrUnknown(
              data['codigo_selo']!, _codigoSeloMeta));
    } else if (isInserting) {
      context.missing(_codigoSeloMeta);
    }
    if (data.containsKey('nome_responsavel')) {
      context.handle(
          _nomeResponsavelMeta,
          nomeResponsavel.isAcceptableOrUnknown(
              data['nome_responsavel']!, _nomeResponsavelMeta));
    } else if (isInserting) {
      context.missing(_nomeResponsavelMeta);
    }
    if (data.containsKey('cpf_responsavel')) {
      context.handle(
          _cpfResponsavelMeta,
          cpfResponsavel.isAcceptableOrUnknown(
              data['cpf_responsavel']!, _cpfResponsavelMeta));
    }
    if (data.containsKey('rg_responsavel')) {
      context.handle(
          _rgResponsavelMeta,
          rgResponsavel.isAcceptableOrUnknown(
              data['rg_responsavel']!, _rgResponsavelMeta));
    }
    if (data.containsKey('orgao_emissor')) {
      context.handle(
          _orgaoEmissorMeta,
          orgaoEmissor.isAcceptableOrUnknown(
              data['orgao_emissor']!, _orgaoEmissorMeta));
    }
    if (data.containsKey('estado_civil')) {
      context.handle(
          _estadoCivilMeta,
          estadoCivil.isAcceptableOrUnknown(
              data['estado_civil']!, _estadoCivilMeta));
    }
    if (data.containsKey('profissao')) {
      context.handle(_profissaoMeta,
          profissao.isAcceptableOrUnknown(data['profissao']!, _profissaoMeta));
    }
    if (data.containsKey('telefone')) {
      context.handle(_telefoneMeta,
          telefone.isAcceptableOrUnknown(data['telefone']!, _telefoneMeta));
    }
    if (data.containsKey('quantidade_moradores')) {
      context.handle(
          _quantidadeMoradoresMeta,
          quantidadeMoradores.isAcceptableOrUnknown(
              data['quantidade_moradores']!, _quantidadeMoradoresMeta));
    }
    if (data.containsKey('renda_familiar')) {
      context.handle(
          _rendaFamiliarMeta,
          rendaFamiliar.isAcceptableOrUnknown(
              data['renda_familiar']!, _rendaFamiliarMeta));
    }
    if (data.containsKey('recebe_programa_social')) {
      context.handle(
          _recebeProgramaSocialMeta,
          recebeProgramaSocial.isAcceptableOrUnknown(
              data['recebe_programa_social']!, _recebeProgramaSocialMeta));
    }
    if (data.containsKey('programa_social')) {
      context.handle(
          _programaSocialMeta,
          programaSocial.isAcceptableOrUnknown(
              data['programa_social']!, _programaSocialMeta));
    }
    if (data.containsKey('tempo_ocupacao_anos')) {
      context.handle(
          _tempoOcupacaoAnosMeta,
          tempoOcupacaoAnos.isAcceptableOrUnknown(
              data['tempo_ocupacao_anos']!, _tempoOcupacaoAnosMeta));
    }
    if (data.containsKey('forma_ocupacao')) {
      context.handle(
          _formaOcupacaoMeta,
          formaOcupacao.isAcceptableOrUnknown(
              data['forma_ocupacao']!, _formaOcupacaoMeta));
    }
    if (data.containsKey('documento_posse')) {
      context.handle(
          _documentoPosseMeta,
          documentoPosse.isAcceptableOrUnknown(
              data['documento_posse']!, _documentoPosseMeta));
    }
    if (data.containsKey('possui_outro_imovel')) {
      context.handle(
          _possuiOutroImovelMeta,
          possuiOutroImovel.isAcceptableOrUnknown(
              data['possui_outro_imovel']!, _possuiOutroImovelMeta));
    }
    if (data.containsKey('possui_conflito')) {
      context.handle(
          _possuiConflitoMeta,
          possuiConflito.isAcceptableOrUnknown(
              data['possui_conflito']!, _possuiConflitoMeta));
    }
    if (data.containsKey('observacoes')) {
      context.handle(
          _observacoesMeta,
          observacoes.isAcceptableOrUnknown(
              data['observacoes']!, _observacoesMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
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
  CadastrosSociai map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CadastrosSociai(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      projetoId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}projeto_id'])!,
      selagemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}selagem_id']),
      codigoSelo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}codigo_selo'])!,
      nomeResponsavel: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}nome_responsavel'])!,
      cpfResponsavel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cpf_responsavel']),
      rgResponsavel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rg_responsavel']),
      orgaoEmissor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}orgao_emissor']),
      estadoCivil: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}estado_civil']),
      profissao: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profissao']),
      telefone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}telefone']),
      quantidadeMoradores: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}quantidade_moradores']),
      rendaFamiliar: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}renda_familiar']),
      recebeProgramaSocial: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}recebe_programa_social'])!,
      programaSocial: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}programa_social']),
      tempoOcupacaoAnos: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}tempo_ocupacao_anos']),
      formaOcupacao: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}forma_ocupacao']),
      documentoPosse: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}documento_posse']),
      possuiOutroImovel: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}possui_outro_imovel'])!,
      possuiConflito: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}possui_conflito'])!,
      observacoes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}observacoes']),
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CadastrosSociaisTable createAlias(String alias) {
    return $CadastrosSociaisTable(attachedDatabase, alias);
  }
}

class CadastrosSociai extends DataClass implements Insertable<CadastrosSociai> {
  final String id;
  final String projetoId;
  final String? selagemId;
  final String codigoSelo;
  final String nomeResponsavel;
  final String? cpfResponsavel;
  final String? rgResponsavel;
  final String? orgaoEmissor;
  final String? estadoCivil;
  final String? profissao;
  final String? telefone;
  final int? quantidadeMoradores;
  final double? rendaFamiliar;
  final bool recebeProgramaSocial;
  final String? programaSocial;
  final int? tempoOcupacaoAnos;
  final String? formaOcupacao;
  final String? documentoPosse;
  final bool possuiOutroImovel;
  final bool possuiConflito;
  final String? observacoes;
  final bool synced;
  final DateTime createdAt;
  const CadastrosSociai(
      {required this.id,
      required this.projetoId,
      this.selagemId,
      required this.codigoSelo,
      required this.nomeResponsavel,
      this.cpfResponsavel,
      this.rgResponsavel,
      this.orgaoEmissor,
      this.estadoCivil,
      this.profissao,
      this.telefone,
      this.quantidadeMoradores,
      this.rendaFamiliar,
      required this.recebeProgramaSocial,
      this.programaSocial,
      this.tempoOcupacaoAnos,
      this.formaOcupacao,
      this.documentoPosse,
      required this.possuiOutroImovel,
      required this.possuiConflito,
      this.observacoes,
      required this.synced,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['projeto_id'] = Variable<String>(projetoId);
    if (!nullToAbsent || selagemId != null) {
      map['selagem_id'] = Variable<String>(selagemId);
    }
    map['codigo_selo'] = Variable<String>(codigoSelo);
    map['nome_responsavel'] = Variable<String>(nomeResponsavel);
    if (!nullToAbsent || cpfResponsavel != null) {
      map['cpf_responsavel'] = Variable<String>(cpfResponsavel);
    }
    if (!nullToAbsent || rgResponsavel != null) {
      map['rg_responsavel'] = Variable<String>(rgResponsavel);
    }
    if (!nullToAbsent || orgaoEmissor != null) {
      map['orgao_emissor'] = Variable<String>(orgaoEmissor);
    }
    if (!nullToAbsent || estadoCivil != null) {
      map['estado_civil'] = Variable<String>(estadoCivil);
    }
    if (!nullToAbsent || profissao != null) {
      map['profissao'] = Variable<String>(profissao);
    }
    if (!nullToAbsent || telefone != null) {
      map['telefone'] = Variable<String>(telefone);
    }
    if (!nullToAbsent || quantidadeMoradores != null) {
      map['quantidade_moradores'] = Variable<int>(quantidadeMoradores);
    }
    if (!nullToAbsent || rendaFamiliar != null) {
      map['renda_familiar'] = Variable<double>(rendaFamiliar);
    }
    map['recebe_programa_social'] = Variable<bool>(recebeProgramaSocial);
    if (!nullToAbsent || programaSocial != null) {
      map['programa_social'] = Variable<String>(programaSocial);
    }
    if (!nullToAbsent || tempoOcupacaoAnos != null) {
      map['tempo_ocupacao_anos'] = Variable<int>(tempoOcupacaoAnos);
    }
    if (!nullToAbsent || formaOcupacao != null) {
      map['forma_ocupacao'] = Variable<String>(formaOcupacao);
    }
    if (!nullToAbsent || documentoPosse != null) {
      map['documento_posse'] = Variable<String>(documentoPosse);
    }
    map['possui_outro_imovel'] = Variable<bool>(possuiOutroImovel);
    map['possui_conflito'] = Variable<bool>(possuiConflito);
    if (!nullToAbsent || observacoes != null) {
      map['observacoes'] = Variable<String>(observacoes);
    }
    map['synced'] = Variable<bool>(synced);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CadastrosSociaisCompanion toCompanion(bool nullToAbsent) {
    return CadastrosSociaisCompanion(
      id: Value(id),
      projetoId: Value(projetoId),
      selagemId: selagemId == null && nullToAbsent
          ? const Value.absent()
          : Value(selagemId),
      codigoSelo: Value(codigoSelo),
      nomeResponsavel: Value(nomeResponsavel),
      cpfResponsavel: cpfResponsavel == null && nullToAbsent
          ? const Value.absent()
          : Value(cpfResponsavel),
      rgResponsavel: rgResponsavel == null && nullToAbsent
          ? const Value.absent()
          : Value(rgResponsavel),
      orgaoEmissor: orgaoEmissor == null && nullToAbsent
          ? const Value.absent()
          : Value(orgaoEmissor),
      estadoCivil: estadoCivil == null && nullToAbsent
          ? const Value.absent()
          : Value(estadoCivil),
      profissao: profissao == null && nullToAbsent
          ? const Value.absent()
          : Value(profissao),
      telefone: telefone == null && nullToAbsent
          ? const Value.absent()
          : Value(telefone),
      quantidadeMoradores: quantidadeMoradores == null && nullToAbsent
          ? const Value.absent()
          : Value(quantidadeMoradores),
      rendaFamiliar: rendaFamiliar == null && nullToAbsent
          ? const Value.absent()
          : Value(rendaFamiliar),
      recebeProgramaSocial: Value(recebeProgramaSocial),
      programaSocial: programaSocial == null && nullToAbsent
          ? const Value.absent()
          : Value(programaSocial),
      tempoOcupacaoAnos: tempoOcupacaoAnos == null && nullToAbsent
          ? const Value.absent()
          : Value(tempoOcupacaoAnos),
      formaOcupacao: formaOcupacao == null && nullToAbsent
          ? const Value.absent()
          : Value(formaOcupacao),
      documentoPosse: documentoPosse == null && nullToAbsent
          ? const Value.absent()
          : Value(documentoPosse),
      possuiOutroImovel: Value(possuiOutroImovel),
      possuiConflito: Value(possuiConflito),
      observacoes: observacoes == null && nullToAbsent
          ? const Value.absent()
          : Value(observacoes),
      synced: Value(synced),
      createdAt: Value(createdAt),
    );
  }

  factory CadastrosSociai.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CadastrosSociai(
      id: serializer.fromJson<String>(json['id']),
      projetoId: serializer.fromJson<String>(json['projetoId']),
      selagemId: serializer.fromJson<String?>(json['selagemId']),
      codigoSelo: serializer.fromJson<String>(json['codigoSelo']),
      nomeResponsavel: serializer.fromJson<String>(json['nomeResponsavel']),
      cpfResponsavel: serializer.fromJson<String?>(json['cpfResponsavel']),
      rgResponsavel: serializer.fromJson<String?>(json['rgResponsavel']),
      orgaoEmissor: serializer.fromJson<String?>(json['orgaoEmissor']),
      estadoCivil: serializer.fromJson<String?>(json['estadoCivil']),
      profissao: serializer.fromJson<String?>(json['profissao']),
      telefone: serializer.fromJson<String?>(json['telefone']),
      quantidadeMoradores:
          serializer.fromJson<int?>(json['quantidadeMoradores']),
      rendaFamiliar: serializer.fromJson<double?>(json['rendaFamiliar']),
      recebeProgramaSocial:
          serializer.fromJson<bool>(json['recebeProgramaSocial']),
      programaSocial: serializer.fromJson<String?>(json['programaSocial']),
      tempoOcupacaoAnos: serializer.fromJson<int?>(json['tempoOcupacaoAnos']),
      formaOcupacao: serializer.fromJson<String?>(json['formaOcupacao']),
      documentoPosse: serializer.fromJson<String?>(json['documentoPosse']),
      possuiOutroImovel: serializer.fromJson<bool>(json['possuiOutroImovel']),
      possuiConflito: serializer.fromJson<bool>(json['possuiConflito']),
      observacoes: serializer.fromJson<String?>(json['observacoes']),
      synced: serializer.fromJson<bool>(json['synced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projetoId': serializer.toJson<String>(projetoId),
      'selagemId': serializer.toJson<String?>(selagemId),
      'codigoSelo': serializer.toJson<String>(codigoSelo),
      'nomeResponsavel': serializer.toJson<String>(nomeResponsavel),
      'cpfResponsavel': serializer.toJson<String?>(cpfResponsavel),
      'rgResponsavel': serializer.toJson<String?>(rgResponsavel),
      'orgaoEmissor': serializer.toJson<String?>(orgaoEmissor),
      'estadoCivil': serializer.toJson<String?>(estadoCivil),
      'profissao': serializer.toJson<String?>(profissao),
      'telefone': serializer.toJson<String?>(telefone),
      'quantidadeMoradores': serializer.toJson<int?>(quantidadeMoradores),
      'rendaFamiliar': serializer.toJson<double?>(rendaFamiliar),
      'recebeProgramaSocial': serializer.toJson<bool>(recebeProgramaSocial),
      'programaSocial': serializer.toJson<String?>(programaSocial),
      'tempoOcupacaoAnos': serializer.toJson<int?>(tempoOcupacaoAnos),
      'formaOcupacao': serializer.toJson<String?>(formaOcupacao),
      'documentoPosse': serializer.toJson<String?>(documentoPosse),
      'possuiOutroImovel': serializer.toJson<bool>(possuiOutroImovel),
      'possuiConflito': serializer.toJson<bool>(possuiConflito),
      'observacoes': serializer.toJson<String?>(observacoes),
      'synced': serializer.toJson<bool>(synced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CadastrosSociai copyWith(
          {String? id,
          String? projetoId,
          Value<String?> selagemId = const Value.absent(),
          String? codigoSelo,
          String? nomeResponsavel,
          Value<String?> cpfResponsavel = const Value.absent(),
          Value<String?> rgResponsavel = const Value.absent(),
          Value<String?> orgaoEmissor = const Value.absent(),
          Value<String?> estadoCivil = const Value.absent(),
          Value<String?> profissao = const Value.absent(),
          Value<String?> telefone = const Value.absent(),
          Value<int?> quantidadeMoradores = const Value.absent(),
          Value<double?> rendaFamiliar = const Value.absent(),
          bool? recebeProgramaSocial,
          Value<String?> programaSocial = const Value.absent(),
          Value<int?> tempoOcupacaoAnos = const Value.absent(),
          Value<String?> formaOcupacao = const Value.absent(),
          Value<String?> documentoPosse = const Value.absent(),
          bool? possuiOutroImovel,
          bool? possuiConflito,
          Value<String?> observacoes = const Value.absent(),
          bool? synced,
          DateTime? createdAt}) =>
      CadastrosSociai(
        id: id ?? this.id,
        projetoId: projetoId ?? this.projetoId,
        selagemId: selagemId.present ? selagemId.value : this.selagemId,
        codigoSelo: codigoSelo ?? this.codigoSelo,
        nomeResponsavel: nomeResponsavel ?? this.nomeResponsavel,
        cpfResponsavel:
            cpfResponsavel.present ? cpfResponsavel.value : this.cpfResponsavel,
        rgResponsavel:
            rgResponsavel.present ? rgResponsavel.value : this.rgResponsavel,
        orgaoEmissor:
            orgaoEmissor.present ? orgaoEmissor.value : this.orgaoEmissor,
        estadoCivil: estadoCivil.present ? estadoCivil.value : this.estadoCivil,
        profissao: profissao.present ? profissao.value : this.profissao,
        telefone: telefone.present ? telefone.value : this.telefone,
        quantidadeMoradores: quantidadeMoradores.present
            ? quantidadeMoradores.value
            : this.quantidadeMoradores,
        rendaFamiliar:
            rendaFamiliar.present ? rendaFamiliar.value : this.rendaFamiliar,
        recebeProgramaSocial: recebeProgramaSocial ?? this.recebeProgramaSocial,
        programaSocial:
            programaSocial.present ? programaSocial.value : this.programaSocial,
        tempoOcupacaoAnos: tempoOcupacaoAnos.present
            ? tempoOcupacaoAnos.value
            : this.tempoOcupacaoAnos,
        formaOcupacao:
            formaOcupacao.present ? formaOcupacao.value : this.formaOcupacao,
        documentoPosse:
            documentoPosse.present ? documentoPosse.value : this.documentoPosse,
        possuiOutroImovel: possuiOutroImovel ?? this.possuiOutroImovel,
        possuiConflito: possuiConflito ?? this.possuiConflito,
        observacoes: observacoes.present ? observacoes.value : this.observacoes,
        synced: synced ?? this.synced,
        createdAt: createdAt ?? this.createdAt,
      );
  CadastrosSociai copyWithCompanion(CadastrosSociaisCompanion data) {
    return CadastrosSociai(
      id: data.id.present ? data.id.value : this.id,
      projetoId: data.projetoId.present ? data.projetoId.value : this.projetoId,
      selagemId: data.selagemId.present ? data.selagemId.value : this.selagemId,
      codigoSelo:
          data.codigoSelo.present ? data.codigoSelo.value : this.codigoSelo,
      nomeResponsavel: data.nomeResponsavel.present
          ? data.nomeResponsavel.value
          : this.nomeResponsavel,
      cpfResponsavel: data.cpfResponsavel.present
          ? data.cpfResponsavel.value
          : this.cpfResponsavel,
      rgResponsavel: data.rgResponsavel.present
          ? data.rgResponsavel.value
          : this.rgResponsavel,
      orgaoEmissor: data.orgaoEmissor.present
          ? data.orgaoEmissor.value
          : this.orgaoEmissor,
      estadoCivil:
          data.estadoCivil.present ? data.estadoCivil.value : this.estadoCivil,
      profissao: data.profissao.present ? data.profissao.value : this.profissao,
      telefone: data.telefone.present ? data.telefone.value : this.telefone,
      quantidadeMoradores: data.quantidadeMoradores.present
          ? data.quantidadeMoradores.value
          : this.quantidadeMoradores,
      rendaFamiliar: data.rendaFamiliar.present
          ? data.rendaFamiliar.value
          : this.rendaFamiliar,
      recebeProgramaSocial: data.recebeProgramaSocial.present
          ? data.recebeProgramaSocial.value
          : this.recebeProgramaSocial,
      programaSocial: data.programaSocial.present
          ? data.programaSocial.value
          : this.programaSocial,
      tempoOcupacaoAnos: data.tempoOcupacaoAnos.present
          ? data.tempoOcupacaoAnos.value
          : this.tempoOcupacaoAnos,
      formaOcupacao: data.formaOcupacao.present
          ? data.formaOcupacao.value
          : this.formaOcupacao,
      documentoPosse: data.documentoPosse.present
          ? data.documentoPosse.value
          : this.documentoPosse,
      possuiOutroImovel: data.possuiOutroImovel.present
          ? data.possuiOutroImovel.value
          : this.possuiOutroImovel,
      possuiConflito: data.possuiConflito.present
          ? data.possuiConflito.value
          : this.possuiConflito,
      observacoes:
          data.observacoes.present ? data.observacoes.value : this.observacoes,
      synced: data.synced.present ? data.synced.value : this.synced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CadastrosSociai(')
          ..write('id: $id, ')
          ..write('projetoId: $projetoId, ')
          ..write('selagemId: $selagemId, ')
          ..write('codigoSelo: $codigoSelo, ')
          ..write('nomeResponsavel: $nomeResponsavel, ')
          ..write('cpfResponsavel: $cpfResponsavel, ')
          ..write('rgResponsavel: $rgResponsavel, ')
          ..write('orgaoEmissor: $orgaoEmissor, ')
          ..write('estadoCivil: $estadoCivil, ')
          ..write('profissao: $profissao, ')
          ..write('telefone: $telefone, ')
          ..write('quantidadeMoradores: $quantidadeMoradores, ')
          ..write('rendaFamiliar: $rendaFamiliar, ')
          ..write('recebeProgramaSocial: $recebeProgramaSocial, ')
          ..write('programaSocial: $programaSocial, ')
          ..write('tempoOcupacaoAnos: $tempoOcupacaoAnos, ')
          ..write('formaOcupacao: $formaOcupacao, ')
          ..write('documentoPosse: $documentoPosse, ')
          ..write('possuiOutroImovel: $possuiOutroImovel, ')
          ..write('possuiConflito: $possuiConflito, ')
          ..write('observacoes: $observacoes, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        projetoId,
        selagemId,
        codigoSelo,
        nomeResponsavel,
        cpfResponsavel,
        rgResponsavel,
        orgaoEmissor,
        estadoCivil,
        profissao,
        telefone,
        quantidadeMoradores,
        rendaFamiliar,
        recebeProgramaSocial,
        programaSocial,
        tempoOcupacaoAnos,
        formaOcupacao,
        documentoPosse,
        possuiOutroImovel,
        possuiConflito,
        observacoes,
        synced,
        createdAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CadastrosSociai &&
          other.id == this.id &&
          other.projetoId == this.projetoId &&
          other.selagemId == this.selagemId &&
          other.codigoSelo == this.codigoSelo &&
          other.nomeResponsavel == this.nomeResponsavel &&
          other.cpfResponsavel == this.cpfResponsavel &&
          other.rgResponsavel == this.rgResponsavel &&
          other.orgaoEmissor == this.orgaoEmissor &&
          other.estadoCivil == this.estadoCivil &&
          other.profissao == this.profissao &&
          other.telefone == this.telefone &&
          other.quantidadeMoradores == this.quantidadeMoradores &&
          other.rendaFamiliar == this.rendaFamiliar &&
          other.recebeProgramaSocial == this.recebeProgramaSocial &&
          other.programaSocial == this.programaSocial &&
          other.tempoOcupacaoAnos == this.tempoOcupacaoAnos &&
          other.formaOcupacao == this.formaOcupacao &&
          other.documentoPosse == this.documentoPosse &&
          other.possuiOutroImovel == this.possuiOutroImovel &&
          other.possuiConflito == this.possuiConflito &&
          other.observacoes == this.observacoes &&
          other.synced == this.synced &&
          other.createdAt == this.createdAt);
}

class CadastrosSociaisCompanion extends UpdateCompanion<CadastrosSociai> {
  final Value<String> id;
  final Value<String> projetoId;
  final Value<String?> selagemId;
  final Value<String> codigoSelo;
  final Value<String> nomeResponsavel;
  final Value<String?> cpfResponsavel;
  final Value<String?> rgResponsavel;
  final Value<String?> orgaoEmissor;
  final Value<String?> estadoCivil;
  final Value<String?> profissao;
  final Value<String?> telefone;
  final Value<int?> quantidadeMoradores;
  final Value<double?> rendaFamiliar;
  final Value<bool> recebeProgramaSocial;
  final Value<String?> programaSocial;
  final Value<int?> tempoOcupacaoAnos;
  final Value<String?> formaOcupacao;
  final Value<String?> documentoPosse;
  final Value<bool> possuiOutroImovel;
  final Value<bool> possuiConflito;
  final Value<String?> observacoes;
  final Value<bool> synced;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CadastrosSociaisCompanion({
    this.id = const Value.absent(),
    this.projetoId = const Value.absent(),
    this.selagemId = const Value.absent(),
    this.codigoSelo = const Value.absent(),
    this.nomeResponsavel = const Value.absent(),
    this.cpfResponsavel = const Value.absent(),
    this.rgResponsavel = const Value.absent(),
    this.orgaoEmissor = const Value.absent(),
    this.estadoCivil = const Value.absent(),
    this.profissao = const Value.absent(),
    this.telefone = const Value.absent(),
    this.quantidadeMoradores = const Value.absent(),
    this.rendaFamiliar = const Value.absent(),
    this.recebeProgramaSocial = const Value.absent(),
    this.programaSocial = const Value.absent(),
    this.tempoOcupacaoAnos = const Value.absent(),
    this.formaOcupacao = const Value.absent(),
    this.documentoPosse = const Value.absent(),
    this.possuiOutroImovel = const Value.absent(),
    this.possuiConflito = const Value.absent(),
    this.observacoes = const Value.absent(),
    this.synced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CadastrosSociaisCompanion.insert({
    required String id,
    required String projetoId,
    this.selagemId = const Value.absent(),
    required String codigoSelo,
    required String nomeResponsavel,
    this.cpfResponsavel = const Value.absent(),
    this.rgResponsavel = const Value.absent(),
    this.orgaoEmissor = const Value.absent(),
    this.estadoCivil = const Value.absent(),
    this.profissao = const Value.absent(),
    this.telefone = const Value.absent(),
    this.quantidadeMoradores = const Value.absent(),
    this.rendaFamiliar = const Value.absent(),
    this.recebeProgramaSocial = const Value.absent(),
    this.programaSocial = const Value.absent(),
    this.tempoOcupacaoAnos = const Value.absent(),
    this.formaOcupacao = const Value.absent(),
    this.documentoPosse = const Value.absent(),
    this.possuiOutroImovel = const Value.absent(),
    this.possuiConflito = const Value.absent(),
    this.observacoes = const Value.absent(),
    this.synced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        projetoId = Value(projetoId),
        codigoSelo = Value(codigoSelo),
        nomeResponsavel = Value(nomeResponsavel);
  static Insertable<CadastrosSociai> custom({
    Expression<String>? id,
    Expression<String>? projetoId,
    Expression<String>? selagemId,
    Expression<String>? codigoSelo,
    Expression<String>? nomeResponsavel,
    Expression<String>? cpfResponsavel,
    Expression<String>? rgResponsavel,
    Expression<String>? orgaoEmissor,
    Expression<String>? estadoCivil,
    Expression<String>? profissao,
    Expression<String>? telefone,
    Expression<int>? quantidadeMoradores,
    Expression<double>? rendaFamiliar,
    Expression<bool>? recebeProgramaSocial,
    Expression<String>? programaSocial,
    Expression<int>? tempoOcupacaoAnos,
    Expression<String>? formaOcupacao,
    Expression<String>? documentoPosse,
    Expression<bool>? possuiOutroImovel,
    Expression<bool>? possuiConflito,
    Expression<String>? observacoes,
    Expression<bool>? synced,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projetoId != null) 'projeto_id': projetoId,
      if (selagemId != null) 'selagem_id': selagemId,
      if (codigoSelo != null) 'codigo_selo': codigoSelo,
      if (nomeResponsavel != null) 'nome_responsavel': nomeResponsavel,
      if (cpfResponsavel != null) 'cpf_responsavel': cpfResponsavel,
      if (rgResponsavel != null) 'rg_responsavel': rgResponsavel,
      if (orgaoEmissor != null) 'orgao_emissor': orgaoEmissor,
      if (estadoCivil != null) 'estado_civil': estadoCivil,
      if (profissao != null) 'profissao': profissao,
      if (telefone != null) 'telefone': telefone,
      if (quantidadeMoradores != null)
        'quantidade_moradores': quantidadeMoradores,
      if (rendaFamiliar != null) 'renda_familiar': rendaFamiliar,
      if (recebeProgramaSocial != null)
        'recebe_programa_social': recebeProgramaSocial,
      if (programaSocial != null) 'programa_social': programaSocial,
      if (tempoOcupacaoAnos != null) 'tempo_ocupacao_anos': tempoOcupacaoAnos,
      if (formaOcupacao != null) 'forma_ocupacao': formaOcupacao,
      if (documentoPosse != null) 'documento_posse': documentoPosse,
      if (possuiOutroImovel != null) 'possui_outro_imovel': possuiOutroImovel,
      if (possuiConflito != null) 'possui_conflito': possuiConflito,
      if (observacoes != null) 'observacoes': observacoes,
      if (synced != null) 'synced': synced,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CadastrosSociaisCompanion copyWith(
      {Value<String>? id,
      Value<String>? projetoId,
      Value<String?>? selagemId,
      Value<String>? codigoSelo,
      Value<String>? nomeResponsavel,
      Value<String?>? cpfResponsavel,
      Value<String?>? rgResponsavel,
      Value<String?>? orgaoEmissor,
      Value<String?>? estadoCivil,
      Value<String?>? profissao,
      Value<String?>? telefone,
      Value<int?>? quantidadeMoradores,
      Value<double?>? rendaFamiliar,
      Value<bool>? recebeProgramaSocial,
      Value<String?>? programaSocial,
      Value<int?>? tempoOcupacaoAnos,
      Value<String?>? formaOcupacao,
      Value<String?>? documentoPosse,
      Value<bool>? possuiOutroImovel,
      Value<bool>? possuiConflito,
      Value<String?>? observacoes,
      Value<bool>? synced,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return CadastrosSociaisCompanion(
      id: id ?? this.id,
      projetoId: projetoId ?? this.projetoId,
      selagemId: selagemId ?? this.selagemId,
      codigoSelo: codigoSelo ?? this.codigoSelo,
      nomeResponsavel: nomeResponsavel ?? this.nomeResponsavel,
      cpfResponsavel: cpfResponsavel ?? this.cpfResponsavel,
      rgResponsavel: rgResponsavel ?? this.rgResponsavel,
      orgaoEmissor: orgaoEmissor ?? this.orgaoEmissor,
      estadoCivil: estadoCivil ?? this.estadoCivil,
      profissao: profissao ?? this.profissao,
      telefone: telefone ?? this.telefone,
      quantidadeMoradores: quantidadeMoradores ?? this.quantidadeMoradores,
      rendaFamiliar: rendaFamiliar ?? this.rendaFamiliar,
      recebeProgramaSocial: recebeProgramaSocial ?? this.recebeProgramaSocial,
      programaSocial: programaSocial ?? this.programaSocial,
      tempoOcupacaoAnos: tempoOcupacaoAnos ?? this.tempoOcupacaoAnos,
      formaOcupacao: formaOcupacao ?? this.formaOcupacao,
      documentoPosse: documentoPosse ?? this.documentoPosse,
      possuiOutroImovel: possuiOutroImovel ?? this.possuiOutroImovel,
      possuiConflito: possuiConflito ?? this.possuiConflito,
      observacoes: observacoes ?? this.observacoes,
      synced: synced ?? this.synced,
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
    if (projetoId.present) {
      map['projeto_id'] = Variable<String>(projetoId.value);
    }
    if (selagemId.present) {
      map['selagem_id'] = Variable<String>(selagemId.value);
    }
    if (codigoSelo.present) {
      map['codigo_selo'] = Variable<String>(codigoSelo.value);
    }
    if (nomeResponsavel.present) {
      map['nome_responsavel'] = Variable<String>(nomeResponsavel.value);
    }
    if (cpfResponsavel.present) {
      map['cpf_responsavel'] = Variable<String>(cpfResponsavel.value);
    }
    if (rgResponsavel.present) {
      map['rg_responsavel'] = Variable<String>(rgResponsavel.value);
    }
    if (orgaoEmissor.present) {
      map['orgao_emissor'] = Variable<String>(orgaoEmissor.value);
    }
    if (estadoCivil.present) {
      map['estado_civil'] = Variable<String>(estadoCivil.value);
    }
    if (profissao.present) {
      map['profissao'] = Variable<String>(profissao.value);
    }
    if (telefone.present) {
      map['telefone'] = Variable<String>(telefone.value);
    }
    if (quantidadeMoradores.present) {
      map['quantidade_moradores'] = Variable<int>(quantidadeMoradores.value);
    }
    if (rendaFamiliar.present) {
      map['renda_familiar'] = Variable<double>(rendaFamiliar.value);
    }
    if (recebeProgramaSocial.present) {
      map['recebe_programa_social'] =
          Variable<bool>(recebeProgramaSocial.value);
    }
    if (programaSocial.present) {
      map['programa_social'] = Variable<String>(programaSocial.value);
    }
    if (tempoOcupacaoAnos.present) {
      map['tempo_ocupacao_anos'] = Variable<int>(tempoOcupacaoAnos.value);
    }
    if (formaOcupacao.present) {
      map['forma_ocupacao'] = Variable<String>(formaOcupacao.value);
    }
    if (documentoPosse.present) {
      map['documento_posse'] = Variable<String>(documentoPosse.value);
    }
    if (possuiOutroImovel.present) {
      map['possui_outro_imovel'] = Variable<bool>(possuiOutroImovel.value);
    }
    if (possuiConflito.present) {
      map['possui_conflito'] = Variable<bool>(possuiConflito.value);
    }
    if (observacoes.present) {
      map['observacoes'] = Variable<String>(observacoes.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
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
    return (StringBuffer('CadastrosSociaisCompanion(')
          ..write('id: $id, ')
          ..write('projetoId: $projetoId, ')
          ..write('selagemId: $selagemId, ')
          ..write('codigoSelo: $codigoSelo, ')
          ..write('nomeResponsavel: $nomeResponsavel, ')
          ..write('cpfResponsavel: $cpfResponsavel, ')
          ..write('rgResponsavel: $rgResponsavel, ')
          ..write('orgaoEmissor: $orgaoEmissor, ')
          ..write('estadoCivil: $estadoCivil, ')
          ..write('profissao: $profissao, ')
          ..write('telefone: $telefone, ')
          ..write('quantidadeMoradores: $quantidadeMoradores, ')
          ..write('rendaFamiliar: $rendaFamiliar, ')
          ..write('recebeProgramaSocial: $recebeProgramaSocial, ')
          ..write('programaSocial: $programaSocial, ')
          ..write('tempoOcupacaoAnos: $tempoOcupacaoAnos, ')
          ..write('formaOcupacao: $formaOcupacao, ')
          ..write('documentoPosse: $documentoPosse, ')
          ..write('possuiOutroImovel: $possuiOutroImovel, ')
          ..write('possuiConflito: $possuiConflito, ')
          ..write('observacoes: $observacoes, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DocumentosReurbTable extends DocumentosReurb
    with TableInfo<$DocumentosReurbTable, DocumentosReurbData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentosReurbTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _projetoIdMeta =
      const VerificationMeta('projetoId');
  @override
  late final GeneratedColumn<String> projetoId = GeneratedColumn<String>(
      'projeto_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _selagemIdMeta =
      const VerificationMeta('selagemId');
  @override
  late final GeneratedColumn<String> selagemId = GeneratedColumn<String>(
      'selagem_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cadastroSocialIdMeta =
      const VerificationMeta('cadastroSocialId');
  @override
  late final GeneratedColumn<String> cadastroSocialId = GeneratedColumn<String>(
      'cadastro_social_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _codigoSeloMeta =
      const VerificationMeta('codigoSelo');
  @override
  late final GeneratedColumn<String> codigoSelo = GeneratedColumn<String>(
      'codigo_selo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tipoDocumentoMeta =
      const VerificationMeta('tipoDocumento');
  @override
  late final GeneratedColumn<String> tipoDocumento = GeneratedColumn<String>(
      'tipo_documento', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _arquivoPathMeta =
      const VerificationMeta('arquivoPath');
  @override
  late final GeneratedColumn<String> arquivoPath = GeneratedColumn<String>(
      'arquivo_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _observacoesMeta =
      const VerificationMeta('observacoes');
  @override
  late final GeneratedColumn<String> observacoes = GeneratedColumn<String>(
      'observacoes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _sourceDeviceIdMeta =
      const VerificationMeta('sourceDeviceId');
  @override
  late final GeneratedColumn<String> sourceDeviceId = GeneratedColumn<String>(
      'source_device_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _syncAttemptsMeta =
      const VerificationMeta('syncAttempts');
  @override
  late final GeneratedColumn<int> syncAttempts = GeneratedColumn<int>(
      'sync_attempts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _syncErrorMeta =
      const VerificationMeta('syncError');
  @override
  late final GeneratedColumn<String> syncError = GeneratedColumn<String>(
      'sync_error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastSyncAttemptAtMeta =
      const VerificationMeta('lastSyncAttemptAt');
  @override
  late final GeneratedColumn<DateTime> lastSyncAttemptAt =
      GeneratedColumn<DateTime>('last_sync_attempt_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _localUpdatedAtMeta =
      const VerificationMeta('localUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> localUpdatedAt =
      GeneratedColumn<DateTime>('local_updated_at', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  static const VerificationMeta _serverUpdatedAtMeta =
      const VerificationMeta('serverUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>('server_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _syncVersionMeta =
      const VerificationMeta('syncVersion');
  @override
  late final GeneratedColumn<int> syncVersion = GeneratedColumn<int>(
      'sync_version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _deletedLocallyMeta =
      const VerificationMeta('deletedLocally');
  @override
  late final GeneratedColumn<bool> deletedLocally = GeneratedColumn<bool>(
      'deleted_locally', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("deleted_locally" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        projetoId,
        selagemId,
        cadastroSocialId,
        codigoSelo,
        tipoDocumento,
        arquivoPath,
        observacoes,
        synced,
        sourceDeviceId,
        syncStatus,
        syncAttempts,
        syncError,
        lastSyncAttemptAt,
        syncedAt,
        localUpdatedAt,
        serverUpdatedAt,
        syncVersion,
        deletedLocally,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'documentos_reurb';
  @override
  VerificationContext validateIntegrity(
      Insertable<DocumentosReurbData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('projeto_id')) {
      context.handle(_projetoIdMeta,
          projetoId.isAcceptableOrUnknown(data['projeto_id']!, _projetoIdMeta));
    } else if (isInserting) {
      context.missing(_projetoIdMeta);
    }
    if (data.containsKey('selagem_id')) {
      context.handle(_selagemIdMeta,
          selagemId.isAcceptableOrUnknown(data['selagem_id']!, _selagemIdMeta));
    }
    if (data.containsKey('cadastro_social_id')) {
      context.handle(
          _cadastroSocialIdMeta,
          cadastroSocialId.isAcceptableOrUnknown(
              data['cadastro_social_id']!, _cadastroSocialIdMeta));
    }
    if (data.containsKey('codigo_selo')) {
      context.handle(
          _codigoSeloMeta,
          codigoSelo.isAcceptableOrUnknown(
              data['codigo_selo']!, _codigoSeloMeta));
    } else if (isInserting) {
      context.missing(_codigoSeloMeta);
    }
    if (data.containsKey('tipo_documento')) {
      context.handle(
          _tipoDocumentoMeta,
          tipoDocumento.isAcceptableOrUnknown(
              data['tipo_documento']!, _tipoDocumentoMeta));
    } else if (isInserting) {
      context.missing(_tipoDocumentoMeta);
    }
    if (data.containsKey('arquivo_path')) {
      context.handle(
          _arquivoPathMeta,
          arquivoPath.isAcceptableOrUnknown(
              data['arquivo_path']!, _arquivoPathMeta));
    } else if (isInserting) {
      context.missing(_arquivoPathMeta);
    }
    if (data.containsKey('observacoes')) {
      context.handle(
          _observacoesMeta,
          observacoes.isAcceptableOrUnknown(
              data['observacoes']!, _observacoesMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    if (data.containsKey('source_device_id')) {
      context.handle(
          _sourceDeviceIdMeta,
          sourceDeviceId.isAcceptableOrUnknown(
              data['source_device_id']!, _sourceDeviceIdMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('sync_attempts')) {
      context.handle(
          _syncAttemptsMeta,
          syncAttempts.isAcceptableOrUnknown(
              data['sync_attempts']!, _syncAttemptsMeta));
    }
    if (data.containsKey('sync_error')) {
      context.handle(_syncErrorMeta,
          syncError.isAcceptableOrUnknown(data['sync_error']!, _syncErrorMeta));
    }
    if (data.containsKey('last_sync_attempt_at')) {
      context.handle(
          _lastSyncAttemptAtMeta,
          lastSyncAttemptAt.isAcceptableOrUnknown(
              data['last_sync_attempt_at']!, _lastSyncAttemptAtMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    if (data.containsKey('local_updated_at')) {
      context.handle(
          _localUpdatedAtMeta,
          localUpdatedAt.isAcceptableOrUnknown(
              data['local_updated_at']!, _localUpdatedAtMeta));
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
          _serverUpdatedAtMeta,
          serverUpdatedAt.isAcceptableOrUnknown(
              data['server_updated_at']!, _serverUpdatedAtMeta));
    }
    if (data.containsKey('sync_version')) {
      context.handle(
          _syncVersionMeta,
          syncVersion.isAcceptableOrUnknown(
              data['sync_version']!, _syncVersionMeta));
    }
    if (data.containsKey('deleted_locally')) {
      context.handle(
          _deletedLocallyMeta,
          deletedLocally.isAcceptableOrUnknown(
              data['deleted_locally']!, _deletedLocallyMeta));
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
  DocumentosReurbData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentosReurbData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      projetoId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}projeto_id'])!,
      selagemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}selagem_id']),
      cadastroSocialId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}cadastro_social_id']),
      codigoSelo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}codigo_selo'])!,
      tipoDocumento: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tipo_documento'])!,
      arquivoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}arquivo_path'])!,
      observacoes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}observacoes']),
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
      sourceDeviceId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}source_device_id']),
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      syncAttempts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sync_attempts'])!,
      syncError: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_error']),
      lastSyncAttemptAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}last_sync_attempt_at']),
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
      localUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}local_updated_at'])!,
      serverUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}server_updated_at']),
      syncVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sync_version'])!,
      deletedLocally: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted_locally'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $DocumentosReurbTable createAlias(String alias) {
    return $DocumentosReurbTable(attachedDatabase, alias);
  }
}

class DocumentosReurbData extends DataClass
    implements Insertable<DocumentosReurbData> {
  final String id;
  final String projetoId;
  final String? selagemId;
  final String? cadastroSocialId;
  final String codigoSelo;
  final String tipoDocumento;
  final String arquivoPath;
  final String? observacoes;
  final bool synced;
  final String? sourceDeviceId;
  final String syncStatus;
  final int syncAttempts;
  final String? syncError;
  final DateTime? lastSyncAttemptAt;
  final DateTime? syncedAt;
  final DateTime localUpdatedAt;
  final DateTime? serverUpdatedAt;
  final int syncVersion;
  final bool deletedLocally;
  final DateTime createdAt;
  const DocumentosReurbData(
      {required this.id,
      required this.projetoId,
      this.selagemId,
      this.cadastroSocialId,
      required this.codigoSelo,
      required this.tipoDocumento,
      required this.arquivoPath,
      this.observacoes,
      required this.synced,
      this.sourceDeviceId,
      required this.syncStatus,
      required this.syncAttempts,
      this.syncError,
      this.lastSyncAttemptAt,
      this.syncedAt,
      required this.localUpdatedAt,
      this.serverUpdatedAt,
      required this.syncVersion,
      required this.deletedLocally,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['projeto_id'] = Variable<String>(projetoId);
    if (!nullToAbsent || selagemId != null) {
      map['selagem_id'] = Variable<String>(selagemId);
    }
    if (!nullToAbsent || cadastroSocialId != null) {
      map['cadastro_social_id'] = Variable<String>(cadastroSocialId);
    }
    map['codigo_selo'] = Variable<String>(codigoSelo);
    map['tipo_documento'] = Variable<String>(tipoDocumento);
    map['arquivo_path'] = Variable<String>(arquivoPath);
    if (!nullToAbsent || observacoes != null) {
      map['observacoes'] = Variable<String>(observacoes);
    }
    map['synced'] = Variable<bool>(synced);
    if (!nullToAbsent || sourceDeviceId != null) {
      map['source_device_id'] = Variable<String>(sourceDeviceId);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['sync_attempts'] = Variable<int>(syncAttempts);
    if (!nullToAbsent || syncError != null) {
      map['sync_error'] = Variable<String>(syncError);
    }
    if (!nullToAbsent || lastSyncAttemptAt != null) {
      map['last_sync_attempt_at'] = Variable<DateTime>(lastSyncAttemptAt);
    }
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['local_updated_at'] = Variable<DateTime>(localUpdatedAt);
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    }
    map['sync_version'] = Variable<int>(syncVersion);
    map['deleted_locally'] = Variable<bool>(deletedLocally);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DocumentosReurbCompanion toCompanion(bool nullToAbsent) {
    return DocumentosReurbCompanion(
      id: Value(id),
      projetoId: Value(projetoId),
      selagemId: selagemId == null && nullToAbsent
          ? const Value.absent()
          : Value(selagemId),
      cadastroSocialId: cadastroSocialId == null && nullToAbsent
          ? const Value.absent()
          : Value(cadastroSocialId),
      codigoSelo: Value(codigoSelo),
      tipoDocumento: Value(tipoDocumento),
      arquivoPath: Value(arquivoPath),
      observacoes: observacoes == null && nullToAbsent
          ? const Value.absent()
          : Value(observacoes),
      synced: Value(synced),
      sourceDeviceId: sourceDeviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceDeviceId),
      syncStatus: Value(syncStatus),
      syncAttempts: Value(syncAttempts),
      syncError: syncError == null && nullToAbsent
          ? const Value.absent()
          : Value(syncError),
      lastSyncAttemptAt: lastSyncAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAttemptAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      localUpdatedAt: Value(localUpdatedAt),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      syncVersion: Value(syncVersion),
      deletedLocally: Value(deletedLocally),
      createdAt: Value(createdAt),
    );
  }

  factory DocumentosReurbData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentosReurbData(
      id: serializer.fromJson<String>(json['id']),
      projetoId: serializer.fromJson<String>(json['projetoId']),
      selagemId: serializer.fromJson<String?>(json['selagemId']),
      cadastroSocialId: serializer.fromJson<String?>(json['cadastroSocialId']),
      codigoSelo: serializer.fromJson<String>(json['codigoSelo']),
      tipoDocumento: serializer.fromJson<String>(json['tipoDocumento']),
      arquivoPath: serializer.fromJson<String>(json['arquivoPath']),
      observacoes: serializer.fromJson<String?>(json['observacoes']),
      synced: serializer.fromJson<bool>(json['synced']),
      sourceDeviceId: serializer.fromJson<String?>(json['sourceDeviceId']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      syncAttempts: serializer.fromJson<int>(json['syncAttempts']),
      syncError: serializer.fromJson<String?>(json['syncError']),
      lastSyncAttemptAt:
          serializer.fromJson<DateTime?>(json['lastSyncAttemptAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      localUpdatedAt: serializer.fromJson<DateTime>(json['localUpdatedAt']),
      serverUpdatedAt: serializer.fromJson<DateTime?>(json['serverUpdatedAt']),
      syncVersion: serializer.fromJson<int>(json['syncVersion']),
      deletedLocally: serializer.fromJson<bool>(json['deletedLocally']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projetoId': serializer.toJson<String>(projetoId),
      'selagemId': serializer.toJson<String?>(selagemId),
      'cadastroSocialId': serializer.toJson<String?>(cadastroSocialId),
      'codigoSelo': serializer.toJson<String>(codigoSelo),
      'tipoDocumento': serializer.toJson<String>(tipoDocumento),
      'arquivoPath': serializer.toJson<String>(arquivoPath),
      'observacoes': serializer.toJson<String?>(observacoes),
      'synced': serializer.toJson<bool>(synced),
      'sourceDeviceId': serializer.toJson<String?>(sourceDeviceId),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'syncAttempts': serializer.toJson<int>(syncAttempts),
      'syncError': serializer.toJson<String?>(syncError),
      'lastSyncAttemptAt': serializer.toJson<DateTime?>(lastSyncAttemptAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'localUpdatedAt': serializer.toJson<DateTime>(localUpdatedAt),
      'serverUpdatedAt': serializer.toJson<DateTime?>(serverUpdatedAt),
      'syncVersion': serializer.toJson<int>(syncVersion),
      'deletedLocally': serializer.toJson<bool>(deletedLocally),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DocumentosReurbData copyWith(
          {String? id,
          String? projetoId,
          Value<String?> selagemId = const Value.absent(),
          Value<String?> cadastroSocialId = const Value.absent(),
          String? codigoSelo,
          String? tipoDocumento,
          String? arquivoPath,
          Value<String?> observacoes = const Value.absent(),
          bool? synced,
          Value<String?> sourceDeviceId = const Value.absent(),
          String? syncStatus,
          int? syncAttempts,
          Value<String?> syncError = const Value.absent(),
          Value<DateTime?> lastSyncAttemptAt = const Value.absent(),
          Value<DateTime?> syncedAt = const Value.absent(),
          DateTime? localUpdatedAt,
          Value<DateTime?> serverUpdatedAt = const Value.absent(),
          int? syncVersion,
          bool? deletedLocally,
          DateTime? createdAt}) =>
      DocumentosReurbData(
        id: id ?? this.id,
        projetoId: projetoId ?? this.projetoId,
        selagemId: selagemId.present ? selagemId.value : this.selagemId,
        cadastroSocialId: cadastroSocialId.present
            ? cadastroSocialId.value
            : this.cadastroSocialId,
        codigoSelo: codigoSelo ?? this.codigoSelo,
        tipoDocumento: tipoDocumento ?? this.tipoDocumento,
        arquivoPath: arquivoPath ?? this.arquivoPath,
        observacoes: observacoes.present ? observacoes.value : this.observacoes,
        synced: synced ?? this.synced,
        sourceDeviceId:
            sourceDeviceId.present ? sourceDeviceId.value : this.sourceDeviceId,
        syncStatus: syncStatus ?? this.syncStatus,
        syncAttempts: syncAttempts ?? this.syncAttempts,
        syncError: syncError.present ? syncError.value : this.syncError,
        lastSyncAttemptAt: lastSyncAttemptAt.present
            ? lastSyncAttemptAt.value
            : this.lastSyncAttemptAt,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
        localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
        serverUpdatedAt: serverUpdatedAt.present
            ? serverUpdatedAt.value
            : this.serverUpdatedAt,
        syncVersion: syncVersion ?? this.syncVersion,
        deletedLocally: deletedLocally ?? this.deletedLocally,
        createdAt: createdAt ?? this.createdAt,
      );
  DocumentosReurbData copyWithCompanion(DocumentosReurbCompanion data) {
    return DocumentosReurbData(
      id: data.id.present ? data.id.value : this.id,
      projetoId: data.projetoId.present ? data.projetoId.value : this.projetoId,
      selagemId: data.selagemId.present ? data.selagemId.value : this.selagemId,
      cadastroSocialId: data.cadastroSocialId.present
          ? data.cadastroSocialId.value
          : this.cadastroSocialId,
      codigoSelo:
          data.codigoSelo.present ? data.codigoSelo.value : this.codigoSelo,
      tipoDocumento: data.tipoDocumento.present
          ? data.tipoDocumento.value
          : this.tipoDocumento,
      arquivoPath:
          data.arquivoPath.present ? data.arquivoPath.value : this.arquivoPath,
      observacoes:
          data.observacoes.present ? data.observacoes.value : this.observacoes,
      synced: data.synced.present ? data.synced.value : this.synced,
      sourceDeviceId: data.sourceDeviceId.present
          ? data.sourceDeviceId.value
          : this.sourceDeviceId,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      syncAttempts: data.syncAttempts.present
          ? data.syncAttempts.value
          : this.syncAttempts,
      syncError: data.syncError.present ? data.syncError.value : this.syncError,
      lastSyncAttemptAt: data.lastSyncAttemptAt.present
          ? data.lastSyncAttemptAt.value
          : this.lastSyncAttemptAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      localUpdatedAt: data.localUpdatedAt.present
          ? data.localUpdatedAt.value
          : this.localUpdatedAt,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      syncVersion:
          data.syncVersion.present ? data.syncVersion.value : this.syncVersion,
      deletedLocally: data.deletedLocally.present
          ? data.deletedLocally.value
          : this.deletedLocally,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentosReurbData(')
          ..write('id: $id, ')
          ..write('projetoId: $projetoId, ')
          ..write('selagemId: $selagemId, ')
          ..write('cadastroSocialId: $cadastroSocialId, ')
          ..write('codigoSelo: $codigoSelo, ')
          ..write('tipoDocumento: $tipoDocumento, ')
          ..write('arquivoPath: $arquivoPath, ')
          ..write('observacoes: $observacoes, ')
          ..write('synced: $synced, ')
          ..write('sourceDeviceId: $sourceDeviceId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncAttempts: $syncAttempts, ')
          ..write('syncError: $syncError, ')
          ..write('lastSyncAttemptAt: $lastSyncAttemptAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('deletedLocally: $deletedLocally, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      projetoId,
      selagemId,
      cadastroSocialId,
      codigoSelo,
      tipoDocumento,
      arquivoPath,
      observacoes,
      synced,
      sourceDeviceId,
      syncStatus,
      syncAttempts,
      syncError,
      lastSyncAttemptAt,
      syncedAt,
      localUpdatedAt,
      serverUpdatedAt,
      syncVersion,
      deletedLocally,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentosReurbData &&
          other.id == this.id &&
          other.projetoId == this.projetoId &&
          other.selagemId == this.selagemId &&
          other.cadastroSocialId == this.cadastroSocialId &&
          other.codigoSelo == this.codigoSelo &&
          other.tipoDocumento == this.tipoDocumento &&
          other.arquivoPath == this.arquivoPath &&
          other.observacoes == this.observacoes &&
          other.synced == this.synced &&
          other.sourceDeviceId == this.sourceDeviceId &&
          other.syncStatus == this.syncStatus &&
          other.syncAttempts == this.syncAttempts &&
          other.syncError == this.syncError &&
          other.lastSyncAttemptAt == this.lastSyncAttemptAt &&
          other.syncedAt == this.syncedAt &&
          other.localUpdatedAt == this.localUpdatedAt &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.syncVersion == this.syncVersion &&
          other.deletedLocally == this.deletedLocally &&
          other.createdAt == this.createdAt);
}

class DocumentosReurbCompanion extends UpdateCompanion<DocumentosReurbData> {
  final Value<String> id;
  final Value<String> projetoId;
  final Value<String?> selagemId;
  final Value<String?> cadastroSocialId;
  final Value<String> codigoSelo;
  final Value<String> tipoDocumento;
  final Value<String> arquivoPath;
  final Value<String?> observacoes;
  final Value<bool> synced;
  final Value<String?> sourceDeviceId;
  final Value<String> syncStatus;
  final Value<int> syncAttempts;
  final Value<String?> syncError;
  final Value<DateTime?> lastSyncAttemptAt;
  final Value<DateTime?> syncedAt;
  final Value<DateTime> localUpdatedAt;
  final Value<DateTime?> serverUpdatedAt;
  final Value<int> syncVersion;
  final Value<bool> deletedLocally;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const DocumentosReurbCompanion({
    this.id = const Value.absent(),
    this.projetoId = const Value.absent(),
    this.selagemId = const Value.absent(),
    this.cadastroSocialId = const Value.absent(),
    this.codigoSelo = const Value.absent(),
    this.tipoDocumento = const Value.absent(),
    this.arquivoPath = const Value.absent(),
    this.observacoes = const Value.absent(),
    this.synced = const Value.absent(),
    this.sourceDeviceId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncAttempts = const Value.absent(),
    this.syncError = const Value.absent(),
    this.lastSyncAttemptAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.deletedLocally = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentosReurbCompanion.insert({
    required String id,
    required String projetoId,
    this.selagemId = const Value.absent(),
    this.cadastroSocialId = const Value.absent(),
    required String codigoSelo,
    required String tipoDocumento,
    required String arquivoPath,
    this.observacoes = const Value.absent(),
    this.synced = const Value.absent(),
    this.sourceDeviceId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncAttempts = const Value.absent(),
    this.syncError = const Value.absent(),
    this.lastSyncAttemptAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.deletedLocally = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        projetoId = Value(projetoId),
        codigoSelo = Value(codigoSelo),
        tipoDocumento = Value(tipoDocumento),
        arquivoPath = Value(arquivoPath);
  static Insertable<DocumentosReurbData> custom({
    Expression<String>? id,
    Expression<String>? projetoId,
    Expression<String>? selagemId,
    Expression<String>? cadastroSocialId,
    Expression<String>? codigoSelo,
    Expression<String>? tipoDocumento,
    Expression<String>? arquivoPath,
    Expression<String>? observacoes,
    Expression<bool>? synced,
    Expression<String>? sourceDeviceId,
    Expression<String>? syncStatus,
    Expression<int>? syncAttempts,
    Expression<String>? syncError,
    Expression<DateTime>? lastSyncAttemptAt,
    Expression<DateTime>? syncedAt,
    Expression<DateTime>? localUpdatedAt,
    Expression<DateTime>? serverUpdatedAt,
    Expression<int>? syncVersion,
    Expression<bool>? deletedLocally,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projetoId != null) 'projeto_id': projetoId,
      if (selagemId != null) 'selagem_id': selagemId,
      if (cadastroSocialId != null) 'cadastro_social_id': cadastroSocialId,
      if (codigoSelo != null) 'codigo_selo': codigoSelo,
      if (tipoDocumento != null) 'tipo_documento': tipoDocumento,
      if (arquivoPath != null) 'arquivo_path': arquivoPath,
      if (observacoes != null) 'observacoes': observacoes,
      if (synced != null) 'synced': synced,
      if (sourceDeviceId != null) 'source_device_id': sourceDeviceId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncAttempts != null) 'sync_attempts': syncAttempts,
      if (syncError != null) 'sync_error': syncError,
      if (lastSyncAttemptAt != null) 'last_sync_attempt_at': lastSyncAttemptAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (localUpdatedAt != null) 'local_updated_at': localUpdatedAt,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (syncVersion != null) 'sync_version': syncVersion,
      if (deletedLocally != null) 'deleted_locally': deletedLocally,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentosReurbCompanion copyWith(
      {Value<String>? id,
      Value<String>? projetoId,
      Value<String?>? selagemId,
      Value<String?>? cadastroSocialId,
      Value<String>? codigoSelo,
      Value<String>? tipoDocumento,
      Value<String>? arquivoPath,
      Value<String?>? observacoes,
      Value<bool>? synced,
      Value<String?>? sourceDeviceId,
      Value<String>? syncStatus,
      Value<int>? syncAttempts,
      Value<String?>? syncError,
      Value<DateTime?>? lastSyncAttemptAt,
      Value<DateTime?>? syncedAt,
      Value<DateTime>? localUpdatedAt,
      Value<DateTime?>? serverUpdatedAt,
      Value<int>? syncVersion,
      Value<bool>? deletedLocally,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return DocumentosReurbCompanion(
      id: id ?? this.id,
      projetoId: projetoId ?? this.projetoId,
      selagemId: selagemId ?? this.selagemId,
      cadastroSocialId: cadastroSocialId ?? this.cadastroSocialId,
      codigoSelo: codigoSelo ?? this.codigoSelo,
      tipoDocumento: tipoDocumento ?? this.tipoDocumento,
      arquivoPath: arquivoPath ?? this.arquivoPath,
      observacoes: observacoes ?? this.observacoes,
      synced: synced ?? this.synced,
      sourceDeviceId: sourceDeviceId ?? this.sourceDeviceId,
      syncStatus: syncStatus ?? this.syncStatus,
      syncAttempts: syncAttempts ?? this.syncAttempts,
      syncError: syncError ?? this.syncError,
      lastSyncAttemptAt: lastSyncAttemptAt ?? this.lastSyncAttemptAt,
      syncedAt: syncedAt ?? this.syncedAt,
      localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      syncVersion: syncVersion ?? this.syncVersion,
      deletedLocally: deletedLocally ?? this.deletedLocally,
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
    if (projetoId.present) {
      map['projeto_id'] = Variable<String>(projetoId.value);
    }
    if (selagemId.present) {
      map['selagem_id'] = Variable<String>(selagemId.value);
    }
    if (cadastroSocialId.present) {
      map['cadastro_social_id'] = Variable<String>(cadastroSocialId.value);
    }
    if (codigoSelo.present) {
      map['codigo_selo'] = Variable<String>(codigoSelo.value);
    }
    if (tipoDocumento.present) {
      map['tipo_documento'] = Variable<String>(tipoDocumento.value);
    }
    if (arquivoPath.present) {
      map['arquivo_path'] = Variable<String>(arquivoPath.value);
    }
    if (observacoes.present) {
      map['observacoes'] = Variable<String>(observacoes.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (sourceDeviceId.present) {
      map['source_device_id'] = Variable<String>(sourceDeviceId.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (syncAttempts.present) {
      map['sync_attempts'] = Variable<int>(syncAttempts.value);
    }
    if (syncError.present) {
      map['sync_error'] = Variable<String>(syncError.value);
    }
    if (lastSyncAttemptAt.present) {
      map['last_sync_attempt_at'] = Variable<DateTime>(lastSyncAttemptAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (localUpdatedAt.present) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (syncVersion.present) {
      map['sync_version'] = Variable<int>(syncVersion.value);
    }
    if (deletedLocally.present) {
      map['deleted_locally'] = Variable<bool>(deletedLocally.value);
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
    return (StringBuffer('DocumentosReurbCompanion(')
          ..write('id: $id, ')
          ..write('projetoId: $projetoId, ')
          ..write('selagemId: $selagemId, ')
          ..write('cadastroSocialId: $cadastroSocialId, ')
          ..write('codigoSelo: $codigoSelo, ')
          ..write('tipoDocumento: $tipoDocumento, ')
          ..write('arquivoPath: $arquivoPath, ')
          ..write('observacoes: $observacoes, ')
          ..write('synced: $synced, ')
          ..write('sourceDeviceId: $sourceDeviceId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncAttempts: $syncAttempts, ')
          ..write('syncError: $syncError, ')
          ..write('lastSyncAttemptAt: $lastSyncAttemptAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('deletedLocally: $deletedLocally, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LotesPreliminaresTable extends LotesPreliminares
    with TableInfo<$LotesPreliminaresTable, LotesPreliminare> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LotesPreliminaresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _projetoIdMeta =
      const VerificationMeta('projetoId');
  @override
  late final GeneratedColumn<String> projetoId = GeneratedColumn<String>(
      'projeto_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _codigoLoteMeta =
      const VerificationMeta('codigoLote');
  @override
  late final GeneratedColumn<String> codigoLote = GeneratedColumn<String>(
      'codigo_lote', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quadraMeta = const VerificationMeta('quadra');
  @override
  late final GeneratedColumn<String> quadra = GeneratedColumn<String>(
      'quadra', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _areaM2Meta = const VerificationMeta('areaM2');
  @override
  late final GeneratedColumn<double> areaM2 = GeneratedColumn<double>(
      'area_m2', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _perimetroMMeta =
      const VerificationMeta('perimetroM');
  @override
  late final GeneratedColumn<double> perimetroM = GeneratedColumn<double>(
      'perimetro_m', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _geometriaGeojsonMeta =
      const VerificationMeta('geometriaGeojson');
  @override
  late final GeneratedColumn<String> geometriaGeojson = GeneratedColumn<String>(
      'geometria_geojson', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _origemArquivoMeta =
      const VerificationMeta('origemArquivo');
  @override
  late final GeneratedColumn<String> origemArquivo = GeneratedColumn<String>(
      'origem_arquivo', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tipoGeometriaMeta =
      const VerificationMeta('tipoGeometria');
  @override
  late final GeneratedColumn<String> tipoGeometria = GeneratedColumn<String>(
      'tipo_geometria', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusLoteMeta =
      const VerificationMeta('statusLote');
  @override
  late final GeneratedColumn<String> statusLote = GeneratedColumn<String>(
      'status_lote', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('preliminar'));
  static const VerificationMeta _necessitaRevisaoMeta =
      const VerificationMeta('necessitaRevisao');
  @override
  late final GeneratedColumn<bool> necessitaRevisao = GeneratedColumn<bool>(
      'necessita_revisao', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("necessita_revisao" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _observacoesMeta =
      const VerificationMeta('observacoes');
  @override
  late final GeneratedColumn<String> observacoes = GeneratedColumn<String>(
      'observacoes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        projetoId,
        codigoLote,
        quadra,
        areaM2,
        perimetroM,
        geometriaGeojson,
        origemArquivo,
        tipoGeometria,
        statusLote,
        necessitaRevisao,
        observacoes,
        synced,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lotes_preliminares';
  @override
  VerificationContext validateIntegrity(Insertable<LotesPreliminare> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('projeto_id')) {
      context.handle(_projetoIdMeta,
          projetoId.isAcceptableOrUnknown(data['projeto_id']!, _projetoIdMeta));
    } else if (isInserting) {
      context.missing(_projetoIdMeta);
    }
    if (data.containsKey('codigo_lote')) {
      context.handle(
          _codigoLoteMeta,
          codigoLote.isAcceptableOrUnknown(
              data['codigo_lote']!, _codigoLoteMeta));
    } else if (isInserting) {
      context.missing(_codigoLoteMeta);
    }
    if (data.containsKey('quadra')) {
      context.handle(_quadraMeta,
          quadra.isAcceptableOrUnknown(data['quadra']!, _quadraMeta));
    }
    if (data.containsKey('area_m2')) {
      context.handle(_areaM2Meta,
          areaM2.isAcceptableOrUnknown(data['area_m2']!, _areaM2Meta));
    }
    if (data.containsKey('perimetro_m')) {
      context.handle(
          _perimetroMMeta,
          perimetroM.isAcceptableOrUnknown(
              data['perimetro_m']!, _perimetroMMeta));
    }
    if (data.containsKey('geometria_geojson')) {
      context.handle(
          _geometriaGeojsonMeta,
          geometriaGeojson.isAcceptableOrUnknown(
              data['geometria_geojson']!, _geometriaGeojsonMeta));
    }
    if (data.containsKey('origem_arquivo')) {
      context.handle(
          _origemArquivoMeta,
          origemArquivo.isAcceptableOrUnknown(
              data['origem_arquivo']!, _origemArquivoMeta));
    }
    if (data.containsKey('tipo_geometria')) {
      context.handle(
          _tipoGeometriaMeta,
          tipoGeometria.isAcceptableOrUnknown(
              data['tipo_geometria']!, _tipoGeometriaMeta));
    }
    if (data.containsKey('status_lote')) {
      context.handle(
          _statusLoteMeta,
          statusLote.isAcceptableOrUnknown(
              data['status_lote']!, _statusLoteMeta));
    }
    if (data.containsKey('necessita_revisao')) {
      context.handle(
          _necessitaRevisaoMeta,
          necessitaRevisao.isAcceptableOrUnknown(
              data['necessita_revisao']!, _necessitaRevisaoMeta));
    }
    if (data.containsKey('observacoes')) {
      context.handle(
          _observacoesMeta,
          observacoes.isAcceptableOrUnknown(
              data['observacoes']!, _observacoesMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
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
  LotesPreliminare map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LotesPreliminare(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      projetoId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}projeto_id'])!,
      codigoLote: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}codigo_lote'])!,
      quadra: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}quadra']),
      areaM2: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}area_m2']),
      perimetroM: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}perimetro_m']),
      geometriaGeojson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}geometria_geojson']),
      origemArquivo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}origem_arquivo']),
      tipoGeometria: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tipo_geometria']),
      statusLote: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status_lote'])!,
      necessitaRevisao: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}necessita_revisao'])!,
      observacoes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}observacoes']),
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $LotesPreliminaresTable createAlias(String alias) {
    return $LotesPreliminaresTable(attachedDatabase, alias);
  }
}

class LotesPreliminare extends DataClass
    implements Insertable<LotesPreliminare> {
  final String id;
  final String projetoId;
  final String codigoLote;
  final String? quadra;
  final double? areaM2;
  final double? perimetroM;
  final String? geometriaGeojson;
  final String? origemArquivo;
  final String? tipoGeometria;
  final String statusLote;
  final bool necessitaRevisao;
  final String? observacoes;
  final bool synced;
  final DateTime createdAt;
  const LotesPreliminare(
      {required this.id,
      required this.projetoId,
      required this.codigoLote,
      this.quadra,
      this.areaM2,
      this.perimetroM,
      this.geometriaGeojson,
      this.origemArquivo,
      this.tipoGeometria,
      required this.statusLote,
      required this.necessitaRevisao,
      this.observacoes,
      required this.synced,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['projeto_id'] = Variable<String>(projetoId);
    map['codigo_lote'] = Variable<String>(codigoLote);
    if (!nullToAbsent || quadra != null) {
      map['quadra'] = Variable<String>(quadra);
    }
    if (!nullToAbsent || areaM2 != null) {
      map['area_m2'] = Variable<double>(areaM2);
    }
    if (!nullToAbsent || perimetroM != null) {
      map['perimetro_m'] = Variable<double>(perimetroM);
    }
    if (!nullToAbsent || geometriaGeojson != null) {
      map['geometria_geojson'] = Variable<String>(geometriaGeojson);
    }
    if (!nullToAbsent || origemArquivo != null) {
      map['origem_arquivo'] = Variable<String>(origemArquivo);
    }
    if (!nullToAbsent || tipoGeometria != null) {
      map['tipo_geometria'] = Variable<String>(tipoGeometria);
    }
    map['status_lote'] = Variable<String>(statusLote);
    map['necessita_revisao'] = Variable<bool>(necessitaRevisao);
    if (!nullToAbsent || observacoes != null) {
      map['observacoes'] = Variable<String>(observacoes);
    }
    map['synced'] = Variable<bool>(synced);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LotesPreliminaresCompanion toCompanion(bool nullToAbsent) {
    return LotesPreliminaresCompanion(
      id: Value(id),
      projetoId: Value(projetoId),
      codigoLote: Value(codigoLote),
      quadra:
          quadra == null && nullToAbsent ? const Value.absent() : Value(quadra),
      areaM2:
          areaM2 == null && nullToAbsent ? const Value.absent() : Value(areaM2),
      perimetroM: perimetroM == null && nullToAbsent
          ? const Value.absent()
          : Value(perimetroM),
      geometriaGeojson: geometriaGeojson == null && nullToAbsent
          ? const Value.absent()
          : Value(geometriaGeojson),
      origemArquivo: origemArquivo == null && nullToAbsent
          ? const Value.absent()
          : Value(origemArquivo),
      tipoGeometria: tipoGeometria == null && nullToAbsent
          ? const Value.absent()
          : Value(tipoGeometria),
      statusLote: Value(statusLote),
      necessitaRevisao: Value(necessitaRevisao),
      observacoes: observacoes == null && nullToAbsent
          ? const Value.absent()
          : Value(observacoes),
      synced: Value(synced),
      createdAt: Value(createdAt),
    );
  }

  factory LotesPreliminare.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LotesPreliminare(
      id: serializer.fromJson<String>(json['id']),
      projetoId: serializer.fromJson<String>(json['projetoId']),
      codigoLote: serializer.fromJson<String>(json['codigoLote']),
      quadra: serializer.fromJson<String?>(json['quadra']),
      areaM2: serializer.fromJson<double?>(json['areaM2']),
      perimetroM: serializer.fromJson<double?>(json['perimetroM']),
      geometriaGeojson: serializer.fromJson<String?>(json['geometriaGeojson']),
      origemArquivo: serializer.fromJson<String?>(json['origemArquivo']),
      tipoGeometria: serializer.fromJson<String?>(json['tipoGeometria']),
      statusLote: serializer.fromJson<String>(json['statusLote']),
      necessitaRevisao: serializer.fromJson<bool>(json['necessitaRevisao']),
      observacoes: serializer.fromJson<String?>(json['observacoes']),
      synced: serializer.fromJson<bool>(json['synced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projetoId': serializer.toJson<String>(projetoId),
      'codigoLote': serializer.toJson<String>(codigoLote),
      'quadra': serializer.toJson<String?>(quadra),
      'areaM2': serializer.toJson<double?>(areaM2),
      'perimetroM': serializer.toJson<double?>(perimetroM),
      'geometriaGeojson': serializer.toJson<String?>(geometriaGeojson),
      'origemArquivo': serializer.toJson<String?>(origemArquivo),
      'tipoGeometria': serializer.toJson<String?>(tipoGeometria),
      'statusLote': serializer.toJson<String>(statusLote),
      'necessitaRevisao': serializer.toJson<bool>(necessitaRevisao),
      'observacoes': serializer.toJson<String?>(observacoes),
      'synced': serializer.toJson<bool>(synced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LotesPreliminare copyWith(
          {String? id,
          String? projetoId,
          String? codigoLote,
          Value<String?> quadra = const Value.absent(),
          Value<double?> areaM2 = const Value.absent(),
          Value<double?> perimetroM = const Value.absent(),
          Value<String?> geometriaGeojson = const Value.absent(),
          Value<String?> origemArquivo = const Value.absent(),
          Value<String?> tipoGeometria = const Value.absent(),
          String? statusLote,
          bool? necessitaRevisao,
          Value<String?> observacoes = const Value.absent(),
          bool? synced,
          DateTime? createdAt}) =>
      LotesPreliminare(
        id: id ?? this.id,
        projetoId: projetoId ?? this.projetoId,
        codigoLote: codigoLote ?? this.codigoLote,
        quadra: quadra.present ? quadra.value : this.quadra,
        areaM2: areaM2.present ? areaM2.value : this.areaM2,
        perimetroM: perimetroM.present ? perimetroM.value : this.perimetroM,
        geometriaGeojson: geometriaGeojson.present
            ? geometriaGeojson.value
            : this.geometriaGeojson,
        origemArquivo:
            origemArquivo.present ? origemArquivo.value : this.origemArquivo,
        tipoGeometria:
            tipoGeometria.present ? tipoGeometria.value : this.tipoGeometria,
        statusLote: statusLote ?? this.statusLote,
        necessitaRevisao: necessitaRevisao ?? this.necessitaRevisao,
        observacoes: observacoes.present ? observacoes.value : this.observacoes,
        synced: synced ?? this.synced,
        createdAt: createdAt ?? this.createdAt,
      );
  LotesPreliminare copyWithCompanion(LotesPreliminaresCompanion data) {
    return LotesPreliminare(
      id: data.id.present ? data.id.value : this.id,
      projetoId: data.projetoId.present ? data.projetoId.value : this.projetoId,
      codigoLote:
          data.codigoLote.present ? data.codigoLote.value : this.codigoLote,
      quadra: data.quadra.present ? data.quadra.value : this.quadra,
      areaM2: data.areaM2.present ? data.areaM2.value : this.areaM2,
      perimetroM:
          data.perimetroM.present ? data.perimetroM.value : this.perimetroM,
      geometriaGeojson: data.geometriaGeojson.present
          ? data.geometriaGeojson.value
          : this.geometriaGeojson,
      origemArquivo: data.origemArquivo.present
          ? data.origemArquivo.value
          : this.origemArquivo,
      tipoGeometria: data.tipoGeometria.present
          ? data.tipoGeometria.value
          : this.tipoGeometria,
      statusLote:
          data.statusLote.present ? data.statusLote.value : this.statusLote,
      necessitaRevisao: data.necessitaRevisao.present
          ? data.necessitaRevisao.value
          : this.necessitaRevisao,
      observacoes:
          data.observacoes.present ? data.observacoes.value : this.observacoes,
      synced: data.synced.present ? data.synced.value : this.synced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LotesPreliminare(')
          ..write('id: $id, ')
          ..write('projetoId: $projetoId, ')
          ..write('codigoLote: $codigoLote, ')
          ..write('quadra: $quadra, ')
          ..write('areaM2: $areaM2, ')
          ..write('perimetroM: $perimetroM, ')
          ..write('geometriaGeojson: $geometriaGeojson, ')
          ..write('origemArquivo: $origemArquivo, ')
          ..write('tipoGeometria: $tipoGeometria, ')
          ..write('statusLote: $statusLote, ')
          ..write('necessitaRevisao: $necessitaRevisao, ')
          ..write('observacoes: $observacoes, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      projetoId,
      codigoLote,
      quadra,
      areaM2,
      perimetroM,
      geometriaGeojson,
      origemArquivo,
      tipoGeometria,
      statusLote,
      necessitaRevisao,
      observacoes,
      synced,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LotesPreliminare &&
          other.id == this.id &&
          other.projetoId == this.projetoId &&
          other.codigoLote == this.codigoLote &&
          other.quadra == this.quadra &&
          other.areaM2 == this.areaM2 &&
          other.perimetroM == this.perimetroM &&
          other.geometriaGeojson == this.geometriaGeojson &&
          other.origemArquivo == this.origemArquivo &&
          other.tipoGeometria == this.tipoGeometria &&
          other.statusLote == this.statusLote &&
          other.necessitaRevisao == this.necessitaRevisao &&
          other.observacoes == this.observacoes &&
          other.synced == this.synced &&
          other.createdAt == this.createdAt);
}

class LotesPreliminaresCompanion extends UpdateCompanion<LotesPreliminare> {
  final Value<String> id;
  final Value<String> projetoId;
  final Value<String> codigoLote;
  final Value<String?> quadra;
  final Value<double?> areaM2;
  final Value<double?> perimetroM;
  final Value<String?> geometriaGeojson;
  final Value<String?> origemArquivo;
  final Value<String?> tipoGeometria;
  final Value<String> statusLote;
  final Value<bool> necessitaRevisao;
  final Value<String?> observacoes;
  final Value<bool> synced;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const LotesPreliminaresCompanion({
    this.id = const Value.absent(),
    this.projetoId = const Value.absent(),
    this.codigoLote = const Value.absent(),
    this.quadra = const Value.absent(),
    this.areaM2 = const Value.absent(),
    this.perimetroM = const Value.absent(),
    this.geometriaGeojson = const Value.absent(),
    this.origemArquivo = const Value.absent(),
    this.tipoGeometria = const Value.absent(),
    this.statusLote = const Value.absent(),
    this.necessitaRevisao = const Value.absent(),
    this.observacoes = const Value.absent(),
    this.synced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LotesPreliminaresCompanion.insert({
    required String id,
    required String projetoId,
    required String codigoLote,
    this.quadra = const Value.absent(),
    this.areaM2 = const Value.absent(),
    this.perimetroM = const Value.absent(),
    this.geometriaGeojson = const Value.absent(),
    this.origemArquivo = const Value.absent(),
    this.tipoGeometria = const Value.absent(),
    this.statusLote = const Value.absent(),
    this.necessitaRevisao = const Value.absent(),
    this.observacoes = const Value.absent(),
    this.synced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        projetoId = Value(projetoId),
        codigoLote = Value(codigoLote);
  static Insertable<LotesPreliminare> custom({
    Expression<String>? id,
    Expression<String>? projetoId,
    Expression<String>? codigoLote,
    Expression<String>? quadra,
    Expression<double>? areaM2,
    Expression<double>? perimetroM,
    Expression<String>? geometriaGeojson,
    Expression<String>? origemArquivo,
    Expression<String>? tipoGeometria,
    Expression<String>? statusLote,
    Expression<bool>? necessitaRevisao,
    Expression<String>? observacoes,
    Expression<bool>? synced,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projetoId != null) 'projeto_id': projetoId,
      if (codigoLote != null) 'codigo_lote': codigoLote,
      if (quadra != null) 'quadra': quadra,
      if (areaM2 != null) 'area_m2': areaM2,
      if (perimetroM != null) 'perimetro_m': perimetroM,
      if (geometriaGeojson != null) 'geometria_geojson': geometriaGeojson,
      if (origemArquivo != null) 'origem_arquivo': origemArquivo,
      if (tipoGeometria != null) 'tipo_geometria': tipoGeometria,
      if (statusLote != null) 'status_lote': statusLote,
      if (necessitaRevisao != null) 'necessita_revisao': necessitaRevisao,
      if (observacoes != null) 'observacoes': observacoes,
      if (synced != null) 'synced': synced,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LotesPreliminaresCompanion copyWith(
      {Value<String>? id,
      Value<String>? projetoId,
      Value<String>? codigoLote,
      Value<String?>? quadra,
      Value<double?>? areaM2,
      Value<double?>? perimetroM,
      Value<String?>? geometriaGeojson,
      Value<String?>? origemArquivo,
      Value<String?>? tipoGeometria,
      Value<String>? statusLote,
      Value<bool>? necessitaRevisao,
      Value<String?>? observacoes,
      Value<bool>? synced,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return LotesPreliminaresCompanion(
      id: id ?? this.id,
      projetoId: projetoId ?? this.projetoId,
      codigoLote: codigoLote ?? this.codigoLote,
      quadra: quadra ?? this.quadra,
      areaM2: areaM2 ?? this.areaM2,
      perimetroM: perimetroM ?? this.perimetroM,
      geometriaGeojson: geometriaGeojson ?? this.geometriaGeojson,
      origemArquivo: origemArquivo ?? this.origemArquivo,
      tipoGeometria: tipoGeometria ?? this.tipoGeometria,
      statusLote: statusLote ?? this.statusLote,
      necessitaRevisao: necessitaRevisao ?? this.necessitaRevisao,
      observacoes: observacoes ?? this.observacoes,
      synced: synced ?? this.synced,
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
    if (projetoId.present) {
      map['projeto_id'] = Variable<String>(projetoId.value);
    }
    if (codigoLote.present) {
      map['codigo_lote'] = Variable<String>(codigoLote.value);
    }
    if (quadra.present) {
      map['quadra'] = Variable<String>(quadra.value);
    }
    if (areaM2.present) {
      map['area_m2'] = Variable<double>(areaM2.value);
    }
    if (perimetroM.present) {
      map['perimetro_m'] = Variable<double>(perimetroM.value);
    }
    if (geometriaGeojson.present) {
      map['geometria_geojson'] = Variable<String>(geometriaGeojson.value);
    }
    if (origemArquivo.present) {
      map['origem_arquivo'] = Variable<String>(origemArquivo.value);
    }
    if (tipoGeometria.present) {
      map['tipo_geometria'] = Variable<String>(tipoGeometria.value);
    }
    if (statusLote.present) {
      map['status_lote'] = Variable<String>(statusLote.value);
    }
    if (necessitaRevisao.present) {
      map['necessita_revisao'] = Variable<bool>(necessitaRevisao.value);
    }
    if (observacoes.present) {
      map['observacoes'] = Variable<String>(observacoes.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
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
    return (StringBuffer('LotesPreliminaresCompanion(')
          ..write('id: $id, ')
          ..write('projetoId: $projetoId, ')
          ..write('codigoLote: $codigoLote, ')
          ..write('quadra: $quadra, ')
          ..write('areaM2: $areaM2, ')
          ..write('perimetroM: $perimetroM, ')
          ..write('geometriaGeojson: $geometriaGeojson, ')
          ..write('origemArquivo: $origemArquivo, ')
          ..write('tipoGeometria: $tipoGeometria, ')
          ..write('statusLote: $statusLote, ')
          ..write('necessitaRevisao: $necessitaRevisao, ')
          ..write('observacoes: $observacoes, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LotesVetorizadosCidadaoTable extends LotesVetorizadosCidadao
    with TableInfo<$LotesVetorizadosCidadaoTable, LotesVetorizadosCidadaoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LotesVetorizadosCidadaoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _projetoIdMeta =
      const VerificationMeta('projetoId');
  @override
  late final GeneratedColumn<String> projetoId = GeneratedColumn<String>(
      'projeto_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _selagemIdMeta =
      const VerificationMeta('selagemId');
  @override
  late final GeneratedColumn<String> selagemId = GeneratedColumn<String>(
      'selagem_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cadastroSocialIdMeta =
      const VerificationMeta('cadastroSocialId');
  @override
  late final GeneratedColumn<String> cadastroSocialId = GeneratedColumn<String>(
      'cadastro_social_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _codigoSeloMeta =
      const VerificationMeta('codigoSelo');
  @override
  late final GeneratedColumn<String> codigoSelo = GeneratedColumn<String>(
      'codigo_selo', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _codigoLoteMeta =
      const VerificationMeta('codigoLote');
  @override
  late final GeneratedColumn<String> codigoLote = GeneratedColumn<String>(
      'codigo_lote', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _origemMeta = const VerificationMeta('origem');
  @override
  late final GeneratedColumn<String> origem = GeneratedColumn<String>(
      'origem', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('cidadao_assistido'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('rascunho'));
  static const VerificationMeta _geometriaGeojsonMeta =
      const VerificationMeta('geometriaGeojson');
  @override
  late final GeneratedColumn<String> geometriaGeojson = GeneratedColumn<String>(
      'geometria_geojson', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _areaM2Meta = const VerificationMeta('areaM2');
  @override
  late final GeneratedColumn<double> areaM2 = GeneratedColumn<double>(
      'area_m2', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _perimetroMMeta =
      const VerificationMeta('perimetroM');
  @override
  late final GeneratedColumn<double> perimetroM = GeneratedColumn<double>(
      'perimetro_m', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _observacoesMeta =
      const VerificationMeta('observacoes');
  @override
  late final GeneratedColumn<String> observacoes = GeneratedColumn<String>(
      'observacoes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _printPathMeta =
      const VerificationMeta('printPath');
  @override
  late final GeneratedColumn<String> printPath = GeneratedColumn<String>(
      'print_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        projetoId,
        selagemId,
        cadastroSocialId,
        codigoSelo,
        codigoLote,
        origem,
        status,
        geometriaGeojson,
        areaM2,
        perimetroM,
        observacoes,
        printPath,
        synced,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lotes_vetorizados_cidadao';
  @override
  VerificationContext validateIntegrity(
      Insertable<LotesVetorizadosCidadaoData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('projeto_id')) {
      context.handle(_projetoIdMeta,
          projetoId.isAcceptableOrUnknown(data['projeto_id']!, _projetoIdMeta));
    }
    if (data.containsKey('selagem_id')) {
      context.handle(_selagemIdMeta,
          selagemId.isAcceptableOrUnknown(data['selagem_id']!, _selagemIdMeta));
    }
    if (data.containsKey('cadastro_social_id')) {
      context.handle(
          _cadastroSocialIdMeta,
          cadastroSocialId.isAcceptableOrUnknown(
              data['cadastro_social_id']!, _cadastroSocialIdMeta));
    }
    if (data.containsKey('codigo_selo')) {
      context.handle(
          _codigoSeloMeta,
          codigoSelo.isAcceptableOrUnknown(
              data['codigo_selo']!, _codigoSeloMeta));
    }
    if (data.containsKey('codigo_lote')) {
      context.handle(
          _codigoLoteMeta,
          codigoLote.isAcceptableOrUnknown(
              data['codigo_lote']!, _codigoLoteMeta));
    }
    if (data.containsKey('origem')) {
      context.handle(_origemMeta,
          origem.isAcceptableOrUnknown(data['origem']!, _origemMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('geometria_geojson')) {
      context.handle(
          _geometriaGeojsonMeta,
          geometriaGeojson.isAcceptableOrUnknown(
              data['geometria_geojson']!, _geometriaGeojsonMeta));
    } else if (isInserting) {
      context.missing(_geometriaGeojsonMeta);
    }
    if (data.containsKey('area_m2')) {
      context.handle(_areaM2Meta,
          areaM2.isAcceptableOrUnknown(data['area_m2']!, _areaM2Meta));
    }
    if (data.containsKey('perimetro_m')) {
      context.handle(
          _perimetroMMeta,
          perimetroM.isAcceptableOrUnknown(
              data['perimetro_m']!, _perimetroMMeta));
    }
    if (data.containsKey('observacoes')) {
      context.handle(
          _observacoesMeta,
          observacoes.isAcceptableOrUnknown(
              data['observacoes']!, _observacoesMeta));
    }
    if (data.containsKey('print_path')) {
      context.handle(_printPathMeta,
          printPath.isAcceptableOrUnknown(data['print_path']!, _printPathMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LotesVetorizadosCidadaoData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LotesVetorizadosCidadaoData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      projetoId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}projeto_id']),
      selagemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}selagem_id']),
      cadastroSocialId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}cadastro_social_id']),
      codigoSelo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}codigo_selo']),
      codigoLote: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}codigo_lote']),
      origem: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}origem'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      geometriaGeojson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}geometria_geojson'])!,
      areaM2: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}area_m2']),
      perimetroM: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}perimetro_m']),
      observacoes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}observacoes']),
      printPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}print_path']),
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $LotesVetorizadosCidadaoTable createAlias(String alias) {
    return $LotesVetorizadosCidadaoTable(attachedDatabase, alias);
  }
}

class LotesVetorizadosCidadaoData extends DataClass
    implements Insertable<LotesVetorizadosCidadaoData> {
  final String id;
  final String? projetoId;
  final String? selagemId;
  final String? cadastroSocialId;
  final String? codigoSelo;
  final String? codigoLote;
  final String origem;
  final String status;
  final String geometriaGeojson;
  final double? areaM2;
  final double? perimetroM;
  final String? observacoes;
  final String? printPath;
  final bool synced;
  final DateTime createdAt;
  final DateTime updatedAt;
  const LotesVetorizadosCidadaoData(
      {required this.id,
      this.projetoId,
      this.selagemId,
      this.cadastroSocialId,
      this.codigoSelo,
      this.codigoLote,
      required this.origem,
      required this.status,
      required this.geometriaGeojson,
      this.areaM2,
      this.perimetroM,
      this.observacoes,
      this.printPath,
      required this.synced,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || projetoId != null) {
      map['projeto_id'] = Variable<String>(projetoId);
    }
    if (!nullToAbsent || selagemId != null) {
      map['selagem_id'] = Variable<String>(selagemId);
    }
    if (!nullToAbsent || cadastroSocialId != null) {
      map['cadastro_social_id'] = Variable<String>(cadastroSocialId);
    }
    if (!nullToAbsent || codigoSelo != null) {
      map['codigo_selo'] = Variable<String>(codigoSelo);
    }
    if (!nullToAbsent || codigoLote != null) {
      map['codigo_lote'] = Variable<String>(codigoLote);
    }
    map['origem'] = Variable<String>(origem);
    map['status'] = Variable<String>(status);
    map['geometria_geojson'] = Variable<String>(geometriaGeojson);
    if (!nullToAbsent || areaM2 != null) {
      map['area_m2'] = Variable<double>(areaM2);
    }
    if (!nullToAbsent || perimetroM != null) {
      map['perimetro_m'] = Variable<double>(perimetroM);
    }
    if (!nullToAbsent || observacoes != null) {
      map['observacoes'] = Variable<String>(observacoes);
    }
    if (!nullToAbsent || printPath != null) {
      map['print_path'] = Variable<String>(printPath);
    }
    map['synced'] = Variable<bool>(synced);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LotesVetorizadosCidadaoCompanion toCompanion(bool nullToAbsent) {
    return LotesVetorizadosCidadaoCompanion(
      id: Value(id),
      projetoId: projetoId == null && nullToAbsent
          ? const Value.absent()
          : Value(projetoId),
      selagemId: selagemId == null && nullToAbsent
          ? const Value.absent()
          : Value(selagemId),
      cadastroSocialId: cadastroSocialId == null && nullToAbsent
          ? const Value.absent()
          : Value(cadastroSocialId),
      codigoSelo: codigoSelo == null && nullToAbsent
          ? const Value.absent()
          : Value(codigoSelo),
      codigoLote: codigoLote == null && nullToAbsent
          ? const Value.absent()
          : Value(codigoLote),
      origem: Value(origem),
      status: Value(status),
      geometriaGeojson: Value(geometriaGeojson),
      areaM2:
          areaM2 == null && nullToAbsent ? const Value.absent() : Value(areaM2),
      perimetroM: perimetroM == null && nullToAbsent
          ? const Value.absent()
          : Value(perimetroM),
      observacoes: observacoes == null && nullToAbsent
          ? const Value.absent()
          : Value(observacoes),
      printPath: printPath == null && nullToAbsent
          ? const Value.absent()
          : Value(printPath),
      synced: Value(synced),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LotesVetorizadosCidadaoData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LotesVetorizadosCidadaoData(
      id: serializer.fromJson<String>(json['id']),
      projetoId: serializer.fromJson<String?>(json['projetoId']),
      selagemId: serializer.fromJson<String?>(json['selagemId']),
      cadastroSocialId: serializer.fromJson<String?>(json['cadastroSocialId']),
      codigoSelo: serializer.fromJson<String?>(json['codigoSelo']),
      codigoLote: serializer.fromJson<String?>(json['codigoLote']),
      origem: serializer.fromJson<String>(json['origem']),
      status: serializer.fromJson<String>(json['status']),
      geometriaGeojson: serializer.fromJson<String>(json['geometriaGeojson']),
      areaM2: serializer.fromJson<double?>(json['areaM2']),
      perimetroM: serializer.fromJson<double?>(json['perimetroM']),
      observacoes: serializer.fromJson<String?>(json['observacoes']),
      printPath: serializer.fromJson<String?>(json['printPath']),
      synced: serializer.fromJson<bool>(json['synced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projetoId': serializer.toJson<String?>(projetoId),
      'selagemId': serializer.toJson<String?>(selagemId),
      'cadastroSocialId': serializer.toJson<String?>(cadastroSocialId),
      'codigoSelo': serializer.toJson<String?>(codigoSelo),
      'codigoLote': serializer.toJson<String?>(codigoLote),
      'origem': serializer.toJson<String>(origem),
      'status': serializer.toJson<String>(status),
      'geometriaGeojson': serializer.toJson<String>(geometriaGeojson),
      'areaM2': serializer.toJson<double?>(areaM2),
      'perimetroM': serializer.toJson<double?>(perimetroM),
      'observacoes': serializer.toJson<String?>(observacoes),
      'printPath': serializer.toJson<String?>(printPath),
      'synced': serializer.toJson<bool>(synced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LotesVetorizadosCidadaoData copyWith(
          {String? id,
          Value<String?> projetoId = const Value.absent(),
          Value<String?> selagemId = const Value.absent(),
          Value<String?> cadastroSocialId = const Value.absent(),
          Value<String?> codigoSelo = const Value.absent(),
          Value<String?> codigoLote = const Value.absent(),
          String? origem,
          String? status,
          String? geometriaGeojson,
          Value<double?> areaM2 = const Value.absent(),
          Value<double?> perimetroM = const Value.absent(),
          Value<String?> observacoes = const Value.absent(),
          Value<String?> printPath = const Value.absent(),
          bool? synced,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      LotesVetorizadosCidadaoData(
        id: id ?? this.id,
        projetoId: projetoId.present ? projetoId.value : this.projetoId,
        selagemId: selagemId.present ? selagemId.value : this.selagemId,
        cadastroSocialId: cadastroSocialId.present
            ? cadastroSocialId.value
            : this.cadastroSocialId,
        codigoSelo: codigoSelo.present ? codigoSelo.value : this.codigoSelo,
        codigoLote: codigoLote.present ? codigoLote.value : this.codigoLote,
        origem: origem ?? this.origem,
        status: status ?? this.status,
        geometriaGeojson: geometriaGeojson ?? this.geometriaGeojson,
        areaM2: areaM2.present ? areaM2.value : this.areaM2,
        perimetroM: perimetroM.present ? perimetroM.value : this.perimetroM,
        observacoes: observacoes.present ? observacoes.value : this.observacoes,
        printPath: printPath.present ? printPath.value : this.printPath,
        synced: synced ?? this.synced,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  LotesVetorizadosCidadaoData copyWithCompanion(
      LotesVetorizadosCidadaoCompanion data) {
    return LotesVetorizadosCidadaoData(
      id: data.id.present ? data.id.value : this.id,
      projetoId: data.projetoId.present ? data.projetoId.value : this.projetoId,
      selagemId: data.selagemId.present ? data.selagemId.value : this.selagemId,
      cadastroSocialId: data.cadastroSocialId.present
          ? data.cadastroSocialId.value
          : this.cadastroSocialId,
      codigoSelo:
          data.codigoSelo.present ? data.codigoSelo.value : this.codigoSelo,
      codigoLote:
          data.codigoLote.present ? data.codigoLote.value : this.codigoLote,
      origem: data.origem.present ? data.origem.value : this.origem,
      status: data.status.present ? data.status.value : this.status,
      geometriaGeojson: data.geometriaGeojson.present
          ? data.geometriaGeojson.value
          : this.geometriaGeojson,
      areaM2: data.areaM2.present ? data.areaM2.value : this.areaM2,
      perimetroM:
          data.perimetroM.present ? data.perimetroM.value : this.perimetroM,
      observacoes:
          data.observacoes.present ? data.observacoes.value : this.observacoes,
      printPath: data.printPath.present ? data.printPath.value : this.printPath,
      synced: data.synced.present ? data.synced.value : this.synced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LotesVetorizadosCidadaoData(')
          ..write('id: $id, ')
          ..write('projetoId: $projetoId, ')
          ..write('selagemId: $selagemId, ')
          ..write('cadastroSocialId: $cadastroSocialId, ')
          ..write('codigoSelo: $codigoSelo, ')
          ..write('codigoLote: $codigoLote, ')
          ..write('origem: $origem, ')
          ..write('status: $status, ')
          ..write('geometriaGeojson: $geometriaGeojson, ')
          ..write('areaM2: $areaM2, ')
          ..write('perimetroM: $perimetroM, ')
          ..write('observacoes: $observacoes, ')
          ..write('printPath: $printPath, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      projetoId,
      selagemId,
      cadastroSocialId,
      codigoSelo,
      codigoLote,
      origem,
      status,
      geometriaGeojson,
      areaM2,
      perimetroM,
      observacoes,
      printPath,
      synced,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LotesVetorizadosCidadaoData &&
          other.id == this.id &&
          other.projetoId == this.projetoId &&
          other.selagemId == this.selagemId &&
          other.cadastroSocialId == this.cadastroSocialId &&
          other.codigoSelo == this.codigoSelo &&
          other.codigoLote == this.codigoLote &&
          other.origem == this.origem &&
          other.status == this.status &&
          other.geometriaGeojson == this.geometriaGeojson &&
          other.areaM2 == this.areaM2 &&
          other.perimetroM == this.perimetroM &&
          other.observacoes == this.observacoes &&
          other.printPath == this.printPath &&
          other.synced == this.synced &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LotesVetorizadosCidadaoCompanion
    extends UpdateCompanion<LotesVetorizadosCidadaoData> {
  final Value<String> id;
  final Value<String?> projetoId;
  final Value<String?> selagemId;
  final Value<String?> cadastroSocialId;
  final Value<String?> codigoSelo;
  final Value<String?> codigoLote;
  final Value<String> origem;
  final Value<String> status;
  final Value<String> geometriaGeojson;
  final Value<double?> areaM2;
  final Value<double?> perimetroM;
  final Value<String?> observacoes;
  final Value<String?> printPath;
  final Value<bool> synced;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LotesVetorizadosCidadaoCompanion({
    this.id = const Value.absent(),
    this.projetoId = const Value.absent(),
    this.selagemId = const Value.absent(),
    this.cadastroSocialId = const Value.absent(),
    this.codigoSelo = const Value.absent(),
    this.codigoLote = const Value.absent(),
    this.origem = const Value.absent(),
    this.status = const Value.absent(),
    this.geometriaGeojson = const Value.absent(),
    this.areaM2 = const Value.absent(),
    this.perimetroM = const Value.absent(),
    this.observacoes = const Value.absent(),
    this.printPath = const Value.absent(),
    this.synced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LotesVetorizadosCidadaoCompanion.insert({
    required String id,
    this.projetoId = const Value.absent(),
    this.selagemId = const Value.absent(),
    this.cadastroSocialId = const Value.absent(),
    this.codigoSelo = const Value.absent(),
    this.codigoLote = const Value.absent(),
    this.origem = const Value.absent(),
    this.status = const Value.absent(),
    required String geometriaGeojson,
    this.areaM2 = const Value.absent(),
    this.perimetroM = const Value.absent(),
    this.observacoes = const Value.absent(),
    this.printPath = const Value.absent(),
    this.synced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        geometriaGeojson = Value(geometriaGeojson);
  static Insertable<LotesVetorizadosCidadaoData> custom({
    Expression<String>? id,
    Expression<String>? projetoId,
    Expression<String>? selagemId,
    Expression<String>? cadastroSocialId,
    Expression<String>? codigoSelo,
    Expression<String>? codigoLote,
    Expression<String>? origem,
    Expression<String>? status,
    Expression<String>? geometriaGeojson,
    Expression<double>? areaM2,
    Expression<double>? perimetroM,
    Expression<String>? observacoes,
    Expression<String>? printPath,
    Expression<bool>? synced,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projetoId != null) 'projeto_id': projetoId,
      if (selagemId != null) 'selagem_id': selagemId,
      if (cadastroSocialId != null) 'cadastro_social_id': cadastroSocialId,
      if (codigoSelo != null) 'codigo_selo': codigoSelo,
      if (codigoLote != null) 'codigo_lote': codigoLote,
      if (origem != null) 'origem': origem,
      if (status != null) 'status': status,
      if (geometriaGeojson != null) 'geometria_geojson': geometriaGeojson,
      if (areaM2 != null) 'area_m2': areaM2,
      if (perimetroM != null) 'perimetro_m': perimetroM,
      if (observacoes != null) 'observacoes': observacoes,
      if (printPath != null) 'print_path': printPath,
      if (synced != null) 'synced': synced,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LotesVetorizadosCidadaoCompanion copyWith(
      {Value<String>? id,
      Value<String?>? projetoId,
      Value<String?>? selagemId,
      Value<String?>? cadastroSocialId,
      Value<String?>? codigoSelo,
      Value<String?>? codigoLote,
      Value<String>? origem,
      Value<String>? status,
      Value<String>? geometriaGeojson,
      Value<double?>? areaM2,
      Value<double?>? perimetroM,
      Value<String?>? observacoes,
      Value<String?>? printPath,
      Value<bool>? synced,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return LotesVetorizadosCidadaoCompanion(
      id: id ?? this.id,
      projetoId: projetoId ?? this.projetoId,
      selagemId: selagemId ?? this.selagemId,
      cadastroSocialId: cadastroSocialId ?? this.cadastroSocialId,
      codigoSelo: codigoSelo ?? this.codigoSelo,
      codigoLote: codigoLote ?? this.codigoLote,
      origem: origem ?? this.origem,
      status: status ?? this.status,
      geometriaGeojson: geometriaGeojson ?? this.geometriaGeojson,
      areaM2: areaM2 ?? this.areaM2,
      perimetroM: perimetroM ?? this.perimetroM,
      observacoes: observacoes ?? this.observacoes,
      printPath: printPath ?? this.printPath,
      synced: synced ?? this.synced,
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
    if (projetoId.present) {
      map['projeto_id'] = Variable<String>(projetoId.value);
    }
    if (selagemId.present) {
      map['selagem_id'] = Variable<String>(selagemId.value);
    }
    if (cadastroSocialId.present) {
      map['cadastro_social_id'] = Variable<String>(cadastroSocialId.value);
    }
    if (codigoSelo.present) {
      map['codigo_selo'] = Variable<String>(codigoSelo.value);
    }
    if (codigoLote.present) {
      map['codigo_lote'] = Variable<String>(codigoLote.value);
    }
    if (origem.present) {
      map['origem'] = Variable<String>(origem.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (geometriaGeojson.present) {
      map['geometria_geojson'] = Variable<String>(geometriaGeojson.value);
    }
    if (areaM2.present) {
      map['area_m2'] = Variable<double>(areaM2.value);
    }
    if (perimetroM.present) {
      map['perimetro_m'] = Variable<double>(perimetroM.value);
    }
    if (observacoes.present) {
      map['observacoes'] = Variable<String>(observacoes.value);
    }
    if (printPath.present) {
      map['print_path'] = Variable<String>(printPath.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
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
    return (StringBuffer('LotesVetorizadosCidadaoCompanion(')
          ..write('id: $id, ')
          ..write('projetoId: $projetoId, ')
          ..write('selagemId: $selagemId, ')
          ..write('cadastroSocialId: $cadastroSocialId, ')
          ..write('codigoSelo: $codigoSelo, ')
          ..write('codigoLote: $codigoLote, ')
          ..write('origem: $origem, ')
          ..write('status: $status, ')
          ..write('geometriaGeojson: $geometriaGeojson, ')
          ..write('areaM2: $areaM2, ')
          ..write('perimetroM: $perimetroM, ')
          ..write('observacoes: $observacoes, ')
          ..write('printPath: $printPath, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MobileSealCodeReservationsTable extends MobileSealCodeReservations
    with
        TableInfo<$MobileSealCodeReservationsTable, MobileSealCodeReservation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MobileSealCodeReservationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _projectIdMeta =
      const VerificationMeta('projectId');
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
      'project_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _prefixMeta = const VerificationMeta('prefix');
  @override
  late final GeneratedColumn<String> prefix = GeneratedColumn<String>(
      'prefix', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startNumberMeta =
      const VerificationMeta('startNumber');
  @override
  late final GeneratedColumn<int> startNumber = GeneratedColumn<int>(
      'start_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _endNumberMeta =
      const VerificationMeta('endNumber');
  @override
  late final GeneratedColumn<int> endNumber = GeneratedColumn<int>(
      'end_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nextNumberMeta =
      const VerificationMeta('nextNumber');
  @override
  late final GeneratedColumn<int> nextNumber = GeneratedColumn<int>(
      'next_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
      'active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _expiresAtMeta =
      const VerificationMeta('expiresAt');
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
      'expires_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        projectId,
        deviceId,
        prefix,
        startNumber,
        endNumber,
        nextNumber,
        quantity,
        active,
        expiresAt,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mobile_seal_code_reservations';
  @override
  VerificationContext validateIntegrity(
      Insertable<MobileSealCodeReservation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('prefix')) {
      context.handle(_prefixMeta,
          prefix.isAcceptableOrUnknown(data['prefix']!, _prefixMeta));
    } else if (isInserting) {
      context.missing(_prefixMeta);
    }
    if (data.containsKey('start_number')) {
      context.handle(
          _startNumberMeta,
          startNumber.isAcceptableOrUnknown(
              data['start_number']!, _startNumberMeta));
    } else if (isInserting) {
      context.missing(_startNumberMeta);
    }
    if (data.containsKey('end_number')) {
      context.handle(_endNumberMeta,
          endNumber.isAcceptableOrUnknown(data['end_number']!, _endNumberMeta));
    } else if (isInserting) {
      context.missing(_endNumberMeta);
    }
    if (data.containsKey('next_number')) {
      context.handle(
          _nextNumberMeta,
          nextNumber.isAcceptableOrUnknown(
              data['next_number']!, _nextNumberMeta));
    } else if (isInserting) {
      context.missing(_nextNumberMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('active')) {
      context.handle(_activeMeta,
          active.isAcceptableOrUnknown(data['active']!, _activeMeta));
    }
    if (data.containsKey('expires_at')) {
      context.handle(_expiresAtMeta,
          expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta));
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
  MobileSealCodeReservation map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MobileSealCodeReservation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      projectId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}project_id'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      prefix: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}prefix'])!,
      startNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}start_number'])!,
      endNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}end_number'])!,
      nextNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}next_number'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      active: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}active'])!,
      expiresAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expires_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $MobileSealCodeReservationsTable createAlias(String alias) {
    return $MobileSealCodeReservationsTable(attachedDatabase, alias);
  }
}

class MobileSealCodeReservation extends DataClass
    implements Insertable<MobileSealCodeReservation> {
  final String id;
  final String projectId;
  final String deviceId;
  final String prefix;
  final int startNumber;
  final int endNumber;
  final int nextNumber;
  final int quantity;
  final bool active;
  final DateTime? expiresAt;
  final DateTime createdAt;
  const MobileSealCodeReservation(
      {required this.id,
      required this.projectId,
      required this.deviceId,
      required this.prefix,
      required this.startNumber,
      required this.endNumber,
      required this.nextNumber,
      required this.quantity,
      required this.active,
      this.expiresAt,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['device_id'] = Variable<String>(deviceId);
    map['prefix'] = Variable<String>(prefix);
    map['start_number'] = Variable<int>(startNumber);
    map['end_number'] = Variable<int>(endNumber);
    map['next_number'] = Variable<int>(nextNumber);
    map['quantity'] = Variable<int>(quantity);
    map['active'] = Variable<bool>(active);
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MobileSealCodeReservationsCompanion toCompanion(bool nullToAbsent) {
    return MobileSealCodeReservationsCompanion(
      id: Value(id),
      projectId: Value(projectId),
      deviceId: Value(deviceId),
      prefix: Value(prefix),
      startNumber: Value(startNumber),
      endNumber: Value(endNumber),
      nextNumber: Value(nextNumber),
      quantity: Value(quantity),
      active: Value(active),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
      createdAt: Value(createdAt),
    );
  }

  factory MobileSealCodeReservation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MobileSealCodeReservation(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      prefix: serializer.fromJson<String>(json['prefix']),
      startNumber: serializer.fromJson<int>(json['startNumber']),
      endNumber: serializer.fromJson<int>(json['endNumber']),
      nextNumber: serializer.fromJson<int>(json['nextNumber']),
      quantity: serializer.fromJson<int>(json['quantity']),
      active: serializer.fromJson<bool>(json['active']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'deviceId': serializer.toJson<String>(deviceId),
      'prefix': serializer.toJson<String>(prefix),
      'startNumber': serializer.toJson<int>(startNumber),
      'endNumber': serializer.toJson<int>(endNumber),
      'nextNumber': serializer.toJson<int>(nextNumber),
      'quantity': serializer.toJson<int>(quantity),
      'active': serializer.toJson<bool>(active),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MobileSealCodeReservation copyWith(
          {String? id,
          String? projectId,
          String? deviceId,
          String? prefix,
          int? startNumber,
          int? endNumber,
          int? nextNumber,
          int? quantity,
          bool? active,
          Value<DateTime?> expiresAt = const Value.absent(),
          DateTime? createdAt}) =>
      MobileSealCodeReservation(
        id: id ?? this.id,
        projectId: projectId ?? this.projectId,
        deviceId: deviceId ?? this.deviceId,
        prefix: prefix ?? this.prefix,
        startNumber: startNumber ?? this.startNumber,
        endNumber: endNumber ?? this.endNumber,
        nextNumber: nextNumber ?? this.nextNumber,
        quantity: quantity ?? this.quantity,
        active: active ?? this.active,
        expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
        createdAt: createdAt ?? this.createdAt,
      );
  MobileSealCodeReservation copyWithCompanion(
      MobileSealCodeReservationsCompanion data) {
    return MobileSealCodeReservation(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      prefix: data.prefix.present ? data.prefix.value : this.prefix,
      startNumber:
          data.startNumber.present ? data.startNumber.value : this.startNumber,
      endNumber: data.endNumber.present ? data.endNumber.value : this.endNumber,
      nextNumber:
          data.nextNumber.present ? data.nextNumber.value : this.nextNumber,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      active: data.active.present ? data.active.value : this.active,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MobileSealCodeReservation(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('deviceId: $deviceId, ')
          ..write('prefix: $prefix, ')
          ..write('startNumber: $startNumber, ')
          ..write('endNumber: $endNumber, ')
          ..write('nextNumber: $nextNumber, ')
          ..write('quantity: $quantity, ')
          ..write('active: $active, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, projectId, deviceId, prefix, startNumber,
      endNumber, nextNumber, quantity, active, expiresAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MobileSealCodeReservation &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.deviceId == this.deviceId &&
          other.prefix == this.prefix &&
          other.startNumber == this.startNumber &&
          other.endNumber == this.endNumber &&
          other.nextNumber == this.nextNumber &&
          other.quantity == this.quantity &&
          other.active == this.active &&
          other.expiresAt == this.expiresAt &&
          other.createdAt == this.createdAt);
}

class MobileSealCodeReservationsCompanion
    extends UpdateCompanion<MobileSealCodeReservation> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String> deviceId;
  final Value<String> prefix;
  final Value<int> startNumber;
  final Value<int> endNumber;
  final Value<int> nextNumber;
  final Value<int> quantity;
  final Value<bool> active;
  final Value<DateTime?> expiresAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const MobileSealCodeReservationsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.prefix = const Value.absent(),
    this.startNumber = const Value.absent(),
    this.endNumber = const Value.absent(),
    this.nextNumber = const Value.absent(),
    this.quantity = const Value.absent(),
    this.active = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MobileSealCodeReservationsCompanion.insert({
    required String id,
    required String projectId,
    required String deviceId,
    required String prefix,
    required int startNumber,
    required int endNumber,
    required int nextNumber,
    required int quantity,
    this.active = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        projectId = Value(projectId),
        deviceId = Value(deviceId),
        prefix = Value(prefix),
        startNumber = Value(startNumber),
        endNumber = Value(endNumber),
        nextNumber = Value(nextNumber),
        quantity = Value(quantity);
  static Insertable<MobileSealCodeReservation> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? deviceId,
    Expression<String>? prefix,
    Expression<int>? startNumber,
    Expression<int>? endNumber,
    Expression<int>? nextNumber,
    Expression<int>? quantity,
    Expression<bool>? active,
    Expression<DateTime>? expiresAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (deviceId != null) 'device_id': deviceId,
      if (prefix != null) 'prefix': prefix,
      if (startNumber != null) 'start_number': startNumber,
      if (endNumber != null) 'end_number': endNumber,
      if (nextNumber != null) 'next_number': nextNumber,
      if (quantity != null) 'quantity': quantity,
      if (active != null) 'active': active,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MobileSealCodeReservationsCompanion copyWith(
      {Value<String>? id,
      Value<String>? projectId,
      Value<String>? deviceId,
      Value<String>? prefix,
      Value<int>? startNumber,
      Value<int>? endNumber,
      Value<int>? nextNumber,
      Value<int>? quantity,
      Value<bool>? active,
      Value<DateTime?>? expiresAt,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return MobileSealCodeReservationsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      deviceId: deviceId ?? this.deviceId,
      prefix: prefix ?? this.prefix,
      startNumber: startNumber ?? this.startNumber,
      endNumber: endNumber ?? this.endNumber,
      nextNumber: nextNumber ?? this.nextNumber,
      quantity: quantity ?? this.quantity,
      active: active ?? this.active,
      expiresAt: expiresAt ?? this.expiresAt,
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
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (prefix.present) {
      map['prefix'] = Variable<String>(prefix.value);
    }
    if (startNumber.present) {
      map['start_number'] = Variable<int>(startNumber.value);
    }
    if (endNumber.present) {
      map['end_number'] = Variable<int>(endNumber.value);
    }
    if (nextNumber.present) {
      map['next_number'] = Variable<int>(nextNumber.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
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
    return (StringBuffer('MobileSealCodeReservationsCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('deviceId: $deviceId, ')
          ..write('prefix: $prefix, ')
          ..write('startNumber: $startNumber, ')
          ..write('endNumber: $endNumber, ')
          ..write('nextNumber: $nextNumber, ')
          ..write('quantity: $quantity, ')
          ..write('active: $active, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _operationMeta =
      const VerificationMeta('operation');
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
      'operation', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('upsert'));
  static const VerificationMeta _projectIdMeta =
      const VerificationMeta('projectId');
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
      'project_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadJsonMeta =
      const VerificationMeta('payloadJson');
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
      'payload_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _attemptsMeta =
      const VerificationMeta('attempts');
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
      'attempts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastErrorMeta =
      const VerificationMeta('lastError');
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
      'last_error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nextAttemptAtMeta =
      const VerificationMeta('nextAttemptAt');
  @override
  late final GeneratedColumn<DateTime> nextAttemptAt =
      GeneratedColumn<DateTime>('next_attempt_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        entityType,
        entityId,
        operation,
        projectId,
        payloadJson,
        status,
        attempts,
        lastError,
        nextAttemptAt,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(Insertable<SyncQueueData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(_operationMeta,
          operation.isAcceptableOrUnknown(data['operation']!, _operationMeta));
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
          _payloadJsonMeta,
          payloadJson.isAcceptableOrUnknown(
              data['payload_json']!, _payloadJsonMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('attempts')) {
      context.handle(_attemptsMeta,
          attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta));
    }
    if (data.containsKey('last_error')) {
      context.handle(_lastErrorMeta,
          lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta));
    }
    if (data.containsKey('next_attempt_at')) {
      context.handle(
          _nextAttemptAtMeta,
          nextAttemptAt.isAcceptableOrUnknown(
              data['next_attempt_at']!, _nextAttemptAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      operation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operation'])!,
      projectId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}project_id'])!,
      payloadJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload_json']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      attempts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attempts'])!,
      lastError: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_error']),
      nextAttemptAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}next_attempt_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final String id;
  final String entityType;
  final String entityId;
  final String operation;
  final String projectId;
  final String? payloadJson;
  final String status;
  final int attempts;
  final String? lastError;
  final DateTime? nextAttemptAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SyncQueueData(
      {required this.id,
      required this.entityType,
      required this.entityId,
      required this.operation,
      required this.projectId,
      this.payloadJson,
      required this.status,
      required this.attempts,
      this.lastError,
      this.nextAttemptAt,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['operation'] = Variable<String>(operation);
    map['project_id'] = Variable<String>(projectId);
    if (!nullToAbsent || payloadJson != null) {
      map['payload_json'] = Variable<String>(payloadJson);
    }
    map['status'] = Variable<String>(status);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    if (!nullToAbsent || nextAttemptAt != null) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      operation: Value(operation),
      projectId: Value(projectId),
      payloadJson: payloadJson == null && nullToAbsent
          ? const Value.absent()
          : Value(payloadJson),
      status: Value(status),
      attempts: Value(attempts),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      nextAttemptAt: nextAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextAttemptAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SyncQueueData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      operation: serializer.fromJson<String>(json['operation']),
      projectId: serializer.fromJson<String>(json['projectId']),
      payloadJson: serializer.fromJson<String?>(json['payloadJson']),
      status: serializer.fromJson<String>(json['status']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      nextAttemptAt: serializer.fromJson<DateTime?>(json['nextAttemptAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'operation': serializer.toJson<String>(operation),
      'projectId': serializer.toJson<String>(projectId),
      'payloadJson': serializer.toJson<String?>(payloadJson),
      'status': serializer.toJson<String>(status),
      'attempts': serializer.toJson<int>(attempts),
      'lastError': serializer.toJson<String?>(lastError),
      'nextAttemptAt': serializer.toJson<DateTime?>(nextAttemptAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SyncQueueData copyWith(
          {String? id,
          String? entityType,
          String? entityId,
          String? operation,
          String? projectId,
          Value<String?> payloadJson = const Value.absent(),
          String? status,
          int? attempts,
          Value<String?> lastError = const Value.absent(),
          Value<DateTime?> nextAttemptAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      SyncQueueData(
        id: id ?? this.id,
        entityType: entityType ?? this.entityType,
        entityId: entityId ?? this.entityId,
        operation: operation ?? this.operation,
        projectId: projectId ?? this.projectId,
        payloadJson: payloadJson.present ? payloadJson.value : this.payloadJson,
        status: status ?? this.status,
        attempts: attempts ?? this.attempts,
        lastError: lastError.present ? lastError.value : this.lastError,
        nextAttemptAt:
            nextAttemptAt.present ? nextAttemptAt.value : this.nextAttemptAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operation: data.operation.present ? data.operation.value : this.operation,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      payloadJson:
          data.payloadJson.present ? data.payloadJson.value : this.payloadJson,
      status: data.status.present ? data.status.value : this.status,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      nextAttemptAt: data.nextAttemptAt.present
          ? data.nextAttemptAt.value
          : this.nextAttemptAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('projectId: $projectId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      entityType,
      entityId,
      operation,
      projectId,
      payloadJson,
      status,
      attempts,
      lastError,
      nextAttemptAt,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.operation == this.operation &&
          other.projectId == this.projectId &&
          other.payloadJson == this.payloadJson &&
          other.status == this.status &&
          other.attempts == this.attempts &&
          other.lastError == this.lastError &&
          other.nextAttemptAt == this.nextAttemptAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<String> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> operation;
  final Value<String> projectId;
  final Value<String?> payloadJson;
  final Value<String> status;
  final Value<int> attempts;
  final Value<String?> lastError;
  final Value<DateTime?> nextAttemptAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operation = const Value.absent(),
    this.projectId = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.status = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    required String id,
    required String entityType,
    required String entityId,
    this.operation = const Value.absent(),
    required String projectId,
    this.payloadJson = const Value.absent(),
    this.status = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        entityType = Value(entityType),
        entityId = Value(entityId),
        projectId = Value(projectId);
  static Insertable<SyncQueueData> custom({
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? operation,
    Expression<String>? projectId,
    Expression<String>? payloadJson,
    Expression<String>? status,
    Expression<int>? attempts,
    Expression<String>? lastError,
    Expression<DateTime>? nextAttemptAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (operation != null) 'operation': operation,
      if (projectId != null) 'project_id': projectId,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (status != null) 'status': status,
      if (attempts != null) 'attempts': attempts,
      if (lastError != null) 'last_error': lastError,
      if (nextAttemptAt != null) 'next_attempt_at': nextAttemptAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueCompanion copyWith(
      {Value<String>? id,
      Value<String>? entityType,
      Value<String>? entityId,
      Value<String>? operation,
      Value<String>? projectId,
      Value<String?>? payloadJson,
      Value<String>? status,
      Value<int>? attempts,
      Value<String?>? lastError,
      Value<DateTime?>? nextAttemptAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      projectId: projectId ?? this.projectId,
      payloadJson: payloadJson ?? this.payloadJson,
      status: status ?? this.status,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
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
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (nextAttemptAt.present) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt.value);
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
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('projectId: $projectId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProjetosTable projetos = $ProjetosTable(this);
  late final $LotesTable lotes = $LotesTable(this);
  late final $BeneficiariosTable beneficiarios = $BeneficiariosTable(this);
  late final $SelagensTable selagens = $SelagensTable(this);
  late final $CadastrosFisicosTable cadastrosFisicos =
      $CadastrosFisicosTable(this);
  late final $CadastrosSociaisTable cadastrosSociais =
      $CadastrosSociaisTable(this);
  late final $DocumentosReurbTable documentosReurb =
      $DocumentosReurbTable(this);
  late final $LotesPreliminaresTable lotesPreliminares =
      $LotesPreliminaresTable(this);
  late final $LotesVetorizadosCidadaoTable lotesVetorizadosCidadao =
      $LotesVetorizadosCidadaoTable(this);
  late final $MobileSealCodeReservationsTable mobileSealCodeReservations =
      $MobileSealCodeReservationsTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        projetos,
        lotes,
        beneficiarios,
        selagens,
        cadastrosFisicos,
        cadastrosSociais,
        documentosReurb,
        lotesPreliminares,
        lotesVetorizadosCidadao,
        mobileSealCodeReservations,
        syncQueue
      ];
}

typedef $$ProjetosTableCreateCompanionBuilder = ProjetosCompanion Function({
  required String id,
  required String nome,
  required String municipio,
  Value<String> estado,
  required String bairro,
  Value<String?> modalidadeReurb,
  Value<double?> areaHa,
  Value<int?> lotesEstimados,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$ProjetosTableUpdateCompanionBuilder = ProjetosCompanion Function({
  Value<String> id,
  Value<String> nome,
  Value<String> municipio,
  Value<String> estado,
  Value<String> bairro,
  Value<String?> modalidadeReurb,
  Value<double?> areaHa,
  Value<int?> lotesEstimados,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$ProjetosTableFilterComposer
    extends Composer<_$AppDatabase, $ProjetosTable> {
  $$ProjetosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get municipio => $composableBuilder(
      column: $table.municipio, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get estado => $composableBuilder(
      column: $table.estado, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bairro => $composableBuilder(
      column: $table.bairro, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get modalidadeReurb => $composableBuilder(
      column: $table.modalidadeReurb,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get areaHa => $composableBuilder(
      column: $table.areaHa, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lotesEstimados => $composableBuilder(
      column: $table.lotesEstimados,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ProjetosTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjetosTable> {
  $$ProjetosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get municipio => $composableBuilder(
      column: $table.municipio, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get estado => $composableBuilder(
      column: $table.estado, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bairro => $composableBuilder(
      column: $table.bairro, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get modalidadeReurb => $composableBuilder(
      column: $table.modalidadeReurb,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get areaHa => $composableBuilder(
      column: $table.areaHa, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lotesEstimados => $composableBuilder(
      column: $table.lotesEstimados,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ProjetosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjetosTable> {
  $$ProjetosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get municipio =>
      $composableBuilder(column: $table.municipio, builder: (column) => column);

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<String> get bairro =>
      $composableBuilder(column: $table.bairro, builder: (column) => column);

  GeneratedColumn<String> get modalidadeReurb => $composableBuilder(
      column: $table.modalidadeReurb, builder: (column) => column);

  GeneratedColumn<double> get areaHa =>
      $composableBuilder(column: $table.areaHa, builder: (column) => column);

  GeneratedColumn<int> get lotesEstimados => $composableBuilder(
      column: $table.lotesEstimados, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ProjetosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProjetosTable,
    Projeto,
    $$ProjetosTableFilterComposer,
    $$ProjetosTableOrderingComposer,
    $$ProjetosTableAnnotationComposer,
    $$ProjetosTableCreateCompanionBuilder,
    $$ProjetosTableUpdateCompanionBuilder,
    (Projeto, BaseReferences<_$AppDatabase, $ProjetosTable, Projeto>),
    Projeto,
    PrefetchHooks Function()> {
  $$ProjetosTableTableManager(_$AppDatabase db, $ProjetosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjetosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjetosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjetosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<String> municipio = const Value.absent(),
            Value<String> estado = const Value.absent(),
            Value<String> bairro = const Value.absent(),
            Value<String?> modalidadeReurb = const Value.absent(),
            Value<double?> areaHa = const Value.absent(),
            Value<int?> lotesEstimados = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProjetosCompanion(
            id: id,
            nome: nome,
            municipio: municipio,
            estado: estado,
            bairro: bairro,
            modalidadeReurb: modalidadeReurb,
            areaHa: areaHa,
            lotesEstimados: lotesEstimados,
            status: status,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String nome,
            required String municipio,
            Value<String> estado = const Value.absent(),
            required String bairro,
            Value<String?> modalidadeReurb = const Value.absent(),
            Value<double?> areaHa = const Value.absent(),
            Value<int?> lotesEstimados = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProjetosCompanion.insert(
            id: id,
            nome: nome,
            municipio: municipio,
            estado: estado,
            bairro: bairro,
            modalidadeReurb: modalidadeReurb,
            areaHa: areaHa,
            lotesEstimados: lotesEstimados,
            status: status,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProjetosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProjetosTable,
    Projeto,
    $$ProjetosTableFilterComposer,
    $$ProjetosTableOrderingComposer,
    $$ProjetosTableAnnotationComposer,
    $$ProjetosTableCreateCompanionBuilder,
    $$ProjetosTableUpdateCompanionBuilder,
    (Projeto, BaseReferences<_$AppDatabase, $ProjetosTable, Projeto>),
    Projeto,
    PrefetchHooks Function()>;
typedef $$LotesTableCreateCompanionBuilder = LotesCompanion Function({
  required String id,
  required String projetoId,
  required String codigo,
  Value<String?> quadra,
  Value<double?> areaM2,
  Value<String> status,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$LotesTableUpdateCompanionBuilder = LotesCompanion Function({
  Value<String> id,
  Value<String> projetoId,
  Value<String> codigo,
  Value<String?> quadra,
  Value<double?> areaM2,
  Value<String> status,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$LotesTableFilterComposer extends Composer<_$AppDatabase, $LotesTable> {
  $$LotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get projetoId => $composableBuilder(
      column: $table.projetoId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get codigo => $composableBuilder(
      column: $table.codigo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get quadra => $composableBuilder(
      column: $table.quadra, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get areaM2 => $composableBuilder(
      column: $table.areaM2, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$LotesTableOrderingComposer
    extends Composer<_$AppDatabase, $LotesTable> {
  $$LotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get projetoId => $composableBuilder(
      column: $table.projetoId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get codigo => $composableBuilder(
      column: $table.codigo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get quadra => $composableBuilder(
      column: $table.quadra, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get areaM2 => $composableBuilder(
      column: $table.areaM2, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$LotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LotesTable> {
  $$LotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get projetoId =>
      $composableBuilder(column: $table.projetoId, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get quadra =>
      $composableBuilder(column: $table.quadra, builder: (column) => column);

  GeneratedColumn<double> get areaM2 =>
      $composableBuilder(column: $table.areaM2, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LotesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LotesTable,
    Lote,
    $$LotesTableFilterComposer,
    $$LotesTableOrderingComposer,
    $$LotesTableAnnotationComposer,
    $$LotesTableCreateCompanionBuilder,
    $$LotesTableUpdateCompanionBuilder,
    (Lote, BaseReferences<_$AppDatabase, $LotesTable, Lote>),
    Lote,
    PrefetchHooks Function()> {
  $$LotesTableTableManager(_$AppDatabase db, $LotesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> projetoId = const Value.absent(),
            Value<String> codigo = const Value.absent(),
            Value<String?> quadra = const Value.absent(),
            Value<double?> areaM2 = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LotesCompanion(
            id: id,
            projetoId: projetoId,
            codigo: codigo,
            quadra: quadra,
            areaM2: areaM2,
            status: status,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String projetoId,
            required String codigo,
            Value<String?> quadra = const Value.absent(),
            Value<double?> areaM2 = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LotesCompanion.insert(
            id: id,
            projetoId: projetoId,
            codigo: codigo,
            quadra: quadra,
            areaM2: areaM2,
            status: status,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LotesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LotesTable,
    Lote,
    $$LotesTableFilterComposer,
    $$LotesTableOrderingComposer,
    $$LotesTableAnnotationComposer,
    $$LotesTableCreateCompanionBuilder,
    $$LotesTableUpdateCompanionBuilder,
    (Lote, BaseReferences<_$AppDatabase, $LotesTable, Lote>),
    Lote,
    PrefetchHooks Function()>;
typedef $$BeneficiariosTableCreateCompanionBuilder = BeneficiariosCompanion
    Function({
  required String id,
  required String loteId,
  required String nomeResponsavel,
  Value<String?> cpf,
  Value<String?> telefone,
  Value<String?> statusDocumental,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$BeneficiariosTableUpdateCompanionBuilder = BeneficiariosCompanion
    Function({
  Value<String> id,
  Value<String> loteId,
  Value<String> nomeResponsavel,
  Value<String?> cpf,
  Value<String?> telefone,
  Value<String?> statusDocumental,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$BeneficiariosTableFilterComposer
    extends Composer<_$AppDatabase, $BeneficiariosTable> {
  $$BeneficiariosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get loteId => $composableBuilder(
      column: $table.loteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nomeResponsavel => $composableBuilder(
      column: $table.nomeResponsavel,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cpf => $composableBuilder(
      column: $table.cpf, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get telefone => $composableBuilder(
      column: $table.telefone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get statusDocumental => $composableBuilder(
      column: $table.statusDocumental,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$BeneficiariosTableOrderingComposer
    extends Composer<_$AppDatabase, $BeneficiariosTable> {
  $$BeneficiariosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get loteId => $composableBuilder(
      column: $table.loteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nomeResponsavel => $composableBuilder(
      column: $table.nomeResponsavel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cpf => $composableBuilder(
      column: $table.cpf, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get telefone => $composableBuilder(
      column: $table.telefone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get statusDocumental => $composableBuilder(
      column: $table.statusDocumental,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$BeneficiariosTableAnnotationComposer
    extends Composer<_$AppDatabase, $BeneficiariosTable> {
  $$BeneficiariosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get loteId =>
      $composableBuilder(column: $table.loteId, builder: (column) => column);

  GeneratedColumn<String> get nomeResponsavel => $composableBuilder(
      column: $table.nomeResponsavel, builder: (column) => column);

  GeneratedColumn<String> get cpf =>
      $composableBuilder(column: $table.cpf, builder: (column) => column);

  GeneratedColumn<String> get telefone =>
      $composableBuilder(column: $table.telefone, builder: (column) => column);

  GeneratedColumn<String> get statusDocumental => $composableBuilder(
      column: $table.statusDocumental, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BeneficiariosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BeneficiariosTable,
    Beneficiario,
    $$BeneficiariosTableFilterComposer,
    $$BeneficiariosTableOrderingComposer,
    $$BeneficiariosTableAnnotationComposer,
    $$BeneficiariosTableCreateCompanionBuilder,
    $$BeneficiariosTableUpdateCompanionBuilder,
    (
      Beneficiario,
      BaseReferences<_$AppDatabase, $BeneficiariosTable, Beneficiario>
    ),
    Beneficiario,
    PrefetchHooks Function()> {
  $$BeneficiariosTableTableManager(_$AppDatabase db, $BeneficiariosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BeneficiariosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BeneficiariosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BeneficiariosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> loteId = const Value.absent(),
            Value<String> nomeResponsavel = const Value.absent(),
            Value<String?> cpf = const Value.absent(),
            Value<String?> telefone = const Value.absent(),
            Value<String?> statusDocumental = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BeneficiariosCompanion(
            id: id,
            loteId: loteId,
            nomeResponsavel: nomeResponsavel,
            cpf: cpf,
            telefone: telefone,
            statusDocumental: statusDocumental,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String loteId,
            required String nomeResponsavel,
            Value<String?> cpf = const Value.absent(),
            Value<String?> telefone = const Value.absent(),
            Value<String?> statusDocumental = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BeneficiariosCompanion.insert(
            id: id,
            loteId: loteId,
            nomeResponsavel: nomeResponsavel,
            cpf: cpf,
            telefone: telefone,
            statusDocumental: statusDocumental,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BeneficiariosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BeneficiariosTable,
    Beneficiario,
    $$BeneficiariosTableFilterComposer,
    $$BeneficiariosTableOrderingComposer,
    $$BeneficiariosTableAnnotationComposer,
    $$BeneficiariosTableCreateCompanionBuilder,
    $$BeneficiariosTableUpdateCompanionBuilder,
    (
      Beneficiario,
      BaseReferences<_$AppDatabase, $BeneficiariosTable, Beneficiario>
    ),
    Beneficiario,
    PrefetchHooks Function()>;
typedef $$SelagensTableCreateCompanionBuilder = SelagensCompanion Function({
  required String id,
  Value<String?> projetoId,
  Value<String?> loteId,
  Value<String?> lotePreliminarId,
  Value<String?> codigoLotePreliminar,
  Value<String> statusVinculoGeografico,
  Value<bool> necessitaValidacaoRtk,
  Value<String?> observacaoGeoespacial,
  required String codigoSelo,
  required String situacao,
  Value<bool> moradorPresente,
  Value<bool> moradiaOcupada,
  Value<String?> situacaoAtendimento,
  Value<String?> tipoUnidade,
  Value<String?> usoImovel,
  Value<String?> nomeInformante,
  Value<String?> telefoneInformante,
  Value<String?> relacaoInformante,
  Value<bool> revisitaNecessaria,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<double?> precisaoGps,
  Value<String?> fotoFachadaPath,
  Value<String?> observacoes,
  Value<bool> synced,
  Value<String?> serverId,
  Value<String?> sourceDeviceId,
  Value<String> syncStatus,
  Value<int> syncAttempts,
  Value<String?> syncError,
  Value<DateTime?> lastSyncAttemptAt,
  Value<DateTime?> syncedAt,
  Value<DateTime> localUpdatedAt,
  Value<DateTime?> serverUpdatedAt,
  Value<int> syncVersion,
  Value<bool> deletedLocally,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$SelagensTableUpdateCompanionBuilder = SelagensCompanion Function({
  Value<String> id,
  Value<String?> projetoId,
  Value<String?> loteId,
  Value<String?> lotePreliminarId,
  Value<String?> codigoLotePreliminar,
  Value<String> statusVinculoGeografico,
  Value<bool> necessitaValidacaoRtk,
  Value<String?> observacaoGeoespacial,
  Value<String> codigoSelo,
  Value<String> situacao,
  Value<bool> moradorPresente,
  Value<bool> moradiaOcupada,
  Value<String?> situacaoAtendimento,
  Value<String?> tipoUnidade,
  Value<String?> usoImovel,
  Value<String?> nomeInformante,
  Value<String?> telefoneInformante,
  Value<String?> relacaoInformante,
  Value<bool> revisitaNecessaria,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<double?> precisaoGps,
  Value<String?> fotoFachadaPath,
  Value<String?> observacoes,
  Value<bool> synced,
  Value<String?> serverId,
  Value<String?> sourceDeviceId,
  Value<String> syncStatus,
  Value<int> syncAttempts,
  Value<String?> syncError,
  Value<DateTime?> lastSyncAttemptAt,
  Value<DateTime?> syncedAt,
  Value<DateTime> localUpdatedAt,
  Value<DateTime?> serverUpdatedAt,
  Value<int> syncVersion,
  Value<bool> deletedLocally,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$SelagensTableFilterComposer
    extends Composer<_$AppDatabase, $SelagensTable> {
  $$SelagensTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get projetoId => $composableBuilder(
      column: $table.projetoId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get loteId => $composableBuilder(
      column: $table.loteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lotePreliminarId => $composableBuilder(
      column: $table.lotePreliminarId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get codigoLotePreliminar => $composableBuilder(
      column: $table.codigoLotePreliminar,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get statusVinculoGeografico => $composableBuilder(
      column: $table.statusVinculoGeografico,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get necessitaValidacaoRtk => $composableBuilder(
      column: $table.necessitaValidacaoRtk,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get observacaoGeoespacial => $composableBuilder(
      column: $table.observacaoGeoespacial,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get codigoSelo => $composableBuilder(
      column: $table.codigoSelo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get situacao => $composableBuilder(
      column: $table.situacao, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get moradorPresente => $composableBuilder(
      column: $table.moradorPresente,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get moradiaOcupada => $composableBuilder(
      column: $table.moradiaOcupada,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get situacaoAtendimento => $composableBuilder(
      column: $table.situacaoAtendimento,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tipoUnidade => $composableBuilder(
      column: $table.tipoUnidade, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usoImovel => $composableBuilder(
      column: $table.usoImovel, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nomeInformante => $composableBuilder(
      column: $table.nomeInformante,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get telefoneInformante => $composableBuilder(
      column: $table.telefoneInformante,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get relacaoInformante => $composableBuilder(
      column: $table.relacaoInformante,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get revisitaNecessaria => $composableBuilder(
      column: $table.revisitaNecessaria,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get precisaoGps => $composableBuilder(
      column: $table.precisaoGps, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fotoFachadaPath => $composableBuilder(
      column: $table.fotoFachadaPath,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get observacoes => $composableBuilder(
      column: $table.observacoes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get serverId => $composableBuilder(
      column: $table.serverId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceDeviceId => $composableBuilder(
      column: $table.sourceDeviceId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get syncAttempts => $composableBuilder(
      column: $table.syncAttempts, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncError => $composableBuilder(
      column: $table.syncError, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncAttemptAt => $composableBuilder(
      column: $table.lastSyncAttemptAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get syncVersion => $composableBuilder(
      column: $table.syncVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deletedLocally => $composableBuilder(
      column: $table.deletedLocally,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SelagensTableOrderingComposer
    extends Composer<_$AppDatabase, $SelagensTable> {
  $$SelagensTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get projetoId => $composableBuilder(
      column: $table.projetoId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get loteId => $composableBuilder(
      column: $table.loteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lotePreliminarId => $composableBuilder(
      column: $table.lotePreliminarId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get codigoLotePreliminar => $composableBuilder(
      column: $table.codigoLotePreliminar,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get statusVinculoGeografico => $composableBuilder(
      column: $table.statusVinculoGeografico,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get necessitaValidacaoRtk => $composableBuilder(
      column: $table.necessitaValidacaoRtk,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get observacaoGeoespacial => $composableBuilder(
      column: $table.observacaoGeoespacial,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get codigoSelo => $composableBuilder(
      column: $table.codigoSelo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get situacao => $composableBuilder(
      column: $table.situacao, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get moradorPresente => $composableBuilder(
      column: $table.moradorPresente,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get moradiaOcupada => $composableBuilder(
      column: $table.moradiaOcupada,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get situacaoAtendimento => $composableBuilder(
      column: $table.situacaoAtendimento,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tipoUnidade => $composableBuilder(
      column: $table.tipoUnidade, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usoImovel => $composableBuilder(
      column: $table.usoImovel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nomeInformante => $composableBuilder(
      column: $table.nomeInformante,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get telefoneInformante => $composableBuilder(
      column: $table.telefoneInformante,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get relacaoInformante => $composableBuilder(
      column: $table.relacaoInformante,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get revisitaNecessaria => $composableBuilder(
      column: $table.revisitaNecessaria,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get precisaoGps => $composableBuilder(
      column: $table.precisaoGps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fotoFachadaPath => $composableBuilder(
      column: $table.fotoFachadaPath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get observacoes => $composableBuilder(
      column: $table.observacoes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get serverId => $composableBuilder(
      column: $table.serverId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceDeviceId => $composableBuilder(
      column: $table.sourceDeviceId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get syncAttempts => $composableBuilder(
      column: $table.syncAttempts,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncError => $composableBuilder(
      column: $table.syncError, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncAttemptAt => $composableBuilder(
      column: $table.lastSyncAttemptAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get syncVersion => $composableBuilder(
      column: $table.syncVersion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deletedLocally => $composableBuilder(
      column: $table.deletedLocally,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SelagensTableAnnotationComposer
    extends Composer<_$AppDatabase, $SelagensTable> {
  $$SelagensTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get projetoId =>
      $composableBuilder(column: $table.projetoId, builder: (column) => column);

  GeneratedColumn<String> get loteId =>
      $composableBuilder(column: $table.loteId, builder: (column) => column);

  GeneratedColumn<String> get lotePreliminarId => $composableBuilder(
      column: $table.lotePreliminarId, builder: (column) => column);

  GeneratedColumn<String> get codigoLotePreliminar => $composableBuilder(
      column: $table.codigoLotePreliminar, builder: (column) => column);

  GeneratedColumn<String> get statusVinculoGeografico => $composableBuilder(
      column: $table.statusVinculoGeografico, builder: (column) => column);

  GeneratedColumn<bool> get necessitaValidacaoRtk => $composableBuilder(
      column: $table.necessitaValidacaoRtk, builder: (column) => column);

  GeneratedColumn<String> get observacaoGeoespacial => $composableBuilder(
      column: $table.observacaoGeoespacial, builder: (column) => column);

  GeneratedColumn<String> get codigoSelo => $composableBuilder(
      column: $table.codigoSelo, builder: (column) => column);

  GeneratedColumn<String> get situacao =>
      $composableBuilder(column: $table.situacao, builder: (column) => column);

  GeneratedColumn<bool> get moradorPresente => $composableBuilder(
      column: $table.moradorPresente, builder: (column) => column);

  GeneratedColumn<bool> get moradiaOcupada => $composableBuilder(
      column: $table.moradiaOcupada, builder: (column) => column);

  GeneratedColumn<String> get situacaoAtendimento => $composableBuilder(
      column: $table.situacaoAtendimento, builder: (column) => column);

  GeneratedColumn<String> get tipoUnidade => $composableBuilder(
      column: $table.tipoUnidade, builder: (column) => column);

  GeneratedColumn<String> get usoImovel =>
      $composableBuilder(column: $table.usoImovel, builder: (column) => column);

  GeneratedColumn<String> get nomeInformante => $composableBuilder(
      column: $table.nomeInformante, builder: (column) => column);

  GeneratedColumn<String> get telefoneInformante => $composableBuilder(
      column: $table.telefoneInformante, builder: (column) => column);

  GeneratedColumn<String> get relacaoInformante => $composableBuilder(
      column: $table.relacaoInformante, builder: (column) => column);

  GeneratedColumn<bool> get revisitaNecessaria => $composableBuilder(
      column: $table.revisitaNecessaria, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get precisaoGps => $composableBuilder(
      column: $table.precisaoGps, builder: (column) => column);

  GeneratedColumn<String> get fotoFachadaPath => $composableBuilder(
      column: $table.fotoFachadaPath, builder: (column) => column);

  GeneratedColumn<String> get observacoes => $composableBuilder(
      column: $table.observacoes, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get sourceDeviceId => $composableBuilder(
      column: $table.sourceDeviceId, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<int> get syncAttempts => $composableBuilder(
      column: $table.syncAttempts, builder: (column) => column);

  GeneratedColumn<String> get syncError =>
      $composableBuilder(column: $table.syncError, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncAttemptAt => $composableBuilder(
      column: $table.lastSyncAttemptAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt, builder: (column) => column);

  GeneratedColumn<int> get syncVersion => $composableBuilder(
      column: $table.syncVersion, builder: (column) => column);

  GeneratedColumn<bool> get deletedLocally => $composableBuilder(
      column: $table.deletedLocally, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SelagensTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SelagensTable,
    Selagen,
    $$SelagensTableFilterComposer,
    $$SelagensTableOrderingComposer,
    $$SelagensTableAnnotationComposer,
    $$SelagensTableCreateCompanionBuilder,
    $$SelagensTableUpdateCompanionBuilder,
    (Selagen, BaseReferences<_$AppDatabase, $SelagensTable, Selagen>),
    Selagen,
    PrefetchHooks Function()> {
  $$SelagensTableTableManager(_$AppDatabase db, $SelagensTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SelagensTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SelagensTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SelagensTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> projetoId = const Value.absent(),
            Value<String?> loteId = const Value.absent(),
            Value<String?> lotePreliminarId = const Value.absent(),
            Value<String?> codigoLotePreliminar = const Value.absent(),
            Value<String> statusVinculoGeografico = const Value.absent(),
            Value<bool> necessitaValidacaoRtk = const Value.absent(),
            Value<String?> observacaoGeoespacial = const Value.absent(),
            Value<String> codigoSelo = const Value.absent(),
            Value<String> situacao = const Value.absent(),
            Value<bool> moradorPresente = const Value.absent(),
            Value<bool> moradiaOcupada = const Value.absent(),
            Value<String?> situacaoAtendimento = const Value.absent(),
            Value<String?> tipoUnidade = const Value.absent(),
            Value<String?> usoImovel = const Value.absent(),
            Value<String?> nomeInformante = const Value.absent(),
            Value<String?> telefoneInformante = const Value.absent(),
            Value<String?> relacaoInformante = const Value.absent(),
            Value<bool> revisitaNecessaria = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<double?> precisaoGps = const Value.absent(),
            Value<String?> fotoFachadaPath = const Value.absent(),
            Value<String?> observacoes = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<String?> serverId = const Value.absent(),
            Value<String?> sourceDeviceId = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> syncAttempts = const Value.absent(),
            Value<String?> syncError = const Value.absent(),
            Value<DateTime?> lastSyncAttemptAt = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<DateTime> localUpdatedAt = const Value.absent(),
            Value<DateTime?> serverUpdatedAt = const Value.absent(),
            Value<int> syncVersion = const Value.absent(),
            Value<bool> deletedLocally = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SelagensCompanion(
            id: id,
            projetoId: projetoId,
            loteId: loteId,
            lotePreliminarId: lotePreliminarId,
            codigoLotePreliminar: codigoLotePreliminar,
            statusVinculoGeografico: statusVinculoGeografico,
            necessitaValidacaoRtk: necessitaValidacaoRtk,
            observacaoGeoespacial: observacaoGeoespacial,
            codigoSelo: codigoSelo,
            situacao: situacao,
            moradorPresente: moradorPresente,
            moradiaOcupada: moradiaOcupada,
            situacaoAtendimento: situacaoAtendimento,
            tipoUnidade: tipoUnidade,
            usoImovel: usoImovel,
            nomeInformante: nomeInformante,
            telefoneInformante: telefoneInformante,
            relacaoInformante: relacaoInformante,
            revisitaNecessaria: revisitaNecessaria,
            latitude: latitude,
            longitude: longitude,
            precisaoGps: precisaoGps,
            fotoFachadaPath: fotoFachadaPath,
            observacoes: observacoes,
            synced: synced,
            serverId: serverId,
            sourceDeviceId: sourceDeviceId,
            syncStatus: syncStatus,
            syncAttempts: syncAttempts,
            syncError: syncError,
            lastSyncAttemptAt: lastSyncAttemptAt,
            syncedAt: syncedAt,
            localUpdatedAt: localUpdatedAt,
            serverUpdatedAt: serverUpdatedAt,
            syncVersion: syncVersion,
            deletedLocally: deletedLocally,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> projetoId = const Value.absent(),
            Value<String?> loteId = const Value.absent(),
            Value<String?> lotePreliminarId = const Value.absent(),
            Value<String?> codigoLotePreliminar = const Value.absent(),
            Value<String> statusVinculoGeografico = const Value.absent(),
            Value<bool> necessitaValidacaoRtk = const Value.absent(),
            Value<String?> observacaoGeoespacial = const Value.absent(),
            required String codigoSelo,
            required String situacao,
            Value<bool> moradorPresente = const Value.absent(),
            Value<bool> moradiaOcupada = const Value.absent(),
            Value<String?> situacaoAtendimento = const Value.absent(),
            Value<String?> tipoUnidade = const Value.absent(),
            Value<String?> usoImovel = const Value.absent(),
            Value<String?> nomeInformante = const Value.absent(),
            Value<String?> telefoneInformante = const Value.absent(),
            Value<String?> relacaoInformante = const Value.absent(),
            Value<bool> revisitaNecessaria = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<double?> precisaoGps = const Value.absent(),
            Value<String?> fotoFachadaPath = const Value.absent(),
            Value<String?> observacoes = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<String?> serverId = const Value.absent(),
            Value<String?> sourceDeviceId = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> syncAttempts = const Value.absent(),
            Value<String?> syncError = const Value.absent(),
            Value<DateTime?> lastSyncAttemptAt = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<DateTime> localUpdatedAt = const Value.absent(),
            Value<DateTime?> serverUpdatedAt = const Value.absent(),
            Value<int> syncVersion = const Value.absent(),
            Value<bool> deletedLocally = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SelagensCompanion.insert(
            id: id,
            projetoId: projetoId,
            loteId: loteId,
            lotePreliminarId: lotePreliminarId,
            codigoLotePreliminar: codigoLotePreliminar,
            statusVinculoGeografico: statusVinculoGeografico,
            necessitaValidacaoRtk: necessitaValidacaoRtk,
            observacaoGeoespacial: observacaoGeoespacial,
            codigoSelo: codigoSelo,
            situacao: situacao,
            moradorPresente: moradorPresente,
            moradiaOcupada: moradiaOcupada,
            situacaoAtendimento: situacaoAtendimento,
            tipoUnidade: tipoUnidade,
            usoImovel: usoImovel,
            nomeInformante: nomeInformante,
            telefoneInformante: telefoneInformante,
            relacaoInformante: relacaoInformante,
            revisitaNecessaria: revisitaNecessaria,
            latitude: latitude,
            longitude: longitude,
            precisaoGps: precisaoGps,
            fotoFachadaPath: fotoFachadaPath,
            observacoes: observacoes,
            synced: synced,
            serverId: serverId,
            sourceDeviceId: sourceDeviceId,
            syncStatus: syncStatus,
            syncAttempts: syncAttempts,
            syncError: syncError,
            lastSyncAttemptAt: lastSyncAttemptAt,
            syncedAt: syncedAt,
            localUpdatedAt: localUpdatedAt,
            serverUpdatedAt: serverUpdatedAt,
            syncVersion: syncVersion,
            deletedLocally: deletedLocally,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SelagensTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SelagensTable,
    Selagen,
    $$SelagensTableFilterComposer,
    $$SelagensTableOrderingComposer,
    $$SelagensTableAnnotationComposer,
    $$SelagensTableCreateCompanionBuilder,
    $$SelagensTableUpdateCompanionBuilder,
    (Selagen, BaseReferences<_$AppDatabase, $SelagensTable, Selagen>),
    Selagen,
    PrefetchHooks Function()>;
typedef $$CadastrosFisicosTableCreateCompanionBuilder
    = CadastrosFisicosCompanion Function({
  required String id,
  required String projetoId,
  Value<String?> selagemId,
  required String codigoSelo,
  Value<String?> tipoImovel,
  Value<String?> usoImovel,
  Value<String?> materialParedes,
  Value<String?> tipoCobertura,
  Value<String?> tipoPiso,
  Value<int?> numeroPavimentos,
  Value<int?> numeroComodos,
  Value<int?> numeroBanheiros,
  Value<bool> possuiEnergia,
  Value<bool> possuiAgua,
  Value<bool> possuiEsgoto,
  Value<bool> possuiBanheiro,
  Value<String?> condicaoHabitabilidade,
  Value<bool> areaRisco,
  Value<bool> sujeitoInundacao,
  Value<String?> observacoes,
  Value<bool> synced,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$CadastrosFisicosTableUpdateCompanionBuilder
    = CadastrosFisicosCompanion Function({
  Value<String> id,
  Value<String> projetoId,
  Value<String?> selagemId,
  Value<String> codigoSelo,
  Value<String?> tipoImovel,
  Value<String?> usoImovel,
  Value<String?> materialParedes,
  Value<String?> tipoCobertura,
  Value<String?> tipoPiso,
  Value<int?> numeroPavimentos,
  Value<int?> numeroComodos,
  Value<int?> numeroBanheiros,
  Value<bool> possuiEnergia,
  Value<bool> possuiAgua,
  Value<bool> possuiEsgoto,
  Value<bool> possuiBanheiro,
  Value<String?> condicaoHabitabilidade,
  Value<bool> areaRisco,
  Value<bool> sujeitoInundacao,
  Value<String?> observacoes,
  Value<bool> synced,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$CadastrosFisicosTableFilterComposer
    extends Composer<_$AppDatabase, $CadastrosFisicosTable> {
  $$CadastrosFisicosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get projetoId => $composableBuilder(
      column: $table.projetoId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get selagemId => $composableBuilder(
      column: $table.selagemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get codigoSelo => $composableBuilder(
      column: $table.codigoSelo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tipoImovel => $composableBuilder(
      column: $table.tipoImovel, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usoImovel => $composableBuilder(
      column: $table.usoImovel, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get materialParedes => $composableBuilder(
      column: $table.materialParedes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tipoCobertura => $composableBuilder(
      column: $table.tipoCobertura, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tipoPiso => $composableBuilder(
      column: $table.tipoPiso, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get numeroPavimentos => $composableBuilder(
      column: $table.numeroPavimentos,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get numeroComodos => $composableBuilder(
      column: $table.numeroComodos, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get numeroBanheiros => $composableBuilder(
      column: $table.numeroBanheiros,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get possuiEnergia => $composableBuilder(
      column: $table.possuiEnergia, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get possuiAgua => $composableBuilder(
      column: $table.possuiAgua, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get possuiEsgoto => $composableBuilder(
      column: $table.possuiEsgoto, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get possuiBanheiro => $composableBuilder(
      column: $table.possuiBanheiro,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get condicaoHabitabilidade => $composableBuilder(
      column: $table.condicaoHabitabilidade,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get areaRisco => $composableBuilder(
      column: $table.areaRisco, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get sujeitoInundacao => $composableBuilder(
      column: $table.sujeitoInundacao,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get observacoes => $composableBuilder(
      column: $table.observacoes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$CadastrosFisicosTableOrderingComposer
    extends Composer<_$AppDatabase, $CadastrosFisicosTable> {
  $$CadastrosFisicosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get projetoId => $composableBuilder(
      column: $table.projetoId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get selagemId => $composableBuilder(
      column: $table.selagemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get codigoSelo => $composableBuilder(
      column: $table.codigoSelo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tipoImovel => $composableBuilder(
      column: $table.tipoImovel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usoImovel => $composableBuilder(
      column: $table.usoImovel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get materialParedes => $composableBuilder(
      column: $table.materialParedes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tipoCobertura => $composableBuilder(
      column: $table.tipoCobertura,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tipoPiso => $composableBuilder(
      column: $table.tipoPiso, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get numeroPavimentos => $composableBuilder(
      column: $table.numeroPavimentos,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get numeroComodos => $composableBuilder(
      column: $table.numeroComodos,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get numeroBanheiros => $composableBuilder(
      column: $table.numeroBanheiros,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get possuiEnergia => $composableBuilder(
      column: $table.possuiEnergia,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get possuiAgua => $composableBuilder(
      column: $table.possuiAgua, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get possuiEsgoto => $composableBuilder(
      column: $table.possuiEsgoto,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get possuiBanheiro => $composableBuilder(
      column: $table.possuiBanheiro,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get condicaoHabitabilidade => $composableBuilder(
      column: $table.condicaoHabitabilidade,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get areaRisco => $composableBuilder(
      column: $table.areaRisco, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get sujeitoInundacao => $composableBuilder(
      column: $table.sujeitoInundacao,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get observacoes => $composableBuilder(
      column: $table.observacoes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$CadastrosFisicosTableAnnotationComposer
    extends Composer<_$AppDatabase, $CadastrosFisicosTable> {
  $$CadastrosFisicosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get projetoId =>
      $composableBuilder(column: $table.projetoId, builder: (column) => column);

  GeneratedColumn<String> get selagemId =>
      $composableBuilder(column: $table.selagemId, builder: (column) => column);

  GeneratedColumn<String> get codigoSelo => $composableBuilder(
      column: $table.codigoSelo, builder: (column) => column);

  GeneratedColumn<String> get tipoImovel => $composableBuilder(
      column: $table.tipoImovel, builder: (column) => column);

  GeneratedColumn<String> get usoImovel =>
      $composableBuilder(column: $table.usoImovel, builder: (column) => column);

  GeneratedColumn<String> get materialParedes => $composableBuilder(
      column: $table.materialParedes, builder: (column) => column);

  GeneratedColumn<String> get tipoCobertura => $composableBuilder(
      column: $table.tipoCobertura, builder: (column) => column);

  GeneratedColumn<String> get tipoPiso =>
      $composableBuilder(column: $table.tipoPiso, builder: (column) => column);

  GeneratedColumn<int> get numeroPavimentos => $composableBuilder(
      column: $table.numeroPavimentos, builder: (column) => column);

  GeneratedColumn<int> get numeroComodos => $composableBuilder(
      column: $table.numeroComodos, builder: (column) => column);

  GeneratedColumn<int> get numeroBanheiros => $composableBuilder(
      column: $table.numeroBanheiros, builder: (column) => column);

  GeneratedColumn<bool> get possuiEnergia => $composableBuilder(
      column: $table.possuiEnergia, builder: (column) => column);

  GeneratedColumn<bool> get possuiAgua => $composableBuilder(
      column: $table.possuiAgua, builder: (column) => column);

  GeneratedColumn<bool> get possuiEsgoto => $composableBuilder(
      column: $table.possuiEsgoto, builder: (column) => column);

  GeneratedColumn<bool> get possuiBanheiro => $composableBuilder(
      column: $table.possuiBanheiro, builder: (column) => column);

  GeneratedColumn<String> get condicaoHabitabilidade => $composableBuilder(
      column: $table.condicaoHabitabilidade, builder: (column) => column);

  GeneratedColumn<bool> get areaRisco =>
      $composableBuilder(column: $table.areaRisco, builder: (column) => column);

  GeneratedColumn<bool> get sujeitoInundacao => $composableBuilder(
      column: $table.sujeitoInundacao, builder: (column) => column);

  GeneratedColumn<String> get observacoes => $composableBuilder(
      column: $table.observacoes, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CadastrosFisicosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CadastrosFisicosTable,
    CadastrosFisico,
    $$CadastrosFisicosTableFilterComposer,
    $$CadastrosFisicosTableOrderingComposer,
    $$CadastrosFisicosTableAnnotationComposer,
    $$CadastrosFisicosTableCreateCompanionBuilder,
    $$CadastrosFisicosTableUpdateCompanionBuilder,
    (
      CadastrosFisico,
      BaseReferences<_$AppDatabase, $CadastrosFisicosTable, CadastrosFisico>
    ),
    CadastrosFisico,
    PrefetchHooks Function()> {
  $$CadastrosFisicosTableTableManager(
      _$AppDatabase db, $CadastrosFisicosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CadastrosFisicosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CadastrosFisicosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CadastrosFisicosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> projetoId = const Value.absent(),
            Value<String?> selagemId = const Value.absent(),
            Value<String> codigoSelo = const Value.absent(),
            Value<String?> tipoImovel = const Value.absent(),
            Value<String?> usoImovel = const Value.absent(),
            Value<String?> materialParedes = const Value.absent(),
            Value<String?> tipoCobertura = const Value.absent(),
            Value<String?> tipoPiso = const Value.absent(),
            Value<int?> numeroPavimentos = const Value.absent(),
            Value<int?> numeroComodos = const Value.absent(),
            Value<int?> numeroBanheiros = const Value.absent(),
            Value<bool> possuiEnergia = const Value.absent(),
            Value<bool> possuiAgua = const Value.absent(),
            Value<bool> possuiEsgoto = const Value.absent(),
            Value<bool> possuiBanheiro = const Value.absent(),
            Value<String?> condicaoHabitabilidade = const Value.absent(),
            Value<bool> areaRisco = const Value.absent(),
            Value<bool> sujeitoInundacao = const Value.absent(),
            Value<String?> observacoes = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CadastrosFisicosCompanion(
            id: id,
            projetoId: projetoId,
            selagemId: selagemId,
            codigoSelo: codigoSelo,
            tipoImovel: tipoImovel,
            usoImovel: usoImovel,
            materialParedes: materialParedes,
            tipoCobertura: tipoCobertura,
            tipoPiso: tipoPiso,
            numeroPavimentos: numeroPavimentos,
            numeroComodos: numeroComodos,
            numeroBanheiros: numeroBanheiros,
            possuiEnergia: possuiEnergia,
            possuiAgua: possuiAgua,
            possuiEsgoto: possuiEsgoto,
            possuiBanheiro: possuiBanheiro,
            condicaoHabitabilidade: condicaoHabitabilidade,
            areaRisco: areaRisco,
            sujeitoInundacao: sujeitoInundacao,
            observacoes: observacoes,
            synced: synced,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String projetoId,
            Value<String?> selagemId = const Value.absent(),
            required String codigoSelo,
            Value<String?> tipoImovel = const Value.absent(),
            Value<String?> usoImovel = const Value.absent(),
            Value<String?> materialParedes = const Value.absent(),
            Value<String?> tipoCobertura = const Value.absent(),
            Value<String?> tipoPiso = const Value.absent(),
            Value<int?> numeroPavimentos = const Value.absent(),
            Value<int?> numeroComodos = const Value.absent(),
            Value<int?> numeroBanheiros = const Value.absent(),
            Value<bool> possuiEnergia = const Value.absent(),
            Value<bool> possuiAgua = const Value.absent(),
            Value<bool> possuiEsgoto = const Value.absent(),
            Value<bool> possuiBanheiro = const Value.absent(),
            Value<String?> condicaoHabitabilidade = const Value.absent(),
            Value<bool> areaRisco = const Value.absent(),
            Value<bool> sujeitoInundacao = const Value.absent(),
            Value<String?> observacoes = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CadastrosFisicosCompanion.insert(
            id: id,
            projetoId: projetoId,
            selagemId: selagemId,
            codigoSelo: codigoSelo,
            tipoImovel: tipoImovel,
            usoImovel: usoImovel,
            materialParedes: materialParedes,
            tipoCobertura: tipoCobertura,
            tipoPiso: tipoPiso,
            numeroPavimentos: numeroPavimentos,
            numeroComodos: numeroComodos,
            numeroBanheiros: numeroBanheiros,
            possuiEnergia: possuiEnergia,
            possuiAgua: possuiAgua,
            possuiEsgoto: possuiEsgoto,
            possuiBanheiro: possuiBanheiro,
            condicaoHabitabilidade: condicaoHabitabilidade,
            areaRisco: areaRisco,
            sujeitoInundacao: sujeitoInundacao,
            observacoes: observacoes,
            synced: synced,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CadastrosFisicosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CadastrosFisicosTable,
    CadastrosFisico,
    $$CadastrosFisicosTableFilterComposer,
    $$CadastrosFisicosTableOrderingComposer,
    $$CadastrosFisicosTableAnnotationComposer,
    $$CadastrosFisicosTableCreateCompanionBuilder,
    $$CadastrosFisicosTableUpdateCompanionBuilder,
    (
      CadastrosFisico,
      BaseReferences<_$AppDatabase, $CadastrosFisicosTable, CadastrosFisico>
    ),
    CadastrosFisico,
    PrefetchHooks Function()>;
typedef $$CadastrosSociaisTableCreateCompanionBuilder
    = CadastrosSociaisCompanion Function({
  required String id,
  required String projetoId,
  Value<String?> selagemId,
  required String codigoSelo,
  required String nomeResponsavel,
  Value<String?> cpfResponsavel,
  Value<String?> rgResponsavel,
  Value<String?> orgaoEmissor,
  Value<String?> estadoCivil,
  Value<String?> profissao,
  Value<String?> telefone,
  Value<int?> quantidadeMoradores,
  Value<double?> rendaFamiliar,
  Value<bool> recebeProgramaSocial,
  Value<String?> programaSocial,
  Value<int?> tempoOcupacaoAnos,
  Value<String?> formaOcupacao,
  Value<String?> documentoPosse,
  Value<bool> possuiOutroImovel,
  Value<bool> possuiConflito,
  Value<String?> observacoes,
  Value<bool> synced,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$CadastrosSociaisTableUpdateCompanionBuilder
    = CadastrosSociaisCompanion Function({
  Value<String> id,
  Value<String> projetoId,
  Value<String?> selagemId,
  Value<String> codigoSelo,
  Value<String> nomeResponsavel,
  Value<String?> cpfResponsavel,
  Value<String?> rgResponsavel,
  Value<String?> orgaoEmissor,
  Value<String?> estadoCivil,
  Value<String?> profissao,
  Value<String?> telefone,
  Value<int?> quantidadeMoradores,
  Value<double?> rendaFamiliar,
  Value<bool> recebeProgramaSocial,
  Value<String?> programaSocial,
  Value<int?> tempoOcupacaoAnos,
  Value<String?> formaOcupacao,
  Value<String?> documentoPosse,
  Value<bool> possuiOutroImovel,
  Value<bool> possuiConflito,
  Value<String?> observacoes,
  Value<bool> synced,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$CadastrosSociaisTableFilterComposer
    extends Composer<_$AppDatabase, $CadastrosSociaisTable> {
  $$CadastrosSociaisTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get projetoId => $composableBuilder(
      column: $table.projetoId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get selagemId => $composableBuilder(
      column: $table.selagemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get codigoSelo => $composableBuilder(
      column: $table.codigoSelo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nomeResponsavel => $composableBuilder(
      column: $table.nomeResponsavel,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cpfResponsavel => $composableBuilder(
      column: $table.cpfResponsavel,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rgResponsavel => $composableBuilder(
      column: $table.rgResponsavel, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get orgaoEmissor => $composableBuilder(
      column: $table.orgaoEmissor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get estadoCivil => $composableBuilder(
      column: $table.estadoCivil, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profissao => $composableBuilder(
      column: $table.profissao, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get telefone => $composableBuilder(
      column: $table.telefone, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantidadeMoradores => $composableBuilder(
      column: $table.quantidadeMoradores,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get rendaFamiliar => $composableBuilder(
      column: $table.rendaFamiliar, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get recebeProgramaSocial => $composableBuilder(
      column: $table.recebeProgramaSocial,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get programaSocial => $composableBuilder(
      column: $table.programaSocial,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tempoOcupacaoAnos => $composableBuilder(
      column: $table.tempoOcupacaoAnos,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get formaOcupacao => $composableBuilder(
      column: $table.formaOcupacao, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get documentoPosse => $composableBuilder(
      column: $table.documentoPosse,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get possuiOutroImovel => $composableBuilder(
      column: $table.possuiOutroImovel,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get possuiConflito => $composableBuilder(
      column: $table.possuiConflito,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get observacoes => $composableBuilder(
      column: $table.observacoes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$CadastrosSociaisTableOrderingComposer
    extends Composer<_$AppDatabase, $CadastrosSociaisTable> {
  $$CadastrosSociaisTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get projetoId => $composableBuilder(
      column: $table.projetoId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get selagemId => $composableBuilder(
      column: $table.selagemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get codigoSelo => $composableBuilder(
      column: $table.codigoSelo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nomeResponsavel => $composableBuilder(
      column: $table.nomeResponsavel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cpfResponsavel => $composableBuilder(
      column: $table.cpfResponsavel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rgResponsavel => $composableBuilder(
      column: $table.rgResponsavel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get orgaoEmissor => $composableBuilder(
      column: $table.orgaoEmissor,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get estadoCivil => $composableBuilder(
      column: $table.estadoCivil, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profissao => $composableBuilder(
      column: $table.profissao, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get telefone => $composableBuilder(
      column: $table.telefone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantidadeMoradores => $composableBuilder(
      column: $table.quantidadeMoradores,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get rendaFamiliar => $composableBuilder(
      column: $table.rendaFamiliar,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get recebeProgramaSocial => $composableBuilder(
      column: $table.recebeProgramaSocial,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get programaSocial => $composableBuilder(
      column: $table.programaSocial,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tempoOcupacaoAnos => $composableBuilder(
      column: $table.tempoOcupacaoAnos,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get formaOcupacao => $composableBuilder(
      column: $table.formaOcupacao,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get documentoPosse => $composableBuilder(
      column: $table.documentoPosse,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get possuiOutroImovel => $composableBuilder(
      column: $table.possuiOutroImovel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get possuiConflito => $composableBuilder(
      column: $table.possuiConflito,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get observacoes => $composableBuilder(
      column: $table.observacoes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$CadastrosSociaisTableAnnotationComposer
    extends Composer<_$AppDatabase, $CadastrosSociaisTable> {
  $$CadastrosSociaisTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get projetoId =>
      $composableBuilder(column: $table.projetoId, builder: (column) => column);

  GeneratedColumn<String> get selagemId =>
      $composableBuilder(column: $table.selagemId, builder: (column) => column);

  GeneratedColumn<String> get codigoSelo => $composableBuilder(
      column: $table.codigoSelo, builder: (column) => column);

  GeneratedColumn<String> get nomeResponsavel => $composableBuilder(
      column: $table.nomeResponsavel, builder: (column) => column);

  GeneratedColumn<String> get cpfResponsavel => $composableBuilder(
      column: $table.cpfResponsavel, builder: (column) => column);

  GeneratedColumn<String> get rgResponsavel => $composableBuilder(
      column: $table.rgResponsavel, builder: (column) => column);

  GeneratedColumn<String> get orgaoEmissor => $composableBuilder(
      column: $table.orgaoEmissor, builder: (column) => column);

  GeneratedColumn<String> get estadoCivil => $composableBuilder(
      column: $table.estadoCivil, builder: (column) => column);

  GeneratedColumn<String> get profissao =>
      $composableBuilder(column: $table.profissao, builder: (column) => column);

  GeneratedColumn<String> get telefone =>
      $composableBuilder(column: $table.telefone, builder: (column) => column);

  GeneratedColumn<int> get quantidadeMoradores => $composableBuilder(
      column: $table.quantidadeMoradores, builder: (column) => column);

  GeneratedColumn<double> get rendaFamiliar => $composableBuilder(
      column: $table.rendaFamiliar, builder: (column) => column);

  GeneratedColumn<bool> get recebeProgramaSocial => $composableBuilder(
      column: $table.recebeProgramaSocial, builder: (column) => column);

  GeneratedColumn<String> get programaSocial => $composableBuilder(
      column: $table.programaSocial, builder: (column) => column);

  GeneratedColumn<int> get tempoOcupacaoAnos => $composableBuilder(
      column: $table.tempoOcupacaoAnos, builder: (column) => column);

  GeneratedColumn<String> get formaOcupacao => $composableBuilder(
      column: $table.formaOcupacao, builder: (column) => column);

  GeneratedColumn<String> get documentoPosse => $composableBuilder(
      column: $table.documentoPosse, builder: (column) => column);

  GeneratedColumn<bool> get possuiOutroImovel => $composableBuilder(
      column: $table.possuiOutroImovel, builder: (column) => column);

  GeneratedColumn<bool> get possuiConflito => $composableBuilder(
      column: $table.possuiConflito, builder: (column) => column);

  GeneratedColumn<String> get observacoes => $composableBuilder(
      column: $table.observacoes, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CadastrosSociaisTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CadastrosSociaisTable,
    CadastrosSociai,
    $$CadastrosSociaisTableFilterComposer,
    $$CadastrosSociaisTableOrderingComposer,
    $$CadastrosSociaisTableAnnotationComposer,
    $$CadastrosSociaisTableCreateCompanionBuilder,
    $$CadastrosSociaisTableUpdateCompanionBuilder,
    (
      CadastrosSociai,
      BaseReferences<_$AppDatabase, $CadastrosSociaisTable, CadastrosSociai>
    ),
    CadastrosSociai,
    PrefetchHooks Function()> {
  $$CadastrosSociaisTableTableManager(
      _$AppDatabase db, $CadastrosSociaisTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CadastrosSociaisTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CadastrosSociaisTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CadastrosSociaisTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> projetoId = const Value.absent(),
            Value<String?> selagemId = const Value.absent(),
            Value<String> codigoSelo = const Value.absent(),
            Value<String> nomeResponsavel = const Value.absent(),
            Value<String?> cpfResponsavel = const Value.absent(),
            Value<String?> rgResponsavel = const Value.absent(),
            Value<String?> orgaoEmissor = const Value.absent(),
            Value<String?> estadoCivil = const Value.absent(),
            Value<String?> profissao = const Value.absent(),
            Value<String?> telefone = const Value.absent(),
            Value<int?> quantidadeMoradores = const Value.absent(),
            Value<double?> rendaFamiliar = const Value.absent(),
            Value<bool> recebeProgramaSocial = const Value.absent(),
            Value<String?> programaSocial = const Value.absent(),
            Value<int?> tempoOcupacaoAnos = const Value.absent(),
            Value<String?> formaOcupacao = const Value.absent(),
            Value<String?> documentoPosse = const Value.absent(),
            Value<bool> possuiOutroImovel = const Value.absent(),
            Value<bool> possuiConflito = const Value.absent(),
            Value<String?> observacoes = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CadastrosSociaisCompanion(
            id: id,
            projetoId: projetoId,
            selagemId: selagemId,
            codigoSelo: codigoSelo,
            nomeResponsavel: nomeResponsavel,
            cpfResponsavel: cpfResponsavel,
            rgResponsavel: rgResponsavel,
            orgaoEmissor: orgaoEmissor,
            estadoCivil: estadoCivil,
            profissao: profissao,
            telefone: telefone,
            quantidadeMoradores: quantidadeMoradores,
            rendaFamiliar: rendaFamiliar,
            recebeProgramaSocial: recebeProgramaSocial,
            programaSocial: programaSocial,
            tempoOcupacaoAnos: tempoOcupacaoAnos,
            formaOcupacao: formaOcupacao,
            documentoPosse: documentoPosse,
            possuiOutroImovel: possuiOutroImovel,
            possuiConflito: possuiConflito,
            observacoes: observacoes,
            synced: synced,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String projetoId,
            Value<String?> selagemId = const Value.absent(),
            required String codigoSelo,
            required String nomeResponsavel,
            Value<String?> cpfResponsavel = const Value.absent(),
            Value<String?> rgResponsavel = const Value.absent(),
            Value<String?> orgaoEmissor = const Value.absent(),
            Value<String?> estadoCivil = const Value.absent(),
            Value<String?> profissao = const Value.absent(),
            Value<String?> telefone = const Value.absent(),
            Value<int?> quantidadeMoradores = const Value.absent(),
            Value<double?> rendaFamiliar = const Value.absent(),
            Value<bool> recebeProgramaSocial = const Value.absent(),
            Value<String?> programaSocial = const Value.absent(),
            Value<int?> tempoOcupacaoAnos = const Value.absent(),
            Value<String?> formaOcupacao = const Value.absent(),
            Value<String?> documentoPosse = const Value.absent(),
            Value<bool> possuiOutroImovel = const Value.absent(),
            Value<bool> possuiConflito = const Value.absent(),
            Value<String?> observacoes = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CadastrosSociaisCompanion.insert(
            id: id,
            projetoId: projetoId,
            selagemId: selagemId,
            codigoSelo: codigoSelo,
            nomeResponsavel: nomeResponsavel,
            cpfResponsavel: cpfResponsavel,
            rgResponsavel: rgResponsavel,
            orgaoEmissor: orgaoEmissor,
            estadoCivil: estadoCivil,
            profissao: profissao,
            telefone: telefone,
            quantidadeMoradores: quantidadeMoradores,
            rendaFamiliar: rendaFamiliar,
            recebeProgramaSocial: recebeProgramaSocial,
            programaSocial: programaSocial,
            tempoOcupacaoAnos: tempoOcupacaoAnos,
            formaOcupacao: formaOcupacao,
            documentoPosse: documentoPosse,
            possuiOutroImovel: possuiOutroImovel,
            possuiConflito: possuiConflito,
            observacoes: observacoes,
            synced: synced,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CadastrosSociaisTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CadastrosSociaisTable,
    CadastrosSociai,
    $$CadastrosSociaisTableFilterComposer,
    $$CadastrosSociaisTableOrderingComposer,
    $$CadastrosSociaisTableAnnotationComposer,
    $$CadastrosSociaisTableCreateCompanionBuilder,
    $$CadastrosSociaisTableUpdateCompanionBuilder,
    (
      CadastrosSociai,
      BaseReferences<_$AppDatabase, $CadastrosSociaisTable, CadastrosSociai>
    ),
    CadastrosSociai,
    PrefetchHooks Function()>;
typedef $$DocumentosReurbTableCreateCompanionBuilder = DocumentosReurbCompanion
    Function({
  required String id,
  required String projetoId,
  Value<String?> selagemId,
  Value<String?> cadastroSocialId,
  required String codigoSelo,
  required String tipoDocumento,
  required String arquivoPath,
  Value<String?> observacoes,
  Value<bool> synced,
  Value<String?> sourceDeviceId,
  Value<String> syncStatus,
  Value<int> syncAttempts,
  Value<String?> syncError,
  Value<DateTime?> lastSyncAttemptAt,
  Value<DateTime?> syncedAt,
  Value<DateTime> localUpdatedAt,
  Value<DateTime?> serverUpdatedAt,
  Value<int> syncVersion,
  Value<bool> deletedLocally,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$DocumentosReurbTableUpdateCompanionBuilder = DocumentosReurbCompanion
    Function({
  Value<String> id,
  Value<String> projetoId,
  Value<String?> selagemId,
  Value<String?> cadastroSocialId,
  Value<String> codigoSelo,
  Value<String> tipoDocumento,
  Value<String> arquivoPath,
  Value<String?> observacoes,
  Value<bool> synced,
  Value<String?> sourceDeviceId,
  Value<String> syncStatus,
  Value<int> syncAttempts,
  Value<String?> syncError,
  Value<DateTime?> lastSyncAttemptAt,
  Value<DateTime?> syncedAt,
  Value<DateTime> localUpdatedAt,
  Value<DateTime?> serverUpdatedAt,
  Value<int> syncVersion,
  Value<bool> deletedLocally,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$DocumentosReurbTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentosReurbTable> {
  $$DocumentosReurbTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get projetoId => $composableBuilder(
      column: $table.projetoId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get selagemId => $composableBuilder(
      column: $table.selagemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cadastroSocialId => $composableBuilder(
      column: $table.cadastroSocialId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get codigoSelo => $composableBuilder(
      column: $table.codigoSelo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tipoDocumento => $composableBuilder(
      column: $table.tipoDocumento, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get arquivoPath => $composableBuilder(
      column: $table.arquivoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get observacoes => $composableBuilder(
      column: $table.observacoes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceDeviceId => $composableBuilder(
      column: $table.sourceDeviceId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get syncAttempts => $composableBuilder(
      column: $table.syncAttempts, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncError => $composableBuilder(
      column: $table.syncError, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncAttemptAt => $composableBuilder(
      column: $table.lastSyncAttemptAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get syncVersion => $composableBuilder(
      column: $table.syncVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deletedLocally => $composableBuilder(
      column: $table.deletedLocally,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$DocumentosReurbTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentosReurbTable> {
  $$DocumentosReurbTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get projetoId => $composableBuilder(
      column: $table.projetoId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get selagemId => $composableBuilder(
      column: $table.selagemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cadastroSocialId => $composableBuilder(
      column: $table.cadastroSocialId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get codigoSelo => $composableBuilder(
      column: $table.codigoSelo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tipoDocumento => $composableBuilder(
      column: $table.tipoDocumento,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get arquivoPath => $composableBuilder(
      column: $table.arquivoPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get observacoes => $composableBuilder(
      column: $table.observacoes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceDeviceId => $composableBuilder(
      column: $table.sourceDeviceId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get syncAttempts => $composableBuilder(
      column: $table.syncAttempts,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncError => $composableBuilder(
      column: $table.syncError, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncAttemptAt => $composableBuilder(
      column: $table.lastSyncAttemptAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get syncVersion => $composableBuilder(
      column: $table.syncVersion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deletedLocally => $composableBuilder(
      column: $table.deletedLocally,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$DocumentosReurbTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentosReurbTable> {
  $$DocumentosReurbTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get projetoId =>
      $composableBuilder(column: $table.projetoId, builder: (column) => column);

  GeneratedColumn<String> get selagemId =>
      $composableBuilder(column: $table.selagemId, builder: (column) => column);

  GeneratedColumn<String> get cadastroSocialId => $composableBuilder(
      column: $table.cadastroSocialId, builder: (column) => column);

  GeneratedColumn<String> get codigoSelo => $composableBuilder(
      column: $table.codigoSelo, builder: (column) => column);

  GeneratedColumn<String> get tipoDocumento => $composableBuilder(
      column: $table.tipoDocumento, builder: (column) => column);

  GeneratedColumn<String> get arquivoPath => $composableBuilder(
      column: $table.arquivoPath, builder: (column) => column);

  GeneratedColumn<String> get observacoes => $composableBuilder(
      column: $table.observacoes, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<String> get sourceDeviceId => $composableBuilder(
      column: $table.sourceDeviceId, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<int> get syncAttempts => $composableBuilder(
      column: $table.syncAttempts, builder: (column) => column);

  GeneratedColumn<String> get syncError =>
      $composableBuilder(column: $table.syncError, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncAttemptAt => $composableBuilder(
      column: $table.lastSyncAttemptAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt, builder: (column) => column);

  GeneratedColumn<int> get syncVersion => $composableBuilder(
      column: $table.syncVersion, builder: (column) => column);

  GeneratedColumn<bool> get deletedLocally => $composableBuilder(
      column: $table.deletedLocally, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DocumentosReurbTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DocumentosReurbTable,
    DocumentosReurbData,
    $$DocumentosReurbTableFilterComposer,
    $$DocumentosReurbTableOrderingComposer,
    $$DocumentosReurbTableAnnotationComposer,
    $$DocumentosReurbTableCreateCompanionBuilder,
    $$DocumentosReurbTableUpdateCompanionBuilder,
    (
      DocumentosReurbData,
      BaseReferences<_$AppDatabase, $DocumentosReurbTable, DocumentosReurbData>
    ),
    DocumentosReurbData,
    PrefetchHooks Function()> {
  $$DocumentosReurbTableTableManager(
      _$AppDatabase db, $DocumentosReurbTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentosReurbTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentosReurbTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentosReurbTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> projetoId = const Value.absent(),
            Value<String?> selagemId = const Value.absent(),
            Value<String?> cadastroSocialId = const Value.absent(),
            Value<String> codigoSelo = const Value.absent(),
            Value<String> tipoDocumento = const Value.absent(),
            Value<String> arquivoPath = const Value.absent(),
            Value<String?> observacoes = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<String?> sourceDeviceId = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> syncAttempts = const Value.absent(),
            Value<String?> syncError = const Value.absent(),
            Value<DateTime?> lastSyncAttemptAt = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<DateTime> localUpdatedAt = const Value.absent(),
            Value<DateTime?> serverUpdatedAt = const Value.absent(),
            Value<int> syncVersion = const Value.absent(),
            Value<bool> deletedLocally = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DocumentosReurbCompanion(
            id: id,
            projetoId: projetoId,
            selagemId: selagemId,
            cadastroSocialId: cadastroSocialId,
            codigoSelo: codigoSelo,
            tipoDocumento: tipoDocumento,
            arquivoPath: arquivoPath,
            observacoes: observacoes,
            synced: synced,
            sourceDeviceId: sourceDeviceId,
            syncStatus: syncStatus,
            syncAttempts: syncAttempts,
            syncError: syncError,
            lastSyncAttemptAt: lastSyncAttemptAt,
            syncedAt: syncedAt,
            localUpdatedAt: localUpdatedAt,
            serverUpdatedAt: serverUpdatedAt,
            syncVersion: syncVersion,
            deletedLocally: deletedLocally,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String projetoId,
            Value<String?> selagemId = const Value.absent(),
            Value<String?> cadastroSocialId = const Value.absent(),
            required String codigoSelo,
            required String tipoDocumento,
            required String arquivoPath,
            Value<String?> observacoes = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<String?> sourceDeviceId = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> syncAttempts = const Value.absent(),
            Value<String?> syncError = const Value.absent(),
            Value<DateTime?> lastSyncAttemptAt = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<DateTime> localUpdatedAt = const Value.absent(),
            Value<DateTime?> serverUpdatedAt = const Value.absent(),
            Value<int> syncVersion = const Value.absent(),
            Value<bool> deletedLocally = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DocumentosReurbCompanion.insert(
            id: id,
            projetoId: projetoId,
            selagemId: selagemId,
            cadastroSocialId: cadastroSocialId,
            codigoSelo: codigoSelo,
            tipoDocumento: tipoDocumento,
            arquivoPath: arquivoPath,
            observacoes: observacoes,
            synced: synced,
            sourceDeviceId: sourceDeviceId,
            syncStatus: syncStatus,
            syncAttempts: syncAttempts,
            syncError: syncError,
            lastSyncAttemptAt: lastSyncAttemptAt,
            syncedAt: syncedAt,
            localUpdatedAt: localUpdatedAt,
            serverUpdatedAt: serverUpdatedAt,
            syncVersion: syncVersion,
            deletedLocally: deletedLocally,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DocumentosReurbTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DocumentosReurbTable,
    DocumentosReurbData,
    $$DocumentosReurbTableFilterComposer,
    $$DocumentosReurbTableOrderingComposer,
    $$DocumentosReurbTableAnnotationComposer,
    $$DocumentosReurbTableCreateCompanionBuilder,
    $$DocumentosReurbTableUpdateCompanionBuilder,
    (
      DocumentosReurbData,
      BaseReferences<_$AppDatabase, $DocumentosReurbTable, DocumentosReurbData>
    ),
    DocumentosReurbData,
    PrefetchHooks Function()>;
typedef $$LotesPreliminaresTableCreateCompanionBuilder
    = LotesPreliminaresCompanion Function({
  required String id,
  required String projetoId,
  required String codigoLote,
  Value<String?> quadra,
  Value<double?> areaM2,
  Value<double?> perimetroM,
  Value<String?> geometriaGeojson,
  Value<String?> origemArquivo,
  Value<String?> tipoGeometria,
  Value<String> statusLote,
  Value<bool> necessitaRevisao,
  Value<String?> observacoes,
  Value<bool> synced,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$LotesPreliminaresTableUpdateCompanionBuilder
    = LotesPreliminaresCompanion Function({
  Value<String> id,
  Value<String> projetoId,
  Value<String> codigoLote,
  Value<String?> quadra,
  Value<double?> areaM2,
  Value<double?> perimetroM,
  Value<String?> geometriaGeojson,
  Value<String?> origemArquivo,
  Value<String?> tipoGeometria,
  Value<String> statusLote,
  Value<bool> necessitaRevisao,
  Value<String?> observacoes,
  Value<bool> synced,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$LotesPreliminaresTableFilterComposer
    extends Composer<_$AppDatabase, $LotesPreliminaresTable> {
  $$LotesPreliminaresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get projetoId => $composableBuilder(
      column: $table.projetoId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get codigoLote => $composableBuilder(
      column: $table.codigoLote, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get quadra => $composableBuilder(
      column: $table.quadra, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get areaM2 => $composableBuilder(
      column: $table.areaM2, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get perimetroM => $composableBuilder(
      column: $table.perimetroM, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get geometriaGeojson => $composableBuilder(
      column: $table.geometriaGeojson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get origemArquivo => $composableBuilder(
      column: $table.origemArquivo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tipoGeometria => $composableBuilder(
      column: $table.tipoGeometria, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get statusLote => $composableBuilder(
      column: $table.statusLote, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get necessitaRevisao => $composableBuilder(
      column: $table.necessitaRevisao,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get observacoes => $composableBuilder(
      column: $table.observacoes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$LotesPreliminaresTableOrderingComposer
    extends Composer<_$AppDatabase, $LotesPreliminaresTable> {
  $$LotesPreliminaresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get projetoId => $composableBuilder(
      column: $table.projetoId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get codigoLote => $composableBuilder(
      column: $table.codigoLote, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get quadra => $composableBuilder(
      column: $table.quadra, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get areaM2 => $composableBuilder(
      column: $table.areaM2, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get perimetroM => $composableBuilder(
      column: $table.perimetroM, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get geometriaGeojson => $composableBuilder(
      column: $table.geometriaGeojson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get origemArquivo => $composableBuilder(
      column: $table.origemArquivo,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tipoGeometria => $composableBuilder(
      column: $table.tipoGeometria,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get statusLote => $composableBuilder(
      column: $table.statusLote, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get necessitaRevisao => $composableBuilder(
      column: $table.necessitaRevisao,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get observacoes => $composableBuilder(
      column: $table.observacoes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$LotesPreliminaresTableAnnotationComposer
    extends Composer<_$AppDatabase, $LotesPreliminaresTable> {
  $$LotesPreliminaresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get projetoId =>
      $composableBuilder(column: $table.projetoId, builder: (column) => column);

  GeneratedColumn<String> get codigoLote => $composableBuilder(
      column: $table.codigoLote, builder: (column) => column);

  GeneratedColumn<String> get quadra =>
      $composableBuilder(column: $table.quadra, builder: (column) => column);

  GeneratedColumn<double> get areaM2 =>
      $composableBuilder(column: $table.areaM2, builder: (column) => column);

  GeneratedColumn<double> get perimetroM => $composableBuilder(
      column: $table.perimetroM, builder: (column) => column);

  GeneratedColumn<String> get geometriaGeojson => $composableBuilder(
      column: $table.geometriaGeojson, builder: (column) => column);

  GeneratedColumn<String> get origemArquivo => $composableBuilder(
      column: $table.origemArquivo, builder: (column) => column);

  GeneratedColumn<String> get tipoGeometria => $composableBuilder(
      column: $table.tipoGeometria, builder: (column) => column);

  GeneratedColumn<String> get statusLote => $composableBuilder(
      column: $table.statusLote, builder: (column) => column);

  GeneratedColumn<bool> get necessitaRevisao => $composableBuilder(
      column: $table.necessitaRevisao, builder: (column) => column);

  GeneratedColumn<String> get observacoes => $composableBuilder(
      column: $table.observacoes, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$LotesPreliminaresTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LotesPreliminaresTable,
    LotesPreliminare,
    $$LotesPreliminaresTableFilterComposer,
    $$LotesPreliminaresTableOrderingComposer,
    $$LotesPreliminaresTableAnnotationComposer,
    $$LotesPreliminaresTableCreateCompanionBuilder,
    $$LotesPreliminaresTableUpdateCompanionBuilder,
    (
      LotesPreliminare,
      BaseReferences<_$AppDatabase, $LotesPreliminaresTable, LotesPreliminare>
    ),
    LotesPreliminare,
    PrefetchHooks Function()> {
  $$LotesPreliminaresTableTableManager(
      _$AppDatabase db, $LotesPreliminaresTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LotesPreliminaresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LotesPreliminaresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LotesPreliminaresTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> projetoId = const Value.absent(),
            Value<String> codigoLote = const Value.absent(),
            Value<String?> quadra = const Value.absent(),
            Value<double?> areaM2 = const Value.absent(),
            Value<double?> perimetroM = const Value.absent(),
            Value<String?> geometriaGeojson = const Value.absent(),
            Value<String?> origemArquivo = const Value.absent(),
            Value<String?> tipoGeometria = const Value.absent(),
            Value<String> statusLote = const Value.absent(),
            Value<bool> necessitaRevisao = const Value.absent(),
            Value<String?> observacoes = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LotesPreliminaresCompanion(
            id: id,
            projetoId: projetoId,
            codigoLote: codigoLote,
            quadra: quadra,
            areaM2: areaM2,
            perimetroM: perimetroM,
            geometriaGeojson: geometriaGeojson,
            origemArquivo: origemArquivo,
            tipoGeometria: tipoGeometria,
            statusLote: statusLote,
            necessitaRevisao: necessitaRevisao,
            observacoes: observacoes,
            synced: synced,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String projetoId,
            required String codigoLote,
            Value<String?> quadra = const Value.absent(),
            Value<double?> areaM2 = const Value.absent(),
            Value<double?> perimetroM = const Value.absent(),
            Value<String?> geometriaGeojson = const Value.absent(),
            Value<String?> origemArquivo = const Value.absent(),
            Value<String?> tipoGeometria = const Value.absent(),
            Value<String> statusLote = const Value.absent(),
            Value<bool> necessitaRevisao = const Value.absent(),
            Value<String?> observacoes = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LotesPreliminaresCompanion.insert(
            id: id,
            projetoId: projetoId,
            codigoLote: codigoLote,
            quadra: quadra,
            areaM2: areaM2,
            perimetroM: perimetroM,
            geometriaGeojson: geometriaGeojson,
            origemArquivo: origemArquivo,
            tipoGeometria: tipoGeometria,
            statusLote: statusLote,
            necessitaRevisao: necessitaRevisao,
            observacoes: observacoes,
            synced: synced,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LotesPreliminaresTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LotesPreliminaresTable,
    LotesPreliminare,
    $$LotesPreliminaresTableFilterComposer,
    $$LotesPreliminaresTableOrderingComposer,
    $$LotesPreliminaresTableAnnotationComposer,
    $$LotesPreliminaresTableCreateCompanionBuilder,
    $$LotesPreliminaresTableUpdateCompanionBuilder,
    (
      LotesPreliminare,
      BaseReferences<_$AppDatabase, $LotesPreliminaresTable, LotesPreliminare>
    ),
    LotesPreliminare,
    PrefetchHooks Function()>;
typedef $$LotesVetorizadosCidadaoTableCreateCompanionBuilder
    = LotesVetorizadosCidadaoCompanion Function({
  required String id,
  Value<String?> projetoId,
  Value<String?> selagemId,
  Value<String?> cadastroSocialId,
  Value<String?> codigoSelo,
  Value<String?> codigoLote,
  Value<String> origem,
  Value<String> status,
  required String geometriaGeojson,
  Value<double?> areaM2,
  Value<double?> perimetroM,
  Value<String?> observacoes,
  Value<String?> printPath,
  Value<bool> synced,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$LotesVetorizadosCidadaoTableUpdateCompanionBuilder
    = LotesVetorizadosCidadaoCompanion Function({
  Value<String> id,
  Value<String?> projetoId,
  Value<String?> selagemId,
  Value<String?> cadastroSocialId,
  Value<String?> codigoSelo,
  Value<String?> codigoLote,
  Value<String> origem,
  Value<String> status,
  Value<String> geometriaGeojson,
  Value<double?> areaM2,
  Value<double?> perimetroM,
  Value<String?> observacoes,
  Value<String?> printPath,
  Value<bool> synced,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$LotesVetorizadosCidadaoTableFilterComposer
    extends Composer<_$AppDatabase, $LotesVetorizadosCidadaoTable> {
  $$LotesVetorizadosCidadaoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get projetoId => $composableBuilder(
      column: $table.projetoId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get selagemId => $composableBuilder(
      column: $table.selagemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cadastroSocialId => $composableBuilder(
      column: $table.cadastroSocialId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get codigoSelo => $composableBuilder(
      column: $table.codigoSelo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get codigoLote => $composableBuilder(
      column: $table.codigoLote, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get origem => $composableBuilder(
      column: $table.origem, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get geometriaGeojson => $composableBuilder(
      column: $table.geometriaGeojson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get areaM2 => $composableBuilder(
      column: $table.areaM2, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get perimetroM => $composableBuilder(
      column: $table.perimetroM, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get observacoes => $composableBuilder(
      column: $table.observacoes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get printPath => $composableBuilder(
      column: $table.printPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$LotesVetorizadosCidadaoTableOrderingComposer
    extends Composer<_$AppDatabase, $LotesVetorizadosCidadaoTable> {
  $$LotesVetorizadosCidadaoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get projetoId => $composableBuilder(
      column: $table.projetoId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get selagemId => $composableBuilder(
      column: $table.selagemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cadastroSocialId => $composableBuilder(
      column: $table.cadastroSocialId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get codigoSelo => $composableBuilder(
      column: $table.codigoSelo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get codigoLote => $composableBuilder(
      column: $table.codigoLote, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get origem => $composableBuilder(
      column: $table.origem, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get geometriaGeojson => $composableBuilder(
      column: $table.geometriaGeojson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get areaM2 => $composableBuilder(
      column: $table.areaM2, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get perimetroM => $composableBuilder(
      column: $table.perimetroM, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get observacoes => $composableBuilder(
      column: $table.observacoes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get printPath => $composableBuilder(
      column: $table.printPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$LotesVetorizadosCidadaoTableAnnotationComposer
    extends Composer<_$AppDatabase, $LotesVetorizadosCidadaoTable> {
  $$LotesVetorizadosCidadaoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get projetoId =>
      $composableBuilder(column: $table.projetoId, builder: (column) => column);

  GeneratedColumn<String> get selagemId =>
      $composableBuilder(column: $table.selagemId, builder: (column) => column);

  GeneratedColumn<String> get cadastroSocialId => $composableBuilder(
      column: $table.cadastroSocialId, builder: (column) => column);

  GeneratedColumn<String> get codigoSelo => $composableBuilder(
      column: $table.codigoSelo, builder: (column) => column);

  GeneratedColumn<String> get codigoLote => $composableBuilder(
      column: $table.codigoLote, builder: (column) => column);

  GeneratedColumn<String> get origem =>
      $composableBuilder(column: $table.origem, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get geometriaGeojson => $composableBuilder(
      column: $table.geometriaGeojson, builder: (column) => column);

  GeneratedColumn<double> get areaM2 =>
      $composableBuilder(column: $table.areaM2, builder: (column) => column);

  GeneratedColumn<double> get perimetroM => $composableBuilder(
      column: $table.perimetroM, builder: (column) => column);

  GeneratedColumn<String> get observacoes => $composableBuilder(
      column: $table.observacoes, builder: (column) => column);

  GeneratedColumn<String> get printPath =>
      $composableBuilder(column: $table.printPath, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LotesVetorizadosCidadaoTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LotesVetorizadosCidadaoTable,
    LotesVetorizadosCidadaoData,
    $$LotesVetorizadosCidadaoTableFilterComposer,
    $$LotesVetorizadosCidadaoTableOrderingComposer,
    $$LotesVetorizadosCidadaoTableAnnotationComposer,
    $$LotesVetorizadosCidadaoTableCreateCompanionBuilder,
    $$LotesVetorizadosCidadaoTableUpdateCompanionBuilder,
    (
      LotesVetorizadosCidadaoData,
      BaseReferences<_$AppDatabase, $LotesVetorizadosCidadaoTable,
          LotesVetorizadosCidadaoData>
    ),
    LotesVetorizadosCidadaoData,
    PrefetchHooks Function()> {
  $$LotesVetorizadosCidadaoTableTableManager(
      _$AppDatabase db, $LotesVetorizadosCidadaoTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LotesVetorizadosCidadaoTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$LotesVetorizadosCidadaoTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LotesVetorizadosCidadaoTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> projetoId = const Value.absent(),
            Value<String?> selagemId = const Value.absent(),
            Value<String?> cadastroSocialId = const Value.absent(),
            Value<String?> codigoSelo = const Value.absent(),
            Value<String?> codigoLote = const Value.absent(),
            Value<String> origem = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> geometriaGeojson = const Value.absent(),
            Value<double?> areaM2 = const Value.absent(),
            Value<double?> perimetroM = const Value.absent(),
            Value<String?> observacoes = const Value.absent(),
            Value<String?> printPath = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LotesVetorizadosCidadaoCompanion(
            id: id,
            projetoId: projetoId,
            selagemId: selagemId,
            cadastroSocialId: cadastroSocialId,
            codigoSelo: codigoSelo,
            codigoLote: codigoLote,
            origem: origem,
            status: status,
            geometriaGeojson: geometriaGeojson,
            areaM2: areaM2,
            perimetroM: perimetroM,
            observacoes: observacoes,
            printPath: printPath,
            synced: synced,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> projetoId = const Value.absent(),
            Value<String?> selagemId = const Value.absent(),
            Value<String?> cadastroSocialId = const Value.absent(),
            Value<String?> codigoSelo = const Value.absent(),
            Value<String?> codigoLote = const Value.absent(),
            Value<String> origem = const Value.absent(),
            Value<String> status = const Value.absent(),
            required String geometriaGeojson,
            Value<double?> areaM2 = const Value.absent(),
            Value<double?> perimetroM = const Value.absent(),
            Value<String?> observacoes = const Value.absent(),
            Value<String?> printPath = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LotesVetorizadosCidadaoCompanion.insert(
            id: id,
            projetoId: projetoId,
            selagemId: selagemId,
            cadastroSocialId: cadastroSocialId,
            codigoSelo: codigoSelo,
            codigoLote: codigoLote,
            origem: origem,
            status: status,
            geometriaGeojson: geometriaGeojson,
            areaM2: areaM2,
            perimetroM: perimetroM,
            observacoes: observacoes,
            printPath: printPath,
            synced: synced,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LotesVetorizadosCidadaoTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $LotesVetorizadosCidadaoTable,
        LotesVetorizadosCidadaoData,
        $$LotesVetorizadosCidadaoTableFilterComposer,
        $$LotesVetorizadosCidadaoTableOrderingComposer,
        $$LotesVetorizadosCidadaoTableAnnotationComposer,
        $$LotesVetorizadosCidadaoTableCreateCompanionBuilder,
        $$LotesVetorizadosCidadaoTableUpdateCompanionBuilder,
        (
          LotesVetorizadosCidadaoData,
          BaseReferences<_$AppDatabase, $LotesVetorizadosCidadaoTable,
              LotesVetorizadosCidadaoData>
        ),
        LotesVetorizadosCidadaoData,
        PrefetchHooks Function()>;
typedef $$MobileSealCodeReservationsTableCreateCompanionBuilder
    = MobileSealCodeReservationsCompanion Function({
  required String id,
  required String projectId,
  required String deviceId,
  required String prefix,
  required int startNumber,
  required int endNumber,
  required int nextNumber,
  required int quantity,
  Value<bool> active,
  Value<DateTime?> expiresAt,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$MobileSealCodeReservationsTableUpdateCompanionBuilder
    = MobileSealCodeReservationsCompanion Function({
  Value<String> id,
  Value<String> projectId,
  Value<String> deviceId,
  Value<String> prefix,
  Value<int> startNumber,
  Value<int> endNumber,
  Value<int> nextNumber,
  Value<int> quantity,
  Value<bool> active,
  Value<DateTime?> expiresAt,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$MobileSealCodeReservationsTableFilterComposer
    extends Composer<_$AppDatabase, $MobileSealCodeReservationsTable> {
  $$MobileSealCodeReservationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get projectId => $composableBuilder(
      column: $table.projectId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get prefix => $composableBuilder(
      column: $table.prefix, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get startNumber => $composableBuilder(
      column: $table.startNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get endNumber => $composableBuilder(
      column: $table.endNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get nextNumber => $composableBuilder(
      column: $table.nextNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$MobileSealCodeReservationsTableOrderingComposer
    extends Composer<_$AppDatabase, $MobileSealCodeReservationsTable> {
  $$MobileSealCodeReservationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get projectId => $composableBuilder(
      column: $table.projectId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get prefix => $composableBuilder(
      column: $table.prefix, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get startNumber => $composableBuilder(
      column: $table.startNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get endNumber => $composableBuilder(
      column: $table.endNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get nextNumber => $composableBuilder(
      column: $table.nextNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$MobileSealCodeReservationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MobileSealCodeReservationsTable> {
  $$MobileSealCodeReservationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get prefix =>
      $composableBuilder(column: $table.prefix, builder: (column) => column);

  GeneratedColumn<int> get startNumber => $composableBuilder(
      column: $table.startNumber, builder: (column) => column);

  GeneratedColumn<int> get endNumber =>
      $composableBuilder(column: $table.endNumber, builder: (column) => column);

  GeneratedColumn<int> get nextNumber => $composableBuilder(
      column: $table.nextNumber, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MobileSealCodeReservationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MobileSealCodeReservationsTable,
    MobileSealCodeReservation,
    $$MobileSealCodeReservationsTableFilterComposer,
    $$MobileSealCodeReservationsTableOrderingComposer,
    $$MobileSealCodeReservationsTableAnnotationComposer,
    $$MobileSealCodeReservationsTableCreateCompanionBuilder,
    $$MobileSealCodeReservationsTableUpdateCompanionBuilder,
    (
      MobileSealCodeReservation,
      BaseReferences<_$AppDatabase, $MobileSealCodeReservationsTable,
          MobileSealCodeReservation>
    ),
    MobileSealCodeReservation,
    PrefetchHooks Function()> {
  $$MobileSealCodeReservationsTableTableManager(
      _$AppDatabase db, $MobileSealCodeReservationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MobileSealCodeReservationsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$MobileSealCodeReservationsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MobileSealCodeReservationsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> projectId = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<String> prefix = const Value.absent(),
            Value<int> startNumber = const Value.absent(),
            Value<int> endNumber = const Value.absent(),
            Value<int> nextNumber = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<bool> active = const Value.absent(),
            Value<DateTime?> expiresAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MobileSealCodeReservationsCompanion(
            id: id,
            projectId: projectId,
            deviceId: deviceId,
            prefix: prefix,
            startNumber: startNumber,
            endNumber: endNumber,
            nextNumber: nextNumber,
            quantity: quantity,
            active: active,
            expiresAt: expiresAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String projectId,
            required String deviceId,
            required String prefix,
            required int startNumber,
            required int endNumber,
            required int nextNumber,
            required int quantity,
            Value<bool> active = const Value.absent(),
            Value<DateTime?> expiresAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MobileSealCodeReservationsCompanion.insert(
            id: id,
            projectId: projectId,
            deviceId: deviceId,
            prefix: prefix,
            startNumber: startNumber,
            endNumber: endNumber,
            nextNumber: nextNumber,
            quantity: quantity,
            active: active,
            expiresAt: expiresAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MobileSealCodeReservationsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $MobileSealCodeReservationsTable,
        MobileSealCodeReservation,
        $$MobileSealCodeReservationsTableFilterComposer,
        $$MobileSealCodeReservationsTableOrderingComposer,
        $$MobileSealCodeReservationsTableAnnotationComposer,
        $$MobileSealCodeReservationsTableCreateCompanionBuilder,
        $$MobileSealCodeReservationsTableUpdateCompanionBuilder,
        (
          MobileSealCodeReservation,
          BaseReferences<_$AppDatabase, $MobileSealCodeReservationsTable,
              MobileSealCodeReservation>
        ),
        MobileSealCodeReservation,
        PrefetchHooks Function()>;
typedef $$SyncQueueTableCreateCompanionBuilder = SyncQueueCompanion Function({
  required String id,
  required String entityType,
  required String entityId,
  Value<String> operation,
  required String projectId,
  Value<String?> payloadJson,
  Value<String> status,
  Value<int> attempts,
  Value<String?> lastError,
  Value<DateTime?> nextAttemptAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$SyncQueueTableUpdateCompanionBuilder = SyncQueueCompanion Function({
  Value<String> id,
  Value<String> entityType,
  Value<String> entityId,
  Value<String> operation,
  Value<String> projectId,
  Value<String?> payloadJson,
  Value<String> status,
  Value<int> attempts,
  Value<String?> lastError,
  Value<DateTime?> nextAttemptAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get projectId => $composableBuilder(
      column: $table.projectId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextAttemptAt => $composableBuilder(
      column: $table.nextAttemptAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get projectId => $composableBuilder(
      column: $table.projectId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextAttemptAt => $composableBuilder(
      column: $table.nextAttemptAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get nextAttemptAt => $composableBuilder(
      column: $table.nextAttemptAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SyncQueueTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueData,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueData,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>
    ),
    SyncQueueData,
    PrefetchHooks Function()> {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<String> entityId = const Value.absent(),
            Value<String> operation = const Value.absent(),
            Value<String> projectId = const Value.absent(),
            Value<String?> payloadJson = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> attempts = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<DateTime?> nextAttemptAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncQueueCompanion(
            id: id,
            entityType: entityType,
            entityId: entityId,
            operation: operation,
            projectId: projectId,
            payloadJson: payloadJson,
            status: status,
            attempts: attempts,
            lastError: lastError,
            nextAttemptAt: nextAttemptAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String entityType,
            required String entityId,
            Value<String> operation = const Value.absent(),
            required String projectId,
            Value<String?> payloadJson = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> attempts = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<DateTime?> nextAttemptAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncQueueCompanion.insert(
            id: id,
            entityType: entityType,
            entityId: entityId,
            operation: operation,
            projectId: projectId,
            payloadJson: payloadJson,
            status: status,
            attempts: attempts,
            lastError: lastError,
            nextAttemptAt: nextAttemptAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncQueueTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueData,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueData,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>
    ),
    SyncQueueData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProjetosTableTableManager get projetos =>
      $$ProjetosTableTableManager(_db, _db.projetos);
  $$LotesTableTableManager get lotes =>
      $$LotesTableTableManager(_db, _db.lotes);
  $$BeneficiariosTableTableManager get beneficiarios =>
      $$BeneficiariosTableTableManager(_db, _db.beneficiarios);
  $$SelagensTableTableManager get selagens =>
      $$SelagensTableTableManager(_db, _db.selagens);
  $$CadastrosFisicosTableTableManager get cadastrosFisicos =>
      $$CadastrosFisicosTableTableManager(_db, _db.cadastrosFisicos);
  $$CadastrosSociaisTableTableManager get cadastrosSociais =>
      $$CadastrosSociaisTableTableManager(_db, _db.cadastrosSociais);
  $$DocumentosReurbTableTableManager get documentosReurb =>
      $$DocumentosReurbTableTableManager(_db, _db.documentosReurb);
  $$LotesPreliminaresTableTableManager get lotesPreliminares =>
      $$LotesPreliminaresTableTableManager(_db, _db.lotesPreliminares);
  $$LotesVetorizadosCidadaoTableTableManager get lotesVetorizadosCidadao =>
      $$LotesVetorizadosCidadaoTableTableManager(
          _db, _db.lotesVetorizadosCidadao);
  $$MobileSealCodeReservationsTableTableManager
      get mobileSealCodeReservations =>
          $$MobileSealCodeReservationsTableTableManager(
              _db, _db.mobileSealCodeReservations);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
}
