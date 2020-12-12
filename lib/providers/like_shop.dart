import '../models/http_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class Likes {
  final String id ;
  final String saveid ;
  Likes(this.id , this.saveid);
}
class LikeShops with ChangeNotifier {
  List<Likes> _likeshopslist = [
  ] ;

  List<Likes> get likeshopslist {
    return [..._likeshopslist] ;
  }

    final String authToken ;
    final String userId ;
    LikeShops(this.authToken , this.userId , this._likeshopslist);


  bool cheak(String id){
     if(_likeshopslist.length == 0){
       return false ;
     }
     for(int i=0 ; i < _likeshopslist.length ; i++) {
        if(_likeshopslist[i].id == id){
           return true ;
        }
        else {
          return false ;
        }
      }
  }

   Future <void> fetchAndSetLikes() async {
    final url = 'https://shopex-110.firebaseio.com/likedshops/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final List<Likes> loadedOrders = [] ;
    final extractedData = json.decode(response.body) as Map<String , dynamic >;
    if(extractedData ==null ){
      return ;
    }
    extractedData.forEach((orderId , orderData){
      loadedOrders.add(
        Likes(
          orderData['id'] ,
           orderId ,
          )
      );
    });
    _likeshopslist = loadedOrders.reversed.toList() ;
    notifyListeners() ;
   
   }

 Future <void> addlikeshop(String id) async {
    
      
   if(!cheak(id)){
     final url = 'https://shopex-110.firebaseio.com/likedshops/$userId.json?auth=$authToken';
    final response = await http.post(url, body: json.encode({
      'id' : id ,
    }),
    );
      _likeshopslist.insert(0, Likes(id, json.decode(response.body)['name'])) ;
   }else{
     final existingProductIndex = _likeshopslist.indexWhere((prod) => prod.id == id);
      var existingProduct = _likeshopslist[existingProductIndex];
      var h = existingProduct.saveid ;
     final url1 = 'https://shopex-110.firebaseio.com/likedshops/$userId/$h.json?auth=$authToken';
      _likeshopslist.removeAt(existingProductIndex) ;
       notifyListeners() ;
       final response = await http.delete(url1) ;
    if(response.statusCode >= 400){
      _likeshopslist.insert(existingProductIndex, existingProduct);
    notifyListeners();
         throw HttpException('Could not delete Product. you might not connected to internet');
    }
    existingProduct = null ;
   }
   notifyListeners() ;
 
  }

}