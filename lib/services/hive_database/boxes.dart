import 'package:flutter/foundation.dart';
import 'package:gestion_commerce_reparation/services/hive_database/hive_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class ActivitiesBox {
  static final instance = ActivitiesBox();
  static Box? activitiesBox;

  initBox() async {
    String path = "/assets/db";
    if (!kIsWeb) {
      path =
          await getApplicationDocumentsDirectory().then((value) => value.path);
    }
    Hive.registerAdapter(ActivitiesHAdapter());
    Hive.init(path);
    ActivitiesBox.activitiesBox = await Hive.openBox("activities");
  }

  loadActivities(List<QueryDocumentSnapshot<Map<String, dynamic>>> data) {
    var list = activitiesBox!.keys;
    for (var doc in data) {
      if (!list.contains(doc.id)) {
        activitiesBox!.put(doc.id, {
          "activityList": doc["activityList"],
          "costumerName": doc["costumerName"],
          "phone": doc["phone"],
          "costumerAdress": doc["costumerAdress"],
          "discount": doc["discount"],
          "payWay": doc["payWay"],
          "ticketNumber": doc["ticketNumber"],
          "date": doc["date"].toDate(),
          "isEstimate": doc["isEstimate"],
          "total": doc["total"],
          "uid": doc.id,
        });
      }
    }
  }
}

class RepairBox {
  static final instance = RepairBox();
  static Box? repairBox;

  initBox() async {
    String path = "/assets/db";
    if (!kIsWeb) {
      path =
          await getApplicationDocumentsDirectory().then((value) => value.path);
    }
    Hive.registerAdapter(RepairesHAdapter());
    Hive.init(path);
    RepairBox.repairBox = await Hive.openBox("repairs");
  }

  laodRepairs(List<QueryDocumentSnapshot<Map<String, dynamic>>> data) {
    var list = repairBox!.keys;
    for (var doc in data) {
      if (!list.contains(doc.id)) {
        repairBox!.put(doc.id, {
          "repairList": doc["repairList"],
          "costumerName": doc["costumerName"],
          "phone": doc["phone"],
          "costumerAdress": doc["costumerAdress"],
          "discount": doc["discount"],
          "accompte": doc["accompte"],
          "emplacement": doc["emplacement"],
          "ticketNumber": doc["ticketNumber"],
          "state": doc["state"],
          "date": doc["date"].toDate(),
          "total": doc["total"],
          "uid": doc.id
        });
      }
    }
  }
}

class DebtOrRefundBox {
  static final instance = DebtOrRefundBox();
  static Box? debtorRefundBox;

  initBox() async {
    String path = "/assets/db";
    if (!kIsWeb) {
      path =
          await getApplicationDocumentsDirectory().then((value) => value.path);
    }
    Hive.registerAdapter(DebtOrRefundHAdapter());
    Hive.init(path);
    DebtOrRefundBox.debtorRefundBox = await Hive.openBox("debtOrRefund");
  }

  loadDebtOrRefund(List<QueryDocumentSnapshot<Map<String, dynamic>>> data) {
    var list = debtorRefundBox!.keys;
    for (var doc in data) {
      if (!list.contains(doc.id)) {
        debtorRefundBox!.put(doc.id, {
          "date": doc["date"],
          "debt": doc["debt"],
          "description": doc["description"],
          "name": doc["name"],
          "number": doc["number"],
          "refund": doc["refund"],
          "uid": doc.id
        });
      }
    }
  }
}

class StockBox {
  static final instance = StockBox();
  static Box? stockBox;

  initBox() async {
    String path = "/assets/db";
    if (!kIsWeb) {
      path =
          await getApplicationDocumentsDirectory().then((value) => value.path);
    }
    Hive.registerAdapter(StockHAdapter());
    Hive.init(path);
    StockBox.stockBox = await Hive.openBox("stocks");
  }

  loadStock(List<QueryDocumentSnapshot<Map<String, dynamic>>> data) {
    var list = stockBox!.keys;
    for (var doc in data) {
      if (!list.contains(doc.id)) {
        stockBox!.put(doc.id, {
          "part": doc["part"],
          "model": doc["model"],
          "emplacement": doc["emplacement"],
          "price": doc["price"],
          "quantity": doc["quantity"],
          "uid": doc.id
        });
      }
    }
  }
}

class ArticleBox {
  static final instance = ArticleBox();
  static Box? articleBox;

  initBox() async {
    String path = "/assets/db";
    if (!kIsWeb) {
      path =
          await getApplicationDocumentsDirectory().then((value) => value.path);
    }
    Hive.registerAdapter(ArticleHAdapter());
    Hive.init(path);
    ArticleBox.articleBox = await Hive.openBox("aritcles");
  }

  loadArticles(List<QueryDocumentSnapshot<Map<String, dynamic>>> data) {
    var list = articleBox!.keys;
    for (var doc in data) {
      if (!list.contains(doc.id)) {
        articleBox!.put(doc.id, {
          "article": doc["article"],
          "categorie": doc["categorie"],
          "price": doc["price"],
          "uid": doc.id,
        });
      }
    }
  }
}

class CostumerBox {
  static final CostumerBox instance = CostumerBox();
  static Box? costumerBox;

  initBox() async {
    String path = "/assets/db";
    if (!kIsWeb) {
      path =
          await getApplicationDocumentsDirectory().then((value) => value.path);
    }
    Hive.registerAdapter(CostumerHAdapter());
    Hive.init(path);
    costumerBox = await Hive.openBox("costumers");
  }

