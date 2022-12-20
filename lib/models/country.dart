import './models.dart';

class Country {
  // properties of the country
  final double? area;
  final List? borders;
  final String commonName;
  final String code;
  final Map? currencies;
  final List? capitals;
  final String? coatOfArms;
  final List? continents;
  final Map? car;
  final Map? demonyms;
  final String? flag;
  final String? fifa;
  final String? flagUrl;
  final Map? gini;
  final bool? independent;
  final Map? idd;
  final Map? languages;
  final LatLng? latLng;
  final bool? landLocked;
  final String? mapsUrl;
  final String officialName;
  final int? population;
  final String? region;
  final String? subregion;
  final List? timezones;
  final List? tlds;
  final bool? unMember;

  const Country({
    required this.commonName,
    required this.officialName,
    required this.tlds,
    required this.code,
    required this.independent,
    required this.unMember,
    required this.currencies,
    required this.idd,
    required this.capitals,
    required this.region,
    required this.subregion,
    required this.languages,
    required this.latLng,
    required this.landLocked,
    required this.borders,
    required this.area,
    required this.demonyms,
    required this.flag,
    required this.mapsUrl,
    required this.population,
    required this.gini,
    required this.fifa,
    required this.car,
    required this.timezones,
    required this.continents,
    required this.flagUrl,
    required this.coatOfArms,
  });
}
