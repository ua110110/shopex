import '../models/shops_model.dart';
import '../widgets/allshop_item.dart';
import 'package:flutter/material.dart';

class AllShopsTile extends StatelessWidget {

  final List<ShopsModel> slist ;
  final bool liked ;

  AllShopsTile({
    @required this.slist ,
    this.liked
  });
  @override
  Widget build(BuildContext context) {
    return slist.isEmpty ? 
     Center(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
           FlatButton.icon(
                padding: EdgeInsets.all(0),
                onPressed: null, 
                icon: Icon(Icons.mood_bad ,size: 50,), 
                label: Text('')
              ),
          Text(liked ?'You have no Favorite Shops' : 'No shops Found near you')
         ],
       ),
     )
     :  Column(
       children: <Widget>[
         SizedBox(height : 15),
         Expanded(
           child: ListView.builder(
                    itemBuilder: (ctx, index){
                      return AllShopsItems(
                        title: slist[index].title, 
                        description: slist[index].description, 
                        image : slist[index].image ,
                        location : slist[index].location ,
                        rating : slist[index].rating ,
                        id: slist[index].id ,
                        );
                    }, 
                      itemCount: slist.length,   
            
    ),
         ),
       ],
     );
  }
}