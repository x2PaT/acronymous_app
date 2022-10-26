import 'package:acronymous_app/data/remote_data/fetch_api_data.dart';
import 'package:acronymous_app/repository/database_repository.dart';
import 'package:acronymous_app/screens/loading_page/cubit/loading_page_cubit.dart';
import 'package:acronymous_app/screens/loading_page/loading_page.dart';
import 'package:acronymous_app/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens/home_page/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => LoadingPageCubit(
          DatabaseRepository(
            databaseHelper: DatabaseHelper(),
            fetchApiData: FetchApiData(),
          ),
        )..start(),
        child: BlocBuilder<LoadingPageCubit, LoadingPageState>(
          builder: (context, state) {
            return state.doneLoading ? const HomePage() : const LoadingPage();
          },
        ),
      ),
    );
  }
}
