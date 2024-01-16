import 'dart:io';

import 'package:contactsbuddy_master/models/contactModel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  final String _dbName = "Contact.db";
  final int _dbVersion = 1;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await _initDB();
    return _db;
  }

  Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String dbPath = join(dir.path, _dbName);
    return await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreateDb,
    );
  }

  // temp
  // void alter() async {
  //   Database? db = await this.db;
  //   String sql =
  //       "ALTER TABLE ${Contact.tblName} ADD ${Contact.colIsDone} BOOLEAN";
  //   db?.execute(sql);
  // }

  // Creating table
  // Future<void> _onCreateDb(Database db, int version) async {
  //   await db.execute('''
  //   CREATE TABLE ${Contact.tblName}(
  //   ${Contact.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
  //   ${Contact.colTitle} TEXT,
  //   ${Contact.colDate} TEXT,
  //   ${Contact.colPriority} TEXT,
  //   )
  //   ''');
  // }
  Future<void> _onCreateDb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE ${Contact.tblName}(
    ${Contact.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${Contact.colTitle} TEXT,
    ${Contact.colDate} TEXT,
    ${Contact.colPriority} TEXT
    )
    ''');
  }

  // for checking is done
  // Future<bool> isDone(Contact contact) async {
  //   Database? db = await this.db;
  //   return await db!.rawQuery(
  //     "SELECT colIsDone FROM ${Contact.tblName} WHERE ${Contact.colId} LIKE ${}"
  //   );
  // }

  // Inserting contacts
  Future<int> insertContact(Contact contact) async {
    Database? db = await this.db;
    print("Date: ${contact.date}");
    return await db!.insert(Contact.tblName, contact.toMap());
  }

  // Fetching the contacts
  // Future<List<Contact>> fetchContacts(String contactName) async {
  //   Database? db = await this.db;
  //   final List<Map<String, dynamic>> contacts = await db!.rawQuery(
  //       "SELECT * FROM ${Contact.tblName} WHERE ${Contact.colTitle} LIKE '$contactName%'");

  //   final List<Contact> contactsList = contacts.isEmpty
  //       ? []
  //       : contacts.map((e) => Contact.fromMap(e)).toList();
  //   contactsList
  //       .sort((contactA, contactB) => contactA.date!.compareTo(contactB.date!));
  //   return contactsList;
  // }
  Future<List<Contact>> fetchContacts(String contactName) async {
    Database? db = await this.db;
    final List<Map<String, dynamic>> contacts = await db!.rawQuery(
        "SELECT * FROM ${Contact.tblName} WHERE ${Contact.colTitle} LIKE '%$contactName%'");

    print("Contact List from Database: $contacts");

    final List<Contact> contactsList = contacts.isEmpty
        ? []
        : contacts.map((e) => Contact.fromMap(e)).toList();

    print("Contact List that returns: $contactsList");
    // contactsList
    //     .sort((contactA, contactB) => contactA.date!.compareTo(contactB.date!));

    return contactsList;
  }

  // Querying all contacts
  Future<List<Map<String, dynamic>>> queryAll() async {
    Database? db = await this.db;
    final List<Map<String, dynamic>> result = await db!.query(Contact.tblName);
    return result;
  }

  // Updating the contacts
  Future<List<Map<String, Object?>>> updateContact(Contact contact,
      String title, int id, String priority, String date) async {
    Database? db = await this.db;
    String sql =
        "UPDATE ${Contact.tblName} SET ${Contact.colTitle}='$title', ${Contact.colDate}='$date', ${Contact.colPriority}='$priority' WHERE id=$id";

    return await db!.rawQuery(sql);
  }

  // // for checking that the task is done
  // Future<void> markDone(Contact contact, int id) async {
  //   Database? db = await this.db;
  //   String sql =
  //       "UPDATE ${Contact.tblName} SET ${Contact.colIsDone} = 1 - ${Contact.colIsDone} WHERE ${Contact.colId} = $id";
  //   await db!.rawUpdate(sql);
  // }

  // Deleting the contacts
  Future<int> deleteContact(int id) async {
    Database? db = await this.db;
    return await db!.delete(Contact.tblName,
        where: '${Contact.colId} = ?', whereArgs: [id]);
  }
}
