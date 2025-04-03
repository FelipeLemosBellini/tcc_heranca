import 'package:get_it/get_it.dart';
import 'package:tcc/core/controllers/testament_controller.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/testament_model.dart';
import 'package:tcc/ui/features/home/home_controller.dart';

class HeirController extends BaseController {
  final HomeController _homeController = GetIt.I.get<HomeController>();
  final TestamentController _testamentController = GetIt.I.get<TestamentController>();

  List<TestamentModel> _listTestament = [];

  List<TestamentModel> get listTestament => _listTestament;

  void testamentImInserted() async {
    _homeController.setLoading(true);
    _listTestament = await _testamentController.getAllTestaments();
    await Future.delayed(Duration(seconds: 3));
    _homeController.setLoading(false);
  }
}
