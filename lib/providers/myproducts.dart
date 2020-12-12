import '../models/http_exception.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyProducts with ChangeNotifier {
   List<ProductModel> _myProducts = [
   ] ;

   final String authToken ;
    final String userId ;
    MyProducts(this.authToken , this.userId , this._myProducts);

   List<ProductModel> get myProducts {
     return [..._myProducts] ;
   }

   List<ProductModel> findbysid(String sid) {
     return _myProducts.where((prod) => prod.sid==sid).toList() ;
   }

   List<ProductModel> findbysidforme() {
     return _myProducts.where((prod) => prod.sid==userId).toList() ;
   }

   ProductModel findById(String id){
    return _myProducts.firstWhere((prod) => prod.id==id);
   }

   List<ProductModel> getprolist (List<String> names){
    List<ProductModel> f = [] ;
    for(int i=0 ; i<names.length ; i++){
      var  x = myProducts.indexWhere((test) => test.title.toLowerCase() == names[i]) ;
      f.add(findById(myProducts[x].id));
    }
    return f ;
  }

   List<String> prolist () {
    List<String> relist  = [] ;
    for(int i=0 ; i<myProducts.length ; i++) {
      relist.add(myProducts[i].title) ;
    }
    return relist ;
  }

  Future <void> fetchAndSetProducts([String seid] ) async {
    final sid = seid==null ? userId : seid ;
    final filterString = 'orderBy="sid"&equalTo="$sid"' ; 
    final url = 'https://shopex-110.firebaseio.com/allproducts.json?auth=$authToken&$filterString';
    try{
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String ,dynamic> ;
       if(extractedData ==null ){
          return null;
       }
      final List<ProductModel> loadedProducts = [] ;
      extractedData.forEach((prodId ,  prodData){
        loadedProducts.insert(0,
        ProductModel(
        id: prodId ,
        title : prodData['title'],
        availability: prodData['availability'],
        price: prodData['price'],
        image: prodData['image'],
        sid: prodData['sid']
        ));
      });
      _myProducts = loadedProducts ;
      notifyListeners();
    }catch(error){
      throw error ;
    }
  }

  Future <void> addProduct(ProductModel product) async{
     final url = 'https://shopex-110.firebaseio.com/allproducts.json?auth=$authToken';
     try {
   final response = await http.post(url , 
    body: json.encode({
      'title': product.title,
      'price': product.price,
      'image' : product.image,
      'sid' : userId,
      'availability' : product.availability,
    }), );
      final newProduct = ProductModel(
      title: product.title ,
      availability: product.availability,
      price: product.price,
      image: product.image,
      id: json.decode(response.body)['name'], 
    //  id: DateTime.now().toString(),
      sid: userId ,
    );
    _myProducts.insert(0 , newProduct);
    notifyListeners();
    }
    catch(error){
       throw error ;
    }
  }

  Future<void> updateProduct (String id ,ProductModel newProduct) async{
  final prodIndex =  _myProducts.indexWhere((prod) => prod.id == id) ;
    final url = 'https://shopex-110.firebaseio.com/allproducts/$id.json?auth=$authToken';
  await http.patch(url , body: json.encode({
      'title': newProduct.title,
      'price': newProduct.price,
      'image' : newProduct.image,
      'availability' : newProduct.availability,
  }));
  _myProducts[prodIndex]  = newProduct ;
notifyListeners() ;
}

Future <void> deleteProduct (String id) async {
  final url = 'https://shopex-110.firebaseio.com/allproducts/$id.json?auth=$authToken';
     final existingProductIndex = _myProducts.indexWhere((prod) => prod.id == id);
     var existingProduct = _myProducts[existingProductIndex];
    _myProducts.removeAt(existingProductIndex) ;

    notifyListeners() ;
     final response = await http.delete(url) ;
    if(response.statusCode >= 400){
      _myProducts.insert(existingProductIndex, existingProduct);
    notifyListeners();
         throw HttpException('Could not delete Product. you might not connected to internet');
    }
    existingProduct = null ;

}

void deleteownproducts () {
    for (int i=0 ; i<_myProducts.length ; i++) {
       if(_myProducts[i].sid == userId) {
         _myProducts.removeAt(i) ;
         i = i -1 ;
       }
    }
}
   
}