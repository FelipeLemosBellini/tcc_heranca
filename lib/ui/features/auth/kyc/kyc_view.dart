import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tcc/core/enum/review_status_document.dart';
import 'package:tcc/ui/features/auth/kyc/widgets/header_banner.dart';
import 'package:tcc/ui/features/auth/kyc/widgets/section_card.dart';
import 'package:tcc/ui/features/auth/kyc/widgets/upload_tile_simple.dart';

import 'package:tcc/ui/widgets/app_bars/app_bar_simple_widget.dart';
import 'package:tcc/ui/widgets/buttons/elevated_button_widget.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';
import 'package:tcc/ui/widgets/loading_and_alert_overlay_widget.dart';
import 'package:tcc/ui/widgets/text_field_widget.dart';
import 'package:tcc/ui/widgets/input_formatters/cpf_input_formatter.dart';
import 'package:tcc/ui/features/auth/kyc/kyc_controller.dart';

class KycView extends StatefulWidget {
  final bool isEdit;

  const KycView({super.key, required this.isEdit});

  @override
  State<KycView> createState() => _KycViewState();
}

class _KycViewState extends State<KycView> {
  final KycController controller = GetIt.I.get<KycController>();

  ImagePicker imagePicker = ImagePicker();

  // FocusNodes
  final cpfFocus = FocusNode();
  final rgFocus = FocusNode();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isEdit) {
        controller.getUser();
      }
    });
  }

  Future<void> _onSubmit(BuildContext context) async {
    if (widget.isEdit) {
      if (controller.proofResidence != null || controller.cpfFront != null) {
        submit(isEdit: true);
      }
      return;
    }

    if (controller.cpfFront != null && controller.proofResidence != null) {
      submit(isEdit: false);
    } else {
      controller.setMessage(
        AlertData(
          message: "Anexe todos os documentos",
          errorType: ErrorType.warning,
        ),
      );
    }
  }

  void submit({required bool isEdit}) async {
    bool response = await controller.submit(isEdit: isEdit);
    if (response) {
      context.pop();
      context.pop();
      controller.setMessage(
        AlertData(
          message: "Documentos enviados para análise",
          errorType: ErrorType.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return LoadingAndAlertOverlayWidget(
          isLoading: controller.isLoading,
          alertData: controller.alertData,
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBarSimpleWidget(
              title: 'Criar Conta',
              onTap: () => context.pop(),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    HeaderBanner(),
                    const SizedBox(height: 16),
                    SectionCard(
                      title: 'Dados',
                      subtitle:
                          'Preencha seus dados básicos. Campos mínimos para validação.',
                      icon: Icons.person_outline,
                      children: [
                        TextFieldWidget(
                          hintText: 'CPF (somente números)',
                          controller: controller.cpfController,
                          keyboardType: TextInputType.number,
                          focusNode: cpfFocus,
                          inputFormatters: [CpfInputFormatter()],
                        ),
                        const SizedBox(height: 16),
                        TextFieldWidget(
                          hintText: 'Número do RG',
                          controller: controller.rgController,
                          focusNode: rgFocus,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SectionCard(
                      title: 'Anexos - somente PDF',
                      icon: Icons.attach_file_outlined,
                      children: [
                        Visibility(
                          visible:
                              !widget.isEdit || controller.cpfDocument != null,
                          child: UploadTileSimple(
                            document: controller.cpfDocument,
                            label: 'Documento de identidade (frente/verso)',
                            hasAttach: controller.cpfFront != null,
                            attach: () async {
                              controller.cpfFront = await getFile(context);
                              setState(() {});
                            },
                          ),
                        ),
                        Visibility(
                          visible:
                              !widget.isEdit ||
                              controller.proofResidenceDocument != null,
                          child: SizedBox(height: 12),
                        ),
                        Visibility(
                          visible:
                              !widget.isEdit ||
                              controller.proofResidenceDocument != null,
                          child: UploadTileSimple(
                            document: controller.proofResidenceDocument,
                            label: 'Comprovante de residência',
                            hasAttach: controller.proofResidence != null,
                            attach: () async {
                              controller.proofResidence = await getFile(
                                context,
                              );
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButtonWidget(
                            text: 'Enviar',
                            onTap: () => _onSubmit(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<XFile?> getFile(BuildContext context) async {
    XFile? file = await imagePicker.pickMedia();
    if (file != null) {
      if (!file.path.endsWith('.pdf')) {
        AlertHelper.showAlertSnackBar(
          context: context,
          alertData: AlertData(
            message: "Selecione um .pdf",
            errorType: ErrorType.warning,
          ),
        );
      }
      return file;
    } else {
      AlertHelper.showAlertSnackBar(
        context: context,
        alertData: AlertData(
          message: "Selecione um arquivo",
          errorType: ErrorType.warning,
        ),
      );
      return null;
    }
  }
}
