import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopex/providers/cart.dart';

class ListView extends StatefulWidget {
  
  final String id ;
  final String title ;
  final double price ;
  final int quantity ;
  final String shopname ;

  ListView ({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.quantity,
    @required this.shopname
  });

  @override
  _ListViewState createState() => _ListViewState();
}

class _ListViewState extends State<ListView> {
  var _isloading = false ;
  @override

  Widget build(BuildContext context) {
    
     final cart = Provider.of<Cart>(context, listen: false);
    
    void orderincrese () {
    setState(() {
    });
  }
    return ListTile( 
      title: Text(widget.title , style: TextStyle(fontSize: 14),),
      subtitle: widget.price<= 0 ? (widget.price==0 ? Text('variety dependent price', style: TextStyle(fontSize: 14)) :Text('Contact seller for price', style: TextStyle(fontSize: 14)) ) : Text('₹${widget.price.toStringAsFixed(0)}' , style: TextStyle(fontSize: 14),), 
      trailing: 
      _isloading ? 
              Container(
                        height: 40,
                        //width: 70,
                        padding: EdgeInsets.only(right:35 , top: 0 , bottom: 5),
                        child: CircularProgressIndicator())  :
                     widget.price<=0 ? Container(width: 0,) :
                     Container(
                        height: 35,
                        width:cart.quantity(widget.id)==0? 83 : 110,
                        color: Colors.white,
                        child:cart.quantity(widget.id)==0 ? 
                         
                          GestureDetector(
                               onTap: () async{
                                  setState(() {
                                    _isloading = true ;
                                  });
                                  bool g = true ;
                               await  (!cart.checksame(widget.shopname)) ?
                               await  showDialog(context: context , builder: (ctx) => AlertDialog(
                                 title: Text('Are you sure?') ,
                                  content: Text(
                                       'NOTE: This will delete Cart Items of Other Shops'
                                  ),
                                  actions: <Widget>[
                                  FlatButton(
                                      child: Text('Yes'), 
                                         onPressed: ()async{
                                           cart.clear() ;
                                         await  Navigator.of(ctx).pop(false);
                                      },),
                                    FlatButton(
                                    child: Text('No'), 
                                       onPressed: (){
                                         g = false ;
                                     Navigator.of(ctx).pop(false);
                                     },)
                                    ],
                                   )
                                      ) : Container() ;

                                

                                  if((widget.quantity-1 >= cart.quantity(widget.id) ) && g){

                                 await cart.addItem(
                                     widget.id,
                                     widget.price,
                                     widget.title,
                                     widget.shopname ,
                                  );
                                  orderincrese() ;
                           Scaffold.of(context).hideCurrentSnackBar();
                           Scaffold.of(context).showSnackBar(SnackBar(
                           content: Text(
                              'Added item to cart!',
                               textAlign: TextAlign.center,
                               style: TextStyle(color:Color.fromRGBO(0, 255, 128, 1) ),
                                ),
                             duration: Duration(seconds: 2),
                             action: SnackBarAction(
                              label: 'UNDO',
                             onPressed: () async {
                               setState(() {
                                 _isloading = true ;
                               });
                                 await cart.removeSingleItem(widget.id);
                                 setState(() {
                                   _isloading = false ;
                                 });
                              },
                               ),
                               ));
                                }
                                else if (g) {
                                  Scaffold.of(context).hideCurrentSnackBar();
                           Scaffold.of(context).showSnackBar(SnackBar(
                           content: Text(
                               cart.quantity(widget.id)==0 ? 'Item is temporarily unavailable!' : 'Max Order Limit Exceed!',
                               style: TextStyle(color:Color.fromRGBO(0, 255, 128, 1) ),
                               textAlign: TextAlign.center,
                                ),
                             duration: Duration(seconds: 2),
                            
                               ));
                                }
                                setState(() {
                                  _isloading = false ;
                                });
                                

                               },
                               child: Container(
                               height: 30,
                               //width: 30,
                               color: Color.fromRGBO(0, 255, 128, 1),
                               margin: EdgeInsets.only(bottom : 5 , right : 5),
                               padding: EdgeInsets.symmetric(horizontal : 1.5 , vertical : 1.5),
                               child : Center(
                                 child: Container(
                                   //margin: EdgeInsets.only(right : 5 , bottom: 5),
                                   padding:EdgeInsets.symmetric(horizontal : 5 , vertical: 5.5) ,
                                   color: Colors.white,
                                   child: Text('ADD ITEM', style : TextStyle (color:Color.fromRGBO(0, 255, 128, 1) ,fontSize: 14 )
                                   ),
                                 ),
                               )
                               
                         ),
                          ) : Row(
                          children : <Widget> [
                              IconButton(
                                icon: Icon(Icons.add , color:cart.quantity(widget.id)==0 ? Colors.grey : Color.fromRGBO(0, 255, 128, 1),), 
                                onPressed: () async{
                                  setState(() {
                                    _isloading = true ;
                                  });
                                  bool g = true ;
                               await  (!cart.checksame(widget.shopname)) ?
                               await  showDialog(context: context , builder: (ctx) => AlertDialog(
                                 title: Text('Are you sure?') ,
                                  content: Text(
                                       'NOTE: This will delete Cart Items of Other Shops'
                                  ),
                                  actions: <Widget>[
                                  FlatButton(
                                      child: Text('Yes'), 
                                         onPressed: ()async{
                                           cart.clear() ;
                                         await  Navigator.of(ctx).pop(false);
                                      },),
                                    FlatButton(
                                    child: Text('No'), 
                                       onPressed: (){
                                         g = false ;
                                     Navigator.of(ctx).pop(false);
                                     },)
                                    ],
                                   )
                                      ) : Container() ;

                                

                                  if((widget.quantity-1 >= cart.quantity(widget.id) ) && g){

                                 await cart.addItem(
                                     widget.id,
                                     widget.price,
                                     widget.title,
                                     widget.shopname ,
                                  );
                                  orderincrese() ;
                           Scaffold.of(context).hideCurrentSnackBar();
                           Scaffold.of(context).showSnackBar(SnackBar(
                           content: Text(
                              'Added item to cart!',
                               textAlign: TextAlign.center,
                               style: TextStyle(color:Color.fromRGBO(0, 255, 128, 1) ),
                                ),
                             duration: Duration(seconds: 2),
                             action: SnackBarAction(
                              label: 'UNDO',
                             onPressed: () async {
                               setState(() {
                                 _isloading = true ;
                               });
                                 await cart.removeSingleItem(widget.id);
                                 setState(() {
                                   _isloading = false ;
                                 });
                              },
                               ),
                               ));
                                }
                                else if (g) {
                                  Scaffold.of(context).hideCurrentSnackBar();
                           Scaffold.of(context).showSnackBar(SnackBar(
                           content: Text(
                               cart.quantity(widget.id)==0 ? 'Item is temporarily unavailable!' : 'Max Order Limit Exceed!',
                               style: TextStyle(color:Color.fromRGBO(0, 255, 128, 1) ),
                               textAlign: TextAlign.center,
                                ),
                             duration: Duration(seconds: 2),
                            
                               ));
                                }
                                setState(() {
                                  _isloading = false ;
                                });
                                }
                                ),
                              Text(cart.quantity(widget.id).toString(),
                              style: TextStyle(color:cart.quantity(widget.id)==0 ? Colors.grey : Color.fromRGBO(0, 255, 128, 1) , fontSize: 18),
                              ),
                              IconButton(
                                icon: Icon(Icons.remove , color:cart.quantity(widget.id)==0 ? Colors.grey : Color.fromRGBO(0, 255, 128, 1), ), 
                                onPressed: ()async{
                                  setState(() {
                                    _isloading = true ;
                                  });
                                 await cart.removeSingleItem(widget.id);
                                 setState(() {
                                   _isloading = false ;
                                 });
                                 
                                }
                                )
                          ]
                        ),
                      ),
    );
  }
}