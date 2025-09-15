import 'package:flutter/material.dart';
import 'package:mensalidade_mts_app/features/associados/presentation/associado_menu.dart';
import 'package:mensalidade_mts_app/features/auth/providers/auth_provider.dart';
import 'package:mensalidade_mts_app/features/auth/presentation/login_page.dart';
import 'package:mensalidade_mts_app/features/tesoureiros/presentation/tesoureiro_menu.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, provider, child) {
        if (provider.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (provider.token == null || provider.user == null) {
          return const LoginPage();
        }

        switch (provider.user!.role) {
          case 'Associado':
            return const MenuAssociado();
          case 'Tesoureiro':
            return const MenuTesoureiro();
          default:
            return const Scaffold(
              body: Center(child: Text('Permissão desconhecida')),
            );
        }
      },
    );
  }
}
