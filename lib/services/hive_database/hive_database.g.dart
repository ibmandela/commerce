// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_database.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivitiesHAdapter extends TypeAdapter<ActivitiesH> {
  @override
  final int typeId = 0;

  @override
  ActivitiesH read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivitiesH()
      ..activityList = (fields[0] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, String>())
          ?.toList()
      ..costumerName = fields[1] as String?
      ..phone = fields[2] as String?
      ..costumerAdress = fields[3] as String?
      ..discount = fields[4] as String?
      ..payWay = fields[5] as String?
      ..ticketNumber = fields[6] as String?
      ..date = fields[7] as DateTime?
      ..isEstimate = fields[8] as bool?
      ..total = fields[9] as double?
      ..uid = fields[10] as String?;
  }

  @override
  void write(BinaryWriter writer, ActivitiesH obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.activityList)
      ..writeByte(1)
      ..write(obj.costumerName)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.costumerAdress)
      ..writeByte(4)
      ..write(obj.discount)
      ..writeByte(5)
      ..write(obj.payWay)
      ..writeByte(6)
      ..write(obj.ticketNumber)
      ..writeByte(7)
      ..write(obj.date)
      ..writeByte(8)
      ..write(obj.isEstimate)
      ..writeByte(9)
      ..write(obj.total)
      ..writeByte(10)
      ..write(obj.uid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivitiesHAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RepairesHAdapter extends TypeAdapter<RepairesH> {
  @override
  final int typeId = 1;

  @override
  RepairesH read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RepairesH()
      ..repairList = (fields[0] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, String>())
          ?.toList()
      ..costumerName = fields[1] as String?
      ..phone = fields[2] as String?
      ..costumerAdress = fields[3] as String?
      ..discount = fields[4] as String?
      ..accompte = fields[5] as String?
      ..emplacement = fields[6] as String?
      ..state = fields[7] as String?
      ..ticketNumber = fields[8] as String?
      ..date = fields[9] as DateTime?
      ..total = fields[10] as double?
      ..uid = fields[11] as String?;
  }

  @override
  void write(BinaryWriter writer, RepairesH obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.repairList)
      ..writeByte(1)
      ..write(obj.costumerName)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.costumerAdress)
      ..writeByte(4)
      ..write(obj.discount)
      ..writeByte(5)
      ..write(obj.accompte)
      ..writeByte(6)
      ..write(obj.emplacement)
      ..writeByte(7)
      ..write(obj.state)
      ..writeByte(8)
      ..write(obj.ticketNumber)
      ..writeByte(9)
      ..write(obj.date)
      ..writeByte(10)
      ..write(obj.total)
      ..writeByte(11)
      ..write(obj.uid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepairesHAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DebtOrRefundHAdapter extends TypeAdapter<DebtOrRefundH> {
  @override
  final int typeId = 2;

  @override
  DebtOrRefundH read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DebtOrRefundH()
      ..date = fields[0] as String?
      ..debt = fields[1] as String?
      ..description = fields[2] as String?
      ..name = fields[3] as String?
      ..number = fields[4] as String?
      ..refund = fields[5] as String?
      ..uid = fields[6] as String?;
  }

  @override
  void write(BinaryWriter writer, DebtOrRefundH obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.debt)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.number)
      ..writeByte(5)
      ..write(obj.refund)
      ..writeByte(6)
      ..write(obj.uid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DebtOrRefundHAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StockHAdapter extends TypeAdapter<StockH> {
  @override
  final int typeId = 3;

  @override
  StockH read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StockH()
      ..part = fields[0] as String?
      ..model = fields[1] as String?
      ..emplacement = fields[2] as String?
      ..price = fields[3] as String?
      ..quantity = fields[4] as int?
      ..uid = fields[5] as String?;
  }

  @override
  void write(BinaryWriter writer, StockH obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.part)
      ..writeByte(1)
      ..write(obj.model)
      ..writeByte(2)
      ..write(obj.emplacement)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.uid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockHAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ArticleHAdapter extends TypeAdapter<ArticleH> {
  @override
  final int typeId = 4;

  @override
  ArticleH read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ArticleH()
      ..article = fields[0] as String?
      ..categorie = fields[1] as String?
      ..price = fields[2] as String?
      ..uid = fields[3] as String?;
  }

  @override
  void write(BinaryWriter writer, ArticleH obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.article)
      ..writeByte(1)
      ..write(obj.categorie)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.uid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArticleHAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CostumerHAdapter extends TypeAdapter<CostumerH> {
  @override
  final int typeId = 5;

  @override
  CostumerH read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CostumerH()
      ..name = fields[0] as String?
      ..phone = fields[1] as String?
      ..adress = fields[2] as String?
      ..uid = fields[3] as String?;
  }

  @override
  void write(BinaryWriter writer, CostumerH obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.phone)
      ..writeByte(2)
      ..write(obj.adress)
      ..writeByte(3)
      ..write(obj.uid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CostumerHAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BrandHAdapter extends TypeAdapter<BrandH> {
  @override
  final int typeId = 6;

  @override
  BrandH read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BrandH()
      ..brand = fields[0] as String?
      ..uid = fields[1] as String?;
  }

  @override
  void write(BinaryWriter writer, BrandH obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.brand)
      ..writeByte(1)
      ..write(obj.uid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrandHAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategorieHAdapter extends TypeAdapter<CategorieH> {
  @override
  final int typeId = 7;

  @override
  CategorieH read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategorieH()
      ..categorie = fields[0] as String?
      ..uid = fields[1] as String?;
  }

  @override
  void write(BinaryWriter writer, CategorieH obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.categorie)
      ..writeByte(1)
      ..write(obj.uid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategorieHAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DescriptionHAdapter extends TypeAdapter<DescriptionH> {
  @override
  final int typeId = 8;

  @override
  DescriptionH read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DescriptionH()
      ..description = fields[0] as String?
      ..uid = fields[1] as String?;
  }

  @override
  void write(BinaryWriter writer, DescriptionH obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.description)
      ..writeByte(1)
      ..write(obj.uid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DescriptionHAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ModelHAdapter extends TypeAdapter<ModelH> {
  @override
  final int typeId = 9;

  @override
  ModelH read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelH()
      ..model = fields[0] as String?
      ..uid = fields[1] as String?;
  }

  @override
  void write(BinaryWriter writer, ModelH obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.model)
      ..writeByte(1)
      ..write(obj.uid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelHAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PartHAdapter extends TypeAdapter<PartH> {
  @override
  final int typeId = 10;

  @override
  PartH read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PartH()
      ..part = fields[0] as String?
      ..uid = fields[1] as String?;
  }

  @override
  void write(BinaryWriter writer, PartH obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.part)
      ..writeByte(1)
      ..write(obj.uid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartHAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MissingHAdapter extends TypeAdapter<MissingH> {
  @override
  final int typeId = 11;

  @override
  MissingH read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MissingH()
      ..model = fields[0] as String?
      ..part = fields[1] as String?
      ..uid = fields[2] as String?;
  }

  @override
  void write(BinaryWriter writer, MissingH obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.model)
      ..writeByte(1)
      ..write(obj.part)
      ..writeByte(2)
      ..write(obj.uid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MissingHAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CurrentUserAdapter extends TypeAdapter<CurrentUser> {
  @override
  final int typeId = 12;

  @override
  CurrentUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurrentUser()
      ..name = fields[0] as String?
      ..phone = fields[1] as String?
      ..fax = fields[2] as String?
      ..adress = fields[3] as String?
      ..code = fields[4] as String?
      ..siret = fields[5] as String?
      ..tva = fields[6] as String?
      ..path = fields[7] as String?
      ..invoiceType = fields[8] as String?
      ..uid = fields[9] as String?
      ..warning = fields[10] as String?
      ..defaultData = fields[11] as bool?;
  }

  @override
  void write(BinaryWriter writer, CurrentUser obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.phone)
      ..writeByte(2)
      ..write(obj.fax)
      ..writeByte(3)
      ..write(obj.adress)
      ..writeByte(4)
      ..write(obj.code)
      ..writeByte(5)
      ..write(obj.siret)
      ..writeByte(6)
      ..write(obj.tva)
      ..writeByte(7)
      ..write(obj.path)
      ..writeByte(8)
      ..write(obj.invoiceType)
      ..writeByte(9)
      ..write(obj.uid)
      ..writeByte(10)
      ..write(obj.warning)
      ..writeByte(11)
      ..write(obj.defaultData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrentUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
