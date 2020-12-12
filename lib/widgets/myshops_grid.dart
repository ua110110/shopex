import '../screens/edit_shop_screen.dart';
import '../screens/recent_orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/myproducts.dart';
import '../widgets/product_item.dart';

class MyShopsGrid extends StatefulWidget {
  @override
  _MyShopsGridState createState() => _MyShopsGridState();
}

class _MyShopsGridState extends State<MyShopsGrid> {
  var _isinIt = true ;

  var _isLoading = true ;

  @override
  void didChangeDependencies() {
   if(_isinIt){
     setState(() {
       _isLoading = true; 
     });
      Provider.of<MyProducts>(context).fetchAndSetProducts().then((_) {
         setState(() {
           _isLoading = false ;
         });
      });
   }
   _isinIt = false ;
    super.didChangeDependencies();
   }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<MyProducts>(context);
    final products = productData.findbysidforme() ;
    return 
    _isLoading ? Center(
        child : CircularProgressIndicator(),
      ) :
    Column(
      children: <Widget>[
        Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding:EdgeInsets.all(8) ,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget> [
                  Text('Edit Shop' , style: TextStyle(fontSize: 20) ,),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(EditShopScreen.routeName ,arguments: 'cheak');
                    }, 
                    icon: Icon(Icons.edit , color: Colors.blue,),
                    ),
                ],
              ),
              ),
            ),
            Card(
            margin: EdgeInsets.only(top: 0 , bottom: 10 ,right: 10 , left: 10),
            child: Padding(
              padding:EdgeInsets.all(8) ,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget> [
                  Text('Customer Orders' , style: TextStyle(fontSize: 20) ,),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                     Navigator.of(context).pushNamed(RecentOrders.routeName);
                    }, 
                    icon: Icon(Icons.local_offer , color: Colors.blue,),
                    ),
                ],
              ),
              ),
            ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: products.length,
            itemBuilder: (ctx , i) => ProductItem(
              id: products[i].id,
              image: products[i].image,
              title: products[i].title,
              price: products[i].price,
              quantity : products[i].availability ,
            ), 
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: (MediaQuery.of(context).size.width-31)/380,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              ),
          ),
        ),
      ],
    );
  }
}



