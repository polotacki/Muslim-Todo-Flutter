import 'package:flutter/material.dart';
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

Widget buildTaskItem(@required contextpage, Map model) => Padding(
    padding: EdgeInsets.symmetric(vertical: 5.0.wp, horizontal: 9.0.wp),
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
                  onTap: () {},
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
                              style: Theme.of(contextpage).textTheme.bodySmall,
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
                      style: Theme.of(contextpage).textTheme.displaySmall,
                    ),
                    Text(
                      '${model['date']}',
                      style: Theme.of(contextpage).textTheme.displaySmall,
                    ),
                  ],
                )),
          )
        ],
      ),
    ));
