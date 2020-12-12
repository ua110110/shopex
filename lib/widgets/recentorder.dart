import '../providers/recent_orders.dart';
import '../widgets/rwidgetitems.dart';
import 'package:flutter/material.dart';

class Rwidget extends StatefulWidget {

  final List<Rorder> rlist  ; 
  Rwidget (
    this.rlist ,
  ) ;
  @override
  _RwidgetState createState() => _RwidgetState(rlist);
}

class _RwidgetState extends State<Rwidget> {
final List<Rorder> slist  ; 
  _RwidgetState (
    this.slist ,
  ) ;
  @override
  Widget build(BuildContext context) {
    return
   slist.isEmpty ? 
     Center(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
           FlatButton.icon(
                padding: EdgeInsets.all(0),
                onPressed: null, 
                icon: Icon(Icons.mood_bad ,size: 50,), 
                label: Text('')
              ),
          Text('Sorry but Your Shop has No orders Yet')
         ],
       ),
     )
    : 
      Column(
       children: <Widget>[
         SizedBox(height : 15),
         Expanded(
           child: ListView.builder(
                    itemBuilder: (ctx, index){
                      return RwidgetItem(
                        name: slist[index].name, 
                        number: slist[index].number, 
                        locatity: slist[index].locality, 
                        city: slist[index].city, 
                        pick: slist[index].pick, 
                        amount: slist[index].amount, 
                        products: slist[index].products , 
                        dateTime: slist[index].dateTime 
                        ) ;
                   }, 
                     itemCount: slist.length,   
            
    ),
         ),
       ],
     );
  }
 }