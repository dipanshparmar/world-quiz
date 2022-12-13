import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/models.dart';
import '../utils/enums/enums.dart';

class CountriesProvider with ChangeNotifier {
  // list to hold the countries
  final List<Country> _countries = [];

  // list to hold the search results
  List<Country> _searchResults = [];

  // method to load the countries
  Future<void> loadCountries() async {
    // making a http request
    final http.Response response = await http.get(
      Uri.parse('https://restcountries.com/v3.1/all'),
    );

    // getting the body
    final String body = response.body;

    // decoding the body
    final List decoded = jsonDecode((body));

    // going through all the decoded data
    for (int i = 0; i < decoded.length; i++) {
      // getting the current data
      final Map current = decoded[i];

      // fetching all the required information
      final String? commonName = current['name']['common'];
      final String? officialName = current['name']['official'];
      final List? tlds = current['tld'];
      final bool? independent = current['independent'];
      final bool? unMember = current['unMember'];
      final Map? currencies = current['currencies'];
      final Map? idd = current['idd'];
      final List? capitals = current['capital'];
      final String? region = current['region'];
      final String? subregion = current['subregion'];
      final Map? languages = current['languages'];
      final List? latLng = current['latlng'];
      final bool? landLocked = current['landlocked'];
      final List? borders = current['borders'];
      final double? area = current['area'];
      final Map? demonyms = current['demonyms'];
      final String? flag = current['flag'];
      final String? mapsUrl = current['maps']['googleMaps'];
      final int? population = current['population'];
      final Map? gini = current['gini'];
      final String? fifa = current['fifa'];
      final Map? car = current['car'];
      final List? timezones = current['timezones'];
      final List? continents = current['continents'];
      final String? flagUrl = current['flags']['png'];
      final String? coatOfArms = current['coatOfArms']['png'];

      // creating a Country
      final Country country = Country(
        commonName: commonName,
        officialName: officialName,
        tlds: tlds,
        independent: independent,
        unMember: unMember,
        currencies: currencies,
        idd: idd,
        capitals: capitals,
        region: region,
        subregion: subregion,
        languages: languages,
        latLng: latLng != null ? LatLng(lat: latLng[0], lng: latLng[1]) : null,
        landLocked: landLocked,
        borders: borders,
        area: area,
        demonyms: demonyms,
        flag: flag,
        mapsUrl: mapsUrl,
        population: population,
        gini: gini,
        fifa: fifa,
        car: car,
        timezones: timezones,
        continents: continents,
        flagUrl: flagUrl,
        coatOfArms: coatOfArms,
      );

      // adding the country to the list
      _countries.add(country);
    }
  }

  // method to get the countries according to a search type
  void filterBy(SearchType searchType, String query) {
    // trimming the query
    query = query.trim();

    // filtering and returning the countries according to the type
    if (searchType == SearchType.country) {
      _searchResults = _countries.where((e) {
        // if both the names are null
        if (e.officialName == null && e.commonName == null) {
          return false;
        }

        // if official name is null but the common name is not
        if (e.officialName == null && e.commonName != null) {
          return e.commonName!.toLowerCase().contains(query.toLowerCase());
        }

        // if official name is not null but the common name is null
        if (e.officialName != null && e.commonName == null) {
          return e.officialName!.toLowerCase().contains(query.toLowerCase());
        }

        // if both the names are not null
        return e.officialName!.toLowerCase().contains(query.toLowerCase()) ||
            e.commonName!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } else if (searchType == SearchType.currency) {
      _searchResults = _countries.where((e) {
        // if currencies is empty then return false
        if (e.currencies == null || e.currencies!.isEmpty) {
          return false;
        }

        return e.currencies!.values.any((element) {
          // if name is null then return false
          if (element['name'] == null) {
            return false;
          }

          // otherwise return the result accordingly
          return element['name'].toLowerCase().contains(query.toLowerCase());
        });
      }).toList();
    } else if (searchType == SearchType.capital) {
      _searchResults = _countries.where((e) {
        // if capital is null or is empty then return false
        if (e.capitals == null || e.capitals!.isEmpty) {
          return false;
        }

        return e.capitals!.any((capital) {
          return capital.toLowerCase().contains(query.toLowerCase());
        });
      }).toList();
    } else if (searchType == SearchType.language) {
      _searchResults = _countries.where((e) {
        if (e.languages == null || e.languages!.isEmpty) {
          return false;
        }

        return e.languages!.values.any((language) {
          return language.toLowerCase().contains(query.toLowerCase());
        });
      }).toList();
    } else {
      _searchResults = [];
    }

    notifyListeners();
  }

  // getter to get the countries
  List<Country> getCountries() {
    return _countries;
  }

  // getter to get the search results
  List<Country> getSearchResults() {
    return _searchResults;
  }
}
