import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/enums/enums.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  static const String routeName = '/search-page';

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // search tabs
  final List searchTabs = ['Country', 'Currency', 'Capital', 'Language'];

  // search types
  final List<SearchType> searchTypes = [
    SearchType.country,
    SearchType.currency,
    SearchType.capital,
    SearchType.language
  ];

  // active index
  int activeIndex = 0;

  // controller for the input box
  final TextEditingController textEditingController = TextEditingController();

  // variable to hold the search value
  String searchValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: textEditingController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search . . .',
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(.8),
            ),
          ),
          style: const TextStyle(
            color: Colors.white,
          ),
          autofocus: true,
          cursorColor: Colors.white,
          onChanged: (value) {
            setState(() {
              searchValue = value;

              Provider.of<CountriesProvider>(context, listen: false).filterBy(
                searchTypes[activeIndex],
                searchValue,
              );
            });
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              textEditingController.clear();

              setState(() {
                searchValue = "";
              });

              Provider.of<CountriesProvider>(context, listen: false).filterBy(
                searchTypes[activeIndex],
                searchValue,
              );
            },
            icon: const Icon(Icons.clear),
            iconSize: 20,
          )
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: searchTabs.asMap().keys.map((idx) {
                  final bool isActive = idx == activeIndex;

                  return Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          activeIndex = idx;

                          Provider.of<CountriesProvider>(context, listen: false)
                              .filterBy(
                            searchTypes[idx],
                            searchValue,
                          );
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              isActive ? Theme.of(context).primaryColor : null,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 15,
                        ),
                        child: Text(
                          searchTabs[idx],
                          style: TextStyle(
                            color: isActive ? Colors.white : null,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: searchValue.isEmpty
                ? const Center(
                    child: Text('Please search something!'),
                  )
                : Consumer<CountriesProvider>(
                    builder: ((context, value, child) {
                      final List<Country> searchResults =
                          value.getSearchResults();

                      // if search results are empty then show an empty message instead
                      if (searchResults.isEmpty) {
                        return const Center(
                          child: Text('No results found for your search!'),
                        );
                      }

                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: searchResults.length,
                        itemBuilder: ((context, index) {
                          return CountryTile(index + 1, searchResults[index]);
                        }),
                      );
                    }),
                  ),
          )
        ],
      ),
    );
  }
}
