import 'package:flutter_share/flutter_share.dart';

import '../providers/all_shops.dart';
import '../providers/auth.dart';
import '../screens/help_screen.dart';
import '../screens/liked_shops_Screen.dart';
import '../screens/myshop_screen.dart';
import '../screens/orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget> [
            AppBar(
              backgroundColor: Color.fromRGBO(0, 255, 128, 1) ,
              title: Column(
                children: <Widget>[
                  Text('Hello!!' ,
                  style: GoogleFonts.portLligatSans(
                           textStyle: Theme.of(context).textTheme.display1,
                           fontSize: 30 ,
                           fontWeight: FontWeight.w700,
                           color: Colors.black,
                           ),),
                ],
              ),
              automaticallyImplyLeading: false,
              ),
             
              Divider(),
              ListTile(
                leading: Icon(Icons.shop_two , color: Colors.orangeAccent,),
                title: Text('Shops'),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/');
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.favorite , color: Colors.red,),
                title: Text('Liked Shops'),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(LikedShops.routeName);
                },
              ),
              Provider.of<AllShops>(context).cheakShop() ? Divider() : Container() ,
              Provider.of<AllShops>(context).cheakShop() ? 
              ListTile(
                leading: Icon(Icons.store_mall_directory , color: Colors.blue,),
                title: Text('My Shop'),
                onTap: () {
                        Navigator.of(context).pushReplacementNamed(MyShop.routeName);
                },
              )
               : Container() ,
               Divider(),
              ListTile(
                leading: Icon(Icons.local_shipping , color:  Colors.black,),
                title: Text('Orders'),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.help , color: Colors.greenAccent,),
                title: Text('Help' , ),
                onTap:  () async {
                 // Navigator.of(context).pushReplacementNamed('/');
                Navigator.of(context).pushReplacementNamed(Help.routeName);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.share , color: Colors.black,),
                title: Text('Share App' , ),
                onTap:  () async {
                                 await  FlutterShare.share(
                                       title: 'ShopeX app share',
                                       text: 'Now everyone can find their near shops in one app and can see items, contact to seller, purchase online and enjoy queueless shopping at the shops which are connected to us. Try it now by downloading it from Play store',
                                       linkUrl: 'https://play.google.com/store/apps/details?id=com.stopcram.shopex3',
                                       chooserTitle: 'ShopeX app share');
                                  
                },
              ),
               Divider(),
               SizedBox(height : 20),
               Divider(),
              ListTile(
                leading: Icon(Icons.exit_to_app , color: Colors.redAccent,),
                title: Text('Logout'),
                onTap:  () async {
                   showDialog(context: context , builder: (ctx) => AlertDialog(
                title: Text('Are you sure?') ,
                content: Text(
                'Do you want to Logout'
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Yes'), 
                    onPressed: ()async{
                      Navigator.of(ctx).pop(true);
                      Auth().logOut();
                    },),
                  FlatButton(
                    child: Text('No'), 
                    onPressed: (){
                      Navigator.of(ctx).pop(false);
                    },)
                ],
                )
                );
                },
              ),
          ],
    ),
      ),
    );
  }
}