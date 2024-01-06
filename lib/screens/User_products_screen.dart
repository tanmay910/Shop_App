import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/Products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/AppDrawer.dart';
import 'package:shop_app/widgets/User_product_item.dart';

import '../models/auth.dart';

class UserProductsScreen extends StatelessWidget {
  static const String id = 'UserProductScreen';

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchandSetData(true);
  }

  @override
  Widget build(BuildContext context) {
    //final ProductData = Provider.of<Products>(context);
    // initially when we not use future builder initially products fetch in product overview screen is used
    // here but on refresh it gets fetch  again
    // now when we want different product for user-products screen we can not use same products list
    // before we do refresh we list of all products as it uses same list on refresh we get user view products
    // but we want as user products screen get display it show user view products
    // that why we use future builder to as in future argument it again fetches products list with filter

    return Scaffold(
      drawer: Appdrawer(),
      appBar: AppBar(
        title: Text('your products'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.id);
              },
              icon: Icon(Icons.add)),
        ],
      ),
      body: FutureBuilder(
        future: _refreshProduct(context),
        builder: (ctx,snapshot)=> snapshot.connectionState == ConnectionState.waiting ?
        Center(child: CircularProgressIndicator()):RefreshIndicator(
          onRefresh: () => _refreshProduct(context),
          child: Consumer<Products>(
            builder: (ctx,ProductData,_)=> Padding(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                  itemCount: ProductData.items.length,
                  itemBuilder: (_, i) => Column(
                        children: [
                          UserProductItem(
                            id: ProductData.items[i].id,
                            title: ProductData.items[i].title,
                            imageUrl: ProductData.items[i].imageUrl,
                          ),
                          Divider(),
                        ],
                      )),
            ),
          ),
        ),
      ),
    );
  }
}
