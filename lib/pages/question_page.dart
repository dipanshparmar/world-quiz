import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import './pages.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  static const String routeName = '/question-page';

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  // question no. Starts from 1
  int currentQuestion = 1;

  // total questions
  final int totalQuestions = 10;

  // state whether to show the colors or not
  bool clicked = false;

  // initially the last question data is an empty object
  Map lastQuestionData = {};

  // to store the clicked index
  int clickedIndex = -1;

  // hold the count of correct answers
  int correctAnswers = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: ((context) {
            return AlertDialog(
              title: const Text(
                'Are your sure?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              content: const Text(
                'You will lose your current progress.',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              actions: [
                InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  onTap: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      'No',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  onTap: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text('Yes'),
                  ),
                ),
              ],
            );
          }),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('$currentQuestion / $totalQuestions'),
          centerTitle: true,
        ),
        body: Consumer<QuizProvider>(
          builder: ((context, value, child) {
            // getting the question data
            final Map questionData =
                clicked ? lastQuestionData : value.getQuestionData(context);

            // setting the last question data
            // this will help when updating the colors so that we don't get the new data while updating the colors for this question
            lastQuestionData = questionData;

            // extracting the data
            final String question = questionData['question'];
            final List<String> choices = questionData['choices'];
            final String answer = questionData['answer'];

            return SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      question,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: choices.asMap().entries.map((entry) {
                      // bool to decide whether this entry is last or not
                      final bool isLast = entry.key == choices.length - 1;

                      // bool to decide whether this is the answer or not
                      final bool isAnswer = entry.value == answer;

                      return Padding(
                        padding: EdgeInsets.only(
                          right: 40,
                          left: 40,
                          bottom: isLast ? 0 : 5,
                        ),
                        child: InkWell(
                          customBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onTap: () async {
                            // making sure we are not allowing the clicks in the delay period
                            if (clicked) return;

                            // setting clicked to true
                            setState(() {
                              clicked = true;

                              // is is answer then increment the correct answer
                              if (isAnswer) {
                                correctAnswers++;
                              }

                              // setting the clicked index
                              clickedIndex = entry.key;
                            });

                            // delaying 1 second before performing the operation
                            await Future.delayed(const Duration(seconds: 1));

                            // if current question is less than the total questions then increment it
                            if (currentQuestion < totalQuestions) {
                              setState(() {
                                // getting to the next question
                                currentQuestion++;

                                // setting clicked to false as we have gone to the next question
                                clicked = false;

                                // resetting the clicked index to -1
                                clickedIndex = -1;
                              });
                            } else {
                              // if we have processed total questions then go to the results page
                              Navigator.of(context).pushReplacementNamed(
                                ResultPage.routeName,
                                arguments: {
                                  'correct': correctAnswers,
                                  'total': totalQuestions,
                                },
                              );
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: isAnswer && clicked
                                    ? Colors.green.shade900
                                    : entry.key == clickedIndex && clicked
                                        ? Colors.red.shade900
                                        : Theme.of(context).primaryColor,
                              ),
                              color: isAnswer && clicked
                                  ? Colors.green.shade900
                                  : entry.key == clickedIndex && clicked
                                      ? Colors.red.shade900
                                      : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              entry.value,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: (isAnswer && clicked) ||
                                        entry.key == clickedIndex
                                    ? Colors.white
                                    : null,
                                fontWeight: (isAnswer && clicked) ||
                                        entry.key == clickedIndex
                                    ? FontWeight.bold
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
