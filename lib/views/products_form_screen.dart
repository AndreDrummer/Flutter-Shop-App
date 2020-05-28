import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';

class ProductFormScreen extends StatefulWidget {
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageURLFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();

  final urlController = TextEditingController();

  Map<String, Object> formData = {};

  @override
  void initState() {
    super.initState();
    _imageURLFocusNode.addListener(_updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (formData.isEmpty) {
      final product = ModalRoute.of(context).settings.arguments as Product;
      if (product != null) {
        formData['id'] = product.id;
        formData['title'] = product.title;
        formData['price'] = product.price;
        formData['description'] = product.description;
        formData['imageUrl'] = product.imageUrl;

        urlController.text = formData['imageUrl'];
      } else {
        formData['price'] = '';
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _imageURLFocusNode.removeListener(_updateImage);
    _descriptionFocusNode.dispose();
  }

  bool isURLValid(String value) {
    bool startWithHttp = value.startsWith('http://');
    bool startWithHttps = value.startsWith('https://');
    bool endsWithPng = value.endsWith('png');
    bool endsWithJpg = value.endsWith('jpg');
    bool endsWithJpeg = value.endsWith('jpeg');

    return (startWithHttp || startWithHttps) &&
        (endsWithJpeg || endsWithJpg || endsWithPng);
  }

  _updateImage() {
    String url = urlController.text;
    if (isURLValid(url)) {
      setState(() {});
    }
  }

  void _saveForm() {
    _form.currentState.save();

    bool formValid = _form.currentState.validate();

    print(formValid);
    if (!formValid) {
      return;
    }

    final product = Product(
      id: formData['id'],
      title: formData['title'],
      price: formData['price'],
      description: formData['description'],
      imageUrl: formData['imageUrl'],
    );

    final products = Provider.of<Products>(context, listen: false);
    if (formData['id'] == null) {
      products.addProducts(product);
    } else {
      products.updateProduct(product);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fórmulário produto"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: formData['title'],
                validator: (value) {
                  bool isEmpty = value.trim().isEmpty;
                  bool isInvalid = value.trim().length < 3;

                  if (isEmpty || isInvalid) {
                    return 'Informe um título válido com no mínimo 3 letras';
                  }

                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) => formData['title'] = value,
              ),
              TextFormField(
                initialValue: formData['price'].toString(),
                validator: (value) {
                  double newPrice;
                  bool isInvalid;
                  bool isEmpty = value.trim().isEmpty;
                  if (!isEmpty) {
                    newPrice = double.tryParse(value);
                    isInvalid = newPrice <= 0;
                  }

                  if (isEmpty || isInvalid) {
                    return 'Informe um preço válido.';
                  }

                  return null;
                },
                focusNode: _priceFocusNode,
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) => {
                  if (value.trim().isNotEmpty)
                    {formData['price'] = double.parse(value)}
                },
              ),
              TextFormField(
                initialValue: formData['description'],
                validator: (value) {
                  bool isEmpty = value.trim().isEmpty;
                  bool isInvalid = value.trim().length < 10;

                  if (isEmpty || isInvalid) {
                    return 'Informe uma descrição válido com no mínimo 10 letras';
                  }

                  return null;
                },
                focusNode: _descriptionFocusNode,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_imageURLFocusNode);
                },
                onSaved: (value) => formData['description'] = value,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      validator: (value) {
                        bool isEmpty = value.trim().isEmpty;
                        bool isInvalid = !isURLValid(value);

                        if (isEmpty || isInvalid) {
                          return 'Informe uma URL válida';
                        }

                        return null;
                      },
                      controller: urlController,
                      focusNode: _imageURLFocusNode,
                      decoration: InputDecoration(
                        labelText: 'URL da imagem',
                      ),
                      keyboardType: TextInputType.url,
                      onSaved: (value) => formData['imageUrl'] = value,
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(top: 8, left: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        style: BorderStyle.solid,
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: urlController.text.isEmpty
                        ? Text("Informe a URL")
                        : Image.network(
                            urlController.text,
                            fit: BoxFit.cover,
                          ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
