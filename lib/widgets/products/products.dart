import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import './product_card.dart';
import '../../models/product.dart';
import '../../scoped-models/products.dart';

class Products extends StatelessWidget {
  Widget _buildProductList(List<Product> products) {
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

<<<<<<< Updated upstream
  @override
  Widget build(BuildContext context) {
    print('[Products Widget] build()');
    // **** STATE MANAGEMENT TOOLS HERE ****
    return ScopedModelDescendant<ProductsModel>(
      builder: (BuildContext context, Widget child, ProductsModel model) {
        // ^^ 'ProductsModel' INHERITS FROM 'Model'
        return _buildProductList(model.products);
        //^^ PASSED IN FROM SCOPED MODEL WHENEVER MODEL CHANGES^^
=======
  Widget buildTitlePriceRow(context, product) {
    //var product = new Product.fromMap(productMap);
    print(product['description']);
    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 5),
      child: FlatButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => ProductPage(
              product['title'],
              product['image'],
              product['price'],
              product['description'],
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              product['title'],
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
            Text(
              product['price'].toString(),
              softWrap: true,
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
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
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                var documentData = document.data;
                return Container(
                  margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                  padding: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                  ),
                  child: Column(
                    children: <Widget>[
                      buildTitlePriceRow(context, documentData),
                      Card(
                        child: SizedBox(
                          height: 230,
                          child: Image.network(documentData['image']),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),
                      AddressTag('San Francisco, Ca'),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                      ),
                      Text("5 miles away"),
                      /*ButtonBar(
                        alignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.description),
                            iconSize: 32,
                            color: Color(0xff2011a2),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ProductPage(
                                            documentData['title'],
                                            documentData['image'],
                                            documentData['price'],
                                            documentData['description']))),
                          ),
                          IconButton(
                            icon: Icon(Icons.email),
                            iconSize: 32,
                            color: Color(0xffff34b3),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ProductPage(
                                            documentData['title'],
                                            documentData['image'],
                                            documentData['price'],
                                            documentData['description']))),
                          ),
                          IconButton(
                            icon: Icon(Icons.shopping_basket),
                            iconSize: 32,
                            color: Colors.greenAccent,
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ProductPage(
                                            documentData['title'],
                                            documentData['image'],
                                            documentData['price'],
                                            documentData['description']))),
                          ),
                        ],
                      ),*/
                    ],
                  ),
                );
              }).toList(),
            );
        }
>>>>>>> Stashed changes
      },
    );
  }
}
