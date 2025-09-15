import 'package:flutter/material.dart';
import 'package:mensalidade_mts_app/core/componentsStyle/login/app_text_styles_login.dart';

class SnackbarHelper {
  static void mostrarSucesso(BuildContext context, String mensagem) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensagem),
          backgroundColor: AppTextStylesLogin.rotaractColor,
        ),
      );
    });
  }

  static void mostrarErro(BuildContext context, String mensagem) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagem), backgroundColor: Colors.redAccent),
      );
    });
  }
}
