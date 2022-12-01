import 'package:acronymous_app/app/core/colors.dart';
import 'package:acronymous_app/app/injectable.dart';
import 'package:acronymous_app/route_generator.dart';
import 'package:flutter/material.dart';

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
