import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tcc/core/routers/routers.dart';
import 'package:tcc/ui/features/home/widgets/drawer/drawer_home_widget.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';
import 'package:tcc/ui/widgets/app_bars/app_bar_drawer_widget.dart';
import 'package:tcc/ui/widgets/app_bars/app_bar_simple_widget.dart';

class AboutUsView extends StatefulWidget {
  const AboutUsView({super.key});

  @override
  State<AboutUsView> createState() => _AboutUsViewState();
}

class _AboutUsViewState extends State<AboutUsView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBarDrawerWidget(
        title: "Sobre",
        openDrawer: () {
          scaffoldKey.currentState?.openDrawer();
        },
      ),
      drawer: DrawerHomeWidget(
        isAboutUs: true,
        openHome: () {
          context.go(RouterApp.home);
        },
        signOut: () {
          context.go(RouterApp.home);
        },
      ),
      body: ListView(
        padding: EdgeInsets.all(24),
        children: [
          Text("Alunos", style: AppFonts.bodyMediumBold),
          SizedBox(height: 16),
          Text(
            "Felipe Lemos Bellini - 838207\nRafael Camillo Jorge - 838625",
            style: AppFonts.bodyMediumMedium,
          ),
          SizedBox(height: 16),Text(
            "Sobre o App",
            style: AppFonts.bodyMediumBold,
          ),
          SizedBox(height: 16),
          Text(
            """O Sistema de Herança Descentralizada é uma solução voltada para usuários de criptomoedas que desejam garantir a transferência de seus ativos digitais após sua morte, de forma segura, confiável e sem depender de intermediários centralizados.
              A aplicação permite que o usuário (testador) registre um contrato inteligente de herança, definindo um ou mais beneficiários e os ativos que serão herdados. 
              O contrato exige uma prova periódica de vida, baseada em uma assinatura digital do testador. Caso essa assinatura não seja renovada dentro de um período determinado, o sistema entra automaticamente em estado de verificação e permite que os herdeiros iniciem o processo de solicitação da herança.""",
            textAlign: TextAlign.start,
            style: AppFonts.bodyMediumMedium,

          ),
        ],
      ),
    );
  }
}
