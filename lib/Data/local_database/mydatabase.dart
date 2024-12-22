import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class MyLocalDatabaseService {
  Database? _mydb;
  int dbversion = 1;
  Future<void> initialize() async {
    // Check if the platform is web or unsupported
    if (kIsWeb || !Platform.isAndroid && !Platform.isIOS) {
      print('Database is not supported on this platform.');
      return;
    }
    // Proceed with database initialization for mobile
    String databaseDestination = await getDatabasesPath();
    final String databasesPath = join(databaseDestination, 'mydatabase.db');
    print('Database path: $databasesPath');

    _mydb = await openDatabase(
      databasesPath,
      version: dbversion,
      onCreate: (db, version) async {
        // Create Events table
        await db.execute('''
          CREATE TABLE IF NOT EXISTS EVENTS (
            ID INTEGER PRIMARY KEY AUTOINCREMENT,
            EVENT_FIREBASE_ID TEXT, -- From firebase
            NAME TEXT NOT NULL,
            CATEGORY TEXT NOT NULL,
            DESCRIPTION TEXT NOT NULL,
            DATE TEXT NOT NULL,
            LOCATION TEXT NOT NULL,
            USER_ID TEXT NOT NULL -- From firebase
          )
        ''');
        print("Events table created");

        // Create Gifts table
        await db.execute('''
          CREATE TABLE IF NOT EXISTS GIFTS (
            ID INTEGER PRIMARY KEY AUTOINCREMENT,
            GIFT_FIREBASE_ID TEXT, -- From firebase
            NAME TEXT NOT NULL,
            DESCRIPTION TEXT NOT NULL,
            CATEGORY TEXT NOT NULL,
            PRICE REAL NOT NULL,
            IMG_URL TEXT, -- Nullable for optional image
            IS_PLEDGED INTEGER DEFAULT 0, -- Boolean: 0 = not pledged, 1 = pledged
            PLEDGED_BY TEXT, -- Nullable: user ID of the pledger
            USER_ID TEXT NOT NULL, -- Owner user ID from firebase
            EVENT_FIREBASE_ID TEXT, -- From firebase
            EVENT_ID INTEGER NOT NULL,
            FOREIGN KEY (EVENT_ID) REFERENCES EVENTS(ID)
          )
        ''');
        print("Gifts table created");

        print("All required tables have been created.");
      },
    );
    print('Database has been opened and initialized');
  }

  //Print the content of the database
  Future<void> printDB() async {
    if (_mydb == null || !_mydb!.isOpen) {
      print('Database is null');
      return;
    }
    final List<Map<String, dynamic>> queryResults = await _mydb!.query('USER');
    if (queryResults.isNotEmpty) {
      print('Printing all database content:');
      queryResults.forEach((row) => print('User data: $row'));
    } else {
      print('Database is empty');
    }
  }

  //Singleton pattern to ensure only one instance of the database is created
  //Check if the database is initialized, otherwise initialize it
  //mydbcheckData
  Future<Database?> getDatabaseInstance() async {
    if (_mydb == null || !_mydb!.isOpen) {
      //or is not open and database is not null
      print('Database is null, initializing...');
      await initialize();
      return _mydb;
    } else {
      print('Database is already initialized');
      return _mydb;
    }
  }

  //Reset the database by deleting the database file and recreating it
  Future<void> resetDatabase() async {
    print('reseting.......');
    if (_mydb == null || !_mydb!.isOpen) {
      print('Database is null');
      return;
    }
    await _mydb!.close();
    _mydb = null;
    final String databaseDestination = await getDatabasesPath();
    final String databasesPath = join(databaseDestination, 'mydatabase.db');
    await deleteDatabase(databasesPath);
    print('Database has been deleted');
    await initialize();
    print('Database has been reset');
  }

}
