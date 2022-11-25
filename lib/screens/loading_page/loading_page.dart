import 'package:acronymous_app/app/core/enums.dart';
import 'package:acronymous_app/app/injectable.dart';
import 'package:acronymous_app/screens/home_page/home_page.dart';
import 'package:acronymous_app/screens/loading_page/cubit/loading_page_cubit.dart';
// import 'package:acronymous_app/screens/boarding_page/boarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoadingPageCubit>(
      create: (context) => getIt<LoadingPageCubit>()..start(),
      child: BlocBuilder<LoadingPageCubit, LoadingPageState>(
        builder: (context, state) {
          switch (state.status) {
            case Status.initial:
              return const Center(
                child: Text('Initial State'),
              );
            case Status.loading:
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: const AssetImage('assets/acronymous-name.png'),
                        color: const Color(0xFF77B277),
                        width: MediaQuery.of(context).size.width * 0.75,
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        'Getting the app ready... please wait...',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 25),
                      const CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
            case Status.success:
              return const HomePage();

            // state.isFirstRun ? const BoardingPage() : const HomePage();
            case Status.error:
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Check your internet connection'),
                      ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<LoadingPageCubit>(context).start();
                        },
                        child: const Text('Refresh'),
                      )
                    ],
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}
