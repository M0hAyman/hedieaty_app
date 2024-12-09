

import '../mydatabase.dart';

class UserService {
  final MyLocalDatabaseService _dbService = MyLocalDatabaseService();

  Future<int> insertUser(Map<String, dynamic> userData) async {
    final db = await _dbService.getDatabaseInstance();
    return await db!.insert('USER', userData);
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await _dbService.getDatabaseInstance();
    final result = await db!.query('USER', where: 'EMAIL = ?', whereArgs: [email]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateUser(int userId, Map<String, dynamic> newUserData) async {
    final db = await _dbService.getDatabaseInstance();
    return await db!.update('USER', newUserData, where: 'ID = ?', whereArgs: [userId]);
  }

  Future<int> deleteUser(int userId) async {
    final db = await _dbService.getDatabaseInstance();
    return await db!.delete('USER', where: 'ID = ?', whereArgs: [userId]);
  }
}
