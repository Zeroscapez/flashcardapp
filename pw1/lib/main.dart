import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(FlashcardApp());
}

class FlashcardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcard Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FlashcardHomePage(),
    );
  }
}

class FlashcardHomePage extends StatefulWidget {
  @override
  _FlashcardHomePageState createState() => _FlashcardHomePageState();
}

class _FlashcardHomePageState extends State<FlashcardHomePage> {
  List<Flashcard> flashcards = [];
  String _storageFileName = 'flashcards.json';

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
  }

  Future<void> _loadFlashcards() async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      File file = File('$appDocPath/$_storageFileName');
      if (await file.exists()) {
        String contents = await file.readAsString();
        setState(() {
          flashcards = (jsonDecode(contents) as List<dynamic>)
              .map((e) => Flashcard.fromJson(e))
              .toList();
        });
      }
    } catch (e) {
      print('Error loading flashcards: $e');
    }
  }

  Future<void> _saveFlashcards() async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      File file = File('$appDocPath/$_storageFileName');
      String data = jsonEncode(flashcards);
      await file.writeAsString(data);
    } catch (e) {
      print('Error saving flashcards: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcard Quiz App'),
      ),
      body: ListView.builder(
        itemCount: flashcards.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(flashcards[index].question),
            subtitle: Text(flashcards[index].answer),
            onTap: () {
              _navigateToEditFlashcardScreen(flashcards[index], index);
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteFlashcard(index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToFlashcardCreationScreen();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _navigateToFlashcardCreationScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlashcardCreationScreen(),
      ),
    ).then((value) {
      if (value != null && value is Flashcard) {
        setState(() {
          flashcards.add(value);
          _saveFlashcards();
        });
      }
    });
  }

  void _navigateToEditFlashcardScreen(Flashcard flashcard, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlashcardEditScreen(flashcard: flashcard),
      ),
    ).then((value) {
      if (value != null && value is Flashcard) {
        setState(() {
          flashcards[index] = value;
          _saveFlashcards();
        });
      }
    });
  }

  void _deleteFlashcard(int index) {
    setState(() {
      flashcards.removeAt(index);
      _saveFlashcards();
    });
  }
}

class FlashcardCreationScreen extends StatefulWidget {
  @override
  _FlashcardCreationScreenState createState() =>
      _FlashcardCreationScreenState();
}

class _FlashcardCreationScreenState extends State<FlashcardCreationScreen> {
  TextEditingController _questionController = TextEditingController();
  TextEditingController _answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Flashcard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(labelText: 'Question'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(labelText: 'Answer'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _saveFlashcard();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveFlashcard() {
    if (_questionController.text.isNotEmpty &&
        _answerController.text.isNotEmpty) {
      Navigator.pop(
        context,
        Flashcard(
          question: _questionController.text,
          answer: _answerController.text,
        ),
      );
    }
  }
}

class FlashcardEditScreen extends StatefulWidget {
  final Flashcard flashcard;

  const FlashcardEditScreen({required this.flashcard});

  @override
  _FlashcardEditScreenState createState() => _FlashcardEditScreenState();
}

class _FlashcardEditScreenState extends State<FlashcardEditScreen> {
  late TextEditingController _questionController;
  late TextEditingController _answerController;

  @override
  void initState() {
    super.initState();
    _questionController =
        TextEditingController(text: widget.flashcard.question);
    _answerController = TextEditingController(text: widget.flashcard.answer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Flashcard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(labelText: 'Question'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(labelText: 'Answer'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _saveFlashcard();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveFlashcard() {
    if (_questionController.text.isNotEmpty &&
        _answerController.text.isNotEmpty) {
      Navigator.pop(
        context,
        Flashcard(
          question: _questionController.text,
          answer: _answerController.text,
        ),
      );
    }
  }
}

class Flashcard {
  String question;
  String answer;

  Flashcard({required this.question, required this.answer});

  Flashcard.fromJson(Map<String, dynamic> json)
      : question = json['question'],
        answer = json['answer'];

  Map<String, dynamic> toJson() => {'question': question, 'answer': answer};
}
