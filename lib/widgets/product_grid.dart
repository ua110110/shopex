import 'package:shopex/models/product_model.dart';

import '../providers/all_shops.dart';
import '../providers/cart.dart';
import '../widgets/listview.dart' as list;
import '../providers/myproducts.dart';
import '../widgets/cunsumer_shop_product.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';

class ProductGrid extends StatefulWidget {
  final String shopid ;

  

  ProductGrid(this.shopid) ; 
  @override
  _ProductGridState createState() => _ProductGridState(shopid);
}

class _ProductGridState extends State<ProductGrid> {
  final String shopide ;
  _ProductGridState(this.shopide);
  
  String distance ;

  var _isinIt = true ;
  var _isLoading = true ;

  Future <void> _refreshProductsmain(BuildContext context) async {
  setState(() {
    _isLoading = true ;
  });
   await Provider.of<Cart>(context).fetchAndSetPlaces();
     var loc = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
     double dis = await (Provider.of<AllShops>(context , listen: false).distance(shopide, loc)) ;
     double hj = dis/1000 ;
     distance = hj.toStringAsFixed(2) ;
     await Provider.of<MyProducts>(context).fetchAndSetProducts(shopide) ;
   setState(() {
     _isLoading= false ;
   });
  }

  @override
  void didChangeDependencies() async {
   if(_isinIt){
     setState(() {
       _isLoading = true; 
     });
      await Provider.of<Cart>(context).fetchAndSetPlaces();
     var loc = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
     double dis = await (Provider.of<AllShops>(context , listen: false).distance(shopide, loc)) ;
     double hj = dis/1000 ;
     distance = hj.toStringAsFixed(2) ;
      Provider.of<MyProducts>(context).fetchAndSetProducts(shopide).then((_) {
         setState(() {
           _isLoading = false ;
         });
      });
   }
   _isinIt = false ;
    super.didChangeDependencies();
   }

   List<ProductModel> gproduct(List<ProductModel> list){
     List<ProductModel> ret = [] ;
     for(int i=0 ; i<list.length ;i++){
       if(list[i].image!='h'){
         ret.add(list[i]);
       }
     }
     return ret ;
   }

