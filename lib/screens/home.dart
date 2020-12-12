import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopex/providers/auth.dart';
import 'package:shopex/screens/shops_screen.dart';
import 'package:shopex/screens/splash_screen.dart';

class HomePage extends StatefulWidget {
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isloading = false ;
  var _isinIt = true ;
  @override
  
  void didChangeDependencies() async {
      if(_isinIt){
       setState(() {
         _isloading = true ;
       });
       await Provider.of<Auth>(context).fetchandset() ;
        setState(() {
          _isloading = false ;
        });
      }
      _isinIt = false  ;
       super.didChangeDependencies();
  }
  @override
  
  Widget build(BuildContext context){
    return _isloading ? SplashScreen() : Shops() ;
    
  }
}

