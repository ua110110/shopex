import 'package:shopex/models/product_model.dart';
import 'package:shopex/providers/myproducts.dart';
import 'package:shopex/widgets/cunsumer_shop_product.dart';
import '../widgets/listview.dart' as list;
import '../providers/all_shops.dart';
import '../providers/cart.dart';
import '../providers/like_shop.dart';
import '../screens/cart_screen.dart';
import '../widgets/badge.dart';
import '../widgets/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopOfScreen extends StatefulWidget {

  static const routeName = '/shop-page';
  
  @override
  _ShopOfScreenState createState() => _ShopOfScreenState();
}

class _ShopOfScreenState extends State<ShopOfScreen> {
  var heart = true ;
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct =
        Provider.of<AllShops>(context, listen: false).findById(productId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 255, 128, 1),
        actions : <Widget> [
          IconButton(
            icon: Icon(Icons.search), 
            onPressed: () async {
               List<String> shopname = Provider.of<MyProducts>(context).prolist() ;
                    List<String> ret = [] ;
                    for(int i=0 ; i<shopname.length ; i++){
                           ret.add(shopname[i].toLowerCase()) ;
                            }
                await showSearch(context: context, delegate: DataSearch(ret)) ;
            }
            ),
          Consumer<Cart>(  
             builder: (_ , cart ,ch) =>
              Badge(
                child: ch,
                 value: cart.itemCount.toString() ,
                 color: Colors.red,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.shopping_cart
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName ) ;
                  },
              ),
          ),

          Consumer<LikeShops>(
                  builder: (ctx , prodata , ch) => heart ? IconButton(
                  icon: Icon(
                    
                   prodata.cheak(loadedProduct.id) ? (Icons.favorite ): Icons.favorite_border ,
                   color: Colors.red ,
                    ),
                    onPressed: () async {
                     setState(() {
                       heart = false ;
                     });
                     await Provider.of<LikeShops>(context).addlikeshop(
                        loadedProduct.id ,
                     ) ;
                     setState(() {
                       heart = true ;
                     });
                    },
                ) : Container(
                  width: 47,
                  padding: EdgeInsets.symmetric(vertical : 15 , horizontal: 12),
                  child: CircularProgressIndicator()) ,
          ),
        ]
      ),
      body: ProductGrid(loadedProduct.id) ,
    );
  }
}


class DataSearch extends SearchDelegate<String> {

  final List<String> name ;
  DataSearch(this.name ) ;
  List<String> mainlist = [] ;
  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed:() { 
      query = '' ;
    })];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
        ), 
        onPressed: () {
          close(context, null);
        }  );
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
  Widget buildResults(BuildContext context) {
    List<ProductModel> products = Provider.of<MyProducts>(context).getprolist(mainlist);
    final gproducts = gproduct(products);
    final lproducts = lproduct(products);
    return CustomScrollView(
          slivers:<Widget>[ 

             gproducts.length==0 ?  SliverFixedExtentList(delegate:SliverChildListDelegate([]), itemExtent: 0)  :  SliverFixedExtentList(
             delegate: 
             SliverChildListDelegate([Container(
               padding: EdgeInsets.only(left: 15 , right: 15 , top: 10),
               child: Text('MOST TRENDY' , style: 
               TextStyle(fontSize : 20 , fontWeight: FontWeight.bold)),
               
               ),
               Divider(),
               ]), itemExtent: 30),
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
                shopname: gproducts[i].sid ,
              ) ;
            },
            childCount : gproducts.length ,
          ) ,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: (MediaQuery.of(context).size.width-31)/380,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                ),
          ),

            lproducts.length==0 ?  SliverFixedExtentList(delegate:SliverChildListDelegate([Container(
            width: double.infinity,
            child: Text( gproducts.length==0 ?'Sorry!! No Products Added by Seller' :'', style: TextStyle(color: Colors.red) , textAlign: TextAlign.center,))]), itemExtent: 20)  : SliverFixedExtentList(
             
             delegate: 
             SliverChildListDelegate([Container(
               padding: EdgeInsets.only(left : 15 , right: 15 , top: gproducts.length==0 ? 10 : 0),
               child: Text('OTHER PRODUCTS' , style: 
               TextStyle(fontSize : 20 , fontWeight: FontWeight.bold)),
               
               ),
               Divider(),
               ]), itemExtent:gproducts.length==0 ? 30 : 25),

          SliverList(delegate: 
            SliverChildBuilderDelegate(
            (ctx , i) {
               return 
               Column(
                 children : <Widget>[ list.ListView(
                  id: lproducts[i].id,
                  title: lproducts[i].title,
                  price: lproducts[i].price,
                  quantity: lproducts[i].availability ,
                  shopname:  lproducts[i].sid,
                  ),
                  Divider(),
                 ]
               ) ;
              
            },
            childCount : lproducts.length ,
          ) ,
           )
      ],
    );
             
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionlist = query.isEmpty ? name : name.where((p) => p.contains(query.toLowerCase())).toList() ;
    mainlist = suggestionlist ;
    return ListView.builder(
      itemBuilder: (context , index) => ListTile(
        leading :Icon(Icons.shopping_cart),
        onTap: () {
          
        },
        title:  
        Text(suggestionlist[index] , style : TextStyle(color: Colors.grey , fontWeight: FontWeight.bold),)
      ),
      itemCount: suggestionlist.length,
      );
  }
  
}