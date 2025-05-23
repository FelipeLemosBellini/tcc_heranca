import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/events/testament_created_event.dart';
import 'package:tcc/core/helpers/datetime_extensions.dart';
import 'package:tcc/core/models/testament_model.dart';
import 'package:tcc/core/routers/routers.dart';
import 'package:tcc/ui/features/testament/widgets/enum_type_user.dart';
import 'package:tcc/ui/features/testament/widgets/flow_testament_enum.dart';
import 'package:tcc/ui/features/testator/see_details/see_details_controller.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';
import 'package:tcc/ui/widgets/app_bars/app_bar_simple_widget.dart';
import 'package:tcc/ui/widgets/buttons/button_icon_widget.dart';
import 'package:tcc/ui/widgets/buttons/elevated_button_thematic_widget.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class SeeDetailsView extends StatefulWidget {
  final EnumTypeUser enumTypeUser;
  final TestamentModel testamentModel;

  const SeeDetailsView({super.key, required this.testamentModel, required this.enumTypeUser});

  @override
  State<SeeDetailsView> createState() => _SeeDetailsViewState();
}

class _SeeDetailsViewState extends State<SeeDetailsView> {
  SeeDetailsController seeDetailsController = GetIt.instance.get<SeeDetailsController>();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: seeDetailsController,
      builder:
          (context, _) => Scaffold(
            appBar: AppBarSimpleWidget(title: 'Detalhes', onTap: () => context.pop()),
            body: ListView(
              padding: EdgeInsets.all(24),
              children: [
                Text("Herdeiros", style: AppFonts.labelLargeBold),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.testamentModel.listHeir.length,
                  itemBuilder: (context, index) {
                    return _lineData(
                      widget.testamentModel.listHeir[index].address,
                      "${widget.testamentModel.listHeir[index].percentage.toString()}%",
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: AppColors.gray7),
                ),
                Text("Ativos", style: AppFonts.labelLargeBold),
                _lineData("ETH", widget.testamentModel.value.toString()),
                _lineData("POL", 1.23.toString()),
                _lineData("LDO", 4.56.toString()),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: AppColors.gray7),
                ),
                Text("Datas", style: AppFonts.labelLargeBold),
                _lineData("Data de criação", widget.testamentModel.dateCreated.dateFormatted),
                _lineData(
                  "Última prova de vida",
                  widget.testamentModel.lastProveOfLife.dateFormatted,
                ),
                _lineData(
                  "Vencimento prova de vida",
                  widget.testamentModel.proofLifeExpiration().dateFormatted,
                  isImportant: true,
                ),
                _lineData(
                  "Plano",
                  widget.testamentModel.plan.name,
                  isImportant: true,
                ),
                SizedBox(height: 8),
                Visibility(
                  visible: widget.enumTypeUser == EnumTypeUser.testator,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonIconWidget(
                        onTap: () => deleteTestament(),
                        actionButtonEnum: ActionButtonEnum.delete,
                      ),
                      ButtonIconWidget(
                        onTap: () {
                          seeDetailsController.setCurrentTestament(widget.testamentModel);
                          context.go(RouterApp.amountStep, extra: FlowTestamentEnum.edit);
                        },
                        actionButtonEnum: ActionButtonEnum.edit,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: ElevatedButtonThematicWidget(
              text:
                  widget.enumTypeUser == EnumTypeUser.testator
                      ? "Prova de vida"
                      : "Resgatar herança",
              onTap: _mainAction,
              thematicEnum: ThematicButtonEnum.green,
            ),
          ),
    );
  }

  void _mainAction() {
    AlertHelper.showAlertSnackBar(
      context: context,
      alertData: AlertData(
        message:
            widget.enumTypeUser == EnumTypeUser.testator
                ? 'Prova de vida realizada.'
                : 'Resgate realizado.',
        errorType: ErrorType.success,
      ),
    );
    context.pop();
  }

  void deleteTestament() {
    seeDetailsController.deleteTestament(widget.testamentModel);
    AlertHelper.showAlertSnackBar(
      context: context,
      alertData: AlertData(message: 'Testamento excluído.', errorType: ErrorType.success),
    );
    EventBus eventBus = GetIt.I.get<EventBus>();
    eventBus.fire(TestamentCreatedEvent());
    context.pop();
  }

  Widget _lineData(String title, String value, {bool? isImportant}) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, right: 8, left: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: isImportant ?? false ? AppFonts.bodySmallMedium : AppFonts.bodySmallRegular,
          ),
          Text(
            value,
            style:
                isImportant ?? false
                    ? AppFonts.bodySmallMedium
                    : AppFonts.bodySmallRegular.copyWith(color: AppColors.gray3),
          ),
        ],
      ),
    );
  }
}
