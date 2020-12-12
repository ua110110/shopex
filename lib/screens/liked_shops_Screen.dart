import '../providers/all_shops.dart';
import '../providers/like_shop.dart';
import '../widgets/all_shopstile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';

class LikedShops extends StatefulWidget {

static const routeName = '/Likedshops-page';
  
  @override
  _LikedShopsState createState() => _LikedShopsState();
}

class _LikedShopsState extends State<LikedShops> {
  

  @override
  Widget build(BuildContext context) {
    final shopsli = Provider.of<LikeShops>(context).likeshopslist ;
    final shopslist = Provider.of<AllShops>(context).slbyidl(shopsli) ;
    return Scaffold(
      appBar: AppBar(
        title: Text('Liked Shops'),
        backgroundColor: Color.fromRGBO(0, 255, 128, 1),
      ),
      drawer: AppDrawer(),
      body:AllShopsTile(slist :shopslist , liked: true,) ,
    );
  }
}