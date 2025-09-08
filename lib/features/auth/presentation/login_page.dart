import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mensalidade_mts_app/core/componentsStyle/login/app_text_styles_login.dart';
import 'package:mensalidade_mts_app/features/auth/providers/auth_provider.dart';
import 'package:mensalidade_mts_app/features/auth/presentation/primeiro_acesso.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Storage seguro
  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, provider, child) {
          // Mostra erro como texto
          if (provider.error != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(provider.error!),
                  backgroundColor: Colors.red,
                ),
              );
            });
          }

          // Se logou com sucesso
          if (provider.user != null && provider.error != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              // Salva o token e a permissão do usuário
              Navigator.pushReplacementNamed(context, '/auth');
              await storage.write(key: 'token', value: provider.user!.token);
              await storage.write(key: 'role', value: provider.user!.role);
            });
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Center(
                    child: Image.asset('assets/images/logo.png', height: 160),
                  ),
                  const Text(
                    'Bem-vindo ao Mensalidade MTS!',
                    style: AppTextStylesLogin.loginStyle,
                  ),
                  const SizedBox(height: 60),

                  // Campo EMAIL
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
                      validator: (value) => value == null || value.isEmpty
                          ? 'Informe o e-mail'
                          : null,
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
                      validator: (value) => value == null || value.isEmpty
                          ? 'Informe a senha'
                          : null,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // BOTÃO ENTRAR
                  provider.loading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            backgroundColor: AppTextStylesLogin.rotaractColor,
                            minimumSize: const Size(360, 55),
                          ),
                          onPressed: () {
                            emailController.text = 'thiago.v.jorge@hotmail.com';
                            passwordController.text = 'teste123';

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

                  // BOTÃO ENTRAR
                  provider.loading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            backgroundColor: AppTextStylesLogin.rotaractColor,
                            minimumSize: const Size(360, 55),
                          ),
                          onPressed: () {
                            emailController.text =
                                'thiagojorge.fatec@gmail.com';
                            passwordController.text = 'teste123';

                            if (_formKey.currentState!.validate()) {
                              provider.login(
                                emailController.text,
                                passwordController.text,
                              );
                            }
                          },
                          child: const Text(
                            'Entrar como associados',
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
