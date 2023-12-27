import 'dart:io';

import 'package:contactsbuddy/models/contactModel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  String _dbName = "Contact.db";
  int _dbVersion = 1;

  DatabaseHelper.private();

  static final DatabaseHelper instance = DatabaseHelper.private();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await _initDB();
    return _db;
  }

  _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String dbPath = join(dir.toString(), _dbName);
    return await openDatabase(dbPath,
        version: _dbVersion, onCreate: _onCreateDb);
  }
//Creating table
  _onCreateDb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE ${Contact.tblName}(
    ${Contact.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${Contact.colTitle} TEXT,
    ${Contact.colDate} TEXT,
    ${Contact.colPriority} TEXT,
    )
    ''');
  }

//Inserting tasks
  Future<int> insertTask(Contact contact) async {
    Database db = await this.db;
    return await db.insert(Contact.tblName, contact.toMap());
  }

//Fetching the tasks
  Future<List<Contact>> fetchTask(String contactname) async {
    Database db = await this.db;
    final List<Map> tasks = await db.rawQuery("SELECT * FROM Contact_table WHERE title LIKE '$contactname%'");
    final List<Contact> tasksList =
    contacts.length == 0 ? [] : contacts.map((e) => Contact.fromMap(e)).toList();
    tasksList.sort((taskA, taskB) => taskA.date.compareTo(taskB.date));
    return tasksList;
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(Task.tblName);
    return result;
  }
//Updating the tasks
  Future updateTask(Task task) async {
    Database db = await this.db;
    return await db.update(Task.tblName, task.toMap(),
        where: '${Task.colId} = ?', whereArgs: [task.id]);
  }

//Deleting the tasks
  Future<int> deleteTask(int id) async {
    Database db = await this.db;
    return await db
        .delete(Task.tblName, where: '${Task.colId} = ?', whereArgs: [id]);
  }
}