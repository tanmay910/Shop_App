import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/Products.dart';

class ProductDetails extends StatelessWidget {
  static const String id = 'ProductDetails';

  @override
  Widget build(BuildContext context) {
    final ProductId = ModalRoute.of(context)?.settings.arguments
        as String; // this give us id of product which we pass to navigator of prodect item

    final loadedProduct =
        Provider.of<Products>(context, listen: false).findByID(ProductId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '\$${loadedProduct.price}',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                height: 20,
                width: double.infinity,
                child: Text(
                  loadedProduct.description,
                  softWrap: true,
                  textAlign: TextAlign.center,
                )),
          ],
        ),
      ),
    );
  }
}
