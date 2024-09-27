import 'package:gestion_commerce_reparation/common/constant.dart';
import 'package:gestion_commerce_reparation/common/message.dart';
import 'package:gestion_commerce_reparation/modeles/user.dart';
import 'package:gestion_commerce_reparation/services/firebase/company_database.dart';
import 'package:gestion_commerce_reparation/services/hive_database/boxes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CostumerDatabase {
  final _collectionCompany = FirebaseFirestore.instance.collection('Companies');

  Future<void> addCostumer(name, adress, phone, context) async {
    final subCollectionActivities =
        _collectionCompany.doc(userUid).collection("Costumers").doc(phone);
    await subCollectionActivities.get().then((docSnapshot) {
      if (docSnapshot.exists) {
        _showAlertDialog(phone, name, adress, context);
      } else {
        try {
          subCollectionActivities.set({
            'name': name.toUpperCase(),
            'adress': adress.toUpperCase(),
            'phone': phone,
          });
        } on FirebaseException catch (e) {
          if (context.mounted) {
            return showAddDialog(context, e);
          }
        }
      }
    });
  }

  Stream<QuerySnapshot> costumers() {
    return _collectionCompany
        .doc(userUid)
        .collection('Costumers')
        .orderBy('name', descending: false)
        .snapshots();
  }

  Future<DocumentSnapshot> costumer(costumerNumber) {
    return _collectionCompany
        .doc(userUid)
        .collection('Costumers')
        .doc(costumerNumber)
        .get();
  }

  Future<void> deleteCostumer(String? costumerUid, context) async {
    try {
      await _collectionCompany
          .doc(userUid)
          .collection('Costumers')
          .doc(costumerUid)
          .delete();
    } on FirebaseException catch (e) {
      if (context.mounted) {
        return showDeleteDialog(context, e);
      }
    }
  }

  Costumer _costumerFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> documentField =
        snapshot.data()! as Map<String, dynamic>;

    return Costumer(
        name: documentField['name'],
        adress: documentField['adress'],
        uid: snapshot.id,
        phone: documentField['phone']);
  }

  List<Costumer> _costumerListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return _costumerFromSnapshot(doc);
    }).toList();
  }

//  Stream<Model> get companyDoc {
//     return _collectionActivities
//         .doc(userUid)
//         .collection('Models')
//         .orderBy('model')
//         .snapshots().map(_companyListFromSnapshot);
//   }

  Stream<List<Costumer>> get costumerstream {
    return _collectionCompany
        .doc(userUid)
        .collection('Costumers')
        .orderBy('name')
        .snapshots()
        .map(_costumerListFromSnapshot);
  }

  Future<List<Costumer>> get costumersFuture {
    return _collectionCompany
        .doc(userUid)
        .collection('Costumers')
        .orderBy('name')
        .get()
        .then((value) => _costumerListFromSnapshot(value));
  }

  _showAlertDialog(String? phone, name, adress, context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Attention...'),
              content: const Text(
                  'Ce client existe deja dans votre base de donnée. Voulez vous le modifier?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Non')),
                TextButton(
                    onPressed: () => {
                          Navigator.pop(context),
                          _collectionCompany
                              .doc(userUid)
                              .collection("Costumers")
                              .doc(phone)
                              .set({
                                'name': name,
                                'adress': adress,
                                'phone': phone,
                              })
                              .then((value) =>
                                  debugPrint('stock add successfully'))
                              .catchError((error) => debugPrint(error))
                        },
                    child: const Text('Oui'))
              ],
            ));
  }
}

class ModelDatabase {
  final _collectionActivities =
      FirebaseFirestore.instance.collection('Companies');

  Future<void> addModel(model, context) async {
    final subCollectionActivities = _collectionActivities
        .doc(userUid)
        .collection("Models")
        .doc(model.toUpperCase());
    await subCollectionActivities.get().then((docSnapshot) {
      if (docSnapshot.exists) {
      } else {
        try {
          subCollectionActivities.set({
            'model': model.toUpperCase(),
          });
        } on FirebaseException catch (e) {
          if (context.mounted) {
            return showAddDialog(context, e);
          }
        }
      }
    });
  }

  Future<void> deleteModel(String? modelUid, context) async {
    try {
      await _collectionActivities
          .doc(userUid)
          .collection('Models')
          .doc(modelUid)
          .delete();
    } on FirebaseException catch (e) {
      if (context.mounted) {
        return showDeleteDialog(context, e);
      }
    }
  }

  Stream<QuerySnapshot> models() {
    return _collectionActivities
        .doc(userUid)
        .collection('Models')
        .orderBy('model')
        .snapshots();
  }

