import 'package:flutter/material.dart';
import 'flashcard_page.dart'
    as FlashcardPage; // Import flashcard_page.dart with prefix
import 'quiz_mode_page.dart'
    as QuizModePage; // Import quiz_mode_page.dart with prefix

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flashcard Quizzer',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 40),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FlashcardPage
                            .FlashcardPage()), // Reference FlashcardPage
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide(color: Colors.blue),
                  ),
                  backgroundColor: Colors.yellow,
                ),
                child: const Text(
                  'View Flashcards',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16), // Optional spacing between buttons
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const QuizModePage.QuizModePage()), // Reference QuizMode
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide(color: Colors.blue),
                  ),
                  backgroundColor: Colors.red,
                ),
                child: const Text(
                  'Start Quiz Mode',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
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
