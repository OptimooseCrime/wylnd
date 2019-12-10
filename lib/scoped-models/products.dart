// STATE MANAGEMENT. Can be switched with Bloc, redux, provider etc
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductsModel extends Model {
  List<Product> _products = [];

  List<Product> get products {
    return List.from(_products);
  }

  void addProduct(Product product) {
    
    _products.add(product);
    Map productMap = product.toMap();
    var itemsCollection = Firestore.instance.collection('items').add(product.toMap());
  }

  void updateProduct(int index, Product product) {
    _products[index] = product;
  }

  void deleteProduct(int index) {
    _products.removeAt(index);
  }
}
