import 'package:flutter/material.dart';
import 'package:mensalidade_mts_app/features/auth/data/auth_remote_datasource.dart';
import 'package:mensalidade_mts_app/features/auth/data/auth_repository_impl.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import 'package:mensalidade_mts_app/core/network/dio_client.dart';
import 'package:mensalidade_mts_app/core/theme/app_theme.dart';
import 'package:mensalidade_mts_app/features/auth/provider/login_provider.dart';
import 'package:mensalidade_mts_app/features/auth/presentation/login_page.dart';

void main() {
  final dio = DioClient(dio: Dio()).dio;
  final authRemoteDataSource = AuthRemoteDataSource(dio);
  final authRepository = AuthRepositoryImpl(authRemoteDataSource);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider(authRepository)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu App',
      theme: AppTheme.lightTheme,
      home: LoginPage(),
    );
  }
}
