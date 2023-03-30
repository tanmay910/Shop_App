import 'package:flutter/material.dart';
import 'package:shop_app/models/productModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/http_Exception.dart';

// this central location where we store product list
// to using provider we can rebuilt app parts which use this data

// changeNotifier mixin is present in material.dart
// we used it because provider in background use this
// to listen the changes

class Products with ChangeNotifier {


  final String authToken;
  final String UserId;





  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    // if(_showFavoriteOnly){
    //   return items.where((prod)=>  prod.isFavorite==true).toList();
    // }
    return [..._items];
  }

  List<Product> Fouvritesitems() {
    return items.where((element) => element.isFavorite == true).toList();
  }

// to see products on user products screen
  // to filter such  that only we can see products created by current user
  // we apply fliter at server side by
  Future<void> fetchandSetData([bool filterby=false]) async {
    // to apply filter add rules "products":{".indexOn:["creatorID]} on server rules

    final filterString = filterby ?'orderBy="creatorID"&equalTo="$UserId"' : '';
    var url =
        'https://shop-app-3bd1d-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';
    try{
      final response = await http.get(Uri.parse(url));
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
      if(extractedData == null) return;

      url= 'https://shop-app-3bd1d-default-rtdb.firebaseio.com/userFavourite/$UserId.json?auth=$authToken';
      final FavouriteResponse= await http.get(Uri.parse(url));
      final FavouriteData= jsonDecode(FavouriteResponse.body);


      List<Product> loadedProduct = [];
      extractedData.forEach((prodID, prodData) {
        loadedProduct.add(
          Product(
            id: prodID,
            description: prodData['description'],
            imageUrl: prodData['imageUrl'],
            price: prodData['price'].toDouble(),
            title: prodData['title'],
            isFavorite: FavouriteData == null ? false :FavouriteData[prodID] ?? false,


          ),
        );
      });

      _items=loadedProduct;
      notifyListeners();
    }catch(error){

      throw (error);
      
    }



  }
  Products(this.authToken,this._items,this.UserId);

  Future<void> addproduct(Product product) async {
    final url =
        'https://shop-app-3bd1d-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorID': UserId,
          }));
      final newProduct = Product(
          id: jsonDecode(response.body)['name'],
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price,
          title: product.title);

      _items.add(newProduct);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Product findByID(String id) {
    return _items.firstWhere((element) =>
        element.id ==
        id); // .firstWhere method takes a lamada function and return the element form items
    // which  satisfy the condition
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final index = _items.indexWhere((element) => element.id == id);
    if (index >= 0) {
      try{
        final url= 'https://shop-app-3bd1d-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
        await http.patch(Uri.parse(url),body:  jsonEncode(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          }
        ));
        _items[index] = newProduct;
        notifyListeners();

      }catch(error){
        throw (error);
      }

    }
  }

  Future<void> deleteProduct(String id) async{
    final url= 'https://shop-app-3bd1d-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex=_items.indexWhere((element) => element.id == id);
    Product? existingProduct=_items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    await http.delete(Uri.parse(url))
        .then((response) {
          if(response.statusCode >=400)
            {
              _items.insert(existingProductIndex, existingProduct!);
              notifyListeners();
             throw httpException('could not delete product');

            }

      existingProduct=null;
    });



  }
}
