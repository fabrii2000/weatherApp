import 'package:flutter/material.dart';

import '../global_variable.dart' as global;

class AppBarCode extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppBarCode({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 0, 100, 255),
      title: Padding(
          padding: EdgeInsets.only(left: global.width(context) * 0.21),
          child: Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'ARCADE CLASSIC',
                  fontSize: 0.03 * global.height(context)))),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
