import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tcc/core/models/user_document.dart';
import 'package:tcc/ui/features/backoffice/list_user_documents/list_user_documents_controller.dart';

class ListUserDocumentsView extends StatefulWidget {
  final String userId;
  const ListUserDocumentsView({super.key, required this.userId});

  @override
  State<ListUserDocumentsView> createState() => _ListUserDocumentsViewState();
}

class _ListUserDocumentsViewState extends State<ListUserDocumentsView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ListUserDocumentsController _controller = GetIt.I.get<ListUserDocumentsController>();

  final Map<String, bool?> _decisions = {};
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
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
    return Scaffold(
      appBar: AppBar(title: const Text('Documentos do usuário')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _controller.listDocuments.length,
              itemBuilder: (context, index) {
                final doc = _controller.listDocuments[index];
                final selected = _decisions[doc.id];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.description),
                          title: Text(doc.typeDocument.name),
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
                                    _decisions[doc.id!] = value;
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
                                    _decisions[doc.id!] = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Campo de texto para o motivo da reprovação
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _reasonController,
                  decoration: const InputDecoration(
                    labelText: 'Motivo da reprovação',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Validação: se houve reprovação, é necessário informar o motivo
                      final hasRejection = _decisions.values.any((v) => v == false);
                      if (hasRejection && _reasonController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Informe o motivo da reprovação.')),
                        );
                        return;
                      }
                      // TODO: Persista cada decisão via seu repositório e feche a tela
                      // Percorra _decisions para identificar status e use o motivo quando houver reprovação.
                    },
                    child: const Text('Enviar'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}