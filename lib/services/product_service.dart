import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:productos_app/services/services.dart';

class ProductoService extends ChangeNotifier {
  final String _baseUrl = 'flutter-productos-453f6-default-rtdb.firebaseio.com';
  final String urlUploadImage =
      'https://api.cloudinary.com/v1_1/duaw7eayf/image/upload?upload_preset=uqz4aluy';
  final List<Producto> productos = [];
  Producto productoSeleccionado;
  bool isLoading = true;
  File newPictureFile;
  final storage = new FlutterSecureStorage();

  ProductoService() {
    this.loadProducts();
  }

  Future<List<Producto>> loadProducts() async {
    this.isLoading = true;
    notifyListeners();
    final url = Uri.https(_baseUrl, 'productos-2.json', {
      'auth': await storage.read(key: 'token') ?? '',
    });
    final resp = await http.get(url);
    final Map<String, dynamic> productosMap = json.decode(resp.body);
    productosMap.forEach((key, value) {
      final tempProd = Producto.fromJson(value);
      tempProd.id = key;
      this.productos.add(tempProd);
    });
    this.isLoading = false;
    notifyListeners();
    return this.productos;
  }

  Future guardarProducto(Producto producto) async {
    isLoading = true;
    notifyListeners();
    if (producto.id == null) {
      await this.crearProducto(producto);
    } else {
      await this.actualizarProducto(producto);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<String> actualizarProducto(Producto producto) async {
    final url = Uri.https(_baseUrl, 'productos-2/${producto.id}.json', {
      'auth': await storage.read(key: 'token') ?? '',
    });
    await http.put(
      url,
      body: productoModelToJson(ProductoModel(prod: producto)),
    );
    final index =
        this.productos.indexWhere((element) => element.id == producto.id);
    this.productos[index] = producto;
    NotificationsService.showSnackBar('Producto actualizado correctamente');
    return producto.id;
  }

  Future<String> crearProducto(Producto producto) async {
    final url = Uri.https(_baseUrl, 'productos-2.json', {
      'auth': await storage.read(key: 'token') ?? '',
    });
    final resp = await http.post(
      url,
      body: productoModelToJson(
        ProductoModel(prod: producto),
      ),
    );
    final decodedData = json.decode(resp.body);
    producto.id = decodedData['name'];
    this.productos.add(producto);
    NotificationsService.showSnackBar('Porducto guardado correctamente');
    return producto.id;
  }

  void actualizarSeleccionImagen(String path) {
    this.productoSeleccionado.picture = path;
    this.newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  Future<String> uploadImage() async {
    if (this.newPictureFile == null) return null;
    this.isLoading = true;
    notifyListeners();
    final url = Uri.parse(this.urlUploadImage);
    final imgUploadRequest = http.MultipartRequest('POST', url);
    final file = await http.MultipartFile.fromPath(
      'file',
      this.newPictureFile.path,
    );
    imgUploadRequest.files.add(file);
    final stringResponse = await imgUploadRequest.send();
    final resp = await http.Response.fromStream(stringResponse);
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      NotificationsService.showSnackBar('No fue posible guardar la imagen');
      print(resp.body);
      return null;
    }
    final decodedData = json.decode(resp.body);
    this.newPictureFile = null;
    return decodedData['secure_url'];
  }
}
