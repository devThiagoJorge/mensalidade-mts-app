import 'package:flutter/material.dart';
import 'package:mensalidade_mts_app/core/componentsStyle/associado/home_page_styles.dart';
import 'package:mensalidade_mts_app/core/componentsStyle/default/app_default_styles.dart';
import 'package:mensalidade_mts_app/core/componentsStyle/login/app_text_styles_login.dart';
import 'package:mensalidade_mts_app/features/pagamentos/commands/atualizar_pagamento_command.dart';
import 'package:mensalidade_mts_app/features/pagamentos/providers/pagamento_provider.dart';
import 'package:mensalidade_mts_app/features/tesoureiros/models/pagamentos_associados.dart';
import 'package:provider/provider.dart';

class ModalConfirmacaoPagamento extends StatefulWidget {
  final Set<PagamentoAssociadosDto> selecionadosParaPagamento;
  final List<PagamentoAssociadosDto> pagamentos;
  final AtualizarPagamentoCommand command;

  const ModalConfirmacaoPagamento({
    super.key,
    required this.selecionadosParaPagamento,
    required this.pagamentos,
    required this.command,
  });

  @override
  State<ModalConfirmacaoPagamento> createState() =>
      _ModalConfirmacaoPagamentoState();
}

class _ModalConfirmacaoPagamentoState extends State<ModalConfirmacaoPagamento> {
  late final Set<String> nomesUnicos;

  @override
  void initState() {
    super.initState();

    nomesUnicos = widget.selecionadosParaPagamento
        .map((p) => p.nomeCompleto)
        .cast<String>()
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    final pagamentosProvider = context.watch<PagamentoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pagamento mensalidade',
          style: AppTextStylesLogin.loginStyle,
        ),
      ),
      body: widget.selecionadosParaPagamento.isEmpty
          ? const Center(
              child: Text(
                'Selecione as mensalidades que deseja pagar!',
                style: HomePageStyles.listaVazia,
              ),
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: nomesUnicos.map((nome) {
                        return ExpansionTile(
                          title: Text(
                            nome,
                            style: AppTextStylesLogin.primeiroLoginStyle,
                          ),
                          subtitle: Text(
                            'Mensalidades selecionadas: (${widget.selecionadosParaPagamento.where((c) => c.nomeCompleto == nome).length})',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          children: widget.selecionadosParaPagamento
                              .where((p) => p.nomeCompleto == nome)
                              .map((p) {
                                return ListTile(
                                  title: Text(
                                    'R\$ ${p.valor.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Vencimento: ${p.diaVencimento}/${p.referenteMes}/${p.referenteAno}',
                                  ),
                                );
                              })
                              .toList(),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: widget.selecionadosParaPagamento.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppDefaultStyles.rotaractColor,
                    foregroundColor: Colors.white,
                    side: const BorderSide(
                      color: AppDefaultStyles.rotaractColor,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                  onPressed: () async {
                    final confirmar = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Confirmar Pagamento'),
                        content: Text(
                          'Você tem certeza que deseja concluir o pagamento de '
                          '${widget.selecionadosParaPagamento.length} mensalidade(s)?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            child: const Text('Cancelar'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppDefaultStyles.rotaractColor,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => Navigator.of(ctx).pop(true),
                            child: const Text('Confirmar'),
                          ),
                        ],
                      ),
                    );

                    if (confirmar == true) {
                      await pagamentosProvider.atualizarPagamento(
                        widget.command,
                      );

                      if (!mounted) return;

                      if (pagamentosProvider.response?.success == true) {
                        Navigator.pop(context, true);
                      }
                    }
                  },
                  child: Text(
                    'Concluir (${widget.selecionadosParaPagamento.length})',
                    style: AppTextStylesLogin.buttonLoginStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
    );
  }
}
