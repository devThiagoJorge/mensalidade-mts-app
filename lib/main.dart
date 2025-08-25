import 'package:flutter/material.dart';
import 'package:mensalidade_mts_app/core/network/api_service.dart';
import 'package:mensalidade_mts_app/core/theme/app_theme.dart';
import 'package:mensalidade_mts_app/features/auth/auth_service.dart';
import 'package:mensalidade_mts_app/features/auth/presentation/login_page.dart';
import 'package:mensalidade_mts_app/features/auth/presentation/primeiro_acesso.dart';
import 'package:mensalidade_mts_app/features/auth/providers/auth_provider.dart';
import 'package:mensalidade_mts_app/features/auth/providers/primeiro_acesso_provider.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Dio configurado
  final dio = Dio(
    BaseOptions(
      baseUrl: const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'https://mensalidademts.onrender.com', // troque pelo seu
      ),
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  // Camada de rede/serviço
  final api = ApiService(dio);
  final authService = AuthService(api);

  runApp(MyApp(authService: authService));
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  const MyApp({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Sessão/login (vida toda do app)
        ChangeNotifierProvider(create: (_) => AuthProvider(authService)),
        // Fluxo de onboarding (primeiro acesso)
        ChangeNotifierProvider(
          create: (_) => PrimeiroAcessoProvider(authService),
        ),
      ],
      child: MaterialApp(
        title: 'Mensalidades MTS',
        theme: AppTheme.lightTheme, // ou ThemeData(...)
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
        routes: {'/primeiro-acesso': (_) => const PrimeiroAcesso()},
      ),
    );
  }
}
