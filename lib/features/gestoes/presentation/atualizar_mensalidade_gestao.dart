import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mensalidade_mts_app/core/components/month_year_date_picker.dart';
import 'package:mensalidade_mts_app/core/components/snackbar.dart';
import 'package:mensalidade_mts_app/core/componentsStyle/login/app_text_styles_login.dart';
import 'package:mensalidade_mts_app/core/utils/data_utils.dart';
import 'package:mensalidade_mts_app/core/utils/numbers_utils.dart';
import 'package:mensalidade_mts_app/features/gestoes/commands/atualizar_mensalidade_command.dart';
import 'package:mensalidade_mts_app/features/gestoes/providers/gestao_provider.dart';
import 'package:provider/provider.dart';

class AtualizarMensalidadeModal extends StatefulWidget {
  const AtualizarMensalidadeModal({super.key});

  @override
  State<AtualizarMensalidadeModal> createState() =>
      _AtualizarMensalidadeModalState();
}

class _AtualizarMensalidadeModalState extends State<AtualizarMensalidadeModal> {
  late final TextEditingController novoValorController;
  late final TextEditingController dataReferenciaController;

  @override
  void initState() {
    super.initState();
    novoValorController = TextEditingController();
    dataReferenciaController = TextEditingController();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GestaoProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Alterar valor da mensalidade',
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
                TextFormField(
                  controller: novoValorController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Novo valor da mensalidade',
                    labelText: 'Novo valor da mensalidade',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o novo valor da mensalidade';
                    }
                    final int? parsedValue = int.tryParse(value);
                    if (parsedValue == null) {
                      return 'Informe um número válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                MonthYearPickerFormField(
                  labelText: 'Selecione o mês e ano',
                  controller: dataReferenciaController,
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
                              AtualizarMensalidadeCommand command =
                                  AtualizarMensalidadeCommand(
                                    dataReferencia: DataUtils.formatarData(
                                      '01/${dataReferenciaController.text}',
                                    ),
                                    novoValor: NumberUtils.converterParaDouble(
                                      novoValorController.text,
                                    ),
                                  );

                              await provider.atualizarValorMensalidade(command);

                              if (provider.error != null) {
                                SnackbarHelper.mostrarErro(
                                  context,
                                  provider.error ?? 'Erro inesperado',
                                );
                              } else {
                                SnackbarHelper.mostrarSucesso(
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
}
