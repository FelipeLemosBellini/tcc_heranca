import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class MaterialDesignController extends BaseController {
  void showWarning() {
    setMessage(AlertData(message: "Waring", errorType: ErrorType.warning), displayDuration: const Duration(seconds: 5));
  }

  void showSuccess() {
    setMessage(AlertData(message: "Success", errorType: ErrorType.success), displayDuration: const Duration(seconds: 5));
  }

  void showError() {
    setMessage(AlertData(message: "Error", errorType: ErrorType.error), displayDuration: const Duration(seconds: 5));
  }

  void loading() async {
    setLoading(true);
    await Future.delayed(Duration(seconds: 3));
    setLoading(false);
  }
}
