class AppUser {
  final String? uid;
  AppUser({this.uid});
}

class Product {
  String? categorie, article, price, uid;
  Product(
      {required this.article,
      required this.price,
      required this.categorie,
      required this.uid});
}

class Categorie {
  String? categorie, uid;
  Categorie({required this.uid, required this.categorie});
}

class Description {
  String? description, uid;
  Description({required this.uid, required this.description});
}

class Article {
  String? article, quantity, price, description;
  Article({this.article, this.price, this.quantity, this.description});
  Map<String, dynamic> toJson() {
    return {
      "article": article,
      "quantity": quantity,
      "price": price,
      "description": description,
    };
  }
}

class Repair {
  String? part, model, price, description;
  Repair({
    this.part,
    this.price,
    this.model,
    this.description,
  });
  Map<String, dynamic> toJson() {
    return {
      "part": part,
      "model": model,
      "price": price,
      "description": description,
    };
  }

  Repair fromJson() {
    return Repair(
        part: "part",
        model: "model",
        price: "price",
        description: "description");
  }
}

class Part {
  final String part, uid;
  Part({required this.part, required this.uid});
}

class Model {
  String? model, uid;
  Model({required this.model, required this.uid});
}

class Brand {
  String? brand, uid;
  Brand({required this.brand, required this.uid});
}

class Stock {
  final String? uid, part, model, emplacement, price;
  final int? quantity;
  const Stock(
      {required this.uid,
      required this.emplacement,
      required this.model,
      required this.part,
      required this.price,
      required this.quantity});
}

class Costumer {
  final String? uid, name, phone, adress;
  const Costumer({
    required this.uid,
    required this.name,
    required this.phone,
    required this.adress,
  });
}

class Activity {
  final String? activityUid,
      ticketNumber,
      phone,
      costumerName,
      discount,
      payWay,
      costumerAdress;
  final List activityList;
  final bool isEstimate;
  final DateTime ticketDate;
  final double total;

  const Activity(
      {required this.activityUid,
      required this.ticketNumber,
      required this.ticketDate,
      required this.phone,
      required this.costumerName,
      required this.costumerAdress,
      required this.discount,
      required this.payWay,
      required this.total,
      required this.isEstimate,
      required this.activityList});
}

class RepairActivity {
  final String? repairUid,
      ticketNumber,
      phone,
      costumerName,
      costumerAdress,
      accompte,
      discount,
      state,
      emplacement;
  final DateTime date;
  final double total;
  final List repairList;
  const RepairActivity(
      {required this.repairUid,
      required this.ticketNumber,
      required this.date,
      required this.phone,
      required this.costumerName,
      required this.costumerAdress,
      required this.discount,
      required this.accompte,
      required this.total,
      required this.state,
      required this.emplacement,
      required this.repairList});
}

class DebtOrRefund {
  String? uid, date, debt, description, name, number, refund;
  DebtOrRefund(
      {required this.date,
      required this.debt,
      required this.description,
      required this.name,
      required this.number,
      required this.refund,
      required this.uid});
}
