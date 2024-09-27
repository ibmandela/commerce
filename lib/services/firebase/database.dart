import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

class DatabaseService {
  String? uid, name;
  DatabaseService({this.uid, this.name});

  final CollectionReference companyCollection =
      FirebaseFirestore.instance.collection("Companies");

  //  fonction qui ajoute une compagnie dans la base de donnée
  Future<void> saveCompany(
      String? name,
      String? adress,
      String? code,
      String? phone,
      String? fax,
      String? siret,
      String? tva,
      String? path,
      String? url,
      String? invoiceType,
      String? sentence) async {
    return await companyCollection.doc(uid).set({
      'name': name,
      'adress': adress,
      'code': code,
      'phone': phone,
      'fax': fax,
      'siret': siret,
      'tva': tva,
      'url': url,
      'invoiceType': invoiceType,
      "sentence": sentence
    }).then((value) => Hive.box("currentUser").put(uid, {
          'name': name,
          'adress': adress,
          'code': code,
          'phone': phone,
          'fax': fax,
          'siret': siret,
          'tva': tva,
          'uid': uid,
          'path': path,
          'url': url,
          "invoiceType": invoiceType,
          "sentence": sentence,
          "defaultData": true
        }));
  }

  // Future<void> modifyCompany(
  //     String? name,
  //     String? adress,
  //     String? code,
  //     String? phone,
  //     String? fax,
  //     String? siret,
  //     String? tva,
  //     String? url) async {
  //   return await companyCollection.doc(uid).update({
  //     'name': name,
  //     'adress': adress,
  //     'code': code,
  //     'phone': phone,
  //     'fax': fax,
  //     'siret': siret,
  //     'tva': tva,
  //     "url": url
  //   });
  // }

  Stream<DocumentSnapshot> companyInformation() {
    return companyCollection.doc(uid).snapshots();
  }
}
