import '../widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class Help extends StatefulWidget {

  static const routeName = '/help-page';

  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  var _expanded1 = false ;
  var _expanded2 = false ;
  var _expanded3 = false ;
  var _expanded4 = false ;
  var _expanded5 = false ;
  var _expanded6 = false ;
  var _expanded7 = false ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HELP'),
        backgroundColor: Color.fromRGBO(0, 255, 128, 1),
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          SizedBox(height: 20,),
          Container(
            width: MediaQuery.of(context).size.width - 40,
            child: Text('WANT TO BECOME SELLER', style: TextStyle(color  :Colors.grey ,fontSize: 14 ), textAlign: TextAlign.left,)),
          Container(
            child : AnimatedContainer(
        duration: Duration(milliseconds: 0),
        height: _expanded1 ? 200 : 80 ,
        child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget> [
            ListTile(title: Text('Connect your shop with us' , style: TextStyle(fontSize : 16 ),),
            trailing: IconButton(
              icon: Icon(_expanded1 ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded1 = !_expanded1 ;
                });
              },
              ),
            ),
        
              AnimatedContainer(
                duration: Duration(milliseconds: 0),
                padding: EdgeInsets.symmetric(
                   horizontal: 15,
                   vertical: 4,
                ),
                height: _expanded1 ? 120 : 0,
                child: Container(
                  child : Column(
                    children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width - 40,
                            child: Text( 'Thanks for choosing us', 
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 20,color: Colors.black ),
                            maxLines: 1,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 40,
                            child: Text( 'MAIL US', 
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 30 ,color: Colors.red  ),
                            maxLines: 1,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 40,
                            child: Text( 'shopexqueries@gmail.com', 
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 20,color: Colors.black ),
                            maxLines: 1,
                            ),
                          ),
                     
                      
                    ],
                  )
                )
              )
            ]
        )
      ) )
       ),
        SizedBox(height: 20,),
          Container(
            width: MediaQuery.of(context).size.width - 40,
            child: Text('HELP WITH OTHER QUERIES', style: TextStyle(color  :Colors.grey ,fontSize: 14), textAlign: TextAlign.left,)), 
          Container(
            child : AnimatedContainer(
        duration: Duration(milliseconds: 0),
        height: _expanded2 ? 200 : 80 ,
          child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget> [
            ListTile(title: Text('Have issues with previous orders?' ,style: TextStyle(fontSize : 16),),
            trailing: IconButton(
              icon: Icon(_expanded2 ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded2 = !_expanded2 ;
                });
              },
              ),
            ),
        
              AnimatedContainer(
                duration: Duration(milliseconds: 0),
                padding: EdgeInsets.symmetric(
                   horizontal: 15,
                   vertical: 4,
                ),
                height: _expanded2 ? 120 : 0,
                child: Container(
                  child : Column(
                    children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width - 40,
                            child: Text( 'Sorry for the inconvenience. Help us to improve this on the next time. Please mail us your name , date and shop name of order on shopexqueries@gmail.com so that we work on the query', 
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 14,color: Colors.black ),
                            
                            ),
                          ),
                     
                      
                    ],
                  )
                )
              )
            ]
        )
      ) )
       ),
        
          Container(
            child : AnimatedContainer(
        duration: Duration(milliseconds: 0),
        height: _expanded3 ? 170 : 80 ,
          child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget> [
            ListTile(title: Text('I am unable to log in on ShopeX' ,style: TextStyle(fontSize : 16)),
            trailing: IconButton(
              icon: Icon(_expanded3 ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded3 = !_expanded3 ;
                });
              },
              ),
            ),
        
              AnimatedContainer(
                duration: Duration(milliseconds: 0),
                padding: EdgeInsets.symmetric(
                   horizontal: 15,
                   vertical: 4,
                ),
                height: _expanded3 ? 90 : 0,
                child: Container(
                  child : Column(
                    children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width - 40,
                            child: Text( 'Please mail us your name, email you used on ShopeX and Issue on shopexqueries@gmail.com. We are always happy to help our customer', 
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 14,color: Colors.black ),
                            
                            ),
                          ),
                     
                      
                    ],
                  )
                )
              )
            ]
        )
      ) )
       ),
       Container(
            child : AnimatedContainer(
        duration: Duration(milliseconds: 0),
        height: _expanded4 ? 170 : 80 ,
          child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget> [
            ListTile(title: Text('Found a bug or problem in ShopeX App' ,style: TextStyle(fontSize : 16)),
            trailing: IconButton(
              icon: Icon(_expanded4 ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded4 = !_expanded4 ;
                });
              },
              ),
            ),
        
              AnimatedContainer(
                duration: Duration(milliseconds: 0),
                padding: EdgeInsets.symmetric(
                   horizontal: 15,
                   vertical: 4,
                ),
                height: _expanded4 ? 90 : 0,
                child: Container(
                  child : Column(
                    children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width - 40,
                            child: Text( 'Please mail Issue or screenshoot of bug on shopexqueries@gmail.com. We are always hearing your Mails.', 
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 14,color: Colors.black ),
                            
                            ),
                          ),
                     
                      
                    ],
                  )
                )
              )
            ]
        )
      ) )
       ),
       Container(
            child : AnimatedContainer(
        duration: Duration(milliseconds: 0),
        height: _expanded5 ? 200 : 80 ,
          child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget> [
            ListTile(title: Text('Can I cancel my order?' ,style: TextStyle(fontSize : 16)),
            trailing: IconButton(
              icon: Icon(_expanded5 ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded5 = !_expanded5 ;
                });
              },
              ),
            ),
        
              AnimatedContainer(
                duration: Duration(milliseconds: 0),
                padding: EdgeInsets.symmetric(
                   horizontal: 15,
                   vertical: 4,
                ),
                height: _expanded5 ? 120 : 0,
                child: Container(
                  child : Column(
                    children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width - 40,
                            child: Text( 'Actually at that present time we are not delivering any item seller has their own delivery man so it depends on the seller to cancel any order to find contact no of seller double tap on that shop name', 
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 14,color: Colors.black ),
                            
                            ),
                          ),
                     
                      
                    ],
                  )
                )
              )
            ]
        )
      ) )
       ),
       Container(
            child : AnimatedContainer(
        duration: Duration(milliseconds: 0),
        height: _expanded6 ? 200 : 80 ,
          child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget> [
            ListTile(title: Text('Wiil ShopeX be accountable for quality/quantity?' ,style: TextStyle(fontSize : 16)),
            trailing: IconButton(
              icon: Icon(_expanded6 ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded6 = !_expanded6 ;
                });
              },
              ),
            ),
        
              AnimatedContainer(
                duration: Duration(milliseconds: 0),
                padding: EdgeInsets.symmetric(
                   horizontal: 15,
                   vertical: 4,
                ),
                height: _expanded6 ? 120 : 0,
                child: Container(
                  child : Column(
                    children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width - 40,
                            child: Text( 'Quantity and quality of the item is a shop responsibility. However in case of issues with the quality or quantity. Kindly Mail us on shopexqueries@gmail.com and we will pass this to the shop', 
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 14,color: Colors.black ),
                            
                            ),
                          ),
                     
                      
                    ],
                  )
                )
              )
            ]
        )
      ) )
       ),
       Container(
            child : AnimatedContainer(
        duration: Duration(milliseconds: 0),
        height: _expanded7 ? 170 : 80 ,
          child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget> [
            ListTile(title: Text('Want to contact Seller' ,style: TextStyle(fontSize : 16)),
            trailing: IconButton(
              icon: Icon(_expanded7 ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded7 = !_expanded7 ;
                });
              },
              ),
            ),
        
              AnimatedContainer(
                duration: Duration(milliseconds: 0),
                padding: EdgeInsets.symmetric(
                   horizontal: 15,
                   vertical: 4,
                ),
                height: _expanded7 ? 90 : 0,
                child: Container(
                  child : Column(
                    children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width - 40,
                            child: Text( 'Go to that Shop and double tap on SHOP NAME and seller contact No will be shown in bottom of Screen', 
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 14,color: Colors.black ),
                            
                            ),
                          ),
                     
                      
                    ],
                  )
                )
              )
            ]
        )
      ) )
       ),
       ] ) ) 
      );
            
  }
}