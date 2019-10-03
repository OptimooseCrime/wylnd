import 'package:flutter/material.dart';

import './product_edit.dart';

class ProductListPage extends StatelessWidget {
  final Function updateProduct;
  final List<Map<String, dynamic>> products;

  ProductListPage(this.products, this.updateProduct);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(20.0),
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            leading: Image.asset(products[index]['image']),
            contentPadding: EdgeInsets.all(10),
            title: Text(products[index]['title']),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return ProductEditPage(
                        product: products[index],
                        updateProduct: updateProduct,
                        productIndex: index,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
      itemCount: products.length,
    );
  }
}
