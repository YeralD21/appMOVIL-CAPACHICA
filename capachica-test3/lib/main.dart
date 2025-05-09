//import 'package:capachica/features/panels/emprendedor/data/repositories/emprendedor_repository.dart';
//import 'package:capachica/features/panels/super_admin/data/repositories/superadmin_repository.dart';
//import 'package:capachica/features/panels/super_admin/providers/superadmin_provider.dart';
//import 'package:capachica/features/panels/user/data/repositories/user_repository.dart';
import 'package:capachica/core/api/api_client.dart';
import 'package:capachica/features/panels/emprendedor/data/repositories/emprendedor_repository.dart';
import 'package:capachica/features/panels/superadmin/data/repositories/superadmin_repository.dart';
import 'package:capachica/features/panels/user/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'features/auth/presentation/screens/register_screen.dart';

// Importa tus providers y screens
import 'features/panels/superadmin/providers/superadmin_provider.dart';
import 'features/panels/superadmin/presentation/screens/superadmin_home_screen.dart';

import 'features/panels/emprendedor/providers/emprendedor_provider.dart';
import 'features/panels/emprendedor/presentation/screens/emprendedor_home_screen.dart';

import 'features/panels/user/providers/user_provider.dart';
import 'features/panels/user/presentation/screens/user_home_screen.dart';

// Importa tu AuthProvider (debes tener uno que maneje login y rol)
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/presentation/screens/login_screen.dart';

import 'features/panels/superadmin/providers/permiso_provider.dart';
import 'features/panels/superadmin/data/repositories/permiso_repository.dart';

void main() {
  final apiClient = ApiClient();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(apiClient)),
        ChangeNotifierProvider(create: (_) => SuperAdminProvider(SuperAdminRepository())),
        ChangeNotifierProvider(create: (_) => EmprendedorProvider(EmprendedorRepository())),
        ChangeNotifierProvider(create: (_) => UserProvider(UserRepository())),
        ChangeNotifierProvider(
          create: (context) => PermisoProvider(
            PermisoRepository(apiClient),
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        Widget home;

        if (authProvider.status == AuthStatus.authenticated) {
          // Cambia esto según cómo guardes el rol (puede ser authProvider.userRole)
          switch (authProvider.userRole) {
            case 'superadmin':
              home = SuperAdminHomeScreen();
              break;
            case 'emprendedor':
              home = EmprendedorHomeScreen();
              break;
            case 'user':
              home = UserHomeScreen();
              break;
            default:
              home = LoginScreen();
          }
        } else {
          home = LoginScreen();
        }

        return MaterialApp(
          title: 'App por Roles',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: home,
          routes: {
            '/login': (_) => LoginScreen(),
            '/register': (_) => RegisterScreen(), 
            '/superadmin': (_) => SuperAdminHomeScreen(),
            '/emprendedor': (_) => EmprendedorHomeScreen(),
            '/user': (_) => UserHomeScreen(),
          },
        );
      },
    );
  }
}