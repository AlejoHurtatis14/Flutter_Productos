import 'package:flutter/material.dart';

class ValidationFormInput {
  static emailValidation({
    @required String value,
  }) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value ?? '') ? null : 'El correo no es correcto.';
  }

  static lenghtStringValidation({
    @required String value,
    @required int length,
  }) {
    if (value != null && value.length >= length) return null;
    return 'El campo debe tener un valor mayor a $length caracteres';
  }
}
