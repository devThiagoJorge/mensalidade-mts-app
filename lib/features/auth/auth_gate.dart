import 'package:flutter/material.dart';
import 'package:mensalidade_mts_app/features/associados/presentation/associado_home_page.dart';
import 'package:mensalidade_mts_app/features/auth/providers/auth_provider.dart';
import 'package:mensalidade_mts_app/features/auth/presentation/login_page.dart';
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
          return LoginPage();
        }

        switch (provider.user!.role) {
          case 'Associado':
            return const AssociadoHomePage();
          case 'Tesoureiro':
            return const Center(child: Text('Permissão Tesoureiro'));
          default:
            return const Scaffold(
              body: Center(child: Text('Permissão desconhecida')),
            );
        }
      },
    );
  }
}
