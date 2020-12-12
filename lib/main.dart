import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopex/screens/Login.dart';
import 'package:shopex/screens/Signup.dart';
import 'package:shopex/screens/home.dart';

import './providers/auth.dart';
import './providers/cart.dart';
import './providers/like_shop.dart';
import './providers/orders.dart';
import './providers/recent_orders.dart';
import './screens/auth_screen.dart';
import './screens/cart_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/edit_shop_screen.dart';
import './screens/help_screen.dart';
import './screens/liked_shops_Screen.dart';
import './screens/new_shop.dart';
import './screens/orders_screen.dart';
import './screens/recent_orders_screen.dart';
import './screens/seller_orders_screen.dart';
import './screens/shop_screen.dart';
import './screens/splash_screen.dart';
import './providers/all_shops.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/shops_screen.dart';
import './screens/myshop_screen.dart';
import './providers/myproducts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[
        ChangeNotifierProvider.value(
           value: Auth(),
           ),
         ChangeNotifierProxyProvider<Auth, MyProducts>(
          builder: (ctx, auth, previousProducts) => MyProducts(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.myProducts,
              ),
        ),
         ChangeNotifierProxyProvider<Auth,RecentOrderpro>(
          builder: (ctx, auth, previousProducts) => RecentOrderpro(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.rorderlist,
              ),
        ),
        ChangeNotifierProxyProvider<Auth, AllShops>(
          builder: (ctx, auth, previousProducts) => AllShops(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.shopslist,
              ),
        ),
        ChangeNotifierProxyProvider<Auth, Cart>(
          builder: (ctx, auth, previousProducts) => Cart(
                auth.token,
                auth.userId,
                previousProducts == null ? {} : previousProducts.items,
              ),
        ),
         ChangeNotifierProxyProvider<Auth, Orders>(
          builder: (ctx, auth, previousProducts) => Orders(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.orders,
              ),
        ),
         ChangeNotifierProxyProvider<Auth, LikeShops>(
          builder: (ctx, auth, previousProducts) => LikeShops(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.likeshopslist,
              ),
        ),
      ] ,
       child :MaterialApp(
          title: 'ShopeX',
          theme: ThemeData(
          primarySwatch: Colors.lightGreen,
          ),
           home: MainScreen(),
          debugShowCheckedModeBanner: false ,
          routes: {
             Shops.routeName: (ctx) => Shops() ,
             MyShop.routeName: (ctx) => MyShop() ,
             ShopOfScreen.routeName: (ctx) => ShopOfScreen() ,
             EditProductScreen.routeName: (ctx) => EditProductScreen() ,
             EditShopScreen.routeName: (ctx) => EditShopScreen() ,
             CartScreen.routeName: (ctx) => CartScreen() ,
             OrdersScreen.routeName: (ctx) => OrdersScreen() ,
             LikedShops.routeName: (ctx) => LikedShops() ,
             NewShop.routeName: (ctx) => NewShop() ,
             SellerOrdersScreen.routeName: (ctx) => SellerOrdersScreen() ,
             RecentOrders.routeName: (ctx) => RecentOrders() , // only for check --------------------
             Help.routeName: (ctx) => Help() ,
             SignupPage.routeName: (ctx) => SignupPage() ,
          },
        ),
      
    );
  }
}

class MainScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context,AsyncSnapshot<FirebaseUser> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting)
          return SplashScreen();
        if(!snapshot.hasData || snapshot.data == null)
          return LoginPage();
        return HomePage();
      },
    );
  }
}
