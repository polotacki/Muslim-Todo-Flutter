import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/shared/styles/colors.dart';
import 'package:untitled3/shared/styles/extensions.dart';

import '../cubit/cubit.dart';

Widget defaultFormField(
        {required TextEditingController controller,
        required TextInputType type,
        required IconData prefix,
        required validate,
        required String label,
        bool isclickable = true,
        onTap,
        onSubmit,
        onChange}) =>
    TextFormField(
      keyboardType: type,
      controller: controller,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            prefix,
            color: Colors.deepPurple,
          ),
          border: const OutlineInputBorder()),
    );

Widget slideLeftBackground() {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      color: pink,
    ),
    child: Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const <Widget>[
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          Text(
            " Delete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    ),
  );
}

Widget slideRightBackground() {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      color: green,
    ),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const <Widget>[
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.archive_rounded,
            color: Colors.white,
          ),
          Text(
            " Archive",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    ),
  );
}

bool isChecked = false;

Widget buildTaskItem(context, Map model) => Padding(
    padding: EdgeInsets.symmetric(vertical: 5.0.wp, horizontal: 9.0.wp),
    child: Dismissible(
      key: Key(model['id'].toString()),
      onDismissed: (direction) {},
      background: slideRightBackground(),
      secondaryBackground: slideLeftBackground(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          AppCubit.get(context).deleteData(id: model['id']);

          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  key: Key(model['id'].toString()),
                  actionsAlignment: MainAxisAlignment.center,
                  content: Text("${model['title']} Deleted successfully",
                      style: Theme.of(context).textTheme.bodySmall),
                  actions: <Widget>[
                    SizedBox(width: 20),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.deepPurple)),
                      child: Text("Okay",
                          style: Theme.of(context).textTheme.displaySmall),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        } else {
          AppCubit.get(context).updateData(status: 'archive', id: model['id']);
        }
      },
      child: Container(
        height: 60.0,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: const [
              BoxShadow(
                color: Color(0xffefefef),
                offset: Offset(-20, -10),
                blurRadius: 20,
                spreadRadius: 0.0,
              ),
              BoxShadow(
                color: Color(0xff8d8d8d),
                offset: Offset(20, 10),
                blurRadius: 40,
                spreadRadius: 0.0,
              ),
            ]),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  const Padding(padding: EdgeInsets.only(left: 20)),
                  GestureDetector(
                    onTap: () {
                      if (model['status'] == 'new') {
                        isChecked = false;
                        AppCubit.get(context)
                            .updateData(status: 'done', id: model['id']);
                      } else if (model['status'] == 'done') {
                        isChecked = true;

                        AppCubit.get(context)
                            .updateData(status: 'new', id: model['id']);
                      } else {
                        isChecked = false;

                        AppCubit.get(context)
                            .updateData(status: 'new', id: model['id']);
                      }
                    },
                    child: isChecked
                        ? AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.fastLinearToSlowEaseIn,
                            decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              border: Border.all(width: 3, color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.done,
                              color: Colors.white,
                              size: 24,
                            ))
                        : AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.fastLinearToSlowEaseIn,
                            decoration: BoxDecoration(
                              border: Border.all(width: 3, color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.check_box,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 4.0.wp),
                    child: SizedBox(
                      width: 80,
                      child: Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              child: Text(
                                '${model['title']}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${model['time']}',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      Text(
                        '${model['date']}',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    ));

Widget taskBuilder(@required List<Map> tasks) => ConditionalBuilder(
      condition: tasks.length > 0,
      builder: (context) => ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(context, tasks[index]),
          separatorBuilder: (context, index) => Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
          itemCount: tasks.length),
      fallback: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/Task.png'),
          Text('List is empty .. , Add some tasks.',
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
