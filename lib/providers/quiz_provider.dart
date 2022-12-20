import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/enums/enums.dart';
import '../utils/functions/functions.dart';
import '../models/models.dart';
import '../providers/providers.dart';

class QuizProvider with ChangeNotifier {
  // all the quiz types
  final Map<String, QuizType> _quizTypes = {
    'Border': QuizType.border,
    'Capital': QuizType.capital,
    'Continent': QuizType.continent,
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

  // function to get the idds list from a map
  List<String> getIdds(Country countryWithIDD) {
    // getting the idd root
    final String iddRoot = countryWithIDD.idd!['root'];

    return (countryWithIDD.idd!['suffixes'] as List).map(
      (suffix) {
        return '$iddRoot$suffix';
      },
    ).toList();
  }

  // method to get the question data
  Map getQuestionData(BuildContext context) {
    // randomly getting a type
    final QuizType quizType = getRand(_activeQuizTypes);

    // countries provider
    final CountriesProvider countriesProvider =
        Provider.of<CountriesProvider>(context, listen: false);

    // getting all the countries
    final List<Country> allCountries = countriesProvider.getCountries();

    // map to hold the prototype of the question data
    final Map<String, Object> questionData = {
      'question': '',
      'choices': [],
      'answer': '',
    };

    // validating the type
    switch (quizType) {
      case QuizType.border:
        {
          // to hold the country that has borders
          Country? countryWithBorders;

          // selecting the country
          while (countryWithBorders == null) {
            // get a random country
            final Country randomCountry = getRand(allCountries) as Country;

            // if country has borders then set it
            if (randomCountry.borders != null &&
                randomCountry.borders!.isNotEmpty) {
              countryWithBorders = randomCountry;
            }
          }

          // getting a random border
          final String randomAnswerBorder = countriesProvider
              .getCountryByCode(getRand(countryWithBorders.borders!) as String)
              .commonName;

          // list to hold the choices
          List<String> choices = [
            randomAnswerBorder
          ]; // holds the answer by default

          // running a loop while the length of choices is not 4
          while (choices.length != 4) {
            // getting a random country
            final Country tempRandomCountry = getRand(allCountries) as Country;

            // if temp random country is not the question country and not in the question country's borders then set it's common name
            if (tempRandomCountry != countryWithBorders &&
                !countryWithBorders.borders!.contains(tempRandomCountry.code)) {
              choices.add(tempRandomCountry.commonName);
            }
          }

          // setting the question
          questionData['question'] =
              '${countryWithBorders.commonName} shares border with?';

          // setting the answer
          questionData['answer'] = randomAnswerBorder;

          // setting the choices
          questionData['choices'] = choices;
        }

        break;
      case QuizType.capital:
        {
          // to hold the country that has a capital
          Country? countryWithCapital;

          // while the country is null, loop
          while (countryWithCapital == null) {
            // reading a random country
            final Country randomCountry = getRand(allCountries);

            // if the country has a capital then set it
            if (randomCountry.capitals != null &&
                randomCountry.capitals!.isNotEmpty) {
              countryWithCapital = randomCountry;
            }
          }

          // getting a random capital as the answer
          final String capital = getRand(countryWithCapital.capitals!);

          // storing the choices
          final List<String> choices = [capital];

          // while the length of the choices is not 4, loop
          while (choices.length != 4) {
            // getting a random country
            final Country randomCountry = getRand(allCountries);

            // if random country is same then skip it
            if (randomCountry == countryWithCapital) {
              continue;
            }

            // if has the capital
            if (randomCountry.capitals != null &&
                randomCountry.capitals!.isNotEmpty) {
              // getting the random capital
              final String randomCapital = getRand(randomCountry.capitals!);

              // set the choice as a random capital only if not already present
              if (!choices.contains(randomCapital)) {
                choices.add(randomCapital);
              }
            }
          }

          // setting the data
          questionData['question'] =
              'What is the capital of ${countryWithCapital.commonName}?';

          // setting the answer
          questionData['answer'] = capital;

          // setting the choices
          questionData['choices'] = choices;
        }
        break;
      case QuizType.continent:
        {
          // getting the continents
          final List<String> continents = countriesProvider.getContinents();

          // to hold the country that has a continent
          Country? countryWithContinent;

          // running a while loop
          while (countryWithContinent == null) {
            // getting a random country
            final Country randomCountry = getRand(allCountries);

            // if country has a continent then set it
            if (randomCountry.continents != null &&
                randomCountry.continents!.isNotEmpty) {
              countryWithContinent = randomCountry;
            }
          }

          // getting the answer
          final String answer = getRand(countryWithContinent.continents!);

          // list to hold the choices
          List<String> choices = [answer];

          // setting the choices
          while (choices.length != 4) {
            // getting a random continent
            final String randomContinent = getRand(continents);

            // if random continent not already in then add it
            if (!choices.contains(randomContinent)) {
              choices.add(randomContinent);
            }
          }

          // setting the data
          questionData['question'] =
              '${countryWithContinent.commonName} is in what continent?';

          questionData['answer'] = answer;

          questionData['choices'] = choices;
        }
        break;
      case (QuizType.flag):
        {
          // to hold the country with a flag
          Country? countryWithFlag;

          // while the country is null
          while (countryWithFlag == null) {
            // getting a random country
            final Country randomCountry = getRand(allCountries);

            // if country has a flag then set it
            if (randomCountry.flag != null) {
              countryWithFlag = randomCountry;
            }
          }

          // setting the answer
          final String answer = countryWithFlag.commonName;

          // setting the options
          final List<String> choices = [answer];

          // while the length of the choices is not 4
          while (choices.length != 4) {
            // getting a random country
            final Country randomCountry = getRand(allCountries);

            // if the random country doesn't already exists in the choices, then add it
            if (!choices.contains(randomCountry.commonName)) {
              choices.add(randomCountry.commonName);
            }
          }

          // setting the question
          questionData['question'] =
              '"${countryWithFlag.flag}" This flag belongs to?';

          // setting the answer
          questionData['answer'] = answer;

          // setting the choices
          questionData['choices'] = choices;
        }
        break;
      case (QuizType.idd):
        {
          // to hold the country with idd
          Country? countryWithIDD;

          // while null
          while (countryWithIDD == null) {
            // getting a random country
            final Country randomCountry = getRand(allCountries);

            // if idd then set it
            if (randomCountry.idd != null && randomCountry.idd!.isNotEmpty) {
              // setting the country
              countryWithIDD = randomCountry;
            }
          }

          // constructing the IDDs
          final List<String> idds = getIdds(countryWithIDD);

          // setting the answer as a random idd
          final String answer = getRand(idds);

          // list to hold the choices
          final List<String> choices = [answer];

          // while not 4 choices
          while (choices.length != 4) {
            // getting a random country
            final Country randomCountry = getRand(allCountries);

            // if this country has the idd and not the original country
            if (randomCountry != countryWithIDD &&
                randomCountry.idd != null &&
                randomCountry.idd!.isNotEmpty) {
              // getting the list idds
              final List<String> iddsTemp = getIdds(randomCountry);

              // selecting a random idd
              final String randomIdd = getRand(iddsTemp);

              // if idd not already in choices then add it
              if (!choices.contains(randomIdd)) {
                choices.add(randomIdd);
              }
            }
          }

          // setting the data
          questionData['question'] =
              'What is the IDD of ${countryWithIDD.commonName}';

          questionData['answer'] = answer;

          questionData['choices'] = choices;
        }
        break;
      case (QuizType.landlocked):
        {
          // to hold the country with landlocked status
          Country? countyWithLandlocked;

          // while null
          while (countyWithLandlocked == null) {
            // getting a random country
            final Country randomCountry = getRand(allCountries);

            // if has landlocked then set the country
            if (randomCountry.landLocked != null) {
              countyWithLandlocked = randomCountry;
            }
          }

          // setting the answer
          final String answer = capitalize(
            countyWithLandlocked.landLocked.toString(),
          );

          // list to hold the choices
          final List<String> choices = ['True', 'False'];

          // setting the data
          questionData['question'] =
              'Is ${countyWithLandlocked.commonName} landlocked?';

          questionData['answer'] = answer;

          // setting the choices
          questionData['choices'] = choices;
        }
        break;
      case (QuizType.language):
        {
          // to hold the country with language
          Country? countryWithLanguage;

          // while null
          while (countryWithLanguage == null) {
            // getting a random country
            final Country randomCountry = getRand(allCountries);

            // if has language
            if (randomCountry.languages != null &&
                randomCountry.languages!.isNotEmpty) {
              countryWithLanguage = randomCountry;
            }
          }

          // getting the languages
          final List languages = countryWithLanguage.languages!.values.toList();

          // setting a random language as the answer
          final String answer = getRand(languages);

          // to hold the choices
          final List<String> choices = [answer];

          // running a while loop
          while (choices.length != 4) {
            // getting a random country
            final Country randomCountry = getRand(allCountries);

            // if randomCountry isn't as same as the original and has languages
            if (randomCountry != countryWithLanguage &&
                randomCountry.languages != null &&
                randomCountry.languages!.isNotEmpty) {
              // getting the values
              final tempLanguages = randomCountry.languages!.values.toList();

              // setting the random language as a choice if not already there
              final String randomLanguage = getRand(tempLanguages);

              if (!choices.contains(randomLanguage)) {
                choices.add(randomLanguage);
              }
            }
          }

          // setting the data
          questionData['question'] =
              'What language is spoken in ${countryWithLanguage.commonName}';

          questionData['answer'] = answer;

          questionData['choices'] = choices;
        }
        break;
      case (QuizType.subRegion):
        {
          // to hold the country with a sub region
          Country? countryWithSubRegion;

          // while is null
          while (countryWithSubRegion == null) {
            // getting a random country
            final Country randomCountry = getRand(allCountries);

            // setting the country if has a sub region
            if (randomCountry.subregion != null) {
              countryWithSubRegion = randomCountry;
            }
          }

          // getting the answer
          final String answer = countryWithSubRegion.subregion!;

          // getting the choices
          List<String> choices = [answer];

          while (choices.length != 4) {
            // getting a random country
            final Country randomCountry = getRand(allCountries);

            // if not same as the original country and has a sub region
            if (randomCountry != countryWithSubRegion &&
                randomCountry.subregion != null) {
              // if sub region not already an option
              if (!choices.contains(randomCountry.subregion)) {
                choices.add(randomCountry.subregion!);
              }
            }
          }

          // setting the data
          questionData['question'] =
              '${countryWithSubRegion.commonName} belongs to which sub region?';

          questionData['answer'] = answer;

          questionData['choices'] = choices;
        }
        break;
    }

    // shuffling the choices 5 times
    for (int i = 0; i < 5; i++) {
      (questionData['choices'] as List).shuffle();
    }

    // returning the question data
    return questionData;
  }
}

// TODO: BEFORE ADDING TO THE OPTIONS, CHECK IF ALREADY IN OR NOT