import '../models/shops_model.dart';
import '../screens/shop_screen.dart';
import 'package:flutter/material.dart';

class AllShopsItems extends StatelessWidget {

  final String title ;
  final String description ;
  final String id ;
  final String image ;
  final double rating ;
  final PlaceLocation location ;

  AllShopsItems({
    @required this.title ,
    @required this.description ,
    @required this.id ,
    this.image ,
    @required this.rating ,
    this.location
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(ShopOfScreen.routeName,
                  arguments: id );
        },
          child: Container(
        height: 130,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: <Widget> [
            Container(
              height: 100,
              width: 100,
              margin: EdgeInsetsDirectional.only(bottom: 15),
              child : FadeInImage(
                    
                    placeholder: AssetImage('assets/images/product.png'),
                    image: NetworkImage(image) ,
                    fit: BoxFit.cover,
                  ) ,
            ),
            SizedBox(
              width : 20
            ),
            Container(
             margin: EdgeInsets.only(top : 5 ,bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children : <Widget> [
                 Container(
                   height: 28,
                   width : MediaQuery.of(context).size.width>=160 ? MediaQuery.of(context).size.width-160 : 0,
                   child: Text( title , 
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 20,color: Colors.teal ),
                          maxLines: 1,
                          ),
                 ),
                  Container(
                    height: 35,
                    width : MediaQuery.of(context).size.width>=160 ? MediaQuery.of(context).size.width-160 : 0,
                    child: Text( description , 
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 14,color: Colors.black45 ),
                          maxLines: 2,
                          ),
                  ),
                  Container(
                    width : MediaQuery.of(context).size.width>=160 ? MediaQuery.of(context).size.width-160 : 0,
                     decoration: BoxDecoration(
                       border: Border(bottom: BorderSide(color: Colors.lime, width : 1.5))
                     ),
                  ),
                   
                   Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children : <Widget> [
                            Container(
                              child : Icon(Icons.star, size: 20,)
                            ),
                            Text(rating.toStringAsFixed(1), style: TextStyle(fontSize: 12),)
                          ]
                        ),
                        SizedBox(width : 5),
                        Container(          
                          padding: EdgeInsets.only(bottom :6 , top : 6),
                        width : MediaQuery.of(context).size.width>=215 ? MediaQuery.of(context).size.width-215 : 0,
                          child: Text(location.address , style: TextStyle(color: Colors.black38 ,fontSize: 14) , maxLines: 2,)
                          ),
                     
                      ],
                    ),
                ]
              ),
            )
          ]
        ) ,
      ),
    );
  }
}