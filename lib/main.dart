import 'package:gestion_commerce_reparation/homes/wrapper.dart';
import 'package:gestion_commerce_reparation/services/hive_database/boxes.dart';
import 'package:gestion_commerce_reparation/services/firebase/sign_in_with_email.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await FirebaseAppCheck.instance.activate(
  //     // webRecaptchaSiteKey: 'recaptcha-v3-site-key',
  //     );
  ActivitiesBox.instance.initBox();
  RepairBox.instance.initBox();
  DebtOrRefundBox.instance.initBox();
  StockBox.instance.initBox();
  ArticleBox.instance.initBox();
  CostumerBox.instance.initBox();
  BrandBox.instance.initBox();
  CategoriesBox.instance.initBox();
  DescriptionBox.instance.initBox();
  ModelBox.instance.initBox();
  PartBox.instance.initBox();
  MissingBox.instance.initBox();
  await CurrentUserBox().initBox();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: AuthenticationService().user,
      initialData: null,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            appBarTheme:
                const AppBarTheme(color: Color.fromARGB(255, 173, 216, 252)),
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          ),
          // home: FutureBuilder<Box>(
          //     future: Hive.openBox("currentUser"),
          //     builder: (context, snapshot) {
          //       if (snapshot.hasError) {
          //         return snapshotError;
          //       } else if (snapshot.connectionState ==
          //           ConnectionState.waiting) {
          //         return loader;
          //       }
          //       var isEstimate = false;
          //       final box = snapshot.requireData.values.firstOrNull;
          //       return PdfCreator(
          //           invoiceType: "first",
          //           path: "",
          //           invoiceNumber: "invoice",
          //           costumerAdress: "costumerAdress",
          //           costumerName: "costumerName",
          //           costumerPhone: "costumerPhone",
          //           date: "date",
          //           companyAdress: "companyAdress",
          //           companyName: "companyName",
          //           companyPhone: "companyPhone",
          //           fax: "fax",
          //           postalCode: "postalCode",
          //           siret: "siret",
          //           tva: "tva",
          //           payWay: "payWay",
          // streamCart: const [
          //   {
          //     "article": "Samsung",
          //     "price": "10000",
          //     "quantity": "2",
          //     "description": "ksdfsdlfsfsmfsfmqs"
          //   },
          //   {
          //     "article": "Samsung",
          //     "price": "1000",
          //     "quantity": "2",
          //     "description": "ksdfsdlfsfsmfsfmqs"
          //   },
          //   {
          //     "article": "Samsung",
          //     "price": "100",
          //     "quantity": "2",
          //     "description": "ksdfsdlfsfsmfsfmqs"
          //   },
          //   {
          //     "article": "Samsung",
          //     "price": "100",
          //     "quantity": "2",
          //     "description": "ksdfsdlfsfsmfsfmqs"
          //   },
          //  ]
          // cart: [
          //   Article(
          //       article: "Samsung",
          //       price: "10000",
          //       quantity: "2",
          //       description: "ksdfsdlfsfsmfsfmqs"),
          //   Article(
          //       article: "Samsung",
          //       price: "1000",
          //       quantity: "2",
          //       description: "ksdfsdlfsfsmfsfmqs"),
          //   Article(
          //       article: "Samsung",
          //       price: "100",
          //       quantity: "2",
          //       description: "ksdfsdlfsfsmfsfmqs"),
          //   Article(
          //       article: "Samsung",
          //       price: "10",
          //       quantity: "2",
          //       description: "ksdfsdlfsfsmfsfmqs"),
          // ],
          // total: 200,
          // discount: "0",
          // documentValue: isEstimate ? "Devis" : "Facture",
          // url:
          //     "https://firebasestorage.googleapis.com/v0/b/gestion-de-commerce-reparation.appspot.com/o/MX1rjWYlX8fdz4Dm8B3vZZqrq702.jpg?alt=media&token=5e3280ca-5ac0-4f52-8ac3-67338ac1b0c6");
          // }))
          home: const Wrapper()),
    );
  }
}
