import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop_app/models/orders.dart';
import '../models/orders.dart';
import 'package:intl/intl.dart';

class OrderItemcard extends StatefulWidget {
  final OrderItem order;
  OrderItemcard({required this.order});

  @override
  State<OrderItemcard> createState() => _OrderItemcardState();
}

class _OrderItemcardState extends State<OrderItemcard> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
                DateFormat('dd MM yyyy hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              icon:
                  _expanded ? Icon(Icons.expand_more) : Icon(Icons.expand_less),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });

              },
            ),
          ),
          if (_expanded) Container(
            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
            height: min(widget.order.products.length *20.0 +100,180.0),
            child: ListView(
              children: widget.order.products.map((prod) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      prod.title,
                      softWrap: true,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),

                  Text(
                    '${prod.quantity}x \$${prod.price}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,

                    ),
                  )


                ],
              )).toList(),
            ),

          ),
        ],
      ),
    );
  }
}
