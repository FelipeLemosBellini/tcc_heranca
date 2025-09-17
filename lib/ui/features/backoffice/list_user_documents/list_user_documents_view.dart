import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/models/user_document.dart';
import 'package:tcc/ui/features/backoffice/list_user_documents/list_user_documents_controller.dart';
import 'package:tcc/ui/widgets/app_bars/app_bar_simple_widget.dart';
import 'package:tcc/ui/widgets/buttons/elevated_button_widget.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';
import 'package:tcc/ui/widgets/text_field_widget.dart';

class ListUserDocumentsView extends StatefulWidget {
  final String userId;

  const ListUserDocumentsView({super.key, required this.userId});

  @override
  State<ListUserDocumentsView> createState() => _ListUserDocumentsViewState();
}

class _ListUserDocumentsViewState extends State<ListUserDocumentsView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ListUserDocumentsController _controller =
      GetIt.I.get<ListUserDocumentsController>();

  @override
  void dispose() {
    super.dispose();
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _controller.getDocumentsByUserId(userId: widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBarSimpleWidget(
            title: 'Usuários Pendentes',
            onTap: () {
              context.pop();
            },
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: _controller.listDocuments.length,
                itemBuilder: (context, index) {
                  final doc = _controller.listDocuments[index];
                  final selected = _controller.decisions[doc.idDocument];
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.description),
                                  const SizedBox(width: 8),
                                  Text(doc.typeDocument.Name),
                                  const Spacer(),
                                  Icon(Icons.remove_red_eye),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile<bool>(
                                      title: const Text('Aprovar'),
                                      value: true,
                                      groupValue: selected,
                                      onChanged: (value) {
                                        setState(() {
                                          _controller.decisions[doc
                                                  .idDocument!] =
                                              value;
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
                                          _controller.decisions[doc
                                                  .idDocument!] =
                                              value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: selected == false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          child: TextFieldWidget(
                            controller: _controller.reasonControllers[index],
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
            ],
          ),
          bottomSheet: ElevatedButtonWidget(
            onTap: () {
              for (
                int index = 0;
                index < _controller.listDocuments.length;
                index++
              ) {
                if (_controller.reasonControllers[index].text.isEmpty &&
                    _controller.decisions[_controller
                            .listDocuments[index]
                            .idDocument] ==
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

                if (_controller.decisions[_controller
                        .listDocuments[index]
                        .idDocument] ==
                    null) {
                  AlertHelper.showAlertSnackBar(
                    context: context,
                    alertData: AlertData(
                      message: 'Selecione as opções de aprovação ou reprovação',
                      errorType: ErrorType.warning,
                    ),
                  );
                  return;
                }

                _controller.submit(
                  documents: _controller.listDocuments,
                  reason: _controller.reasonControllers[index].text,
                );

                AlertHelper.showAlertSnackBar(
                  context: context,
                  alertData: AlertData(
                    message: 'Documentos enviados com sucesso',
                    errorType: ErrorType.success,
                  ),
                );
                context.pop();
              }
            },
            text: "Enviar",
          ),
        );
      },
    );
  }
}
