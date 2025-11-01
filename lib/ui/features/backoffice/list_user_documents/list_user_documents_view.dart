import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/enum/enum_documents_from.dart';
import 'package:tcc/core/enum/review_status_document.dart';
import 'package:tcc/core/events/update_users_event.dart';
import 'package:tcc/core/routers/routers.dart';
import 'package:tcc/ui/features/backoffice/list_user_documents/list_user_documents_controller.dart';
import 'package:tcc/ui/widgets/app_bars/app_bar_simple_widget.dart';
import 'package:tcc/ui/widgets/buttons/elevated_button_widget.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';
import 'package:tcc/ui/widgets/loading_and_alert_overlay_widget.dart';
import 'package:tcc/ui/widgets/text_field_widget.dart';

class ListUserDocumentsView extends StatefulWidget {
  final String userId;
  final String? testatorCpf;
  final String? testatorName;

  const ListUserDocumentsView({
    super.key,
    required this.userId,
    this.testatorCpf,
    this.testatorName,
  });

  @override
  State<ListUserDocumentsView> createState() => _ListUserDocumentsViewState();
}

class _ListUserDocumentsViewState extends State<ListUserDocumentsView> {
  final ListUserDocumentsController _controller =
      GetIt.I.get<ListUserDocumentsController>();
  final EventBus eventBus = GetIt.I.get<EventBus>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _controller.getDocumentsByUserId(
        userId: widget.userId,
        testatorCpf: widget.testatorCpf,
        from: widget.testatorCpf != null
            ? EnumDocumentsFrom.inheritanceRequest
            : EnumDocumentsFrom.kyc,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return LoadingAndAlertOverlayWidget(
          isLoading: _controller.isLoading,
          alertData: _controller.alertData,
          child: Scaffold(
            appBar: AppBarSimpleWidget(
              title: 'Validar documentos',
              onTap: () {
                context.pop();
              },
            ),
            body: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.testatorName != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.testatorName ?? '',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        if (widget.testatorCpf != null)
                          Text(
                            'CPF: ${widget.testatorCpf}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      ],
                    ),
                  ),
                Expanded(
                  child: _controller.listDocuments.isEmpty
                      ? const Center(
                          child: Text('Nenhum documento pendente.'),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 16),
                          itemCount: _controller.listDocuments.length,
                          itemBuilder: (context, index) {
                            final doc = _controller.listDocuments[index];
                            final isPending =
                                doc.reviewStatus == ReviewStatusDocument.pending;
                            final selected = isPending
                                ? _controller.decisions[doc.idDocument]
                                : null;
                            return Column(
                              children: [
                                Card(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.description),
                                            const SizedBox(width: 8),
                                            Text(doc.typeDocument.Name),
                                            const Spacer(),
                                            GestureDetector(
                                              onTap: () {
                                                if (doc.pathStorage != null) {
                                                  _controller.openPdf(
                                                    doc.pathStorage!,
                                                  );
                                                }
                                              },
                                              child: const Icon(
                                                Icons.file_open_outlined,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (isPending)
                                          Row(
                                            children: [
                                              Expanded(
                                                child: RadioListTile<bool>(
                                                  title: const Text('Aprovar'),
                                                  value: true,
                                                  groupValue: selected,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _controller.decisions[
                                                        doc.idDocument!
                                                      ] = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                              Expanded(
                                                child: RadioListTile<bool>(
                                                  title: const Text('Reprovar'),
                                                  value: false,
                                                  groupValue: selected,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _controller.decisions[
                                                        doc.idDocument!
                                                      ] = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          )
                                        else
                                          Container(
                                            margin: const EdgeInsets.only(top: 12),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: doc.reviewStatus ==
                                                      ReviewStatusDocument.approved
                                                  ? Colors.green.withOpacity(0.15)
                                                  : Colors.red.withOpacity(0.15),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  doc.reviewStatus ==
                                                          ReviewStatusDocument
                                                              .approved
                                                      ? Icons.check_circle_outline
                                                      : Icons.highlight_off,
                                                  color: doc.reviewStatus ==
                                                          ReviewStatusDocument
                                                              .approved
                                                      ? Colors.green.shade700
                                                      : Colors.red.shade700,
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    doc.reviewStatus ==
                                                            ReviewStatusDocument
                                                                .approved
                                                        ? 'Documento aprovado'
                                                        : 'Documento recusado',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (isPending)
                                  Visibility(
                                    visible: selected == false,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 8,
                                      ),
                                      child: TextFieldWidget(
                                        controller: _controller
                                            .reasonControllers[index],
                                        maxLines: 3,
                                        hintText: 'Motivo da reprovação',
                                        focusNode: _controller.focusNodes[index],
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                ),
              ],
            ),
            bottomSheet: ElevatedButtonWidget(
              onTap: () async {
                for (
                  int index = 0;
                  index < _controller.listDocuments.length;
                  index++
                ) {
                  final doc = _controller.listDocuments[index];
                  if (doc.reviewStatus != ReviewStatusDocument.pending) {
                    continue;
                  }
                  if (_controller.reasonControllers[index].text.isEmpty &&
                      _controller.decisions[doc.idDocument] ==
                          false) {
                    AlertHelper.showAlertSnackBar(
                      context: context,
                      alertData: AlertData(
                        message: 'Preencha o motivo da reprova',
                        errorType: ErrorType.warning,
                      ),
                    );
                    return;
                  }

                  if (_controller.decisions[doc.idDocument] == null) {
                    AlertHelper.showAlertSnackBar(
                      context: context,
                      alertData: AlertData(
                        message:
                            'Selecione as opções de aprovação ou reprovação',
                        errorType: ErrorType.warning,
                      ),
                    );
                    return;
                  }
                }
                for (
                  int index = 0;
                  index < _controller.listDocuments.length;
                  index++
                ) {
                  final doc = _controller.listDocuments[index];
                  if (doc.reviewStatus != ReviewStatusDocument.pending) {
                    continue;
                  }
                  doc.reviewMessage = _controller.reasonControllers[index].text;
                  await _controller.submit(documents: doc);
                }

                bool hasInvalidDocuments = false;

                for (
                  int index = 0;
                  index < _controller.listDocuments.length;
                  index++
                ) {
                  final doc = _controller.listDocuments[index];
                  if (doc.reviewStatus != ReviewStatusDocument.pending) {
                    continue;
                  }
                  if (_controller.decisions[doc.idDocument] == false) {
                    hasInvalidDocuments = true;
                    break;
                  }
                }

                if (_controller.currentTestatorCpf != null) {
                  await _controller.updateInheritanceStatus(
                    hasInvalidDocuments: hasInvalidDocuments,
                    requesterId: widget.userId,
                    testatorCpf: _controller.currentTestatorCpf!,
                  );
                } else {
                  await _controller.updateKycStatus(
                    hasInvalidDocument: hasInvalidDocuments,
                    userId: widget.userId,
                  );
                }

                AlertHelper.showAlertSnackBar(
                  context: context,
                  alertData: AlertData(
                    message: hasInvalidDocuments
                        ? 'Análise concluída: existem documentos reprovados.'
                        : 'Documentos aprovados com sucesso!',
                    errorType: ErrorType.success,
                  ),
                );
                eventBus.fire(UpdateUsersEvent());
                if (!mounted) return;
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(RouterApp.listUsers);
                }
              },
              text: "Enviar",
            ),
          ),
        );
      },
    );
  }
}
