import 'package:flutter/material.dart';
import 'package:mensalidade_mts_app/core/componentsStyle/associado/home_page_styles.dart';
import 'package:mensalidade_mts_app/core/componentsStyle/default/app_default_styles.dart';
import 'package:mensalidade_mts_app/core/componentsStyle/login/app_text_styles_login.dart';
import 'package:mensalidade_mts_app/features/auth/providers/auth_provider.dart';
import 'package:mensalidade_mts_app/features/pagamentos/commands/atualizar_pagamento_command.dart';
import 'package:mensalidade_mts_app/features/pagamentos/presentation/modal_confirmacao_pagamento.dart';
import 'package:mensalidade_mts_app/features/pagamentos/providers/pagamento_provider.dart';
import 'package:mensalidade_mts_app/features/tesoureiros/models/pagamentos_associados.dart';
import 'package:provider/provider.dart';

class TesoureiroHomePage extends StatefulWidget {
  const TesoureiroHomePage({super.key});

  @override
  State<TesoureiroHomePage> createState() => _TesoureiroHomePagePageState();
}

enum StatusSelecionado { pendentes, atrasadas, pagas }

enum StatusPagamento {
  pendente(1),
  pago(2);

  final int value;
  const StatusPagamento(this.value);
}

class _TesoureiroHomePagePageState extends State<TesoureiroHomePage> {
  List<PagamentoAssociadosDto> pagamentos = [];
  double valorTotal = 0;
  OpcoesDropDown? valorSelecionado;
  StatusSelecionado? statusSelecionado;
  Set<PagamentoAssociadosDto> selecionados = {};
  Set<String> nomesAssociados = {};

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
        valorSelecionado = opcoesDropDown.first;
        atualizarListagemPagamentos(
          pagamentosProvider: pagamentosProvider,
          status: StatusSelecionado.pendentes,
          pagamentosDto: pagamentosProvider.mensalidades!.pagamentosPendentes,
          valor: pagamentosProvider.mensalidades!.valorTotalPagamentosPendentes,
        );

