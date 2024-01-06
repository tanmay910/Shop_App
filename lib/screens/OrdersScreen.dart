import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/orders.dart';
import '../models/auth.dart';
import '../widgets/OrderItemcards.dart';
import '../widgets/AppDrawer.dart';

// @override
// void initState() {
//   //
//   // Future.delayed(Duration.zero).then((_) async{
//   //   setState(() {
//   //     _isLoading =true;
//   //
//   //   });
//   //   await Provider.of<Orders>(context,listen: false).fetchAndSetOrder();
//   //   setState(() {
//   //     _isLoading=false;
//   //   });
//   //
//   // });
//   super.initState();
// }
//

//we converted it to stateless widget and use futurebuilder widget because we are using stateful only due ot spinner

//The FutureBuilder widget is used to asynchronously build a widget tree  or rebuilt the builder  based on the state of a Future. In this case, the fetchAndSetOrder() method of the Orders provider class returns a Future that fetches and sets the user's order data.
//
// Since the order data is not available immediately, FutureBuilder is used to show a loading indicator (CircularProgressIndicator) while the data is being fetched. Once the data is fetched, FutureBuilder rebuilds the widget tree and displays the order data using a ListView.builder.
//
// Using FutureBuilder in this scenario helps to improve the user experience by displaying a loading indicator while the data is being fetched, and then displaying the order data once it's available.
class OrderScreen extends StatefulWidget {
  static const String id = 'OrderScreen';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late Future<void> _fetchSetOrders;

  @override
  void initState() {
    super.initState();
    _fetchSetOrders =
        Provider.of<Orders>(context, listen: false).fetchAndSetOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: FutureBuilder(
        future: _fetchSetOrders,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.hasError) {
              // Error handling
              print(dataSnapshot.error);
              return Center(
                child: Text('An error occurred!'),
              );
            } else {
              // Instead of using the Provider.of method above which rebuilds the entire build method when data changes and makes multiple calls to fetch Orders,
              // only rebuild the ListView when data changes (avoiding multiple calls and an infinite loop)
              return Consumer<Orders>(builder: (ctx, orderData, child) {
                if (orderData.orders.isEmpty) {
                  // No orders, show a message
                  return Center(
                    child: Text('You have no orders.'),
                  );
                }
                // Orders are available, show the ListView
                return ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) => OrderItemcard(order: orderData.orders[i]),
                );
              });
            }
          }
        },
      ),
      drawer: Appdrawer(),
    );
  }

}
//
