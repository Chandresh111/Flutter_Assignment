import 'package:flutter_test/flutter_test.dart';
import 'package:library_system/main.dart';

void main() {
  test('Book object is created correctly', () {
    final book = Book(
      title: 'The Alchemist',
      author: 'Paulo Coelho',
    );

    expect(book.title, 'The Alchemist');
    expect(book.author, 'Paulo Coelho');
    expect(book.isAvailable, true);
  });

  test('Book availability can be changed', () {
    final book = Book(
      title: '1984',
      author: 'George Orwell',
    );

    expect(book.isAvailable, true);

    book.isAvailable = false;

    expect(book.isAvailable, false);
  });
}