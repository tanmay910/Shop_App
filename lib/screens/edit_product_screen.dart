import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/productModel.dart';
import 'package:shop_app/providers/Products.dart';

class EditProductScreen extends StatefulWidget {
  static const String id = 'EditProductScreen';
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusedNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlcontroller = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  var isLoading = false;

  var existingProduct =
      Product(id: '', description: '', imageUrl: '', price: 0, title: '');
  var _init =
      true; // as did depencines run several times  during app is running  so we write the logic in if(_init) so it run only once
  var _initValues = {
    'title': '',
    'id': '',
    'description': '',
    'imageUrl': '',
    'price': ''
  };

  @override
  void initState() {
    _imageUrlFocusNode
        .addListener(_updateUI); // this is used to rebuilt ui when
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_init) {
      final productId =
          ModalRoute.of(context)!.settings.arguments as String? ?? '';
      if (productId != '') {
        final product = Provider.of<Products>(context).findByID(productId);
        existingProduct = product;
        _initValues = {
          'id': existingProduct.id,
          'description': existingProduct.description,
          //'imageUrl': existingProduct.imageUrl,
          'price': existingProduct.price.toString(),
          'title': existingProduct.title,
        };
        _imageUrlcontroller.text = existingProduct.imageUrl;
      }

      _init = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateUI);
    _descriptionFocusNode.dispose();
    _priceFocusedNode.dispose();
    _imageUrlcontroller.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  //
  Future<void> _saveform() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    _formKey.currentState
        ?.save(); //----> this function now tigger a method on text form field which allow you to take value entered and do what ever you want
    // it execute the onSaved property of field widget
    setState(() {
      isLoading = true;
    });
    if (existingProduct.id != '') {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(existingProduct.id, existingProduct);

    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addproduct(existingProduct);
      } catch (error) {
        await showDialog(     // as show dialog return future so is we didn't use await it diretly go to finally block  beacause in dart run asunc function in background so it directly move to next instruction which we don't want here
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Error occured!'),
                  content: Text('something went wrong!'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                        },
                        child: Text('okay')),
                  ],
                ));
      }
    }
    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);
  }

  void _updateUI() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
              onPressed: () {
                _saveform();
              },
              icon: const Icon(Icons.save))
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter the title';
                        }
                      },
                      textInputAction: TextInputAction.next,
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      keyboardType: TextInputType.text,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusedNode);
                      },
                      onSaved: (value) {
                        existingProduct = Product(
                          id: existingProduct.id,
                          description: existingProduct.description,
                          imageUrl: existingProduct.imageUrl,
                          price: existingProduct.price,
                          title: value!,
                          isFavorite: existingProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter the price';
                        } else if (double.tryParse(value) == null) {
                          return 'Enter valid number';
                        } else if (double.parse(value) == 0) {
                          return 'Enter number greater than zero';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                      initialValue: _initValues['price'],
                      focusNode: _priceFocusedNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        existingProduct = Product(
                            id: existingProduct.id,
                            description: existingProduct.description,
                            imageUrl: existingProduct.imageUrl,
                            price: double.parse(value!),
                            title: existingProduct.title,
                            isFavorite: existingProduct.isFavorite);
                      },
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter the Description';
                        } else if (value.length < 10) {
                          return 'please atleast 10 charachters';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      initialValue: existingProduct.description,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) {
                        existingProduct = Product(
                            id: existingProduct.id,
                            description: value!,
                            imageUrl: existingProduct.imageUrl,
                            price: existingProduct.price,
                            title: existingProduct.title);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            )),
                            child: _imageUrlcontroller.text.isEmpty
                                ? Text('Enter url')
                                : FittedBox(
                                    child: Image.network(
                                    _imageUrlcontroller.text,
                                    fit: BoxFit.cover,
                                  )),
                          ),
                          Expanded(
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter the Image Url';
                                } else if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Enter valid url';
                                } else if (!value.endsWith('.png') &&
                                    !value.endsWith('.jpg') &&
                                    !value.endsWith('.jpeg')) {
                                  return 'Enter valid image url';
                                }
                                return null;
                              },
                              decoration:
                                  InputDecoration(labelText: 'Image Url'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlcontroller,
                              focusNode: _imageUrlFocusNode,
                              onSaved: (value) {
                                existingProduct = Product(
                                    id: existingProduct.id,
                                    description: existingProduct.description,
                                    imageUrl: value!,
                                    price: existingProduct.price,
                                    title: existingProduct.title,
                                    isFavorite: existingProduct.isFavorite);
                              },
                              onFieldSubmitted: (_) {
                                // onFieldSubmitted is tigger when done button is pressed on soft keyboard because we add textInput action to done
                                _saveform();
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
