import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled3/shared/components/components.dart';
import 'package:untitled3/shared/cubit/cubit.dart';
import 'package:untitled3/shared/styles/extensions.dart';

import '../shared/components/constants.dart';

class HomeLayout extends StatelessWidget {
  late Database database;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {},
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.currentIndex],
                style: Theme.of(context).textTheme.titleLarge,
              ),
              leading: Padding(
                padding:
                    EdgeInsets.only(left: 4.0.wp, bottom: 2.0.wp, top: 5.0.wp),
                child: cubit.iconAppBar[cubit.currentIndex],
              ),
            ),
            key: scaffoldKey,
            body: ConditionalBuilder(
              condition: true,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              tooltip: 'add tasks',
              child: Icon(fabIcon),
              onPressed: () {
                if (isBottomSheetShown) {
                  if (formKey.currentState?.validate() != true) {
                  } else {
                    insertToDatabase(
                            title: titleController.text,
                            date: dateController.text,
                            time: timeController.text)
                        .then((value) {
                      getDataFromDatabase(database).then(
                        (value) {
                          Navigator.pop(context);
/*                    setState(() {
                      isBottomSheetShown = false;
                      fabIcon = Icons.edit;

                      tasks = value;
                      print("got tasks.. $value");
                    }
                    );*/
                        },
                      );
                    });
                  }
                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet(
                          (context) => Container(
                                color: Colors.white,
                                padding: const EdgeInsets.all(16),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      defaultFormField(
                                        controller: titleController,
                                        type: TextInputType.text,
                                        prefix: Icons.title,
                                        validate: (value) {
                                          if (value.isEmpty) {
                                            return 'title must not be empty';
                                          } else {
                                            return null;
                                          }
                                        },
                                        label: 'Task Title',
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      defaultFormField(
                                          controller: timeController,
                                          type: TextInputType.datetime,
                                          prefix: Icons.watch_later_outlined,
                                          validate: (value) {
                                            if (value.isEmpty) {
                                              return 'time must not be empty';
                                            } else {
                                              return null;
                                            }
                                          },
                                          label: 'Task Time',
                                          onTap: () {
                                            showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now(),
                                            ).then((value) {
                                              if (value != null) {
                                                timeController.text =
                                                    (value.format(context))
                                                        .toString();
                                              } else {
                                                timeController.text = '';
                                              }
                                            });
                                          }),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      defaultFormField(
                                          controller: dateController,
                                          type: TextInputType.datetime,
                                          prefix: Icons.calendar_today,
                                          validate: (value) {
                                            if (value.isEmpty) {
                                              return 'date must not be empty';
                                            } else {
                                              return null;
                                            }
                                          },
                                          label: 'Task Date',
                                          onTap: () {
                                            showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate:
                                                  DateTime.parse('2024-02-28'),
                                            ).then((value) {
                                              if (value != null) {
                                                dateController.text =
                                                    DateFormat.yMMMd()
                                                        .format(value)
                                                        .toString();
                                              } else {
                                                dateController.text = '';
                                              }
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                          elevation: 20.0)
                      .closed
                      .then((value) {
                    isBottomSheetShown = false;
                    /* setState(() {
                fabIcon = Icons.edit;
              });*/
                  });

                  isBottomSheetShown = true;
                  /*setState(() {
              fabIcon = Icons.add;
            });*/
                }
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: false,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.menu),
                    tooltip: 'pending tasks',
                    label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline),
                    label: 'Done',
                    tooltip: 'finished tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined),
                    label: 'Archived',
                    tooltip: 'archived tasks')
              ],
            ),
          );
        },
      ),
    );
  }

  final String tableTodo = 'tasks';
  final String columnId = '_id';
  final String columnTitle = 'title';
  final String columnDate = 'date';
  final String columnTime = 'time';
  final String columnStatus = 'status';

  void createDatabase() async {
    database = await openDatabase('todo.db', version: 1,
        onCreate: (database, version) async {
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
          getDataFromDatabase(database).then((value) {
            tasks = value;
            print("got tasks.. $value");
          });
          print('database opened');
        });
  }

  Future insertToDatabase({@required String? title,
    @required String? time,
    @required String? date}) async {
    return await database.transaction((txn) {
      txn
          .rawInsert(
          'INSERT INTO $tableTodo ($columnTitle,$columnDate,$columnTime,$columnStatus) VALUES ("$title","$date","$time","")')
          .then((value) {
        print('id $value inserted successfully');
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

  Future<List<Map>> getDataFromDatabase(database) async {
    return await database.rawQuery('SELECT * FROM tasks');
  }
}
