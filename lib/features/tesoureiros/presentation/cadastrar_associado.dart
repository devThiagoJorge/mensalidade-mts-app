import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mensalidade_mts_app/core/componentsStyle/default/app_default_styles.dart';
import 'package:mensalidade_mts_app/core/componentsStyle/login/app_text_styles_login.dart';

class CadastroAssociadoPage extends StatefulWidget {
  const CadastroAssociadoPage({super.key});

  @override
  State<CadastroAssociadoPage> createState() => _CadastroAssociadoPageState();
}

class _CadastroAssociadoPageState extends State<CadastroAssociadoPage> {
  @override
  void initState() {
    super.initState();
  }

  bool isInicioGestao = true;
  @override
  Widget build(BuildContext context) {
    final primeiroNomeController = TextEditingController();
    final sobrenomeController = TextEditingController();
    final emailController = TextEditingController();
    final diaVencimentoMensalidadeController = TextEditingController();
    const WidgetStateProperty<Icon> thumbIcon =
        WidgetStateProperty<Icon>.fromMap(<WidgetStatesConstraint, Icon>{
          WidgetState.selected: Icon(Icons.check),
          WidgetState.any: Icon(Icons.close),
        });

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
                    labelText: 'Sobrenome',
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
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Dia do vencimento da mensalidade',
                    labelText: 'Dia do vencimento da mensalidade',
                  ),
                  validator: (value) {
                    // 1. Verifica se o valor é nulo ou vazio
                    if (value == null || value.isEmpty) {
                      return 'Informe o Dia do vencimento da mensalidade';
                    }

                    // 2. Tenta converter o valor para um número.
                    final int? parsedValue = int.tryParse(value);

                    // 3. Verifica se a conversão falhou (não é um número válido)
                    if (parsedValue == null) {
                      return 'Informe um número válido';
                    }

                    // 4. Verifica se o número está dentro do intervalo aceitável (1 a 31)
                    if (parsedValue < 1 || parsedValue > 31) {
                      return 'O dia deve estar entre 1 e 31';
                    }

                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Gerar a mensalidade desde o começo da gestão?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Switch(
                      thumbIcon: thumbIcon,
                      value: isInicioGestao,
                      onChanged: (bool newValue) {
                        setState(() {
                          isInicioGestao = newValue;
                        });
                      },
                      activeThumbColor: AppDefaultStyles.rotaractColor,
                    ),
                  ],
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
