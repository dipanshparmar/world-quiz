import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/widgets.dart';
import '../providers/providers.dart';
import '../utils/enums/enums.dart';

class FiltersPage extends StatelessWidget {
  const FiltersPage({super.key});

  static const String routeName = '/filters-page';

  @override
  Widget build(BuildContext context) {
    // getting the provider
    final CountriesProvider countriesProvider =
        Provider.of<CountriesProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Filters',
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
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
                      items: countriesProvider.getContinents(),
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
                      items: countriesProvider.getSubregions(),
                      filterType: FilterType.subRegion,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Consumer<CountriesProvider>(
            builder: ((context, value, child) {
              // if there are active filters
              if (value.hasActiveFilters()) {
                // returning the container
                return Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Total results: ${value.getFilteredCountries().length}',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        onTap: () {
                          value.clearFilters();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          child: const Icon(
                            Icons.clear,
                            color: Colors.black,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox();
            }),
          )
        ],
      ),
    );
  }
}
