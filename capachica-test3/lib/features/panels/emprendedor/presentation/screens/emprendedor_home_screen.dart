import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/emprendedor_provider.dart';
import 'package:capachica/features/auth/providers/auth_provider.dart';

class EmprendedorHomeScreen extends StatefulWidget {
  @override
  State<EmprendedorHomeScreen> createState() => _EmprendedorHomeScreenState();
}

class _EmprendedorHomeScreenState extends State<EmprendedorHomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
      Provider.of<EmprendedorProvider>(context, listen: false).loadProfile()
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EmprendedorProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Emprendedor Home'),
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
            : Text('Bienvenido, ${provider.profile!.name} de ${provider.profile!.businessName}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => provider.loadProfile(),
        child: Icon(Icons.refresh),
      ),
    );
  }
}