import 'package:acronymous_app/app/core/colors.dart';
import 'package:acronymous_app/app/injectable.dart';
import 'package:acronymous_app/route_generator.dart';
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
      title: 'Acronymous',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.mainAppColor,
        ),
      ),
      initialRoute: '/loading',
      onGenerateRoute: RouteGeneretor.generateRoute,
    );
  }
}
