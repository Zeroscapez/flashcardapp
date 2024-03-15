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
      home: FlashcardPage(),
    );
  }
}

class FlashcardPage extends StatefulWidget {
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
    _loadFlashcards();
  }

  Future<void> _initStorageFilePath() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    _storageFilePath = '${appDocDir.path}/flashcards.json';
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
        title: Text('Flashcards'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: flashcards.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Question: ${flashcards[index].question}'),
                  subtitle: Text('Answer: ${flashcards[index].answer}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteFlashcard(index);
                    },
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
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(16.0),
                ),
                child: Icon(Icons.add),
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
        builder: (context) => FlashcardCreationPage(),
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
    setState(() {
      flashcards.removeAt(index);
      _saveFlashcards();
    });
  }

  Future<void> _saveFlashcards() async {
    try {
      File file = File(_storageFilePath);
      String data = jsonEncode(flashcards);
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
        title: Text('Create Flashcard'),
        backgroundColor: Colors.blue,
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
                _addFlashcardAndNavigateBack(context);
              },
              child: Text('Save'),
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
