import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import './product_card.dart';
import '../../models/product.dart';
import '../../scoped-models/products.dart';
import './price_tag.dart';
import './address_tag.dart';
import '../../pages/product.dart';
import '../ui_elements/title_default.dart';

class Products extends StatelessWidget {
  Widget _buildProductList(List<Product> products) {
    Widget productCards;
    if (products.length > 0) {
      productCards = ListView.builder(
        itemBuilder: (BuildContext context, index) =>
            ProductCard(products[index], 'to'),
        itemCount: products.length,
      );
    } else {
      productCards = Container();
    }
    return productCards;
  }
  Widget buildTitlePriceRow(product) {
  //var product = new Product.fromMap(productMap);
  print(product['description']);
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(product['title']),
          SizedBox(
            width: 8.0,
          ),
          Text(product['price'].toString())
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    print('[Products Widget] build()');
        var itemStream = Firestore.instance.collection('items').snapshots();

    // **** STATE MANAGEMENT TOOLS HERE **** !!NO MORE SCOPE!!
    return StreamBuilder<QuerySnapshot>(
      stream: itemStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
               var documentData = document.data;     
                return Card(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 140,
                        child: Image.network(documentData['image']),
                      ),
                      Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(documentData['title']),
          SizedBox(
            width: 8.0,
          ),
          Text(documentData['price'].toString())
        ],
      ),
    ),
                      AddressTag('Union Square, San Francisco'),
                      ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.info),
          color: Theme.of(context).accentColor,
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(
                builder: (BuildContext context) => ProductPage(
                  documentData['title'], documentData['image'], documentData['price'], documentData['description']
                ))),
        ),
        IconButton(
          icon: Icon(Icons.favorite_border),
          color: Colors.red,
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(
                builder: (BuildContext context) => ProductPage(
                  documentData['title'], documentData['image'], documentData['price'], documentData['description']
                ))),
        ),
      ],
    ),
                    ],
                  ),
                );
               print(documentData['title']);
              }).toList(),
            );
        }
      },
        
      );
  }
}