        atualizarNomesAssociados(
          pagamentosProvider.mensalidades!.pagamentosPendentes,
        );
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
    required double valor,
  }) {
    setState(() {
      pagamentos = [];
      statusSelecionado = status;
      pagamentos = pagamentosDto;
      valorTotal = valor;

      apagarMensalidadesSelecionadas();
    });
  }

  Future<void> _openModalPagamentos(AtualizarPagamentoCommand command) async {
    final pagamentosProvider = context.read<PagamentoProvider>();
    final pagou = await showModalBottomSheet<bool>(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => ModalConfirmacaoPagamento(
        selecionadosParaPagamento: selecionados,
        pagamentos: pagamentos,
        command: command,
      ),
    );

    if (pagou == true) {
      apagarMensalidadesSelecionadas();

      await pagamentosProvider.obterMensalidadeAssociados(
        '${valorSelecionado?.property}=true',
      );

      setState(() {
        pagamentos = pagamentosProvider.mensalidades!.pagamentosPendentes;
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pagamento realizado com sucesso! 🎉')),
        );
      }
    }
  }

  void atualizarNomesAssociados(List<PagamentoAssociadosDto> pagamentos) {
    setState(() {
      nomesAssociados = pagamentos
          .map((p) => p.nomeCompleto)
          .cast<String>()
          .toSet();
    });
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 15),
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
                          // Reseta a visualização para a lista de pagamentos pendentes após a mudança no dropdown.
                          statusSelecionado = StatusSelecionado.pendentes;
                        });

                        final property = '${novoValor.property}=true';

                        await pagamentosProvider.obterMensalidadeAssociados(
                          property,
                        );

                        if (!mounted) return;

                        setState(() {
                          // A lista a ser mostrada agora é sempre a de Pendentes.
                          atualizarListagemPagamentos(
                            pagamentosProvider: pagamentosProvider,
                            status: StatusSelecionado.pendentes,
                            pagamentosDto: pagamentosProvider
                                .mensalidades!
                                .pagamentosPendentes,
                            valor: pagamentosProvider
                                .mensalidades!
                                .valorTotalPagamentosPendentes,
                          );
                          atualizarNomesAssociados(
                            pagamentosProvider
                                .mensalidades!
                                .pagamentosPendentes,
                          );
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
                          if (statusSelecionado ==
                              StatusSelecionado.pendentes) {
                            return;
                          }

                          atualizarListagemPagamentos(
                            pagamentosProvider: pagamentosProvider,
                            status: StatusSelecionado.pendentes,
                            pagamentosDto: pagamentosProvider
                                .mensalidades!
                                .pagamentosPendentes,
                            valor: pagamentosProvider
                                .mensalidades!
                                .valorTotalPagamentosPendentes,
                          );

                          atualizarNomesAssociados(
                            pagamentosProvider
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
                          if (statusSelecionado ==
                              StatusSelecionado.atrasadas) {
                            return;
                          }

                          atualizarListagemPagamentos(
                            pagamentosProvider: pagamentosProvider,
                            status: StatusSelecionado.atrasadas,
                            pagamentosDto: pagamentosProvider
                                .mensalidades!
                                .pagamentosAtrasados,
                            valor: pagamentosProvider
                                .mensalidades!
                                .valorTotalPagamentosAtrasados,
                          );

                          pagamentos = pagamentos.map((p) {
                            p.statusNome = 'Atrasado';
                            return p;
                          }).toList();

                          atualizarNomesAssociados(
                            pagamentosProvider
                                .mensalidades!
                                .pagamentosAtrasados,
                          );
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
                            pagamentosDto: pagamentosProvider
                                .mensalidades!
                                .pagamentosPagos,
                            valor: pagamentosProvider
                                .mensalidades!
                                .valorTotalPagamentosPagos,
                          );

                          atualizarNomesAssociados(
                            pagamentosProvider.mensalidades!.pagamentosPagos,
                          );
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              pagamentos.isEmpty
                  ? Center(
                      child: Text(
                        'Não há mensalidades ${statusSelecionado!.name}.',
                        style: HomePageStyles.listaVazia,
                      ),
                    )
                  : pagamentosProvider.loading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: nomesAssociados.map((nome) {
                        final pagamentosDoAssociado = pagamentos
                            .where((p) => p.nomeCompleto == nome)
                            .toList();
                        return ExpansionTile(
                          title: Text(
                            nome,
                            style: AppTextStylesLogin.primeiroLoginStyle,
                          ),
                          subtitle: Text(
                            'Mensalidades ${statusSelecionado!.name} (${pagamentosDoAssociado.length})',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          children: pagamentosDoAssociado.map((p) {
                            return Card(
                              color: const Color.fromARGB(255, 226, 223, 225),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.monetization_on_rounded,
                                ),
                                title: Text(
                                  'Referente: ${p.referenteMes}/${p.referenteAno}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  'Valor: R\$ ${p.valor.toStringAsFixed(2)}\n'
                                  'Vencimento: ${p.diaVencimento}/${p.referenteMes}/${p.referenteAno}\n'
                                  'Status: ${p.statusNome}',
                                ),
                                trailing: Checkbox(
                                  activeColor: AppDefaultStyles.rotaractColor,
                                  checkColor: Colors.white,
                                  value: selecionados.contains(p),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value!) {
                                        selecionados.add(p);
                                      } else {
                                        selecionados.remove(p);
                                      }
                                    });
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }).toList(),
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: selecionados.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () async {
                AtualizarPagamentoCommand command = AtualizarPagamentoCommand(
                  idsPagamentos: selecionados
                      .map((p) => p.idPagamento)
                      .toList(),
                  statusPagamentoId:
                      statusSelecionado != StatusSelecionado.pagas
                      ? StatusPagamento.pago.value
                      : StatusPagamento.pendente.value,
                  dataPagamento: null,
                );
                _openModalPagamentos(command);
              },
              label: Text(
                statusSelecionado != StatusSelecionado.pagas
                    ? 'Pagar (${selecionados.length})'
                    : 'Marcar como pendente (${selecionados.length})',
              ),
              icon: Icon(
                statusSelecionado != StatusSelecionado.pagas
                    ? Icons.payment
                    : Icons.undo,
              ),
              backgroundColor: AppDefaultStyles.rotaractColor,
              foregroundColor: Colors.white,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
        padding: const EdgeInsets.symmetric(vertical: 20),
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
