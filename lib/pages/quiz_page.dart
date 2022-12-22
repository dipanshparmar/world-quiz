import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../utils/enums/enums.dart';
import '../providers/providers.dart';
import '../pages/pages.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  static const String routeName = '/quiz-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'Are you sure you are ready for the hardest quiz of this world?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildQuizTypes(context),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: _buildBottomNav(context),
            )
          ],
        ),
      ),
    );
  }

  Row _buildBottomNav(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Consumer<QuizProvider>(
            builder: ((context, value, child) {
              // getting the active quiz types boolean
              final bool hasActiveQuizTypes =
                  value.getActiveQuizTypes().isEmpty ? false : true;

              return InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: hasActiveQuizTypes
                    ? () {
                        Navigator.of(context).pushNamed(QuestionPage.routeName);
                      }
                    : () {},
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: hasActiveQuizTypes
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'Let\'s Do This',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          onTap: () {
            // pushing the history page
            Navigator.of(context).pushNamed(HistoryPage.routeName);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(50),
            ),
            padding: const EdgeInsets.all(18),
            child: const Icon(
              Icons.history,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildQuizTypes(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: ((context, value, child) {
        // getting all the quiz types
        final Map<String, QuizType> quizTypes = value.getQuizTypes();

        // getting the active quiz types
        final List<QuizType> activeQuizTypes = value.getActiveQuizTypes();

        return Wrap(
          spacing: 5,
          runSpacing: 5,
          alignment: WrapAlignment.center,
          children: quizTypes.entries.map((e) {
            // deciding that whether the current type is active or not
            final bool isActive = activeQuizTypes.contains(e.value);

            return GestureDetector(
              onTap: () {
                // if is active then remove it, active it otherwise
                isActive
                    ? value.removeQuizType(e.value)
                    : value.addQuizType(e.value);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isActive ? Theme.of(context).primaryColor : null,
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                child: Text(
                  e.key,
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.black,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }),
    );
  }
}
