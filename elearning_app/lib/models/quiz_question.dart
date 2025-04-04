import 'package:flutter/material.dart';
import '../models/quiz_question.dart';
import '../data/literacy_data.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int? selectedAnswerIndex;
  bool showResult = false;
  int correctAnswers = 0;

  void checkAnswer(int index) {
    setState(() {
      selectedAnswerIndex = index;
      showResult = true;
      if (index == literacyQuestions[currentQuestionIndex].correctAnswerIndex) {
        correctAnswers++;
      }
    });
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < literacyQuestions.length - 1) {
        currentQuestionIndex++;
        selectedAnswerIndex = null;
        showResult = false;
      } else {
        // Quiz finished
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Quiz Complete!'),
            content: Text(
                'You got $correctAnswers out of ${literacyQuestions.length} correct!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context); // Back to HomeScreen
                  setState(() {
                    currentQuestionIndex = 0;
                    correctAnswers = 0;
                    selectedAnswerIndex = null;
                    showResult = false;
                  });
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = literacyQuestions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Literacy Quiz'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${currentQuestionIndex + 1}/${literacyQuestions.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              currentQuestion.question,
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 20),
            ...currentQuestion.options.asMap().entries.map((entry) {
              int idx = entry.key;
              String option = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedAnswerIndex == idx
                        ? (showResult
                            ? (idx == currentQuestion.correctAnswerIndex
                                ? Colors.green
                                : Colors.red)
                            : Colors.blue)
                        : null,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: showResult ? null : () => checkAnswer(idx),
                  child: Text(option, style: const TextStyle(fontSize: 18)),
                ),
              );
            }).toList(),
            const SizedBox(height: 20),
            if (showResult)
              ElevatedButton(
                onPressed: nextQuestion,
                child: Text(
                  currentQuestionIndex < literacyQuestions.length - 1
                      ? 'Next Question'
                      : 'Finish',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
