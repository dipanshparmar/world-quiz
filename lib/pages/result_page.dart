import 'package:flutter/material.dart';

import '../utils/functions/functions.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  static const String routeName = '/result-page';

  // method to get a message according to the score
  String? getMessage(int score, int total) {
    // getting the percentage amount
    double percentage = getPercentage(score, total);

    // getting the percentage in scale of 10
    int inTenScale = percentage ~/ 10;

    // returning a message according to the ten scale
    if (inTenScale == 1) {
      return 'That\'s a good start.';
    } else if (inTenScale == 2) {
      return 'Climbing the stairs just like that.';
    } else if (inTenScale == 3) {
      return 'Got 30% of the answers correct.';
    } else if (inTenScale == 4) {
      return 'Nice! Almost reached the half.';
    } else if (inTenScale == 5) {
      return 'Woohoo! You got half of the answers correct.';
    } else if (inTenScale == 6) {
      return 'Wonderful.';
    } else if (inTenScale == 7) {
      return 'Impressive.';
    } else if (inTenScale == 8) {
      return 'You deserve a treat today.';
    } else if (inTenScale == 9) {
      return 'That\'s some insanity right there.';
    } else if (inTenScale == 10) {
      return 'Don\'t you have a life?';
    }

    // otherwise just return null
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // getting the arguments
    final Map data = ModalRoute.of(context)!.settings.arguments! as Map;

    // extracting the data
    final int correctAnswers = data['correct'];
    final int totalQuestions = data['total'];

    final String? message = getMessage(correctAnswers, totalQuestions);

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
            // if we have a message then show it
            if (message != null)
              const SizedBox(
                height: 20,
              ),
            if (message != null)
              Text(
                message,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
