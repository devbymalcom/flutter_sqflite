import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sqflite/models/first_entity.dart';
import 'package:flutter_sqflite/models/second_entity.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

int kVersion = 1;
String dbName = 'flutter_sqflite.db';

const String tableFirstEntity = 'first_entity';
const String tableSecondEntity = 'second_entity';
const String tableThirdEntity = 'third_entity';

class DatabaseService {
  final lock = Lock(reentrant: true);
  final _updateTriggerController = StreamController<bool>.broadcast();
  Database? db;

  Future<Database?> get ready async => db ??= await lock.synchronized(() async {
        db ??= await _db;
        return db;
      });

  late final Future<Database> _db = () async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);

    return await openDatabase(
      path,
      version: kVersion,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
      onCreate: _onCreate,
    );
  }();

  Future<void> _onCreate(Database db, int version) async {
    db.execute(
      'CREATE TABLE IF NOT EXISTS $tableSecondEntity(id INTEGER PRIMARY KEY, name TEXT, description TEXT)',
    );
    db.execute(
      'CREATE TABLE IF NOT EXISTS $tableFirstEntity(id INTEGER PRIMARY KEY, name TEXT, description TEXT, secondEntityId INTEGER, FOREIGN KEY(secondEntityId) REFERENCES $tableSecondEntity(id) ON DELETE CASCADE)',
    );
  }

  void _triggerUpdate() {
    _updateTriggerController.sink.add(true);
  }

  Future<void> saveFirstEntity(FirstEntity firstEntity) async {
    try {
      if (firstEntity.id != null) {
        await db!.update(tableFirstEntity, firstEntity.toMap(),
            where: 'id = ?', whereArgs: [firstEntity.id]);
      } else {
        await db!.insert(tableFirstEntity, firstEntity.toMap(),
            conflictAlgorithm: ConflictAlgorithm.abort);
      }
    } catch (e) {
      debugPrint('An unexpected error occurred. ${e.toString()}}');
    }
    _triggerUpdate();
  }

  Future<void> saveSecondEntity(SecondEntity secondEntity) async {
    if (secondEntity.id != null) {
      await db!.update(tableSecondEntity, secondEntity.toMap(),
          where: 'id = ?', whereArgs: [secondEntity.id]);
    } else {
      await db!.insert(tableSecondEntity, secondEntity.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    debugPrint('SecondEntity saved');
    _triggerUpdate();
  }

  Stream<List<FirstEntity>> onFirstEntities() {
    late StreamController<List<FirstEntity>> ctlr;
    StreamSubscription? triggerSubscription;

    Future<void> sendUpdate() async {
      var firstentitys = await getFirstEntitys();
      if (!ctlr.isClosed) {
        ctlr.add(firstentitys);
      }
    }

    ctlr = StreamController<List<FirstEntity>>(onListen: () {
      sendUpdate();

      triggerSubscription = _updateTriggerController.stream.listen((_) {
        sendUpdate();
      });
    }, onCancel: () {
      triggerSubscription?.cancel();
    });
    return ctlr.stream;
  }

  Stream<List<SecondEntity>> onSecondEntities() {
    late StreamController<List<SecondEntity>> ctlr;
    StreamSubscription? triggerSubscription;

    Future<void> sendUpdate() async {
      var secondentitys = await getSecondEntitys();
      if (!ctlr.isClosed) {
        ctlr.add(secondentitys);
      }
    }

    ctlr = StreamController<List<SecondEntity>>(onListen: () {
      sendUpdate();

      triggerSubscription = _updateTriggerController.stream.listen((_) {
        sendUpdate();
      });
    }, onCancel: () {
      triggerSubscription?.cancel();
    });
    return ctlr.stream;
  }

  Stream<FirstEntity> onFirstEntity(int? id) {
    late StreamController<FirstEntity> ctlr;
    StreamSubscription? triggerSubscription;

    Future<void> sendUpdate() async {
      var firstentity = await getFirstEntity(id!);
      if (!ctlr.isClosed) {
        ctlr.add(firstentity);
      }
    }

    ctlr = StreamController<FirstEntity>(onListen: () {
      sendUpdate();

      triggerSubscription = _updateTriggerController.stream.listen((_) {
        sendUpdate();
      });
    }, onCancel: () {
      triggerSubscription?.cancel();
    });
    return ctlr.stream;
  }

  Stream<SecondEntity> onSecondEntity(int? id) {
    late StreamController<SecondEntity> ctlr;
    StreamSubscription? triggerSubscription;

    Future<void> sendUpdate() async {
      var secondentity = await getSecondEntity(id!);
      if (!ctlr.isClosed) {
        ctlr.add(secondentity);
      }
    }

    ctlr = StreamController<SecondEntity>(onListen: () {
      sendUpdate();

      triggerSubscription = _updateTriggerController.stream.listen((_) {
        sendUpdate();
      });
    }, onCancel: () {
      triggerSubscription?.cancel();
    });
    return ctlr.stream;
  }

  Future<List<FirstEntity>> getFirstEntitys() async {
    final List<Map<String, dynamic>> maps = await db!.query(tableFirstEntity);
    return List.generate(
        maps.length, (index) => FirstEntity.fromMap(maps[index]));
  }

  Future<List<SecondEntity>> getSecondEntitys() async {
    final List<Map<String, dynamic>> maps = await db!.query(tableSecondEntity);
    return List.generate(
        maps.length, (index) => SecondEntity.fromMap(maps[index]));
  }

  Future<FirstEntity> getFirstEntity(int id) async {
    final List<Map<String, dynamic>> maps =
        await db!.query(tableFirstEntity, where: 'id = ?', whereArgs: [id]);
    return FirstEntity.fromMap(maps[0]);
  }

  Future<SecondEntity> getSecondEntity(int id) async {
    final List<Map<String, dynamic>> maps =
        await db!.query(tableSecondEntity, where: 'id = ?', whereArgs: [id]);
    return SecondEntity.fromMap(maps[0]);
  }

  Future<void> deleteFirstEntity(int id) async {
    await db!.delete(tableFirstEntity, where: 'id = ?', whereArgs: [id]);
    _triggerUpdate();
  }

  Future<void> deleteSecondEntity(int id) async {
    await db!.delete(tableSecondEntity, where: 'id = ?', whereArgs: [id]);
    _triggerUpdate();
  }
}
