import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/orders.dart';
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
class OrderScreen extends StatelessWidget {
  static const String id = 'OrderScreen';



  // @override
  @override
  Widget build(BuildContext context) {
    // final OrderData = Provider.of<Orders>(context); // here ont call listenr as changes lead to rebuild of widget and future builder
    // again get call  this go on forever instead we use consumer
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: Appdrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrder(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (dataSnapshot.error != null) {

            return Center(
              child: Text('an error occured'),
            );
          } else {
            return Consumer<Orders>(
              builder: (ctx, orderData, child) => ListView.builder(
                itemCount: orderData.orders.length,
                itemBuilder: (ctx, i) =>
                    OrderItemcard(order: orderData.orders[i]),
              ),
            );
          }
        },
      ),
    );
  }
}
//
