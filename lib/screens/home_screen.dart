import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/screens/loading_screen.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productoService = Provider.of<ProductoService>(context);
    final registerService = Provider.of<RegisterService>(
      context,
      listen: false,
    );

    if (productoService.isLoading) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
        actions: [
          IconButton(
            icon: Icon(Icons.login_outlined),
            onPressed: () {
              registerService.logout();
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),
        ],
        //Es para el incicio del appbar
        //leading: IconButton(icon: Icon(Icons.login_outlined), onPressed: onPressed),
      ),
      body: ListView.builder(
        itemCount: productoService.productos.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              child: ProductCard(
                product: productoService.productos[index],
              ),
              onTap: () {
                productoService.productoSeleccionado =
                    productoService.productos[index].copiar();
                Navigator.pushNamed(context, 'product');
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          productoService.productoSeleccionado = new Producto(
            available: false,
            name: '',
            price: 0,
          );
          Navigator.pushNamed(context, 'product');
        },
      ),
    );
  }
}
