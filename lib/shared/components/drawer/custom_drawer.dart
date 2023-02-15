import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../../cubit/cubit.dart';
import 'custom_list_tile.dart';
import 'header.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _isCollapsed = false;
  bool status = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      status = AppCubit.get(context).isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return SafeArea(
          child: AnimatedContainer(
            curve: Curves.easeInOutCubic,
            duration: const Duration(milliseconds: 500),
            width: _isCollapsed ? 300 : 70,
            margin: const EdgeInsets.only(bottom: 10, top: 10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topLeft: Radius.circular(10),
              ),
              color: Colors.deepPurple,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomDrawerHeader(isColapsed: _isCollapsed),
                  const Divider(
                    color: Colors.grey,
                  ),
                  CustomListTile(
                    iconWidget: const Icon(
                      Icons.home_outlined,
                      color: Colors.white,
                    ),
                    isCollapsed: _isCollapsed,
                    icon: Icons.home_outlined,
                    title: 'Home',
                    infoCount: 0,
                  ),
                  CustomListTile(
                    iconWidget: const Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                    ),
                    isCollapsed: _isCollapsed,
                    icon: Icons.calendar_today,
                    title: 'Calender',
                    infoCount: 0,
                  ),
                  CustomListTile(
                    iconWidget: const Icon(
                      Icons.pin_drop,
                      color: Colors.white,
                    ),
                    isCollapsed: _isCollapsed,
                    icon: Icons.pin_drop,
                    title: 'Destinations',
                    infoCount: 0,
                    doHaveMoreOptions: Icons.arrow_forward_ios,
                  ),
                  CustomListTile(
                    iconWidget: const Icon(
                      Icons.message_rounded,
                      color: Colors.white,
                    ),
                    isCollapsed: _isCollapsed,
                    icon: Icons.message_rounded,
                    title: 'Messages',
                    infoCount: 8,
                  ),
                  CustomListTile(
                    iconWidget: const Icon(
                      Icons.cloud,
                      color: Colors.white,
                    ),
                    isCollapsed: _isCollapsed,
                    icon: Icons.cloud,
                    title: 'Weather',
                    infoCount: 0,
                    doHaveMoreOptions: Icons.arrow_forward_ios,
                  ),
                  CustomListTile(
                    iconWidget: const Icon(
                      Icons.airplane_ticket,
                      color: Colors.white,
                    ),
                    isCollapsed: _isCollapsed,
                    icon: Icons.airplane_ticket,
                    title: 'Flights',
                    infoCount: 0,
                    doHaveMoreOptions: Icons.arrow_forward_ios,
                  ),
                  const Divider(color: Colors.grey),
                  const Spacer(),
                  CustomListTile(
                    iconWidget: const Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                    isCollapsed: _isCollapsed,
                    icon: Icons.notifications,
                    title: 'Notifications',
                    infoCount: 2,
                  ),
                  CustomListTile(
                    iconWidget: const Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                    isCollapsed: _isCollapsed,
                    icon: Icons.settings,
                    title: 'Settings',
                    infoCount: 0,
                  ),
                  const SizedBox(height: 10),
                  CustomListTile(
                    iconWidget: FlutterSwitch(
                      width: 55.0,
                      height: 30.0,
                      toggleSize: 30.0,
                      value: status,
                      borderRadius: 30.0,
                      padding: 2.0,
                      activeToggleColor: const Color(0xFF6E40C9),
                      inactiveToggleColor: Colors.deepPurple,
                      activeSwitchBorder: Border.all(
                        color: const Color(0xFF3C1E70),
                        width: 1.0,
                      ),
                      inactiveSwitchBorder: Border.all(
                        color: const Color(0xFFD1D5DA),
                        width: 1.0,
                      ),
                      activeColor: const Color(0xFF271052),
                      inactiveColor: Colors.white,
                      activeIcon: const Icon(
                        Icons.nightlight_round,
                        color: Color(0xFFF8E3A1),
                      ),
                      inactiveIcon: const Icon(
                        Icons.wb_sunny,
                        color: Color(0xFFFFDF5D),
                      ),
                      onToggle: (val) {
                        setState(() {
                          status = val;
                          AppCubit.get(context).changeAppMode();
                        });
                      },
                    ),
                    isCollapsed: _isCollapsed,
                    icon: Icons.settings,
                    title: 'Settings',
                    infoCount: 0,
                  ),
                  Align(
                    alignment: _isCollapsed
                        ? Alignment.bottomRight
                        : Alignment.bottomCenter,
                    child: IconButton(
                      splashColor: Colors.transparent,
                      icon: Icon(
                        _isCollapsed
                            ? Icons.arrow_back_ios
                            : Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 16,
                      ),
                      onPressed: () {
                        setState(() {
                          _isCollapsed = !_isCollapsed;
                        });
                      },
                    ),
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
