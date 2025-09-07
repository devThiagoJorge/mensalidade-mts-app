import 'package:flutter/material.dart';
import 'package:mensalidade_mts_app/core/componentsStyle/associado/home_page_styles.dart';
import 'package:mensalidade_mts_app/core/componentsStyle/default/app_default_styles.dart';
import 'package:mensalidade_mts_app/features/auth/providers/auth_provider.dart';
import 'package:mensalidade_mts_app/features/pagamentos/commands/atualizar_pagamento_command.dart';
import 'package:mensalidade_mts_app/features/pagamentos/providers/pagamento_provider.dart';
import 'package:mensalidade_mts_app/features/tesoureiros/models/pagamentos_associados.dart';
import 'package:provider/provider.dart';

class TesoureiroHomePage extends StatefulWidget {
  const TesoureiroHomePage({super.key});

  @override
  State<TesoureiroHomePage> createState() => _TesoureiroHomePagePageState();
}

enum StatusSelecionado { pendentes, atrasadas, pagas }

class _TesoureiroHomePagePageState extends State<TesoureiroHomePage> {
  List<PagamentoAssociadosDto> pagamentos = [];
  double valorTotal = 0;
  OpcoesDropDown? valorSelecionado;
  StatusSelecionado? statusSelecionado;
  Set<int> selecionados = {};

  List<OpcoesDropDown> opcoesDropDown = [
    OpcoesDropDown(
      descricao: 'Mês atual',
      ativo: false,
      property: 'IsMesCorrente',
    ),
    OpcoesDropDown(
      descricao: 'Mês Anterior',
      ativo: false,
      property: 'IsMesAnterior',
    ),
    OpcoesDropDown(
      descricao: '1º semestre da gestão',
      ativo: false,
      property: 'IsPrimeiroSemestreGestao',
    ),
    OpcoesDropDown(
      descricao: '2º semestre da gestão',
      ativo: false,
      property: 'IsSegundoSemestreGestao',
    ),
    OpcoesDropDown(
      descricao: 'Gestão toda',
      ativo: false,
      property: 'IsGestao',
    ),
  ];

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (!mounted) return;

      final authProvider = context.read<AuthProvider>();
      final pagamentosProvider = context.read<PagamentoProvider>();

      await authProvider.loadFromStorage();
      await pagamentosProvider.obterMensalidadeAssociados(
        '${opcoesDropDown.first.property}=true',
      );

      if (!mounted) return;

