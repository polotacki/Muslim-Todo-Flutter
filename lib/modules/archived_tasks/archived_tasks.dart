import 'package:flutter/material.dart';
import 'package:untitled3/shared/styles/extensions.dart';

class ArchivedTasks extends StatelessWidget {
  const ArchivedTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
        children: [
          Row(
            children: [
              Padding(
                padding:
                    EdgeInsets.only(left: 4.0.wp, bottom: 2.0.wp, top: 5.0.wp),
                child: const Icon(
                  Icons.archive_rounded,
                  color: Colors.deepPurple,
                  size: 35,
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(
                      left: 4.0.wp, bottom: 2.0.wp, right: 4.0.wp, top: 4.0.wp),
                  child: Text(
                    'Archive',
                    style: Theme.of(context).textTheme.titleLarge,
                  )),
            ],
          ),
        ],
      )),
    );
  }
}
