// lib/pages/favorites_page.dart
import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/db_service.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Future<List<Book>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _refreshFavorites();
  }

  void _refreshFavorites() {
    setState(() {
      _favoritesFuture = DatabaseService.instance.getItems();
    });
  }

  Future<void> _deleteFavorite(String id) async {
    await DatabaseService.instance.deleteItem(id);
    _refreshFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Books'),
      ),
      body: FutureBuilder<List<Book>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No favorites yet'));
          }

          final favorites = snapshot.data!;
          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final book = favorites[index];
              return Dismissible(
                key: Key(book.id),
                background: Container(color: Colors.red),
                onDismissed: (direction) => _deleteFavorite(book.id),
                child: Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: book.thumbnailUrl != null
                        ? Image.network(
                            book.thumbnailUrl!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => 
                                const Icon(Icons.book, size: 50),
                          )
                        : const Icon(Icons.book, size: 50),
                    title: Text(book.title),
                    subtitle: book.authors != null
                        ? Text(book.authors!)
                        : const Text('Unknown author'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteFavorite(book.id),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}