import 'package:fpdart/src/either.dart';
import 'package:get_it/get_it.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/user_model.dart';
import 'package:tcc/core/repositories/firestore/firestore_repository_interface.dart';
import 'package:tcc/ui/features/home/home_controller.dart';

class WalletController extends BaseController {
  final HomeController _homeController = GetIt.I.get<HomeController>();
  final FirestoreRepositoryInterface _firestoreRepository = GetIt.I.get<FirestoreRepositoryInterface>();

  // Método que retorna só o endereço do usuário (ou null, se não tiver)
  Future<String?> getUserAddress() async {
    final result = await _firestoreRepository.getUser();
    return result.fold(
          (exception) => null,
          (user) => user.address,
    );
  }

  Future<void> loadAssets() async {
    _homeController.setLoading(true);

    final address = await getUserAddress();
    if (address == null) {
      print("Usuário ainda não carregado, adiando carregamento de assets");
      _homeController.setLoading(false);
      return;
    }

    // Simula carregamento de assets
    await Future.delayed(const Duration(seconds: 1));

    _homeController.setLoading(false);
  }
}
