import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/ui_elements/title_default.dart';

class ProductPage extends StatelessWidget {
  final String title;
  final String imageUrl;
  final double price;
  final String description;

  ProductPage(this.title, this.imageUrl, this.price, this.description);

  Widget _buildAddressPriceRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Union Square, San Francisco',
          style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            '|',
            style: TextStyle(color: Colors.grey, fontSize: 20),
          ),
        ),
        Text(
          '\$' + price.toString(),
          style: TextStyle(fontFamily: 'Oswald', color: Colors.grey, fontSize: 20),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
        print('Back button pressed!');
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: <Widget>[
            IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {},
          ),
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () => '',
            ),
            
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.network(imageUrl),
            Container(
              padding: EdgeInsets.all(10.0),
              child: TitleDefault(title),
            ),
            _buildAddressPriceRow(),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                description,
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  child: Icon(Icons.add_shopping_cart),
                  onPressed: () => '',
                  color: Colors.teal,
                  textColor: Colors.white,
                  
                ),
                FlatButton(
                  child: Icon(Icons.chat),
                  onPressed: () => '',
                  color: Colors.teal,
                  textColor: Colors.white,
                ),
                FlatButton(
                  child: Icon(Icons.help),
                  onPressed: () => '',
                  color: Colors.teal,
                  textColor: Colors.white,
                  
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
