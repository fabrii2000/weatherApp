import 'package:flutter/material.dart';
import 'package:meteo_app/utils/AppColors.dart';

import '../utils/global_variable.dart' as global;

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppBarWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backGroundColorHomeBlack,
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
