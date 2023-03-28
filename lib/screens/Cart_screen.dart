import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/cart_item.dart';

import '../providers/cart.dart';
import '../models/orders.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  static const String id = 'cartScreen';



  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .titleSmall
                              ?.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: cart.item.length,
                itemBuilder: (ctx, i) => Cart_item(
                      id: cart.item.values.toList()[i].id,
                      producId: cart.item.keys.toList()[i],
                      title: cart.item.values.toList()[i].title,
                      price: cart.item.values.toList()[i].price,
                      quantity: cart.item.values.toList()[i].quantity,
                    )),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    super.key,
    required this.cart,
  });

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var isLoading=false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: widget.cart.totalAmount<=0? null :  () async{
          setState(() {
            isLoading=true;
          });
         await Provider.of<Orders>(context,listen: false).addorder(
              widget.cart.item.values.toList(), widget.cart.totalAmount);
         setState(() {
           isLoading=false;
         });
          widget.cart.clearCart();
        },
        child:isLoading? CircularProgressIndicator(): Text(
          'ORDER NOW',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ));
  }
}
