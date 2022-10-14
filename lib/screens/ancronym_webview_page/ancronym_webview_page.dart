import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class AncronymWebviewPage extends StatelessWidget {
  const AncronymWebviewPage({Key? key, required this.acronym})
      : super(key: key);

  final String acronym;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Information about $acronym'),
      ),
      body: WebviewScaffold(
        url: "https://wikipedia.com/wiki/$acronym",
        withZoom: true,
        withLocalStorage: true,
      ),
    );
  }
}
