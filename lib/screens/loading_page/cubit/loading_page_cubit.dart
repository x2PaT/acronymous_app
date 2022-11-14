// ignore_for_file: avoid_print

import 'dart:io';

import 'package:acronymous_app/app/core/enums.dart';
import 'package:acronymous_app/repository/database_repository.dart';
import 'package:acronymous_app/services/database_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'loading_page_state.dart';

class LoadingPageCubit extends Cubit<LoadingPageState> {
  LoadingPageCubit({
    required this.databaseRepository,
  }) : super(LoadingPageState());
  final DatabaseRepository databaseRepository;

  Future<void> start() async {
    emit(state.copyWith(status: Status.loading));

    bool internetConnection = await checkInternetConnection();

    bool isFirstRun = await databaseRepository.isTableEmpty(
      DatabaseHelper.metadataTableName,
    );

    print('isFirstRun $isFirstRun');
    print('internetConnection $internetConnection');

    if (isFirstRun) {
      if (internetConnection) {
        print('Writing data to database');
        await databaseRepository.writeDataToDatabase();

        emit(state.copyWith(
          doneLoading: true,
          status: Status.success,
        ));
      } else {
        print('Please connect to internet');

        await Future.delayed(const Duration(seconds: 2));
        emit(state.copyWith(
          doneLoading: false,
          status: Status.error,
        ));
      }
    } else {
      if (internetConnection) {
        print('Checking integrity with database');

        await databaseRepository.checkDatabaseIntegrity();
        emit(state.copyWith(
          doneLoading: true,
          status: Status.success,
        ));
      } else {
        print('Connect to internet to get latest data');
        await Future.delayed(const Duration(seconds: 2));

        emit(state.copyWith(
          doneLoading: true,
          status: Status.success,
        ));
      }
    }
  }

  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }
}
