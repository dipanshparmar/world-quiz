import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/enums/enums.dart';
import '../providers/providers.dart';

class Option extends StatefulWidget {
  const Option({
    Key? key,
    required this.filterType,
    required this.textValue,
  }) : super(key: key);

  final FilterType filterType;
  final String textValue;

  @override
  State<Option> createState() => _OptionState();
}

class _OptionState extends State<Option> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CountriesProvider>(
      builder: ((context, value, child) {
        // getting the active filters
        final Map activeFilters = value.getActiveFilters();

        // getting the list of the active values according to the type
        List values = activeFilters[widget.filterType];

        // bool to decide whether the current filter is active or not
        final bool isSelected = values.contains(widget.textValue);

        return GestureDetector(
          onTap: () {
            setState(() {
              if (!isSelected) {
                // applying the filter
                value.applyFilter(widget.filterType, widget.textValue);
              } else {
                // removing the filter
                value.removeFilter(widget.filterType, widget.textValue);
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              color:
                  isSelected ? Theme.of(context).colorScheme.secondary : null,
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              widget.textValue,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
              ),
            ),
          ),
        );
      }),
    );
  }
}
