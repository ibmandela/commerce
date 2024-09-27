import 'package:hive/hive.dart';
part 'hive_database.g.dart';

@HiveType(typeId: 0)
class ActivitiesH {
  @HiveField(0)
  List<Map<String, String>>? activityList;
  @HiveField(1)
  String? costumerName;
  @HiveField(2)
  String? phone;
  @HiveField(3)
  String? costumerAdress;
  @HiveField(4)
  String? discount;
  @HiveField(5)
  String? payWay;
  @HiveField(6)
  String? ticketNumber;
  @HiveField(7)
  DateTime? date;
  @HiveField(8)
  bool? isEstimate;
  @HiveField(9)
  double? total;
  @HiveField(10)
  String? uid;
}

@HiveType(typeId: 1)
class RepairesH {
  @HiveField(0)
  List<Map<String, String>>? repairList;
  @HiveField(1)
  String? costumerName;
  @HiveField(2)
  String? phone;
  @HiveField(3)
  String? costumerAdress;
  @HiveField(4)
  String? discount;
  @HiveField(5)
  String? accompte;
  @HiveField(6)
  String? emplacement;
  @HiveField(7)
  String? state;
  @HiveField(8)
  String? ticketNumber;
  @HiveField(9)
  DateTime? date;
  @HiveField(10)
  double? total;
  @HiveField(11)
  String? uid;
}

@HiveType(typeId: 2)
class DebtOrRefundH {
  @HiveField(0)
  String? date;
  @HiveField(1)
  String? debt;
  @HiveField(2)
  String? description;
  @HiveField(3)
  String? name;
  @HiveField(4)
  String? number;
  @HiveField(5)
  String? refund;
  @HiveField(6)
  String? uid;
}

@HiveType(typeId: 3)
class StockH {
  @HiveField(0)
  String? part;
  @HiveField(1)
  String? model;
  @HiveField(2)
  String? emplacement;
  @HiveField(3)
  String? price;
  @HiveField(4)
  int? quantity;
  @HiveField(5)
  String? uid;
}

@HiveType(typeId: 4)
class ArticleH {
  @HiveField(0)
  String? article;
  @HiveField(1)
  String? categorie;
  @HiveField(2)
  String? price;
  @HiveField(3)
  String? uid;
}

@HiveType(typeId: 5)
class CostumerH {
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? phone;
  @HiveField(2)
  String? adress;
  @HiveField(3)
  String? uid;
}

@HiveType(typeId: 6)
class BrandH {
  @HiveField(0)
  String? brand;
  @HiveField(1)
  String? uid;
}

@HiveType(typeId: 7)
class CategorieH {
  @HiveField(0)
  String? categorie;
  @HiveField(1)
  String? uid;
}

@HiveType(typeId: 8)
class DescriptionH {
  @HiveField(0)
  String? description;
  @HiveField(1)
  String? uid;
}

@HiveType(typeId: 9)
class ModelH {
  @HiveField(0)
  String? model;
  @HiveField(1)
  String? uid;
}

@HiveType(typeId: 10)
class PartH {
  @HiveField(0)
  String? part;
  @HiveField(1)
  String? uid;
}

@HiveType(typeId: 11)
class MissingH {
  @HiveField(0)
  String? model;
  @HiveField(1)
  String? part;
  @HiveField(2)
  String? uid;
}

@HiveType(typeId: 12)
class CurrentUser {
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? phone;
  @HiveField(2)
  String? fax;
  @HiveField(3)
  String? adress;
  @HiveField(4)
  String? code;
  @HiveField(5)
  String? siret;
  @HiveField(6)
  String? tva;
  @HiveField(7)
  String? path;
  @HiveField(8)
  String? invoiceType;
  @HiveField(9)
  String? uid;
  @HiveField(10)
  String? warning;
  @HiveField(11)
  bool? defaultData;
}
