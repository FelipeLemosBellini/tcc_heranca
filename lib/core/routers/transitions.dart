import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class Transitions {
  static CustomTransitionPage<dynamic> customTransitionPage(Widget child, GoRouterState state) {
    return CustomTransitionPage(
      key: ValueKey(state.uri.path), // Usa a rota atual como chave única
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Detecta se está avançando ou voltando
        bool isPushing = state.fullPath == state.uri.path;

        return SlideTransition(
          position: animation.drive(
            Tween<Offset>(
              begin: isPushing ? const Offset(1, 0) : const Offset(-1, 0),
              // Direita para esquerda ou esquerda para direita
              end: Offset.zero, // Vai para o centro
            ).chain(CurveTween(curve: Curves.easeInOut)), // Suaviza a animação
          ),
          child: child,
        );
      },
    );
  }
}
