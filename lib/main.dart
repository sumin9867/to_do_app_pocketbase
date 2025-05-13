import 'package:flutter/material.dart';
import 'package:to_do_app_with_pocketbase/core/presentation/app_router.dart';
import 'package:to_do_app_with_pocketbase/core/presentation/app_theme.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,     
      routerConfig: appRouter,        
    );
  }
}
