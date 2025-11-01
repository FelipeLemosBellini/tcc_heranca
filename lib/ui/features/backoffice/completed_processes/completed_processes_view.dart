import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/helpers/datetime_extensions.dart';
import 'package:tcc/core/helpers/extensions.dart';
import 'package:tcc/core/routers/routers.dart';
import 'package:tcc/ui/features/backoffice/completed_processes/completed_processes_controller.dart';
import 'package:tcc/ui/features/backoffice/list_users/widgets/drawer_list_users_widget.dart';
import 'package:tcc/ui/features/testament/widgets/enum_type_user.dart';
import 'package:tcc/ui/widgets/app_bars/app_bar_drawer_widget.dart';
import 'package:tcc/ui/widgets/loading_and_alert_overlay_widget.dart';

class CompletedProcessesView extends StatefulWidget {
  const CompletedProcessesView({super.key});

  @override
  State<CompletedProcessesView> createState() => _CompletedProcessesViewState();
}

class _CompletedProcessesViewState extends State<CompletedProcessesView> {
  final CompletedProcessesController _controller =
      GetIt.I.get<CompletedProcessesController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadCompleted();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        return LoadingAndAlertOverlayWidget(
          isLoading: _controller.isLoading,
          alertData: _controller.alertData,
          child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBarDrawerWidget(
              title: 'Processos finalizados',
              openDrawer: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            drawer: DrawerListUsersWidget(
              goToPending: () {
                _scaffoldKey.currentState?.closeDrawer();
                context.go(RouterApp.listUsers);
              },
              goToCompleted: () {
                _scaffoldKey.currentState?.closeDrawer();
              },
              signOut: () {
                context.go(RouterApp.login);
              },
            ),
            body: Padding(
              padding: const EdgeInsets.all(24),
              child: _controller.processes.isEmpty
                  ? const Center(
                      child: Text('Nenhum processo finalizado encontrado.'),
                    )
                  : ListView.builder(
                      itemCount: _controller.processes.length,
                      itemBuilder: (context, index) {
                        final process = _controller.processes[index];
                        final responsibleName =
                            _controller.responsibleNameOf(process.requestById);
                        return Container(
                          margin: EdgeInsets.only(bottom: index == _controller.processes.length - 1 ? 32 : 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                process.name ?? 'Testador não informado',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text('CPF: ${process.cpf?.formatCpf() ?? '---'}'),
                              const SizedBox(height: 4),
                              Text('Responsável: $responsibleName'),
                              const SizedBox(height: 4),
                              Text('Finalizado em: ${process.updatedAt?.formatDateWithHour() ?? '---'}'),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  onPressed: () {
                                    context.push(
                                      RouterApp.seeDetailsInheritance,
                                      extra: {
                                        'testament': process,
                                        'typeUser': EnumTypeUser.admin,
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.visibility_outlined),
                                  label: const Text('Ver detalhes'),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
        );
      },
    );
  }
}
