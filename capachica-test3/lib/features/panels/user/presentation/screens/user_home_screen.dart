import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import 'package:capachica/features/auth/providers/auth_provider.dart';

class UserHomeScreen extends StatefulWidget {
  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar el perfil automáticamente al entrar a la pantalla
    Future.microtask(() =>
      Provider.of<UserProvider>(context, listen: false).loadProfile()
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('User Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              await Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: Center(
        child: provider.profile == null
            ? CircularProgressIndicator()
            : Text('Bienvenido, ${provider.profile!.name}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => provider.loadProfile(),
        child: Icon(Icons.refresh),
      ),
    );
  }
}