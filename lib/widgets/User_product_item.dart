import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

import '../providers/Products.dart';

class UserProductItem extends StatelessWidget {
  final String? title;
  final String? imageUrl;
  final String? id;
  UserProductItem({this.id, this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final scaffold= ScaffoldMessenger.of(context);

    return ListTile(
      title: Text(title!),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl!),
      ),
      trailing: Container(
        width: 100,
        child: Row(children: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, EditProductScreen.id,
                  arguments: this.id);
            },
            icon: Icon(Icons.edit),
            color: Theme.of(context).primaryColor,
          ),
          IconButton(
            onPressed: () async {
              try {
               await Provider.of<Products>(context, listen: false)
                    .deleteProduct(id!);
              } catch (e) {
               scaffold
                    .showSnackBar(SnackBar(content: Text('Deletion failed')));
              }
            },
            icon: Icon(Icons.delete),
            color: Theme.of(context).colorScheme.error,
          )
        ]),
      ),
    );
  }
}
