import 'package:flutter/material.dart';
import 'package:meteo_app/utils/AppColors.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  TextFieldWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: "Search",
        hintStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: AppColors.backgroundTextField,
        border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.backgroundTextField),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.backgroundTextField),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.backgroundTextField),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        prefixIcon: Icon(Icons.search_sharp),
      ),
    );
  }
}
