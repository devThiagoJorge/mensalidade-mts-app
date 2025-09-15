import 'package:flutter/material.dart';
import 'package:mensalidade_mts_app/core/componentsStyle/default/app_default_styles.dart';
import 'package:mensalidade_mts_app/features/gestoes/presentation/atualizar_mensalidade_gestao.dart';
import 'package:mensalidade_mts_app/features/tesoureiros/presentation/cadastrar_associado.dart';

class OperacoesMenu extends StatelessWidget {
  const OperacoesMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          children: [
            Center(child: Image.asset('assets/images/logo.png', height: 160)),
            Expanded(
              child: ListView(
                children: [
                  ExpansionTile(
                    leading: const Icon(Icons.people_outline),
                    title: const Text('Associados'),
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person_add_outlined),
                        selectedColor: AppDefaultStyles.rotaractColor,
                        title: const Text('Cadastrar Associado'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CadastroAssociadoPage(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.check_circle_outline),
                        selectedColor: AppDefaultStyles.rotaractColor,
                        title: const Text('Sinalizar mensalidade como paga'),
                        onTap: () {},
                      ),
                    ],
                  ),
                  ExpansionTile(
                    leading: const Icon(Icons.home_outlined),
                    title: const Text('Gestão'),
                    children: [
                      ListTile(
                        leading: const Icon(Icons.add),
                        selectedColor: AppDefaultStyles.rotaractColor,
                        title: const Text('Adicionar nova gestão'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.attach_money),
                        selectedColor: AppDefaultStyles.rotaractColor,
                        title: const Text('Alterar valor mensalidade'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const AtualizarMensalidadeModal(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                    leading: const Icon(Icons.account_balance_wallet_outlined),
                    title: const Text('Tesoureiros'),
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person_outline),
                        selectedColor: AppDefaultStyles.rotaractColor,
                        title: const Text('Empossar novo tesoureiro'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.person_remove_outlined),
                        selectedColor: AppDefaultStyles.rotaractColor,
                        title: const Text('Encerrar mandato tesoureiro'),
                        onTap: () {},
                      ),
                    ],
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings_outlined),
                    selectedColor: AppDefaultStyles.rotaractColor,
                    title: const Text('Configurações'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
