import 'package:flutter/material.dart';

class AppInputStyles {

  static InputDecoration defaultInput({ 
    required String label,
    Color bgColor = Colors.white,
    Widget? suffix,
    bool isPassword = false,
    required bool obscureText,
    required VoidCallback? onToggleObscure,
    }) { 
    
    return InputDecoration(
                label: Text(label),
                filled: true,
                fillColor: bgColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: onToggleObscure,
                  )
                : suffix,
                //labelStyle: TextStyle(color: Colors.red),
                //floatingLabelStyle: TextStyle(color: Colors.green),
                //floatingLabelBehavior: FloatingLabelBehavior.never,
              ) ;
  }
}