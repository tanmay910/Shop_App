import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/Products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/AppDrawer.dart';
import 'package:shop_app/widgets/User_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const String id = 'UserProductScreen';

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchandSetData();
  }

  @override
  Widget build(BuildContext context) {
    final ProductData = Provider.of<Products>(context);

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
      body: RefreshIndicator(
        onRefresh: () => _refreshProduct(context),
        child: Padding(
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
    );
  }
}