      setState(() {
        pagamentos = pagamentosProvider.mensalidades!.pagamentosPendentes;
        valorSelecionado = opcoesDropDown.first;
        statusSelecionado = StatusSelecionado.pendentes;
        valorTotal =
            pagamentosProvider.mensalidades!.valorTotalPagamentosPendentes;
      });
    });
  }

  void apagarMensalidadesSelecionadas() {
    selecionados = {};
  }

  void atualizarListagemPagamentos({
    required PagamentoProvider pagamentosProvider,
    required StatusSelecionado status,
    required List<PagamentoAssociadosDto> pagamentosDto,
  }) {
    pagamentos = [];
    statusSelecionado = status;
    pagamentos = pagamentosDto;
    valorTotal = pagamentosProvider.mensalidades!.valorTotalPagamentosPagos;
    apagarMensalidadesSelecionadas();
  }

  @override
  Widget build(BuildContext context) {
    final pagamentosProvider = context.watch<PagamentoProvider>();
    final authProvider = context.watch<AuthProvider>();

    if (pagamentosProvider.mensalidades == null ||
        authProvider.user == null ||
        pagamentosProvider.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          children: [
            Center(child: Image.asset('assets/images/logo.png', height: 160)),
            Center(
              child: Text(
                authProvider.user!.gestaoAtual,
                style: HomePageStyles.gestaoStyle,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DropdownButtonFormField<OpcoesDropDown>(
                    initialValue: valorSelecionado,
                    hint: const Text('Selecione uma opção'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: opcoesDropDown.map((OpcoesDropDown item) {
                      return DropdownMenuItem<OpcoesDropDown>(
                        value: item,
                        child: Text(item.descricao),
                      );
                    }).toList(),
                    onChanged: (OpcoesDropDown? novoValor) async {
                      if (novoValor == null) return;

                      setState(() {
                        valorSelecionado = novoValor;
                        for (var item in opcoesDropDown) {
                          item.ativo = (item == novoValor);
                        }
                      });

                      final property = '${novoValor.property}=true';

                      await pagamentosProvider.obterMensalidadeAssociados(
                        property,
                      );

                      if (!mounted) return;

                      setState(() {
                        pagamentos = pagamentosProvider
                            .mensalidades!
                            .pagamentosPendentes;

                        statusSelecionado = StatusSelecionado.pendentes;

                        valorTotal = pagamentosProvider
                            .mensalidades!
                            .valorTotalPagamentosPendentes;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Text('Valor total: $valorTotal'),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildStatusButton(
                    label:
                        'Pendentes (${pagamentosProvider.mensalidades?.pagamentosPendentes.length ?? 0})',
                    isSelected:
                        statusSelecionado == StatusSelecionado.pendentes,
                    selectedColor: const Color(0xFFFBC02D),
                    unselectedColor: const Color(0xFFFFF9C4),
                    borderColor: const Color(0xFFFBC02D),
                    onPressed: () {
                      setState(() {
                        if (statusSelecionado == StatusSelecionado.pendentes) {
                          return;
                        }

                        atualizarListagemPagamentos(
                          pagamentosProvider: pagamentosProvider,
                          status: StatusSelecionado.pendentes,
                          pagamentosDto: pagamentosProvider
                              .mensalidades!
                              .pagamentosPendentes,
                        );
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatusButton(
                    label:
                        'Atrasados (${pagamentosProvider.mensalidades?.pagamentosAtrasados.length ?? 0})',
                    isSelected:
                        statusSelecionado == StatusSelecionado.atrasadas,
                    selectedColor: const Color(0xFFD32F2F),
                    unselectedColor: const Color(0xFFFFCDD2),
                    borderColor: const Color(0xFFD32F2F),
                    onPressed: () {
                      setState(() {
                        if (statusSelecionado == StatusSelecionado.atrasadas) {
                          return;
                        }

                        atualizarListagemPagamentos(
                          pagamentosProvider: pagamentosProvider,
                          status: StatusSelecionado.atrasadas,
                          pagamentosDto: pagamentosProvider
                              .mensalidades!
                              .pagamentosAtrasados,
                        );

                        pagamentos = pagamentos.map((p) {
                          p.statusNome = 'Atrasado';
                          return p;
                        }).toList();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatusButton(
                    label:
                        'Pagos (${pagamentosProvider.mensalidades?.pagamentosPagos.length ?? 0})',
                    isSelected: statusSelecionado == StatusSelecionado.pagas,
                    selectedColor: const Color(0xFF0097A7),
                    unselectedColor: const Color(0xFFB2EBF2),
                    borderColor: const Color(0xFF0097A7),
                    onPressed: () {
                      setState(() {
                        if (statusSelecionado == StatusSelecionado.pagas) {
                          return;
                        }

                        atualizarListagemPagamentos(
                          pagamentosProvider: pagamentosProvider,
                          status: StatusSelecionado.pagas,
                          pagamentosDto:
                              pagamentosProvider.mensalidades!.pagamentosPagos,
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              // A lista agora ocupa todo o espaço restante disponível
              child: pagamentos.isEmpty
                  ? Center(
                      child: Text(
                        'Não há mensalidades ${statusSelecionado!.name}.',
                        style: HomePageStyles.listaVazia,
                      ),
                    )
                  : pagamentosProvider.loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 15),
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      itemCount: pagamentos.length,
                      itemBuilder: (context, index) {
                        final p = pagamentos[index];
                        return Card(
                          color: const Color.fromARGB(255, 226, 223, 225),
                          child: CheckboxListTile(
                            title: Center(
                              child: Text(
                                p.nomeCompleto,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            subtitle: Text(
                              'Data vencimento: ${p.diaVencimento}/${p.referenteMes}/${p.referenteAno}\n'
                              'Valor: R\$ ${p.valor.toStringAsFixed(2)}\n'
                              '${p.dataPagamento != null ? "${p.dataPagamento!.day.toString().padLeft(2, '0')}/"
                                        "${p.dataPagamento!.month.toString().padLeft(2, '0')}/"
                                        "${p.dataPagamento!.year}" : "Não pago"}\n'
                              '${p.statusNome}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            secondary: const Icon(
                              Icons.monetization_on_rounded,
                            ),
                            activeColor: AppDefaultStyles.rotaractColor,
                            checkColor: Colors.white,
                            value: selecionados.contains(p.idPagamento),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value!) {
                                  selecionados.add(p.idPagamento);
                                } else {
                                  selecionados.remove(p.idPagamento);
                                }
                              });
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
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
            onPressed: () {
              AtualizarPagamentoCommand command = AtualizarPagamentoCommand(
                idsPagamentos: selecionados.toList(),
                statusPagamentoId: 2,
                dataPagamento: DateTime.now(),
              );

              pagamentosProvider.atualizarPagamento(command);

              if (pagamentosProvider.response!.success) {
                statusSelecionado = StatusSelecionado.pendentes;
                pagamentos =
                    pagamentosProvider.mensalidades!.pagamentosPendentes;

                valorTotal = pagamentosProvider
                    .mensalidades!
                    .valorTotalPagamentosPendentes;

                selecionados = {};
              }
            },
            child: Text(
              'Pagar (${selecionados.length})',
              style: HomePageStyles.buttonTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusButton({
    required String label,
    required bool isSelected,
    required Color selectedColor,
    required Color unselectedColor,
    required Color borderColor,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? selectedColor : unselectedColor,
        foregroundColor: isSelected ? Colors.white : Colors.black,
        side: BorderSide(color: borderColor, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        padding: const EdgeInsets.symmetric(vertical: 35),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: HomePageStyles.buttonTextStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class OpcoesDropDown {
  String descricao;
  bool ativo;
  String property;

  OpcoesDropDown({
    required this.descricao,
    required this.ativo,
    required this.property,
  });
}
