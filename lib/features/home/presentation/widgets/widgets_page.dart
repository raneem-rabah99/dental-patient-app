import 'package:dentaltreatment/core/theme/app_color.dart';
import 'package:flutter/material.dart';

Widget buildTextFieldEdit(
  TextEditingController controller,
  String hintText,
  IconData icon, {
  bool isPassword = false,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 4.0),
    child: TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(
          icon,
          color: AppColor.gray,
        ), // Optional: Adjust the icon color
        // Custom border similar to the one in `buildCityDropdown` and `buildTitleAndTextField`
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColor.gray,
            width: 2,
          ), // Gray border color and 2px width
          borderRadius: BorderRadius.circular(
            8,
          ), // Rounded corners, same as before
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColor.gray,
            width: 2,
          ), // Border when not focused
          borderRadius: BorderRadius.circular(8), // Rounded corners
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColor.gray,
            width: 2,
          ), // Border when focused
          borderRadius: BorderRadius.circular(8), // Rounded corners
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Please enter $hintText' : null,
    ),
  );
}

Widget buildButtonProfilewithonpressed(String text, VoidCallback onPressed) {
  return Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 16, left: 50, right: 30),
    child: Container(
      decoration: BoxDecoration(
        color: AppColor.darkblue,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ElevatedButton(
        onPressed: onPressed, // Now dynamic
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.darkblue,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          shadowColor: Colors.blueAccent,
          elevation: 6,
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}
