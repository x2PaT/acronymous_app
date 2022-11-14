import 'package:acronymous_app/app/injectable.dart';
import 'package:acronymous_app/screens/ancronym_webview_page/cubit/ancronym_webview_page_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
      body: BlocProvider<AncronymWebviewPageCubit>(
        create: (context) => getIt<AncronymWebviewPageCubit>()..start(),
        child: BlocBuilder<AncronymWebviewPageCubit, AncronymWebviewPageState>(
          builder: (context, state) {
            if (state.internetStatus) {
              return WebView(
                initialUrl: "https://wikipedia.com/wiki/$acronym",
                javascriptMode: JavascriptMode.unrestricted,
              );
            } else {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Column(
                    children: [
                      const Text(
                        'Check your internet conenction',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<AncronymWebviewPageCubit>(context)
                                .start();
                          },
                          child: const Text('Refresh'))
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
