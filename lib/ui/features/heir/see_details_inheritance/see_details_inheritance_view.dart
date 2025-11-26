import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/enum/heir_status.dart';
import 'package:tcc/core/enum/review_status_document.dart';
import 'package:tcc/core/helpers/datetime_extensions.dart';
import 'package:tcc/core/helpers/extensions.dart';
import 'package:tcc/core/models/document.dart';
import 'package:tcc/core/models/request_inheritance_model.dart';
import 'package:tcc/core/routers/routers.dart';
import 'package:tcc/ui/features/heir/see_details_inheritance/see_details_inheritance_controller.dart';
import 'package:tcc/ui/features/heir/see_details_inheritance/widgets/details_row_widget.dart';
import 'package:tcc/ui/features/heir/see_details_inheritance/widgets/status_banner_widget.dart';
import 'package:tcc/ui/features/testament/widgets/enum_type_user.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';
import 'package:tcc/ui/widgets/app_bars/app_bar_simple_widget.dart';
import 'package:tcc/ui/widgets/buttons/elevated_button_widget.dart';
import 'package:tcc/ui/widgets/loading_and_alert_overlay_widget.dart';

class SeeDetailsInheritanceView extends StatefulWidget {
  final RequestInheritanceModel testament;
  final EnumTypeUser typeUser;

  const SeeDetailsInheritanceView({
    super.key,
    required this.testament,
    required this.typeUser,
  });

  @override
  State<SeeDetailsInheritanceView> createState() =>
      _SeeDetailsInheritanceViewState();
}

class _SeeDetailsInheritanceViewState extends State<SeeDetailsInheritanceView> {
  final SeeDetailsInheritanceController _controller =
      GetIt.I.get<SeeDetailsInheritanceController>();

