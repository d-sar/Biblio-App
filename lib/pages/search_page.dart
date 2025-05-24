
// lib/pages/search_page.dart
import 'package:app_biblio/pages/favorites_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/book.dart';
import '../services/api_service.dart';
import '../services/db_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Book> _books = [];
  bool _isLoading = false;

  Future<void> _searchBooks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final books = await ApiService.searchBooks(_searchController.text);
      setState(() {
        _books = books;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search books',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _searchBooks(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchBooks,
                ),
              ],
            ),
          ),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: _books.length,
                    itemBuilder: (context, index) {
                      final book = _books[index];
                      return _BookItem(book: book);
                    },
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FavoritesPage()),
          );
        },
        child: const Icon(Icons.favorite),
      ),
    );
  }
}

class _BookItem extends StatefulWidget {
  final Book book;

  const _BookItem({Key? key, required this.book}) : super(key: key);

  @override
  __BookItemState createState() => __BookItemState();
}

class __BookItemState extends State<_BookItem> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final isFavorite = await DatabaseService.instance.isFavorite(widget.book.id);
    setState(() {
      _isFavorite = isFavorite;
    });
  }

  Future<void> _toggleFavorite() async {
    if (_isFavorite) {
      await DatabaseService.instance.deleteItem(widget.book.id);
    } else {
      await DatabaseService.instance.insertItem(widget.book);
    }
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: widget.book.thumbnailUrl != null
            ? Image.network(
                widget.book.thumbnailUrl!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => 
                    const Icon(Icons.book, size: 50),
              )
            : const Icon(Icons.book, size: 50),
        title: Text(widget.book.title),
        subtitle: widget.book.authors != null
            ? Text(widget.book.authors!)
            : const Text('Unknown author'),
        trailing: IconButton(
          icon: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite ? Colors.red : null,
          ),
          onPressed: _toggleFavorite,
        ),
      ),
    );
  }
}