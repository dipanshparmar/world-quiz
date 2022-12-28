import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import './pages/pages.dart';
import './providers/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // theme of the app
    final ThemeData theme = ThemeData(
      fontFamily: 'Ubuntu',
      primaryColor: const Color(0xFF624422),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF624422),
        titleTextStyle: TextStyle(
          fontFamily: 'Ubuntu',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CountriesProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => QuizProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            secondary: const Color(0xFFFBE0AA),
          ),
        ),
        home: const HomePage(),
        routes: {
          HomePage.routeName: (context) => const HomePage(),
          CountryPage.routeName: (context) => const CountryPage(),
          WebView.routeName: (context) => const WebView(),
          SearchPage.routeName: (context) => const SearchPage(),
          QuizPage.routeName: (context) => const QuizPage(),
          QuestionPage.routeName: (context) => const QuestionPage(),
          ResultPage.routeName: (context) => const ResultPage(),
          HistoryPage.routeName: (context) => const HistoryPage(),
          FiltersPage.routeName: (context) => const FiltersPage(),
        },
      ),
    );
  }
}
