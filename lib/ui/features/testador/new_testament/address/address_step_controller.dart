import 'package:flutter/material.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class AddressStepController extends ChangeNotifier {
  bool _isLoading = false;
  AlertData? _alertData;

  bool get isLoading => _isLoading;
  AlertData? get alertData => _alertData;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setAlert(AlertData? alert) {
    _alertData = alert;
    notifyListeners();
  }
}
