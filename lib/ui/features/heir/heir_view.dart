import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/helpers/datetime_extensions.dart';
import 'package:tcc/core/routers/routers.dart';
import 'package:tcc/ui/features/heir/heir_controller.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';
import 'package:tcc/ui/widgets/buttons/pill_button_widget.dart';
import 'package:tcc/ui/widgets/loading_and_alert_overlay_widget.dart';

class HeirView extends StatefulWidget {
  const HeirView({super.key});

  @override
  State<HeirView> createState() => _HeirViewState();
}

class _HeirViewState extends State<HeirView> with AutomaticKeepAliveClientMixin {
  HeirController heirController = GetIt.I.get<HeirController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      heirController.testamentImInserted();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListenableBuilder(
      listenable: heirController,
      builder: (context, _) {
        return LoadingAndAlertOverlayWidget(
          isLoading: heirController.isLoading,
          alertData: heirController.alertData,
          child: Visibility(
            visible: heirController.listTestament.isNotEmpty,
            replacement: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.description_outlined, size: 40, color: AppColors.primaryLight3),
                SizedBox(height: 8),
                Text('Você não está em nenhum testamento.', style: AppFonts.labelLargeMedium),
              ],
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(24.0),
              shrinkWrap: true,
              itemCount: heirController.listTestament.length,
              itemBuilder: (context, index) {
                final testament = heirController.listTestament[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: heirController.listTestament.length - 1 == index ? 64 : 16,
                  ),
                  child: Card(
                    color: AppColors.primary6,
                    shadowColor: AppColors.primaryLight5,
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Text(testament.title, style: AppFonts.bodyLargeBold),
                          const SizedBox(height: 8),
                          Text(
                            "Criado em: ${testament.dateCreated.dateFormatted}",
                            style: AppFonts.labelSmallLight.copyWith(color: AppColors.primaryLight2),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Prova de vida: ${testament.lastProveOfLife.dateFormatted}",
                            style: AppFonts.labelSmallBold.copyWith(color: AppColors.error2),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Divider(color: AppColors.white),
                          ),
                          Text("Endereço do Contrato:", style: AppFonts.labelSmallBold),
                          const SizedBox(height: 8),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: testament.listHeir.length,
                            itemBuilder: (context, index) {
                              final heir = testament.listHeir[index];
                              return Text(
                                heir.address,
                                style: AppFonts.bodySmallRegular.copyWith(
                                  color: AppColors.primaryLight2,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Valor:", style: AppFonts.labelSmallBold),
                                  const SizedBox(height: 8),
                                  Text(
                                    "${testament.value} ETH",
                                    style: AppFonts.labelMediumBold.copyWith(
                                      color: AppColors.primaryLight2,
                                    ),
                                  ),
                                ],
                              ),
                              PillButtonWidget(
                                onTap: () {
                                  // context.push(RouterApp.seeDetails, extra: testament);
                                },
                                text: "Ver detalhes",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
