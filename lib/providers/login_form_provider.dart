import 'package:flutter/material.dart';

class LoginFOrmProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String email = '';
  String password = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  bool isValidForm() {
    return this.formKey.currentState?.validate() ?? false;
  }
}
