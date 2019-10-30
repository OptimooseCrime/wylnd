import 'package:flutter/material.dart';

import './product_edit.dart';

class ProductListPage extends StatelessWidget {
  final Function updateProduct;
  final Function deletePreoduct;
  final List<Map<String, dynamic>> products;

  ProductListPage(this.products, this.updateProduct, this.deletePreoduct);

  Widget _buildEditButton(BuildContext context, int index){
    return IconButton(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(20.0),
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: Key(products[index]['title']),
          onDismissed: (DismissDirection direction) {
            if (direction == DismissDirection.endToStart) {
              print('Swipe delete');
              deletePreoduct(index);
            } else if (direction == DismissDirection.startToEnd) {
              print('Start to end');
            } else {
              print('other swiping occured');
            }
          },
          background: Container(
            child: Icon(Icons.delete),
            // child: Text('DELETE? \n >>>>'),
            color: Colors.red[300],
          ),
          child: Card(
            child: ListTile(
              leading: CircleAvatar(
                  backgroundImage: AssetImage(products[index]['image'])),
              contentPadding: EdgeInsets.all(10),
              title: Text(products[index]['title']),
              subtitle: Text('\$${products[index]['price'].toString()}'),
              trailing: _buildEditButton(context, index)
            ),
          ),
        );
      },
      itemCount: products.length,
    );
  }
}
