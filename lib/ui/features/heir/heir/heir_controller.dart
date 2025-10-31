import 'package:get_it/get_it.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/request_inheritance_model.dart';
import 'package:tcc/core/models/testament_model.dart';
import 'package:tcc/core/models/user_model.dart';
import 'package:tcc/core/repositories/inheritance_repository/inheritance_repository.dart';
import 'package:tcc/core/repositories/user_repository/user_repository.dart';
import 'package:tcc/ui/features/home/home_controller.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class HeirController extends BaseController {
  final HomeController _homeController = GetIt.I.get<HomeController>();
  final InheritanceRepository inheritanceRepository;

  HeirController({required this.inheritanceRepository});

  List<RequestInheritanceModel> _listTestament = [];

  List<RequestInheritanceModel> get listTestament => _listTestament;

  void loadingTestaments() async {
    _homeController.setLoading(true);

    var response = await inheritanceRepository.getInheritancesByUserId();

    response.fold((error) {}, (success) {
      _listTestament = success;
    });

    await Future.delayed(Duration(seconds: 1));
    _homeController.setLoading(false);
    notifyListeners();
  }
}
