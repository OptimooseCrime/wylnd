import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user.dart';
import '../pages/products_admin.dart';
import '../widgets/products/products.dart';

class ProductsPage extends StatelessWidget {
  FirebaseUser user;

  ProductsPage({this.user});
  
  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Menu'),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text(user.email+' Account'),
            onTap: () {
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => UserAccount(user: user)
              )
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Listings'),
            onTap: () {
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => ProductsAdminPage(user: user)
              ));
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: Text('WYLND'),
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
      body: Products(),
    );
  }
}
