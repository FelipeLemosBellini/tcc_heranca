import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/helpers/datetime_extensions.dart';
import 'package:tcc/core/helpers/datetime_extensions.dart';
import 'package:tcc/Enum/enum_prove_of_live_recorrence.dart';
import 'package:tcc/core/models/heir_model.dart';
import 'package:tcc/core/models/testament_model.dart';
import 'package:tcc/core/routers/routers.dart';
import 'package:tcc/ui/features/testator/testator_controller.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';
import 'package:tcc/ui/helpers/extensions.dart';
import 'package:tcc/ui/widgets/buttons/pill_button_widget.dart';

class TestatorView extends StatefulWidget {
  const TestatorView({super.key});

  @override
  State<TestatorView> createState() => _TestatorViewState();
}

class _TestatorViewState extends State<TestatorView> {
  TestatorController testatorController = GetIt.I.get<TestatorController>();
  final List<TestamentModel> listTestament = [
    TestamentModel(
      title: "Testamento de João",
      value: 3,
      listHeir: [
        HeirModel(
          address: "Maria",
          percentage: 50,
        ),
        HeirModel(
          address: "Carlos",
          percentage: 50,
        ),
      ],
      dateCreated: DateTime.now(),
      lastProveOfLife: DateTime.now(), 
      proveOfLiveRecorrence: EnumProveOfLiveRecorrence.TRIMESTRAL,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: testatorController,
      builder: (context, _) {
        return ListView.builder(
          itemCount: listTestament.length,
          padding: const EdgeInsets.all(24.0),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final testament = listTestament[index];
            return Padding(
              padding: EdgeInsets.only(bottom: listTestament.length - 1 == index ? 64 : 16),
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
                              context.push(RouterApp.seeDetails, extra: testament);
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
        );
      },
    );
  }
}
