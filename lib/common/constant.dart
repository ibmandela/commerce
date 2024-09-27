import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

const textInputDecoration = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    contentPadding: EdgeInsets.all(12.0),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 3.0),
      borderRadius: BorderRadius.all(Radius.circular(30)),
    ),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 3.0),
        borderRadius: BorderRadius.all(Radius.circular(10))));

const textInputDecoration2 = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    contentPadding: EdgeInsets.all(12.0),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
    ),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 3.0),
        borderRadius: BorderRadius.all(Radius.circular(10))));

const textInputDecoration3 = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    contentPadding: EdgeInsets.all(12.0),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 3.0),
      borderRadius: BorderRadius.all(Radius.circular(30)),
    ),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 5.0),
        borderRadius: BorderRadius.all(Radius.circular(30))));

const borderRaduis =
    RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)));

const textStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
const formTextStyle =
    TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.blue);

const listTextStyle =
    TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.blue);
const listTrainingStyle =
    TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.blue);
const divider = Divider(
  thickness: 2,
  height: 22,
);
const textInputDecorationwithout = InputDecoration(
    fillColor: Colors.blue,
    filled: true,
    contentPadding: EdgeInsets.all(12.0),
    enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 3.0),
        borderRadius: BorderRadius.all(Radius.circular(10))));

var textBoxDecoration = BoxDecoration(
    border: Border.all(color: Colors.blue, width: 3.0),
    borderRadius: const BorderRadius.all(Radius.circular(30)));
var boxdecoration = BoxDecoration(
    borderRadius: const BorderRadius.all(Radius.circular(15.0)),
    border: Border.all(width: 4, color: Colors.blue));

var gridTextStyle = const TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w500);
var titleStyle = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
var buttonText = const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
var subtitle = const TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
var listItem = const TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
const loader = Center(
  child: CircularProgressIndicator(),
);
const snapshotError = Center(
  child: Text("Une erreur s'est produite"),
);
var buttonStyle = ElevatedButton.styleFrom(
  shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2))),
);
final user = Hive.box("currentUser").values.first;

String companyName = user["name"];
String companyPhone = user["phone"];
String companyAdress = user["adress"];
String postalCode = user["code"];
String fax = user["fax"];
String siret = user["siret"];
String tva = user["tva"];
String invoiceType = user["invoiceType"];
String path = user["path"];
String url = user["url"];
String userUid = user["uid"];
String warning = user["warning"];
String defaultSentence =
    "Ce ticket est votre preuve de dépôt, il doit être bien conservé.Tout appareil déposé pour réparation chez doit être retirer trois (3) mois au plus tard après sa réparation. Passé ce délai notre responsabilité ne sera pas engagée sur la restitution de votre appareil.";
String ibDeveloppe =
    "IbDéveloppe vous avez un soucis j'ai une appli: 06 98 55 75 67";
bool defaultData = user["defaultData"];

class MyRowBuilder {
  Widget child;
  int flex;
  MyRowBuilder({required this.child, required this.flex});
}
