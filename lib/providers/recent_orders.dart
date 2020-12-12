import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'cart.dart';

class Rorder {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime; 
  final String city ;
  final String locality ;
  //final int pin ;
  final String name ;
  final int number ;
  final String pick ;


Rorder({
  @required this.id ,
  @required this.amount,
  @required this.products,
  @required this.dateTime ,
  @required this.city,
  @required this.locality ,
 // @required this.pin ,
  @required this.name ,
  @required this.number, 
  @required this.pick
});

}

class RecentOrderpro with ChangeNotifier {
  List<Rorder> _rorderlist = [] ;

    final String authToken ;
    final String userId ;
    RecentOrderpro(this.authToken , this.userId , this._rorderlist);

   List<Rorder> get rorderlist {
     return [..._rorderlist];
   }

Future <void> fetchAndSetOrders() async {
    final url = 'https://shopex-110.firebaseio.com/sellerorders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final List<Rorder> loadedOrders = [] ;
    final extractedData = json.decode(response.body) as Map<String , dynamic >;
    if(extractedData ==null ){
      return ;
    }
    extractedData.forEach((orderId , orderData){
      loadedOrders.add(
        Rorder(
          id: orderId ,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          city: orderData['city'],
          name: orderData['name'],
          number: orderData['number'],
          locality: orderData['locality'],
          pick: orderData['pick'],
     //     pin: orderData['pin'],
          products: (orderData['products'] as List<dynamic>)
          .map(
            (item) => CartItem(
              id: item['id'],
              price: item['price'],
              quantity: item['quantity'],
              title: item['title'],
              ),
          ).toList(),
          )
      );
    });
    _rorderlist = loadedOrders.reversed.toList() ;
    notifyListeners() ;
   
   }
 List<CartItem> cartProducts ;
 double total ;

 void setcart(List<CartItem> cartProd , double jk){
   cartProducts = cartProd ;
   total = jk ;
 }


Future <void> addOrder( int number , String locality , String name , String city  , String pick ) async {
  final c = cartProducts[0].shopname ;
    final url = 'https://shopex-110.firebaseio.com/sellerorders/$c.json?auth=$authToken';
    final timestamp = DateTime.now() ;
    final response = await http.post(url, body: json.encode({
      'amount' : total ,
      'dateTime': timestamp.toIso8601String(),
      'city' : city ,
     // 'pin' : pin ,
      'locality' : locality ,
      'name' : name ,
      'number' : number ,
      'pick' : pick ,
      'products' : cartProducts.map((cp){
        return {
          'id' : cp.id ,
          'title' : cp.title,
          'quantity' : cp.quantity,
          'price' : cp.price,
        };
      }).toList()
      
    }),
    );
     _rorderlist.insert(0,
     Rorder(
      id: json.decode(response.body)['name'],
      amount: total,
      dateTime: DateTime.now(),
      products: cartProducts,
      city: city,
      locality: locality ,
      number: number ,
      pick: pick,
    //  pin: pin ,
      name: name ,
      ),
      );
      notifyListeners();
   } 


  Future<void> deleteallorders ()async{
    // final c = cartProducts[0].shopname ;
    final url = 'https://shopex-110.firebaseio.com/sellerorders/$userId.json?auth=$authToken';
    await http.delete(url);
    _rorderlist.clear() ;
    notifyListeners() ;
  }

}