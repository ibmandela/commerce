import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestion_commerce_reparation/common/constant.dart';
import 'package:gestion_commerce_reparation/services/costumer_class.dart';
import 'package:gestion_commerce_reparation/services/firebase/company_database.dart';
import 'package:gestion_commerce_reparation/services/hive_database/boxes.dart';
import 'package:url_launcher/url_launcher.dart';

errorDialog(BuildContext context, label) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Attention!!!"),
            content:
                Text("Une erreur $label s'est produite veuillez réessayer "),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Ok"))
            ],
          ));
}

sendSms(body) {
  final smsLauchUri = Uri(
      scheme: "sms",
      path: "+33698557567",
      queryParameters: <String, String>{"body": body});
  launchUrl(smsLauchUri);
}

sendMail(String body) {
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'ibrahimacicamara@gmail.com',
    query: encodeQueryParameters(<String, String>{
      'subject': body,
    }),
  );

  launchUrl(emailLaunchUri);
}

launchUPageWeb(adress) {
  // String? encodeQueryParameters(Map<String, String> params) {
  //   return params.entries
  //       .map((MapEntry<String, String> e) =>
  //           '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
  //       .join('&');
  // }

  final Uri emailLaunchUri = Uri(
    scheme: 'https',
    path: adress,
  );

  launchUrl(emailLaunchUri);
}

buildLayout(List<MyRowBuilder> children, width) {
  return width > 850
      ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: children
              .map((widget) => Expanded(
                    flex: widget.flex,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: widget.child,
                    ),
                  ))
              .toList(),
        )
      : Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: children
                .map((widget) => Padding(
                      padding: const EdgeInsets.all(8),
                      child: widget.child,
                    ))
                .toList(),
          ),
        );
}

Future<void> loadDefaultData(BuildContext context) async {
  return await FirebaseFirestore.instance
      .collection("Companies")
      .doc("Default")
      .get()
      .then((doc) {
    _addBrand(doc["adress"], context);
    _addCategorie(doc["code"], context);
    _addDescription(doc["phone"], context);
    _addModels(doc["name"], context);
    _addPart(doc["sentence"], doc["name"], context);
  });
}

_addPart(List parts, models, BuildContext context) {
  for (String part in parts) {
    PartsDatabase().addPart(part, context);
    PartBox.partBox!.put(part, {"part": part, "uid": part});
    _addStock(part, models, context);
  }
}

_addModels(List models, BuildContext context) {
  for (String model in models) {
    ModelDatabase().addModel(model, context);
  }
}

_addCategorie(List categories, BuildContext context) {
  for (String categorie in categories) {
    CompanyDatabase().addCategorie(categorie, context);
  }
}

_addDescription(List descriptions, BuildContext context) {
  for (String description in descriptions) {
    CompanyDatabase().addDescription(description, context);
  }
}

_addBrand(List brands, BuildContext context) {
  for (String brand in brands) {
    ModelDatabase().addBrand(brand, context);
  }
}

_addStock(String part, List models, BuildContext context) {
  for (var model in models) {
    StockDatabase().addStock(part, model, "", 0, "0", context);
  }
}
