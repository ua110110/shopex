import '../providers/recent_orders.dart';
import '../widgets/recentorder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class RecentOrders extends StatefulWidget {

  static const routeName = '/cheak-page';

  @override
  _RecentOrdersState createState() => _RecentOrdersState();
}

class _RecentOrdersState extends State<RecentOrders> {
  var _isinIt = true ;

  var _isLoading = true ;
Future <void> _refreshProductsmain(BuildContext context) async {
  setState(() {
    _isLoading = true ;
  });
   await Provider.of<RecentOrderpro>(context).fetchAndSetOrders() ;
   setState(() {
     _isLoading= false ;
   });
  }
   @override
  void didChangeDependencies() {
   if(_isinIt){
     setState(() {
       _isLoading = true; 
     });
      Provider.of<RecentOrderpro>(context).fetchAndSetOrders().then((_) {
         setState(() {
           _isLoading = false ;
         });
      });
   }
   _isinIt = false ;
    super.didChangeDependencies();
   }
 
  @override
  Widget build(BuildContext context) {
    final rlist = Provider.of<RecentOrderpro>(context).rorderlist ;
    return Scaffold(
      appBar: AppBar(
        title: Text('Recent Orders'),
        backgroundColor: Color.fromRGBO(0, 255, 128, 1) ,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever), 
            onPressed:() async {
               showDialog(context: context , builder: (ctx) => AlertDialog(
                title: Text('Are you sure?') ,
                content: Text(
                'Do you want Delete Information of all Orders?'
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Yes'), 
                    onPressed: ()async{
                      Navigator.of(ctx).pop(true);
                     await Provider.of<RecentOrderpro>(context).deleteallorders();
                    },),
                  FlatButton(
                    child: Text('No'), 
                    onPressed: (){
                      Navigator.of(ctx).pop(false);
                    },)
                ],
                )
                );
            }
            )
        ],
      ),
        body:
        RefreshIndicator(
        onRefresh:() {
          return _refreshProductsmain(context);
        } ,
        child : _isLoading ? Center(
        child : CircularProgressIndicator(),
      ) :
      Rwidget(rlist)
    ),
    );
  }
}