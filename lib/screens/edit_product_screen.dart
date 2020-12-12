import '../models/product_model.dart';
import '../providers/myproducts.dart';
import '../screens/myshop_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product' ;

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode() ;
  final _descriptionFocusNode = FocusNode();
  final _imegeUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  String appbarname = '' ;
  var _editedProduct = ProductModel(
    id: null,
    title: '',
    price: null,
    availability: null,
    image: '',
    sid: '' ,
  );
  var _initValues = {
    'title':'',
    'availability':'10',
    'price':'',
    'image': '',
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
       appbarname = 'Create Product' ;
       _imegeUrlController.text = 'h';
       final productId = ModalRoute.of(context).settings.arguments as  String ;
       if(productId != null){
         appbarname = 'Edit Product' ;
        _editedProduct = Provider.of<MyProducts>(context , listen: false).findById(productId);
         _initValues = {
         'title': _editedProduct.title ,
         'availability':_editedProduct.availability.toString(),
          'price':_editedProduct.price.toString(),
          'image': '',
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
    super.dispose(); 
  }

  void _updateImageUrl(){
    if(!_imageUrlFocusNode.hasFocus){
      setState(() {   });
    }
  }

  Future<void> _saveForm() async {
    final isValid =_form.currentState.validate();
    if(!isValid){
      return ;
    }
    _form.currentState.save();
   
    setState(() {
      _isLoading = true ;
    });
    
    if(_editedProduct.id != null){
        await Provider.of<MyProducts>(context , listen: false).updateProduct(_editedProduct.id , _editedProduct);
    }else {
      try {
         await  Provider.of<MyProducts>(context , listen: false).addProduct(_editedProduct);
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
         Navigator.of(context).pop();
    }
 
  @override
  Widget build(BuildContext context) {
    final prodid= ModalRoute.of(context).settings.arguments as  String ;
    return Scaffold(
      appBar: AppBar(
        title: Text(appbarname),
        backgroundColor: Color.fromRGBO(0, 255, 128, 1),
        actions: <Widget>[  
        prodid !=null ? IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
              
               Provider.of<MyProducts>(context).deleteProduct(prodid);
               Navigator.of(context).pushReplacementNamed(MyShop.routeName);
                },
              ) : Container() ,
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
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if(value.isEmpty){
                    return 'Please enter a Title';
                  }
                  return null;
                },
                onSaved:(value) {
                  _editedProduct = ProductModel(
                    title: value,
                    price: _editedProduct.price,
                    availability: _editedProduct.availability,
                    image: _editedProduct.image,
                    id: _editedProduct.id,
                    sid: _editedProduct.sid,
                    );
                }
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a Price';
                  }
                  if (double.parse(value)>=999999) {
                    return 'Price must be less then 10 Lakhs';
                  }
                  if (double.tryParse(value)== null){
                    return 'Please enter a valid number';
                  }
                  if(double.parse(value) < -1){
                    return 'Price not Possible';
                  }
                  return null;
                },
                onSaved:(value) {
                  _editedProduct = ProductModel(
                    title: _editedProduct.title,
                    price: double.parse(value) ,
                    availability: _editedProduct.availability,
                    image: _editedProduct.image,
                    id: _editedProduct.id,
                    sid: _editedProduct.sid
                    );
                }
              ), 
             
              TextFormField(
                initialValue: _initValues['availability'],
                decoration: InputDecoration(labelText: 'Quantity'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _descriptionFocusNode,
                onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_imageUrlFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter Quantity';
                  }
                  if (double.tryParse(value)== null){
                    return 'Please enter a valid number';
                  }
                  if(double.parse(value) < 0){
                    return 'Quantity not Possible';
                  }
                  if(double.parse(value) >=9999 ){
                    return 'Quantity must be less than 10k';
                  }
                  return null;
                },
                onSaved:(value) {
                  _editedProduct = ProductModel(
                    title: _editedProduct.title,
                    price: _editedProduct.price ,
                    availability: int.parse(value),
                    image: _editedProduct.image,
                    id: _editedProduct.id,
                    sid: _editedProduct.sid
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
                          _saveForm();
                        },
                         validator: (value) {
                           if(value.isEmpty){
                                return 'Please enter an image URL';
                              }
                           return null;
                         },
                        onSaved:(value) {
                         _editedProduct = ProductModel(
                          title: _editedProduct.title,
                          price: _editedProduct.price ,
                          availability: _editedProduct.availability,
                          image: value,
                          id: _editedProduct.id,
                          sid: _editedProduct.sid
                    );
                }
                        ),
                    ),
                ]
              )
            ],
            )
          ),
      ),
    );
  }}