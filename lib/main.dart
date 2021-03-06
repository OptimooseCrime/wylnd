import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';

import './pages/auth.dart';
import './pages/products_admin.dart';
import './pages/products.dart';
import './pages/product.dart';
import './models/product.dart';
import './scoped-models/products.dart';

void main() {
  // debugPaintSizeEnabled = true;
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
// ************* MOVED TO BE MANAGED BY SCOPED MODEL *************
  // List<Product> products = [];
  // void _addProduct(Product product) {
  //   setState(() {
  //     _products.add(product);
  //   });
  //   print(_products);
  // }

  // void _updateProduct(int index, Product product) {
  //   setState(() {
  //     _products[index] = product;
  //   });
  // }

  // void _deleteProduct(int index) {
  //   setState(() {
  //     _products.removeAt(index);
  //   });
  // }
  // ************* MOVED TO BE MANAGED BY SCOPED MODEL *************

  @override
  Widget build(BuildContext context) {
    return new ScopedModel<ProductsModel>(
      model: new ProductsModel(),
      child: new MaterialApp(
        // debugShowMaterialGrid: true,
        theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.teal,
            accentColor: Colors.deepPurple,
            buttonColor: Colors.deepPurple),
        // home: AuthPage(),
        routes: {
          '/': (BuildContext context) => AuthPage(),
          '/products': (BuildContext context) => ProductsPage(),
          '/admin': (BuildContext context) => ProductsAdminPage(),
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'product') {
            final int index = int.parse(pathElements[2]);
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) =>
                  ProductPage(null, null, null, null),
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => ProductsPage());
        },
      ),
    );
    //^^ Setting the MaterialApp up inside the ScopedModel means it gets passed down without using the constructors. Instead passes it down to all child widgets. This allows us to set it up without any manual data passing
  }
}
