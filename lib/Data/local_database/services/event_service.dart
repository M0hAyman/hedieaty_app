import '../mydatabase.dart';

class EventService {
  final MyLocalDatabaseService _dbService = MyLocalDatabaseService();

  Future<int> insertEvent(Map<String, dynamic> eventData) async {
    final db = await _dbService.getDatabaseInstance();
    return await db!.insert('EVENTS', eventData);
  }

  Future<List<Map<String, dynamic>>> getEventsByUserId(int userId) async {
    final db = await _dbService.getDatabaseInstance();
    return await db!.query('EVENTS', where: 'USER_ID = ?', whereArgs: [userId]);
  }

  Future<int> updateEvent(int eventId, Map<String, dynamic> newEventData) async {
    final db = await _dbService.getDatabaseInstance();
    return await db!.update('EVENTS', newEventData, where: 'ID = ?', whereArgs: [eventId]);
  }

  Future<int> deleteEvent(int eventId) async {
    final db = await _dbService.getDatabaseInstance();
    return await db!.delete('EVENTS', where: 'ID = ?', whereArgs: [eventId]);
  }
}
