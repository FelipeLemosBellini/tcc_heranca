import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/models/user_model.dart';
import 'package:tcc/core/routers/routers.dart';
import 'package:tcc/ui/features/backoffice/list_users/list_users_controller.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/widgets/app_bars/app_bar_drawer_widget.dart';

class ListUsersView extends StatefulWidget {
  const ListUsersView({super.key});

  @override
  State<ListUsersView> createState() => _ListUsersViewState();
}

class _ListUsersViewState extends State<ListUsersView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final ListUsersController _controller = GetIt.I.get<ListUsersController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _controller.getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBarDrawerWidget(
        title: 'Usuários Pendentes',
        openDrawer: () {},
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          return ListView.builder(
            itemCount: _controller.listUsers.length,
            itemBuilder: (context, index) {
              final user = _controller.listUsers[index];
              return GestureDetector(
                onTap: () {
                  context.push(
                    RouterApp.listDocuments,
                    extra: {"userId": user.id},
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: index == 0 ? 24 : 12,
                  ),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    iconColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    leading: const Icon(Icons.person),
                    title: Text(
                      user.name.toUpperCase(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
