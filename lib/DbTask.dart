import 'package:flutter/cupertino.dart';
import 'package:notificaciones/MapTask.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';

class DBTask {
  static Database _dbTask;
  static const String Id = 'control';
  static const String TITLE = 'title';
  static const String BODY = 'body';
  static const String YEAR = 'year';
  static const String MES = 'mes';
  static const String DIA = 'dia';
  static const String HORA = 'hora';
  static const String MINUTOS = 'minutos';
  static const String SEGUNDOS = 'segundos';
  static const String DETALLES = 'detalles';
  static const String TABLE = 'Tasks';
  static const String DB_NAME = 'students04.db';


//creacion de la base de datos

  Future<Database> get db async {
    if (_dbTask != null) {
      return _dbTask;
    }
    else {
      _dbTask = await initDb();
      return _dbTask;
    }
  }

  initDb() async {
    io.Directory appDirectory = await getApplicationDocumentsDirectory();
    print(appDirectory);
    String path = join(appDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }


  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($Id INTEGER PRIMARY KEY, $TITLE TEXT, $BODY TEXT, $DETALLES TEXT, $HORA TEXT, $MINUTOS TEXT, $SEGUNDOS TEXT)");
  }

  Future<List<MapTask>> getTask () async {
    var dbClient = await db;
    List<Map> map = await dbClient.query(TABLE, columns: [Id, TITLE, BODY,DETALLES, HORA, MINUTOS, SEGUNDOS, ]);
    List<MapTask> taskList=[];
    if (map.length > 0) {
      for (int i = 0; i < map.length; i++) {
        taskList.add(MapTask.fromMap(map[i]));
      }
    }
    return taskList;
  }


  Future<MapTask> insert(MapTask maptask) async {
    var dbClient = await db;
    maptask.control = await dbClient.insert(TABLE, maptask.toMap());
    return maptask;
  }

//Delete
  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$Id = ?', whereArgs: [id]);
  }

//Update
  Future<int> update(MapTask maptask) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, maptask.toMap(), where: '$Id = ?',
        whereArgs: [maptask.control]);
  }

}