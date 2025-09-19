// ... seu código anterior
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mensalidade_mts_app/core/components/snackbar.dart';
import 'package:mensalidade_mts_app/core/componentsStyle/default/app_default_styles.dart';
import 'package:mensalidade_mts_app/core/componentsStyle/login/app_text_styles_login.dart';
import 'package:mensalidade_mts_app/features/associados/commands/criar_associado_command.dart';
import 'package:mensalidade_mts_app/features/associados/providers/associado_provider.dart';
import 'package:provider/provider.dart';

class CadastroAssociadoPage extends StatefulWidget {
  const CadastroAssociadoPage({super.key});

  @override
  State<CadastroAssociadoPage> createState() => _CadastroAssociadoPageState();
}

class _CadastroAssociadoPageState extends State<CadastroAssociadoPage> {
  late final TextEditingController primeiroNomeController;
  late final TextEditingController sobrenomeController;
  late final TextEditingController emailController;
  late final TextEditingController diaVencimentoMensalidadeController;

  @override
  void initState() {
    super.initState();
    primeiroNomeController = TextEditingController();
    sobrenomeController = TextEditingController();
    emailController = TextEditingController();
    diaVencimentoMensalidadeController = TextEditingController();
  }

  @override
  void dispose() {
    primeiroNomeController.dispose();
    sobrenomeController.dispose();
    emailController.dispose();
    diaVencimentoMensalidadeController.dispose();
    super.dispose();
  }

  bool isInicioGestao = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    const WidgetStateProperty<Icon> thumbIcon =
        WidgetStateProperty<Icon>.fromMap(<WidgetStatesConstraint, Icon>{
          WidgetState.selected: Icon(Icons.check),
          WidgetState.any: Icon(Icons.close),
        });

    final provider = Provider.of<AssociadoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cadastrar novo associado',
          style: AppTextStylesLogin.loginStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Center(
                  child: Image.asset('assets/images/logo.png', height: 160),
                ),
                const SizedBox(height: 40),
                // Campo EMAIL
                TextFormField(
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

                const SizedBox(height: 20),
                TextFormField(
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
                const SizedBox(height: 20),
                TextFormField(
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

                const SizedBox(height: 20),
                TextFormField(
                  controller: diaVencimentoMensalidadeController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Dia do vencimento da mensalidade',
                    labelText: 'Dia do vencimento da mensalidade',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o Dia do vencimento da mensalidade';
                    }
                    final int? parsedValue = int.tryParse(value);
                    if (parsedValue == null) {
                      return 'Informe um número válido';
                    }
                    if (parsedValue < 1 || parsedValue > 31) {
                      return 'O dia deve estar entre 1 e 31';
                    }
                    return null;
                  },
                ),
                // AQUI COMEÇA O PADDING CORRETO PARA O SWITCH
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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

                const SizedBox(height: 40),

                provider.loading
                    ? const CircularProgressIndicator(
                        color: AppTextStylesLogin.rotaractColor,
                      )
                    : SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            backgroundColor: AppTextStylesLogin.rotaractColor,
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final int diaVencimentoPagamento = int.parse(
                                diaVencimentoMensalidadeController.text,
                              );

                              CriarAssociadoCommand command =
                                  CriarAssociadoCommand(
                                    primeiroNome: primeiroNomeController.text,
                                    sobreNome: sobrenomeController.text,
                                    email: emailController.text,
                                    diaVencimentoPagamento:
                                        diaVencimentoPagamento,
                                    gerarDesdeComecoGestao: isInicioGestao,
                                  );

                              await provider.cadastrarAssociado(command);

                              if (provider.response!.success) {
                                SnackbarHelper.mostrarSucesso(
                                  context,
                                  provider.response!.message,
                                );
                                resetFields();
                              } else {
                                SnackbarHelper.mostrarErro(
                                  context,
                                  provider.response!.message,
                                );
                              }
                            }
                          },
                          child: const Text(
                            'Cadastrar',
                            style: AppTextStylesLogin.buttonLoginStyle,
                          ),
                        ),
                      ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void resetFields() {
    primeiroNomeController.clear();
    sobrenomeController.clear();
    emailController.clear();
    diaVencimentoMensalidadeController.clear();
    isInicioGestao = false;
  }
}
