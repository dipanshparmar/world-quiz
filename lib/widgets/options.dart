import 'package:flutter/material.dart';
import '../utils/enums/enums.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';

class Options extends StatefulWidget {
  const Options({
    required this.items,
    required this.filterType,
    super.key,
  });

  final List items;
  final FilterType filterType;

  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CountriesProvider>(
      builder: ((context, value, child) {
        // getting the active filters
        final Map activeFilters = value.getActiveFilters();

        // getting the list of the active values according to the type
        List values = activeFilters[widget.filterType];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Wrap(
            runSpacing: 10,
            spacing: 10,
            children: widget.items.asMap().keys.map((e) {
              // getting the current text value
              final String textValue = widget.items[e];

              // is selected
              final bool isSelected = values.contains(textValue);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (!isSelected) {
                      // applying the filter
                      value.applyFilter(widget.filterType, textValue);
                    } else {
                      // removing the filter
                      value.removeFilter(widget.filterType, textValue);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 15,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.secondary
                        : null,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    widget.items[e],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }),
    );
  }
}
