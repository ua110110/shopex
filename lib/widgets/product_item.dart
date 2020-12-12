import '../screens/edit_product_screen.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {

  final String image ;
  final String id ;
  final String title ;
  final double price ;
  final int quantity ;

  ProductItem ({
    @required this.image ,
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return 
       Container(
         child: Column(
           children : <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(EditProductScreen.routeName ,arguments: id);
                },
                child: Container(
                  height: 100,
                  width: double.infinity,
                  child: Hero(
                      tag: id,
                      child: FadeInImage(
                      placeholder: AssetImage('assets/images/product.png'),
                      image: NetworkImage(image) ,
                      fit: BoxFit.cover,
                    ),
                  )
                ),
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
                      child: Text( title , 
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16,color: Colors.white ),
                      maxLines: 2,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 8  , bottom: 4),
                          child: Text('₹${price.toStringAsFixed(0)}' ,
                          style: TextStyle(color: Colors.grey , fontSize: 14),
                          ),
                        ),
                        Container(
                          
                          padding: EdgeInsets.only( right: 8  , bottom: 4),
                          child: Text('Quantity:${quantity}' ,
                          style: TextStyle(color: Colors.grey , fontSize: 14),
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