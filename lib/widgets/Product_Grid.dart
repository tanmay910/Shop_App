import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/Products.dart';
import 'package:shop_app/widgets/Product_Item.dart';

class Product_grid extends StatelessWidget {
  bool showfavs;
  Product_grid(this.showfavs);


  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context); // this a listener
    final products = showfavs? productsData.Fouvritesitems(): productsData.items;

    return GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15),
        itemCount: products.length,
        // itemBuilder takes context and index
        itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
          // create:(ctx)=>product[index],
         value: products[index],
            child: ProductItem(),

        ));
  }
}
