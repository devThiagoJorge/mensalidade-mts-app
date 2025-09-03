import 'package:flutter/material.dart';
import 'package:mensalidade_mts_app/core/componentsStyle/default/app_default_styles.dart';
import 'package:mensalidade_mts_app/features/associados/presentation/associado_home_page.dart';
import 'package:mensalidade_mts_app/features/associados/presentation/associado_meu_perfil.dart';
import 'package:mensalidade_mts_app/features/tesoureiros/presentation/tesoureiro_home_page.dart';

class MenuTesoureiro extends StatefulWidget {
  const MenuTesoureiro({super.key});

  @override
  State<MenuTesoureiro> createState() => _MenuTesoureiroState();
}

class _MenuTesoureiroState extends State<MenuTesoureiro> {
  int _indiceAtual = 0;
  final List<Widget> _telas = [const TesoureiroHomePage(), const MeuPerfil()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _telas[_indiceAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        onTap: onTabTapped,
        selectedItemColor: AppDefaultStyles.rotaractColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Página inicial',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Operações',
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _indiceAtual = index;
    });
  }
}
