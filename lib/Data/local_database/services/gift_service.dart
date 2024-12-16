

import 'package:sqflite/sqflite.dart';

import '../mydatabase.dart';

class GiftService {
  final MyLocalDatabaseService _dbService = MyLocalDatabaseService();

  Future<int> insertGift(Map<String, dynamic> giftData) async {
    final db = await _dbService.getDatabaseInstance();
    return await db!.insert('GIFTS', giftData, conflictAlgorithm: ConflictAlgorithm.replace,);
  }

  Future<List<Map<String, dynamic>>> getGiftsByEventId(int eventId) async {
    final db = await _dbService.getDatabaseInstance();
    return await db!.query('GIFTS', where: 'EVENT_ID = ?', whereArgs: [eventId]);
  }

  Future<int> updateGift(int giftId, Map<String, dynamic> newGiftData) async {
    final db = await _dbService.getDatabaseInstance();
    return await db!.update('GIFTS', newGiftData, where: 'ID = ?', whereArgs: [giftId]);
  }

  Future<int> deleteGift(int giftId) async {
    final db = await _dbService.getDatabaseInstance();
    return await db!.delete('GIFTS', where: 'ID = ?', whereArgs: [giftId]);
  }
}
