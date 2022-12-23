import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';
import './pages.dart';
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
                              Navigator.of(context)
                                  .pushNamed(FiltersPage.routeName);
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
                ),
              ],
            );
          }

          // if we have an error
          if (snapshot.hasError) {
            return _buildErrorContainer(snapshot, context);
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
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  // getting the current country
                  final Country country = countries[index];

                  return CountryTile(context, index + 1, country);
                },
                itemCount: countries.length,
              );
            });
          }
        },
      ),
      floatingActionButton: _getFloatingActionButton(),
    );
  }

  Consumer<CountriesProvider> _getFloatingActionButton() {
    return Consumer<CountriesProvider>(
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
    );
  }

  Container _buildErrorContainer(
      AsyncSnapshot<dynamic> snapshot, BuildContext context) {
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
          InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(HomePage.routeName);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                'Retry',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
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
