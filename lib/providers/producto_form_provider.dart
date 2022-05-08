import 'package:flutter/material.dart';
import 'package:productos_app/models/product.dart';

class ProductFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  Producto producto;

  ProductFormProvider(this.producto);

  bool isFormValid() {
    return this.formKey.currentState.validate() ?? false;
  }

  actualizarEstado(bool estado) {
    this.producto.available = estado;
    notifyListeners();
  }
}
