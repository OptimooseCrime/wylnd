import 'package:flutter/material.dart';
class Product {
  String title;
  String description;
  double price;
  String image;

  Product(
    {
    @required this.title, 
    @required this.description, 
    @required this.price, 
    @required this.image
    }
  );
  Map<String, dynamic> toMap() {
      return {
        'title': title,
        'description': description,
        'price': price,
        'image': image
      };
  }
  Product.fromMap(Map map) {
    this.title = map['name'];
    this.description = map['description'];
    this.price = map['price'];
    this.image = map['price'];
  }
}
