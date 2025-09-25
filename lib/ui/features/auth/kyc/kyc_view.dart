import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tcc/ui/features/auth/kyc/widgets/header_banner.dart';
import 'package:tcc/ui/features/auth/kyc/widgets/section_card.dart';
import 'package:tcc/ui/features/auth/kyc/widgets/upload_tile_simple.dart';

import 'package:tcc/ui/widgets/app_bars/app_bar_simple_widget.dart';
import 'package:tcc/ui/widgets/buttons/elevated_button_widget.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';
import 'package:tcc/ui/widgets/loading_and_alert_overlay_widget.dart';
import 'package:tcc/ui/widgets/text_field_widget.dart';
import 'package:tcc/ui/features/auth/kyc/kyc_controller.dart';

class KycView extends StatefulWidget {
  const KycView({super.key});

  @override
  State<KycView> createState() => _KycViewState();
}

class _KycViewState extends State<KycView> {
  final KycController controller = GetIt.I.get<KycController>();

  ImagePicker imagePicker = ImagePicker();

  XFile? cpfFront;
  XFile? proofResidence;

  // Controllers
  final cpfController = TextEditingController();
  final rgController = TextEditingController();

  // FocusNodes
  final cpfFocus = FocusNode();
  final rgFocus = FocusNode();

  @override
  void dispose() {
    cpfController.dispose();
    rgController.dispose();
    cpfFocus.dispose();
    rgFocus.dispose();
    super.dispose();
  }

  Future<void> _onSubmit(BuildContext context) async {
    if (cpfFront != null && proofResidence != null) {
      bool response = await controller.submit(
        cpf: cpfController.text,
        rg: rgController.text,
        cpfFront: cpfFront!,
        proofResidence: proofResidence!,
      );
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
    } else {
      controller.setMessage(
        AlertData(
          message: "Anexe todos os documentos",
          errorType: ErrorType.warning,
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
                          controller: cpfController,
                          keyboardType: TextInputType.number,
                          focusNode: cpfFocus,
                        ),
                        const SizedBox(height: 16),
                        TextFieldWidget(
                          hintText: 'Número do RG',
                          controller: rgController,
                          focusNode: rgFocus,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SectionCard(
                      title: 'Anexos - somente PDF',
                      icon: Icons.attach_file_outlined,
                      children: [
                        UploadTileSimple(
                          label: 'Documento de identidade (frente/verso)',
                          hasAttach: cpfFront != null,
                          attach: () async {
                            cpfFront = await getFile(context);
                            setState(() {});
                          },
                        ),
                        SizedBox(height: 12),
                        UploadTileSimple(
                          label: 'Comprovante de residência',
                          hasAttach: proofResidence != null,
                          attach: () async {
                            proofResidence = await getFile(context);
                            setState(() {});
                          },
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
