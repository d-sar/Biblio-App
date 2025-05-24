// lib/services/db_service.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import '../models/book.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;
  static bool _isInitialized = false;

  DatabaseService._init();

  Future<void> _ensureDatabaseFactoryInitialized() async {
    if (_isInitialized) return;

    if (kIsWeb) {
      // Web platform - we'll use localStorage instead of SQLite
      // For now, we'll just mark as initialized and handle storage differently
      _isInitialized = true;
      return;
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // Desktop platforms - use FFI
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    // For mobile platforms (Android/iOS), the default databaseFactory is already set

    _isInitialized = true;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    try {
      await _ensureDatabaseFactoryInitialized();

      if (kIsWeb) {
        // For web, we'll throw an error for now since SQLite isn't supported
        throw UnsupportedError(
          'SQLite database is not supported on web platform. Use shared_preferences instead.',
        );
      }

      _database = await _initDB('favorites.db');
      return _database!;
    } catch (e) {
      print('Error initializing database: $e');
      rethrow;
    }
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites (
        id TEXT PRIMARY KEY,
        title TEXT,
        authors TEXT,
        thumbnailUrl TEXT
      )
    ''');
  }

  Future<int> insertItem(Book book) async {
    try {
      final db = await instance.database;
      return await db.insert(
        'favorites',
        book.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error inserting item: $e');
      rethrow;
    }
  }

  Future<List<Book>> getItems() async {
    try {
      final db = await instance.database;
      final List<Map<String, dynamic>> maps = await db.query('favorites');
      return List.generate(maps.length, (i) => Book.fromMap(maps[i]));
    } catch (e) {
      print('Error getting items: $e');
      return [];
    }
  }

  Future<int> deleteItem(String id) async {
    try {
      final db = await instance.database;
      return await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print('Error deleting item: $e');
      rethrow;
    }
  }

  Future<bool> isFavorite(String id) async {
    try {
      final db = await instance.database;
      final result = await db.query(
        'favorites',
        where: 'id = ?',
        whereArgs: [id],
      );
      return result.isNotEmpty;
    } catch (e) {
      print('Error checking favorite: $e');
      return false;
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
