import '../models/shops_model.dart';
import '../providers/all_shops.dart';
import '../screens/myshop_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:provider/provider.dart';

class EditShopScreen extends StatefulWidget {
  static const routeName = '/edit-shop' ;

  @override
  _EditShopScreenState createState() => _EditShopScreenState();
}

class _EditShopScreenState extends State<EditShopScreen> {
  final _priceFocusNode = FocusNode() ;
  final _descriptionFocusNode = FocusNode();
  final _imegeUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  String appbarname = '' ;
  var _editedProduct = ShopsModel(
    id: null,
    title: '',
    contactNo: null,
    description: '',
    image: '',
    location: PlaceLocation(
      latitude: 0, 
      longitude: 0,
      address: ''
      ) ,
      rating: null ,
      ratinglist: [ RatingList(
        userId : '' ,
        urating:  null ,
      )]
  );
  var _initValues = {
    'title':'',
    'contactNo':'',
    'description':'',
    'image': '',
    'address' : '', 
  };
  var _isInit = true ;
  var _isLoading = false ;

  @override
  void initState() { 
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(_isInit){
       appbarname = 'Create Shop' ;
       final productId = ModalRoute.of(context).settings.arguments as  String ;
       if(productId != null){
         appbarname = 'Edit Shop' ;
        _editedProduct = Provider.of<AllShops>(context , listen: false).findownshop();
         _initValues = {
         'title':_editedProduct.title,
         'contactNo':_editedProduct.contactNo.toString(),
         'description':_editedProduct.description,
         'image': _editedProduct.image,
         'address': _editedProduct.location.address ,
         };
         _imegeUrlController.text = _editedProduct.image ;
       }
    }
    _isInit = false ;
    super.didChangeDependencies();
  }
                  
  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imegeUrlController.dispose();
    _imageUrlFocusNode.dispose();
    _addressFocusNode.dispose() ;
    super.dispose(); 
  }

  void _updateImageUrl(){
    if(!_imageUrlFocusNode.hasFocus){
      if(
        (!_imegeUrlController.text.startsWith('http') && !_imegeUrlController.text.startsWith('https')))
      {
        return;
      }
      setState(() {   });
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if(!isValid){
      return ;
    }
    _form.currentState.save();
   
    setState(() {
      _isLoading = true ;
    });
    
    if(_editedProduct.id != null){
        await Provider.of<AllShops>(context , listen: false).updateProduct(_editedProduct.eid , _editedProduct);
    }else {
      try {
         await  Provider.of<AllShops>(context , listen: false).addProduct(_editedProduct);
      }
      catch(error){
         showDialog(context: context ,
          builder: (ctx) => AlertDialog(
            title: Text('An error occured!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                   Navigator.of(ctx).pop();
                },
                )
            ],
            )
          );
      }
    }
        setState(() {
          _isLoading = false ;
        });
        Navigator.of(context).pushReplacementNamed(MyShop.routeName);
    }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appbarname),
        backgroundColor: Color.fromRGBO(0, 255, 128, 1),
        actions: <Widget>[
              IconButton(
              icon: Icon(Icons.save),
              onPressed: _saveForm ,
              ),
        ],
      ),
      body: _isLoading ?
       Center(
         child: CircularProgressIndicator(),
       )
       : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: 
          ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(labelText: 'Shop '),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value) {
                  if(value.isEmpty){
                    return 'Please enter a Shop Name';
                  }
                  return null;
                },
                onSaved:(value) {
                  _editedProduct = ShopsModel(
                    title: value,
                    description: _editedProduct.description,
                    contactNo: _editedProduct.contactNo,
                    image: _editedProduct.image,
                    location: _editedProduct.location ,
                    id: _editedProduct.id,
                    rating: _editedProduct.rating,
                    ratinglist: _editedProduct.ratinglist ,
                    eid: _editedProduct.eid ,
              //      isFavorite: _editedProduct.isFavorite,
                    );
                }
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(labelText: 'Short description of what you Sell like Grossery etc..'),
                maxLines: 3,
            //    textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                 validator: (value) {
                  if(value.isEmpty){
                    return 'Please enter a description';
                  }
                  if(value.length < 10){
                    return 'Should be at least 10 chracters long';
                  }
                  return null;
                },
                onSaved:(value) {
                  _editedProduct = ShopsModel(
                    title: _editedProduct.title,
                    description: value,
                    contactNo: _editedProduct.contactNo,
                    image: _editedProduct.image,
                    location: _editedProduct.location ,
                    id: _editedProduct.id,
                    rating: _editedProduct.rating,
                    ratinglist: _editedProduct.ratinglist ,
                    eid: _editedProduct.eid ,
                    );
                }
              ),
              TextFormField(
                initialValue: _initValues['contactNo'],
                decoration: InputDecoration(labelText: 'Contact No of Seller without 0 or +91'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_addressFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a Contact No';
                  }
                  if ( value.toString().length != 10 ) {
                    return 'Invalid Contact No';
                  }
                  if (double.tryParse(value)== null){
                    return 'Please enter a valid number';
                  }
                  if(double.parse(value) < 0){
                    return 'Invalid Contact No';
                  }
                  return null;
                },
                onSaved:(value) {
                  _editedProduct = ShopsModel(
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    contactNo: int.parse(value),
                    image: _editedProduct.image,
                    location: _editedProduct.location ,
                    id: _editedProduct.id,
                    rating: _editedProduct.rating,
                    ratinglist: _editedProduct.ratinglist ,
                    eid: _editedProduct.eid ,
                    );
                }
              ), 
              TextFormField(
                initialValue: _initValues['address'],
                decoration: InputDecoration(labelText: 'short address'),
                textInputAction: TextInputAction.next,
                focusNode: _addressFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_imageUrlFocusNode);
                },
                validator: (value) {
                  if(value.isEmpty){
                    return 'Please enter a short address';
                  }
                  return null;
                },
                onSaved:(value) {
                  _editedProduct = ShopsModel(
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    contactNo: _editedProduct.contactNo,
                    image: _editedProduct.image,
                    location: PlaceLocation(latitude:_editedProduct.location.latitude , longitude: _editedProduct.location.longitude , address: value ),
                    id: _editedProduct.id,
                    rating: _editedProduct.rating,
                    ratinglist: _editedProduct.ratinglist ,
                    eid: _editedProduct.eid ,
                    );
                }
              ),    
              
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget> [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8,right: 10),
                    decoration: BoxDecoration(border: Border.all(
                      width: 1,
                      color: Colors.grey,
                      )
                      ),
                      child: _imegeUrlController.text.isEmpty ? Text('Enter a URL') 
                      :
                      FittedBox(
                        child: Image.network(_imegeUrlController.text,
                        fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imegeUrlController,
                        focusNode: _imageUrlFocusNode,
                        onFieldSubmitted: (_){
                        },
                         validator: (value) {
                           if(value.isEmpty){
                                return 'Please enter an image URL';
                              }
                           if(!value.startsWith('http') && !value.startsWith('https')){
                                return 'Please enter a valid URL';
                           } 
                           return null;
                         },
                        onSaved:(value) {
                           _editedProduct = ShopsModel(
                           title: _editedProduct.title,
                           description: _editedProduct.description,
                           contactNo: _editedProduct.contactNo,
                           image: value,
                           location: _editedProduct.location ,
                           id: _editedProduct.id,
                           rating: _editedProduct.rating,
                           ratinglist: _editedProduct.ratinglist ,
                           eid: _editedProduct.eid ,
                    );
                }
                        ),
                    ),
                ]
              ),SizedBox(
                height : 10
              ),
              FlatButton.icon(
              onPressed: 
              ()async {
                var g = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
                print(g.latitude);
                 _editedProduct = ShopsModel(
                           title: _editedProduct.title,
                           description: _editedProduct.description,
                           contactNo: _editedProduct.contactNo,
                           image: _editedProduct.image ,
                           location: PlaceLocation(latitude: g.latitude , longitude: g.longitude , address: _editedProduct.location.address) ,
                           id: _editedProduct.id,
                           rating: _editedProduct.rating,
                           ratinglist: _editedProduct.ratinglist ,
                           eid: _editedProduct.eid ,
                    );
                }
               ,
              icon: Icon(Icons.location_on),
              label: Text('Current Location'),
              textColor: Theme.of(context).primaryColor,
            ),

            ],
            )
          ),
      ),
    );
  }}