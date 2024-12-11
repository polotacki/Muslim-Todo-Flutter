import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:muslim_todo_flutter/layout/home_layout.dart';
import 'package:muslim_todo_flutter/shared/components/components.dart';
import 'package:muslim_todo_flutter/shared/styles/colors.dart';

import '../../data/on_boarding.dart';
import '../../models/on_boarding_data.dart';
import '../../shared/cubit/cubit.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  double _currentPageIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          body: SafeArea(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: Column(
                children: [
                  skipButton(context: context),
                  SizedBox(height: 35.h),
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      physics: const BouncingScrollPhysics(),
                      itemCount: 3,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPageIndex = index.toDouble();
                        });
                      },
                      itemBuilder: (context, index) {
                        final OnBoardingData element = onBoardingData[index];
                        return onBoardingElement(
                            subTitle: element.subTitle,
                            title: element.title,
                            lottiePath: element.image);
                      },
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Column(
                    children: [
                      AnimatedSmoothIndicator(
                        duration: const Duration(milliseconds: 500),
                        activeIndex: _currentPageIndex.toInt(),
                        count: 3,
                        effect: WormEffect(
                          dotColor: pink,
                          activeDotColor: Colors.deepPurple,
                          dotWidth: 35.w,
                          dotHeight: 10.h,
                          spacing: 20.w,
                          type: WormType.normal,
                        ),
                        curve: Curves.easeOutCubic,
                      ),
                      SizedBox(height: 15.h),
                      _currentPageIndex + 1 == onBoardingData.length
                          ? Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      cubit.handleLocationPermission();
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeLayout()));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurple,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 20),
                                      textStyle: TextStyle(fontSize: 14.w),
                                    ),
                                    child: const Text(
                                      "Get Started",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(30),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        _controller.jumpToPage(2);
                                      },
                                      style: TextButton.styleFrom(
                                        elevation: 0,
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13.w,
                                        ),
                                      ),
                                      child: const Text(
                                        "SKIP",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        _controller.nextPage(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          curve: Curves.easeIn,
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              width: 2,
                                              color: Colors.deepPurple),
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 20),
                                        textStyle: TextStyle(fontSize: 13.w),
                                      ),
                                      child: const Text("NEXT"),
                                    ),
                                  ]))
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
