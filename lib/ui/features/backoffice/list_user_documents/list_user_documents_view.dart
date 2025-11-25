import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/enum/enum_documents_from.dart';
import 'package:tcc/core/enum/review_status_document.dart';
import 'package:tcc/core/events/update_users_event.dart';
import 'package:tcc/ui/features/backoffice/list_user_documents/list_user_documents_controller.dart';
import 'package:tcc/ui/features/backoffice/list_user_documents/widgets/list_documents_widget.dart';
import 'package:tcc/ui/widgets/app_bars/app_bar_simple_widget.dart';
import 'package:tcc/ui/widgets/buttons/elevated_button_widget.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';
import 'package:tcc/ui/widgets/loading_and_alert_overlay_widget.dart';

class ListUserDocumentsView extends StatefulWidget {
  final String userId;
  final String? testatorCpf;
  final String? testatorId;
  final String? testatorName;

  const ListUserDocumentsView({
    super.key,
    required this.userId,
    this.testatorCpf,
    this.testatorId,
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
        testatorId: widget.testatorId,
        from:
            widget.testatorId != null
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
                ListDocumentsWidget(
                  decisions: _controller.decisions,
                  listDocuments: _controller.listDocuments,
                  openPdf: (String pdf) {
                    _controller.openPdf(pdf);
                  },
                  approve: (bool value, String docId) {
                    setState(() {
                      _controller.decisions[docId] = value;
                    });
                  },
                  focusNodes: _controller.focusNodes,
                  reasonControllers: _controller.reasonControllers,
                ),
              ],
            ),
            bottomSheet: ElevatedButtonWidget(
              onTap: () => onSubmitted(context),
              text: "Enviar",
            ),
          ),
        );
      },
    );
  }

  void onSubmitted(BuildContext context) async {
    for (int index = 0; index < _controller.listDocuments.length; index++) {
      final doc = _controller.listDocuments[index];
      final docId = doc.id;
      if (doc.reviewStatus != ReviewStatusDocument.pending) {
        continue;
      }
      if (_controller.reasonControllers[index].text.isEmpty &&
          docId != null &&
          _controller.decisions[docId] == false) {
        AlertHelper.showAlertSnackBar(
          context: context,
          alertData: AlertData(
            message: 'Preencha o motivo da reprova',
            errorType: ErrorType.warning,
          ),
        );
        return;
      }

      if (docId == null || _controller.decisions[docId] == null) {
        AlertHelper.showAlertSnackBar(
          context: context,
          alertData: AlertData(
            message: 'Selecione as opções de aprovação ou reprovação',
            errorType: ErrorType.warning,
          ),
        );
        return;
      }
    }
    for (int index = 0; index < _controller.listDocuments.length; index++) {
      final doc = _controller.listDocuments[index];
      if (doc.reviewStatus != ReviewStatusDocument.pending) {
        continue;
      }
      doc.reviewMessage = _controller.reasonControllers[index].text;
      // await _controller.submit(documents: doc);
    }

    bool hasInvalidDocuments = false;

    for (int index = 0; index < _controller.listDocuments.length; index++) {
      final doc = _controller.listDocuments[index];
      final docId = doc.id;
      if (doc.reviewStatus != ReviewStatusDocument.pending) {
        continue;
      }
      if (docId != null && _controller.decisions[docId] == false) {
        hasInvalidDocuments = true;
        break;
      }
    }

    if ((_controller.currentTestatorId ?? '').isNotEmpty) {
      await _controller.updateInheritanceStatus(
        context: context,
        hasInvalidDocuments: false, //hasInvalidDocuments,
        requesterId: widget.userId,
        cpfTestator: _controller.currentTestatorId!,
      );
    } else {
      await _controller.updateKycStatus(
        hasInvalidDocument: hasInvalidDocuments,
        userId: widget.userId,
      );
    }

    await AlertHelper.showAlertSnackBar(
      context: context,
      alertData: AlertData(
        message:
            hasInvalidDocuments
                ? 'Análise concluída: existem documentos reprovados.'
                : 'Documentos aprovados com sucesso!',
        errorType: ErrorType.success,
      ),
    );
    eventBus.fire(UpdateUsersEvent());
    context.pop();
  }
}
