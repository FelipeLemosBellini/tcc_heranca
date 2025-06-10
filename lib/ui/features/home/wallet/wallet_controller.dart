import 'package:get_it/get_it.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/repositories/firestore/firestore_repository_interface.dart';
import 'package:tcc/ui/features/home/home_controller.dart';

class WalletController extends BaseController {
  final HomeController _homeController = GetIt.I.get<HomeController>();
  final FirestoreRepositoryInterface _firestoreRepository =
      GetIt.I.get<FirestoreRepositoryInterface>();

  final double balanceETH = 0;
  String userAddress = "";

  Future<void> getUserAddress() async {
    final result = await _firestoreRepository.getUser();
    return result.fold(
      (exception) => null,
      (user) => userAddress = user.address,
    );
  }

  Future<void> reloadData() async {
    _homeController.setLoading(true);

    getUserAddress().then((_) {
      notifyListeners();
    });
    _homeController.setLoading(false);
  }
}
