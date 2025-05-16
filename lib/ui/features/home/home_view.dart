import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/routers/routers.dart';
import 'package:tcc/ui/features/heir/heir_view.dart';
import 'package:tcc/ui/features/home/home_controller.dart';
import 'package:tcc/ui/features/home/wallet/wallet_view.dart';
import 'package:tcc/ui/features/home/widgets/drawer/drawer_home_widget.dart';
import 'package:tcc/ui/features/testament/widgets/flow_testament_enum.dart';
import 'package:tcc/ui/features/testator/testator/testator_view.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/widgets/app_bars/app_bar_drawer_widget.dart';
import 'package:tcc/ui/widgets/bottom_navigation/bottom_navigation_bar_home_widget.dart';
import 'package:tcc/ui/widgets/loading_and_alert_overlay_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeController homeController = GetIt.I.get<HomeController>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  final List<Widget> _screens = [const WalletView(), const TestatorView(), const HeirView()];

  final List<String> _titles = ['Carteira', 'Meus testamentos', 'Heranças'];

  late PageController _pageController;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void initState() {
    homeController.addListener(_onLoadingChanged);
    _pageController = PageController(initialPage: _selectedIndex, keepPage: true);
    super.initState();
  }

  @override
  void dispose() {
    homeController.removeListener(_onLoadingChanged);
    super.dispose();
  }

  void _onLoadingChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingAndAlertOverlayWidget(
      isLoading: homeController.isLoading,
      alertData: homeController.alertData,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBarDrawerWidget(
          title: _titles[_selectedIndex],
          openDrawer: () {
            scaffoldKey.currentState?.openDrawer();
          },
        ),
        drawer: DrawerHomeWidget(
          openAboutUs: () => context.go(RouterApp.aboutUs),
          isHome: true,
          signOut: () {
            homeController.signOut();
            context.go(RouterApp.login);
          },
        ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBarHomeWidget(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
        floatingActionButton:
            _selectedIndex == 1
                ? FloatingActionButton(
                  onPressed: () {
                    context.push(RouterApp.planStep, extra: FlowTestamentEnum.creation);
                  },
                  backgroundColor: AppColors.primaryLight2,
                  child: Icon(Icons.add_sharp, color: AppColors.primary),
                )
                : null,
        floatingActionButtonLocation:
            _selectedIndex == 1 ? FloatingActionButtonLocation.endFloat : null,
      ),
    );
  }
}
