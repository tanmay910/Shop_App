import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/productModel.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/screens/Cart_screen.dart';
import 'package:shop_app/widgets/AppDrawer.dart';
import 'package:shop_app/widgets/Product_Item.dart';
import 'package:shop_app/widgets/Product_Grid.dart';
import 'package:shop_app/widgets/badge.dart';

import '../providers/Products.dart';

enum FilterOperations {
  Favourite,
  ShowAll,
}

class ProductOverviewScreen extends StatefulWidget {
  static const String id = 'ProjectOverviewScreen';

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _init = true;
  var _isLoading=false;


  @override
  void initState() {
    // TODO: implement initState

    //Provider.of<Products>(context).fetchandSetData();  // WON'T WORK INIT STATE because all of(context) doenot work in initstate
    //TO LET IT WORK WE HAVE TWO WAYS  1) FUTURE DELAY 2) DID CHANGE DEPENDENCIES
    // Future.delayed(Duration.zero).then((value)  {
    //   Provider.of<Products>(context).fetchandSetData();
    // });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_init) {
      setState(() {
        _isLoading=true;

      });
      Provider.of<Products>(context).fetchandSetData().then((value) {
        setState(() {
          _isLoading=false;
        });
      });
    }
    _init=false;
    super.didChangeDependencies();
  }

  bool showfavs = false;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);

    return Scaffold(
      drawer: Appdrawer(),
      appBar: AppBar(
        title: Text('My Shop'),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (selectedValue) {
                setState(() {
                  if (selectedValue == FilterOperations.Favourite) {
                    showfavs = true;
                  } else {
                    showfavs = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('show favourite'),
                      value: FilterOperations.Favourite,
                    ),
                    PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOperations.ShowAll,
                    )
                  ]),
          Consumer<Cart>(
            builder: (_, cartdata, ch) {
              // the cartdata is variable which will contain instance of class that is passed in
              // provider.of<class_name>(context) i.e here it is class_name
              return badge(child: ch!, value: cartdata.itemcount.toString());
            },
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.id);
              },
            ),
          ),
        ],
      ),
      body: _isLoading? Center(child: CircularProgressIndicator()): Product_grid(showfavs),
    );
  }
}