    List<ProductModel> lproduct(List<ProductModel> list){
     List<ProductModel> ret = [] ;
     for(int i=0 ; i<list.length ;i++){
       if(list[i].image=='h'){
         ret.add(list[i]);
       }
     }
     return ret ;
   }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<MyProducts>(context);
    final products = productData.findbysid(shopide) ;
    final gproducts = gproduct(products);
    final lproducts = lproduct(products);
    final shopdata = Provider.of<AllShops>(context) ;
    final shope = shopdata.findById(shopide) ;
    return
     RefreshIndicator(
        onRefresh:() {
          return _refreshProductsmain(context);
        } ,
        child: _isLoading ? Center(
        child : CircularProgressIndicator(),
      ) :
     CustomScrollView(
     
          slivers:<Widget>[ 
            SliverFixedExtentList(
              delegate: SliverChildListDelegate([
                   Container (
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal : 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children : <Widget> [
                    SizedBox(height : 25) ,
                   GestureDetector(
                     onDoubleTap: () {
                           Scaffold.of(context).hideCurrentSnackBar();
                           Scaffold.of(context).showSnackBar(SnackBar(
                           content: Text(
                              'Seller Contact No: ${shope.contactNo}',
                              style: TextStyle(color : Color.fromRGBO(0, 255, 128, 1), ),
                               textAlign: TextAlign.center,
                                ),
                             duration: Duration(seconds: 4),
                             
                               ));
                     },
                     child: Text( shope.title , 
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 20,color: Colors.teal ),
                            maxLines: 1,
                            ),
                   ),
                          SizedBox(
                            height: 15 ,
                          ),
                    Text( shope.description , 
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 14,color: Colors.black45 ),
                          maxLines: 1,
                          ),
                    SizedBox(height : 15) ,
                    Container(
                      width : MediaQuery.of(context).size.width-20,
                       decoration: BoxDecoration(
                         border: Border(bottom: BorderSide(color: Colors.lime, width : 1.5))
                       ),
                    ),
                     
                     Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlatButton.icon(
                            padding: EdgeInsets.all(0),
                            clipBehavior: Clip.none,
                           // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            onPressed: (){
                              showDialog(
                                 context: context,
                                 barrierDismissible: true, 
                                 builder: (context) {
                                 return RatingDialog(
                                 icon: Icon(Icons.store_mall_directory,
                                      size: 100, color: Colors.red,
                                      ), 
                                      title: shope.title,
                                      description:
                                             shope.description,
                                      submitButton: "SUBMIT",
                                      positiveComment: "We are so happy to hear your Positive Comment:)", 
                                      negativeComment: "We're sad to hear but Thank For your Comment :(", 
                                      accentColor: Colors.red, 
                                      onSubmitPressed: (int rating) {
                                           shopdata.rating(shope.id, rating ,shope.eid);
                                      },
                                   );
                                 });
                            }, 
                            icon: Icon(Icons.star ,size: 25 , color: Colors.blue, ), 
                            label: Text(shope.rating.toStringAsFixed(1).toString() , style: TextStyle(color : Colors.blue),)
                            ),
                          
                          Container(
                            width: MediaQuery.of(context).size.width -250,
                            child: Text('$distance KM approx..', style: TextStyle(color: Colors.black38) , maxLines: 1,)),
                        ],
                      ),
                      Container(
                      width : MediaQuery.of(context).size.width-20,
                       decoration: BoxDecoration(
                         border: Border(bottom: BorderSide(color: Colors.lime, width : 1.5))
                       ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical :9),
                      child: Row(
                       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children : <Widget> [
                          Container (child: Icon(Icons.location_on  , color: Colors.red, size: 30,),),
                          Container(
                            width: MediaQuery.of(context).size.width-70,
                            child: Text(shope.location.address, textAlign: TextAlign.right , style: TextStyle(fontSize: 14) , maxLines: 1,))
                        ]
                      ),
                    ),
                     Container(
                      width : MediaQuery.of(context).size.width-20,
                       decoration: BoxDecoration(
                         border: Border(bottom: BorderSide(color: Colors.lime, width : 1.5))
                       ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical :9),
                      child: Row(
                       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children : <Widget> [
                          Container (child: Icon(Icons.contact_phone , size: 30,),),
                          Container(
                            width: MediaQuery.of(context).size.width-70,
                            child: Text(shope.contactNo.toString(), textAlign: TextAlign.right , style: TextStyle(fontSize: 14) , maxLines: 1,))
                        ]
                      ),
                    ),
                       Container(
                      width : MediaQuery.of(context).size.width,
                       decoration: BoxDecoration(
                         border: Border(bottom: BorderSide(color: Colors.blueGrey, width : 1.5))
                       ),
                    ),
                  
                  ]
                ), 
             ),
              ]
              ), 
              itemExtent:260
              ),

              gproducts.length==0 ?  SliverFixedExtentList(delegate:SliverChildListDelegate([]), itemExtent: 0)  :   SliverFixedExtentList(
             delegate: 
             SliverChildListDelegate([Container(
               padding: EdgeInsets.symmetric(horizontal : 15),
               child: Text('MOST TRENDY' , style: 
               TextStyle(fontSize : 20 , fontWeight: FontWeight.bold)),
               
               ),
               Divider(),
               ]), itemExtent: 25),
        SliverGrid(
          delegate:
          
           SliverChildBuilderDelegate(
            (ctx , i) {
               return ConsumerShop(
                id: gproducts[i].id,
                image: gproducts[i].image,
                title: gproducts[i].title,
                price: gproducts[i].price,
                quantity: gproducts[i].availability ,
                shopname: shopide ,
              ) ;
            },
            childCount : gproducts.length ,
          ) ,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2 ,
                childAspectRatio: (MediaQuery.of(context).size.width-31)/380,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                ),
          ),

        //  Container(child: Text('Other Products')),
          //Divider(),
          lproducts.length==0 ?  SliverFixedExtentList(delegate:SliverChildListDelegate([Container(
            width: double.infinity,
            child: Text( gproducts.length==0 ?'Sorry!! No Products Added by Seller' :'', style: TextStyle(color: Colors.red) , textAlign: TextAlign.center,))]), itemExtent: 20)  :  SliverFixedExtentList(
             delegate: 
             SliverChildListDelegate([Container(
               padding: EdgeInsets.symmetric(horizontal : 15),
               child: Text('OTHER PRODUCTS' , style: 
               TextStyle(fontSize : 20 , fontWeight: FontWeight.bold)),
               
               ),
               Divider(),
               ]), itemExtent: 25),

           SliverList(delegate: 
            SliverChildBuilderDelegate(
            (ctx , i) {
               return 
               Column(
                 children : <Widget>[ 
                  list.ListView(
                  id: lproducts[i].id,
                  title: lproducts[i].title,
                  price: lproducts[i].price,
                  quantity: lproducts[i].availability ,
                  shopname: shopide ,
                  ),
                  Divider(),
                 ]
               ) ;
              
            },
            childCount : lproducts.length ,
          ) ,
           )
      ],
    ) ,    
     );
  }
}