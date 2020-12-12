import 'package:flutter/foundation.dart';

class ProductModel {
  final String title ;
  final double price ;
  final String image ;
  final int availability ;
  final String id ;
  final String sid ;

  ProductModel({
    @required this.title ,
    @required this.price,
    this.image, 
    @required this.availability,
    @required this.id ,
    @required this.sid,
  });
}