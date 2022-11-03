import 'package:acronymous_app/app/injection_container.dart';
import 'package:acronymous_app/screens/loading_page/cubit/loading_page_cubit.dart';
import 'package:acronymous_app/screens/loading_page/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
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
      home: BlocProvider<LoadingPageCubit>(
        create: (context) => getIt<LoadingPageCubit>()..start(),
        child: BlocBuilder<LoadingPageCubit, LoadingPageState>(
          builder: (context, state) {
            return const LoadingPage();
          },
        ),
      ),
    );
  }
}
