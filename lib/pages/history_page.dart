import 'package:flutter/material.dart';

import '../utils/helpers/helpers.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  static const String routeName = '/history-page';

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future _future;

  @override
  void initState() {
    super.initState();

    _future = DatabaseHelper.getAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz History'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          // if waiting
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // if has an error
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error occurred while fetching the data'),
            );
          }

          // if the data is empty
          if (snapshot.data.isEmpty) {
            return const Center(
              child: Text('No quiz history found!'),
            );
          }

          // reversing the data to show the last at the first position and so on
          final List data = (snapshot.data as List).reversed.toList();

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: data.length,
            itemBuilder: ((context, index) {
              // getting the current data
              final Map<String, Object?> current = data[index];

              // getting the data from the fields
              final int correctAnswers = current['correct_answers'] as int;
              final int totalQuestions = current['total_questions'] as int;
              final String date = current['date'] as String;
              final List<String> topics =
                  (current['topics'] as String).split(',');

              return Column(
                children: [
                  ExpansionTile(
                    title: Text(
                      'You scored $correctAnswers / $totalQuestions',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    iconColor: const Color(0xFF3F3D56),
                    subtitle: Text(date),
                    textColor: const Color(0xFF3F3D56),
                    childrenPadding: const EdgeInsets.only(
                      bottom: 20,
                    ),
                    expandedAlignment: Alignment.centerLeft,
                    children: [
                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 20),
                          child: Row(
                            children: topics.map((topic) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3F3D56),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                margin: const EdgeInsets.only(left: 10),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                child: Text(
                                  topic,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      )
                    ],
                  ),
                  if (index == data.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        'Only last 50 results are shown',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(.6),
                        ),
                      ),
                    ),
                ],
              );
            }),
          );
        },
      ),
    );
  }
}
