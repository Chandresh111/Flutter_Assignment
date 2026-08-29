import 'dart:io';

// LIBRARY MANAGEMENT SYSTEM

// 1. BOOK CLASS

class Book {
  String title;
  String author;
  bool isAvailable;

  Book({
    required this.title,
    required this.author,
    this.isAvailable = true,
  });

  void displayBook() {
    print(
      'Title: $title | Author: $author | '
      'Available: ${isAvailable ? "Yes" : "No"}',
    );
  }
}

// 2. MEMBER CLASS

class Member {
  String name;
  int memberId;

  Member({
    required this.name,
    required this.memberId,
  });

  void displayMember() {
    print('Member ID: $memberId | Name: $name');
  }

  void borrowBook(Book book) {
    if (book.isAvailable) {
      book.isAvailable = false;
      print('$name borrowed "${book.title}".');
    } else {
      print('"${book.title}" is not available.');
    }
  }

  void returnBook(Book book) {
    book.isAvailable = true;
    print('$name returned "${book.title}".');
  }
}

// 3. INHERITANCE

class PremiumMember extends Member {
  PremiumMember({
    required super.name,
    required super.memberId,
  });

  void showPremiumBenefit() {
    print('$name is a Premium Member.');
    print('Benefit: Premium members can borrow books for 30 days.');
  }
}

// 4. LIBRARY CLASS

class Library {
  String name;

  // Lists to store books and members
  List<Book> books = [];
  List<Member> members = [];

  Library(this.name);

  // Add a book
  void addBook(Book book) {
    books.add(book);
    print('Book "${book.title}" added to the library.');
  }

  // Register a member
  void registerMember(Member member) {
    members.add(member);
    print('Member "${member.name}" registered successfully.');
  }

  // Display all books using a loop
  void displayAllBooks() {
    print('\n========== BOOK COLLECTION ==========');

    for (Book book in books) {
      book.displayBook();
    }
  }

  // Display all members using a loop
  void displayAllMembers() {
    print('\n========== LIBRARY MEMBERS ==========');

    for (Member member in members) {
      member.displayMember();
    }
  }
}

// MAIN PROGRAM

void main() {
  Library library = Library('City Central Library');

  // CREATE 10 BOOKS

  Book book1 = Book(
    title: 'The Alchemist',
    author: 'Paulo Coelho',
  );

  Book book2 = Book(
    title: '1984',
    author: 'George Orwell',
  );

  Book book3 = Book(
    title: 'Clean Code',
    author: 'Robert Martin',
  );

  Book book4 = Book(
    title: 'The Great Gatsby',
    author: 'F. Scott Fitzgerald',
  );

  Book book5 = Book(
    title: 'To Kill a Mockingbird',
    author: 'Harper Lee',
  );

  Book book6 = Book(
    title: 'Atomic Habits',
    author: 'James Clear',
  );

  Book book7 = Book(
    title: 'The Psychology of Money',
    author: 'Morgan Housel',
  );

  Book book8 = Book(
    title: 'Rich Dad Poor Dad',
    author: 'Robert Kiyosaki',
  );

  Book book9 = Book(
    title: 'Harry Potter and the Sorcerer\'s Stone',
    author: 'J. K. Rowling',
  );

  Book book10 = Book(
    title: 'The Hobbit',
    author: 'J. R. R. Tolkien',
  );

  // ADD ALL 10 BOOKS TO LIBRARY

  library.addBook(book1);
  library.addBook(book2);
  library.addBook(book3);
  library.addBook(book4);
  library.addBook(book5);
  library.addBook(book6);
  library.addBook(book7);
  library.addBook(book8);
  library.addBook(book9);
  library.addBook(book10);

  // CREATE MEMBERS

  Member member1 = Member(
    name: 'Chandresh',
    memberId: 101,
  );

  PremiumMember member2 = PremiumMember(
    name: 'Akash',
    memberId: 102,
  );

  // REGISTER MEMBERS

  library.registerMember(member1);
  library.registerMember(member2);

  // MENU LOOP

  bool running = true;

  while (running) {
    print('\n====================================');
    print('      ${library.name}');
    print('====================================');
    print('1. Display all books');
    print('2. Display all members');
    print('3. Borrow a book');
    print('4. Return a book');
    print('5. Show premium member');
    print('6. Exit');
    print('====================================');

    stdout.write('Enter your choice: ');

    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        library.displayAllBooks();
        break;

      case '2':
        library.displayAllMembers();
        break;

      case '3':
        member1.borrowBook(book1);
        break;

      case '4':
        member1.returnBook(book1);
        break;

      case '5':
        member2.showPremiumBenefit();
        break;

      case '6':
        print('\nThank you for using ${library.name}!');
        running = false;
        break;

      default:
        print('\nInvalid choice. Please try again.');
    }
  }
}