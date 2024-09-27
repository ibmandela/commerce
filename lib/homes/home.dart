// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:gestion_commerce_reparation/adders/quick_sell.dart';
import 'package:gestion_commerce_reparation/adders/repair_adder.dart';
import 'package:gestion_commerce_reparation/common/constant.dart';
import 'package:gestion_commerce_reparation/common/functions.dart';
import 'package:gestion_commerce_reparation/common/message.dart';
import 'package:gestion_commerce_reparation/services/bluetooth_printer.dart';
import 'package:gestion_commerce_reparation/services/firebase/storage_firebase.dart';
import 'package:gestion_commerce_reparation/services/hive_database/boxes.dart';
import 'package:gestion_commerce_reparation/viewer.dart/object/missing_viewer.dart';
import 'package:gestion_commerce_reparation/viewer.dart/profils/costumer_viewer.dart';
import 'package:gestion_commerce_reparation/viewer.dart/profils/profile_company.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatelessWidget {
  final String? userUid;
  const HomePage({required this.userUid, super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: CurrentUserBox.currentUserBox!.listenable(),
        builder: (context, box, child) {
          final data = box.values.isEmpty ? null : box.values.first;
          return Scaffold(
              appBar: AppBar(
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(30))),
                title: data == null
                    ? loader
                    : Text('Bienvenue chez \n ${data['name']}'),
                centerTitle: true,
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Profil()));
                      },
                      child: data == null
                          ? loader
                          : CircleAvatar(
                              foregroundColor: Colors.black,
                              radius: 35.0,
                              child: data["url"] == ""
                                  ? Text(
                                      data['name'][0].toUpperCase(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30.0),
                                    )
                                  : Center(
                                      child: kIsWeb
                                          ? Image.network(data["url"])
                                          : data["path"] == ""
                                              ? Text(
                                                  data['name'][0].toUpperCase(),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 30.0))
                                              : Image.file(File(data["path"])),
                                    ),
                            ),
                    ),
                  ),
                ],
              ),
              body: data == null
                  ? loader
                  : Home(
                      user: box.values.first,
                      userUid: userUid,
                    ));
        });
  }
}

class Home extends StatefulWidget {
  final String? userUid;
  final dynamic user;
  const Home({required this.userUid, required this.user, super.key});

  @override
  State createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    if (
        // StockBox.stockBox!.isEmpty &&
        //   BrandBox.brandBox!.isEmpty &&
        //   CategoriesBox.categoriesBox!.isEmpty &&
        //   PartBox.partBox!.isEmpty &&
        widget.user["defaultData"] == true) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _showDefaultDataDialog(widget.user));
    }
    if (!kIsWeb && widget.user["url"] != "" && widget.user["path"] == "") {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _showDefaultDataDialog(widget.user));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: TextButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const QuickSellPage()));
              },
              icon: Icon(
                Icons.computer_rounded,
                size: MediaQuery.of(context).size.width / 10,
              ),
              label: const Text('Vente'),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RepairAdderPage()));
                  },
                  icon: Icon(
                    Icons.home_repair_service,
                    size: MediaQuery.of(context).size.width / 10,
                  ),
                  label: const Text('Réparation'),
                ),
                TextButton.icon(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CostumerViewerPage())),
                  icon: Icon(
                    Icons.person_pin,
                    size: MediaQuery.of(context).size.width / 10,
                  ),
                  label: const Text('Clients'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const MissingView(isSmall: false))),
                    icon: Icon(
                      Icons.call_missed_outgoing_rounded,
                      size: MediaQuery.of(context).size.width / 10,
                    ),
                    label: const Text('Articles manquant'),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      if (Platform.isAndroid || Platform.isIOS) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const BluetoothPrinter()));
                      } else {
                        showCostumDialog(context, "Impossible",
                            "Cette fonctionnalité n'est pas disponible sur cette plateforme");
                      }
                    },
                    icon: Icon(
                      Icons.print_rounded,
                      size: MediaQuery.of(context).size.width / 10,
                    ),
                    label: const Text('Imprimante'),
                  ),
                ]),
          ),
        ],
      ),
    );
  }

  _showImageDialog(doc) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Attention!!!"),
              content: const Text(
                  "Vous avez un logo dans votre compte, souhaitez vous le téléchager ?"),
              actions: [
                TextButton(
                    onPressed: () {
                      _fetchImage(doc);
                    },
                    child: const Text("Oui")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Plutard")),
                TextButton(
                    onPressed: () async {
                      await Hive.box("currentUser").put(doc["uid"], {
                        "adress": doc["adress"],
                        "code": doc["code"],
                        "fax": doc["fax"],
                        "name": doc["name"],
                        "phone": doc["phone"],
                        "siret": doc["siret"],
                        "tva": doc["tva"],
                        "uid": doc["uid"],
                        "path": "",
                        "url": "",
                        "invoiceType": doc["invoiceType"],
                        "defaultData": doc["defaultData"]
                      }).then((value) => Navigator.pop(context));
                    },
                    child: const Text("Ne plus me demander")),
              ],
            ));
  }

  _showDefaultDataDialog(doc) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Attention!!!"),
              content:
                  const Text("Voulez vous charger les données par défaut ?"),
              actions: [
                TextButton(
                    onPressed: () async {
                      await loadDefaultData(context);
                      Navigator.pop(context);
                    },
                    child: const Text("Oui")),
                TextButton(
                    onPressed: () async {
                      await Hive.box("currentUser").put(doc["uid"], {
                        "adress": doc["adress"],
                        "code": doc["code"],
                        "fax": doc["fax"],
                        "name": doc["name"],
                        "phone": doc["phone"],
                        "siret": doc["siret"],
                        "tva": doc["tva"],
                        "uid": doc["uid"],
                        "path": "",
                        "url": "",
                        "invoiceType": doc["invoiceType"],
                        "defaultData": false
                      }).then((value) => Navigator.pop(context));
                    },
                    child: const Text("Non")),
              ],
            ));
  }

  _fetchImage(doc) async {
    String path =
        await StorageFirebase().downloadFile(widget.userUid!, context);
    await Hive.box("currentUser").put(doc["uid"], {
      "adress": doc["adress"],
      "code": doc["code"],
      "fax": doc["fax"],
      "name": doc["name"],
      "phone": doc["phone"],
      "siret": doc["siret"],
      "tva": doc["tva"],
      "uid": doc["uid"],
      "path": path,
      "url": doc["url"],
      "invoiceType": doc["invoiceType"],
      "warning": doc["warning"]
    }).then((value) => Navigator.pop(context));
  }
}
