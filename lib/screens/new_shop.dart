import '../screens/edit_shop_screen.dart';
import '../widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class NewShop extends StatelessWidget {

  static const routeName = '/NewShop-page';

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = AppBar(
        title : Text('Create Shop') ,
        backgroundColor: Color.fromRGBO(0, 255, 128, 1),
      );
    return Scaffold(
      appBar: appBar,
      drawer: AppDrawer(),
      body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height-
                appBar.preferredSize.height
                - MediaQuery.of(context).padding.top,
          decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(0, 255, 128, 1).withOpacity(1),
                    Color.fromRGBO(0, 255, 255, 1).withOpacity(0.2),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0, 1],
                ),
              ),
          child: Center(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             
             children: <Widget>[
               FlatButton.icon(
                    padding: EdgeInsets.all(0),
                    onPressed: null, 
                    label: Text('Having Shop' ,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black, 
                      fontWeight: FontWeight.bold, 
                      fontSize : 40
                      ),
                      ) ,
                    icon: Icon(Icons.store_mall_directory ,size: 50, color: Colors.black,), 
                    
                  ),
                  Text('Want to Sell' ,
                  textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black , 
                      fontSize : 40 ,
                      fontWeight: FontWeight.bold,
                      ),
                      ) ,
                      Text('beyond your Reach' ,
                      textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black , 
                      fontSize : 40,
                      fontWeight: FontWeight.bold
                      ),
                      ) ,
                  Text('Connect With Us Now' ,
                  textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black , 
                      fontSize : 40,
                      fontWeight: FontWeight.bold
                      ),
                      ) ,
                      SizedBox(
                        height: 20,
                      ),
                  RaisedButton(
                    onPressed:() {
                      Navigator.of(context).pushReplacementNamed(EditShopScreen.routeName);
                    }, 
                    color: Colors.black,
                    child: Text('Create Shop Now' ,
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize : 20
                      ),
                      ) ,)
             ],
           ),
     ),
        ),
      ),
    );
  }
}