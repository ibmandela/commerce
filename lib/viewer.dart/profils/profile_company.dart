import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:gestion_commerce_reparation/common/constant.dart';
import 'package:gestion_commerce_reparation/homes/authentication.dart';
import 'package:gestion_commerce_reparation/services/firebase/sign_in_with_email.dart';
import 'package:gestion_commerce_reparation/viewer.dart/activity.dart';
import 'package:gestion_commerce_reparation/viewer.dart/categorie_viewer.dart';
import 'package:gestion_commerce_reparation/viewer.dart/profils/company_profil_edit.dart';
import 'package:gestion_commerce_reparation/viewer.dart/statistic_viewer.dart';
import 'package:gestion_commerce_reparation/viewer.dart/object/stock_viewer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfilPage extends StatelessWidget {
  final Color? color;
  const ProfilPage({this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return const Profil();
  }
}

class Profil extends StatefulWidget {
  const Profil({
    super.key,
  });

  @override
  State createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  final spaceDown = const SizedBox(
    height: 5,
  );
  final space = const SizedBox(
    width: 30,
  );
  File? file;
  var format = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: const Color.fromRGBO(33, 150, 243, 1),
        body: SingleChildScrollView(
            child: Center(
      child: Card(
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: SizedBox(
            width: MediaQuery.of(context).size.width > 600 ? 600 : null,
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(children: [
                _buildHead(),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      _builIcon(
                          const Icon(
                            Icons.person_pin,
                            color: Colors.blue,
                          ),
                          companyName),
                      const SizedBox(
                        height: 5,
                      ),
                      _builIcon(
                          const Icon(
                            Icons.phone,
                            color: Colors.blue,
                          ),
                          companyPhone),
                      const SizedBox(
                        height: 5,
                      ),
                      _builIcon(
                          const Icon(
                            Icons.phone,
                            color: Colors.blue,
                          ),
                          fax),
                      const SizedBox(
                        height: 5,
                      ),
                      _builIcon(
                          const Icon(
                            Icons.location_pin,
                            color: Colors.blue,
                          ),
                          companyAdress),
                      const SizedBox(
                        height: 5,
                      ),
                      _builIcon(
                          const Icon(
                            Icons.location_pin,
                            color: Colors.blue,
                          ),
                          postalCode),
                      spaceDown,
                      _builIcon(
                          const Icon(
                            Icons.location_pin,
                            color: Colors.blue,
                          ),
                          siret),
                      const SizedBox(
                        height: 5,
                      ),
                      _builIcon(
                          const Icon(
                            Icons.location_pin,
                            color: Colors.blue,
                          ),
                          tva),
                      spaceDown,
                      spaceDown,
                      _buildButton(),
                      spaceDown,
                      _buildStockButton(),
                      spaceDown,
                      _buildStatButton(),
                      spaceDown,
                      _buildCategorieButton(),
                      spaceDown,
                      _buildRepairButton(),
                    ],
                  ),
                ),
              ]),
            ),
          )),
    )));
  }

  _buildHead() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              size: 40,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Stack(children: [
            SizedBox(
                width: MediaQuery.of(context).size.width / 6,
                height: MediaQuery.of(context).size.width / 6,
                child: CircleAvatar(
                    foregroundColor: Colors.black,
                    radius: 35.0,
                    child: url == ""
                        ? Text(
                            companyName[0],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 50.0),
                          )
                        : kIsWeb
                            ? Image.network(url)
                            : Image.file(File(path)))),
          ]),
          IconButton(
              icon: const Icon(
                Icons.edit,
                size: 40,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilEdit()));
              }),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
            backgroundColor: Colors.white,
            elevation: 30),
        onPressed: () {
          AuthenticationService().signOut();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const AuthenticationPage()));
        },
        child: const Text(
          "Se déconnecter",
          style: formTextStyle,
        ));
  }

  Widget _buildStockButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
            backgroundColor: Colors.white,
            elevation: 30),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const StockViewPage()));
        },
        child: const Text(
          "Voir le stock",
          style: formTextStyle,
        ));
  }

  Widget _buildStatButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
            backgroundColor: Colors.white,
            elevation: 30),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const StatViewerPage(
                        isCostumerView: false,
                      )));
        },
        child: const Text(
          "Voir les statistique",
          style: formTextStyle,
        ));
  }

  Widget _buildCategorieButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
            backgroundColor: Colors.white,
            elevation: 30),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CategorieViewerPage()));
        },
        child: const Text(
          "Voir les articles",
          style: formTextStyle,
        ));
  }

  Widget _buildRepairButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
            backgroundColor: Colors.white,
            elevation: 30),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ActivityPage(
                        isCostumerView: false,
                      )));
        },
        child: const Text(
          "Voir les répartions",
          style: formTextStyle,
        ));
  }

  _builIcon(Icon icon, String label) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.white),
          borderRadius: const BorderRadius.all(Radius.circular(30))),
      child: Row(
        children: [
          icon,
          space,
          Text(
            label,
            style: formTextStyle,
          )
        ],
      ),
    );
  }

  buildAvatar(String name) {
    var initialName = name[0].toUpperCase();

    return Center(
      child: CircleAvatar(
        foregroundColor: Colors.black,
        radius: 35.0,
        child: Text(
          initialName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
        ),
      ),
    );
  }
}
