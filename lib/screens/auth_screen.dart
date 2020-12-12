// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../widgets/bezierContainer.dart';
// import '../providers/auth.dart';
// import '../models/http_exception.dart';

// enum AuthMode { Signup, Login }

// class AuthScreen extends StatelessWidget {
//   static const routeName = '/auth';

//   @override
//   Widget build(BuildContext context) {
//     final deviceSize = MediaQuery.of(context).size;
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Color.fromRGBO(0, 255, 138, 1).withOpacity(0.7),
//                   Color.fromRGBO(121, 226, 196, 1).withOpacity(0.7),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 stops: [0, 1],
//               ),
//             ),
//            ),
//           // Positioned(
//           //           top: -MediaQuery.of(context).size.height * 0.15,
//           //           right: -MediaQuery.of(context).size.width * .4,
//           //           child:Container(child: Text('Forgot Password' ,style: TextStyle(color: Colors.black ,fontSize: 20),) , ) ,  ),
//           Positioned(
//                     top: -MediaQuery.of(context).size.height * .15,
//                     right: -MediaQuery.of(context).size.width * .4,
//                     child: BezierContainer()),
//           SingleChildScrollView(
//             child: Container(
//               height: deviceSize.height,
//               width: deviceSize.width,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   RichText(
//                    textAlign: TextAlign.center,
//                      text: TextSpan(
//                      text: 'S',
//                      style: GoogleFonts.portLligatSans(
//                      textStyle: Theme.of(context).textTheme.display1,
//                      fontSize: 100,
//                      fontWeight: FontWeight.w700,
//                      color: Colors.lightGreen,
//                      ),
//                      children: [
//                       TextSpan(
//                        text: 'hope',
//                       style: TextStyle(color: Colors.black, fontSize: 80),
//                         ),
//                        TextSpan(
//                       text: 'X',
//                      style: TextStyle(color: Colors.lightGreen , fontSize: 80),
//                             ),
//                          ]),
//                        ),
//                   Flexible(
//                     flex: deviceSize.width > 600 ? 2 : 1,
//                     child: AuthCard(),
//                   ),
//                 ],
//               ),
//             ),
//           ),
    
//         ],
//       ),
//     );
//   }
// }

// class AuthCard extends StatefulWidget {
//   const AuthCard({
//     Key key,
//   }) : super(key: key);

//   @override
//   _AuthCardState createState() => _AuthCardState();
// }

// class _AuthCardState extends State<AuthCard> {
//   final GlobalKey<FormState> _formKey = GlobalKey();
//   AuthMode _authMode = AuthMode.Login;
//   Map<String, String> _authData = {
//     'email': '',
//     'password': '',
//   };
//   var _isLoading = false;
//   final _passwordController = TextEditingController();
//   AnimationController _controller ;
//   Animation<Size> _heightAnimation ;

//   @override
//   void initState() {
//     super.initState();
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//             title: Text('An Error Occurred!'),
//             content: Text(message),
//             actions: <Widget>[
//               FlatButton(
//                 child: Text('Okay'),
//                 onPressed: () {
//                   Navigator.of(ctx).pop();
//                 },
//               )
//             ],
//           ),
//     );
//   }

