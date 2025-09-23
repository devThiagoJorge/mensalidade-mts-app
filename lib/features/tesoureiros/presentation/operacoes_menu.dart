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
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // Espaço no topo para separar o conteúdo da barra de status
            const SizedBox(height: 50),
            // Logo centralizada com tamanho ajustado
            Center(child: Image.asset('assets/images/logo.png', height: 120)),
            // Espaço entre a logo e o menu
            const SizedBox(height: 30),
            // O Card atua como um contêiner com cantos arredondados e sombra
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  children: [
                    // Menu de Associados
                    ExpansionTile(
                      leading: const Icon(Icons.people_outlined),
                      title: const Text('Associados'),
                      collapsedIconColor: Colors.black54,
                      iconColor: AppDefaultStyles.rotaractColor,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person_add_outlined),
                          title: const Text('Cadastrar Associado'),
                          selectedColor: AppDefaultStyles.rotaractColor,
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
                          title: const Text('Sinalizar mensalidade como paga'),
                          selectedColor: AppDefaultStyles.rotaractColor,
                          onTap: () {},
                        ),
                      ],
                    ),
                    // Linha separadora
                    const Divider(height: 1),

                    // Menu de Gestão
                    ExpansionTile(
                      leading: const Icon(Icons.home_outlined),
                      title: const Text('Gestão'),
                      collapsedIconColor: Colors.black54,
                      iconColor: AppDefaultStyles.rotaractColor,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.add),
                          title: const Text('Adicionar nova gestão'),
                          selectedColor: AppDefaultStyles.rotaractColor,
                          onTap: () {},
                        ),
                        ListTile(
                          leading: const Icon(Icons.attach_money),
                          title: const Text('Alterar valor mensalidade'),
                          selectedColor: AppDefaultStyles.rotaractColor,
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
                    // Linha separadora
                    const Divider(height: 1),

                    // Menu de Tesoureiros
                    ExpansionTile(
                      leading: const Icon(
                        Icons.account_balance_wallet_outlined,
                      ),
                      title: const Text('Tesoureiros'),
                      collapsedIconColor: Colors.black54,
                      iconColor: AppDefaultStyles.rotaractColor,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person_outline),
                          title: const Text('Empossar novo tesoureiro'),
                          selectedColor: AppDefaultStyles.rotaractColor,
                          onTap: () {},
                        ),
                        ListTile(
                          leading: const Icon(Icons.person_remove_outlined),
                          title: const Text('Encerrar mandato tesoureiro'),
                          selectedColor: AppDefaultStyles.rotaractColor,
                          onTap: () {},
                        ),
                      ],
                    ),
                    // Linha separadora
                    const Divider(height: 1),

                    // Item de Configurações
                    ListTile(
                      leading: const Icon(Icons.settings_outlined),
                      title: const Text('Configurações'),
                      selectedColor: AppDefaultStyles.rotaractColor,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
            // Espaço no final para evitar que o conteúdo fique colado na borda inferior
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
