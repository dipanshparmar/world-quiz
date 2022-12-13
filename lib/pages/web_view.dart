import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart' as view;

class WebView extends StatefulWidget {
  const WebView({super.key});

  static const String routeName = '/web-view';

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  bool isFinished = false;

  @override
  Widget build(BuildContext context) {
    // getting the url
    final String mapsUrl = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Maps'),
      ),
      body: Stack(
        children: [
          view.WebView(
            initialUrl: mapsUrl,
            javascriptMode: view.JavascriptMode.unrestricted,
            onPageFinished: ((url) {
              setState(() {
                isFinished = true;
              });
            }),
          ),
          !isFinished
              ? Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : const Text('')
        ],
      ),
    );
  }
}
