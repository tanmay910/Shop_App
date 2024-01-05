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
import 'screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  //static final navigatorKey = GlobalKey<NavigatorState>();

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
        ChangeNotifierProxyProvider<Auth, Products>(
          // this provider will be rebuild when Auth provider notice changes therefore this provider should be after auth provider
          // it take two argument first is on which our proxy provider depends on and second is
          // type of you want to provide or means which we you want to track changes
          create: (ctx) => Products('', [],''),
          //  here it initialise the products instance with empty token and list as
          // Auth class change update run and change the list and token

          update: (ctx, auth, previousProducts) => Products( auth.token ?? '',
              previousProducts == null ? [] : previousProducts!.items,auth.userId?? ''),
          // we want our items not delete after we rebuild the Products therefore we initialise it
          // at first we it would be null as our data is not fetched we would initialise it
          // [] and then it would previous products
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        // when ever auth notice changes the proxy provider gets  notify rebuild the widget where we use the listener of proxy provider

        ChangeNotifierProxyProvider<Auth, Orders>(
            create: (ctx) => Orders('', [],''),
            update: (ctx, auth, previousOrders) => Orders(auth.token??'',
                previousOrders == null ? [] : previousOrders!.orders,auth.userId?? '')),
      ],
      child: Consumer<Auth>(
          builder: (ctx, Authdata, _) => MaterialApp(
            //navigatorKey: navigatorKey,
            title: 'My shop',
            theme: ThemeData(
              secondaryHeaderColor: Colors.deepOrange,
              primarySwatch: Colors.indigo,
              fontFamily: 'Lato',
            ),


            //Consumer<Auth> listens for changes to the Auth object.
            // Whenever the value of Authdata changes, the builder function is called.The builder function of Consumer<Auth> returns a MaterialApp widget. This widget is the root of the app and is responsible for setting the app's title, theme, and home screen.

            // The home property of MaterialApp is set to a FutureBuilder. This widget is responsible for showing either the SplashScreen or the AuthScreen, depending on whether the user is already authenticated or not.
            // The future property of FutureBuilder is set to Authdata.tryAutoLogin(). This method returns a Future that resolves to the user's authentication state.
            // The builder function of FutureBuilder is called when the future resolves. If the future is still in progress, ConnectionState.waiting is returned, which displays the SplashScreen. Otherwise, the builder checks whether the user is authenticated or not.

            // If the user is authenticated (Authdata.isAuth == true), the ProductOverviewScreen is displayed. If the user is not authenticated, the AuthScreen is displayed.
            // If the user logs in or logs out while using the app, the Auth object will notify its listeners (including Consumer<Auth>) of the change. When this happens, the builder function of Consumer<Auth> will be called again, and the UI will update to reflect the new authentication state.
            // In summary, Consumer and FutureBuilder work together to manage the state of the app and to display different screens depending on that state. Consumer listens for changes to the Auth object, while FutureBuilder manages the asynchronous process of checking the user's authentication state. When the future resolves, the builder function of FutureBuilder checks the authentication state and displays the appropriate screen.

            home: Authdata.isAuth ? ProductOverviewScreen() : FutureBuilder(
                future: Authdata.tryAutoLogin(),
                builder:(ctx,userAuthsnapshot) =>
                userAuthsnapshot.connectionState == ConnectionState.waiting ? SplashScreen():AuthScreen()),
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