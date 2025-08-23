import 'package:flutter/material.dart';
import 'package:mensalidade_mts_app/core/components/login/app_text_styles_login.dart';
import 'package:mensalidade_mts_app/features/auth/presentation/primeiro_acesso.dart';
import 'package:provider/provider.dart';
import 'package:mensalidade_mts_app/features/auth/provider/login_provider.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Chave global para validar os campos
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoginProvider>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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

              // Campo E-MAIL
              SizedBox(
                width: 360,
                child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Informe o seu e-mail',
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o e-mail';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Digite um e-mail válido';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Campo SENHA
              SizedBox(
                width: 360,
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Informe a senha',
                    labelText: 'Senha',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe a senha';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 20),

              // BOTÃO ENTRAR
              provider.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        backgroundColor: AppTextStylesLogin.rotaractColor,
                        minimumSize: const Size(360, 55),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          provider.login(
                            emailController.text,
                            passwordController.text,
                          );
                        }
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

              // ERROS OU SUCESSO
              if (provider.error != null) ...[
                const SizedBox(height: 12),
                Text(
                  provider.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
              if (provider.user != null) ...[
                const SizedBox(height: 12),
                Text('Bem-vindo, ${provider.user!.name}!'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
