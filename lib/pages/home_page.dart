import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';
import './pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchPage.routeName);
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list),
          )
        ],
      ),
      body: FutureBuilder(
        future: _future,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          }

          // if we have an error
          if (snapshot.hasError) {
            print(snapshot.error);
            // TODO
            return Text('An error occurred');
          } else {
            // if we have the data then access it and list it
            return Consumer<CountriesProvider>(
                builder: (context, value, child) {
              // getting the countries
              final List<Country> countries = value.getCountries();

              // returning the listview
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  // getting the current country
                  final Country country = countries[index];

                  return CountryTile(index + 1, country);
                },
                itemCount: countries.length,
              );
            });
          }
        }),
      ),
    );
  }
}
