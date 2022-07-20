import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.roboto().toString(),
              ),
              textAlign: TextAlign.center,

            ),
            Text(contrat,
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.roboto().toString()
              ),
              textAlign: TextAlign.center,
            ),
            Text(description,
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.grey[900],
                  fontWeight: FontWeight.normal,
                  fontFamily: GoogleFonts.roboto().toString(),
                  fontStyle: FontStyle.italic
              ),
              textAlign: TextAlign.center,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(onPressed: null,
                      child:  Icon(Icons.share,
                        size: 50,color: Colors.green,)),
                  ElevatedButton(onPressed: null,
                      child:  Icon(Icons.bookmark_add,
                        size: 50,color: Colors.green,)),
                ]
            ),
          ],
        ),
      ),
    );
  }
}
