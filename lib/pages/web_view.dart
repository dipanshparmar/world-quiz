import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart' as view;

class WebView extends StatelessWidget {
  const WebView({super.key});

  static const String routeName = '/web-view';

  @override
  Widget build(BuildContext context) {
    // getting the url
    final String mapsUrl = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Maps'),
      ),
      body: view.WebView(
        initialUrl: mapsUrl,
        javascriptMode: view.JavascriptMode.unrestricted,
      ),
    );
  }
}
