import 'package:flutter/foundation.dart';
import '../utils/enums/enums.dart';

class QuizProvider with ChangeNotifier {
  // all the quiz types
  final Map<String, QuizType> _quizTypes = {
    'Border': QuizType.border,
    'Capital': QuizType.capital,
    'Continent': QuizType.continent,
    'Currency': QuizType.currency,
    'Flag': QuizType.flag,
    'IDD': QuizType.idd,
    'Land locked': QuizType.landlocked,
    'Language': QuizType.language,
    'Sub region': QuizType.subRegion,
  };

  // active quiz types, defaults to capital, continent, flag, sub region, border
  final List<QuizType> _activeQuizTypes = [
    QuizType.capital,
    QuizType.continent,
    QuizType.flag,
    QuizType.subRegion,
    QuizType.border,
  ];

  // method to get all the quiz types
  Map<String, QuizType> getQuizTypes() {
    return _quizTypes;
  }

  // method to get the active quiz types
  List<QuizType> getActiveQuizTypes() {
    return _activeQuizTypes;
  }

  // method to add the quiz type to the list
  void addQuizType(QuizType type) {
    // adding the type to the list
    _activeQuizTypes.add(type);

    // notifying the listeners
    notifyListeners();
  }

  // method to remove the quiz type from the list
  void removeQuizType(QuizType type) {
    _activeQuizTypes.remove(type);

    // notifying the listeners
    notifyListeners();
  }
}
