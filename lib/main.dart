import 'package:flutter/material.dart';
import 'package:mensalidade_mts_app/core/network/api_service.dart';
import 'package:mensalidade_mts_app/core/theme/app_theme.dart';
import 'package:mensalidade_mts_app/features/associados/associado_service.dart';
import 'package:mensalidade_mts_app/features/associados/providers/associado_provider.dart';
import 'package:mensalidade_mts_app/features/auth/auth_gate.dart';
import 'package:mensalidade_mts_app/features/auth/auth_service.dart';
import 'package:mensalidade_mts_app/features/auth/providers/auth_provider.dart';
import 'package:mensalidade_mts_app/features/auth/providers/primeiro_acesso_provider.dart';
import 'package:mensalidade_mts_app/features/pagamentos/pagamento_service.dart';
import 'package:mensalidade_mts_app/features/pagamentos/providers/pagamento_provider.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Dio configurado
  final dio = Dio(
    BaseOptions(
      baseUrl: const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'https://mensalidademts.onrender.com',
      ),
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  final api = ApiService(dio);
  final authService = AuthService(api);
  final associadoService = AssociadoService(api);
  final pagamentosService = PagamentoService(api);

  runApp(
    MyApp(
      authService: authService,
      associadoService: associadoService,
      pagamentosService: pagamentosService,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  final AssociadoService associadoService;
  final PagamentoService pagamentosService;
  const MyApp({
    super.key,
    required this.authService,
    required this.associadoService,
    required this.pagamentosService,
  });
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authService)),
        ChangeNotifierProvider(
          create: (_) => PrimeiroAcessoProvider(authService),
        ),
        ChangeNotifierProvider(
          create: (_) => AssociadoProvider(associadoService),
        ),
        ChangeNotifierProvider(
          create: (_) => PagamentoProvider(pagamentosService),
        ),
      ],
      child: MaterialApp(
        title: 'Mensalidades MTS',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const AuthGate(),
      ),
    );
  }
}
