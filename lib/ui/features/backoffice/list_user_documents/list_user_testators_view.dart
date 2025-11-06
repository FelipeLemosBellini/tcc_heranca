import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/routers/routers.dart';
import 'package:tcc/ui/features/backoffice/list_user_documents/list_user_testators_controller.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/widgets/app_bars/app_bar_simple_widget.dart';
import 'package:tcc/ui/widgets/loading_and_alert_overlay_widget.dart';

class ListUserTestatorsView extends StatefulWidget {
  final String requesterId;
  final String? requesterName;

  const ListUserTestatorsView({
    super.key,
    required this.requesterId,
    this.requesterName,
  });

  @override
  State<ListUserTestatorsView> createState() => _ListUserTestatorsViewState();
}

class _ListUserTestatorsViewState extends State<ListUserTestatorsView> {
  final ListUserTestatorsController _controller =
      GetIt.I.get<ListUserTestatorsController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadTestators(requesterId: widget.requesterId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.requesterName ?? 'Processos de herança';

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        return LoadingAndAlertOverlayWidget(
          isLoading: _controller.isLoading,
          alertData: _controller.alertData,
          child: Scaffold(
            appBar: AppBarSimpleWidget(
              title: title,
              onTap: () => context.pop(),
            ),
            body: ListView(
              children: [
                GestureDetector(
                  onTap: () {
                    context.push(
                      RouterApp.listDocuments,
                      extra: {
                        'userId': widget.requesterId,
                      },
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 24, right: 24, top: 24),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const ListTile(
                      iconColor: Colors.white,
                      leading: Icon(Icons.person_outline),
                      title: Text(
                        'Documentos do solicitante',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'Inclui KYC e outros documentos do usuário.',
                        style: TextStyle(color: Colors.white70),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                if (_controller.testators.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Text('Nenhum processo de herança pendente.'),
                  )
                else
                  ..._controller.testators.map(
                    (testator) {
                      return GestureDetector(
                        onTap: () {
                          context.push(
                      RouterApp.listDocuments,
                      extra: {
                        'userId': widget.requesterId,
                        'testatorId': testator.userId,
                        'testatorCpf': testator.cpf,
                        'testatorName': testator.name,
                      },
                    );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                            left: 24,
                            right: 24,
                            top: 12,
                          ),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            iconColor: Colors.white,
                            leading: const Icon(Icons.assignment_ind_outlined),
                            title: Text(
                              testator.name.toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              'CPF: ${testator.cpf}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
