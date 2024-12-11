import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:muslim_todo_flutter/shared/components/components.dart';
import 'package:muslim_todo_flutter/shared/cubit/cubit.dart';
import 'package:muslim_todo_flutter/shared/styles/extensions.dart';

import '../shared/components/drawer/custom_drawer.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {
        if (state is AppInsertDatabaseState) {
          Navigator.pop(context);
        }
      },
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              cubit.titles[cubit.currentIndex],
              style: Theme.of(context).textTheme.titleLarge,
            ).animate().fadeIn(duration: 300.ms),
            leading: Padding(
              padding:
                  EdgeInsets.only(left: 20,right: 20, bottom: 2.0.w, top: 2.0.w),
              child: cubit.iconAppBar[cubit.currentIndex],
            ).animate().fadeIn(duration: 300.ms),
            actions: const [CustomDrawer()],
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
            child: Icon(cubit.fabIcon),
            onPressed: () {
              if (cubit.isBottomSheetShown) {
                if (formKey.currentState?.validate() != true) {
                } else {
                  Fluttertoast.showToast(
                      msg: "Task Added !",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: AppCubit.get(context).isDark == false
                          ? Color(0xff535353)
                          : Colors.white,
                      textColor: AppCubit.get(context).isDark == false
                          ? Colors.white
                          : Color.fromRGBO(27, 31, 35, 1.0),
                      fontSize: 16.0);
                  cubit.insertToDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text);
                }
              } else {
                titleController.text = '';
                timeController.text = '';
                dateController.text = '';
                scaffoldKey.currentState
                    ?.showBottomSheet(
                        (context) => Container(
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
                                              lastDate: DateTime(2024),
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
                                    ]
                                        .animate(
                                            delay: 300.ms, interval: 200.ms)
                                        .fadeIn(duration: 300.ms)),
                              ).animate().slideY(begin: 1, duration: 300.ms),
                            ),
                        elevation: 1.0)
                    .closed
                    .then((value) {
                  cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
                });

                cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
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
                  label: 'All Tasks'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.today_outlined),
                  label: 'Today\'s Tasks ',
                  tooltip: 'archived tasks'),
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
        ).animate().fadeIn(duration: 300.ms);
      },
    );
  }
}
