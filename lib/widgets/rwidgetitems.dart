import '../providers/cart.dart';
import '../providers/orders.dart';
import '../widgets/order_item.dart' as o;
import 'package:flutter/material.dart';

class RwidgetItem extends StatelessWidget {
  final String name ;
  final int number ;
  final String locatity ;
  final String city ;
  final String pick ;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime; 

  RwidgetItem ({
  @required this.name ,
  @required this.number ,
  @required this.locatity ,
  @required this.city ,
  @required this.pick ,
  @required this.amount ,
  @required this.products ,
  @required this.dateTime,
  });
 
  @override
  
  Widget build(BuildContext context) {
    return 
    Column(
      
      children : <Widget>[ 
        Container(
        padding:  EdgeInsets.symmetric(horizontal : 20),
        child: Column(
          
          children : <Widget> [
            Container(
                     height: 25,
                     width : MediaQuery.of(context).size.width-40 ,
                     child: Text( name , 
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 20,color: Color.fromRGBO(196, 196, 242, 0.9) ),
                            maxLines: 1,
                            ),
                   ),
            Container(
                     height: 23,
                      width : MediaQuery.of(context).size.width-40 ,
                     child: Text( number.toString() , 
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 18,color: Colors.black87 ),
                            maxLines: 1,
                            ),
                   ),
             Container(
                     height: 23,
                      width : MediaQuery.of(context).size.width-40 ,
                     child: Text(locatity , 
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 18,color: Colors.black87 ),
                            maxLines: 1,
                            ),
                   ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children : <Widget> [
                 Container(
                     height: 23,
                      width : MediaQuery.of(context).size.width-200,
                     child: Text( city , 
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 18,color: Colors.black87 ),
                            maxLines: 1,
                            ),
                   ),
                    Container(
                     height: 20,
                     child: Text( pick , 
                            style: TextStyle(fontSize: 14,color: Colors.grey),
                            maxLines: 1,
                            ),
                   ),
              ]
            ),
          ]
        ),
      ),
      o.OrderItem( OrderItem(id: 'gh', amount: amount, products: products, dateTime: dateTime, shopname: null)),
       Container(
                    width : MediaQuery.of(context).size.width ,
                     decoration: BoxDecoration(
                       border: Border(bottom: BorderSide(color: Colors.lime, width : 3))
                     ),
                  ),
                  SizedBox(height : 3)
      ],
    );
  }
}

