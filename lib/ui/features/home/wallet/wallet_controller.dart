import 'package:get_it/get_it.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/user_model.dart';
import 'package:tcc/core/repositories/firestore/firestore_repository_interface.dart';
import 'package:tcc/ui/features/home/home_controller.dart';

class WalletController extends BaseController {
  final HomeController homeController;
  final FirestoreRepositoryInterface firestoreRepository;

  WalletController({
    required this.homeController,
    required this.firestoreRepository,
  });

  UserModel? userModel;

  Future<void> loadUser() async {
    // _homeController.setLoading(true);
    // final result = await _firestoreRepository.getUser();
    // result.fold(
    //   (error) {
    //     setMessage(
    //       AlertData(
    //         message: "Erro ao criar o testamento",
    //         errorType: ErrorType.error,
    //       ),
    //     );
    //     return;
    //   },
    //   (UserModel user) {
    //     userModel = user;
    //     notifyListeners();
    //   },
    // );
    // _homeController.setLoading(false);
  }
}