  Future<void> _reloadDocuments() async {
    final requesterId = widget.testament.requestById ?? '';
    final testatorId = widget.testament.testatorId ?? '';
    if (requesterId.isEmpty || testatorId.isEmpty) return;
    await _controller.loadDocuments(
      requesterId: requesterId,
      testatorId: testatorId,
    );
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _reloadDocuments();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status =
        widget.testament.heirStatus ?? HeirStatus.consultaSaldoSolicitado;
    final createdAt = widget.testament.createdAt?.formatDateWithHour() ?? '---';
    final updatedAt = widget.testament.updatedAt?.formatDateWithHour();
    final cpf = widget.testament.cpf?.formatCpf() ?? '---';
    final rg = widget.testament.rg ?? '---';

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return LoadingAndAlertOverlayWidget(
          isLoading: _controller.isLoading,
          alertData: _controller.alertData,
          child: Scaffold(
            appBar: AppBarSimpleWidget(
              title: 'Detalhes da herança',
              onTap: () => context.pop(),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailRow(
                    label: 'Testador',
                    value: widget.testament.name ?? 'Não informado',
                  ),
                  const SizedBox(height: 12),
                  DetailRow(label: 'CPF', value: cpf),
                  const SizedBox(height: 12),
                  DetailRow(label: 'RG', value: rg),
                  const SizedBox(height: 12),
                  DetailRow(label: 'Solicitado em', value: createdAt),
                  if (updatedAt != null) ...[
                    const SizedBox(height: 12),
                    DetailRow(label: 'Última atualização', value: updatedAt),
                  ],
                  const SizedBox(height: 24),
                  StatusBanner(status: status),
                  const SizedBox(height: 24),
                  Text(
                    _statusMessage(status, widget.typeUser),
                    style: AppFonts.labelSmallMedium,
                  ),
                  if (widget.typeUser == EnumTypeUser.heir) ...[
                    if (status == HeirStatus.consultaSaldoAprovado) ...[
                      const SizedBox(height: 24),
                      ElevatedButtonWidget(
                        text: 'Enviar documentos da herança',
                        isBig: true,
                        onTap: () async {
                          final result = await context.push(
                            RouterApp.requestInheritance,
                            extra: widget.testament,
                          );
                          if (result == true) {
                            await _reloadDocuments();
                          }
                        },
                      ),
                    ],
                    if (status == HeirStatus.consultaSaldoRecusado) ...[
                      const SizedBox(height: 24),
                      ElevatedButtonWidget(
                        text: 'Corrigir documentos da consulta de saldo',
                        isBig: true,
                        onTap: () async {
                          final result = await context.push(
                            RouterApp.requestVault,
                            extra: widget.testament,
                          );
                          if (result == true) {
                            await _reloadDocuments();
                          }
                        },
                      ),
                    ],
                    if (status == HeirStatus.transferenciaSaldoRecusado) ...[
                      const SizedBox(height: 24),
                      ElevatedButtonWidget(
                        text: 'Reenviar documentos da transferência',
                        isBig: true,
                        onTap: () async {
                          final result = await context.push(
                            RouterApp.requestInheritance,
                            extra: widget.testament,
                          );
                          if (result == true) {
                            await _reloadDocuments();
                          }
                        },
                      ),
                    ],
                  ],
                  const SizedBox(height: 32),
                  Text(
                    'Documentos do processo',
                    style: AppFonts.bodySmallMedium,
                  ),
                  const SizedBox(height: 12),
                  if (_controller.documents.isEmpty)
                    Text(
                      'Nenhum documento disponível.',
                      style: AppFonts.bodyMediumMedium,
                    )
                  else
                    ..._controller.documents.map(_buildDocumentTile),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _statusMessage(HeirStatus status, EnumTypeUser typeUser) {
    final isHeir = typeUser == EnumTypeUser.heir;
    switch (status) {
      case HeirStatus.consultaSaldoSolicitado:
        return 'A solicitação está aguardando análise do backoffice. Assim que for avaliada, você será notificado.';
      case HeirStatus.consultaSaldoAprovado:
        return isHeir
            ? 'A consulta de saldo foi aprovada. Reúna os documentos complementares e envie a solicitação de transferência. Verifique seu email, enviamos o saldo do testador para você.'
            : 'Consulta de saldo aprovada. Oriente o solicitante a enviar os documentos complementares.';
      case HeirStatus.consultaSaldoRecusado:
        return 'A consulta de saldo foi recusada. Verifique os documentos enviados e envie uma nova solicitação se necessário.';
      case HeirStatus.transferenciaSaldoSolicitado:
        return 'Os documentos da transferência foram enviados e aguardam revisão do backoffice.';
      case HeirStatus.transferenciaSaldoRealizada:
        return isHeir
            ? 'Processo finalizado! A equipe do backoffice aprovou a transferência dos ativos.'
            : 'Processo finalizado! O backoffice aprovou a transferência.';
      case HeirStatus.transferenciaSaldoRecusado:
        return 'A transferência foi recusada. Consulte o motivo com o backoffice e ajuste os documentos para reenviar.';
    }
  }

  Widget _buildDocumentTile(Document document) {
    final status = document.reviewStatus;
    final theme = Theme.of(context);
    final statusData = _statusChipData(status);
    final uploadedAt = document.uploadedAt.formatDateWithHour();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  document.typeDocument.Name,
                  style: AppFonts.bodySmallLight,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusData.background,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusData.label,
                  style: AppFonts.bodySmallLight.copyWith(
                    color: statusData.foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Enviado em $uploadedAt', style: AppFonts.bodySmallLight),
          if (document.reviewStatus == ReviewStatusDocument.invalid &&
              (document.reviewMessage?.isNotEmpty ?? false)) ...[
            const SizedBox(height: 8),
            Text(
              'Motivo da reprovação: ${document.reviewMessage}',
              style: AppFonts.bodySmallLight.copyWith(
                color: Colors.red.shade400,
              ),
            ),
          ],
          if (document.pathStorage != null && document.pathStorage!.isNotEmpty)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _controller.openDocument(document),
                icon: const Icon(Icons.open_in_new),
                label: Text('Abrir documento', style: AppFonts.bodySmallLight),
              ),
            ),
        ],
      ),
    );
  }

  _StatusChipData _statusChipData(ReviewStatusDocument status) {
    switch (status) {
      case ReviewStatusDocument.approved:
        return _StatusChipData(
          label: 'Aprovado',
          background: Colors.green.withOpacity(0.15),
          foreground: Colors.green.shade700,
        );
      case ReviewStatusDocument.invalid:
        return _StatusChipData(
          label: 'Recusado',
          background: Colors.red.withOpacity(0.15),
          foreground: Colors.red.shade700,
        );
      case ReviewStatusDocument.pending:
        return _StatusChipData(
          label: 'Pendente',
          background: Colors.orange.withOpacity(0.15),
          foreground: Colors.orange.shade800,
        );
    }
  }
}

class _StatusChipData {
  final String label;
  final Color background;
  final Color foreground;

  _StatusChipData({
    required this.label,
    required this.background,
    required this.foreground,
  });
}
