import 'package:gestion_commerce_reparation/common/message.dart';
import 'package:gestion_commerce_reparation/modeles/user.dart';
import 'package:gestion_commerce_reparation/services/hive_database/boxes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CompanyDatabase {
  String? userUid;
  CompanyDatabase({this.userUid});

  final _companyCollection = FirebaseFirestore.instance.collection("Companies");

  Future<void> addProduct(article, price, categorie) async {
    final CollectionReference subCollectionActivities =
        _companyCollection.doc(userUid).collection('Articles');
    ArticleBox.articleBox!.put(article.toUpperCase(), {
      'categorie': categorie.toUpperCase(),
      'article': article.toUpperCase(),
      'price': price,
      "uid": article.toUpperCase()
    });

    subCollectionActivities.doc(article.toUpperCase()).set({
      'categorie': categorie.toUpperCase(),
      'article': article.toUpperCase(),
      'price': price,
    }).catchError((error) => debugPrint(error));
  }

  Future<void> deleteProduct(String? articleUid, BuildContext context) async {
    try {
      _companyCollection
          .doc(userUid)
          .collection('Articles')
          .doc(articleUid)
          .delete();
      ArticleBox.articleBox!.delete(articleUid);
    } on FirebaseException catch (e) {
      if (context.mounted) {
        return showDeleteDialog(context, e);
      }
    }
  }

  Product _productFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> documentSnapshot =
        snapshot.data() as Map<String, dynamic>;
    return Product(
        uid: snapshot.id,
        article: documentSnapshot['article'],
        price: documentSnapshot['price'],
        categorie: documentSnapshot['categorie']);
  }

  List<Product> _productListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => _productFromSnapshot(doc)).toList();
  }

  Stream<QuerySnapshot> products() {
    return _companyCollection
        .doc(userUid)
        .collection('Articles')
        .orderBy('article')
        .snapshots();
  }

  Stream<QuerySnapshot> productByCategorie(categorie) {
    return _companyCollection
        .doc(userUid)
        .collection('Articles')
        .where('categorie', isEqualTo: categorie)
        .orderBy('article')
        .snapshots();
  }

  Future<List<Product>> productByCategorieFuture(categorie) {
    return _companyCollection
        .doc(userUid)
        .collection('Articles')
        .where('categorie', isEqualTo: categorie)
        .orderBy('article')
        .get()
        .then((value) => _productListFromSnapshot(value));
  }

  Future<List<Product>> productsFuture() {
    return _companyCollection
        .doc(userUid)
        .collection('Articles')
        .orderBy('article')
        .get()
        .then((value) => _productListFromSnapshot(value));
  }

  Future<void> addCategorie(categorie, context) async {
    final CollectionReference subCollectionActivities =
        _companyCollection.doc(userUid).collection('Categories');
    try {
      CategoriesBox.categoriesBox!.put(categorie.toUpperCase(), {
        'categorie': categorie.toUpperCase(),
        "uid": categorie.toUpperCase(),
      });
      subCollectionActivities.doc(categorie).set({
        'categorie': categorie.toUpperCase(),
      });
    } on FirebaseException catch (e) {
      if (context.mounted) {
        return showAddDialog(context, e);
      }
    }
  }

  Future<void> deleteCategorie(categorieUid, context) async {
    try {
      await _companyCollection
          .doc(userUid)
          .collection('Categories')
          .doc(categorieUid.toUpperCase())
          .delete()
          .then((value) => CategoriesBox.categoriesBox!.delete(categorieUid));
    } on FirebaseException catch (e) {
      if (context.mounted) {
        return showDeleteDialog(context, e);
      }
    }
  }

  Categorie _categorieFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> documentSnapshot =
        snapshot.data() as Map<String, dynamic>;
    return Categorie(
        uid: snapshot.id, categorie: documentSnapshot['categorie']);
  }

  List<Categorie> _categorieListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => _categorieFromSnapshot(doc)).toList();
  }

  Future<List<Categorie>> get categoriesFuture {
    return _companyCollection
        .doc(userUid)
        .collection('Categories')
        .orderBy('categorie')
        .get()
        .then((value) => _categorieListFromSnapshot(value));
  }

  Stream<QuerySnapshot> categories() {
    return _companyCollection
        .doc(userUid)
        .collection('Categories')
        .orderBy('description')
        .snapshots();
  }

  Future<void> addDescription(description, context) async {
    final CollectionReference subCollectionActivities =
        _companyCollection.doc(userUid).collection('Descriptions');
    try {
      DescriptionBox.descriptionBox!.put(description.toUpperCase(), {
        'description': description.toUpperCase(),
        'uid': description.toUpperCase(),
      });
      await subCollectionActivities.doc(description).set({
        'description': description.toUpperCase(),
      });
    } on FirebaseException catch (e) {
      if (context.mounted) {
        return showAddDialog(context, e);
      }
    }
  }

  Future<void> deleteDescription(descriptionUid, context) async {
    try {
      await _companyCollection
          .doc(userUid)
          .collection('Descriptions')
          .doc(descriptionUid.toUpperCase())
          .delete()
          .then(
              (value) => DescriptionBox.descriptionBox!.delete(descriptionUid));
    } on FirebaseException catch (e) {
      if (context.mounted) {
        return showDeleteDialog(context, e);
      }
    }
  }

  Description _descriptionFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> documentSnapshot =
        snapshot.data() as Map<String, dynamic>;
    return Description(
        uid: snapshot.id, description: documentSnapshot['description']);
  }

  List<Description> _descriptionListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => _descriptionFromSnapshot(doc)).toList();
  }

  Future<List<Description>> get descriptionFuture {
    return _companyCollection
        .doc(userUid)
        .collection('Descriptions')
        .orderBy('description')
        .get()
        .then((value) => _descriptionListFromSnapshot(value));
  }

  Future<void> addActivity(
      String? ticketNumber,
      articleList,
      costumerName,
      phone,
      payWay,
      total,
      discount,
      isEstimate,
      costumerAdress,
      ticketDate,
      context) async {
    final CollectionReference subCollectionActivities =
        _companyCollection.doc(userUid).collection('Activities');
    try {
      ActivitiesBox.activitiesBox!.put(ticketNumber, {
        'ticketNumber': ticketNumber,
        'date': ticketDate,
        'costumerName': costumerName.toUpperCase(),
        'phone': phone,
        'costumerAdress': costumerAdress.toUpperCase(),
        'activityList': articleList.map((article) => article.toJson()).toList(),
        'payWay': payWay,
        'total': total,
        'discount': discount,
        'isEstimate': isEstimate,
        "uid": ticketNumber
      });
      await subCollectionActivities.doc(ticketNumber).set({
        'ticketNumber': ticketNumber,
        'date': ticketDate,
        'costumerName': costumerName.toUpperCase(),
        'phone': phone,
        'costumerAdress': costumerAdress.toUpperCase(),
        'activityList': articleList.map((article) => article.toJson()).toList(),
        'payWay': payWay,
        'total': total,
        'discount': discount,
        'isEstimate': isEstimate
      });
    } on FirebaseException catch (e) {
      if (context.mounted) {
        return showAddDialog(context, e);
      }
    }
  }

  Future<void> modifyActitvityNumber(activityUid, phone, context) async {
    try {
      await _companyCollection
          .doc(userUid)
          .collection('Activities')
          .doc(activityUid)
          .update({'phone': phone}).then(
              (value) => debugPrint('actvity updated successully'));
    } on FirebaseException catch (e) {
      if (context.mounted) {
        return showModifyDialog(context, e);
      }
    }
  }

  Future<void> modifyActitvityTotal(activityUid, total, context) async {
    try {
      await _companyCollection
          .doc(userUid)
          .collection('Activities')
          .doc(activityUid)
          .update({'total': total}).then(
              (value) => debugPrint('actvity updated successully'));
    } on FirebaseException catch (e) {
      if (context.mounted) {
        return showModifyDialog(context, e);
      }
    }
  }

  Future<void> deleteActivity(String? activityUid, context) async {
    try {
      await _companyCollection
          .doc(userUid)
          .collection('Activities')
          .doc(activityUid)
          .delete()
          .then((value) => ActivitiesBox.activitiesBox!.delete(activityUid));
    } on FirebaseException catch (e) {
      if (context.mounted) {
        return showDeleteDialog(context, e);
      }
    }
  }

  Activity _activityFromsnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> documentSnapshot =
        snapshot.data() as Map<String, dynamic>;
    return Activity(
        activityUid: snapshot.id,
        ticketNumber: documentSnapshot['ticketNumber'],
        ticketDate: documentSnapshot['date'].toDate(),
        phone: documentSnapshot['phone'],
        costumerName: documentSnapshot['costumerName'],
        costumerAdress: documentSnapshot['costumerAdress'],
        discount: documentSnapshot['discount'],
        payWay: documentSnapshot['payWay'],
        total: documentSnapshot['total'],
        isEstimate: documentSnapshot['isEstimate'],
        activityList: documentSnapshot['activityList']);
  }

  List<Activity> _activityListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => _activityFromsnapshot(doc)).toList();
  }

  Stream<QuerySnapshot> onlyActivities(time) {
    return _companyCollection
        .doc(userUid)
        .collection('Activities')
        .where('isRepair', isEqualTo: true)
        .where('date', isGreaterThanOrEqualTo: time)
        .snapshots();
  }

  Stream<QuerySnapshot> activitiesByTicket(ticketNumber) {
    return _companyCollection
        .doc(userUid)
        .collection('Activities')
        .where('ticketNumber', isEqualTo: ticketNumber)
        .snapshots();
  }

  Stream<QuerySnapshot> activities() {
    return _companyCollection.doc(userUid).collection('Activities').snapshots();
  }

  Stream<QuerySnapshot> activitiesByCostumer(String costumerNumber) {
    return _companyCollection
        .doc(userUid)
        .collection('Activities')
        .orderBy('date', descending: true)
        .where('phone', isEqualTo: costumerNumber)
        .snapshots();
  }

  Stream<List<Activity>> activitiesByTimes(time) {
    return _companyCollection
        .doc(userUid)
        .collection('Activities')
        .orderBy('date', descending: true)
        .where('date', isGreaterThanOrEqualTo: time)
        .snapshots()
        .map(_activityListFromSnapshot);
  }

  Future<List<Activity>> activitiesByTimesFuture(time) {
    return _companyCollection
        .doc(userUid)
        .collection('Activities')
        .orderBy('date', descending: true)
        .where('date', isGreaterThanOrEqualTo: time)
        .get()
        .then((value) => _activityListFromSnapshot(value));
  }

  Future<List<Activity>> activitiesFuture() {
    return _companyCollection
        .doc(userUid)
        .collection('Activities')
        .get()
        .then((value) => _activityListFromSnapshot(value));
  }

  Future<List<Activity>> onlyActivitiesFuture(time) {
    return _companyCollection
        .doc(userUid)
        .collection('Activities')
        .where('isRepair', isEqualTo: true)
        .where('date', isGreaterThanOrEqualTo: time)
        .get()
        .then((value) => _activityListFromSnapshot(value));
  }

  Future<List<Activity>> activitiesByTicketFuture(ticketNumber) {
    return _companyCollection
        .doc(userUid)
        .collection('Activities')
        .where('ticketNumber', isEqualTo: ticketNumber)
        .get()
        .then((value) => _activityListFromSnapshot(value));
  }

  Future<List<Activity>> activitiesByCostumerFuture(String costumerNumber) {
    return _companyCollection
        .doc(userUid)
        .collection('Activities')
        .orderBy('date', descending: true)
        .where('phone', isEqualTo: costumerNumber)
        .get()
        .then((value) => _activityListFromSnapshot(value));
  }

  Future<void> addRepair(String? ticketNumber, phone, costumerName, discount,
      accompte, repairList, total, costumerAdress, date, context) async {
    final CollectionReference subCollectionActivities =
        _companyCollection.doc(userUid).collection('Repairs');
    try {
      RepairBox.repairBox!.put(ticketNumber, {
        'ticketNumber': ticketNumber,
        'date': date,
        'phone': phone,
        'costumerName': costumerName.toUpperCase(),
        'costumerAdress': costumerAdress.toUpperCase(),
        'accompte': accompte,
        'discount': discount,
        'repairList': repairList.map((repair) => repair.toJson()).toList(),
        'total': total,
        'state': 'En cours',
        'emplacement': '',
        'uid': ticketNumber
      });
      await subCollectionActivities.doc(ticketNumber).set({
        'ticketNumber': ticketNumber,
        'date': date,
        'phone': phone,
        'costumerName': costumerName.toUpperCase(),
        'costumerAdress': costumerAdress.toUpperCase(),
        'accompte': accompte,
        'discount': discount,
        'repairList': repairList.map((repair) => repair.toJson()).toList(),
        'total': total,
        'state': 'En cours',
        'emplacement': ''
      });
    } on FirebaseException catch (e) {
      if (context.mounted) {
        return showAddDialog(context, e);
      }
    }
  }

