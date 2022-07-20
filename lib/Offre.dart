import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class Offre extends StatelessWidget{
  final String titles;
  final String logo;
  final String contrat;
  final String description;

  const Offre({
    Key? key,
    required this.titles,
    required this.logo,
    required this.contrat,
    required this.description
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles,
        style: GoogleFonts.roboto(),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(logo,
              style: TextStyle(
                fontSize: 40,
                color: Colors.green[200],
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,

            ),
            Text(contrat,
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
            Text(description,
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.grey[900],
                  fontWeight: FontWeight.normal
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
