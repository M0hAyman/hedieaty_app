import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
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
            EVENT_FIREBASE_ID TEXT NOT NULL, -- From firebase
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
            GIFT_FIREBASE_ID TEXT NOT NULL, -- From firebase
            NAME TEXT NOT NULL,
            DESCRIPTION TEXT NOT NULL,
            CATEGORY TEXT NOT NULL,
            PRICE REAL NOT NULL,
            IMG_URL TEXT, -- Nullable for optional image
            IS_PLEDGED INTEGER DEFAULT 0, -- Boolean: 0 = not pledged, 1 = pledged
            PLEDGED_BY TEXT NOT NULL, -- Nullable: user ID of the pledger
            USER_ID TEXT NOT NULL, -- Owner user ID from firebase
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

  //Sync data from Firestore to SQLite
  Future<void> syncFirestoreDataToSQLite(Map<String, dynamic> userData) async {
    if (_mydb == null || !_mydb!.isOpen) {
      print('Database is null, not yet initialized');
      return;
    }
    //Convert the boolean password reset value to an integer
    int passwordReset = userData['passwordReset'] ? 1 : 0;
    userData['PASSWORDRESET'] = passwordReset;

    print('Syncing Firestore data to SQLite...');
    if (!userData.containsKey('PASSWORD')) {
      userData['PASSWORD'] = 'defaultPassword';
    } else {
      userData['PASSWORD'] = hashPassword(userData['PASSWORD']);
    }

    //Check if there's existing data in the database
    final List<Map<String, dynamic>> existingData = await _mydb!.query('USER');
    if (existingData.isNotEmpty) {
      //Update the existing data
      await _mydb!.update('USER', userData,
          where: 'ID = ?', whereArgs: [existingData.first['ID']]);
      print('Data found and has been updated');
    } else {
      //Insert the new data
      await _mydb!.insert('USER', userData);
      print('Data not found and has been inserted');
    }

    print('Data has been synced successfully');
  }

  //Hash the password using a simple hashing algorithm
  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  //Fetch the user data from SQLite
  Future<Map<String, dynamic>> fetchUserDataFromSQLite() async {
    if (_mydb == null || !_mydb!.isOpen) {
      print('Database is null, not yet initialized');
      return {};
    }
    print('Fetching user data from SQLite...');
    final List<Map<String, dynamic>> userData = await _mydb!.query('USER');
    if (userData.isNotEmpty) {
      print('User data found and fetched');
      print('User data: ${userData.first}');
      return userData.first;
    } else {
      print('User data not found');
      return {};
    }
  }

  //Verify the hashed password
  Future<bool> verifyPassword(
      String enteredPassword, storedHashedPassword) async {
    if (_mydb == null || !_mydb!.isOpen) {
      print('Database is null, not yet initialized');
      return false;
    }
    print('Verifying password...');
    final String hashedPassword = hashPassword(enteredPassword);
    if (hashedPassword == storedHashedPassword) {
      print('Password is correct');
      return true;
    } else {
      print('Password is incorrect');
      return false;
    }
  }

  //Get user by email
  Future<Map<String, dynamic>> getUserByEmail(String email) async {
    if (_mydb == null || !_mydb!.isOpen) {
      print('Database is null, not yet initialized');
      return {};
    }
    print('Fetching user data by email...');
    final List<Map<String, dynamic>> userData = await _mydb!.query(
      'USER',
      where: 'EMAIL = ?',
      whereArgs: [email],
    );
    if (userData.isNotEmpty) {
      print('User data found and fetched');
      print('User data: ${userData.first}');
      return userData.first;
    } else {
      print('User data not found');
      return {};
    }
  }

  //Close the database when it's no longer needed

  //...............................................
  // static final MyLocalDatabaseService instance = MyLocalDatabaseService._init();

  // static Database? _database;

  // MyLocalDatabaseService._init();

  // Future<Database> get database async {
  //   if (_database != null) return _database!;

  //   _database = await _initDB('mydatabase.db');
  //   return _database!;
  // }

  // Future<Database> _initDB(String filePath) async {
  //   final db = await openDatabase(filePath, version: 1, onCreate: _createDB);
  //   return db;
  // }

  // Future _createDB(Database db, int version) async {
  //   const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  //   const textType = 'TEXT NOT NULL';
  //   const boolType = 'BOOLEAN NOT NULL';

  //   await db.execute('''CREATE TABLE $tableEvents (
  //     ${EventFields.id} $idType,
  //     ${EventFields.title} $textType,
  //     ${EventFields.description} $textType,
  //     ${EventFields.date} $textType,
  //     ${EventFields.isAllDay} $boolType,
  //     ${EventFields.isImportant} $boolType
  //   )''');
  // }
}
