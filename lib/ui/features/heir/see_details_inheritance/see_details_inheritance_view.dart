import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/enum/heir_status.dart';
import 'package:tcc/core/helpers/datetime_extensions.dart';
import 'package:tcc/core/helpers/extensions.dart';
import 'package:tcc/core/models/request_inheritance_model.dart';
import 'package:tcc/ui/features/testament/widgets/enum_type_user.dart';
import 'package:tcc/ui/widgets/app_bars/app_bar_simple_widget.dart';

class SeeDetailsInheritanceView extends StatelessWidget {
  final RequestInheritanceModel testament;
  final EnumTypeUser typeUser;

  const SeeDetailsInheritanceView({
    super.key,
    required this.testament,
    required this.typeUser,
  });

  @override
  Widget build(BuildContext context) {
    final status = testament.heirStatus ?? HeirStatus.consultaSaldoSolicitado;
    final createdAt = testament.createdAt?.formatDateWithHour() ?? '---';
    final updatedAt = testament.updatedAt?.formatDateWithHour();
    final cpf = testament.cpf?.formatCpf() ?? '---';
    final rg = testament.rg ?? '---';

    return Scaffold(
      appBar: AppBarSimpleWidget(
        title: 'Detalhes da herança',
        onTap: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailRow(label: 'Testador', value: testament.name ?? 'Não informado'),
            const SizedBox(height: 12),
            _DetailRow(label: 'CPF', value: cpf),
            const SizedBox(height: 12),
            _DetailRow(label: 'RG', value: rg),
            const SizedBox(height: 12),
            _DetailRow(label: 'Solicitado em', value: createdAt),
            if (updatedAt != null) ...[
              const SizedBox(height: 12),
              _DetailRow(label: 'Última atualização', value: updatedAt),
            ],
            const SizedBox(height: 24),
            _StatusBanner(status: status),
            const SizedBox(height: 24),
            Text(
              _statusMessage(status),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  String _statusMessage(HeirStatus status) {
    final isHeir = typeUser == EnumTypeUser.heir;
    switch (status) {
      case HeirStatus.consultaSaldoSolicitado:
        return 'A solicitação está aguardando análise do backoffice. Assim que for avaliada, você será notificado.';
      case HeirStatus.consultaSaldoAprovado:
        return isHeir
            ? 'A consulta de saldo foi aprovada. Reúna os documentos complementares e envie a solicitação de transferência.'
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
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelMedium),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final HeirStatus status;

  const _StatusBanner({required this.status});

  @override
  Widget build(BuildContext context) {
    Color background;
    Color foreground;
    switch (status) {
      case HeirStatus.consultaSaldoAprovado:
      case HeirStatus.transferenciaSaldoRealizada:
        background = Colors.green.withOpacity(0.15);
        foreground = Colors.green.shade800;
        break;
      case HeirStatus.consultaSaldoRecusado:
      case HeirStatus.transferenciaSaldoRecusado:
        background = Colors.red.withOpacity(0.15);
        foreground = Colors.red.shade700;
        break;
      case HeirStatus.consultaSaldoSolicitado:
      case HeirStatus.transferenciaSaldoSolicitado:
      default:
        background = Colors.orange.withOpacity(0.15);
        foreground = Colors.orange.shade800;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: foreground),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              status.label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: foreground, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
