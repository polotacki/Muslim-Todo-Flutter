import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:untitled3/shared/styles/extensions.dart';

import '../cubit/cubit.dart';
import '../styles/colors.dart';

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
      color: Colors.red,
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
      color: Colors.green,
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

Widget buildTaskItem(context, Map model) => Padding(
    padding: EdgeInsets.symmetric(vertical: 5.0.wp, horizontal: 9.0.wp),
    child: Dismissible(
      key: new ObjectKey(model),
      onDismissed: (direction) {},
      background: slideRightBackground(),
      secondaryBackground: slideLeftBackground(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  actionsAlignment: MainAxisAlignment.center,
                  content: Text(
                      "Are you sure you want to delete ${model['title']}?",
                      style: Theme.of(context).textTheme.bodySmall),
                  actions: <Widget>[
                    ElevatedButton(
                      child: Text(
                        "Cancel",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      child: Text("Delete",
                          style: Theme.of(context).textTheme.titleSmall),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        } else {
          // TODO: Navigate to edit page;
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
                      AppCubit.get(context)
                          .updateData(status: 'done', id: model['id']);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 3, color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.done,
                        color: Colors.deepPurple,
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
