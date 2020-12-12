import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth.dart';


class SignupPage extends StatefulWidget {

  static const routeName = '/signup-page';

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _isloading = false ;
  Color color = Colors.grey;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _passwordControllercheck;
  bool _issecure = true ;
  @override
  void initState() { 
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
    _passwordControllercheck = TextEditingController(text: "");
  }

  void toggler(){
    setState(() {
      _issecure = !_issecure ;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
              Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              color: Color.fromRGBO(0, 255, 128, 1),
              child: Stack(
                children: <Widget>[
                  Positioned(
                      //padding: EdgeInsets.fromLTRB(220.0, 140.0, 0.0, 0.0),
                      right: 0,
                      top: 140,
                        child: Container(
                        height: 100,
                        width:  160,
                        decoration: BoxDecoration(image : DecorationImage(image: AssetImage('assets/images/product.png'), fit: BoxFit.fill)),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10.0, 160.0, 0.0, 0.0),
                      child: Text('ShopeX',
                          style: GoogleFonts.portLligatSans(
                           textStyle: Theme.of(context).textTheme.display1,
                            fontSize: 50,
                           fontWeight: FontWeight.w700,
                            color: Colors.black,
                     ),
                              ),
                    ),
                  Container(
                    padding: EdgeInsets.fromLTRB(100.0, 205.0, 0.0, 0.0),
                    child: Text(
                      'Signup',
                      style:GoogleFonts.portLligatSans(
                           textStyle: Theme.of(context).textTheme.display1,
                            fontSize: 30,
                           fontWeight: FontWeight.w700,
                            color: Colors.black,
                     ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          labelText: 'EMAIL',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color.fromRGBO(0, 255, 128, 1)))),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                          labelText: 'NEW PASSWORD ',
                          suffixIcon: IconButton(icon: Icon(_issecure ? Icons.visibility :Icons.visibility_off), onPressed: (){toggler();}),
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color.fromRGBO(0, 255, 128, 1)))),
                      obscureText: _issecure ,
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: _passwordControllercheck,
                      decoration: InputDecoration(
                          labelText: 'CONFIRM PASSWORD ',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: color),
                              focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color.fromRGBO(0, 255, 128, 1)))),
                      obscureText: _issecure ,
                    ),
                    SizedBox(height: 50.0),
                   _isloading==true ? CircularProgressIndicator() : GestureDetector(
                            onTap: () async {
                              if(_passwordController.text == _passwordControllercheck.text && _passwordController.text.length>=6 && _emailController.text.contains('@') && _emailController.text.contains('.com')){
                                    setState(() {
                                   _isloading = true ;
                                });
                                if(_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                                print("Email and password cannot be empty");
                                 return;
                                 }
                                 bool res = await Auth().signupWithEmail(_emailController.text, _passwordController.text, );
                                 if(!res) {
                                    print("SignUp failed");
                                 }
                                 Navigator.of(context).pop();
                                  setState(() {
                                   _isloading = false ;
                                });
                              }
                              else {
                                if(_passwordController.text.length<6) {
                                    showDialog(
                               context: context,
                               builder: (ctx) => AlertDialog(
                               title: Text('Password must be atleast 6 digits long!!'),
                              // content: Text('Please send your Gmail id on testmequeries@gmail.com with subject PASSWORD RESET and you will receive reset link within 24hrs'),
                               actions: <Widget>[
                               FlatButton(
                                  child: Text('CLOSE'),
                               onPressed: () {
                               Navigator.of(ctx).pop();
                                                 },
                                            )
                                        ],
                                    ),
                                 );
                                }
                                 else if (_passwordController.text != _passwordControllercheck.text){
                                  setState(() {
                                    color = Colors.red ;
                                  });
                                  showDialog(
                               context: context,
                               builder: (ctx) => AlertDialog(
                               title: Text('Confirm Password does not match with Password!!'),
                              // content: Text('Please send your Gmail id on testmequeries@gmail.com with subject PASSWORD RESET and you will receive reset link within 24hrs'),
                               actions: <Widget>[
                               FlatButton(
                                  child: Text('CLOSE'),
                               onPressed: () {
                               Navigator.of(ctx).pop();
                                                 },
                                            )
                                        ],
                                    ),
                                 );
                                    } 
                               else {
                                   showDialog(
                               context: context,
                               builder: (ctx) => AlertDialog(
                               title: Text('Invalid email ID!!'),
                              // content: Text('Please send your Gmail id on testmequeries@gmail.com with subject PASSWORD RESET and you will receive reset link within 24hrs'),
                               actions: <Widget>[
                               FlatButton(
                                  child: Text('CLOSE'),
                               onPressed: () {
                               Navigator.of(ctx).pop();
                                                 },
                                            )
                                        ],
                                    ),
                                 );
                               }
                              }
                                 },
                          child: Container(
                          height: 40.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Color.fromRGBO(0, 255, 128, 0.7),
                            color: Color.fromRGBO(0, 255, 128, 1),
                            elevation: 7.0,
                              child: Center(
                                child: Text(
                                  'SIGNUP',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                          )),
                   ),
                    SizedBox(height: 20.0),
                    Container(
                      height: 40.0,
                      color: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 1.0),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20.0)),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: 
                              Center(
                                child: Text('Go Back',
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 255, 128, 1),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat')),
                              ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height : 300
                    )
                  ],
                )),
          ]),
        ));
  }
}