  laodCostumers(List<QueryDocumentSnapshot<Map<String, dynamic>>> data) {
    var list = costumerBox!.keys;
    for (var doc in data) {
      if (!list.contains(doc.id)) {
        costumerBox!.put(doc.id, {
          "name": doc["name"],
          "phone": doc["phone"],
          "adress": doc["adress"],
          "uid": doc.id
        });
      }
    }
  }
}

class BrandBox {
  static final instance = BrandBox();
  static Box? brandBox;

  initBox() async {
    String path = "/assets/db";
    if (!kIsWeb) {
      path =
          await getApplicationDocumentsDirectory().then((value) => value.path);
    }
    Hive.registerAdapter(BrandHAdapter());
    Hive.init(path);
    BrandBox.brandBox = await Hive.openBox("brands");
  }

  loadBrand(List<QueryDocumentSnapshot<Map<String, dynamic>>> data) {
    var list = brandBox!.keys;
    for (var doc in data) {
      if (!list.contains(doc.id)) {
        brandBox!.put(doc.id, {"brand": doc["brand"], "uid": doc.id});
      }
    }
  }
}

class CategoriesBox {
  static final instance = CategoriesBox();
  static Box? categoriesBox;

  initBox() async {
    String path = "/assets/db";
    if (!kIsWeb) {
      path =
          await getApplicationDocumentsDirectory().then((value) => value.path);
    }
    Hive.registerAdapter(CategorieHAdapter());
    Hive.init(path);
    CategoriesBox.categoriesBox = await Hive.openBox("categories");
  }

  loadCategorie(List<QueryDocumentSnapshot<Map<String, dynamic>>> data) {
    var list = categoriesBox!.keys;
    for (var doc in data) {
      if (!list.contains(doc.id)) {
        categoriesBox!
            .put(doc.id, {"categorie": doc["categorie"], "uid": doc.id});
      }
    }
  }
}

class DescriptionBox {
  static final instance = DescriptionBox();
  static Box? descriptionBox;

  initBox() async {
    String path = "/assets/db";
    if (!kIsWeb) {
      path =
          await getApplicationDocumentsDirectory().then((value) => value.path);
    }
    Hive.registerAdapter(DescriptionHAdapter());
    Hive.init(path);
    DescriptionBox.descriptionBox = await Hive.openBox("description");
  }

  loadDescription(List<QueryDocumentSnapshot<Map<String, dynamic>>> data) {
    var list = descriptionBox!.keys;
    for (var doc in data) {
      if (!list.contains(doc.id)) {
        descriptionBox!
            .put(doc.id, {"description": doc["description"], "uid": doc.id});
      }
    }
  }
}

class ModelBox {
  static final instance = ModelBox();
  static Box? modelBox;

  initBox() async {
    String path = "/assets/db";
    if (!kIsWeb) {
      path =
          await getApplicationDocumentsDirectory().then((value) => value.path);
    }
    Hive.registerAdapter(ModelHAdapter());
    Hive.init(path);
    ModelBox.modelBox = await Hive.openBox("model");
  }

  loadModel(List<QueryDocumentSnapshot<Map<String, dynamic>>> data) {
    var list = modelBox!.keys;
    for (var doc in data) {
      if (!list.contains(doc.id)) {
        modelBox!.put(doc.id, {"model": doc["model"], "uid": doc.id});
      }
    }
  }
}

class PartBox {
  static final instance = PartBox();
  static Box? partBox;

  initBox() async {
    String path = "/assets/db";
    if (!kIsWeb) {
      path =
          await getApplicationDocumentsDirectory().then((value) => value.path);
    }
    Hive.registerAdapter(PartHAdapter());
    Hive.init(path);
    partBox = await Hive.openBox("parts");
  }

  loadPart(List<QueryDocumentSnapshot<Map<String, dynamic>>> data) {
    var list = partBox!.keys;
    for (var doc in data) {
      if (!list.contains(doc.id)) {
        partBox!.put(doc.id, {"part": doc["part"], "uid": doc.id});
      }
    }
  }
}

class MissingBox {
  static final instance = MissingBox();
  static Box? missingBox;

  initBox() async {
    String path = "/assets/db";
    if (!kIsWeb) {
      path =
          await getApplicationDocumentsDirectory().then((value) => value.path);
    }
    Hive.registerAdapter(MissingHAdapter());
    Hive.init(path);
    MissingBox.missingBox = await Hive.openBox("missing");
  }

  loadMissing(List<QueryDocumentSnapshot<Map<String, dynamic>>> data) {
    var list = missingBox!.keys;
    for (var doc in data) {
      if (!list.contains(doc.id)) {
        missingBox!.put(doc.id,
            {"model": doc["model"], "part": doc["part"], "uid": doc.id});
      }
    }
  }
}

class CurrentUserBox {
  static final instance = CurrentUser();
  static Box? currentUserBox;
  initBox() async {
    String path = "/assets/db";
    if (!kIsWeb) {
      path =
          await getApplicationDocumentsDirectory().then((value) => value.path);
    }
    Hive.registerAdapter(CurrentUserAdapter());
    Hive.init(path);
    CurrentUserBox.currentUserBox = await Hive.openBox("currentUser");
  }

  loadUser(DocumentSnapshot<Map<String, dynamic>> doc) async {
    await Hive.box("currentUser").put(doc.id, {
      "warning": doc["url"],
      "adress": doc["adress"],
      "code": doc["code"],
      "fax": doc["fax"],
      "name": doc["name"],
      "phone": doc["phone"],
      "siret": doc["siret"],
      "tva": doc["tva"],
      "uid": doc.id,
      "path": "",
      "url": doc["url"],
      "invoiceType": doc["invoiceType"],
      "defaultData": false
    });
  }
}
