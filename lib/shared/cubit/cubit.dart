import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled3/modules/archived_tasks/archived_tasks.dart';
import 'package:untitled3/modules/done_tasks/done_tasks.dart';
import 'package:untitled3/modules/pending_tasks/pending_tasks.dart';
import 'package:untitled3/modules/today_tasks/today_pending_tasks.dart';
import 'package:untitled3/shared/network/local/cache_helper.dart';

import '../network/remote/dio_helper.dart';

part 'state.dart';

class AppCubit extends Cubit<AppStates> {
  int currentIndex = 0;
  List<Widget> screens = [
    const PendingTasks(),
    const TodayTasks(),
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
      Icons.watch_later_outlined,
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
  List<Map> todayTasks = [];
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  List<String> titles = ['My List', 'Today`s Tasks', 'Done Tasks', 'Archive'];
  late Database database;
  final String tableTodo = 'tasks';
  final String columnId = 'id';
  final String columnTitle = 'title';
  final String columnDate = 'date';
  final String columnTime = 'time';
  final String columnStatus = 'status';

  void createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) async {
      print('database created');

      await database.execute('''
create table $tableTodo ( 
  $columnId integer primary key autoincrement, 
  $columnTitle text not null,
   $columnDate text not null,
    $columnTime text not null,
  $columnStatus text not null)
''');
      print('table created');
    }, onOpen: (database) {
      getDataFromDatabase(database);
      print('database opened');
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  Future<bool?> confirmDeletion(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure you want to delete?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Yes'),
            )
          ],
        );
      },
    );
  }

  updateIconColor({
    @required String? id,
  }) async {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    Color iconColor = Colors.deepPurple;
    database.rawQuery('SELECT status FROM tasks WHERE id = ?', ['$id']).then(
        (value) {
      if (value == 'new') {
        iconColor = Colors.white;
      } else {
        iconColor = Colors.white;
      }

      print(value);
    });
  }

  void updateData({
    @required String? status,
    @required int? id,
  }) async {
    database.rawUpdate('UPDATE $tableTodo SET status = ? WHERE id = ?',
        ['$status', '$id']).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  bool isDark = true;
  ThemeMode appMode = ThemeMode.dark;

  void changeAppMode({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(AppChangeModeState());
    } else {
      isDark = !isDark;
      CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value) {
        emit(AppChangeModeState());
      });
    }
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    emit(AppGetLocationPermission());

    return await Geolocator.getCurrentPosition();
  }

  void deleteData({
    @required int? id,
  }) async {
    database.rawDelete('DELETE FROM Tasks WHERE id = ?', ['$id']).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  insertToDatabase(
      {@required String? title,
      @required String? time,
      @required String? date}) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO $tableTodo ($columnTitle,$columnDate,$columnTime,$columnStatus) VALUES ("$title","$date","$time","new")')
          .then((value) {
        print('id $value inserted successfully');
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((onError) {
        print(onError.toString());
      });
      todoInsert() async {
        var x = print("inserting data ..");
        return x;
      }

      return todoInsert();
    });
  }

  insertPrayToDatabase(
      {@required String? title,
      @required String? time,
      @required String? date}) async {
    await database.transaction((txn) {
      txn.rawInsert(
          ''' replace into $tableTodo ($columnId, $columnTitle, $columnDate, $columnTime, $columnStatus)
               values ((CASE WHEN (select  $columnId from $tableTodo where $columnTitle = "$title")=null 
               THEN ((SELECT MAX($columnId) FROM $tableTodo) + 1) ELSE (select  $columnId from $tableTodo where 
               $columnTitle = "$title") END ), "$title", "$date", "$time", "new")''').then((value) {
        print('id $value inserted successfully');
        emit(AppInsertPrayDataState());
      }).catchError((onError) {
        print(onError.toString());
      });
      todoInsert() async {
        var x = print("inserting data ..");
        return x;
      }

      return todoInsert();
    });
  }

  Map<String, dynamic> prayer = {};

  void getPrayer() {
    emit(AppLoadingState());
    // http://api.aladhan.com/v1/timingsByCity?city=Cairo&country=Egypt&method=4
    DioHelper.getData(
            url: 'v1/timingsByCity?',
            query: {'city': 'Cairo', 'country': 'Egypt', 'method': '4'})
        .then((value) {
      prayer = value.data['data']['timings'];
      print(prayer);
      String prayDate = DateFormat.yMMMd().format(DateTime.now()).toString();
      insertPrayToDatabase(title: 'Fajr', time: prayer['Fajr'], date: prayDate);
      insertPrayToDatabase(
          title: 'Dhuhr', time: prayer['Dhuhr'], date: prayDate);
      insertPrayToDatabase(title: 'Asr', time: prayer['Asr'], date: prayDate);
      insertPrayToDatabase(
          title: 'Maghrib', time: prayer['Maghrib'], date: prayDate);
      insertPrayToDatabase(title: 'Isha', time: prayer['Isha'], date: prayDate);
      getDataFromDatabase(database);
      emit(AppGePrayerTimesSuccessState());
    }).catchError((onError) {
      print(onError.toString());
      emit(AppGePrayerTimesErrorState(onError.toString()));
    });
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    todayTasks = [];
    doneTasks = [];
    archivedTasks = [];
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new' || element['status'] == 'done') {
          newTasks.add(element);
          if (element['status'] == 'new' &&
              element['date'] ==
                  DateFormat.yMMMd().format(DateTime.now()).toString()) {
            todayTasks.add(element);
          }
          if (element['status'] == 'done') {
            doneTasks.add(element);
          }
        } else {
          archivedTasks.add(element);
        }

        print(element['status']);
      });
      emit(AppGetDatabaseState());
    });
  }

  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeButtonSheetState());
  }

  void changeTaskStatus(model, context) {
    if (model['status'] == 'new') {
      AppCubit.get(context).updateData(status: 'done', id: model['id']);
    } else if (model['status'] == 'done') {
      AppCubit.get(context).updateData(status: 'new', id: model['id']);
    } else {
      AppCubit.get(context).updateData(status: 'new', id: model['id']);
    }
    emit(AppUpdateCheckedState());
  }
}
