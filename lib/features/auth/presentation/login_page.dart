import 'package:flutter/material.dart';
import 'package:mensalidade_mts_app/core/components/login/app_text_styles_login.dart';
import 'package:mensalidade_mts_app/features/auth/presentation/primeiro_acesso.dart';
import 'package:provider/provider.dart';
import 'package:mensalidade_mts_app/features/auth/provider/login_provider.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoginProvider>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Image.asset('../../assets/images/logo.png', height: 160),
            ),
            const Text(
              'Bem-vindo ao Mensalidade MTS!',
              style: AppTextStylesLogin.loginStyle,
            ),
            const SizedBox(height: 60),
            SizedBox(
              width: 360,
              child: TextField(
                controller: emailController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 360,
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Senha',
                ),
              ),
            ),
            const SizedBox(height: 20),

            provider.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.all(
                          Radius.circular(5),
                        ),
                      ),
                      backgroundColor: AppTextStylesLogin.rotaractColor,
                      minimumSize: const Size(360, 55),
                    ),
                    onPressed: () {
                      provider.login(
                        emailController.text,
                        passwordController.text,
                      );
                    },
                    child: const Text(
                      'Entrar',
                      style: AppTextStylesLogin.buttonLoginStyle,
                    ),
                  ),

            const SizedBox(height: 25),

            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppTextStylesLogin.rotaractColor,
                    width: 2,
                  ),
                ),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrimeiroAcesso(),
                    ),
                  );
                },
                child: const Text(
                  'Primeiro acesso do associado',
                  style: AppTextStylesLogin.primeiroLoginStyle,
                ),
              ),
            ),

            if (provider.error != null) ...[
              const SizedBox(height: 12),
              Text(provider.error!, style: const TextStyle(color: Colors.red)),
            ],
            if (provider.user != null) ...[
              const SizedBox(height: 12),
              Text('Bem-vindo, ${provider.user!.name}!'),
            ],
          ],
        ),
      ),
    );
  }
}
