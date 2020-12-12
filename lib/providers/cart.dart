import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String shopname ;
 

CartItem({
  @required this.id,
  @required this.title,
  @required this.quantity,
  @required this.price,
  @required this.shopname ,
  });
}

class CartItemr {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String shopname ;
  final String proid ;

CartItemr({
  @required this.id,
  @required this.title,
  @required this.quantity,
  @required this.price,
  @required this.shopname,
  @required this.proid
  });
}

class Cart with ChangeNotifier{
  Map<String, CartItemr> _items = {};

  Map<String, CartItemr> get items {
    return {..._items};
  }

  Map<String , CartItem> get itemswithoutproid {
    Map<String , CartItem> h = {} ;
    _items.forEach((key, cartItem) {
       h.putIfAbsent(key, () {
         return CartItem(
           id: cartItem.id , 
           title: cartItem.title , 
           quantity:cartItem.quantity, 
           price: cartItem.price , 
           shopname: cartItem.shopname);
       });
    });
    return h ;
  }

  final String authToken ;
    final String userId ;
    Cart(this.authToken , this.userId , this._items);

   var initial = false ;
  Future<void> fetchAndSetPlaces() async {
    
    if(!initial){
    final url = 'https://shopex-110.firebaseio.com/cart/$userId.json?auth=$authToken';
     final response = await http.get(url);
    final List<CartItemr> c = [] ;
    final extractedData = json.decode(response.body) as Map<String , dynamic >;
    if(extractedData ==null ){
      return ;
    }
        extractedData.forEach((orderId , orderData){
      c.add(
        CartItemr(
          id: orderData['id'] ,
          title: orderData['title'] ,
          price: orderData['price']  ,
          quantity: orderData['quantity'],
          shopname: orderData['shopname'],
          proid: orderId ,
          )
      );
    });


    _items = {} ;
    for(int i=0 ; i<c.length ; i++) {
        _items.putIfAbsent( c[i].id ,
       ()=> CartItemr(
         id: c[i].id , 
         title: c[i].title , 
         price: c[i].price ,
         quantity: c[i].quantity ,
         shopname: c[i].shopname ,
         proid: c[i].proid ,
         ));
    }
    initial = true ;
    notifyListeners() ;
    }
  }

  int get itemCount {
    return  _items.length ;
  }

  double get totalAmount {
    double total = 0 ;
    _items.forEach((key, cartItem) {
       total += cartItem.price*cartItem.quantity ;
    });
    return total ;
  }

  int  quantity (String id) {
    if (_items.containsKey(id)){
     return _items[id].quantity ;
    }
    return 0 ;
  }

  bool checksame (String shon) {
    int k = 0 ;
     _items.forEach((key, cartItem) {
       if(cartItem.shopname == shon)
       {
          k = k + 1 ;
       }
    });
    if(k==items.length) {
      return true ;
    }
    return false ;
  }

  Future <void> addItem(
    String productId, 
    double price , 
    String title ,
    String shopname,
    
    )async{

    if (_items.containsKey(productId))  {
          String jp = _items[productId].proid ;
         final url = 'https://shopex-110.firebaseio.com/cart/$userId/$jp.json?auth=$authToken';
    final response = await http.patch(url, body: json.encode({
      'quantity' : _items[productId].quantity + 1 ,
      
    }),
    );
      _items.update(
        productId, 
       (existingCartItem)  {
     
       return CartItemr(
         proid:  existingCartItem.proid ,
         title: existingCartItem.title,
         price: existingCartItem.price,
         quantity: existingCartItem.quantity + 1 ,
         shopname: existingCartItem.shopname,
         id: productId  ,
        );
         }
      );
     

    }
    else {
      final url = 'https://shopex-110.firebaseio.com/cart/$userId.json?auth=$authToken';
    final response = await http.post(url, body: json.encode({
      'id' : productId,
      'title': title ,
      'price' : price  ,
      'quantity' : 1 ,
      'shopname' : shopname ,
      
    }),
    );
      _items.putIfAbsent(productId,
       () {
         
         return CartItemr(
         proid: json.decode(response.body)['name'] , 
         title: title , 
         price: price,
         quantity: 1,
         shopname: shopname ,
         id: productId ,
         );
         }
         );
    }
    notifyListeners() ;  
  }




Future <void> removeItem (String productId) async {
  String jp = _items[productId].proid ;
   final url = 'https://shopex-110.firebaseio.com/cart/$userId/$jp.json?auth=$authToken';
   await http.delete(url) ;
   _items.remove(productId);
   notifyListeners();
}

Future <void> removeSingleItem(String productId) async {
  if(!_items.containsKey(productId)) {
    return ;
  }
  if(_items[productId].quantity > 1){
        String jp = _items[productId].proid ;
         final url = 'https://shopex-110.firebaseio.com/cart/$userId/$jp.json?auth=$authToken';
    final response = await http.patch(url, body: json.encode({
      'quantity' : _items[productId].quantity - 1 ,
      
    }),
    );
    _items.update(productId, 
      (existingCartItem) {
    
        return CartItemr(
        proid: existingCartItem.proid ,
        title: existingCartItem.title ,
        price: existingCartItem.price ,
        quantity: existingCartItem.quantity-1 , 
        shopname: existingCartItem.shopname,
        id: productId ,
        ); 
      }
    );

  }
  else  {
   await removeItem(productId) ;
    //_items.remove(productId);
  }
  notifyListeners();
}

Future<void> clear() async {
  final url = 'https://shopex-110.firebaseio.com/cart/$userId.json?auth=$authToken';
   await http.delete(url) ;
  _items = {} ;
  notifyListeners() ;
}




}

