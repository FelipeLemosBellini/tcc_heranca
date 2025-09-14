import 'package:get_it/get_it.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/testament_model.dart';
import 'package:tcc/core/models/user_model.dart';
import 'package:tcc/core/repositories/firestore/firestore_repository.dart';
import 'package:tcc/ui/features/home/home_controller.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class TestatorController extends BaseController {
  final HomeController _homeController = GetIt.I.get<HomeController>();

  final FirestoreRepository firestoreRepository;

  TestatorController({required this.firestoreRepository});

  List<TestamentModel> _listTestament = [];

  List<TestamentModel> get listTestament => _listTestament;

  void loadingTestaments() async {
    _homeController.setLoading(true);

    _listTestament.clear();
    notifyListeners();

    var response = await firestoreRepository.getUser();
    String address = "";
    response.fold(
      (error) {
        setMessage(
          AlertData(
            message: "Erro ao buscar o testamento",
            errorType: ErrorType.error,
          ),
        );
        _homeController.setLoading(false);
        notifyListeners();
        return;
      },
      (UserModel user) {
        address = user.address ?? "";
      },
    );

    var response2 = await firestoreRepository.getTestamentByAddress(address);
    response2.fold(
      (error) {
        _listTestament.clear();
        setMessage(
          AlertData(message: error.errorMessage, errorType: ErrorType.error),
        );
      },
      (success) {
        _listTestament.add(success);
      },
    );

    await Future.delayed(Duration(seconds: 1));
    _homeController.setLoading(false);
    notifyListeners();
  }
}
