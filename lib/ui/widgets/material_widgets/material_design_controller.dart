import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class MaterialDesignController extends BaseController {
  void showWarning() {
    setMessage(AlertData(message: "Waring", errorType: ErrorType.warning));
  }

  void showSuccess() {
    setMessage(AlertData(message: "Success", errorType: ErrorType.success));
  }

  void showError() {
    setMessage(AlertData(message: "Error", errorType: ErrorType.error));
  }

  void loading() async {
    setLoading(true);
    await Future.delayed(Duration(seconds: 3));
    setLoading(false);
  }
}
