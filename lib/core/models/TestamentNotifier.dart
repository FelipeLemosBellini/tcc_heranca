import 'package:flutter/material.dart';
import 'package:tcc/core/models/testament_model.dart';

class TestamentNotifier extends ChangeNotifier {
  final TestamentModel _testament = TestamentModel(
    title: '',
    date: '',
    address: {},
    value: '',
  );

  TestamentModel get testament => _testament;

  void setTitle(String title) {
    _testament.title = title;
    notifyListeners();
  }

  void setDate(String date) {
    _testament.date = date;
    notifyListeners();
  }

  void setAddress(Map<String, int> address) {
    _testament.address = address;
    notifyListeners();
  }

  void setValue(String value) {
    _testament.value = value;
    notifyListeners();
  }
}
