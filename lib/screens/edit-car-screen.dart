import 'package:car_rental/providers/Car.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/Car.dart';
import '../providers/Cars.dart';

import 'dart:io';

// import 'package:image_picker/image_picker.dart';

class EditCarScreen extends StatefulWidget {
  static const routeName = '/edit-car';

  @override
  _EditCarScreenState createState() => _EditCarScreenState();
}

class _EditCarScreenState extends State<EditCarScreen> {
  final _priceFocusNode = FocusNode();
  final _consoFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Car(
    id: null,
    title: '',
    price: 0,
    consommation: 0,
    description: '',
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'consommation': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;
  Map<String, bool> _category = {
    "Sport": false,
    "Family": false,
  };
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Cars>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'consommation': _editedProduct.consommation.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _consoFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    String category = "";
    _category.forEach((key, value) {
      if (value == true) {
        category = key;
      }
    });
    _editedProduct = Car(
        title: _editedProduct.title,
        price: _editedProduct.price,
        consommation: _editedProduct.consommation,
        description: _editedProduct.description,
        imageUrl: _editedProduct.imageUrl,
        id: _editedProduct.id,
        isFavorite: _editedProduct.isFavorite,
        category: category);
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Cars>(context, listen: false)
          .updateCar(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Cars>(context, listen: false).addCar(_editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }

  void _showPicker(context) {
    showModalBottomSheet(
        backgroundColor: Color.fromRGBO(108, 99, 255, 1),
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(
                        Icons.photo_library,
                        color: Colors.white,
                      ),
                      title: new Text(
                        'Galery',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        // _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Edit Car'),
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40))),
        backgroundColor: Color.fromRGBO(64, 61, 57, 1),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Name'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Car(
                            title: value,
                            price: _editedProduct.price,
                            consommation: _editedProduct.consommation,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_consoFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a price.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than zero.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Car(
                            title: _editedProduct.title,
                            price: double.parse(value),
                            consommation: _editedProduct.consommation,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['consommation'],
                      decoration:
                          InputDecoration(labelText: 'Average consumption'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _consoFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a value.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than zero.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Car(
                            title: _editedProduct.title,
                            price: _editedProduct.price,
                            consommation: double.parse(value),
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a description.';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 characters long.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Car(
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          consommation: _editedProduct.consommation,
                          description: value,
                          imageUrl: _editedProduct.imageUrl,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Category",
                      style: TextStyle(fontSize: 15),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: FlatButton(
                                onPressed: () {
                                  setState(() {
                                    _category["Family"] = !_category["Family"];
                                    _category["Sport"] = false;
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  // width: 80,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    child: Text("Family",
                                        style: (_category["Family"] == true)
                                            ? Theme.of(context)
                                                .textTheme
                                                .body1
                                                .copyWith(
                                                    color: Colors.white,
                                                    fontSize: 18)
                                            : Theme.of(context)
                                                .textTheme
                                                .body1
                                                .copyWith(
                                                    color: Color.fromRGBO(
                                                        64, 61, 57, 1),
                                                    fontSize: 18)),
                                  ),
                                  decoration: (_category["Family"] == true)
                                      ? BoxDecoration(
                                          color: Color.fromRGBO(64, 61, 57, 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)))
                                      : BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color:
                                                Color.fromRGBO(64, 61, 57, 1),
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                ),
                              )),
                          Expanded(
                            flex: 1,
                            child: FlatButton(
                              onPressed: () {
                                setState(() {
                                  _category["Sport"] = !_category["Sport"];
                                  _category["Family"] = false;
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 50,
                                // width: 80,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Text('Sport',
                                      style: (_category["Sport"] == true)
                                          ? Theme.of(context)
                                              .textTheme
                                              .body1
                                              .copyWith(
                                                  color: Colors.white,
                                                  fontSize: 18)
                                          : Theme.of(context)
                                              .textTheme
                                              .body1
                                              .copyWith(
                                                  color: Color.fromRGBO(
                                                      64, 61, 57, 1),
                                                  fontSize: 18)),
                                ),
                                decoration: (_category["Sport"] == true)
                                    ? BoxDecoration(
                                        color: Color.fromRGBO(64, 61, 57, 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)))
                                    : BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color:
                                                Color.fromRGBO(64, 61, 57, 1)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Icon(
                                  Icons.camera_enhance,
                                  color: Color.fromRGBO(37, 36, 34, 1),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Select an image",
                                style: TextStyle(fontSize: 17),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
