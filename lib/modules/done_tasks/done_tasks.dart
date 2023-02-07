import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled3/shared/styles/extensions.dart';

import '../../shared/components/components.dart';
import '../../shared/cubit/cubit.dart';

class DoneTasks extends StatelessWidget {
  const DoneTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var tasks = AppCubit.get(context).doneTasks;

          return ListView.separated(
              itemBuilder: (context, index) =>
                  buildTaskItem(context, tasks[index]),
              separatorBuilder: (context, index) => Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey[300],
                  ),
              itemCount: tasks.length);
        });
  }
}
