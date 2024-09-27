import 'package:flutter/material.dart';
import 'package:gestion_commerce_reparation/common/constant.dart';
import 'package:gestion_commerce_reparation/common/functions.dart';
import 'package:gestion_commerce_reparation/common/widget/actions.dart';
import 'dart:html' as html;

import 'package:url_launcher/url_launcher.dart';

class Gestion extends StatefulWidget {
  const Gestion({super.key});

  @override
  State<Gestion> createState() => _GestionState();
}

class _GestionState extends State<Gestion> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double fontSize = MediaQuery.of(context).size.width < 550
        ? MediaQuery.of(context).size.width / 50
        : MediaQuery.of(context).size.width / 80;
    double fontSize1 = MediaQuery.of(context).size.width < 550
        ? MediaQuery.of(context).size.width / 40
        : MediaQuery.of(context).size.width / 60;
    double fontSize2 = MediaQuery.of(context).size.width < 550
        ? MediaQuery.of(context).size.width / 20
        : MediaQuery.of(context).size.width / 50;
    return Scaffold(
      appBar: AppBar(
        actions: actions(context),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(
              MediaQuery.of(context).size.width > 550 ? 30 : 8.0),
          child: Column(
            children: [
              Text("Gestion de Commerce de réparation",
                  style: titleStyle.copyWith(fontSize: fontSize2)),
              const SizedBox(
                height: 10,
              ),
              Card(
                  elevation: 10,
                  child: buildLayout([
                    MyRowBuilder(
                        flex: 1, child: Image.asset("assets/gestion.png")),
                    MyRowBuilder(
                        flex: 1,
                        child: Text(
                          '''Cette application est conçue pour aider les gérant d’un commerce, elle est disponible sur Android, iOS, Windows et web. Elle est utilisable aussi bien sur téléphone portable que sur tablette ou ordinateur. Elle permet de gérer l’entreprise sur plusieurs plateformes en même temps. Elle permet entre autre 
       - de gérer les réparations, ventes et leur suivie.
       - de fournir des justificatifs aux clients (facture, ticket, preuve de dépôt) au format papier, ticket ou dématérialisé.
       - de gérer les clients, voir leurs activités chez vous, voir leur soldes (s’ils ont des crédits).
       - de gérer le stock de marchandises et pièces, lister les articles en rupture de stock.
       - de voir vos statistiques et les analyser.''',
                          style: textStyle.copyWith(fontSize: fontSize),
                        )),
                  ], width)),
              SizedBox(
                height: fontSize2,
              ),
              Text(
                "Gérer les réparations, ventes et leur suivie.",
                style: (titleStyle.copyWith(fontSize: fontSize1)),
              ),
              Card(
                  elevation: 10,
                  child: buildLayout([
                    MediaQuery.of(context).size.width > 850
                        ? MyRowBuilder(
                            flex: 1, child: Image.asset("assets/vente.png"))
                        : MyRowBuilder(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Image.asset("assets/vente.png")),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: Image.asset("assets/suivie.png"))
                              ],
                            )),
                    MyRowBuilder(
                        flex: 1,
                        child: Text(
                            '''Elle permet d’enregistrer une vente ou une réparation d’en suivre l’état afin d’avoir une vision plus claire des activités de l’entreprise, aussi de prévenir le client sur l’état de sa réparation.''',
                            style: textStyle.copyWith(fontSize: fontSize))),
                    if (MediaQuery.of(context).size.width > 850)
                      MyRowBuilder(
                          flex: 1, child: Image.asset("assets/suivie.png")),
                  ], width)),
              SizedBox(
                height: fontSize2,
              ),
              Text(
                "Fournir des justificatifs aux clients (facture, ticket, preuve de dépôt) au format papier, ticket ou dématérialisé.",
                style: (titleStyle.copyWith(fontSize: fontSize1)),
              ),
              Card(
                  elevation: 10,
                  child: buildLayout([
                    MediaQuery.of(context).size.width > 850
                        ? MyRowBuilder(
                            flex: 2,
                            child: Image.asset(
                              "assets/facture.png",
                              fit: BoxFit.fill,
                            ))
                        : MyRowBuilder(
                            flex: 1,
                            child: SizedBox(
                                width: width < 850 ? width / 2 : null,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        flex: 3,
                                        child:
                                            Image.asset("assets/facture.png")),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Image.asset("assets/ticket.png"))
                                  ],
                                ))),
                    MyRowBuilder(
                        flex: 6,
                        child: Text(
                            '''Elle permet de fournir des factures ou des devis aux clients sous différents format (ticket, A4 ou dématérialisé). Elle permet de fournir aussi un justificatif dépôt de son appareil relatant l’état de l’appareil et l’intervention qu’il subira.''',
                            style: textStyle.copyWith(fontSize: fontSize))),
                    if (MediaQuery.of(context).size.width > 850)
                      MyRowBuilder(
                          flex: 1, child: Image.asset("assets/ticket.png")),
                  ], width)),
              SizedBox(
                height: fontSize2,
              ),
              Text(
                "Gérer les réparations, ventes et leur suivie.",
                style: (titleStyle.copyWith(fontSize: fontSize1)),
              ),
              Card(
                  elevation: 10,
                  child: buildLayout([
                    MyRowBuilder(
                        flex: 1,
                        child: width < 850
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      width: width < 850 ? width / 2 : null,
                                      child: Image.asset("assets/client.png"))
                                ],
                              )
                            : Image.asset("assets/client.png")),
                    MyRowBuilder(
                        flex: 2,
                        child: Text(
                            '''Gérer les clients, voir leurs activités chez vous, voir leur soldes (s’ils ont des crédits).''',
                            style: textStyle.copyWith(fontSize: fontSize)))
                  ], width)),
              SizedBox(
                height: fontSize2,
              ),
              Text(
                "Gérer le stock de marchandises et pièces, lister les articles en rupture de stock.",
                style: (titleStyle.copyWith(fontSize: fontSize1)),
              ),
              Card(
                  elevation: 10,
                  child: buildLayout([
                    MyRowBuilder(
                        flex: 1,
                        child: width < 850
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      width: width < 850 ? width / 2 : null,
                                      child: Image.asset("assets/stock.png")),
                                ],
                              )
                            : Image.asset("assets/stock.png")),
                    MyRowBuilder(
                        flex: 2,
                        child: Text(
                            '''Elle permet de lister le stock de marchandise et de pièces restant, manquant permettant d’avoir une idée claire sur le stock.
                      ''',
                            style: textStyle.copyWith(fontSize: fontSize)))
                  ], width)),
              SizedBox(
                height: fontSize2,
              ),
              Text(
                "Voir vos statistiques et les analyser.",
                style: (titleStyle.copyWith(fontSize: fontSize1)),
              ),
              Card(
                elevation: 10,
                child: buildLayout([
                  MyRowBuilder(
                    flex: 1,
                    child: width < 850
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width: width < 850 ? width / 2 : null,
                                  child: Image.asset("assets/statistique.png")),
                            ],
                          )
                        : Image.asset("assets/statistique.png"),
                  ),
                  MyRowBuilder(
                      flex: 2,
                      child: Text(
                          '''Elle permet d’avoir accès à partir de n’ importe où au différentes statistique de l’entreprise.''',
                          style: textStyle.copyWith(fontSize: fontSize)))
                ], width),
              ),
              SizedBox(
                height: fontSize2,
              ),
              Text("Gestion de mon Commerce de réparation est disponible sur :",
                  style: titleStyle.copyWith(fontSize: fontSize)),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                GestureDetector(
                  onTap: () {
                    html.AnchorElement anchorElement = html.AnchorElement(
                        href: "assets/apps/commerce de réparation.apk");
                    anchorElement.download = "commerce de réparation.apk";
                    anchorElement.click();
                  },
                  child: Column(
                    children: [
                      Icon(
                        size: MediaQuery.of(context).size.width / 10,
                        Icons.android,
                        color: Colors.green,
                      ),
                      Text(
                        "Android",
                        style: titleStyle.copyWith(fontSize: fontSize),
                      ),
                      Text(
                        "(Téléchager)",
                        style: textStyle.copyWith(
                            fontSize: fontSize, color: Colors.blue),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    launchUrl(Uri(
                      scheme: 'https',
                      host: 'play.google.com',
                      path: 'store/apps/details',
                      query:
                          'id=fr.ibdeveloppe.gestion_commerce_reparation&pcampaignid=web_share',
                    ));
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 10,
                        child: Image.asset("assets/store.png"),
                      ),
                      Text(
                        "Voir sur",
                        style: textStyle.copyWith(fontSize: fontSize),
                      ),
                      Text(
                        "le play store",
                        style: textStyle.copyWith(fontSize: fontSize),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: [
                      Icon(
                        size: MediaQuery.of(context).size.width / 10,
                        Icons.apple_sharp,
                        color: Colors.black,
                      ),
                      Text(
                        "IOS",
                        style: titleStyle.copyWith(fontSize: fontSize),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    html.AnchorElement anchorElement = html.AnchorElement(
                        href: "assets/apps/commerce de réparation.exe");
                    anchorElement.download = "commerce de réparation";
                    anchorElement.click();
                  },
                  child: Column(
                    children: [
                      Icon(
                        size: MediaQuery.of(context).size.width / 10,
                        Icons.window_sharp,
                        color: Colors.blue,
                      ),
                      Text(
                        "Windows",
                        style: titleStyle.copyWith(fontSize: fontSize),
                      ),
                      Text(
                        "(Téléchager)",
                        style: textStyle.copyWith(
                            fontSize: fontSize, color: Colors.blue),
                      )
                    ],
                  ),
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
