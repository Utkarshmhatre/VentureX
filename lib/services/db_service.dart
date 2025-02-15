import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/canvas_item_model.dart';

class DbService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, 'business_canvas.db');

    return openDatabase(
      databasePath,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE canvas_items (id INTEGER PRIMARY KEY, type TEXT, content TEXT, x REAL, y REAL, width REAL, height REAL)',
        );
        await db.execute(
          'CREATE TABLE ideas (id INTEGER PRIMARY KEY AUTOINCREMENT, idea TEXT, score REAL)',
        );
      },
      version: 2,
    );
  }

  Future<void> insertCanvasItem(CanvasItemModel item) async {
    final db = await database;
    await db.insert(
      'canvas_items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<CanvasItemModel>> getCanvasItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('canvas_items');
    return List.generate(maps.length, (i) {
      return CanvasItemModel(
        id: maps[i]['id'],
        type: maps[i]['type'],
        content: maps[i]['content'],
        x: maps[i]['x'],
        y: maps[i]['y'],
        width: maps[i]['width'],
        height: maps[i]['height'],
      );
    });
  }

  Future<void> deleteCanvasItem(int id) async {
    final db = await database;
    await db.delete('canvas_items', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateCanvasItem(CanvasItemModel item) async {
    final db = await database;
    await db.update(
      'canvas_items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> clearCanvasItems() async {
    final db = await database;
    await db.delete('canvas_items');
  }

  Future<void> saveIdea(
    String idea,
    Map<String, dynamic> validationResult,
  ) async {
    final db = await database;
    await db.insert('ideas', {
      'idea': idea,
      'score': validationResult['score'],
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
