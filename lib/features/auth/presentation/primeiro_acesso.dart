import 'package:flutter/material.dart';
import 'package:mensalidade_mts_app/core/components/login/app_text_styles_login.dart';

class PrimeiroAcesso extends StatelessWidget {
  const PrimeiroAcesso({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Image.asset('../../assets/images/logo.png', height: 160),
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.all(Radius.circular(5)),
                ),
                backgroundColor: AppTextStylesLogin.rotaractColor,
                minimumSize: const Size(360, 55),
              ),
              onPressed: () {},
              child: const Text(
                'Enviar',
                style: AppTextStylesLogin.buttonLoginStyle,
              ),
            ),
            const SizedBox(height: 60),
            const Card(
              color: AppTextStylesLogin.backgroundPainelInformativoColor,
              child: SizedBox(
                width: 360,
                height: 200,
                child: Padding(
                  padding: EdgeInsetsGeometry.all(30),
                  child: Center(
                    child: Text(
                      'Bem-vindo ao Mensalidades MTS! Digite o e-mail cadastrado pelo tesoureiro para receber seu código de acesso.',
                      style: AppTextStylesLogin.alteracaoSenhaPainelInformativo,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
