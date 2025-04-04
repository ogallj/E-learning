import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz_question.dart';
import '../data/literacy_data.dart';
import 'dart:async';

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
  int totalAttempts = 0;
  late Timer _timer;
  int _timeLeft = 30;

  @override
  void initState() {
    super.initState();
    _loadProgress();
    _startTimer();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      totalAttempts = prefs.getInt('totalAttempts') ?? 0;
    });
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('totalAttempts', totalAttempts + 1);
    await prefs.setInt('lastScore', correctAnswers);
    await prefs.setInt(
        'totalCorrect', (prefs.getInt('totalCorrect') ?? 0) + correctAnswers);
  }

  void _startTimer() {
    _timeLeft = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer.cancel();
          if (!showResult) {
            checkAnswer(-1); // Auto-submit as incorrect
          }
          nextQuestion();
        }
      });
    });
  }

  void checkAnswer(int index) {
    setState(() {
      selectedAnswerIndex = index;
      showResult = true;
      if (index == literacyQuestions[currentQuestionIndex].correctAnswerIndex) {
        correctAnswers++;
      }
      _timer.cancel();
    });
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < literacyQuestions.length - 1) {
        currentQuestionIndex++;
        selectedAnswerIndex = null;
        showResult = false;
        _startTimer();
      } else {
        _timer.cancel();
        _saveProgress();
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
                  Navigator.pop(context);
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
  void dispose() {
    _timer.cancel();
    super.dispose();
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${currentQuestionIndex + 1}/${literacyQuestions.length}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Time Left: $_timeLeft s',
                  style: TextStyle(
                    fontSize: 18,
                    color: _timeLeft <= 10 ? Colors.red : Colors.black,
                  ),
                ),
              ],
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
