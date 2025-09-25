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
import 'package:tcc/ui/widgets/loading_and_alert_overlay_widget.dart';
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
  XFile? documentoCpf;
  XFile? enderecoDoInventariante;
  XFile? testamento;
  XFile? transferenciaDeAtivos;

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
                        title: 'Dados do inventariante',
                        subtitle:
                            'Preencha com os dados básicos do inventariante.',
                        icon: Icons.person_outline,
                        children: [
                          TextFieldWidget(
                            hintText: 'CPF (somente números)',
                            controller: _requestVaultController.cpfHeirController,
                            keyboardType: TextInputType.number,
                            onlyNumber: true,
                            focusNode: _requestVaultController.cpfHeirFocus,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SectionCard(
                        title: 'Dados do falecido',
                        subtitle: 'Preencha com os dados básicos do falecido.',
                        icon: Icons.person_outline,
                        children: [
                          TextFieldWidget(
                            hintText: 'CPF (somente números)',
                            controller: _requestVaultController.cpfTestatorController,
                            keyboardType: TextInputType.number,
                            onlyNumber: true,
                            focusNode: _requestVaultController.cpfTestatorFocus,
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
                              procuracaoDoInventariante = await imagePicker
                                  .pickImage(source: ImageSource.camera);
                              setState(() {});
                            },
                          ),
                          SizedBox(height: 12),
                          UploadTileSimple(
                            label: 'Procuracao do inventariante',
                            hasAttach: certidaoDeObito != null,
                            attach: () async {
                              certidaoDeObito = await imagePicker.pickImage(
                                source: ImageSource.camera,
                              );
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
                              onTap: () {
                                context.pop();
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
}
