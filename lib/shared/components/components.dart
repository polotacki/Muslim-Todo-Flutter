import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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
      color: Colors.redAccent,
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
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
            height: 60.0,
            width: double.infinity - 1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: AppCubit.get(context).isDark == false
                      ? const Color(0xff535353)
                      : const Color.fromRGBO(27, 31, 35, 1.0),
                  offset: Offset(4, 4),
                  blurRadius: 8,
                  spreadRadius: 0.0,
                ),
              ],
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [
                  0.5,
                  0.5,
                ],
                colors: <Color>[green, Colors.redAccent], // red to yellow
              ),
            )),
        Dismissible(
          dismissThresholds: const {
            DismissDirection.startToEnd: 0.4,
            DismissDirection.endToStart: 0.4
          },
          behavior: HitTestBehavior.translucent,
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
                      actionsOverflowAlignment: OverflowBarAlignment.center,
                      content: Text("${model['title']} Deleted successfully",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelSmall),
                      actions: <Widget>[
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.deepPurple)),
                          child: Text("Okay",
                              style: Theme.of(context).textTheme.bodySmall),
                          onPressed: () {
                            Navigator.of(context).pop();
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.transparent,
                                    elevation: 0.0,
                                    key: Key(model['id'].toString()),
                                    actionsAlignment: MainAxisAlignment.center,
                                    actionsOverflowAlignment:
                                        OverflowBarAlignment.center,
                                    content: Lottie.asset(
                                      'assets/animations/delete-animation.json',
                                      width: 150.w,
                                      height: 150.h,
                                      fit: BoxFit.contain,
                                      repeat: false,
                                    ),
                                    actions: const <Widget>[],
                                  );
                                });
                          },
                        ),
                      ],
                    );
                  });
            } else {
              AppCubit.get(context)
                  .updateData(status: 'archive', id: model['id']);
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                      key: Key(model['id'].toString()),
                      actionsAlignment: MainAxisAlignment.center,
                      actionsOverflowAlignment: OverflowBarAlignment.center,
                      content: Lottie.asset(
                        'assets/animations/success.json',
                        width: 300.w,
                        height: 200.h,
                        fit: BoxFit.cover,
                        repeat: false,
                      ),
                      actions: const <Widget>[],
                    );
                  });
            }
            return null;
          },
          child: Container(
            height: 60.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppCubit.get(context).isDark == false
                  ? Colors.white
                  : Color.fromRGBO(36, 41, 46, 1),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 20)),
                      GestureDetector(
                        onTap: () {
                          AppCubit.get(context)
                              .changeTaskStatus(model, context);
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0.0,
                                  key: Key(model['id'].toString()),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actionsOverflowAlignment:
                                      OverflowBarAlignment.center,
                                  content: Lottie.asset(
                                    'assets/animations/done.json',
                                    width: 300.w,
                                    height: 200.h,
                                    fit: BoxFit.cover,
                                    repeat: false,
                                  ),
                                  actions: const <Widget>[],
                                );
                              });
                        },
                        child: model['status'] == 'done'
                            ? AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.fastLinearToSlowEaseIn,
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple,
                                  border:
                                      Border.all(width: 3, color: Colors.grey),
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
                                  border:
                                      Border.all(width: 3, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                          child: Icon(
                                  Icons.check_box,
                                  color: AppCubit.get(context).isDark == false
                                      ? Colors.white
                                      : Color.fromRGBO(36, 41, 46, 1),
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
                                    style: AppCubit.get(context).isDark == false
                                        ? Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(color: Colors.black)
                                        : Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(color: Colors.white),
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
                      decoration: const BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(8.0),
                              right: Radius.circular(10.0))),
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
                        ].animate(interval: 600.ms).fade(duration: 300.ms),
                      )),
                )
              ].animate().slideX(begin: 1, duration: 300.ms),
            ),
          ),
        ),
      ],
    ));

Widget taskBuilder(List<Map> tasks) => ConditionalBuilder(
      condition: tasks.isNotEmpty,
      builder: (context) => (ListView.separated(
          itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(
                      child: buildTaskItem(context, tasks[index])))),
          separatorBuilder: (context, index) => const Divider(
                color: Colors.transparent,
              ),
          itemCount: tasks.length)),
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
        ].animate(interval: 400.ms).fade(duration: 300.ms),
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
