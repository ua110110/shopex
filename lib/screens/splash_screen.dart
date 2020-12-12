import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(0, 255, 138, 1).withOpacity(0.7),
                  Color.fromRGBO(121, 226, 196, 1).withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
        child: Center(
          child: Text('Loading ...' ,
        style: GoogleFonts.portLligatSans(
                     textStyle: Theme.of(context).textTheme.display1,
                     fontSize: 20,
                     fontWeight: FontWeight.w700,
                     color: Colors.black,
                     ),
        ),
        ),
      ),
    );
  }
}
