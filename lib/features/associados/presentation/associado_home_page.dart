import 'package:flutter/material.dart';
import 'package:mensalidade_mts_app/core/componentsStyle/associado/home_page_styles.dart';
import 'package:mensalidade_mts_app/features/associados/providers/associado_provider.dart';
import 'package:mensalidade_mts_app/features/auth/providers/auth_provider.dart';
import 'package:mensalidade_mts_app/features/pagamentos/models/pagamento.dart';
import 'package:provider/provider.dart';

class AssociadoHomePage extends StatefulWidget {
  const AssociadoHomePage({super.key});

  @override
  State<AssociadoHomePage> createState() => _AssociadoHomePageState();
}

enum StatusSelecionado { pendentes, atrasadas, pagas }

class _AssociadoHomePageState extends State<AssociadoHomePage> {
  List<Pagamento> pagamentos = [];
  StatusSelecionado? statusSelecionado;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (!mounted) return;

      final authProvider = context.read<AuthProvider>();
      final associadoProvider = context.read<AssociadoProvider>();
      await authProvider.loadFromStorage();

      await associadoProvider.obterPorId(authProvider.user!.id);

      if (!mounted) return;

      setState(() {
        pagamentos = associadoProvider.associado!.pagamentosPendentes;
        statusSelecionado = StatusSelecionado.pendentes;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final associadoProvider = context.watch<AssociadoProvider>();
    final authProvider = context.watch<AuthProvider>();

    if (associadoProvider.associado == null || authProvider.user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: associadoProvider.loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Center(
                      child: Image.asset('assets/images/logo.png', height: 120),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: Text(
                        associadoProvider.associado?.gestao ??
                            'Gestão não informada.',
                        style: HomePageStyles.gestaoStyle,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _buildStatusButton(
                            label:
                                'Pendentes (${associadoProvider.associado!.pagamentosPendentes.length})',
                            isSelected:
                                statusSelecionado ==
                                StatusSelecionado.pendentes,
                            selectedColor: const Color(0xFFFBC02D),
                            unselectedColor: const Color(0xFFFFF9C4),
                            borderColor: const Color(0xFFFBC02D),
                            onPressed: () {
                              setState(() {
                                statusSelecionado = StatusSelecionado.pendentes;
                                pagamentos = associadoProvider
                                    .associado!
                                    .pagamentosPendentes;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildStatusButton(
                            label:
                                'Atrasados (${associadoProvider.associado!.pagamentosAtrasados.length})',
                            isSelected:
                                statusSelecionado ==
                                StatusSelecionado.atrasadas,
                            selectedColor: const Color(0xFFD32F2F),
                            unselectedColor: const Color(0xFFFFCDD2),
                            borderColor: const Color(0xFFD32F2F),
                            onPressed: () {
                              setState(() {
                                statusSelecionado = StatusSelecionado.atrasadas;
                                pagamentos = associadoProvider
                                    .associado!
                                    .pagamentosAtrasados
                                    .map((p) {
                                      p.statusNome = 'Atrasado';
                                      return p;
                                    })
                                    .toList();
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildStatusButton(
                            label:
                                'Pagos (${associadoProvider.associado!.pagamentosPagos.length})',
                            isSelected:
                                statusSelecionado == StatusSelecionado.pagas,
                            selectedColor: const Color(0xFF0097A7),
                            unselectedColor: const Color(0xFFB2EBF2),
                            borderColor: const Color(0xFF0097A7),
                            onPressed: () {
                              setState(() {
                                statusSelecionado = StatusSelecionado.pagas;
                                pagamentos = associadoProvider
                                    .associado!
                                    .pagamentosPagos;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (pagamentos.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 30.0),
                        child: Center(
                          child: Text(
                            'Nenhum pagamento encontrado',
                            style: HomePageStyles.listaVazia,
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          itemCount: pagamentos.length,
                          itemBuilder: (context, index) {
                            final p = pagamentos[index];
                            return Card(
                              color: const Color.fromARGB(255, 226, 223, 225),
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                leading: const Icon(Icons.receipt_long),
                                title: Text(
                                  'Referente: ${p.referenteMes}/${p.referenteAno}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  'Vencimento: ${p.diaVencimento}/${p.referenteMes}/${p.referenteAno}\n'
                                  'Valor: R\$ ${p.valor.toStringAsFixed(2)}\n'
                                  'Status: ${p.statusNome}',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
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
        padding: const EdgeInsets.symmetric(vertical: 12),
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