//   Future<void> _submit() async {
//     if (!_formKey.currentState.validate()) {
//       return;
//     }
//     _formKey.currentState.save();
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       if (_authMode == AuthMode.Login) {
//         await Provider.of<Auth>(context, listen: false).login(
//           _authData['email'],
//           _authData['password'],
//         );
//       } else {
//         await Provider.of<Auth>(context, listen: false).signup(
//           _authData['email'],
//           _authData['password'],
//         );
//       }
//     } on HttpException catch (error) {
//       var errorMessage = 'Authentication failed';
//       if (error.toString().contains('EMAIL_EXISTS')) {
//         errorMessage = 'This email address is already in use.';
//       } else if (error.toString().contains('INVALID_EMAIL')) {
//         errorMessage = 'This is not a valid email address';
//       } else if (error.toString().contains('WEAK_PASSWORD')) {
//         errorMessage = 'This password is too weak.';
//       } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
//         errorMessage = 'Could not find a user with that email.';
//       } else if (error.toString().contains('INVALID_PASSWORD')) {
//         errorMessage = 'Invalid password.';
//       }
//       _showErrorDialog(errorMessage);
//     } catch (error) {
//       const errorMessage =
//           'Could not authenticate you. Please try again later.';
//       _showErrorDialog(errorMessage);
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   void _switchAuthMode() {
//     if (_authMode == AuthMode.Login) {
//       setState(() {
//         _authMode = AuthMode.Signup;
//       });
//     } else {
//       setState(() {
//         _authMode = AuthMode.Login;
//       });
//     }
//   }
//  bool d = true ;
//   void toggler(){
//     setState(() {
//       d = !d ;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final deviceSize = MediaQuery.of(context).size;
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       elevation: 8.0,
//       child: Container(
//         height: _authMode == AuthMode.Signup ? 350 : 290,
//         constraints:
//             BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 350 : 290),
//         width: deviceSize.width * 0.75,
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               children: <Widget>[
//                 TextFormField(
//                   decoration: InputDecoration(labelText: 'E-Mail'),
//                   keyboardType: TextInputType.emailAddress,
//                   validator: (value) {
//                     if (value.isEmpty || !value.contains('@')) {
//                       return 'Invalid email!';
//                     }
//                   },
//                   onSaved: (value) {
//                     _authData['email'] = value;
//                   },
//                 ),
//                 TextFormField(
//                   decoration: InputDecoration(labelText: 'Password for App', suffixIcon: IconButton(icon: Icon(d==true ? Icons.visibility :Icons.visibility_off), onPressed: (){toggler();})),
//                   obscureText: d,
//                   controller: _passwordController,
//                   validator: (value) {
//                     if (value.isEmpty || value.length < 5) {
//                       return 'Password is too short!';
//                     }
//                   },
//                   onSaved: (value) {
//                     _authData['password'] = value;
//                   },
//                 ),
//                 if (_authMode == AuthMode.Signup)
//                   TextFormField(
//                     enabled: _authMode == AuthMode.Signup,
//                     decoration: InputDecoration(labelText: 'Confirm Password'),
//                     obscureText: true,
//                     validator: _authMode == AuthMode.Signup
//                         ? (value) {
//                             if (value != _passwordController.text) {
//                               return 'Passwords do not match!';
//                             }
//                           }
//                         : null,
//                   ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 if (_isLoading)
//                   CircularProgressIndicator()
//                 else
//                   RaisedButton(
//                     child:
//                         Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
//                     onPressed: _submit,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
//                     color: Theme.of(context).primaryColor,
//                     textColor: Theme.of(context).primaryTextTheme.button.color,
//                   ),
//                 FlatButton(
//                   child: Text(
//                       '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
//                   onPressed: _switchAuthMode,
//                   padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
//                   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                   textColor: Theme.of(context).primaryColor,
//                 ),
//                 FlatButton(
//                     padding: EdgeInsets.only(left: 150,top: 0),
//                     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                      textColor: Theme.of(context).primaryColor,
//                   onPressed: (){
//                     showDialog(
//                     context: context,
//                    builder: (ctx) => AlertDialog(
//                    title: Text('Forgot Password?'),
//                    content: Text('Please Mail your registered E-Mail Id on shopexqueries@gmail.com and you receive reset link within 24hrs'),
//                    actions: <Widget>[
//                    FlatButton(
//                 child: Text('Okay'),
//                 onPressed: () {
//                   Navigator.of(ctx).pop();
//                   },
//                   )
//                   ],
//                   ),
//                   );
//                   }, 
//                   child: Text('Forgot Password?' ,style: TextStyle(fontSize: 14),) , ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }




