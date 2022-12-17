import 'dart:io';

import 'package:flutter/material.dart';
import '../models/country.dart';
import '../widgets/widgets.dart';
import './pages.dart';
import '../utils/functions/functions.dart';

class CountryPage extends StatelessWidget {
  const CountryPage({super.key});

  // route name
  static const String routeName = '/country-page';

  @override
  Widget build(BuildContext context) {
    // getting the country from the arguments
    final Country country =
        ModalRoute.of(context)!.settings.arguments as Country;

    return Scaffold(
      appBar: AppBar(
        title: Text(country.commonName ?? 'Undefined'),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            if (country.flagUrl != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                height: 200,
                width: double.infinity,
                child: getNetworkImage(country.flagUrl!),
              ),
            const SizedBox(
              height: 40,
            ),
            getCountryNames(
              country.officialName ?? 'Undefined',
              country.commonName ?? 'Undefined',
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (country.area != null && country.area! > 0)
                    InfoSection(
                      heading: 'Area',
                      items: ['${country.area} Sq. Km.'],
                    ),
                  if (country.borders != null && country.borders!.isNotEmpty)
                    InfoSection(
                      heading: 'Border(s)',
                      items: country.borders!,
                    ),
                  if (country.capitals != null && country.capitals!.isNotEmpty)
                    InfoSection(
                      heading: 'Capital(s)',
                      items: country.capitals!,
                    ),
                  if (country.car != null &&
                      country.car!.isNotEmpty &&
                      country.car!.containsKey('side'))
                    InfoSection(
                      heading: 'Car side',
                      items: [country.car!['side']],
                    ),
                  if (country.car != null &&
                      country.car!.isNotEmpty &&
                      country.car!.containsKey('signs') &&
                      // making sure there are no empty string to render
                      (country.car!['signs'] as List)
                          .where((e) => e.isNotEmpty)
                          .toList()
                          .isNotEmpty)
                    InfoSection(
                      heading: 'Car signs',
                      items: (country.car!['signs'] as List).map((e) {
                        return e;
                      }).toList(),
                    ),
                  if (country.coatOfArms != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Heading('Coat of Arms'),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          height: 150,
                          width: double.infinity,
                          child: getNetworkImage(country.coatOfArms!),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  if (country.continents != null &&
                      country.continents!.isNotEmpty)
                    InfoSection(
                      heading: 'Continent(s)',
                      items: country.continents!,
                    ),
                  if (country.currencies != null &&
                      country.currencies!.isNotEmpty)
                    InfoSection(
                      heading: 'Currencies',
                      items: country.currencies!.values.map((e) {
                        // final currency string
                        String cString = "";

                        if ((e as Map).containsKey('name')) {
                          cString += e['name'] + ' ';
                        }

                        if (e.containsKey('symbol')) {
                          cString += "(${e['symbol']})";
                        }

                        // removing the leading or trailing spaces and returning the final string
                        return cString.trim();
                      }).toList(),
                    ),
                  if (country.demonyms != null &&
                      country.demonyms!.isNotEmpty &&
                      country.demonyms!.containsKey('eng') &&
                      ((country.demonyms!['eng'] as Map).containsKey('f') ||
                          (country.demonyms!['eng'] as Map).containsKey('m')))
                    InfoSection(
                      heading: 'Demonyms',
                      items: [
                        if (country.demonyms!['eng'].containsKey('f'))
                          "${country.demonyms!['eng']['f']} (f)",
                        if (country.demonyms!['eng'].containsKey('m'))
                          "${country.demonyms!['eng']['m']} (m)",
                      ],
                    ),
                  if (country.fifa != null)
                    InfoSection(
                      heading: 'Fifa',
                      items: [country.fifa],
                    ),
                  if (country.gini != null && country.gini!.isNotEmpty)
                    InfoSection(
                      heading: 'Gini',
                      items: country.gini!.keys.map((e) {
                        return '${country.gini![e]} ($e)';
                      }).toList(),
                    ),
                  if (country.idd != null && country.idd!.isNotEmpty)
                    InfoSection(
                      heading: 'IDD prefix',
                      items: (country.idd!['suffixes'] as List).map((e) {
                        // getting the root
                        final String root = country.idd!['root'];

                        // adding the root to the current suffix and returning the final suffix
                        return '$root$e';
                      }).toList(),
                    ),
                  if (country.independent != null)
                    InfoSection(
                      heading: 'Independent',
                      items: [country.independent == true ? 'Yes' : 'No'],
                    ),
                  if (country.landLocked != null)
                    InfoSection(
                      heading: 'Land locked',
                      items: [country.landLocked == true ? 'Yes' : 'No'],
                    ),
                  if (country.languages != null &&
                      country.languages!.isNotEmpty)
                    InfoSection(
                      heading: 'Language(s)',
                      items: country.languages!.values.toList(),
                    ),
                  if (country.latLng != null)
                    InfoSection(
                      heading: 'Lat Lng',
                      items: ['${country.latLng!.lat}, ${country.latLng!.lng}'],
                    ),
                  if (country.population != null)
                    InfoSection(
                      heading: 'Population',
                      items: [country.population],
                    ),
                  if (country.region != null)
                    InfoSection(
                      heading: 'Region',
                      items: [country.region],
                    ),
                  if (country.subregion != null)
                    InfoSection(
                      heading: 'Sub region',
                      items: [country.subregion],
                    ),
                  if (country.timezones != null &&
                      country.timezones!.isNotEmpty)
                    InfoSection(
                      heading: 'Timezone(s)',
                      items: country.timezones!,
                    ),
                  if (country.tlds != null && country.tlds!.isNotEmpty)
                    InfoSection(
                      heading: 'Top level domain(s)',
                      items: country.tlds!,
                    ),
                  if (country.unMember != null)
                    InfoSection(
                      heading: 'UN member',
                      items: [country.unMember == true ? 'Yes' : 'No'],
                    )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: getFloatingActionButton(context, country.mapsUrl),
    );
  }

  Image getNetworkImage(String url) {
    return Image.network(
      url,
      loadingBuilder: (context, child, loadingProgress) {
        // if there is no loading progress then return the child as loading has been done
        if (loadingProgress == null) {
          return child;
        }

        // getting the current progress and the total bytes
        final int current = loadingProgress.cumulativeBytesLoaded;
        final int? total = loadingProgress.expectedTotalBytes;

        return Center(
          child: Text(
            total == null
                ? 'Loading . . .'
                : '${getPercentage(current, total).toStringAsFixed(2)} %',
            style: TextStyle(
              color: Colors.white.withOpacity(.8),
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
      errorBuilder: ((context, error, stackTrace) {
        // returning a message according to the exception
        return Center(
          child: Text(
            error.runtimeType == SocketException
                ? 'Couldn\'t connect to the Internet.'
                : 'Error while loading the image!',
            style: TextStyle(
              color: Colors.white.withOpacity(.8),
            ),
          ),
        );
      }),
    );
  }

  Column getCountryNames(String officialName, String commonName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            officialName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            commonName,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withOpacity(.8)),
          ),
        )
      ],
    );
  }

  Widget? getFloatingActionButton(BuildContext context, String? mapsUrl) {
    if (mapsUrl == null) {
      return null;
    }

    return Container(
      height: 55,
      width: 55,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: 2,
        ),
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(55),
      ),
      child: IconButton(
        icon: const Icon(Icons.map),
        iconSize: 22,
        color: Theme.of(context).colorScheme.secondary,
        onPressed: () {
          Navigator.of(context)
              .pushNamed(WebView.routeName, arguments: mapsUrl);
        },
      ),
    );
  }
}
