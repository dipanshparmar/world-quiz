import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import './pages.dart';
import '../utils/helpers/database_helper.dart';
import '../utils/enums/enums.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  static const String routeName = '/question-page';

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  // question no. Starts from 1
  int currentQuestion = 1;

  // state whether to show the colors or not
  bool clicked = false;

  // initially the last question data is an empty object
  Map lastQuestionData = {};

  // to store the clicked index
  int clickedIndex = -1;

  // hold the count of correct answers
  int correctAnswers = 0;

  // state to store whether the results are being saved in the DB or not
  bool isSaving = false;

  // function to get the flag from the question format i.e. "[flg]" something something
  Map<String, String> getFlagData(String question) {
    // splitting the string by spaces
    List<String> splitted = question.split(' ');

    // returning the flag and the question
    return {
      'flag': splitted[0].replaceAll('"', ''),
      'question': splitted.sublist(1).join(' '),
    };
  }

  @override
  Widget build(BuildContext context) {
    // grabbing the total question
    final int totalQuestions =
        Provider.of<QuizProvider>(context, listen: false).getTotalQuestions();

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
        body: Stack(
          children: [
            Consumer<QuizProvider>(
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
                final QuizType quizType = questionData['type'];

                return SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // if quiz type is flag
                      if (quizType == QuizType.flag)
                        Text(
                          getFlagData(question)['flag']!,
                          style: const TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      if (quizType == QuizType.flag)
                        const SizedBox(
                          height: 5,
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          quizType == QuizType.flag
                              ? getFlagData(question)[
                                  'question']! // removing the flag from the question and then showing
                              : question, // if not quiz type flag then show the complete question
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
                                await Future.delayed(
                                    const Duration(seconds: 1));

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
                                  // setting the state to true
                                  setState(() {
                                    isSaving = true;
                                  });

                                  // saving the data to the DB
                                  DatabaseHelper.insert({
                                    'correct_answers': correctAnswers,
                                    'total_questions': totalQuestions,
                                    'date': DateFormat.yMMMMd('en_us').format(
                                      DateTime.now(),
                                    ),
                                    'topics': value
                                        .getActiveQuizTypes()
                                        .map((e) {
                                          return value
                                              .getStringRepresentationOfQuizType(
                                                  e);
                                        })
                                        .toList()
                                        .join(','),
                                  }).then((value) {
                                    // once saved the data, push the results page
                                    Navigator.of(context).pushReplacementNamed(
                                      ResultPage.routeName,
                                      arguments: {
                                        'correct': correctAnswers,
                                        'total': totalQuestions,
                                      },
                                    );
                                  });
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(15),
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
            if (isSaving)
              Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.black.withOpacity(.8),
                child: const Center(
                  child: Text(
                    'Saving . . .',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
