import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';

import 'package:tcc/ui/widgets/app_bars/app_bar_simple_widget.dart';
import 'package:tcc/ui/widgets/buttons/elevated_button_widget.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';
import 'package:tcc/ui/widgets/loading_and_alert_overlay_widget.dart';
import 'package:tcc/ui/widgets/text_field_widget.dart';
import 'package:tcc/ui/features/auth/kyc/kyc_controller.dart';

class KycView extends StatefulWidget {
  const KycView({super.key});

  @override
  State<KycView> createState() => _KycViewState();
}

class _KycViewState extends State<KycView> {
  final KycController controller = GetIt.I.get<KycController>();
  // Controllers
  final cpfController = TextEditingController();
  final rgController  = TextEditingController();

  // FocusNodes
  final cpfFocus = FocusNode();
  final rgFocus  = FocusNode();

  @override
  void dispose() {
    cpfController.dispose();
    rgController.dispose();
    cpfFocus.dispose();
    rgFocus.dispose();
    super.dispose();
  }

  String _digitsOnly(String s) => s.replaceAll(RegExp(r'[^0-9]'), '');

  bool _isValidCpf(String raw) {
    final cpf = _digitsOnly(raw);
    if (cpf.length != 11) return false;
    if (RegExp(r'^(\d)\1{10}$').hasMatch(cpf)) return false;

    // 1º dígito
    var sum = 0;
    for (var i = 0; i < 9; i++) {
      sum += int.parse(cpf[i]) * (10 - i);
    }
    var rem = (sum * 10) % 11;
    if (rem == 10) rem = 0;
    if (rem != int.parse(cpf[9])) return false;

    // 2º dígito
    sum = 0;
    for (var i = 0; i < 10; i++) {
      sum += int.parse(cpf[i]) * (11 - i);
    }
    rem = (sum * 10) % 11;
    if (rem == 10) rem = 0;
    if (rem != int.parse(cpf[10])) return false;

    return true;
  }

  Future<void> _onSubmit() async {
    await controller.submit(
      cpf: cpfController.text,
      rg: rgController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return LoadingAndAlertOverlayWidget(
          isLoading: controller.isLoading,
          alertData: controller.alertData,
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBarSimpleWidget(
              title: 'Criar Conta',
              onTap: () => context.pop(),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _HeaderBanner(),
                    const SizedBox(height: 16),

                    // Dados
                    _SectionCard(
                      title: 'Dados',
                      subtitle: 'Preencha seus dados básicos. Campos mínimos para validação.',
                      icon: Icons.person_outline,
                      children: [
                        TextFieldWidget(
                          hintText: 'CPF (somente números)',
                          controller: cpfController,
                          keyboardType: TextInputType.number,
                          focusNode: cpfFocus,
                        ),
                        const SizedBox(height: 16),
                        TextFieldWidget(
                          hintText: 'Número do RG',
                          controller: rgController,
                          focusNode: rgFocus,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Anexos
                    _SectionCard(
                      title: 'Anexos',
                      icon: Icons.attach_file_outlined,
                      children: const [
                        _UploadTileSimple(label: 'Documento de identidade (frente/verso)'),
                        SizedBox(height: 12),
                        _UploadTileSimple(label: 'Comprovante de residência'),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButtonWidget(
                            text: 'Enviar',
                            onTap: _onSubmit,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HeaderBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.primaryContainer,
            scheme.secondaryContainer.withOpacity(.92),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_user_outlined, size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Informe CPF e RG, e anexe a frente/verso do documento e o comprovante de residência.',
              style: TextStyle(
                color: scheme.onPrimaryContainer,
                fontSize: 14,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.children,
    this.subtitle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: scheme.primary),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                style: TextStyle(
                  color: scheme.onSurfaceVariant,
                  fontSize: 12.5,
                  height: 1.25,
                ),
              ),
            ],
            const SizedBox(height: 14),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _UploadTileSimple extends StatelessWidget {
  final String label;

  const _UploadTileSimple({required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Widget _action(String text, VoidCallback onTap) {
      return ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 180, maxWidth: 280, minHeight: 48),
        child: ElevatedButtonWidget(text: text, onTap: onTap),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 420;
        final previewSize = isCompact ? 68.0 : 84.0;

        final labelText = Text(
          label,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: scheme.onSurface,
          ),
        );

        final preview = _PreviewPlaceholder(size: previewSize);

        final actions = Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: isCompact ? WrapAlignment.start : WrapAlignment.end,
          children: [
            _action('Anexar frente', () {
              AlertHelper.showAlertSnackBar(
                context: context,
                alertData: AlertData(
                  message: 'Anexar frente (layout)',
                  errorType: ErrorType.success,
                ),
              );
            }),
            _action('Anexar verso', () {
              AlertHelper.showAlertSnackBar(
                context: context,
                alertData: AlertData(
                  message: 'Anexar verso (layout)',
                  errorType: ErrorType.success,
                ),
              );
            }),
          ],
        );

        // Linha (tela larga) ou coluna (tela estreita)
        final contentRow = Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            preview,
            const SizedBox(width: 12),
            Expanded(child: labelText),
            const SizedBox(width: 8),
            actions,
          ],
        );

        final contentColumn = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                preview,
                const SizedBox(width: 12),
                Expanded(child: labelText),
              ],
            ),
            const SizedBox(height: 10),
            actions,
          ],
        );

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: scheme.surfaceVariant.withOpacity(.35),
            borderRadius: BorderRadius.circular(14),
          ),
          child: isCompact ? contentColumn : contentRow,
        );
      },
    );
  }
}

class _PreviewPlaceholder extends StatelessWidget {
  final double size;
  const _PreviewPlaceholder({this.size = 84});

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).colorScheme.surfaceVariant.withOpacity(.25);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: size,
        height: size,
        color: bg,
        child: const Icon(Icons.image, size: 32),
      ),
    );
  }
}
