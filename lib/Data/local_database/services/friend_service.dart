

import 'package:sqflite/sqflite.dart';

import '../mydatabase.dart';

class FriendService {
  final MyLocalDatabaseService _dbService = MyLocalDatabaseService();

  Future<int> addFriend(int userId, int friendId) async {
    final db = await _dbService.getDatabaseInstance();
    return await db!.insert('FRIENDS', {'USER_ID': userId, 'FRIEND_ID': friendId}, conflictAlgorithm: ConflictAlgorithm.replace,);
  }

  Future<List<Map<String, dynamic>>> getFriendsByUserId(int userId) async {
    final db = await _dbService.getDatabaseInstance();
    return await db!.query('FRIENDS', where: 'USER_ID = ?', whereArgs: [userId]);
  }

  Future<int> removeFriend(int userId, int friendId) async {
    final db = await _dbService.getDatabaseInstance();
    return await db!.delete(
      'FRIENDS',
      where: 'USER_ID = ? AND FRIEND_ID = ?',
      whereArgs: [userId, friendId],
    );
  }
}
