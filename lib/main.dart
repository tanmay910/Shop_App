import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/Products.dart';
import 'package:shop_app/screens/Cart_screen.dart';
import 'package:shop_app/screens/OrdersScreen.dart';
import 'package:shop_app/screens/Product_detatils_screen.dart';
import 'package:shop_app/screens/User_products_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/product_overview_screen.dart';
import 'models/orders.dart';
import './screens/auth_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // this changeNotifierProvider( a provider ) help us to register the class
    // for  which we want that class child listen the changes and rebuilt

    //       in flutter doesnot destroy and widget again and again
    //   it just reuse it as data change in modal class but
    // in widget such as gridview or listview as its children create only when it on screen
    // and flutter recycle the widget and in gridview widget get recycled but data change that why
    // we want that widget rebuilt even if data changes that why
    // so   ChangeNotifierProvider( create: (context)=>Products()....), should not used as it  create bugs
    // instead use    //ChangeNotifierProvider.value(value:Products()...),

    // here it is on in grid or list view therefore we use create method

    // return ChangeNotifierProvider(
    //     create: (context)=>Products(),
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth,Products> (   // this provider will be rebuild when Auth provider notice changes therefore this provider should be after auth provider
          // it take two argument first is on which our proxy provider depends on and second is
          // type of you want to provide or means which we you want to track changes
          create: (ctx) => Products('',[]),
          //  here it intialise the products instance with empty token and list as
          // Auth class change update run and change the list and token

          update: (ctx,auth,previousProducts)=>Products(auth.token!,previousProducts == null ? [] : previousProducts!.items),
          // we want our items not delete after we rebuild the Products therefore we intialise it
          // at first we it would be null as our data is not fetched we would intialise it
          // [] and then it would previous products



        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
      ],
      child: Consumer<Auth>(
          builder: (ctx, Authdata, _) => MaterialApp(
                title: 'My shop',
                theme: ThemeData(
                  secondaryHeaderColor: Colors.deepOrange,
                  primarySwatch: Colors.indigo,
                  fontFamily: 'Lato',
                ),
                home: Authdata.isAuth? ProductOverviewScreen()  :AuthScreen(),
                routes: {
                  ProductDetails.id: (context) => ProductDetails(),
                  CartScreen.id: (context) => CartScreen(),
                  ProductOverviewScreen.id: (context) =>
                      ProductOverviewScreen(),
                  OrderScreen.id: (context) => OrderScreen(),
                  UserProductsScreen.id: (context) => UserProductsScreen(),
                  EditProductScreen.id: (context) => EditProductScreen(),
                  AuthScreen.id: (context) => AuthScreen(),
                },
              )),
    );
  }
}
