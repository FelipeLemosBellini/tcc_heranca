import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/models/testament_model.dart';
import 'package:tcc/ui/features/testator/see_details/see_details_controller.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';
import 'package:tcc/ui/widgets/app_bars/app_bar_simple_widget.dart';
import 'package:tcc/ui/widgets/buttons/button_icon_widget.dart';
import 'package:tcc/ui/widgets/buttons/elevated_button_thematic_widget.dart';

class SeeDetailsView extends StatefulWidget {
  final TestamentModel testamentModel;

  const SeeDetailsView({super.key, required this.testamentModel});

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
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return _lineData("0xABC...EF12", "30%");
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: AppColors.gray7),
                ),
                Text("Ativos", style: AppFonts.labelLargeBold),
                _lineData("ETH", "1.53"),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: AppColors.gray7),
                ),
                Text("Datas", style: AppFonts.labelLargeBold),
                _lineData("Data de criação", "01/01/0001"),
                _lineData("Última prova de vida", "01/01/0001"),
                _lineData("Vencimento prova de vida", "01/01/0001", isImportant: true),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ButtonIconWidget(onTap: () {}, actionButtonEnum: ActionButtonEnum.delete),
                    ButtonIconWidget(onTap: () {}, actionButtonEnum: ActionButtonEnum.edit),
                  ],
                ),
              ],
            ),
            bottomNavigationBar: ElevatedButtonThematicWidget(
              text: "Prova de vida",
              onTap: () {},
              thematicEnum: ThematicButtonEnum.green,
            ),
          ),
    );
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
