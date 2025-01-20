import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'todolist.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tarefas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> atualizarTarefa(int id, String novoTitulo) async {
    final db = await database;
    return await db.update(
      'tarefas',
      {'titulo': novoTitulo}, // Dados a serem atualizados
      where: 'id = ?', // Condição de seleção
      whereArgs: [id], // Argumento para a condição
    );
  }

  Future<int> inserirTarefa(String titulo) async {
    final db = await database;
    return await db.insert('tarefas', {'titulo': titulo});
  }

  Future<List<Map<String, dynamic>>> listarTarefas() async {
    final db = await database;
    return await db.query('tarefas');
  }

  Future<int> deletarTarefa(int id) async {
    final db = await database;
    return await db.delete('tarefas', where: 'id = ?', whereArgs: [id]);
  }
}