//A FAIRE
  Future<void> modifyRepairState(
      String? repairUid,
      state,
      ticketNumber,
      phone,
      costumerName,
      costumerAdress,
      accompte,
      discount,
      repairList,
      total,
      date,
      context) async {
    final docReference =
        _companyCollection.doc(userUid).collection('Repairs').doc(repairUid);
    try {
      await docReference.update({
        'state': state,
      }).then((value) => RepairBox.repairBox!.put(repairUid, {
            'ticketNumber': ticketNumber,
            'date': date,
            'phone': phone,
            'costumerName': costumerName.toUpperCase(),
            'costumerAdress': costumerAdress.toUpperCase(),
            'accompte': accompte,
            'discount': discount,
            'repairList': repairList,
            'total': total,
            'state': state,
            'emplacement': '',
            'uid': repairUid
          }));
    } on FirebaseException catch (e) {
      if (context.mounted) {
        return showModifyDialog(context, e);
      }
    }
  }

  Future<void> modifyRepairEmplacement(
      String? repairUid, emplacement, context) async {
    final docReference =
        _companyCollection.doc(userUid).collection('Repairs').doc(repairUid);
    try {
      await docReference.update({
        'emplacement': emplacement,
      }).then(
          (value) => debugPrint('activity emplacement updated successfully'));
    } on FirebaseException catch (e) {
      if (context.mounted) {
        return showModifyDialog(context, e);
      }
    }
  }

  modifyRepairNumber(String? repairUid, phone, context) async {
    final docReference =
        _companyCollection.doc(userUid).collection('Repairs').doc(repairUid);
    try {
      await docReference.update({
        'phone': phone,
      }).then(
          (value) => debugPrint('activity emplacement updated successfully'));
    } on FirebaseException catch (e) {
      if (context.mounted) {
        return showModifyDialog(context, e);
      }
    }
  }

  Future<void> deleteRepair(String? repairUid, context) async {
    try {
      await _companyCollection
          .doc(userUid)
          .collection('Repairs')
          .doc(repairUid)
          .delete()
          .then((value) => RepairBox.repairBox!.delete(repairUid));
    } on FirebaseException catch (e) {
      if (context.mounted) {
        return showDeleteDialog(context, e);
      }
    }
  }

  RepairActivity _repairFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> documentSnapshot =
        snapshot.data() as Map<String, dynamic>;
    return RepairActivity(
        repairUid: snapshot.id,
        ticketNumber: documentSnapshot['ticketNumber'],
        date: documentSnapshot['date'].toDate(),
        phone: documentSnapshot['phone'],
        costumerName: documentSnapshot['costumerName'],
        costumerAdress: documentSnapshot['costumerAdress'],
        discount: documentSnapshot['discount'],
        accompte: documentSnapshot['accompte'],
        total: documentSnapshot['total'],
        state: documentSnapshot['state'],
        emplacement: documentSnapshot['emplacement'],
        repairList: documentSnapshot['repairList']);
  }

  List<RepairActivity> _repairListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => _repairFromSnapshot(doc)).toList();
  }

  Future<List<RepairActivity>> repairsFutur() {
    return _companyCollection
        .doc(userUid)
        .collection('Repairs')
        .orderBy('date', descending: true)
        .get()
        .then((value) => _repairListFromSnapshot(value));
  }

  Future<List<RepairActivity>> repairsByDaysFutre(date) {
    return _companyCollection
        .doc(userUid)
        .collection('Repairs')
        .orderBy('date', descending: true)
        .where('date', isEqualTo: date)
        .get()
        .then(_repairListFromSnapshot);
  }

  Future<List<RepairActivity>> repairsBycostumerFutre(phone) {
    return _companyCollection
        .doc(userUid)
        .collection('Repairs')
        .orderBy('date', descending: true)
        .where('phone', isEqualTo: phone)
        .get()
        .then((value) => _repairListFromSnapshot(value));
  }

  Future<List<RepairActivity>> repairsIsGreaterFuture(time) {
    return _companyCollection
        .doc(userUid)
        .collection('Repairs')
        .orderBy('date', descending: true)
        .where('date', isGreaterThan: time)
        .get()
        .then((value) => _repairListFromSnapshot(value));
  }

  Stream<List<RepairActivity>> repairs() {
    return _companyCollection
        .doc(userUid)
        .collection('Repairs')
        .orderBy('date', descending: true)
        .snapshots()
        .map((event) => _repairListFromSnapshot(event));
  }

  Stream<List<RepairActivity>> repairsByDays(date) {
    return _companyCollection
        .doc(userUid)
        .collection('Repairs')
        .orderBy('date', descending: true)
        .where('date', isEqualTo: date)
        .snapshots()
        .map((event) => _repairListFromSnapshot(event));
  }

  Stream<List<RepairActivity>> repairsIsGreater(time) {
    return _companyCollection
        .doc(userUid)
        .collection('Repairs')
        .orderBy('date', descending: true)
        .where('date', isGreaterThan: time)
        .snapshots()
        .map((event) => _repairListFromSnapshot(event));
  }

  Future<void> addMissingItem(part, model, context) async {
    String uid = DateTime.now().millisecondsSinceEpoch.toString();
    final CollectionReference subCollectionActivities =
        _companyCollection.doc(userUid).collection('Missing');
    try {
      MissingBox.missingBox!.put(uid, {
        'part': part.toUpperCase(),
        'model': model.toUpperCase(),
        "uid": uid
      });
      await subCollectionActivities
          .doc(uid)
          .set({'part': part.toUpperCase(), 'model': model.toUpperCase()});
    } on FirebaseException catch (e) {
      if (context.mounted) {
        return showAddDialog(context, e);
      }
    }
  }

  Future<void> deleteMissingItem(String? itemUid, context) async {
    try {
      MissingBox.missingBox!.delete(itemUid);
      await _companyCollection
          .doc(userUid)
          .collection('Missing')
          .doc(itemUid)
          .delete();
    } on FirebaseException catch (e) {
      if (context.mounted) {
        return showDeleteDialog(context, e);
      }
    }
  }

  Stream<QuerySnapshot> missingItems() {
    return _companyCollection.doc(userUid).collection('Missing').snapshots();
  }

  Future<void> addRefundOrDebt(
      String? date, name, number, description, debt, refund, context) async {
    String uid = DateTime.now().millisecondsSinceEpoch.toString();
    final CollectionReference subCollectionActivities =
        _companyCollection.doc(userUid).collection('DebtOrRefund');
    try {
      DebtOrRefundBox.debtorRefundBox!.put(uid, {
        'date': date,
        'name': name.toUpperCase(),
        'number': number,
        'description': description.toUpperCase(),
        'debt': debt,
        'refund': refund,
        "uid": uid
      });
      await subCollectionActivities.doc(uid).set({
        'date': date,
        'name': name.toUpperCase(),
        'number': number,
        'description': description.toUpperCase(),
        'debt': debt,
        'refund': refund,
      });
    } on FirebaseException catch (e) {
      if (context.mounted) {
        return showAddDialog(context, e);
      }
    }
  }

  Future<void> modifyDebtOrRefundPhone(
      debtOrRefundUid, newNumber, context) async {
    try {
      await _companyCollection
          .doc(userUid)
          .collection('DebtOrRefund')
          .doc(debtOrRefundUid)
          .update({'number': newNumber}).then(
              (value) => debugPrint('Debt update successully'));
    } on FirebaseException catch (e) {
      if (context.mounted) {
        return showModifyDialog(context, e);
      }
    }
  }

  Future<void> deleteRefundOrDebt(String? itemUid, context) async {
    try {
      DebtOrRefundBox.debtorRefundBox!.delete(itemUid);
      await _companyCollection
          .doc(userUid)
          .collection('DebtOrRefund')
          .doc(itemUid)
          .delete();
    } on FirebaseException catch (e) {
      if (context.mounted) {
        return showDeleteDialog(context, e);
      }
    }
  }

  DebtOrRefund _debtOrRefundFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> documentsnapshot =
        snapshot.data() as Map<String, dynamic>;
    return DebtOrRefund(
        uid: snapshot.id,
        date: documentsnapshot['date'],
        debt: documentsnapshot['debt'],
        description: documentsnapshot['description'],
        name: documentsnapshot['name'],
        number: documentsnapshot['number'],
        refund: documentsnapshot['refund']);
  }

  List<DebtOrRefund> _debtOrRefundListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => _debtOrRefundFromSnapshot(doc)).toList();
  }

  Future<List<DebtOrRefund>> refundsOrdebts() {
    return _companyCollection
        .doc(userUid)
        .collection('DebtOrRefund')
        .orderBy('date', descending: true)
        .get()
        .then((value) => _debtOrRefundListFromSnapshot(value));
  }

  Future<List<DebtOrRefund>> refundsOrdebtsByCostumerFuture(String? phone) {
    return _companyCollection
        .doc(userUid)
        .collection('DebtOrRefund')
        .orderBy('date', descending: true)
        .where('number', isEqualTo: phone)
        .get()
        .then((value) => _debtOrRefundListFromSnapshot(value));
  }

  Stream<List<DebtOrRefund>> refundsOrdebtsByCostumer(String? phone) {
    return _companyCollection
        .doc(userUid)
        .collection('DebtOrRefund')
        .orderBy('date', descending: true)
        .where('number', isEqualTo: phone)
        .snapshots()
        .map((snapshot) => _debtOrRefundListFromSnapshot(snapshot));
  }
}
