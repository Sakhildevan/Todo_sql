import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_sql/models/task_model.dart';

class DatabaseHelper {
  Database? _database;
  Future initializeDatabase() async {
    _database = await openDatabase(join(await getDatabasesPath(), "tasks.db"),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT, isCompleted INTEGER)');
    });
  }

  Future<void> insertTask(Task task) async {
    initializeDatabase();
    await _database!.insert('tasks', task.toMap());
  }

  Future<void> updateTask(Task task) async {
    initializeDatabase();
    await _database!.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(int id) async {
    initializeDatabase();
    await _database!.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Task>> getTasks() async {
    initializeDatabase();
    Database db = _database??await openDatabase(join(await getDatabasesPath(), "tasks.db"),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT, isCompleted INTEGER)');
    });
    final List<Map<String, dynamic>> tasksMap = await db.query('tasks');
    return List.generate(tasksMap.length, (i) {
      return Task(
        id: tasksMap[i]['id'],
        title: tasksMap[i]['title'],
        description: tasksMap[i]['description'],
        isCompleted: tasksMap[i]['isCompleted'] == 1,
      );
    });
  }
}
