import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../../cubit/cubit.dart';
import 'custom_list_tile.dart';

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
        return CustomListTile(
          onTap: () {},
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
              width: 2.0,
            ),
            inactiveSwitchBorder: Border.all(
              color: const Color(0xFFD1D5DA),
              width: 2.0,
            ),
            activeColor: const Color(0xFF271052),
            inactiveColor: const Color(0xFFE1E1E1),
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
        );
      },
    );
  }
}
