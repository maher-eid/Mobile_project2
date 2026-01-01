import 'package:flutter/material.dart';
import 'book.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String filteredBooks = 'Please select an author to see the books.';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  _loadBooks() async {
    await updateBooks(); // Load books from the server
    setState(() {
      isLoading = false;
    });
  }

  void _filterBooksByAuthor(String author) {
    setState(() {
      filteredBooks = ''; // Clear previous results
      for (var book in books) {
        if (book.author == author) {
          filteredBooks += '\n${book.toString()}\n';
        }
      }

      if (filteredBooks.isEmpty) {
        filteredBooks = 'No books found for the selected author.';
      } else {
        print('Filtered Books: $filteredBooks'); // Debug statement
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Show Books'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  MyWidget(
                      onAuthorSelected:
                          _filterBooksByAuthor), // Pass function to MyWidget
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          filteredBooks,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

