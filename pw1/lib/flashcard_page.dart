import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const FlashcardApp());
}

class FlashcardApp extends StatelessWidget {
  const FlashcardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcard Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FlashcardPage(),
    );
  }
}

class FlashcardPage extends StatefulWidget {
  const FlashcardPage({Key? key}) : super(key: key);

  @override
  _FlashcardPageState createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  List<Flashcard> flashcards = [];
  late String _storageFilePath;

  @override
  void initState() {
    super.initState();
    _initStorageFilePathAndLoadFlashcards();
  }

  Future<void> _initStorageFilePathAndLoadFlashcards() async {
    await _initStorageFilePath();
    bool fileExists = await File(_storageFilePath).exists();
    if (!fileExists) {
      await _prePopulateFlashcards();
    }
    _loadFlashcards();
  }

  Future<void> _initStorageFilePath() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    _storageFilePath = '${appDocDir.path}/flashcards.json';
  }

  Future<void> _prePopulateFlashcards() async {
    // Pre-populate the flashcards with some initial data
    List<Flashcard> initialFlashcards = [
      Flashcard(
        question: 'What is the capital of France?',
        answer: 'Paris',
      ),
      Flashcard(
        question: 'What is the largest planet in our solar system?',
        answer: 'Jupiter',
      ),
    ];
    await _saveFlashcards(initialFlashcards);
  }

  Future<void> _loadFlashcards() async {
    try {
      File file = File(_storageFilePath);
      if (await file.exists()) {
        String contents = await file.readAsString();
        setState(() {
          flashcards = (jsonDecode(contents) as List<dynamic>)
              .map((e) => Flashcard.fromJson(e))
              .toList();
        });
        print('Flashcards loaded from: $_storageFilePath');
      }
    } catch (e) {
      print('Error loading flashcards: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Flashcards',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.blue,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: flashcards.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.white,
                    child: ListTile(
                      title: Text('Question: ${flashcards[index].question}',
                          style: const TextStyle(color: Colors.black)),
                      subtitle: Text('Answer: ${flashcards[index].answer}',
                          style: const TextStyle(color: Colors.black)),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _deleteFlashcard(index);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  _navigateToAddFlashcardPage(context);
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16.0),
                ),
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToAddFlashcardPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FlashcardCreationPage(),
      ),
    ).then((newFlashcard) {
      if (newFlashcard != null) {
        setState(() {
          flashcards.add(newFlashcard);
          _saveFlashcards();
        });
      }
    });
  }

  void _deleteFlashcard(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content:
              const Text('Are you sure you want to delete this flashcard?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  flashcards.removeAt(index);
                  _saveFlashcards();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveFlashcards([List<Flashcard>? flashcardsToSave]) async {
    List<Flashcard> saveData = flashcardsToSave ?? flashcards;
    try {
      File file = File(_storageFilePath);
      String data = jsonEncode(saveData);
      await file.writeAsString(data);
      print('Flashcards saved to: $_storageFilePath');
    } catch (e) {
      print('Error saving flashcards: $e');
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

class FlashcardCreationPage extends StatefulWidget {
  const FlashcardCreationPage({Key? key}) : super(key: key);

  @override
  _FlashcardCreationPageState createState() => _FlashcardCreationPageState();
}

class _FlashcardCreationPageState extends State<FlashcardCreationPage> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Flashcard',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.blue,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(
                  labelText: 'Question',
                  labelStyle: TextStyle(color: Colors.black)),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _answerController,
              decoration: const InputDecoration(
                  labelText: 'Answer',
                  labelStyle: TextStyle(color: Colors.black)),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _addFlashcardAndNavigateBack(context);
              },
              child: const Text('Save', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  void _addFlashcardAndNavigateBack(BuildContext context) {
    final String question = _questionController.text;
    final String answer = _answerController.text;
    if (question.isNotEmpty && answer.isNotEmpty) {
      Navigator.pop(
        context,
        Flashcard(question: question, answer: answer),
      );
    }
  }
}
