import 'package:get_it/get_it.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/repositories/firestore/firestore_repository_interface.dart';
import 'package:tcc/ui/features/home/home_controller.dart';

class WalletController extends BaseController {
  final HomeController _homeController = GetIt.I.get<HomeController>();
  final FirestoreRepositoryInterface _firestoreRepository = GetIt.I.get<FirestoreRepositoryInterface>();

  double? get balance => _homeController.balance;

  // Método que retorna só o endereço do usuário (ou null, se não tiver)
  Future<String?> getUserAddress() async {
    final result = await _firestoreRepository.getUser();
    return result.fold(
          (exception) => null,
          (user) => user.address,
    );
  }

  Future<double> loadAssets() async {
    _homeController.setLoading(true);

    final result = await _firestoreRepository.getUser();
    if (result.isLeft()) {
      _homeController.setLoading(false);
      return 0.0;
    }

    final user = result.getRight().toNullable();
    if (user == null) {
      _homeController.setLoading(false);
      return 0.0;
    }

    await Future.delayed(const Duration(seconds: 1));
    _homeController.setLoading(false);
    return user.balance;
  }
}
