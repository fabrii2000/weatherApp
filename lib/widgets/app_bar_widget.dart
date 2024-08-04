import 'package:flutter/material.dart';
import 'package:meteo_app/utils/app_colors.dart';

import '../utils/global_variable.dart' as global;

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;

  const AppBarWidget({super.key, this.title,  this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: FlexibleSpaceBar(),
      actions: actions,
      backgroundColor: AppColors.backGroundColorHomeBlack,
      title: Padding(
          padding: EdgeInsets.only(left: global.width(context) * 0.21),
          child: Text(title ?? "",
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
