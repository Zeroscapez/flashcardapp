import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:math';

class QuizModePage extends StatefulWidget {
  const QuizModePage({super.key});

  @override
  _QuizModePageState createState() => _QuizModePageState();
}

class _QuizModePageState extends State<QuizModePage> {
  List<Flashcard>? flashcards;
  int currentQuestionIndex = 0;
  String userAnswer = '';
  bool? isCorrect;

  @override
  void initState() {
    super.initState();
    loadFlashcards();
  }

  Future<void> loadFlashcards() async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String storageFilePath = '${appDocDir.path}/flashcards.json';
      File file = File(storageFilePath);
      if (await file.exists()) {
        String contents = await file.readAsString();
        setState(() {
          flashcards = (jsonDecode(contents) as List<dynamic>)
              .map((e) => Flashcard.fromJson(e))
              .toList();
        });
        print('Flashcards loaded from: $storageFilePath');
      } else {
        print('No flashcards available.');
      }
    } catch (e) {
      print('Error loading flashcards: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if flashcards list is not initialized
    if (flashcards == null) {
      // Display a loading indicator or any other placeholder widget
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Mode'),
        ),
        body: const Center(
          child: CircularProgressIndicator(), // Loading indicator
        ),
      );
    }

    // If flashcards list is empty
    if (flashcards!.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Mode'),
        ),
        body: const Center(
          child: Text('No flashcards available.'),
        ),
      );
    }

    // If flashcards list is not empty, proceed with quiz mode
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Mode'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Check if all flashcards have been completed
            currentQuestionIndex < flashcards!.length
                ? Text(
                    'Question ${currentQuestionIndex + 1}: ${flashcards![currentQuestionIndex].question}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  )
                : const Text(
                    'Quiz Complete',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
            const SizedBox(height: 20),
            // Display multiple choice options
            currentQuestionIndex < flashcards!.length
                ? Column(
                    children: _buildOptions(),
                  )
                : Container(), // Hide options when quiz complete
            const SizedBox(height: 20),
            // Show next button only if quiz is not complete
            currentQuestionIndex < flashcards!.length
                ? ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // Reset state for next question
                        userAnswer = '';
                        isCorrect = null;
                        // Move to next question or end quiz
                        currentQuestionIndex++;
                      });
                    },
                    child: const Text('Next'),
                  )
                : Container(), // Hide next button when quiz complete
            const SizedBox(height: 20),
            if (isCorrect != null)
              Text(
                isCorrect! ? 'Correct!' : 'Incorrect!',
                style: TextStyle(
                  color: isCorrect! ? Colors.green : Colors.red,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Build multiple choice options
  List<Widget> _buildOptions() {
    List<Widget> options = [];
    var correctAnswer = flashcards![currentQuestionIndex].answer;
    var wrongAnswers = _generateWrongAnswers(correctAnswer);
    // Add correct answer as one of the options
    options.add(_buildOptionButton(correctAnswer));
    // Add wrong answers as options
    options.addAll(
        wrongAnswers.map((wrongAnswer) => _buildOptionButton(wrongAnswer)));
    // Shuffle the options
    options.shuffle();
    return options;
  }

  // Generate wrong answers
  List<String> _generateWrongAnswers(String correctAnswer) {
    List<String> wrongAnswers = [];

    // Add the correct answer to the list of wrong answers
    wrongAnswers.add(correctAnswer);

    if (flashcards!.length >= 5) {
      var random = Random();
      // Generate two random wrong answers from other flashcards
      while (wrongAnswers.length < 3) {
        var randomIndex = random.nextInt(flashcards!.length);
        var wrongAnswer = flashcards![randomIndex].answer;
        // Ensure the wrong answer is not the same as the correct answer
        if (!wrongAnswers.contains(wrongAnswer)) {
          wrongAnswers.add(wrongAnswer);
        }
      }
    } else {
      // Use generic wrong answers if there are not enough flashcards
      wrongAnswers = ['A', 'B', 'C'];
    }

    // Shuffle the list of wrong answers
    wrongAnswers.shuffle();
    return wrongAnswers;
  }

  // Build a multiple choice option button
  Widget _buildOptionButton(String option) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          userAnswer = option;
          // Check answer immediately after selecting
          checkAnswer();
        });
      },
      child: Text(option),
    );
  }

  void checkAnswer() {
    if (userAnswer == flashcards![currentQuestionIndex].answer) {
      setState(() {
        isCorrect = true;
      });
    } else {
      setState(() {
        isCorrect = false;
      });
    }
  }
}

class Flashcard {
  final String question;
  final String answer;

  Flashcard({required this.question, required this.answer});

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      question: json['question'],
      answer: json['answer'],
    );
  }
}
