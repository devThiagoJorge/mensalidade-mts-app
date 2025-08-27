import 'package:flutter/material.dart';
import 'package:mensalidade_mts_app/core/components/associado/home_page_styles.dart';

class AssociadoHomePage extends StatefulWidget {
  const AssociadoHomePage({super.key});

  @override
  State<AssociadoHomePage> createState() => _AssociadoHomePageState();
}

class _AssociadoHomePageState extends State<AssociadoHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Center(
              child: Text(
                '2025-2026: Unidos para Fazer o Bem',
                style: HomePageStyles.gestaoStyle,
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildStatusButton(
                    label: 'Pendentes (8)',
                    bgColor: const Color(0xFFFFF9C4),
                    borderColor: const Color(0xFFFBC02D),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatusButton(
                    label: 'Atrasados (3)',
                    bgColor: const Color(0xFFFFCDD2),
                    borderColor: const Color(0xFFD32F2F),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatusButton(
                    label: 'Pagos (1)',
                    bgColor: const Color(0xFFB2EBF2),
                    borderColor: const Color(0xFF0097A7),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            const Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text('Gestão 25/26'),
                    subtitle: Text('Vencimento'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton({
    required String label,
    required Color bgColor,
    required Color borderColor,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: bgColor,
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
