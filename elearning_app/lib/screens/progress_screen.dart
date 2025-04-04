import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  int totalAttempts = 0;
  int lastScore = 0;
  int totalCorrect = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      totalAttempts = prefs.getInt('totalAttempts') ?? 0;
      lastScore = prefs.getInt('lastScore') ?? 0;
      totalCorrect = prefs.getInt('totalCorrect') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Progress'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Literacy Progress',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Quizzes Taken: $totalAttempts',
                        style: const TextStyle(fontSize: 18)),
                    Text('Last Quiz Score: $lastScore',
                        style: const TextStyle(fontSize: 18)),
                    Text('Total Correct Answers: $totalCorrect',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text(
                      'Accuracy: ${totalAttempts > 0 ? ((totalCorrect / (totalAttempts * 3)) * 100).toStringAsFixed(1) : 0}%',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
