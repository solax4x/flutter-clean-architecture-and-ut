import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFormFieldUtil {
  static const double ICON_SIZE = 22;
  static const Color ICON_COLOR = Colors.white;

  static TextFormField getLoginFormTextField(
      {Icon prefixIcon,
      String hintText = null,
      String labelText = null,
      Function validator,
      TextEditingController controller,
      TextInputType keyboardType = TextInputType.text,
      TextStyle textStyle}) {
    TextFormField textFormField = TextFormField(
      keyboardType: keyboardType,
      style: textStyle,
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white, height: 1.2),
        contentPadding: EdgeInsets.all(21),
        isDense: true,
        filled: true,
        fillColor: Colors.white24,
        errorStyle: TextStyle(color: CupertinoColors.destructiveRed),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide:
              BorderSide(color: CupertinoColors.destructiveRed, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Color(0xffFF8F00), width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.black54, width: 2.0),
        ),
        // add padding to adjust text
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white70, height: 1.2),
        prefixIcon: Padding(
            padding: EdgeInsets.only(left: 24, right: 16), child: prefixIcon),
      ),
    );
    return textFormField;
  }
}
