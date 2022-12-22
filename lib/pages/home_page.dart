import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';
import './pages.dart';
import '../utils/enums/enums.dart';
import '../utils/constants/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String routeName = '/home-page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // future to hold the load countries future
  late Future _future;

  @override
  void initState() {
    super.initState();

    // setting the future
    _future =
        Provider.of<CountriesProvider>(context, listen: false).loadCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries'),
        elevation: Provider.of<CountriesProvider>(context).hasActiveFilters()
            ? 0
            : null,
        actions: [
          Consumer<CountriesProvider>(
            builder: ((context, value, child) {
              bool isDataLoaded = value.isDataLoaded();

              return IconButton(
                onPressed: isDataLoaded
                    ? () {
                        Navigator.pushNamed(context, SearchPage.routeName);
                      }
                    : null,
                icon: Icon(
                  Icons.search,
                  color: isDataLoaded ? null : kDisabledIconColor,
                ),
              );
            }),
          ),
          Consumer<CountriesProvider>(
            builder: (context, value, child) {
              // getting the data status
              bool isDataLoaded = value.isDataLoaded();

              return AbsorbPointer(
                absorbing:
                    !isDataLoaded, // if data is not loaded then absorb, else not
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      onPressed: isDataLoaded
                          ? () {
                              getModalBottomSheet(context);
                            }
                          : null,
                      icon: Icon(
                        Icons.filter_list,
                        color: isDataLoaded ? null : kDisabledIconColor,
                      ),
                    ),
                    if (value.hasActiveFilters())
                      Positioned(
                        top: 15,
                        right: 10,
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      )
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Getting your data. Please hang on!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          }

          // if we have an error
          if (snapshot.hasError) {
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    snapshot.error is SocketException
                        ? kSocketErrorText
                        : 'An error occurred while fetching the data!',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed(HomePage.routeName);
                    },
                    child: Text(
                      'Retry',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            // if we have the data then access it and list it
            return Consumer<CountriesProvider>(
                builder: (context, value, child) {
              // getting the countries
              final List<Country> countries = !value.hasActiveFilters()
                  ? value.getCountries()
                  : value.getFilteredCountries();

              // if countries is empty then just return the text
              if (countries.isEmpty) {
                return const Center(
                  child: Text('No countries found!'),
                );
              }

              // returning the listview
              return Column(
                children: [
                  // show only if the filters are active
                  if (value.hasActiveFilters())
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10.0),
                      color: Theme.of(context).primaryColor,
                      alignment: Alignment.center,
                      child: Text(
                        'Total results found: ${value.getFilteredCountries().length}',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        // getting the current country
                        final Country country = countries[index];

                        return CountryTile(context, index + 1, country);
                      },
                      itemCount: countries.length,
                    ),
                  ),
                ],
              );
            });
          }
        },
      ),
      floatingActionButton: Consumer<CountriesProvider>(
        builder: ((context, value, child) {
          if (value.isDataLoaded()) {
            return FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).pushNamed(QuizPage.routeName);
              },
              child: const Icon(Icons.quiz),
            );
          }

          return const SizedBox();
        }),
      ),
    );
  }

  Future<dynamic> getModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: Theme.of(context).primaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * .8,
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(children: [
              Container(
                height: 2,
                width: 30,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Heading(
                      'Filter results',
                      paddingLeft: 0,
                    ),
                    Consumer<CountriesProvider>(
                      builder: ((context, value, child) {
                        // has countries
                        bool hasFilters = value.hasActiveFilters();

                        return GestureDetector(
                          onTap: hasFilters
                              ? () {
                                  value.clearFilters();
                                }
                              : () {},
                          child: Text(
                            'Clear All',
                            style: TextStyle(
                              color: hasFilters
                                  ? Theme.of(context).colorScheme.secondary
                                  : Colors.white.withOpacity(.5),
                              fontWeight: hasFilters ? FontWeight.bold : null,
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: Consumer<CountriesProvider>(
                    builder: ((context, value, child) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 20),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Heading('Continents'),
                            const SizedBox(
                              height: 10,
                            ),
                            Options(
                              items: value.getContinents(),
                              filterType: FilterType.continent,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Heading('Sub regions'),
                            const SizedBox(
                              height: 10,
                            ),
                            Options(
                              items: value.getSubregions(),
                              filterType: FilterType.subRegion,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              )
            ]),
          ),
        );
      },
    );
  }

  OutlineInputBorder getInputBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.secondary,
        width: 2,
      ),
    );
  }
}
