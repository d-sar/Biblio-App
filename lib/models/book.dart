// lib/models/book.dart
class Book {
  final String id;
  final String title;
  final String? authors;
  final String? thumbnailUrl;

  Book({
    required this.id,
    required this.title,
    this.authors,
    this.thumbnailUrl,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['volumeInfo']['title'],
      authors: json['volumeInfo']['authors']?.join(', '),
      thumbnailUrl: json['volumeInfo']['imageLinks']?['thumbnail'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'authors': authors,
      'thumbnailUrl': thumbnailUrl,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      authors: map['authors'],
      thumbnailUrl: map['thumbnailUrl'],
    );
  }
}