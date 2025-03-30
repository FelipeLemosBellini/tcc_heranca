import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/models/testament_model.dart';
import 'package:tcc/ui/features/testator/see_details/see_details_controller.dart';
import 'package:tcc/ui/widgets/app_bars/app_bar_simple_widget.dart';

class SeeDetailsView extends StatefulWidget {
  final TestamentModel testamentModel;

  const SeeDetailsView({super.key, required this.testamentModel});

  @override
  State<SeeDetailsView> createState() => _SeeDetailsViewState();
}

class _SeeDetailsViewState extends State<SeeDetailsView> {
  SeeDetailsController seeDetailsController = GetIt.instance.get<SeeDetailsController>();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: seeDetailsController,
      builder:
          (context, _) => Scaffold(
            appBar: AppBarSimpleWidget(title: 'Detalhes', onTap: () => context.pop()),
            body: ListView(),
          ),
    );
  }
}
