import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  static const String routeName = '/result-page';

  @override
  Widget build(BuildContext context) {
    // getting the arguments
    final Map data = ModalRoute.of(context)!.settings.arguments! as Map;

    // extracting the data
    final int correctAnswers = data['correct'];
    final int totalQuestions = data['total'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Score'),
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You Scored'),
            const SizedBox(
              height: 20,
            ),
            Text(
              '$correctAnswers / $totalQuestions',
              style: const TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'That\'s some insanity right there',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
