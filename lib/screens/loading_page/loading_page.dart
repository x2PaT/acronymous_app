import 'package:acronymous_app/app/core/enums.dart';
import 'package:acronymous_app/screens/home_page/home_page.dart';
import 'package:acronymous_app/screens/loading_page/cubit/loading_page_cubit.dart';
import 'package:acronymous_app/screens/boarding_page/boarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadingPageCubit, LoadingPageState>(
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
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 25),
                    Text(
                      'Getting the app ready... please wait...',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          case Status.success:
            return state.isFirstRun ? const BoardingPage() : const HomePage();
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
    );
  }
}
