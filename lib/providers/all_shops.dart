import '../models/http_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../models/shops_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../providers/like_shop.dart';
import 'dart:math' show cos , sqrt , sin , asin;

class AllShops with ChangeNotifier {
  List<ShopsModel> _shopslist = [
  ] ;

    final String authToken ;
    final String userId ;
    AllShops(this.authToken , this.userId , this._shopslist);

  List<ShopsModel> get shopslist {
    return [..._shopslist] ;
  }
  String getidbyindex(String name) {
    final x = shopslist.indexWhere((test) => test.title.toLowerCase() == name) ;
    return shopslist[x].id ;
  }

  List<ShopsModel> getshoplist (List<String> names){
    List<ShopsModel> f = [] ;
    for(int i=0 ; i<names.length ; i++){
      var  x = shopslist.indexWhere((test) => test.title.toLowerCase() == names[i]) ;
      f.add(findById(shopslist[x].id));
    }
    return f ;
  }

  List<String> namelist () {
    List<String> relist  = [] ;
    for(int i=0 ; i<_shopslist.length ; i++) {
      relist.add(shopslist[i].title) ;
    }
    return relist ;
  }

  List<String> dislist () {
    List<String> relist  = [] ;
    for(int i=0 ; i<_shopslist.length ; i++) {
      relist.add(shopslist[i].description) ;
    }
    return relist ;
  }

  Future<double> distance (String sid , Position loc) async {
     var u = findById(sid) ;
     double distanceInMeters = await Geolocator().distanceBetween(loc.latitude, loc.longitude, u.location.latitude, u.location.longitude);
     return distanceInMeters ;
  }
  Future <void> fetchAndSetProducts() async {
    final url = 'https://shopex-110.firebaseio.com/allshops.json?auth=$authToken';
    try{
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String ,dynamic> ;
       if(extractedData ==null ){
          return null;
       }

      final List<ShopsModel> loadedProducts = [] ;
      extractedData.forEach((prodId ,  prodData){
        loadedProducts.insert(0,
        ShopsModel (
        eid: prodId ,
        id: prodData['id'],
        title : prodData['title'],
        description: prodData['description'],
        contactNo: (prodData['contactNo'] ),
        image: prodData['image'],
        location: PlaceLocation(latitude: ( prodData['latitude'] ), longitude: ( prodData['longitude'] )  , address: prodData['address']),
        rating: (prodData['rating'] ) ,
        ratinglist: (prodData['ratinglist'] as List<dynamic>)
          .map(
            (item) => RatingList(
              urating: (item['urating'] ),
              userId: item['userId'],
              ),
          ).toList(),
        ));
      });
      
     var lo = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      QuickSort ob = new QuickSort(); 
       ob.sort(loadedProducts , 0, loadedProducts.length-1 , lo);
      _shopslist = loadedProducts ;
      notifyListeners();
    }catch(error){
      throw error ;
    }
  }



  Future <void> addProduct(ShopsModel shop) async{
    final url = 'https://shopex-110.firebaseio.com/allshops.json?auth=$authToken';
     try {
   final response = await http.post(url , 
    body: json.encode({
      'title': shop.title,
      'description':shop.description,
      'image' : shop.image,
      'contactNo' : shop.contactNo,
      'id' : userId,
      'rating' : 3.1 ,
      'ratinglist' : shop.ratinglist.map((cp) {
        return {
          'userId' : userId ,
          'urating' : 3.1 ,
      };
      }).toList(),
      'latitude' : shop.location.latitude ,
      'longitude' : shop.location.longitude,
      'address' : shop.location.address ,
    }), );
      final newProduct = ShopsModel(
      title: shop.title ,
      rating: 3 ,
      ratinglist: [
      RatingList(
        userId : userId,
        urating : 3
         )
       ],
       location: shop.location,
      description: shop.description,
      image: shop.image,
      eid: json.decode(response.body)['name'],
      id: userId ,
      contactNo: shop.contactNo ,
    );
 
    _shopslist.add( newProduct);
  
    notifyListeners();
    }
    catch(error){
       throw error ;
    }
  }

  Future<void> updateProduct (String eid , ShopsModel newshop) async{
  final prodIndex =  _shopslist.indexWhere((prod) => prod.eid == eid) ;
   final url = 'https://shopex-110.firebaseio.com/allshops/$eid.json?auth=$authToken';
    await http.patch(url , body: json.encode({
     'title' : newshop.title,
     'description' : newshop.description,
     'image' : newshop.image,
     'contactNo' : newshop.contactNo,
     'address' : newshop.location.address ,
     'latitude' : newshop.location.latitude ,
     'longitude' : newshop.location.longitude ,
   }));
  _shopslist[prodIndex]  = newshop ;
notifyListeners() ;
}
  

