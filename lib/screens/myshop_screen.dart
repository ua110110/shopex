import 'dart:io';
import 'package:provider/provider.dart';
import 'package:shopex/models/product_model.dart';
import 'package:shopex/providers/myproducts.dart';
import 'package:shopex/widgets/product_item.dart';

import '../screens/edit_product_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../widgets/myshops_grid.dart';

class MyShop extends StatefulWidget {
 
  static const routeName = '/Myshop-page';

  @override
  _MyShopState createState() => _MyShopState();
}

class _MyShopState extends State<MyShop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        backgroundColor: Color.fromRGBO(0, 255, 128, 1),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search), 
            onPressed: () async {
               List<String> shopname = Provider.of<MyProducts>(context).prolist() ;
                    List<String> ret = [] ;
                    for(int i=0 ; i<shopname.length ; i++){
                           ret.add(shopname[i].toLowerCase()) ;
                            }
                await showSearch(context: context, delegate: DataSearch(ret)) ;
            }
            ),
           IconButton(
            icon: Icon(Icons.add), 
            onPressed:() {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            ),
        ],
      ),
      drawer: AppDrawer(),
      body: MyShopsGrid() ,
       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:Platform.isIOS ?
      Container() 
      :FloatingActionButton(
        backgroundColor: Color.fromRGBO(0, 255, 128, 1),
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context).pushNamed(EditProductScreen.routeName) ,
        ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {

  final List<String> name ;
  DataSearch(this.name ) ;
  List<String> mainlist = [] ;
  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed:() { 
      query = '' ;
    })];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
        ), 
        onPressed: () {
          close(context, null);
        }  );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<ProductModel> products = Provider.of<MyProducts>(context).getprolist(mainlist);
    return //Expanded(
         // child: 
          GridView.builder(
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
        //  ),
        ) ;
             
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionlist = query.isEmpty ? name : name.where((p) => p.contains(query.toLowerCase())).toList() ;
    mainlist = suggestionlist ;
    return ListView.builder(
      itemBuilder: (context , index) => ListTile(
        leading :Icon(Icons.shopping_cart),
        onTap: () {
          
        },
        title:  
        Text(suggestionlist[index] , style : TextStyle(color: Colors.grey , fontWeight: FontWeight.bold),)
      ),
      itemCount: suggestionlist.length,
      );
  }
  
}