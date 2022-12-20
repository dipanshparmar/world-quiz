import 'package:flutter/material.dart';
import '../models/country.dart';
import '../pages/pages.dart';

class CountryTile extends StatelessWidget {
  const CountryTile(this._idx, this._country, {super.key});

  // var to hold the country
  final int _idx;
  final Country _country;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text('$_idx'),
      title: Text(_country.commonName),
      trailing: Text(_country.flag ?? ''),
      onTap: () {
        Navigator.pushNamed(
          context,
          CountryPage.routeName,
          arguments: _country,
        );
      },
    );
  }
}
