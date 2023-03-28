import 'package:flutter/material.dart';
import '../providers/cart.dart';
import 'package:provider/provider.dart';

class Cart_item extends StatelessWidget {
  final String? id;
  final String? producId;
  final double? price;
  final String? title;
  final int? quantity;

  Cart_item({this.producId, this.id, this.quantity, this.price, this.title});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(this.id),
      background: Container(
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 50,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false)
            .removeItem(this.producId.toString());
      },
      // confirmDismiss should return Future<bool> future boolean
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  content: Text('Do you want to remove item form cart'),
                  title: Text('Are you sure?'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(ctx, false);
                        },
                        child: Text('NO')),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(ctx, true);
                        },
                        child: Text('YES')),
                  ],
                ));
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Padding(
              padding: const EdgeInsets.all(10.0),
              child: FittedBox(
                  child: CircleAvatar(
                child: Text('\$$price'),
              )),
            ),
            title: Text(title!),
            subtitle: Text('\$ ${price! * quantity!}'),
            trailing: Text('\$$quantity x'),
          ),
        ),
      ),
    );
  }
}