  Model _modelFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> documentField =
        snapshot.data()! as Map<String, dynamic>;

    return Model(model: documentField['model'], uid: snapshot.id);
  }

  List<Model> _modelListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return _modelFromSnapshot(doc);
    }).toList();
  }

  Future<List<Model>> get modelFuture {
    return _collectionActivities
        .doc(userUid)
        .collection('Models')
        .orderBy('model')
        .get()
        .then((value) => _modelListFromSnapshot(value));
  }

  Stream<List<Model>> get modelStream {
    return _collectionActivities
        .doc(userUid)
        .collection('Models')
        .orderBy('model')
        .snapshots()
        .map(_modelListFromSnapshot);
  }

  Future<void> addBrand(brand, context) async {
    final subCollectionActivities = _collectionActivities
        .doc(userUid)
        .collection("Brands")
        .doc(brand.toUpperCase());

    try {
      subCollectionActivities.set({
        'brand': brand.toUpperCase(),
      });
      BrandBox.brandBox!.put(brand, {"brand": brand, "uid": brand});
    } on FirebaseException catch (e) {
      if (context.mounted) {
        return showModifyDialog(context, e);
      }
    }
  }

  Future<void> deleteBrand(String? brandUid, context) async {
    try {
      await _collectionActivities
          .doc(userUid)
          .collection('Brands')
          .doc(brandUid)
          .delete();
    } on FirebaseException catch (e) {
      if (context.mounted) {
        return showDeleteDialog(context, e);
      }
    }
  }

  Brand _brandFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> documentField =
        snapshot.data()! as Map<String, dynamic>;

    return Brand(brand: documentField['brand'], uid: snapshot.id);
  }

  List<Brand> _brandListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return _brandFromSnapshot(doc);
    }).toList();
  }

  Future<List<Brand>> get brandFutures {
    return _collectionActivities
        .doc(userUid)
        .collection('Brands')
        .orderBy('brand')
        .get()
        .then((value) => _brandListFromSnapshot(value));
  }
}

class PartsDatabase {
  final _collectionActivities =
      FirebaseFirestore.instance.collection('Companies');
  Future<void> addPart(part, context) async {
    final subCollectionActivities = _collectionActivities
        .doc(userUid)
        .collection("Parts")
        .doc(part.toUpperCase());

    try {
      PartBox.partBox!.put(part, {"part": part, "uid": part});
      subCollectionActivities.set({
        'part': part.toUpperCase(),
      });
    } on FirebaseException catch (e) {
      if (context.mounted) {
        return showModifyDialog(context, e);
      }
    }
  }

  Future<void> deletePart(String? partUid, context) async {
    try {
      PartBox.partBox!.delete(partUid);
      await _collectionActivities
          .doc(userUid)
          .collection('Parts')
          .doc(partUid)
          .delete();
    } on FirebaseException catch (e) {
      if (context.mounted) {
        return showDeleteDialog(context, e);
      }
    }
  }

  Stream<QuerySnapshot> parts() {
    return _collectionActivities
        .doc(userUid)
        .collection('Parts')
        .orderBy('part')
        .snapshots();
  }

  Part _partFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> documentField =
        snapshot.data()! as Map<String, dynamic>;

    return Part(part: documentField['part'], uid: snapshot.id);
  }

  List<Part> _partListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return _partFromSnapshot(doc);
    }).toList();
  }

  Future<List<Part>> get partFuture {
    return _collectionActivities
        .doc(userUid)
        .collection('Parts')
        .orderBy('part')
        .get()
        .then((snapshot) => _partListFromSnapshot(snapshot));
  }

  Stream<List<Part>> get partStream {
    return _collectionActivities
        .doc(userUid)
        .collection('Parts')
        .orderBy('part')
        .snapshots()
        .map(_partListFromSnapshot);
  }
}

class StockDatabase {
  final _collectionActivities =
      FirebaseFirestore.instance.collection('Companies');

  Future<void> addStock(
      part, model, emplacement, int quantity, price, context) async {
    final subCollectionActivities = _collectionActivities
        .doc(userUid)
        .collection("Stock")
        .doc('${part.toUpperCase()} ${model.toUpperCase()}');

    try {
      StockBox.stockBox!.put('${part.toUpperCase()} ${model.toUpperCase()}', {
        'part': part.toUpperCase(),
        'quantity': quantity,
        'emplacement': emplacement,
        'price': price,
        'model': model.toUpperCase(),
        "uid": '${part.toUpperCase()} ${model.toUpperCase()}'
      });
      subCollectionActivities.set({
        'part': part.toUpperCase(),
        'quantity': quantity,
        'emplacement': emplacement,
        'price': price,
        'model': model.toUpperCase()
      });
    } on FirebaseException catch (e) {
      if (context.mounted) {
        return showAddDialog(context, e);
      }
    }
  }

