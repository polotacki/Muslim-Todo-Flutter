import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled3/modules/archived_tasks/archived_tasks.dart';
import 'package:untitled3/modules/done_tasks/done_tasks.dart';
import 'package:untitled3/modules/pending_tasks/pending_tasks.dart';

part 'state.dart';

class AppCubit extends Cubit<AppStates> {
  int currentIndex = 0;
  List<Widget> screens = [
    const PendingTasks(),
    const DoneTasks(),
    const ArchivedTasks(),
  ];
  List<Icon> iconAppBar = [
    const Icon(
      Icons.list_alt_rounded,
      color: Colors.deepPurple,
      size: 35,
    ),
    const Icon(
      Icons.data_saver_off_rounded,
      color: Colors.deepPurple,
      size: 35,
    ),
    const Icon(
      Icons.archive_rounded,
      color: Colors.deepPurple,
      size: 35,
    )
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  List<String> titles = ['My List', 'Done Tasks', 'Archive'];

  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
}
