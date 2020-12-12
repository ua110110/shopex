import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopex/screens/Signup.dart';
import '../providers/auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController;
  TextEditingController _passwordController;
  bool _isloading = false ;
  bool _issecure = true ;
  @override
  void initState() { 
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
  }
  void toggler(){
    setState(() {
      
      _issecure = !_issecure ;
    });
  }
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color:Color.fromRGBO(0, 255, 128, 1) ,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                     // padding: EdgeInsets.fromLTRB(220.0, 140.0, 0.0, 0.0),
                        right: 0,
                        top: 140,
                        child: Container(
                        height: 100,
                        width:  160,
                        decoration: BoxDecoration(image : DecorationImage(image: AssetImage('assets/images/product.png'), fit: BoxFit.fill)),
                      ),
                    ),
                    // Container(
                    //   padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                    //   child: Text('ShopeX',
                    //       style: TextStyle(
                    //           fontSize: 80.0, fontWeight: FontWeight.bold)),
                    // ),
                    Container(
                      padding: EdgeInsets.fromLTRB(30.0, 175.0, 0.0, 0.0),
                      child: Text('ShopeX',
                          style: GoogleFonts.portLligatSans(
                           textStyle: Theme.of(context).textTheme.display1,
                            fontSize: 50,
                           fontWeight: FontWeight.w700,
                            color: Colors.black,
                     ),
                              ),
                    ),
                    // Container(
                    //   padding: EdgeInsets.fromLTRB(140.0, 175.0, 0.0, 0.0),
                    //   child: Text('.',
                    //       style: TextStyle(
                    //           fontSize: 80.0,
                    //           fontWeight: FontWeight.bold,
                    //           color: Colors.pink)),
                    // )
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
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
                      SizedBox(height: 20.0),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(icon: Icon(_issecure ? Icons.visibility :Icons.visibility_off), onPressed: (){toggler();}),
                            labelText: 'APP PASSWORD',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(0, 255, 128, 1)))),
                        obscureText: _issecure ,
                      ),
                      SizedBox(height: 5.0),
                      Container(
                        alignment: Alignment(1.0, 0.0),
                        padding: EdgeInsets.only(top: 15.0, left: 20.0),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                                 context: context,
                                 builder: (ctx) => AlertDialog(
                                 title: Text('Forgot Password?',
                                 ),
                                 content: RichText(
                                   text: TextSpan(
                                     text : 'Please send your Gmail id on ',
                                     style: TextStyle(
                                           color : Colors.black ,
                                           fontWeight : FontWeight.normal
                                         ),
                                     children: <TextSpan> [
                                       TextSpan(
                                         text : 'shopexqueries@gmail.com ' ,
                                         style: TextStyle(
                                           color : Color.fromRGBO(0, 255, 128, 1) ,
                                           fontWeight : FontWeight.bold
                                         ),
                                         
                                       ),
                                       
                                       TextSpan(
                                         text: 'with subject as PASSWORD RESET. Then you receive password reset link within 24hrs'
                                       )
                                     ]
                                   ),
                                 ),
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
                          },
                          child: Text(
                            'Forgot Password',
                            style: TextStyle(
                                color: Color.fromRGBO(0, 255, 128, 1),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ),
                      SizedBox(height: 40.0),
                      _isloading==true ? CircularProgressIndicator() : GestureDetector(
                        onTap: () async {
                                setState(() {
                                   _isloading = true ;
                                });
                                if(_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                                print("Email and password cannot be empty");
                                 return;
                                 }
                                 String res = await Auth().signInWithEmail(_emailController.text, _passwordController.text);
                                 if(res != '') {
                                    print("Login failed");
                                 
                                 showDialog(
                                     context: context,
                                      builder: (ctx) => AlertDialog(
                                     title: Text('An Error Occurred!'),
                                     content: Text(res),
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
                                  setState(() {
                                   _isloading = false ;
                                });
                                 },
                          child: Container(
                          height: 40.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Color.fromRGBO(0, 255, 128, 0.7) ,
                            color: Color.fromRGBO(0, 255, 128, 1),
                            elevation: 7.0,
                              child: Center(
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                            
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        height: 40.0,
                        color: Colors.transparent,
                        child:  GestureDetector(
                             onTap: () async {

                                  bool res = await Auth().loginWithGoogle();
                                    if(!res) {
                                      print("error logging in with google");
                                      showDialog(
                                     context: context,
                                      builder: (ctx) => AlertDialog(
                                     title: Text('An Error Occurred!'),
                                     content: Text('something wents wrong while signin with google.'),
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
                                    },
                            child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black,
                                    style: BorderStyle.solid,
                                    width: 1.0),
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                  child:
                                      ImageIcon(AssetImage('assets/images/google.png')),
                                ),
                                SizedBox(width: 10.0),
                                Center(
                                  child: Text('Log in with Google',
                                      style: TextStyle(
                                          color: Color.fromRGBO(0, 255, 128, 1),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat')),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
              SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'New to ShopeX ?',
                    style: TextStyle(fontFamily: 'Montserrat'),
                  ),
                  SizedBox(width: 5.0),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(SignupPage.routeName);
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                          color: Color.fromRGBO(0, 255, 128, 1),
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                  )
                ],
              ),
              SizedBox(
                height : 220 ,
              )
            ],
          ),
        ));
  }
}