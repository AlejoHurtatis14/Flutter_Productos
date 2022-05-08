import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:productos_app/providers/producto_form_provider.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productoService = Provider.of<ProductoService>(context);
    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(productoService.productoSeleccionado),
      child: _ProductScreenBody(productoService: productoService),
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    Key key,
    @required this.productoService,
  }) : super(key: key);

  final ProductoService productoService;

  @override
  Widget build(BuildContext context) {
    final providerProducto = Provider.of<ProductFormProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        //keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage(
                  url: productoService.productoSeleccionado.picture,
                ),
                Positioned(
                  top: 50,
                  left: 20,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, size: 40, color: Colors.grey),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                Positioned(
                  top: 50,
                  right: 20,
                  child: IconButton(
                    icon: Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                    onPressed: () async {
                      final _picker = new ImagePicker();
                      final XFile pickedFile = await _picker.pickImage(
                        source: ImageSource.camera,
                        imageQuality: 100,
                      );
                      if (pickedFile == null) return;
                      productoService.actualizarSeleccionImagen(
                        pickedFile.path,
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 50,
                  right: 70,
                  child: IconButton(
                    icon: Icon(Icons.image, size: 40, color: Colors.grey),
                    onPressed: () async {
                      final _picker = new ImagePicker();
                      final XFile pickedFile = await _picker.pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 100,
                      );
                      if (pickedFile == null) return;
                      productoService.actualizarSeleccionImagen(
                        pickedFile.path,
                      );
                    },
                  ),
                ),
              ],
            ),
            _ProductForm(),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: productoService.isLoading
            ? CircularProgressIndicator(backgroundColor: Colors.white)
            : Icon(Icons.save_outlined),
        onPressed: productoService.isLoading
            ? null
            : () async {
                if (!providerProducto.isFormValid()) return;

                final String imgeUrl = await productoService.uploadImage();
                if (imgeUrl != null) {
                  providerProducto.producto.picture = imgeUrl;
                }
                await productoService.guardarProducto(
                  providerProducto.producto,
                );
              },
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productoFormProvider = Provider.of<ProductFormProvider>(context);
    final productoForm = productoFormProvider.producto;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 250,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: productoFormProvider.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nombre del producto',
                  labelText: 'Nombre:',
                ),
                initialValue: productoForm.name,
                onChanged: (value) => productoForm.name = value,
                validator: (value) {
                  if (value == null || value.length < 1) {
                    return 'El nombre es obligatorio';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: '${productoForm.price}',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^(\d+)?\.?\d{0,2}'),
                  )
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                  hintText: '\$150',
                  labelText: 'Precio: ',
                ),
                onChanged: (value) {
                  if (double.tryParse(value) == null) {
                    productoForm.price = 0;
                  } else {
                    productoForm.price = int.parse(value);
                  }
                },
              ),
              SizedBox(height: 10),
              SwitchListTile.adaptive(
                value: productoForm.available,
                title: Text('Disponible'),
                activeColor: Colors.indigo,
                onChanged: productoFormProvider.actualizarEstado,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(25),
          bottomLeft: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, 5),
            blurRadius: 5,
          )
        ],
      );
}
