import 'dart:convert';
import 'package:flutter/material.dart';

ProductoModel productoModelFromJson(String str) =>
    ProductoModel.fromJson(json.decode(str));

String productoModelToJson(ProductoModel data) => json.encode(data.toJson());

class ProductoModel {
  ProductoModel({
    this.prod,
  });

  Producto prod;

  factory ProductoModel.fromJson(Map<String, dynamic> json) => ProductoModel(
        prod: Producto.fromJson(json["prod"]),
      );

  Map<String, dynamic> toJson() => prod.toJson();
}

class Producto {
  Producto({
    @required this.available,
    @required this.name,
    this.picture,
    @required this.price,
    this.id,
  });

  bool available;
  String name;
  String picture;
  int price;
  String id;

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        available: json["available"],
        name: json["name"],
        picture: json["picture"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "available": available,
        "name": name,
        "picture": picture,
        "price": price,
      };

  Producto copiar() => Producto(
        available: this.available,
        name: this.name,
        price: this.price,
        picture: this.picture,
        id: this.id,
      );
}
