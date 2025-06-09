import 'package:get_it/get_it.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/testament_model.dart';
import 'package:tcc/core/repositories/firestore/firestore_repository.dart';
import 'package:tcc/ui/features/home/home_controller.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class HeirController extends BaseController {
  final HomeController _homeController = GetIt.I.get<HomeController>();
  final FirestoreRepository firestoreRepository;

  HeirController({required this.firestoreRepository});

  List<TestamentModel> _listTestament = [];

  List<TestamentModel> get listTestament => _listTestament;

  void loadingTestaments() async {
    _homeController.setLoading(true);
    // var response = await firestoreRepository.getTestamentByAddress(address);
    //
    // response.fold(
    //   (error) {
    //     setMessage(
    //       AlertData(message: error.errorMessage, errorType: ErrorType.error),
    //     );
    //   },
    //   (success) {
    //     _listTestament = success;
    //   },
    // );
    await Future.delayed(Duration(seconds: 1));
    _homeController.setLoading(false);
    notifyListeners();
  }
}
