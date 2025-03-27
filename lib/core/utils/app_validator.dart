import 'package:flutter/material.dart';
import 'package:finder/core/functions/reg_exp.dart';

class AppValidators {
  static String? validateFillFields(BuildContext context, String? name) {
    if (name == null || name.isEmpty) {
      return "This field is required";
    }
    return null;
  }

  static String? validatePasswordFields(
      BuildContext context, String? password) {
    if (password == null || password.isEmpty) {
      return "This field is required";
    } else if (AppRegexp.passwordRegex.hasMatch(password) == false) {
      return "Password must be 10 characters with a mix of numbers,upper case characters and symbols.";
    }
    return null;
  }

  static String? validateRepeatPasswordFields(
      BuildContext context, String? password, String? repeatedPassword) {
    if (repeatedPassword == null || repeatedPassword.isEmpty) {
      return "This field is required";
    }
    if (password != repeatedPassword) {
      return "confirmed password must be same as password";
    }
    return null;
  }

  static String? validateEmailFields(BuildContext context, String? email) {
    if (email == null || email.isEmpty) {
      return "This field is required";
    } else if (AppRegexp.emailRegexp.hasMatch(email) == false) {
      return "email not valid in right form";
    }
    return null;
  }

  static String? validatePhoneFields(BuildContext context, String? phone) {
    if (phone == null || phone.isEmpty) {
      return "This field is required";
    }
    if (AppRegexp.phoneRegexp.hasMatch(phone) == false) {
      return "phone number not valid";
    }
    return null;
  }
}
