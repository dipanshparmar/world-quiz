import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/country.dart';
import '../widgets/widgets.dart';
import './pages.dart';
import '../utils/functions/functions.dart';
import '../utils/constants/constants.dart';
import '../providers/providers.dart';

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
        title: Text(country.commonName),
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
                height: 150,
                width: double.infinity,
                child: getNetworkImage(country.flagUrl!),
              ),
            const SizedBox(
              height: 40,
            ),
            getCountryNames(
              country.officialName,
              country.commonName,
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
                      leading: const Icon(
                        Icons.grass,
                        color: Colors.white,
                        size: 16,
                      ),
                      heading: 'Area',
                      items: ['${country.area} Km\u00B2'],
                    ),
                  if (country.borders != null && country.borders!.isNotEmpty)
                    Consumer<CountriesProvider>(
                      builder: ((context, value, child) {
                        return InfoSection(
                          leading: const Icon(
                            Icons.border_style,
                            color: Colors.white,
                            size: 16,
                          ),
                          heading: 'Border(s)',
                          items: country.borders!.map((code) {
                            // getting the country by code
                            final Country country =
                                value.getCountryByCode(code);

                            return country.commonName;
                          }).toList(),
                          clickHandlers: country.borders!.map((code) {
                            // getting the country by the code
                            final Country country =
                                value.getCountryByCode(code);

                            return () {
                              Navigator.of(context).pushNamed(
                                CountryPage.routeName,
                                arguments: country,
                              );
                            };
                          }).toList(),
                        );
                      }),
                    ),
                  if (country.capitals != null && country.capitals!.isNotEmpty)
                    InfoSection(
                      leading: const Icon(
                        Icons.business,
                        color: Colors.white,
                        size: 16,
                      ),
                      heading: 'Capital(s)',
                      items: country.capitals!,
                    ),
                  if (country.continents != null &&
                      country.continents!.isNotEmpty)
                    InfoSection(
                      leading: const Icon(
                        Icons.public,
                        color: Colors.white,
                        size: 16,
                      ),
                      heading: 'Continent(s)',
                      items: country.continents!,
                    ),
                  if (country.currencies != null &&
                      country.currencies!.isNotEmpty)
                    InfoSection(
                      leading: const Icon(
                        Icons.attach_money,
                        color: Colors.white,
                        size: 16,
                      ),
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
                  if (country.languages != null &&
                      country.languages!.isNotEmpty)
                    InfoSection(
                      leading: const Icon(
                        Icons.language,
                        color: Colors.white,
                        size: 16,
                      ),
                      heading: 'Language(s)',
                      items: country.languages!.values.toList(),
                    ),
                  if (country.population != null)
                    InfoSection(
                      leading: const Icon(
                        Icons.people,
                        color: Colors.white,
                        size: 16,
                      ),
                      heading: 'Population',
                      items: [country.population],
                    ),
                  if (country.region != null)
                    InfoSection(
                      leading: const Icon(
                        Icons.area_chart,
                        color: Colors.white,
                        size: 16,
                      ),
                      heading: 'Region',
                      items: [country.region],
                    ),
                  if (country.subregion != null)
                    InfoSection(
                      leading: const Icon(
                        Icons.landscape,
                        color: Colors.white,
                        size: 16,
                      ),
                      heading: 'Sub region',
                      items: [country.subregion],
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
                  if (country.car != null &&
                      country.car!.isNotEmpty &&
                      country.car!.containsKey('side'))
                    InfoSection(
                      leading: const Icon(
                        Icons.time_to_leave,
                        color: Colors.white,
                        size: 16,
                      ),
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
                      leading: const Icon(
                        Icons.tag,
                        color: Colors.white,
                        size: 16,
                      ),
                      heading: 'Car signs',
                      items: (country.car!['signs'] as List).map((e) {
                        return e;
                      }).toList(),
                    ),
                  if (country.demonyms != null &&
                      country.demonyms!.isNotEmpty &&
                      country.demonyms!.containsKey('eng') &&
                      ((country.demonyms!['eng'] as Map).containsKey('f') ||
                          (country.demonyms!['eng'] as Map).containsKey('m')))
                    InfoSection(
                      leading: const Icon(
                        Icons.emoji_people,
                        color: Colors.white,
                        size: 16,
                      ),
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
                      leading: const Icon(
                        Icons.sports_soccer,
                        color: Colors.white,
                        size: 16,
                      ),
                      heading: 'Fifa',
                      items: [country.fifa],
                    ),
                  if (country.gini != null && country.gini!.isNotEmpty)
                    InfoSection(
                      leading: const Icon(
                        Icons.price_change,
                        color: Colors.white,
                        size: 16,
                      ),
                      heading: 'Gini',
                      items: country.gini!.keys.map((e) {
                        return '${country.gini![e]} ($e)';
                      }).toList(),
                    ),
                  if (country.idd != null && country.idd!.isNotEmpty)
                    InfoSection(
                      leading: const Icon(
                        Icons.phone,
                        color: Colors.white,
                        size: 16,
                      ),
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
                      leading: const Icon(
                        Icons.flag,
                        color: Colors.white,
                        size: 16,
                      ),
                      heading: 'Independent',
                      items: [country.independent == true ? 'Yes' : 'No'],
                    ),
                  if (country.landLocked != null)
                    InfoSection(
                      leading: const Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: 16,
                      ),
                      heading: 'Land locked',
                      items: [country.landLocked == true ? 'Yes' : 'No'],
                    ),
                  if (country.latLng != null)
                    InfoSection(
                      leading: const Icon(
                        Icons.place,
                        color: Colors.white,
                        size: 16,
                      ),
                      heading: 'Lat Lng',
                      items: ['${country.latLng!.lat}, ${country.latLng!.lng}'],
                    ),
                  if (country.timezones != null &&
                      country.timezones!.isNotEmpty)
                    InfoSection(
                      leading: const Icon(
                        Icons.schedule,
                        color: Colors.white,
                        size: 16,
                      ),
                      heading: 'Timezone(s)',
                      items: country.timezones!,
                    ),
                  if (country.tlds != null && country.tlds!.isNotEmpty)
                    InfoSection(
                      leading: const Icon(
                        Icons.web,
                        color: Colors.white,
                        size: 16,
                      ),
                      heading: 'Top level domain(s)',
                      items: country.tlds!,
                    ),
                  if (country.unMember != null)
                    InfoSection(
                      leading: const Icon(
                        Icons.groups,
                        color: Colors.white,
                        size: 16,
                      ),
                      heading: 'UN member',
                      items: [country.unMember == true ? 'Yes' : 'No'],
                    )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: country.mapsUrl != null
          ? getFloatingActionButton(context, country.mapsUrl)
          : null,
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
            error is SocketException
                ? kImageSocketErrorText
                : 'Error while loading the image!',
            textAlign: TextAlign.center,
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
