import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/country.dart';
import '../pages/pages.dart';
import '../providers/providers.dart';
import '../utils/enums/enums.dart';

class CountryTile extends StatelessWidget {
  const CountryTile(
    this.context,
    this._idx,
    this._country, {
    super.key,
  });

  // var to hold the country
  final BuildContext context;
  final int _idx;
  final Country _country;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text('$_idx'),
      title: Text(_country.commonName),
      trailing: Text(_country.flag ?? ''),
      subtitle: _buildSubtitle(),
      onTap: () {
        Navigator.pushNamed(
          context,
          CountryPage.routeName,
          arguments: _country,
        );
      },
    );
  }

  // method to build the subtitle
  Widget? _buildSubtitle() {
    // getting the countries provider
    final CountriesProvider countriesProvider =
        Provider.of<CountriesProvider>(context, listen: false);

    // bool whether there are active filters or not
    final bool hasActiveFilters = countriesProvider.hasActiveFilters();

    // getting the active filters
    final Map activeFilters = countriesProvider.getActiveFilters();

    // extracting the individual filters
    final List continentsFilter = activeFilters[FilterType.continent];
    final List subregionsFilter = activeFilters[FilterType.subRegion];

    // getting the current countries continents and subregion
    final List? currentCountryContinents = _country.continents;
    final String? currentCountrySubregion = _country.subregion;

    // if has active filters
    if (hasActiveFilters) {
      // if any of them is not null
      if (currentCountryContinents != null || currentCountrySubregion != null) {
        // returning the row
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              // if current country has continents
              if (currentCountryContinents != null &&
                  currentCountryContinents.isNotEmpty)
                _buildContinents(
                  continentsFilter,
                  currentCountryContinents,
                ),

              if ((currentCountryContinents != null &&
                      currentCountryContinents.isNotEmpty &&
                      getActiveContinents(
                              continentsFilter, currentCountryContinents)
                          .isNotEmpty) &&
                  currentCountrySubregion != null &&
                  subregionsFilter.contains(currentCountrySubregion))
                const SizedBox(
                  width: 10,
                ),

              // if the sub region is not null and is present in the filter
              if (currentCountrySubregion != null &&
                  subregionsFilter.contains(currentCountrySubregion))
                _buildCustomChip(
                  currentCountrySubregion,
                  color: Theme.of(context).primaryColor,
                ),
            ],
          ),
        );
      }

      return null;
    }

    return null;
  }

  Container _buildCustomChip(
    String currentCountrySubregion, {
    Color color = Colors.black,
    Color textColor = Colors.white,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 5,
      ),
      child: Text(
        currentCountrySubregion,
        style: TextStyle(
          fontSize: 12,
          color: textColor,
        ),
      ),
    );
  }

  // function to build the continents
  Widget _buildContinents(List continentsFilter, List currentCountryFilters) {
    // getting the active continents
    final List activeContinents =
        getActiveContinents(continentsFilter, currentCountryFilters);

    return Row(
      children: activeContinents.asMap().entries.map((e) {
        return Padding(
          padding: EdgeInsets.only(
              right: e.key == activeContinents.length - 1 ? 0 : 10.0),
          child: _buildCustomChip(
            e.value,
            textColor: Colors.black,
            color: Theme.of(context).colorScheme.secondary,
          ),
        );
      }).toList(),
    );
  }

  // function to get the active continents
  List getActiveContinents(List continentsFilter, List currentCountryFilters) {
    return currentCountryFilters
        .where((continent) => continentsFilter.contains(continent))
        .toList();
  }
}
