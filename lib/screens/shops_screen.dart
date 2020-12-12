import 'package:shopex/providers/auth.dart';

import '../models/shops_model.dart';
import '../providers/cart.dart';
import 'package:geolocator/geolocator.dart';
import '../providers/all_shops.dart';
import '../providers/like_shop.dart';
import '../screens/cart_screen.dart';
import '../screens/shop_screen.dart';
import '../widgets/all_shopstile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';

class Shops extends StatefulWidget {

  static const routeName = '/allshop-page';
  @override
  _ShopsState createState() => _ShopsState();
}
class _ShopsState extends State<Shops> {
  var _isinIt = true ;
  var _isinIt1 = true ;
  var _isLoading = true ;
 // Position lo ;
   

 Future <void> _refreshProductsmain(BuildContext context) async {
  setState(() {
    _isLoading = true ;
  });
   bool status1 = await Geolocator().isLocationServiceEnabled() ;
     if(!status1){
       showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            title: Text('Location Services not Enabled!!'),
            content: Text('Please Enable your Location to find nearby Shops'),
            actions: <Widget>[
              FlatButton(
                child: Text('CLOSE'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
     }
    // Provider.of<Cart>(context).fetchAndSetPlaces();
     await Provider.of<LikeShops>(context).fetchAndSetLikes() ;
     await Provider.of<AllShops>(context).fetchAndSetProducts() ;
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
      bool status1 = await Geolocator().isLocationServiceEnabled() ;
     if(!status1){
       showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            title: Text('Location Services not Enabled!!'),
            content: Text('Please Enable your Location to find nearby Shops'),
            actions: <Widget>[
              FlatButton(
                child: Text('CLOSE'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
    );
     }
      await Provider.of<LikeShops>(context).fetchAndSetLikes() ;
      Provider.of<AllShops>(context).fetchAndSetProducts().then((_) {
         setState(() {
           _isLoading = false ;
         });
      });
   }
   _isinIt = false ;
    super.didChangeDependencies();
   }

  Future <void> cartload() async {
     if(_isinIt1){
     setState(() {
       _isLoading = true; 
     });
     
     await Provider.of<Cart>(context).fetchAndSetPlaces().then((_) {
         setState(() {
           _isLoading = false ;
         });
      }
      );
   }
   Navigator.of(context).pushNamed(CartScreen.routeName ) ;
   _isinIt1 = false ;
   }

  @override
  Widget build(BuildContext context) {
    var shopslist = Provider.of<AllShops>(context).shopslist ;
    return Scaffold(
      appBar: AppBar(
        title: Text('ShopeX' ,
        style: GoogleFonts.portLligatSans(
                     textStyle: Theme.of(context).textTheme.display1,
                     fontSize: 30,
                     fontWeight: FontWeight.w700,
                     color: Colors.black,
                     ),
        ),
        backgroundColor: Color.fromRGBO(0, 255, 128, 1) ,
        actions: <Widget> [
         
              IconButton(
                icon: Icon(Icons.search), 
                onPressed: (){
                   List<String> shopname = Provider.of<AllShops>(context).namelist() ;
                   List<String> disname = Provider.of<AllShops>(context).dislist() ;
                    List<String> ret = [] ;
                    List<String> dis = [] ;
                    for(int i=0 ; i<shopname.length ; i++){
                           ret.add(shopname[i].toLowerCase()) ;
                         //  dis.add(disname[i].toLowerCase());
                           dis.add(shopname[i].toLowerCase() + ' ' + disname[i].toLowerCase());
                            }
                   //  List<String> combo(){
  //                          List<String> combo = [] ;
  //                          for(int i=0 ; i<shopname.length ; i++){
  //                          combo.add(shopname[i] + ' ' + dis[i]);
  //                          }
  //  // return combo ;
//  }
                showSearch(context: context, delegate: DataSearch(ret , dis)) ;
                }) ,
                 IconButton(
                icon: Icon(
                  Icons.shopping_cart
                  ),
                  onPressed: () async {
                    await cartload() ;
                  },
              ),
        ]
      ),
      drawer: AppDrawer(),
      body:
      RefreshIndicator(
        onRefresh:() {
          return _refreshProductsmain(context);
        } ,
        child : _isLoading ? Center(
        child : CircularProgressIndicator(),
      ) :
      
      AllShopsTile(slist :shopslist , liked: false,) ,
    ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final List<String> name ;
  final List<String> dis ;
  DataSearch(this.name , this.dis) ;
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

  @override
  Widget buildResults(BuildContext context) {
    List<ShopsModel> shops = Provider.of<AllShops>(context).getshoplist(mainlist);
    return AllShopsTile(slist: shops , liked : false);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> shps = [] ;
    for(int i=0 ; i<name.length ; i++){
      if(dis[i].contains(query.toLowerCase())){
        shps.add(name[i]);
      }
    }
    final suggestionlist = query.isEmpty ? name :shps ;
    mainlist = suggestionlist ;
    return ListView.builder(
      itemBuilder: (context , index) => ListTile(
        leading :Icon(Icons.store_mall_directory),
        onTap: () {
        String id = Provider.of<AllShops>(context).getidbyindex(suggestionlist[index]) ;
        Navigator.of(context).pushReplacementNamed(ShopOfScreen.routeName,
                  arguments: id);
        },
        title:  
        Text(suggestionlist[index] , style : TextStyle(color: Colors.grey , fontWeight: FontWeight.bold),)
      ),
      itemCount: suggestionlist.length,
      );
  }
  
}