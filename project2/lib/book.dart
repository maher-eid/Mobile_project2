import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

const String baseURL = 'website-for-project2.infy.uk';

class Book {
  final int id;
  final String title;
  final String genre;
  final int stock;
  final double price;
  final String author;

  Book(this.id, this.title, this.genre, this.stock, this.price, this.author);

  @override
  String toString() {
    return 'BID: $id Title: ${title.toUpperCase()}\nGenre: $genre Stock: $stock Price: $price\$ Author: $author';
  }
}

List<Book> books = []; // List to store book data

List<String> authors = [
  'William Shakespeare',
  'Jane Austen',
  'Gabriel García Márquez',
  'Toni Morrison'
];

updateBooks() async {
  try {
    books.clear(); // Clear previous data
    final url = Uri.http(baseURL, 'getBooks.php');
    final response = await http
        .get(url)
        .timeout(const Duration(seconds: 5)); // Timeout set to 5 seconds

    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      for (var row in jsonResponse) {
        Book book = Book(
          int.parse(row['book_id']),
          row['title'],
          row['genre'],
          int.parse(row['stock']),
          double.parse(row['price']),
          row['author'],
        );
        books.add(book);
      }
    }
  } catch (e) {
    print('$e'); // Catch and print errors
  }
}

class MyWidget extends StatefulWidget {
  final Function(String) onAuthorSelected;

  const MyWidget({super.key, required this.onAuthorSelected});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  String? selectedAuthor = authors[0]; // Default selected author

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Select an Author:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Column(
          children: authors.map((author) {
            return RadioListTile<String>(
              title: Text(author),
              value: author,
              groupValue: selectedAuthor,
              onChanged: (value) {
                setState(() {
                  selectedAuthor = value;
                });
                widget.onAuthorSelected(value!); // Notify parent of selection
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
