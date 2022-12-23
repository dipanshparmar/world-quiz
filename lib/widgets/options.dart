import 'package:flutter/material.dart';
import '../utils/enums/enums.dart';
import './widgets.dart';

class Options extends StatelessWidget {
  const Options({
    required this.items,
    required this.filterType,
    super.key,
  });

  final List items;
  final FilterType filterType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        runSpacing: 10,
        spacing: 10,
        children: items.asMap().keys.map((e) {
          // getting the current text value
          final String textValue = items[e];

          return Option(
            filterType: filterType,
            textValue: textValue,
          );
        }).toList(),
      ),
    );
  }
}
