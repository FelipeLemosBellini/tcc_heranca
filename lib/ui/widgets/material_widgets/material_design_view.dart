import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/ui/widgets/app_bars/app_bar_drawer_widget.dart';
import 'package:tcc/ui/widgets/app_bars/app_bar_simple_widget.dart';
import 'package:tcc/ui/widgets/bottom_navigation/bottom_navigation_bar_home_widget.dart';
import 'package:tcc/ui/widgets/buttons/button_icon_widget.dart';
import 'package:tcc/ui/widgets/buttons/elevated_button_thematic_widget.dart';
import 'package:tcc/ui/widgets/buttons/elevated_button_widget.dart';
import 'package:tcc/ui/widgets/buttons/pill_button_widget.dart';
import 'package:tcc/ui/widgets/loading_and_alert_overlay_widget.dart';
import 'package:tcc/ui/widgets/material_widgets/material_design_controller.dart';
import 'package:tcc/ui/widgets/text_field_widget.dart';

class MaterialDesignView extends StatefulWidget {
  const MaterialDesignView({super.key});

  @override
  State<MaterialDesignView> createState() => _MaterialDesignViewState();
}

class _MaterialDesignViewState extends State<MaterialDesignView> {
  MaterialDesignController controller = GetIt.I.get<MaterialDesignController>();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return LoadingAndAlertOverlayWidget(
          isLoading: controller.isLoading,
          alertData: controller.alertData,
          child: Scaffold(
            appBar: AppBarSimpleWidget(
              onTap: () {
                context.pop();
              },
              title: "Title app bar",
            ),
            body: ListView(
              shrinkWrap: true,
              children: [
                SizedBox(
                  height: 64,
                  child: AppBarDrawerWidget(
                    title: "title",
                    openDrawer: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                SizedBox(height: 16),
                TextFieldWidget(
                  hintText: "Password",
                  controller: TextEditingController(),
                  focusNode: FocusNode(),
                  obscureText: true,
                  padding: EdgeInsets.symmetric(horizontal: 24),
                ),
                SizedBox(height: 24),
                TextFieldWidget(
                  hintText: "Email",
                  controller: TextEditingController(),
                  focusNode: FocusNode(),
                  padding: EdgeInsets.symmetric(horizontal: 24),
                ),
                SizedBox(height: 24),
                PillButtonWidget(onTap: () {}, text: "Pill button"),
                SizedBox(height: 8),
                PillButtonWidget(onTap: controller.loading, text: "Loading"),
                SizedBox(height: 8),
                PillButtonWidget(onTap: controller.showError, text: "Show Error"),
                SizedBox(height: 8),
                PillButtonWidget(onTap: controller.showWarning, text: "Show Warning"),
                SizedBox(height: 8),
                PillButtonWidget(onTap: controller.showSuccess, text: "Show Success"),

                Row(
                  children: [
                    SizedBox(height: 8),
                    ButtonIconWidget(onTap: () {}, actionButtonEnum: ActionButtonEnum.delete),
                    SizedBox(height: 8),
                    ButtonIconWidget(onTap: () {}, actionButtonEnum: ActionButtonEnum.send),
                    SizedBox(height: 8),
                    ButtonIconWidget(onTap: () {}, actionButtonEnum: ActionButtonEnum.edit),
                  ],
                ),
                SizedBox(height: 8),
                ElevatedButtonWidget(text: "Elevated button", onTap: () {}),
                SizedBox(height: 8),
                ElevatedButtonWidget(
                  text: "Elevated button inverted",
                  onTap: () {},
                  inverterColor: true,
                  padding: EdgeInsets.zero,
                ),
                SizedBox(height: 8),
                ElevatedButtonThematicWidget(
                  text: "text",
                  onTap: () {},
                  thematicEnum: ThematicButtonEnum.blue,
                  padding: EdgeInsets.zero,
                ),
                SizedBox(height: 8),
                ElevatedButtonThematicWidget(
                  text: "text",
                  onTap: () {},
                  thematicEnum: ThematicButtonEnum.red,
                  padding: EdgeInsets.zero,
                ),
                SizedBox(height: 8),
                ElevatedButtonThematicWidget(
                  text: "text",
                  onTap: () {},
                  thematicEnum: ThematicButtonEnum.green,
                  padding: EdgeInsets.zero,
                ),
                SizedBox(height: 8),
              ],
            ),
            bottomNavigationBar: BottomNavigationBarHomeWidget(
              selectedIndex: 0,
              onItemTapped: (_) {},
            ),
          ),
        );
      },
    );
  }
}
