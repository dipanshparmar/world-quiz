import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './pages/pages.dart';
import './providers/providers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // theme of the app
    final ThemeData theme = ThemeData(
      fontFamily: 'Ubuntu',
      primaryColor: const Color(0xFF0B5687),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0B5687),
        titleTextStyle: TextStyle(
          fontFamily: 'Ubuntu',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CountriesProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            secondary: const Color(0xFFF9D162),
          ),
        ),
        home: const HomePage(),
        routes: {
          HomePage.routeName: (context) => const HomePage(),
          CountryPage.routeName: (context) => const CountryPage(),
          WebView.routeName: (context) => const WebView(),
          SearchPage.routeName: (context) => const SearchPage(),
        },
      ),
    );
  }
}
