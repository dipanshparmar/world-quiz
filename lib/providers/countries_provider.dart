import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/models.dart';
import '../utils/enums/enums.dart';

class CountriesProvider with ChangeNotifier {
  // list to hold the countries
  final List<Country> _countries = [];

  // list to hold the search results
  List<Country> _searchResults = [];

  // list to hold the filtered countries
  List<Country> _filteredCountries = [];

  // storing the active filters
  final Map<FilterType, List<String>> _activeFilters = {
    FilterType.continent: [],
    FilterType.subRegion: [],
  };

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
      final String commonName = current['name']['common'];
      final String officialName = current['name']['official'];
      final List? tlds = current['tld'];
      final String countryCode = current['cca3'];
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
        code: countryCode,
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

    // notifying the listeners
    notifyListeners();
  }

  // getter to get the status of data
  bool isDataLoaded() {
    return _countries.isNotEmpty;
  }

  // method to get the countries according to a search type
  void filterBy(SearchType searchType, String query) {
    // trimming the query
    query = query.trim();

    // filtering and returning the countries according to the type
    if (searchType == SearchType.country) {
      _searchResults = _countries.where((e) {
        return e.officialName.toLowerCase().contains(query.toLowerCase()) ||
            e.commonName.toLowerCase().contains(query.toLowerCase());
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

  // method to get the continents
  List<String> getContinents() {
    // list to hold the continents
    List<String> continents = [];

    // going through all the countries
    for (int i = 0; i < _countries.length; i++) {
      // getting the continents of current country
      final List? conts = _countries[i].continents;

      // if conts is not null and not empty then iterate over them
      if (conts != null && conts.isNotEmpty) {
        for (int i = 0; i < conts.length; i++) {
          // if current continent is not already in the list of continents then add it
          if (!continents.contains(conts[i])) {
            continents.add(conts[i]);
          }
        }
      }
    }

    return continents;
  }

  // method to get the regions
  List<String> getSubregions() {
    // list to store the regions
    List<String> subregions = [];

    // running a for loop for the length of the countries times
    for (int i = 0; i < _countries.length; i++) {
      // getting the current countries' regions
      final String? subregion = _countries[i].subregion;

      // if region is not null and not an empty string
      if (subregion != null && subregion.isNotEmpty) {
        // adding the subregion to the list if not already present
        if (!subregions.contains(subregion)) {
          subregions.add(subregion);
        }
      }
    }

    return subregions;
  }

  // function to apply a filter
  void applyFilter(FilterType filterType, String filterValue) {
    // if filter type is not one of the supposed, then throw an exception
    if (!(filterType == FilterType.continent ||
        filterType == FilterType.subRegion)) {
      throw TypeError();
    }

    // otherwise add the filter to the active filters
    _activeFilters[filterType]!.add(filterValue);

    // updating the filtered countries
    _updateFilteredCountries();

    // notifying the listeners
    notifyListeners();
  }

  void removeFilter(FilterType filterType, String filterValue) {
    // if filter type is not the supported one then throw an exception
    if (!(filterType == FilterType.continent ||
        filterType == FilterType.subRegion)) {
      throw TypeError();
    }

    // otherwise removing the filter from the active filters
    _activeFilters[filterType]!.remove(filterValue);

    // updating the filtered countries
    _updateFilteredCountries();

    // notifying the listeners
    notifyListeners();
  }

  // private function to update the filtered countries
  void _updateFilteredCountries() {
    _filteredCountries = _countries.where((country) {
      // getting the current country's continents
      final List? currentCountrysContinents = country.continents;

      // if current country's any continent matches with the filter continents then return true
      if (currentCountrysContinents != null) {
        // if the filter continents has any of the current country's continent matching then return true
        bool hasAny = currentCountrysContinents.any((continent) {
          return _activeFilters[FilterType.continent]!.contains(continent);
        });

        // if has any then return true
        if (hasAny) {
          return true;
        }
      }

      // getting the subregion
      final String? subregion = country.subregion;

      // if current country's sub region matches with the filter subregions then return true
      if (subregion != null) {
        if (_activeFilters[FilterType.subRegion]!.contains(subregion)) {
          return true;
        }
      }

      // return false if none of the filtered match above
      return false;
    }).toList();
  }

  // method to clear the filters
  void clearFilters() {
    // emptying the filters
    _activeFilters[FilterType.continent] = [];
    _activeFilters[FilterType.subRegion] = [];

    // updating the countries
    _updateFilteredCountries();

    // notifying the listeners
    notifyListeners();
  }

  // method to return true or false depening whether there are filters active or not
  bool hasActiveFilters() {
    return _activeFilters[FilterType.continent]!.isNotEmpty ||
        _activeFilters[FilterType.subRegion]!.isNotEmpty;
  }

  // getter to get the countries
  List<Country> getCountries() {
    return _countries;
  }

  // getter to get the search results
  List<Country> getSearchResults() {
    return _searchResults;
  }

  // getter to get the filtered countries
  List<Country> getFilteredCountries() {
    return _filteredCountries;
  }

  // getter to get the active filters
  Map getActiveFilters() {
    return _activeFilters;
  }

  // method to get the name of the country by code
  Country getCountryByCode(String code) {
    return _countries.firstWhere((element) => element.code == code);
  }
}
