import 'package:flutter/material.dart';
import 'package:mensalidade_mts_app/core/components/login/app_text_styles_login.dart';
import 'package:mensalidade_mts_app/features/auth/presentation/login_page.dart';

class PrimeiroAcesso extends StatefulWidget {
  const PrimeiroAcesso({super.key});

  @override
  State<PrimeiroAcesso> createState() => _PrimeiroAcessoState();
}

class _PrimeiroAcessoState extends State<PrimeiroAcesso> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final codigoController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmacaoController = TextEditingController();

  int etapa = 1;

  final List<String> textosPainel = [
    'Bem-vindo ao Mensalidades MTS! Digite o e-mail cadastrado pelo tesoureiro para receber seu código de acesso.',
    'Enviamos um código para o seu e-mail. Informe-o para seguir com a criação da senha.',
    'Agora é hora de criar sua senha! Não se preocupe, usamos criptografia para mantê-la segura.',
  ];

  @override
  void initState() {
    super.initState();
    _resetarEstados();
  }

  void _resetarEstados() {
    etapa = 1;
    emailController.clear();
    codigoController.clear();
    senhaController.clear();
    confirmacaoController.clear();
  }

  bool senhaIgual() {
    return senhaController.text == confirmacaoController.text;
  }

  void _avancar() {
    if (formKey.currentState!.validate()) {
      if (etapa < 3) {
        setState(() => etapa++);
      } else if (etapa == 3 && senhaIgual()) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Center(
                child: Image.asset('../../assets/images/logo.png', height: 160),
              ),
              const SizedBox(height: 60),

              // Etapa 1
              if (etapa == 1) ...[
                SizedBox(
                  width: 360,
                  child: TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Informe o seu e-mail',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe seu e-mail';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'E-mail inválido';
                      }
                      return null;
                    },
                  ),
                ),
              ],

              // Etapa 2
              if (etapa == 2) ...[
                SizedBox(
                  width: 360,
                  child: TextFormField(
                    controller: codigoController,
                    decoration: const InputDecoration(
                      labelText: 'Código',
                      hintText: 'Informe o código recebido',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o código';
                      }
                      if (value.length < 6) {
                        return 'O código deve ter 6 dígitos';
                      }
                      return null;
                    },
                  ),
                ),
              ],

              // Etapa 3
              if (etapa == 3) ...[
                SizedBox(
                  width: 360,
                  child: TextFormField(
                    controller: senhaController,
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      hintText: 'Defina sua senha',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe uma senha';
                      }
                      if (value.length < 6) {
                        return 'A senha deve ter pelo menos 6 caracteres';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 360,
                  child: TextFormField(
                    controller: confirmacaoController,
                    decoration: const InputDecoration(
                      labelText: 'Confirme a sua senha',
                      hintText: 'Confirme a sua senha',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirme a senha';
                      }
                      if (value != senhaController.text) {
                        return 'As senhas não coincidem';
                      }
                      return null;
                    },
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // Botão
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  backgroundColor: AppTextStylesLogin.rotaractColor,
                  minimumSize: const Size(360, 55),
                ),
                onPressed: _avancar,
                child: const Text(
                  'Avançar',
                  style: AppTextStylesLogin.buttonLoginStyle,
                ),
              ),

              const SizedBox(height: 60),

              // Painel
              Card(
                color: AppTextStylesLogin.backgroundPainelInformativoColor,
                child: SizedBox(
                  width: 360,
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Center(
                      child: Text(
                        textosPainel[etapa - 1],
                        style:
                            AppTextStylesLogin.alteracaoSenhaPainelInformativo,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
