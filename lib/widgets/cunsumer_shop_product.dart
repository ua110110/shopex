import '../providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConsumerShop extends StatefulWidget {

  final String image ;
  final String id ;
  final String title ;
  final double price ;
  final int quantity ;
  final String shopname ;

  ConsumerShop ({
    @required this.image ,
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.quantity,
    @required this.shopname
  });

  @override
  _ConsumerShopState createState() => _ConsumerShopState();
}

class _ConsumerShopState extends State<ConsumerShop> {
  var _isloading = false ;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    
    void orderincrese () {
    setState(() {
    });
  }
  
    return 
       Container(
         padding: EdgeInsets.only(left: 7 , right: 7 ,top: 0 , bottom: 1),
         child: Column(
           children : <Widget>[
              Container(
                height: 100,
                width: double.infinity,
                child: Hero(
                    tag: widget.id,
                    child: FadeInImage(
                    placeholder: AssetImage('assets/images/product.png'),
                    image: NetworkImage(widget.image) ,
                    fit: BoxFit.cover,
                  ),
                )
              ),
              
              Container(
                height: 90,
                color: Colors.black,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left : 8 , right: 8 , top: 4),
                      child: Text( widget.title , 
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16,color: Colors.white ),
                      maxLines: 2,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                       widget.price <= 0?
                       Container(
                          padding: EdgeInsets.only(left: 16 , right: 0  , bottom: 8),
                          child: Text(widget.price==0 ? 'variety dependent price' : 'Contact seller for price' ,
                          style: TextStyle(color: Colors.grey , fontSize: 12),
                          ),
                        )
                        : Container(
                          padding: EdgeInsets.only(left: 8 , right: 0  , bottom: 0),
                          child: Text('₹${widget.price.toStringAsFixed(0)}' ,
                          style: TextStyle(color: Colors.grey , fontSize: widget.price>10000 ? 14: 18),
                          ),
                        ),
                      //  cart.quantity(widget.id)==0 ? Text('ADD') : 
                      _isloading ? 
                      Container(
                        height: 40,
                        //width: 70,
                        padding: EdgeInsets.only(right:35 , top: 0 , bottom: 5),
                        child: CircularProgressIndicator(backgroundColor: Color.fromRGBO(0, 255, 128, 1),))  :
                     widget.price<=0 ? Container()  : Container(
                        height: 35,
                        child: cart.quantity(widget.id)==0 ? 
                         
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
                               color: Color.fromRGBO(0, 255, 128, 1),
                               margin: EdgeInsets.only(bottom : 5 , right : 5),
                               padding: EdgeInsets.symmetric(horizontal : 1.5 , vertical : 1.5),
                               child : Center(
                                 child: Container(
                                   //margin: EdgeInsets.only(right : 5 , bottom: 5),
                                   padding:EdgeInsets.symmetric(horizontal : 5 , vertical: 5.5) ,
                                   color: Colors.black,
                                   child: Text('ADD ITEM', style : TextStyle (color:Color.fromRGBO(0, 255, 128, 1) ,fontSize: 14 )
                                   ),
                                 ),
                               )
                               
                         ),
                          )
                          : Row(
                          children : <Widget> [
                              IconButton(
                                icon: Icon(Icons.add , color:Color.fromRGBO(0, 255, 128, 1),), 
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
                      ],
                    ),
                  ],
                ),
              ),
           ],
         ),
       );
  }
}