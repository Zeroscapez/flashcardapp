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
          textAlign: TextAlign.center, // Align header text to center
          style: TextStyle(fontSize: 40), // Set font size of header text
        ),
        backgroundColor: Colors.blue,
        centerTitle: true, // Center the header text
      ),
      backgroundColor: Colors.blue, // Set background color of Scaffold
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
                            .FlashcardPage()), // Use the prefix for FlashcardPage
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
                        builder: (context) => const QuizModePage.QuizModePage(
                              flashcards: [],
                            )), // Use the prefix for QuizModePage
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
