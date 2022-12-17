import 'package:flutter/foundation.dart';

class LoadingTextsProvider with ChangeNotifier {
  // loading texts
  final List<String> _loadingTexts = [
    'Almost there.',
    'Should be available any minute now.',
    'Still not loaded yet?',
    'Hmm! Is this normal?',
    'Umm . . .',
    'We can only wait at this point.',
  ];

  // active text
  String _activeText = 'Loading your data . . .';

  // method to update the text periodically
  void updateTextPeriodically() async {
    // index
    int index = 1;

    // setting a do while
    await Future.doWhile(() async {
      // if index exceeds, then return false
      if (index == _loadingTexts.length) {
        return false;
      }

      // awaiting for 2 seconds
      await Future.delayed(const Duration(seconds: 3));

      // setting the active text to current index
      _activeText = _loadingTexts[index];

      // notifying the listeners
      notifyListeners();

      // incrementing the index
      index++;

      return true;
    });
  }

  // getter for the text
  String getActiveText() {
    return _activeText;
  }
}
