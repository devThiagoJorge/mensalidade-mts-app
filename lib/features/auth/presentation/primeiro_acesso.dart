import 'package:flutter/material.dart';
import 'package:mensalidade_mts_app/core/components/login/app_text_styles_login.dart';
import 'package:mensalidade_mts_app/features/auth/presentation/login_page.dart';
import 'package:mensalidade_mts_app/features/auth/providers/primeiro_acesso_provider.dart';
import 'package:provider/provider.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        context.read<PrimeiroAcessoProvider>();
      }
    });
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

  Future<void> avancar(PrimeiroAcessoProvider provider) async {
    if (!formKey.currentState!.validate()) return;

    switch (etapa) {
      case 1:
        await provider.solicitarPrimeiroAcesso(emailController.text);
        if (provider.error == null && provider.response?.success == true) {
          setState(() => etapa++);
          _mostarSucesso(provider.response!.message);
        } else {
          _mostrarErro(provider.error ?? 'Erro inesperado');
        }
        break;

      case 2:
        await provider.validarCodigo(codigoController.text);
        if (codigoController.text.length == 6) {
          setState(() => etapa++);
          _mostarSucesso(provider.response!.message);
        } else {
          _mostrarErro(provider.error ?? 'Erro inesperado');
        }
        break;

      case 3:
        if (senhaIgual()) {
          await provider.definirSenha(
            emailController.text,
            senhaController.text,
            codigoController.text,
          );

          if (provider.error == null && provider.response?.success == true) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              }
            });
          }
        } else {
          _mostrarErro(provider.error ?? 'Erro inesperado');
        }
        break;
    }
  }

  void _mostrarErro(String mensagem) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagem), backgroundColor: Colors.red),
      );
    });
  }

  void _mostarSucesso(String mensagem) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensagem),
          backgroundColor: AppTextStylesLogin.rotaractColor,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PrimeiroAcessoProvider>(context);

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

              if (etapa == 1) ...[_campoEmail()],
              if (etapa == 2) ...[_campoCodigo()],
              if (etapa == 3) ...[
                _campoSenha(),
                const SizedBox(height: 20),
                _campoConfirmacao(),
              ],

              const SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  backgroundColor: AppTextStylesLogin.rotaractColor,
                  minimumSize: const Size(360, 55),
                ),
                onPressed: () => avancar(provider),
                child: provider.loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Avançar',
                        style: AppTextStylesLogin.buttonLoginStyle,
                      ),
              ),

              const SizedBox(height: 20),

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

  Widget _campoEmail() => SizedBox(
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
  );

  Widget _campoCodigo() => SizedBox(
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
  );

  Widget _campoSenha() => SizedBox(
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
  );

  Widget _campoConfirmacao() => SizedBox(
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
  );
}
