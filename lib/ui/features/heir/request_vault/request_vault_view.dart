import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tcc/core/routers/routers.dart';
import 'package:tcc/ui/features/auth/kyc/widgets/section_card.dart';
import 'package:tcc/ui/features/auth/kyc/widgets/upload_tile_simple.dart';
import 'package:tcc/ui/features/heir/request_inheritance/request_inheritance_controller.dart';
import 'package:tcc/ui/features/heir/request_vault/request_vault_controller.dart';
import 'package:tcc/ui/widgets/app_bars/app_bar_simple_widget.dart';
import 'package:tcc/ui/widgets/buttons/elevated_button_widget.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';
import 'package:tcc/ui/widgets/loading_and_alert_overlay_widget.dart';
import 'package:tcc/ui/widgets/input_formatters/cpf_input_formatter.dart';
import 'package:tcc/ui/widgets/text_field_widget.dart';

class RequestVaultView extends StatefulWidget {
  const RequestVaultView({super.key});

  @override
  State<RequestVaultView> createState() => _RequestVaultViewState();
}

class _RequestVaultViewState extends State<RequestVaultView> {
  final RequestVaultController _requestVaultController =
      GetIt.I.get<RequestVaultController>();

  ImagePicker imagePicker = ImagePicker();

  XFile? procuracaoDoInventariante;
  XFile? certidaoDeObito;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _requestVaultController,
      builder:
          (_, __) => LoadingAndAlertOverlayWidget(
            isLoading: _requestVaultController.isLoading,
            alertData: _requestVaultController.alertData,
            child: Scaffold(
              appBar: AppBarSimpleWidget(
                title: "Solicitar saldo do cofre",
                onTap: () {
                  context.pop();
                },
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
                      SectionCard(
                        title: 'Dados do falecido',
                        subtitle: 'Preencha com os dados básicos do falecido.',
                        icon: Icons.person_outline,
                        children: [
                          TextFieldWidget(
                            hintText: 'CPF (somente números)',
                            controller:
                                _requestVaultController.cpfTestatorController,
                            keyboardType: TextInputType.number,
                            focusNode: _requestVaultController.cpfTestatorFocus,
                            inputFormatters: [CpfInputFormatter()],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SectionCard(
                        title: 'Anexos',
                        icon: Icons.attach_file_outlined,
                        children: [
                          UploadTileSimple(
                            label: 'Certificado de Obito',
                            hasAttach: procuracaoDoInventariante != null,
                            attach: () async {
                              procuracaoDoInventariante = await getFile(context);
                              setState(() {});
                            },
                          ),
                          SizedBox(height: 12),
                          UploadTileSimple(
                            label: 'Procuracao do inventariante',
                            hasAttach: certidaoDeObito != null,
                            attach: () async {
                              certidaoDeObito = await getFile(context);
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
                              onTap: () async {
                                if (procuracaoDoInventariante == null ||
                                    certidaoDeObito == null) {
                                  _requestVaultController.setMessage(
                                    AlertData(
                                      message: "Anexe os documentos!",
                                      errorType: ErrorType.error,
                                    ),
                                  );
                                  return;
                                }

                                final success =
                                    await _requestVaultController
                                        .createRequestInheritance(
                                          certificadoDeObito: certidaoDeObito!,
                                          procuracaoAdvogado:
                                              procuracaoDoInventariante!,
                                          cpfTestator:
                                              _requestVaultController
                                                  .cpfTestatorController
                                                  .text,
                                        );
                                if (!mounted) return;
                                if (success) {
                                  context.pop();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
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
