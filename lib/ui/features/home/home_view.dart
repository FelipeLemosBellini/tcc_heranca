import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/routers/routers.dart';
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
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBarHomeWidget(
        title: _titles[_selectedIndex],
        onTap: () {},
        openDrawer: () {
          scaffoldKey.currentState?.openDrawer();
        },
      ),
      drawer: DrawerHomeWidget(),
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
                backgroundColor: AppColors.primary,
                child: Icon(Icons.add, color: AppColors.primaryLight2),
              )
              : null,
      floatingActionButtonLocation:
          _selectedIndex == 1 ? FloatingActionButtonLocation.endFloat : null,
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
