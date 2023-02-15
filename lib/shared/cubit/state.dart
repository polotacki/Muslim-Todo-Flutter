part of 'cubit.dart';

@immutable
abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppChangeBottomNavBarState extends AppStates {}

class AppCreateDatabaseState extends AppStates {}

class AppLoadingState extends AppStates {}

class AppGetDatabaseState extends AppStates {}

class AppInsertDatabaseState extends AppStates {}

class AppChangeButtonSheetState extends AppStates {}

class AppUpdateDatabaseState extends AppStates {}

class AppDeleteDatabaseState extends AppStates {}

class AppUpdateCheckedState extends AppStates {}

class AppChangeModeState extends AppStates {}

class AppGetLocationPermission extends AppStates {}

class AppGePrayerTimesSuccessState extends AppStates {}

class AppGePrayerTimesErrorState extends AppStates {
  final String error;

  AppGePrayerTimesErrorState(this.error);
}
