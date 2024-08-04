import 'package:flutter/material.dart';
import 'package:meteo_app/utils/app_colors.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final Future<void>?  onSubmitted;
  final List<double>? size;
  const TextFieldWidget({super.key, required this.controller, this.onSubmitted,  this.size});

  @override
  Widget build(BuildContext context) {
    return size != null? SizedBox(
      height: size![0] ,
      width: size![1],
      child: TextField(
        onSubmitted: (value) async {onSubmitted != null ? await onSubmitted : null;},
        controller: controller,
        style: TextStyle(
            color: AppColors.textColorDarkMode, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: "Enter the name of the city",
          hintStyle: TextStyle(color: Colors.grey[800]),
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
      ),
    ): TextField(
      onSubmitted: (value) async {onSubmitted != null ? await onSubmitted : null;},
      controller: controller,
      style: TextStyle(
          color: AppColors.textColorDarkMode, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: "Enter the name of the city",
        hintStyle: TextStyle(color: Colors.grey[800]),
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
