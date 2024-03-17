import 'package:flutter/material.dart';
import 'package:pw1/flashcard_page.dart'
    as FlashcardPage; // Alias for Flashcard class in flashcard_page.dart

class QuizModePage extends StatefulWidget {
  final List<FlashcardPage.Flashcard> flashcards;

  const QuizModePage({super.key, required this.flashcards});

  @override
  _QuizModePageState createState() => _QuizModePageState();
}

class _QuizModePageState extends State<QuizModePage> {
  int currentQuestionIndex = 0;
  String userAnswer = '';
  bool isCorrect = false;

  @override
  Widget build(BuildContext context) {
    // Check if flashcards list is empty
    if (widget.flashcards.isEmpty) {
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
            Text(
              'Question ${currentQuestionIndex + 1}: ${widget.flashcards[currentQuestionIndex].question}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                userAnswer = value;
              },
              decoration: const InputDecoration(
                labelText: 'Your Answer',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                checkAnswer();
                setState(() {
                  currentQuestionIndex++;
                  isCorrect = false; // Reset isCorrect flag
                  userAnswer = ''; // Clear user answer
                });
              },
              child: const Text('Next'),
            ),
            const SizedBox(height: 20),
            Text(
              isCorrect ? 'Correct!' : 'Incorrect!',
              style: TextStyle(
                color: isCorrect ? Colors.green : Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkAnswer() {
    if (userAnswer == widget.flashcards[currentQuestionIndex].answer) {
      isCorrect = true;
    } else {
      isCorrect = false;
    }
  }
}
