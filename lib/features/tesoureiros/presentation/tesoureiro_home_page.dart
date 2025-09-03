import 'package:flutter/material.dart';
import 'package:mensalidade_mts_app/core/componentsStyle/associado/home_page_styles.dart';
import 'package:mensalidade_mts_app/features/auth/providers/auth_provider.dart';
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
      descricao: 'Primeiro semestre',
      ativo: false,
      property: 'IsPrimeiroSemestre',
    ),
    OpcoesDropDown(
      descricao: 'Segundo semestre',
      ativo: false,
      property: 'IsSegundoSemestre',
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

  @override
  Widget build(BuildContext context) {
    final pagamentosProvider = context.watch<PagamentoProvider>();
    final authProvider = context.watch<AuthProvider>();

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
                        'Pendentes (${pagamentosProvider.mensalidades!.pagamentosPendentes.length})',
                    isSelected:
                        statusSelecionado == StatusSelecionado.pendentes,
                    selectedColor: const Color(0xFFFBC02D),
                    unselectedColor: const Color(0xFFFFF9C4),
                    borderColor: const Color(0xFFFBC02D),
                    onPressed: () {
                      setState(() {
                        statusSelecionado = StatusSelecionado.pendentes;
                        pagamentos = pagamentosProvider
                            .mensalidades!
                            .pagamentosPendentes;

                        valorTotal = pagamentosProvider
                            .mensalidades!
                            .valorTotalPagamentosPendentes;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatusButton(
                    label:
                        'Atrasados (${pagamentosProvider.mensalidades!.pagamentosAtrasados.length})',
                    isSelected:
                        statusSelecionado == StatusSelecionado.atrasadas,
                    selectedColor: const Color(0xFFD32F2F),
                    unselectedColor: const Color(0xFFFFCDD2),
                    borderColor: const Color(0xFFD32F2F),
                    onPressed: () {
                      setState(() {
                        statusSelecionado = StatusSelecionado.atrasadas;
                        pagamentos = pagamentosProvider
                            .mensalidades!
                            .pagamentosAtrasados
                            .map((p) {
                              p.statusNome = 'Atrasado';
                              return p;
                            })
                            .toList();

                        valorTotal = pagamentosProvider
                            .mensalidades!
                            .valorTotalPagamentosAtrasados;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatusButton(
                    label:
                        'Pagos (${pagamentosProvider.mensalidades!.pagamentosPagos.length})',
                    isSelected: statusSelecionado == StatusSelecionado.pagas,
                    selectedColor: const Color(0xFF0097A7),
                    unselectedColor: const Color(0xFFB2EBF2),
                    borderColor: const Color(0xFF0097A7),
                    onPressed: () {
                      setState(() {
                        statusSelecionado = StatusSelecionado.pagas;
                        pagamentos =
                            pagamentosProvider.mensalidades!.pagamentosPagos;

                        valorTotal = pagamentosProvider
                            .mensalidades!
                            .valorTotalPagamentosPagos;
                      });
                    },
                  ),
                ),
              ],
            ),
            pagamentosProvider.loading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: pagamentos.isEmpty
                        ? Center(
                            child: Text(
                              'Não há mensalidades ${statusSelecionado!.name}.',
                              style: HomePageStyles.listaVazia,
                            ),
                          )
                        : ListView.separated(
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 15),
                            padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                            itemCount: pagamentos.length,
                            itemBuilder: (context, index) {
                              final p = pagamentos[index];
                              return Card(
                                color: const Color.fromARGB(255, 226, 223, 225),
                                child: ListTile(
                                  title: Center(
                                    child: Text(
                                      p.statusNome,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Data vencimento: ${p.diaVencimento}/${p.referenteMes}/${p.referenteAno}\n'
                                    'Valor: R\$ ${p.valor.toStringAsFixed(2)}\n'
                                    'Pagamento: ${p.dataPagamento != null ? "${p.dataPagamento!.day.toString().padLeft(2, '0')}/"
                                              "${p.dataPagamento!.month.toString().padLeft(2, '0')}/"
                                              "${p.dataPagamento!.year}" : "Não pago"}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
          ],
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