  Future<void> modifyStockEmplacement(String? stockUid, emplacement, part,
      quantity, price, model, context) async {
    final subCollectionActivities =
        _collectionActivities.doc(userUid).collection("Stock").doc(stockUid);
    try {
      await subCollectionActivities.update({
        'emplacement': emplacement,
      }).then((value) => StockBox.stockBox!.put(stockUid, {
            'part': part.toUpperCase(),
            'quantity': quantity,
            'emplacement': emplacement,
            'price': price,
            'model': model.toUpperCase(),
            "uid": stockUid
          }));
    } on FirebaseException catch (e) {
      if (context.mounted) {
        return showModifyDialog(context, e);
      }
    }
  }

  Future<void> modifyStockQuantity(
      stockUid, model, part, context, price, quantity, emplacement) {
    final subCollectionStocks =
        _collectionActivities.doc(userUid).collection("Stock").doc(stockUid);
    return subCollectionStocks.get().then((docSnapshot) {
      if (docSnapshot.exists) {
        if (docSnapshot.get('quantity') > 0) {
          try {
            subCollectionStocks
                .update({'quantity': FieldValue.increment(-1)}).then(
                    (value) => StockBox.stockBox!.put(stockUid, {
                          'part': part.toUpperCase(),
                          'quantity': quantity - 1,
                          'emplacement': emplacement,
                          'price': price,
                          'model': model.toUpperCase(),
                          "uid": stockUid
                        }));
          } on FirebaseException catch (e) {
            if (context.mounted) {
              return showModifyDialog(context, e);
            }
          }
        } else {
          _noInStockshowAlertDialog(
              part.toUpperCase(), model.toUpperCase(), context);
        }
      } else {
        _noInStockshowAlertDialog(
            part.toUpperCase(), model.toUpperCase(), context);
        addStock(
            part.toUpperCase(), model.toUpperCase(), '', 0, price, context);
      }
    });
  }

  Stock _stockFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> documentSnapshot =
        snapshot.data() as Map<String, dynamic>;
    return Stock(
        uid: snapshot.id,
        emplacement: documentSnapshot['emplacement'],
        model: documentSnapshot['model'],
        part: documentSnapshot['part'],
        price: documentSnapshot['price'],
        quantity: documentSnapshot['quantity']);
  }

  List<Stock> _stockListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => _stockFromSnapshot(doc)).toList();
  }

  Future<List<Stock>> stocksFuture() {
    return _collectionActivities
        .doc(userUid)
        .collection('Stock')
        .get()
        .then((value) => _stockListFromSnapshot(value));
  }

  Stream<QuerySnapshot> stocks() {
    return _collectionActivities
        .doc(userUid)
        .collection('Stock')
        .orderBy('part')
        .snapshots();
  }

  Stream<QuerySnapshot> stocksByPart(part) {
    return _collectionActivities
        .doc(userUid)
        .collection('Stock')
        .orderBy('model', descending: true)
        .where('part', isEqualTo: part.toUpperCase())
        .snapshots();
  }

  Future<List<Stock>> stocksByPartFutur(part) {
    return _collectionActivities
        .doc(userUid)
        .collection('Stock')
        .orderBy('model', descending: true)
        .where('part', isEqualTo: part.toUpperCase())
        .get()
        .then((value) => _stockListFromSnapshot(value));
  }

  Future<void> deleteStock(String? stockUid, context) async {
    try {
      StockBox.stockBox!.delete(stockUid);
      await _collectionActivities
          .doc(userUid)
          .collection('Stock')
          .doc(stockUid)
          .delete();
    } on FirebaseException catch (e) {
      if (context.mounted) {
        return showDeleteDialog(context, e);
      }
    }
  }

  Stream<List<Stock>> stockStream(part) {
    return _collectionActivities
        .doc(userUid)
        .collection('Stock')
        .orderBy('model')
        .where('part', isEqualTo: part)
        .snapshots()
        .map(_stockListFromSnapshot);
  }

  _noInStockshowAlertDialog(String? part, model, context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Attention...'),
              content: const Text(
                  "Vous n'avez plus cette pièce en stock. Voulez vous la commander?"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annuler')),
                TextButton(
                    onPressed: () => {
                          CompanyDatabase(userUid: userUid)
                              .addMissingItem(part, model, context),
                          Navigator.pop(context)
                        },
                    child: const Text('Commander'))
              ],
            ));
  }
}
