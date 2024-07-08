import 'package:flutter/material.dart';
import 'package:meteo_app/utils/app_colors.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  const TextFieldWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(
          color: AppColors.textColorDarkMode, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: "Enter the name of the city",
        hintStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: AppColors.textFieldDarkMode,
        border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.textFieldDarkMode),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.textFieldDarkMode),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.textFieldDarkMode),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        prefixIcon: Icon(Icons.search_sharp),
      ),
    );
  }
}
