

import 'package:sqflite/sqflite.dart';

import '../mydatabase.dart';

class GiftService {
  final MyLocalDatabaseService _dbService = MyLocalDatabaseService();

  Future<int> pledgeGift(int giftId, String userId) async {
    final db = await _dbService.getDatabaseInstance();
    return await db!.update(
      'GIFTS',
      {'IS_PLEDGED': 1, 'PLEDGED_BY': userId},
      where: 'ID = ?',
      whereArgs: [giftId],
    );
  }
  Future<int> unpledgeGift(int giftId) async {
    final db = await _dbService.getDatabaseInstance();
    return await db!.update(
      'GIFTS',
      {'IS_PLEDGED': 0, 'PLEDGED_BY': null},
      where: 'ID = ?',
      whereArgs: [giftId],
    );
  }
  Future<int> insertGift(Map<String, dynamic> giftData) async {
    try {
      final db = await _dbService.getDatabaseInstance();
      final id = await db!.insert(
        'GIFTS',
        giftData,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('The new row id inserted: $id');
      return id; // Return the generated ID
    } catch (e) {
      print("Error inserting gift: $e");
      throw Exception("Failed to insert gift.");
    }
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
