import 'package:flutter/material.dart';
import 'package:tcc/core/enum/review_status_document.dart';
import 'package:tcc/core/models/document.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';
import 'package:tcc/ui/widgets/text_field_widget.dart';

class ListDocumentsWidget extends StatelessWidget {
  final Function(String) openPdf;
  final List<Document> listDocuments;
  final Map<String, bool?> decisions;
  final Function(bool, String) approve;
  final List<TextEditingController> reasonControllers;
  final List<FocusNode> focusNodes;

  const ListDocumentsWidget({
    super.key,
    required this.openPdf,
    required this.listDocuments,
    required this.decisions,
    required this.approve,
    required this.reasonControllers,
    required this.focusNodes,
  });

  @override
  Widget build(BuildContext context) {
    return listDocuments.isEmpty
        ? Center(
          child: Text(
            'Nenhum documento pendente.',
            style: AppFonts.bodyMediumMedium,
          ),
        )
        : ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 16),
          itemCount: listDocuments.length,
          itemBuilder: (context, index) {
            final doc = listDocuments[index];
            final docId = doc.id;
            final isPending = doc.reviewStatus == ReviewStatusDocument.pending;
            final selected =
                (isPending && docId != null) ? decisions[docId] : null;
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
                            Text(
                              doc.typeDocument.Name,
                              style: AppFonts.bodyMediumLight,
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                if (doc.pathStorage != null) {
                                  openPdf(doc.pathStorage!);
                                }
                              },
                              child: const Icon(Icons.file_open_outlined),
                            ),
                          ],
                        ),
                        if (isPending)
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile<bool>(
                                  title: Text(
                                    'Aprovar',
                                    style: AppFonts.bodySmallLight,
                                  ),
                                  value: true,
                                  groupValue: selected,
                                  onChanged: (value) {
                                    if (value != null && docId != null) {
                                      approve(value, docId);
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<bool>(
                                  title: Text(
                                    'Reprovar',
                                    style: AppFonts.bodySmallLight,
                                  ),
                                  value: false,
                                  groupValue: selected,
                                  onChanged: (value) {
                                    if (value != null && docId != null) {
                                      approve(value, docId);
                                    }
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
                              color:
                                  doc.reviewStatus ==
                                          ReviewStatusDocument.approved
                                      ? Colors.green.withOpacity(0.15)
                                      : Colors.red.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  doc.reviewStatus ==
                                          ReviewStatusDocument.approved
                                      ? Icons.check_circle_outline
                                      : Icons.highlight_off,
                                  color:
                                      doc.reviewStatus ==
                                              ReviewStatusDocument.approved
                                          ? Colors.green.shade700
                                          : Colors.red.shade700,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    doc.reviewStatus ==
                                            ReviewStatusDocument.approved
                                        ? 'Documento aprovado'
                                        : 'Documento recusado',
                                    style: AppFonts.bodySmallMedium,
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
                        controller: reasonControllers[index],
                        maxLines: 3,
                        hintText: 'Motivo da reprovação',
                        focusNode: focusNodes[index],
                      ),
                    ),
                  ),
              ],
            );
          },
        );
  }
}