 Future<void> rating (String id , int rating , String eid ) async{
    
    final existingProductIndex = _shopslist.indexWhere((prod) => prod.id == id);
    if(!cheakShopbyid(id , existingProductIndex)) {
      final url = 'https://shopex-110.firebaseio.com/allshops/$eid.json?auth=$authToken';

    _shopslist[existingProductIndex].ratinglist.insert(0, RatingList(userId : userId , urating : rating.toDouble() ));
      await http.patch(url , body: json.encode(
        {
        'ratinglist' : _shopslist[existingProductIndex].ratinglist.map((cp) {
        return {
          'userId' : cp.userId ,
          'urating' : cp.urating ,
      };
      }).toList(),
        }
         ),
      );
    if(_shopslist[existingProductIndex].ratinglist.length >= 50) {
      final url2 = 'https://shopex-110.firebaseio.com/allshops/$eid/ratinglist/49.json?auth=$authToken';
      final response = await http.delete(url2) ;
      _shopslist[existingProductIndex].ratinglist.removeAt(50) ;
    }   
    double r = 0 ;
    for(int i=0 ; i < _shopslist[existingProductIndex].ratinglist.length  ; i++){
      r = r + _shopslist[existingProductIndex].ratinglist[i].urating ;
    }
    
    final url1 = 'https://shopex-110.firebaseio.com/allshops/$eid.json?auth=$authToken';
    await http.patch(url1 , body: json.encode({
     'rating' : r/_shopslist[existingProductIndex].ratinglist.length ,
   }));
     

    _shopslist[existingProductIndex].rating = r/_shopslist[existingProductIndex].ratinglist.length ;
    }
    else {
      final existingProductIndexuser = _shopslist[existingProductIndex].ratinglist.indexWhere((prod) => prod.userId == userId);
      
       final url = 'https://shopex-110.firebaseio.com/allshops/$eid/ratinglist/$existingProductIndexuser.json?auth=$authToken';
       await http.patch(url , body: json.encode({
        'urating' : rating.toDouble()  ,
   }));
      _shopslist[existingProductIndex].ratinglist[existingProductIndexuser].urating = rating.toDouble() ;
      
       double r = 0 ;
    for(int i=0 ; i < _shopslist[existingProductIndex].ratinglist.length  ; i++){
      r = r + _shopslist[existingProductIndex].ratinglist[i].urating ;
    }
     

     final url1 = 'https://shopex-110.firebaseio.com/allshops/$eid.json?auth=$authToken';
    await http.patch(url1 , body: json.encode({
     'rating' : r/_shopslist[existingProductIndex].ratinglist.length ,
   }));

    _shopslist[existingProductIndex].rating = r/_shopslist[existingProductIndex].ratinglist.length ;
    
    }
    notifyListeners();
  }


   ShopsModel findById(String id){
    return _shopslist.firstWhere((prod) => prod.id==id);
  }

  ShopsModel findownshop(){
    return _shopslist.firstWhere((prod) => prod.id==userId);
  }
   
 bool cheakShopbyid(String id , int index){
     if(_shopslist[index].ratinglist.length == 0){
       return false ;
     }
     for(int i=0 ; i < _shopslist[index].ratinglist.length ; i++) {
        if(_shopslist[index].ratinglist[i].userId == userId){
           return true ;
        }
        else {
          return false ;
        }
      }
  }

  bool cheakShop([String b]){
    String ib ;
    if(b==null) {
        ib = userId ;
    }else {
        ib = b ;
    }
     if(_shopslist.length == 0){
       return false ;
     }
     for(int i=0 ; i < _shopslist.length ; i++) {
        if(_shopslist[i].id == ib){
           return true ;
        }
      }
      return false ;
  }

  List<ShopsModel> slbyidl (List<Likes> ids) {
    List<ShopsModel> out = [] ;
    for(int i=0 ; i<ids.length ; i++) {
      if(cheakShop(ids[i].id)){
        out.add(findById(ids[i].id)) ;
      }
    }
    return out ;
  }

  String findeid(){
    var x =_shopslist.firstWhere((prod) => prod.id==userId);
    return x.eid ;
  }

 Future <void> deleteShop() async {
   String eid = findeid();
    final url = 'https://shopex-110.firebaseio.com/allshops/$eid.json?auth=$authToken';
      final existingProductIndex = _shopslist.indexWhere((prod) => prod.eid == eid);
      var existingProduct = _shopslist[existingProductIndex];
      _shopslist.removeAt(existingProductIndex) ;
    notifyListeners() ;
   
   final response = await http.delete(url) ;
    if(response.statusCode >= 400){
      _shopslist.insert(existingProductIndex, existingProduct);
    notifyListeners();
         throw HttpException('Could not delete Product. you might not connected to internet');
    }
    existingProduct = null ;
}



  }

  class QuickSort 
{ 
   
   double distance (double slat , double slon , Position loc) {
     var loc1 = (loc.latitude)/57.29577951  ;
     var loc2 = loc.longitude/57.29577951 ;
     var loc3 = slat/57.29577951 ;
     var loc4 = slon/57.29577951 ;
     double dlon = loc3-loc1 ;
     double dlat = loc4-loc2 ;
     double a = sin(dlat/2)*sin(dlat/2) + cos(loc1)*cos(loc3)*sin(dlon/2)*sin(dlon/2) ;
     double c = 2*asin(sqrt(a)) ;
     return c*6371 ;
  }
   
    int partition(List<ShopsModel> arr, int low, int high , Position lo) 
    { 
        double pivot = distance (arr[high].location.latitude , arr[high].location.longitude, lo) ;  
        int i = (low-1);
        for (int j=low; j<high; j++) 
        { 
            if (distance (arr[j].location.latitude , arr[j].location.longitude, lo) < pivot) 
            { i++ ;
                var temp = arr[i]; 
                arr[i] = arr[j]; 
                arr[j] = temp; 
            } 
        } 
        var temp = arr[i+1]; 
        arr[i+1] = arr[high]; 
        arr[high] = temp; 
  
        return i+1; 
    } 
    void sort(List<ShopsModel> arr, int low, int high , Position lo) 
    { 
        if (low < high) 
        { 
            int pi = partition(arr, low, high , lo); 
            sort(arr, low, pi-1 , lo); 
            sort(arr, pi+1, high , lo); 
        } 
    }

}
