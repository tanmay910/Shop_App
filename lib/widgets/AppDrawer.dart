import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/auth.dart';
import 'package:shop_app/screens/OrdersScreen.dart';
import 'package:shop_app/screens/User_products_screen.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/product_overview_screen.dart';

class Appdrawer extends StatelessWidget {
  const Appdrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello User'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: (){
              Navigator.pushReplacementNamed(context,ProductOverviewScreen.id );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: (){
              Navigator.pushReplacementNamed(context,OrderScreen.id );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: (){
              Navigator.pushReplacementNamed(context,UserProductsScreen.id );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: (){
              Navigator.pop(context);
              Provider.of<Auth>(context, listen: false).logout();
               Navigator.pushReplacementNamed(context,AuthScreen.id );
            },
          )
        ],
      ),
    );
  }
}
