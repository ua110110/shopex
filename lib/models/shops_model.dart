import 'package:flutter/foundation.dart';

class ShopsModel {
  final String title ;
  final String description ;
  PlaceLocation location ;
  final int contactNo ;
  final String image ;  
  final String id ;
  double rating ;
  List<RatingList> ratinglist ;
  final String eid ;

  ShopsModel({
    @required this.title ,
    @required this.description ,
    this.location, 
    @required this.contactNo ,
    this.image ,  
    @required this.id,
    this.rating ,
    this.ratinglist ,
    this.eid
  });

}

class PlaceLocation{
  final double latitude ;
  final double longitude ;
  final String address ;

   PlaceLocation({
    @required this.latitude ,
    @required this.longitude ,
    this.address ,
  });
}

class RatingList {
  final String userId ;
  double urating ;

  RatingList({
     this.userId ,
     this.urating,
  });
}