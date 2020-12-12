import '../providers/orders.dart';
import '../providers/recent_orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class SellerOrdersScreen extends StatefulWidget {

  static const routeName = '/Seller-page';

  @override
  _SellerOrdersScreenState createState() => _SellerOrdersScreenState(
    );
}

class _SellerOrdersScreenState extends State<SellerOrdersScreen> {

  final _pinFocusNode = FocusNode() ;
  final _contactFocusNode = FocusNode();
  final _localityFocusNode = FocusNode();
  final _cityFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Rorder(
      city: '' ,
      locality: '' ,
      number: null ,
    //  pin: null ,
      name: '' ,
      pick: 'Not Provided',
  );
  var _isInit = true ;
  var _isLoading = false ;

 Future<void> _saveForm() async {
    final isValid =_form.currentState.validate();
    if(!isValid){
      return ;
    }

    _form.currentState.save();
   
    setState(() {
      _isLoading = true ;
    });
      try {
         await  Provider.of<RecentOrderpro>(context , listen: false).addOrder( _editedProduct.number, _editedProduct.locality, _editedProduct.name, _editedProduct.city , _editedProduct.pick);
        Provider.of<Orders>(context, listen: false).ex(true) ;
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
        setState(() {
          _isLoading = false ;
        });
         Navigator.of(context).pop();
    }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text('Customer Detail'),
        backgroundColor: Color.fromRGBO(0, 255, 128, 1) ,
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
                Container(
                padding: EdgeInsets.only(top: 10),
                child: Text('Currently we support only COD' , style: TextStyle(fontWeight : FontWeight.bold , fontSize: 16),),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Your Name'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_contactFocusNode);
                },
                validator: (value) {
                  if(value.isEmpty){
                    return 'Please enter a Your Name';
                  }
                  return null;
                },
                onSaved:(value) {
                  _editedProduct = Rorder(
                       city: _editedProduct.city ,
                       locality: _editedProduct.locality ,
                       number: _editedProduct.number ,
                    //   pin: _editedProduct.pin ,
                       name: value ,
                       pick: _editedProduct.pick
                    );
                }
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contact No with out 0 or +91'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _contactFocusNode,
                onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_pinFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter Your Contact Number';
                  }
                  if (value.length!=10 ) {
                    return 'Please enter a valid Contact Number';
                  }
                  return null;
                },
                onSaved:(value) {
                  _editedProduct = Rorder(
                       city: _editedProduct.city ,
                       locality: _editedProduct.locality ,
                       number: int.parse(value) ,
                  //     pin: _editedProduct.pin ,
                       name: _editedProduct.name ,
                       pick: _editedProduct.pick,
                    );
                }
              ), 
              TextFormField(
                decoration: InputDecoration(labelText: 'Addrress of your Locatity'),
                textInputAction: TextInputAction.next,
                focusNode: _localityFocusNode ,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_cityFocusNode);
                },
                validator: (value) {
                  if(value.isEmpty){
                    return 'Please enter Address of your Locality';
                  }
                  return null;
                },
                onSaved:(value) {
                  _editedProduct = Rorder(
                       city: _editedProduct.city ,
                       locality: value ,
                       number: _editedProduct.number ,
                  //     pin: _editedProduct.pin ,
                       name: _editedProduct.name ,
                        pick: _editedProduct.pick
                    );
                }
              ),   

              TextFormField(
                decoration: InputDecoration(labelText: 'City'),
                textInputAction: TextInputAction.next,
                focusNode: _cityFocusNode ,
                onFieldSubmitted: (_) {
                },
                validator: (value) {
                  if(value.isEmpty){
                    return 'Please enter name of your city or city nearby you';
                  }
                  return null;
                },
                onSaved:(value) {
                  _editedProduct = Rorder(
                       city: value ,
                       locality: _editedProduct.locality ,
                       number: _editedProduct.number ,
                    //   pin: _editedProduct.pin ,
                       name: _editedProduct.name ,
                        pick: _editedProduct.pick
                    );
                }
              ),   
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Text('Choose item pickup date and time(optional)' , style: TextStyle(fontWeight : FontWeight.bold , fontSize: 14),),
              ),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children :<Widget>[ 
                   Container(
                     child: Text(_editedProduct.pick)
                   ),
                   FlatButton(
                  onPressed: () {
                    DatePicker.showDateTimePicker(context, showTitleActions: true, onChanged: (date) {
                      print('change $date in time zone ' + date.timeZoneOffset.inHours.toString());
                    },
                    minTime: DateTime.now(),
                    maxTime: DateTime.now().add(Duration (days: 7)),
                     onConfirm: (date) {
                       _editedProduct = Rorder(
                         city: _editedProduct.city,
                         locality: _editedProduct.locality ,
                         number: _editedProduct.number ,
                      //   pin: _editedProduct.pin ,
                         name: _editedProduct.name ,
                          pick: date.toString() ,
                      );
                      setState(() {
                        
                      });
                      print(_editedProduct.pick);
                      print('confirm $date');
                    }, currentTime: DateTime.now());
                  },
                  child: Text(
                    _editedProduct.pick != 'Not Provided' ? 'Change' : 'Choose',
                    style: TextStyle(color: Colors.blue),
                  )),
                 ],
               ), 
               Divider(),
            RaisedButton.icon(
            icon: Icon(Icons.trip_origin),
            label: Text('Place Order'),
            onPressed:()async {
              return _saveForm();
               },
            elevation: 0,
            materialTapTargetSize:
             MaterialTapTargetSize.shrinkWrap,
            color: Theme.of(context).accentColor,
          ),
        SizedBox(height: 10,),
        Container(
          child: Text('All orders from ShopeX will provide all this information to the Corresponding Seller and then Seller will contact you and delivery related information is also provided to you by seller on the above given Contact No. but this contact time may vary from seller to seller. Currently we do not have our own home delivery so delivery depends on seller.'),
        ),
            ],
            )
          ),
      ),
    );
  }}