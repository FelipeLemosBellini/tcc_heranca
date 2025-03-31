import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/routers/routers.dart';
import 'package:tcc/ui/features/home/home_controller.dart';
import 'package:tcc/ui/features/home/wallet_view/wallet_view.dart';
import 'package:tcc/ui/features/home/widgets/drawer/drawer_home_widget.dart';
import 'package:tcc/ui/features/testator/testator_view.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/widgets/app_bars/app_bar_home_widget.dart';
import 'package:tcc/ui/widgets/bottom_navigation/bottom_navigation_bar_home_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeController homeController = GetIt.I.get<HomeController>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  final List<Widget> _screens = [const WalletView(), const TestatorView(), const HerdeiroScreen()];

  final List<String> _titles = ['Carteira', 'Meus testamentos', 'Heranças'];

  late PageController _pageController;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex, keepPage: true);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: homeController,
      builder: (context, _) {
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBarHomeWidget(
            title: _titles[_selectedIndex],
            onTap: () {},
            openDrawer: () {
              scaffoldKey.currentState?.openDrawer();
            },
          ),
          drawer: DrawerHomeWidget(
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
                      context.push(RouterApp.amountStep);
                    },
                    backgroundColor: AppColors.primaryLight2,
                    child: Icon(Icons.add_sharp, color: AppColors.primary),
                  )
                  : null,
          floatingActionButtonLocation:
              _selectedIndex == 1 ? FloatingActionButtonLocation.endFloat : null,
        );
      },
    );
  }
}

class HerdeiroScreen extends StatelessWidget {
  const HerdeiroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Herdeiro Screen"));
  }
}
