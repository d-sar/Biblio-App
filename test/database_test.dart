import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:app_biblio/services/db_service.dart';
import 'package:app_biblio/models/book.dart';

void main() {
  group('Database Tests', () {
    setUpAll(() {
      // Initialize FFI
      sqfliteFfiInit();
      // Change the default factory
      databaseFactory = databaseFactoryFfi;
    });

    test('Database initialization should work', () async {
      final dbService = DatabaseService.instance;
      
      // Test creating a book
      final testBook = Book(
        id: 'test123',
        title: 'Test Book',
        authors: 'Test Author',
        thumbnailUrl: null,
      );
      
      // Test inserting
      await dbService.insertItem(testBook);
      
      // Test checking if favorite
      final isFav = await dbService.isFavorite('test123');
      expect(isFav, true);
      
      // Test getting items
      final items = await dbService.getItems();
      expect(items.length, greaterThan(0));
      expect(items.first.id, 'test123');
      
      // Test deleting
      await dbService.deleteItem('test123');
      final isFavAfterDelete = await dbService.isFavorite('test123');
      expect(isFavAfterDelete, false);
    });
  });
}
