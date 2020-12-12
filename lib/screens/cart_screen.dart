import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';
import '../providers/recent_orders.dart';
import '../screens/seller_orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart' ;

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context) ;
    return
     Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
        backgroundColor: Color.fromRGBO(0, 255, 128, 1),
      ),
      body: Column(
        children : <Widget> [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding:EdgeInsets.all(8) ,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget> [
                  Text('Total' , style: TextStyle(fontSize: 20) ,),
                  Spacer(),
                  Chip(label: Text('₹${cart.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.title.color,
                    ),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart)
                ],
              ),
              ),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: ListView.builder(
                itemCount: cart.itemCount,
                itemBuilder: (ctx , i) => CartItem(
                  cart.items.values.toList()[i].id , 
                  cart.items.keys.toList()[i],
                  cart.items.values.toList()[i].price,
                  cart.items.values.toList()[i].quantity,
                  cart.items.values.toList()[i].title,
                  ),
                ),
                ),
        ]
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false ;


  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)? null : () async { 
        setState(() {
          _isLoading = true ;
        });
       
      Provider.of<RecentOrderpro>(context , listen: false).setcart(widget.cart.itemswithoutproid.values.toList(),  widget.cart.totalAmount);

      await Navigator.of(context).pushNamed(SellerOrdersScreen.routeName,
                  );
      if(Provider.of<Orders>(context, listen: false).ex()){
       await Provider.of<Orders>(context, listen: false).addOrder(widget.cart.itemswithoutproid.values.toList() , widget.cart.totalAmount  ) ;
      }
      
      if(Provider.of<Orders>(context, listen: false).ex()){
        await widget.cart.clear() ;
      Provider.of<Orders>(context, listen: false).ex(false) ;
      }
        setState(() {
         _isLoading = false ;
       });
      },
      textColor: Theme.of(context).primaryColor,
      );
  }
}