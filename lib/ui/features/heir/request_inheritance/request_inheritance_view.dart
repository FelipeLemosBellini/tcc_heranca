import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tcc/core/models/request_inheritance_model.dart';
import 'package:tcc/ui/features/auth/kyc/widgets/section_card.dart';
import 'package:tcc/ui/features/auth/kyc/widgets/upload_tile_simple.dart';
import 'package:tcc/ui/features/heir/request_inheritance/request_inheritance_controller.dart';
import 'package:tcc/ui/widgets/app_bars/app_bar_simple_widget.dart';
import 'package:tcc/ui/widgets/buttons/elevated_button_widget.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';
import 'package:tcc/ui/widgets/loading_and_alert_overlay_widget.dart';
import 'package:tcc/ui/widgets/text_field_widget.dart';

class RequestInheritanceView extends StatefulWidget {
  final RequestInheritanceModel inheritance;

  const RequestInheritanceView({super.key, required this.inheritance});

  @override
  State<RequestInheritanceView> createState() => _RequestInheritanceViewState();
}

class _RequestInheritanceViewState extends State<RequestInheritanceView> {
  final RequestInheritanceController _requestInheritanceController =
      GetIt.I.get<RequestInheritanceController>();

  ImagePicker imagePicker = ImagePicker();

  XFile? procuracaoDoInventariante;
  XFile? certidaoDeObito;
  XFile? documentoCpf;
  XFile? enderecoDoInventariante;
  XFile? testamento;
  XFile? transferenciaDeAtivos;

  // Controllers
  final cpfController = TextEditingController();
  final rgController = TextEditingController();

  // FocusNodes
  final cpfFocus = FocusNode();
  final rgFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    cpfController.text = widget.inheritance.cpf ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _requestInheritanceController,
      builder:
          (_, __) => LoadingAndAlertOverlayWidget(
            isLoading: _requestInheritanceController.isLoading,
            alertData: _requestInheritanceController.alertData,
            child: Scaffold(
              appBar: AppBarSimpleWidget(
                title: "Solicitar herança",
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
                            controller: cpfController,
                            keyboardType: TextInputType.number,
                            onlyNumber: true,
                            focusNode: cpfFocus,
                          ),
                          const SizedBox(height: 16),
                          TextFieldWidget(
                            hintText: 'Número do RG',
                            controller: rgController,
                            focusNode: rgFocus,
                            onlyNumber: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SectionCard(
                        title: 'Anexos - somente PDF',
                        icon: Icons.attach_file_outlined,
                        children: [
                          UploadTileSimple(
                            label: 'Procuração do inventariantes',
                            hasAttach: procuracaoDoInventariante != null,
                            attach: () async {
                              procuracaoDoInventariante = await getFile(
                                context,
                              );
                              setState(() {});
                            },
                          ),
                          SizedBox(height: 12),
                          UploadTileSimple(
                            label: 'Certidão de óbito',
                            hasAttach: certidaoDeObito != null,
                            attach: () async {
                              certidaoDeObito = await getFile(context);
                              setState(() {});
                            },
                          ),
                          SizedBox(height: 12),
                          UploadTileSimple(
                            label: 'Documento CPF',
                            hasAttach: documentoCpf != null,
                            attach: () async {
                              documentoCpf = await getFile(context);
                              setState(() {});
                            },
                          ),
                          SizedBox(height: 12),
                          UploadTileSimple(
                            label: 'Endereço do representante/inventariante',
                            hasAttach: enderecoDoInventariante != null,
                            attach: () async {
                              enderecoDoInventariante = await getFile(context);
                              setState(() {});
                            },
                          ),
                          SizedBox(height: 12),
                          UploadTileSimple(
                            label:
                                'Testamento ou documento do processo do inventário',
                            hasAttach: testamento != null,
                            attach: () async {
                              testamento = await getFile(context);
                              setState(() {});
                            },
                          ),
                          SizedBox(height: 12),
                          UploadTileSimple(
                            label:
                                'Ordem judicial para transferência dos ativos',
                            hasAttach: transferenciaDeAtivos != null,
                            attach: () async {
                              transferenciaDeAtivos = await getFile(context);
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
                                    certidaoDeObito == null ||
                                    documentoCpf == null ||
                                    enderecoDoInventariante == null ||
                                    testamento == null ||
                                    transferenciaDeAtivos == null) {
                                  AlertHelper.showAlertSnackBar(
                                    context: context,
                                    alertData: AlertData(
                                      message: 'Anexe todos os documentos obrigatórios.',
                                      errorType: ErrorType.warning,
                                    ),
                                  );
                                  return;
                                }
                                await _requestInheritanceController
                                    .createRequestInheritance(
                                      inheritance: widget.inheritance,
                                      rg: rgController.text,
                                      procuracaoDoInventariante:
                                          procuracaoDoInventariante!,
                                      certidaoDeObito: certidaoDeObito!,
                                      documentoCpf: documentoCpf!,
                                      enderecoDoInventariante:
                                          enderecoDoInventariante!,
                                      testamento: testamento!,
                                      transferenciaDeAtivos:
                                          transferenciaDeAtivos!,
                                    );
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
