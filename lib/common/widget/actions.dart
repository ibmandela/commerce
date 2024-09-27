import 'package:flutter/material.dart';
import 'package:gestion_commerce_reparation/contact.dart';
import 'package:gestion_commerce_reparation/gestion.dart';
import 'package:gestion_commerce_reparation/homes/authentication.dart';

List<Widget> actions(context) {
  double fontSize = MediaQuery.of(context).size.width < 550
      ? MediaQuery.of(context).size.width / 30
      : MediaQuery.of(context).size.width / 70;
  return [
    TextButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Gestion()));
        },
        child: Text(
          "Accueil",
          style: TextStyle(
              fontSize: fontSize,
              color: Colors.black,
              fontWeight: FontWeight.w600),
        )),
    TextButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AuthenticationPage()));
        },
        child: Text(
          "S'identifier",
          style: TextStyle(
              fontSize: fontSize,
              color: Colors.black,
              fontWeight: FontWeight.w600),
        )),
    TextButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ContactMe()));
        },
        child: Text(
          "Nous contacter",
          style: TextStyle(
              fontSize: fontSize,
              color: Colors.black,
              fontWeight: FontWeight.w600),
        ))
  ];
}
