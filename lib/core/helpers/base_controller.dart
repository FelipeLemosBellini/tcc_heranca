import 'package:flutter/cupertino.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class BaseController extends ChangeNotifier {
  AlertData? _alertData;

  bool _isLoading = false;

  AlertData? get alertData => _alertData;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setMessage(AlertData alertData) {
    _alertData = alertData;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 100), () => _cleanError());
  }

  void _cleanError() => _alertData = null;
}
