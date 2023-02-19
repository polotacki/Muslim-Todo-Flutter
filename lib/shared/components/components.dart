import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:untitled3/shared/styles/colors.dart';
import 'package:untitled3/shared/styles/extensions.dart';

import '../../layout/home_layout.dart';
import '../cubit/cubit.dart';

Widget defaultFormField(
        {required TextEditingController controller,
        required TextInputType type,
        required IconData prefix,
        required validate,
        required String label,
        bool isClickable = true,
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
                      style: Theme.of(context).textTheme.displaySmall),
                  actions: <Widget>[
                    const SizedBox(width: 20),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.deepPurple)),
                      child: Text("Okay",
                          style: Theme.of(context).textTheme.bodySmall),
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
        return null;
      },
      child: Container(
        height: 60.0,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: const [
              BoxShadow(
                color: Color(0xff535353),
                offset: Offset(4, 4),
                blurRadius: 8,
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
                      AppCubit.get(context).changeTaskStatus(model, context);
                    },
                    child: model['status'] == 'done'
                        ? AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
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
                      duration: const Duration(milliseconds: 500),
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
                                style: Theme.of(context).textTheme.displaySmall,
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
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '${model['date']}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    ));

Widget taskBuilder(List<Map> tasks) => ConditionalBuilder(
      condition: tasks.isNotEmpty,
      builder: (context) => ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(context, tasks[index]),
          separatorBuilder: (context, index) => Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
          itemCount: tasks.length),
      fallback: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(flex: 1, child: Image.asset('assets/images/Task.png')),
          Expanded(
            flex: 1,
            child: Text('List is empty .. , Add some tasks.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),

    );

Widget onBoardingElement(
    {required lottiePath, required title, required subTitle}) {
  return SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: Column(
      children: [
        Lottie.asset(
          lottiePath,
          width: 300.w,
          height: 300.h,
        ),
        SizedBox(height: 35.h),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 15.h),
        Text(
          subTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
            color: Colors.black.withOpacity(0.8),
          ),
        ),
      ],
    ),
  );
}

Widget skipButton({required context}) {
  return Align(
    alignment: AlignmentDirectional.topEnd,
    child: GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeLayout()));
      },
      child: Container(
        width: 80.w,
        height: 40.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40), color: Colors.deepPurple),
        child: Center(
          child: Text(
            "Skip",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ),
  );
}