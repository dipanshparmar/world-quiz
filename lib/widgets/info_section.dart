import 'package:flutter/material.dart';
import './widgets.dart';

class InfoSection extends StatelessWidget {
  const InfoSection({
    Key? key,
    required this.heading,
    required this.items,
    this.clickHandlers,
    this.includeSizedbox = true,
  }) : super(key: key);

  final String heading;
  final List items;
  final List<Function>? clickHandlers;
  final bool includeSizedbox;

  @override
  Widget build(BuildContext context) {
    // if clickHandlers are there then check the lengths of both the arrays
    if (clickHandlers != null) {
      if (clickHandlers!.length != items.length) {
        throw Error();
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Heading(heading),
        const SizedBox(
          height: 10,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              children: [
                Row(
                  children: items.asMap().keys.map((key) {
                    final Object e = items[key];

                    return GestureDetector(
                      onTap: () {
                        clickHandlers != null ? clickHandlers![key]() : () {};
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.only(right: 20),
                        child: Text('$e'),
                      ),
                    );
                  }).toList(),
                ),
                if (includeSizedbox)
                  const SizedBox(
                    height: 20,
                  )
              ],
            ),
          ),
        )
      ],
    );
  }
}
