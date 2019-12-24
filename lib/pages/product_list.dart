import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './product_edit.dart';
import '../models/product.dart';

class ProductListPage extends StatelessWidget {
  final Function updateProduct;
  final Function deletePreoduct;
  final List<Product> products;

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
  var itemStream = Firestore.instance.collection('items').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: itemStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return ListView(
      padding: EdgeInsets.all(20.0),
      children: snapshot.data.documents.map((DocumentSnapshot document) {
        return new Dismissible(
          key: Key(document.documentID),
          onDismissed: (DismissDirection direction) {
            if (direction == DismissDirection.endToStart) {
              print('Swipe delete');
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    document['image'],
                    scale: 50,
                    ),
              ),
              contentPadding: EdgeInsets.all(10),
              title: Text(document['title']),
              subtitle: Text('\$${document["price"].toString()}'),
              trailing: _buildEditButton(context, 4),
            ),
          ),
        );
      }).toList(),
    );
      }
    );
    
  }
}
