import 'package:flutter/material.dart';

import './product_card.dart';
import '../../models/product.dart';

class Products extends StatelessWidget {
  final List<Product> products;

  Products(this.products) {
    print('[Products Widget] Constructor');
  }

  Widget _buildProductList() {
    Widget productCards;
    if (products.length > 0) {
      productCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            ProductCard(products[index], index),
        itemCount: products.length,
      );
    } else {
      productCards = Container();
    }
    return productCards;
  }

  @override
  Widget build(BuildContext context) {
    print('[Products Widget] build()');
    return _buildProductList();
  }
}
