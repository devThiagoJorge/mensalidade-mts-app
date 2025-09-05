import 'package:flutter/material.dart';
import 'package:mensalidade_mts_app/core/componentsStyle/login/app_text_styles_login.dart';

class CadastroAssociadoPage extends StatefulWidget {
  const CadastroAssociadoPage({super.key});

  @override
  State<CadastroAssociadoPage> createState() => _CadastroAssociadoPageState();
}

enum StatusSelecionado { pendentes, atrasadas, pagas }

class _CadastroAssociadoPageState extends State<CadastroAssociadoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final primeiroNomeController = TextEditingController();
    final sobrenomeController = TextEditingController();
    final emailController = TextEditingController();
    final diaVencimentoMensalidadeController = TextEditingController();

    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cadastrar novo associado',
          style: AppTextStylesLogin.loginStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(child: Image.asset('assets/images/logo.png', height: 160)),
              const SizedBox(height: 40),
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
              SizedBox(
                width: 360,
                child: TextFormField(
                  controller: primeiroNomeController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Informe o primeiro nome',
                    labelText: 'Primeiro nome',
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Informe o primeiro nome'
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 360,
                child: TextFormField(
                  controller: sobrenomeController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Informe o sobrenome',
                    labelText: 'Primeiro nome',
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Informe o sobrenome'
                      : null,
                ),
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: 360,
                child: TextFormField(
                  controller: diaVencimentoMensalidadeController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Dia do vencimento da mensalidade',
                    labelText: 'Dia do vencimento da mensalidade',
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Informe o Dia do vencimento da mensalidade'
                      : null,
                ),
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: 360,
                child: TextFormField(
                  controller: diaVencimentoMensalidadeController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Gerar desde começo da gestão?',
                    labelText: 'Dia do vencimento da mensalidade',
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Informe o Dia do vencimento da mensalidade'
                      : null,
                ),
              ),
              const SizedBox(height: 40),

              // BOTÃO ENTRAR
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  backgroundColor: AppTextStylesLogin.rotaractColor,
                  minimumSize: const Size(360, 55),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {}
                },
                child: const Text(
                  'Cadastrar',
                  style: AppTextStylesLogin.buttonLoginStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
