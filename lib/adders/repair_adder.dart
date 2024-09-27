import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:gestion_commerce_reparation/adders/brand_adder.dart';
import 'package:gestion_commerce_reparation/adders/descripion_adder.dart';
import 'package:gestion_commerce_reparation/adders/part_adder.dart';
import 'package:gestion_commerce_reparation/adders/quick_sell.dart';
import 'package:gestion_commerce_reparation/adders/stock_adder.dart';
import 'package:gestion_commerce_reparation/common/constant.dart';
import 'package:gestion_commerce_reparation/modeles/user.dart';
import 'package:gestion_commerce_reparation/services/bluetooth_printer.dart';
import 'package:gestion_commerce_reparation/services/firebase/company_database.dart';
import 'package:gestion_commerce_reparation/services/costumer_class.dart';
import 'package:gestion_commerce_reparation/services/hive_database/boxes.dart';
import 'package:gestion_commerce_reparation/services/print_service.dart';
import 'package:gestion_commerce_reparation/viewer.dart/activity.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:printing/printing.dart';

class RepairAdderPage extends StatelessWidget {
  final String? repairUid,
      costumerName,
      costumerPhone,
      costumerAdress,
      discount,
      accompte,
      emplacement,
      state,
      ticketNumber;
  final List<Repair>? repairList;
  final double? total;
  final DateTime? date;
  const RepairAdderPage(
      {this.repairUid,
      this.costumerAdress,
      this.costumerName,
      this.costumerPhone,
      this.total,
      this.state,
      this.emplacement,
      this.accompte,
      this.discount,
      this.date,
      this.ticketNumber,
      this.repairList,
      super.key});

  @override
  Widget build(BuildContext context) {
    return RepairAdder(
      emaplacement: emplacement,
      discount: discount,
      date: date,
      ticketNumber: ticketNumber,
      state: state,
      accompte: accompte,
      costumerAdress: costumerAdress,
      costumerName: costumerName,
      costumerPhone: costumerPhone,
      repairUid: repairUid,
      repairList: repairList,
    );
  }
}

class RepairAdder extends StatefulWidget {
  final String? repairUid,
      costumerName,
      costumerPhone,
      costumerAdress,
      accompte,
      discount,
      state,
      ticketNumber,
      emaplacement;

  final List<Repair>? repairList;
  final DateTime? date;
  const RepairAdder(
      {this.repairUid,
      this.costumerAdress,
      this.costumerName,
      this.costumerPhone,
      this.accompte,
      this.date,
      this.discount,
      this.repairList,
      this.state,
      this.ticketNumber,
      this.emaplacement,
      super.key});

  @override
  State<RepairAdder> createState() => _RepairAdderState();
}

class _RepairAdderState extends State<RepairAdder> {
  final _nameControler = TextEditingController();
  final _adressControler = TextEditingController();
  final _phoneControler = TextEditingController();
  final _priceControler = TextEditingController();
  final _discountControler = TextEditingController();
  final _descriptionContoler = TextEditingController();
  final _accompteControler = TextEditingController();
  final _descriptionControler = TextEditingController();
  final _partControler = TextEditingController();
  final _modelControler = TextEditingController();
  final _costumerFormKey = GlobalKey<FormState>();

  final spaceDown = const SizedBox(
    height: 3,
  );

  final _ticketDate = DateFormat('ddMMyy').format(DateTime.now());
  final _randomNumber = Random().nextInt(100);
  final _oneDay = DateTime.now().subtract(const Duration(days: 1));
  var _date = DateTime.now();

  String? _part;
  String? _model;
  int? _quantity = 0;
  String? _emplacement;
  String? _searchPhone;
  String? _ticketNumber;

  bool _phoneIsNull = false;
  bool _chooseCostumer = false;
  bool _addDiscount = false;
  bool _chooseBrand = false;

  List<Repair> _repairs = [];
  List<Stock> stocks = [];
  List<Part> parts = [];
  final List<String> _descriptions = [];

  var bluetooth = BlueThermalPrinter.instance;

  @override
  void dispose() {
    _nameControler.dispose();
    _adressControler.dispose();
    _phoneControler.dispose();
    _priceControler.dispose();
    _accompteControler.dispose();
    _discountControler.dispose();
    _descriptionControler.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.initState();
    if (widget.repairUid != null) {
      _repairs = widget.repairList ?? [];
      _ticketNumber = widget.ticketNumber;
      _date = widget.date ?? DateTime.now();
      _discountControler.text = widget.discount ?? '';
      _accompteControler.text = widget.accompte ?? '';
      _nameControler.text = '${widget.costumerName}';
      _phoneControler.text = '${widget.costumerPhone}';
      _adressControler.text = '${widget.costumerAdress}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: MediaQuery.of(context).size.height < 600
              ? const Size.fromHeight(40)
              : const Size.fromHeight(60),
          child: AppBar(
            title: Row(children: [
              Expanded(child: _buildPart()),
              Expanded(flex: 2, child: _buildModel()),
              Expanded(child: _buildPrice()),
              _buildAddTocart()
            ]),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const QuickSellPage()))
                        .then((value) => Navigator.pop(context));
                  },
                  icon: const Icon(Icons.computer_rounded)),
              IconButton(
                icon: const Icon(Icons.person_add_rounded),
                onPressed: () {
                  setState(() {
                    _chooseCostumer = !_chooseCostumer;
                  });
                },
              )
            ],
          )),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                    flex: MediaQuery.of(context).size.height > 600 ? 3 : 2,
                    child:
                        !_chooseBrand ? _buildPartGrid() : _buildBrandGrid()),
                Expanded(flex: 2, child: _buildBouttons())
              ],
            ),
          ),
          Expanded(
            flex: MediaQuery.of(context).size.height > 600 ? 3 : 2,
            child: Row(
              children: [
                Expanded(flex: 3, child: _buildStockGrid()),
                _chooseCostumer
                    ? Expanded(flex: 2, child: _buildCostumer())
                    : _repairs.isNotEmpty
                        ? Expanded(flex: 2, child: _buildOrder())
                        : Expanded(flex: 2, child: _buildActivityList())
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildStockGrid() {
    return ValueListenableBuilder<Box<dynamic>>(
        valueListenable: StockBox.stockBox!.listenable(),
        builder: (context, box, widget1) {
          stocks = box.values
              .map((stock) => Stock(
                  uid: stock["uid"],
                  emplacement: stock["emplacement"],
                  model: stock["model"],
                  part: stock["part"],
                  price: stock["price"],
                  quantity: stock["quantity"]))
              .toList();
          var data =
              _part != null || _part == "" || _model != null || _model == ""
                  ? box.values
                      .map((stock) => Stock(
                          uid: stock["uid"],
                          emplacement: stock["emplacement"],
                          model: stock["model"],
                          part: stock["part"],
                          price: stock["price"],
                          quantity: stock["quantity"]))
                      .where(
                        (element) => _model != null
                            ? _part == null
                                ? element.model!
                                    .toUpperCase()
                                    .contains(_model!.toUpperCase())
                                : (element.part!.toUpperCase() ==
                                        _part!.toUpperCase() &&
                                    element.model!
                                        .toUpperCase()
                                        .contains(_model!.toUpperCase()))
                            : element.part!
                                .toUpperCase()
                                .contains(_part!.toUpperCase()),
                      )
                      .toList()
                  : box.values
                      .map((stock) => Stock(
                          uid: stock["uid"],
                          emplacement: stock["emplacement"],
                          model: stock["model"],
                          part: stock["part"],
                          price: stock["price"],
                          quantity: stock["quantity"]))
                      .toList();
          return Stack(
            children: [
              Container(
                  decoration: boxdecoration.copyWith(
                      border: Border.all(
                          color: Colors.blue,
                          width: MediaQuery.of(context).size.height > 600
                              ? 4
                              : 2)),
                  child: GridView.builder(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.height > 600 ? 5 : 0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              MediaQuery.of(context).size.height > 600 ? 6 : 4,
                          childAspectRatio: 2),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return GridTile(
                            child: InkWell(
                                onLongPress: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => StockAdderPage(
                                                emplacement:
                                                    data[index].emplacement,
                                                quantity: data[index]
                                                    .quantity
                                                    .toString(),
                                                model: data[index].model,
                                                price: data[index].price,
                                                stockUid: data[index].uid,
                                                part: data[index].part,
                                              )));
                                },
                                onTap: () {
                                  _part = null;

                                  setState(() {
                                    _emplacement = '${data[index].emplacement}';
                                    _quantity = data[index].quantity;
                                    _partControler.text = '${data[index].part}';
                                    _modelControler.text =
                                        '${data[index].model}';
                                    _priceControler.text =
                                        '${data[index].price}';

                                    _repairs.add(Repair(
                                        price: data[index].price,
                                        part: data[index].part,
                                        model: data[index].model,
                                        description: ''));
                                  });
                                },
                                child: _buidCard(Colors.white, Colors.blue,
                                    '${data[index].part}\n${data[index].model}\n${NumberFormat.currency(locale: 'fr', symbol: '€').format(double.parse('${data[index].price}'))}')));
                      })),
              if (MediaQuery.of(context).size.height > 600)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      heroTag: "repairBtn1",
                      backgroundColor:
                          _part != null ? Colors.blue : Colors.grey,
                      child: const Icon(
                        Icons.add,
                      ),
                      onPressed: () {
                        if (_part != null) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StockAdderPage(
                                        brand: _model,
                                        part: _part,
                                      )));
                        }
                      },
                    ),
                  ),
                )
            ],
          );
        });
  }

  _buildPartGrid() {
    return ValueListenableBuilder<Box<dynamic>>(
        valueListenable: PartBox.partBox!.listenable(),
        builder: (context, box, widget1) {
          parts = box.values
              .map((part) => Part(part: part["part"], uid: part["uid"]))
              .toList();
          var partData = _part == null
              ? box.values
                  .map((part) => Part(part: part["part"], uid: part["uid"]))
                  .toList()
              : box.values
                  .where((part) => part["part"].contains(_part!.toUpperCase()))
                  .map((part) => Part(part: part["part"], uid: part["uid"]))
                  .toList();
          return Stack(
            children: [
              SizedBox(
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              MediaQuery.of(context).size.height > 600 ? 6 : 4,
                          childAspectRatio: 2.5),
                      itemCount: partData.length,
                      itemBuilder: (context, index) {
                        return GridTile(
                            child: InkWell(
                                onLongPress: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PartAdderPage(
                                                partUid: partData[index].uid,
                                                part: partData[index].part,
                                              )));
                                },
                                onTap: () {
                                  setState(() {
                                    _chooseBrand = true;
                                    _model = null;
                                    _part = partData[index].part;
                                    _partControler.text = partData[index].part;
                                  });
                                },
                                child: _buidCard(Colors.blue, Colors.white,
                                    partData[index].part)));
                      })),
              if (MediaQuery.of(context).size.height > 600)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      heroTag: "repairBtn2",
                      child: const Icon(Icons.add),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PartAdderPage()));
                      },
                    ),
                  ),
                )
            ],
          );
        });
  }

  _buildBrandGrid() {
    return ValueListenableBuilder<Box<dynamic>>(
        valueListenable: BrandBox.brandBox!.listenable(),
        builder: (context, box, widget1) {
          var brandData = box.values
              .map((brand) => Brand(brand: brand["brand"], uid: brand["uid"]))
              .toList();
          return Stack(
            children: [
              brandData.isEmpty
                  ? Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _chooseBrand = false;
                          });
                        },
                        child: const Text(
                            "Aucune marque appuyer sur + pour en rajouter ou ici pour annuler"),
                      ),
                    )
                  : SizedBox(
                      child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 6, childAspectRatio: 2.5),
                          itemCount: brandData.length,
                          itemBuilder: (context, index) {
                            return GridTile(
                                child: InkWell(
                                    onLongPress: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BrandAdderPage(
                                                    brandUid:
                                                        brandData[index].uid,
                                                    brand:
                                                        brandData[index].brand,
                                                  )));
                                    },
                                    onTap: () {
                                      setState(() {
                                        _part = null;
                                        _chooseBrand = false;
                                        _modelControler.text =
                                            '${brandData[index].brand}';
                                        _model = '${brandData[index].brand}';
                                      });
                                    },
                                    child: _buidCard(Colors.white, Colors.green,
                                        brandData[index].brand)));
                          })),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    heroTag: "repairBtn3",
                    child: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BrandAdderPage()));
                    },
                  ),
                ),
              )
            ],
          );
        });
  }

  _buildOrder() {
    double total = _repairs.fold(
        0.0,
        (previousValue, element) =>
            previousValue + double.parse('${element.price}'));
    return SizedBox(
      child: Column(
        children: [
          Expanded(
              child: Text('Ticket : $_ticketDate$_randomNumber',
                  style: titleStyle.copyWith(
                      fontSize:
                          MediaQuery.of(context).size.height > 600 ? 20 : 10))),
          if (MediaQuery.of(context).size.height > 600)
            const SizedBox(
              height: 30,
            ),
          Expanded(
            flex: 6,
            child: ListView.builder(
                itemCount: _repairs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            MediaQuery.of(context).size.height > 600 ? 8.0 : 5,
                        vertical:
                            MediaQuery.of(context).size.height > 600 ? 5 : 0),
                    child: GestureDetector(
                      onLongPress: () =>
                          _deleteRepairAlerteDialog(_repairs[index]),
                      child: Column(children: [
                        Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.height > 600 ? 0 : 7),
                          child: Row(children: [
                            Expanded(
                                flex: 6,
                                child: Text(
                                  '${_repairs[index].part}  ${_repairs[index].model}',
                                  style: listItem.copyWith(
                                      fontSize:
                                          MediaQuery.of(context).size.height >
                                                  600
                                              ? 14
                                              : 7),
                                )),
                            Expanded(
                                flex: 2,
                                child: Text('${_repairs[index].price}€',
                                    style: listItem.copyWith(
                                        fontSize:
                                            MediaQuery.of(context).size.height >
                                                    600
                                                ? 14
                                                : 7)))
                          ]),
                        ),
                        if (_repairs[index].description != '')
                          Text('${_repairs[index].description}')
                      ]),
                    ),
                  );
                }),
          ),
          if (MediaQuery.of(context).size.height > 600)
            Expanded(
              child: Container(
                decoration: boxdecoration,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1),
                  child: Text(
                    'Nombre de réparation : ${_repairs.length}    Total : $total€',
                    style: subtitle,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  _buildActivityList() {
    return ValueListenableBuilder<Box>(
        valueListenable: RepairBox.repairBox!.listenable(),
        builder: (context, box, child) {
          var data = box.values
              .where((repair) => repair["date"].isAfter(_oneDay))
              .map((repair) => RepairActivity(
                  repairUid: repair["uid"],
                  ticketNumber: repair["ticketNumber"],
                  date: repair["date"],
                  phone: repair["phone"],
                  costumerName: repair["costumerName"],
                  costumerAdress: repair["costumerAdress"],
                  discount: repair["discount"],
                  accompte: repair["accompte"],
                  total: repair["total"],
                  state: repair["state"],
                  emplacement: repair["emplacement"],
                  repairList: repair["repairList"]))
              .toList();
          data.sort((a, b) => b.date.compareTo(a.date));

          double totalRepair = data.fold(
              0.0, (previousValue, element) => previousValue + element.total);
          return SizedBox(
            child: Column(children: [
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Reparations du jour',
                    style: titleStyle.copyWith(
                        fontSize:
                            MediaQuery.of(context).size.height > 600 ? 20 : 10),
                  ),
                  if (MediaQuery.of(context).size.height > 600)
                    const SizedBox(
                      width: 20,
                    ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ActivityPage(
                                      isCostumerView: false,
                                    )));
                      },
                      child: Text("Voir tous",
                          style: subtitle.copyWith(
                              fontSize: MediaQuery.of(context).size.height > 600
                                  ? 15
                                  : 9)))
                ],
              )),
              Expanded(
                  flex: 6,
                  child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return _buildExpansionTile(
                            data[index].repairList,
                            data[index].repairUid,
                            data[index].ticketNumber,
                            data[index].total,
                            data[index].date,
                            data[index].costumerName,
                            data[index].costumerAdress,
                            data[index].phone,
                            data[index].discount,
                            data[index].accompte,
                            data[index].emplacement,
                            data[index].state);
                      })),
              if (MediaQuery.of(context).size.height > 600)
                Expanded(
                  child: Container(
                      decoration: boxdecoration,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'Total du jour : ${totalRepair.toString()}€',
                          style: titleStyle,
                        ),
                      )),
                )
            ]),
          );
        });
  }

  _buildCostumer() {
    return ValueListenableBuilder<Box<dynamic>>(
        valueListenable: CostumerBox.costumerBox!.listenable(),
        builder: (context, box, widget) {
          List<Costumer> data = _searchPhone != null
              ? box.values
                  .where(
                      (costumer) => costumer["phone"].contains('$_searchPhone'))
                  .map((costumer) => Costumer(
                      uid: costumer["uid"],
                      name: costumer["name"],
                      phone: costumer["phone"],
                      adress: costumer["adress"]))
                  .toList()
              : box.values
                  .map(((costumer) => Costumer(
                      uid: costumer["uid"],
                      name: costumer["name"],
                      phone: costumer["phone"],
                      adress: costumer["adress"])))
                  .toList();
          return _phoneIsNull
              ? _buildAddCostumer()
              : SizedBox(
                  child: Column(
                    children: [
                      Expanded(
                        child: Text(
                          'Repertoir client',
                          style: titleStyle.copyWith(
                              fontSize: MediaQuery.of(context).size.height > 600
                                  ? 20
                                  : 10),
                        ),
                      ),
                      Expanded(child: _buildPhone()),
                      Expanded(
                          flex: 6,
                          child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return Column(children: [
                                  ListTile(
                                    onTap: () {
                                      setState(() {
                                        _nameControler.text =
                                            '${data[index].name}';
                                        _phoneControler.text =
                                            '${data[index].phone}';
                                        _adressControler.text =
                                            '${data[index].adress}';
                                        _chooseCostumer = false;
                                      });
                                    },
                                    title: Text(
                                      '${data[index].name}',
                                      style: formTextStyle.copyWith(
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height >
                                                  600
                                              ? 17
                                              : 8),
                                    ),
                                    trailing: Text(
                                      '${data[index].phone}',
                                      style: formTextStyle.copyWith(
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height >
                                                  600
                                              ? 17
                                              : 8),
                                    ),
                                  ),
                                  const Divider(
                                    thickness: 1,
                                    height: 0,
                                  ),
                                ]);
                              })),
                    ],
                  ),
                );
        });
  }

  _buildAddCostumer() {
    return Card(
      child: Form(
          key: _costumerFormKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'Ajouter un nouveau Client',
                    style: titleStyle.copyWith(
                        fontSize:
                            MediaQuery.of(context).size.height > 600 ? 20 : 10),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height > 600 ? 10 : 2,
                  ),
                  _buildPhone(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height > 600 ? 10 : 2,
                  ),
                  _buildName(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height > 600 ? 10 : 2,
                  ),
                  _buildAdress(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height > 600 ? 20 : 4,
                  ),
                  _buildAddCostumerButton()
                ],
              ),
            ),
          )),
    );
  }

  Widget _buildPhone() {
    return SizedBox(
      height: MediaQuery.of(context).size.height > 600 ? 50 : 30,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextFormField(
          keyboardType: TextInputType.phone,
          autocorrect: false,
          decoration: textInputDecoration.copyWith(
              prefixIcon: MediaQuery.of(context).size.height > 600
                  ? const Icon(
                      Icons.phone,
                      color: Colors.blue,
                    )
                  : null,
              suffixIcon: MediaQuery.of(context).size.height > 600
                  ? TextButton(
                      onPressed: () {
                        setState(() {
                          _phoneIsNull = true;
                        });
                      },
                      child: Text(
                        'Ajouter',
                        style: formTextStyle.copyWith(
                            fontSize: MediaQuery.of(context).size.height > 600
                                ? 17
                                : 7),
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          _phoneIsNull = true;
                        });
                      },
                      icon: const Icon(
                        color: Colors.blue,
                        Icons.add,
                        size: 15,
                      )),
              label: Text(
                'Entrer un numéro',
                style: formTextStyle.copyWith(
                    fontSize:
                        MediaQuery.of(context).size.height > 600 ? 20 : 7),
              ),
              hintText: ' Entrer un numéro'),
          controller: _phoneControler,
          onChanged: (value) {
            setState(() {
              _searchPhone = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildName() {
    return SizedBox(
        height: MediaQuery.of(context).size.height > 600 ? 50 : 30,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextFormField(
            keyboardType: TextInputType.name,
            autocorrect: true,
            textCapitalization: TextCapitalization.words,
            decoration: textInputDecoration.copyWith(
                prefixIcon: const Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
                label: Text(
                  'Nom du Client',
                  style: formTextStyle.copyWith(
                      fontSize:
                          MediaQuery.of(context).size.height > 600 ? 20 : 7),
                ),
                hintText: 'Nom du client'),
            controller: _nameControler,
            validator: (value) {
              if (value == null || value.length < 2) {
                return "Cet nom est invalide";
              } else {
                return null;
              }
            },
          ),
        ));
  }

  Widget _buildAdress() {
    return SizedBox(
        height: MediaQuery.of(context).size.height > 600 ? 50 : 30,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextFormField(
            keyboardType: TextInputType.streetAddress,
            autocorrect: true,
            textCapitalization: TextCapitalization.words,
            decoration: textInputDecoration.copyWith(
                prefixIcon: const Icon(
                  Icons.home,
                  color: Colors.blue,
                ),
                label: Text(
                  "Adresse du client",
                  style: formTextStyle.copyWith(
                      fontSize:
                          MediaQuery.of(context).size.height > 600 ? 20 : 7),
                ),
                hintText: "Adresse du client"),
            controller: _adressControler,
            validator: (value) {
              if (value == null) {
                return null;
              }
              if (value.isNotEmpty && value.length < 2) {
                return "Entrez une adresse valide SVP";
              } else {
                return null;
              }
            },
          ),
        ));
  }

  Widget _buildModel() {
    return SizedBox(
        height: MediaQuery.of(context).size.height > 600 ? 50 : 30,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              keyboardType: TextInputType.name,
              autocorrect: true,
              textCapitalization: TextCapitalization.characters,
              decoration: textInputDecoration.copyWith(
                  label: Text(
                    'Modèle',
                    style: formTextStyle.copyWith(
                        fontSize:
                            MediaQuery.of(context).size.height > 600 ? 17 : 8),
                  ),
                  hintText: 'Modèle'),
              controller: _modelControler,
              onChanged: (value) {
                setState(() {
                  _model = value;
                });
              },
              validator: (value) {
                if (value == null || value.length < 2) {
                  return "Ce champ est invalide";
                } else {
                  return null;
                }
              },
            )));
  }

  Widget _buildPart() {
    return SizedBox(
        height: MediaQuery.of(context).size.height > 600 ? 50 : 30,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              keyboardType: TextInputType.name,
              autocorrect: true,
              textCapitalization: TextCapitalization.characters,
              decoration: textInputDecoration.copyWith(
                  label: Text(
                    'Pièce',
                    style: formTextStyle.copyWith(
                        fontSize:
                            MediaQuery.of(context).size.height > 600 ? 17 : 8),
                  ),
                  hintText: 'Pièce'),
              controller: _partControler,
              onChanged: (value) => setState(() {
                _part = value;
              }),
              validator: (value) {
                if (value == null || value.length < 2) {
                  return "Ce champ est invalide";
                } else {
                  return null;
                }
              },
            )));
  }

  Widget _buildDescription() {
    return TextFormField(
      keyboardType: TextInputType.name,
      autocorrect: true,
      onChanged: (value) {
        _repairs.last.description = value;
      },
      textCapitalization: TextCapitalization.characters,
      decoration: textInputDecoration.copyWith(
          label: const Text(
            'Descrption',
            style: formTextStyle,
          ),
          hintText: 'Description'),
      controller: _descriptionContoler,
    );
  }

  Widget _buildAccompt() {
    return TextFormField(
      keyboardType: TextInputType.number,
      autocorrect: false,
      decoration: textInputDecoration.copyWith(
          label: const Text(
            'Accompte',
            style: formTextStyle,
          ),
          hintText: 'Accompte'),
      controller: _accompteControler,
    );
  }

  Widget _buildDiscount() {
    return TextFormField(
      keyboardType: TextInputType.number,
      autocorrect: false,
      decoration: textInputDecoration.copyWith(
          label: const Text(
            'Réduction',
            style: formTextStyle,
          ),
          hintText: 'Réduction'),
      controller: _discountControler,
    );
  }

  Widget _buildPrice() {
    return SizedBox(
        height: MediaQuery.of(context).size.height > 600 ? 50 : 30,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              autocorrect: false,
              decoration: textInputDecoration.copyWith(
                  label: Text(
                    'Prix',
                    style: formTextStyle.copyWith(
                        fontSize:
                            MediaQuery.of(context).size.height > 600 ? 17 : 8),
                  ),
                  hintText: 'Prix'),
              controller: _priceControler,
            )));
  }

  _buildDate() {
    return Column(children: [
      Text(
        '${_date.day}/${_date.month}/${_date.year}',
        style: formTextStyle,
      ),
      ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: borderRaduis,
            padding: const EdgeInsets.symmetric(horizontal: 30),
          ),
          onPressed: () async {
            DateTime? newDate = await showDatePicker(
                context: context,
                initialDate: _date,
                firstDate: DateTime(1900),
                lastDate: DateTime(2100));
            if (newDate == null) return;
            setState(() {
              _date = newDate;
            });
          },
          child: Text(
            'Choisir une date',
            style: buttonText,
          ))
    ]);
  }

  _buildTextField() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                _addDiscount ? 'Accompte et Réduction' : 'Modififier la date',
                style: titleStyle,
              ),
              content: SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                child: _addDiscount
                    ? Column(children: [
                        Expanded(child: _buildDiscount()),
                        const SizedBox(
                          width: 2,
                        ),
                        Expanded(child: _buildAccompt())
                      ])
                    : Expanded(child: _buildDate()),
              ),
              actions: [_buildDoubleCancelButton(), _buildDoubleDoneButton()],
            ));
  }

  _buildBouttons() {
    return SizedBox(
        child: Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildDoneButton()),
              Expanded(child: _buildCancelButton()),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildPrintTicket()),
              // Expanded(
              //     child: Padding(
              //   padding: const EdgeInsets.all(4.0),
              //   child: _buildes(),
              // ))
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildDescriptionButton()),
              Expanded(child: _buildDiscountButton()),
              Expanded(child: _buildDateButton())
            ],
          ),
        )
      ],
    ));
  }

  Widget _buildDescriptionCancelButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        onPressed: () {
          setState(() {
            _descriptionContoler.clear();
            _descriptions.clear();
          });
          Navigator.pop(context);
        },
        child: Text(
          "Annuler",
          style: buttonText.copyWith(
              fontSize: MediaQuery.of(context).size.height > 600 ? 16 : 10),
        ));
  }

  Widget _buildDescriptionDoneButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        onPressed: () {
          setState(() {
            if (_descriptionContoler.value.text != '') {
              _repairs.last.description =
                  '${_descriptionContoler.value.text},${_descriptions.join(',')}';
            } else {
              _repairs.last.description = _descriptions.join(',');
            }
          });
          Navigator.pop(context);
        },
        child: Text(
          "Valider",
          style: buttonText.copyWith(
              fontSize: MediaQuery.of(context).size.height > 600 ? 16 : 10),
        ));
  }

  Widget _buildDoubleCancelButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        onPressed: () {
          setState(() {
            _addDiscount = false;
            _descriptionContoler.clear();
            _discountControler.clear();
            _accompteControler.clear();
          });
        },
        child: Text(
          "Annuler",
          style: buttonText.copyWith(
              fontSize: MediaQuery.of(context).size.height > 600 ? 16 : 10),
        ));
  }

  Widget _buildDoubleDoneButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        onPressed: () {
          setState(() {
            _addDiscount = false;
          });
          Navigator.pop(context);
        },
        child: Text(
          "Valider",
          style: buttonText.copyWith(
              fontSize: MediaQuery.of(context).size.height > 600 ? 16 : 10),
        ));
  }

  Widget _buildAddCostumerButton() {
    return ElevatedButton(
        onPressed: () {
          if (_costumerFormKey.currentState!.validate()) {
            setState(() {
              CostumerDatabase().addCostumer(
                  _nameControler.value.text,
                  _adressControler.value.text,
                  _phoneControler.value.text,
                  context);
              CostumerBox.costumerBox!.put(_phoneControler.value.text, {
                "name": _nameControler.value.text,
                "phone": _phoneControler.value.text,
                "adress": _adressControler.value.text,
                "uid": _phoneControler.value.text
              });
            });
          }
          _chooseCostumer = false;
          _phoneIsNull = false;
        },
        child: Text("Ajouter le contact",
            style: buttonText.copyWith(
                fontSize: MediaQuery.of(context).size.height > 600 ? 16 : 10)));
  }

  Widget _buildPrintTicket() {
    List<Repair> list = _repairs;
    String invoiceNumber = _ticketNumber ?? '$_ticketDate$_randomNumber';
    return kIsWeb || Platform.isWindows
        ? ElevatedButton(
            onPressed: () async {
              if (_repairs.isNotEmpty) {
                if (_phoneControler.value.text != '') {
                  setState(() {
                    _submitPrint(invoiceNumber, list);
                  });
                } else {
                  _showCostumerDialogue();
                }
              }
            },
            child: Text(
              "Ticket",
              style: buttonText.copyWith(
                  fontSize: MediaQuery.of(context).size.height > 600 ? 16 : 10),
            ))
        : FutureBuilder<bool?>(
            future: bluetooth.isConnected,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return snapshotError;
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return loader;
              }
              bool isConnected = snapshot.requireData ?? false;

              return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: _repairs.isNotEmpty && isConnected
                          ? Colors.blue
                          : Colors.red,
                      textStyle: textStyle),
                  onPressed: () {
                    if (isConnected) {
                      if (_repairs.isNotEmpty) {
                        if (_phoneControler.value.text != '') {
                          setState(() {
                            _submitPrint(invoiceNumber, list);
                          });
                        } else {
                          _showCostumerDialogue();
                        }
                      }
                    } else {
                      _showBluetoothAlertDialog();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BluetoothPrinter()));
                    }
                  },
                  child: Text(
                    isConnected ? "Ticket" : "aucune imprimante",
                    style: buttonText.copyWith(
                        fontSize:
                            MediaQuery.of(context).size.height > 600 ? 16 : 10),
                  ));
            });
  }

  Widget _buildDoneButton() {
    var invoiceNumber = _ticketNumber ?? '$_ticketDate$_randomNumber';
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _repairs.isNotEmpty ? Colors.blue : Colors.grey,
        ),
        onPressed: () {
          if (_repairs.isNotEmpty) {
            if (_phoneControler.value.text == '') {
              _showCostumerDialogue();
            } else {
              setState(() {
                _addToFireBase(invoiceNumber).then((value) {
                  _repairs.clear();
                  _phoneControler.clear();
                  _nameControler.clear();
                  _adressControler.clear();
                  _repairs.clear();
                  _discountControler.clear();
                  _accompteControler.clear();
                  _descriptionContoler.clear();
                  _date = DateTime.now();
                });
              });
            }
          }
        },
        child: Text("Valider",
            style: buttonText.copyWith(
                fontSize: MediaQuery.of(context).size.height > 600 ? 16 : 10)));
  }

  Widget _buildCancelButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _repairs.isNotEmpty ? Colors.red : Colors.grey,
        ),
        onPressed: () {
          if (_repairs.isNotEmpty) {
            setState(() {
              _repairs.clear();
              _phoneControler.clear();
              _nameControler.clear();
              _adressControler.clear();
              _repairs.clear();
              _discountControler.clear();
              _accompteControler.clear();
              _descriptionContoler.clear();
              _date = DateTime.now();
            });
          }
        },
        child: Text("Annuler",
            style: buttonText.copyWith(
                fontSize: MediaQuery.of(context).size.height > 600 ? 16 : 10)));
  }

  Widget _buildDiscountButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: _repairs.isNotEmpty ? Colors.blue : Colors.grey),
        onPressed: () {
          if (_repairs.isNotEmpty) {
            setState(() {
              _addDiscount = true;
              _buildTextField();
            });
          }
        },
        child: Text("Réduction",
            style: buttonText.copyWith(
                fontSize: MediaQuery.of(context).size.height > 600 ? 16 : 10)));
  }

  Widget _buildDescriptionButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: _repairs.isNotEmpty ? Colors.blue : Colors.grey),
        onPressed: () {
          if (_repairs.isNotEmpty) {
            _descriptionContoler.clear();
            _descriptions.clear();
            _showAddDescriptionDialogue();
          }
        },
        child: Text("Description",
            style: buttonText.copyWith(
                fontSize: MediaQuery.of(context).size.height > 600 ? 16 : 10)));
  }

  Widget _buildDateButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: _repairs.isNotEmpty ? Colors.blue : Colors.grey),
        onPressed: () {
          if (_repairs.isNotEmpty) {
            setState(() {
              _addDiscount = false;
              _buildTextField();
            });
          }
        },
        child: Text("Date",
            style: buttonText.copyWith(
                fontSize: MediaQuery.of(context).size.height > 600 ? 16 : 10)));
  }

  _buildAddTocart() {
    Iterable fetchStock =
        stocks.map((stock) => "${stock.part} ${stock.model}".toUpperCase());
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
        ),
        child: const Text('Valider', style: TextStyle(color: Colors.blue)),
        onPressed: () {
          if (_modelControler.value.text != '' &&
              _partControler.value.text != '') {
            setState(() {
              var newQuantity = _quantity ?? 0;
              var newPrice = _priceControler.value.text == ''
                  ? '0'
                  : _priceControler.value.text
                      .replaceAll(",", ".")
                      .replaceAll(" ", "");
              var newEmplacemnt = _emplacement ?? '';
              if (fetchStock.contains(
                  "${_partControler.value.text} ${_modelControler.value.text}"
                      .toUpperCase())) {
                Stock stock = stocks.firstWhere((element) =>
                    "${element.part} ${element.model}".toUpperCase() ==
                    "${_partControler.value.text} ${_modelControler.value.text}"
                        .toUpperCase());
                if (stock.price!.toUpperCase() != newPrice.toUpperCase()) {
                  _showModifyArticleDialog(
                      false, newPrice, newEmplacemnt, newQuantity);
                } else {
                  if (_repairs.isNotEmpty &&
                      _repairs.last.model == _modelControler.value.text &&
                      _repairs.last.part == _partControler.value.text) {
                    _repairs.last = Repair(
                        part: _partControler.text,
                        model: _modelControler.value.text,
                        price: newPrice,
                        description: '');
                  } else {
                    _repairs.add(Repair(
                        part: _partControler.value.text,
                        model: _modelControler.value.text,
                        price: newPrice,
                        description: ''));
                  }
                }
              } else {
                _showModifyArticleDialog(
                    true, newPrice, newEmplacemnt, newQuantity);
              }
            });
          }
        });
  }

  // Future _submit() async {
  //   var _price = getPrice(_priceControler.value.text.replaceAll(",", ".").replaceAll(" ", ""));
  //   var _description = _descriptionControler.value.text;
  //   var repair = Repair(
  //     model: _model,
  //     description: _description,
  //     part: _part,
  //     price: _price,
  //   );
  //   _cart = '$_cart\n $_part $_model  $_price EUR';
  //   repairList.add(repair);

  //   StockDatabase(companyUid: widget.userUid).modifyStockQuantity(
  //       '${_part!.toUpperCase} ${_model!.toUpperCase}',
  //       _model,
  //       _part,
  //       context,
  //       _price);
  // }

  Future _submitPrint(invoiceNumber, list) async {
    double total = _repairs.fold(
        0,
        (previousValue, element) =>
            previousValue + double.parse(element.price!));
    var discount = double.parse(getPrice(_discountControler.value.text
        .replaceAll(",", ".")
        .replaceAll(" ", "")));
    var accompte = double.parse(getPrice(_accompteControler.value.text
        .replaceAll(",", ".")
        .replaceAll(" ", "")));
    var date = DateFormat('HH:mm dd/MM/yyyy').format(_date);

    _addToFireBase(invoiceNumber);

    if (kIsWeb || Platform.isWindows) {
      var pdf = PdfCreator(
        accompte: getPrice(_accompteControler.value.text
            .replaceAll(",", ".")
            .replaceAll(" ", "")),
        isTicket: "REPAIR",
        documentValue: "Ticket de dépot",
        path: path,
        url: url,
        costumerAdress: "",
        costumerName: _nameControler.value.text,
        costumerPhone: _phoneControler.value.text,
        payWay: '',
        invoiceNumber: invoiceNumber,
        total: total,
        date: DateFormat('HH:mm dd/MM/yyyy').format(_date),
        discount: getPrice(_discountControler.value.text
            .replaceAll(",", ".")
            .replaceAll(" ", "")),
        cart: _repairs
            .map((repair) => Article(
                description: repair.description,
                article: "${repair.part} ${repair.model} ",
                price: repair.price,
                quantity: "1"))
            .toList(),
      ).generatePdf(context);
      await Printing.layoutPdf(onLayout: (_) => pdf);
    } else {
      PrintTicket().printRepairTicket(
          date,
          list,
          total,
          accompte,
          discount,
          invoiceNumber,
          invoiceNumber,
          _nameControler.value.text,
          _phoneControler.value.text);
    }
    _showPrintAlertDialog();
  }

  // Dialogue pour permettre de modifier ou ajouté un article
  _showModifyArticleDialog(isToAdd, newPrice, newEmplacemnt, newQuantity) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Attention...'),
              content: Text(isToAdd
                  ? "Voulez vous ajouter cette pièce ?"
                  : 'Voulez vous modifier  cette pièce ?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (_repairs.isNotEmpty &&
                          _repairs.last.model == _modelControler.value.text &&
                          _repairs.last.part == _partControler.value.text) {
                        _repairs.last = Repair(
                            part: _partControler.text,
                            model: _modelControler.value.text,
                            price: newPrice,
                            description: '');
                      } else {
                        _repairs.add(Repair(
                            part: _partControler.value.text,
                            model: _modelControler.value.text,
                            price: newPrice,
                            description: ''));
                      }
                      setState(() {
                        _modelControler.clear();
                        _priceControler.clear();
                        _emplacement = null;
                        _quantity = null;
                      });
                    },
                    child: const Text('Non')),
                TextButton(
                    onPressed: () {
                      // Lorsque la categorie etait vide, on ajoute un nouvel article dans le cas contraire on modifie l'article
                      if (!isToAdd) {
                        StockDatabase()
                            .addStock(
                                _partControler.value.text,
                                _modelControler.value.text,
                                newEmplacemnt,
                                newQuantity,
                                newPrice,
                                context)
                            .then((value) => Navigator.pop(context));
                        if (_repairs.isNotEmpty &&
                            _repairs.last.model == _modelControler.value.text &&
                            _repairs.last.part == _partControler.value.text) {
                          _repairs.last = Repair(
                              part: _partControler.text,
                              model: _modelControler.value.text,
                              price: newPrice,
                              description: '');
                        } else {
                          _repairs.add(Repair(
                              part: _partControler.value.text,
                              model: _modelControler.value.text,
                              price: newPrice,
                              description: ''));
                        }
                        setState(() {
                          _modelControler.clear();
                          _priceControler.clear();
                          _emplacement = null;
                          _quantity = null;
                        });
                      } else {
                        if (!parts.map((part) => part.uid).contains(
                            _partControler.value.text.toUpperCase())) {
                          PartsDatabase().addPart(
                              _partControler.value.text.toUpperCase(), context);
                        }
                        StockDatabase()
                            .addStock(
                                _partControler.value.text,
                                _modelControler.value.text,
                                newEmplacemnt,
                                newQuantity,
                                newPrice,
                                context)
                            .then((value) => Navigator.pop(context));
                        if (_repairs.isNotEmpty &&
                            _repairs.last.model == _modelControler.value.text &&
                            _repairs.last.part == _partControler.value.text) {
                          _repairs.last = Repair(
                              part: _partControler.text,
                              model: _modelControler.value.text,
                              price: newPrice,
                              description: '');
                        } else {
                          _repairs.add(Repair(
                              part: _partControler.value.text,
                              model: _modelControler.value.text,
                              price: newPrice,
                              description: ''));
                        }
                        setState(() {
                          _modelControler.clear();
                          _priceControler.clear();
                          _emplacement = null;
                          _quantity = null;
                        });
                      }
                    },
                    child: const Text('Oui'))
              ],
            ));
  }

  _showAddDescriptionDialogue() {
    return showDialog(
        context: context,
        builder: (BuildContext context) =>
            StatefulBuilder(builder: (context, setState) {
              return Dialog(
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Column(
                          children: [
                            Expanded(
                              child: TextButton(
                                  child: const Text('Ajouter une description'),
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const DescriptionAdderPage()))),
                            ),
                            Expanded(
                                flex: 6,
                                child: ValueListenableBuilder<Box<dynamic>>(
                                    valueListenable: DescriptionBox
                                        .descriptionBox!
                                        .listenable(),
                                    builder: (context, box, widget) {
                                      var descriptionData = box.values
                                          .map((description) => Description(
                                              uid: description["uid"],
                                              description:
                                                  description["description"]))
                                          .toList();
                                      return ListView.builder(
                                          itemCount: descriptionData.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                                onTap: () => {
                                                      setState(
                                                        () {
                                                          _descriptions
                                                                  .contains(
                                                                      '${descriptionData[index].description}')
                                                              ? _descriptions
                                                                  .remove(
                                                                      '${descriptionData[index].description}')
                                                              : _descriptions.add(
                                                                  '${descriptionData[index].description}');
                                                        },
                                                      )
                                                    },
                                                title: Text(
                                                  '${descriptionData[index].description}',
                                                  style: TextStyle(
                                                      color: _descriptions.contains(
                                                              '${descriptionData[index].description}')
                                                          ? Colors.green
                                                          : Colors.blue),
                                                ),
                                                trailing: _descriptions.contains(
                                                        '${descriptionData[index].description}')
                                                    ? const Icon(
                                                        Icons
                                                            .radio_button_checked,
                                                        color: Colors.green,
                                                      )
                                                    : const Icon(
                                                        Icons
                                                            .radio_button_unchecked,
                                                        color: Colors.blue,
                                                      ));
                                          });
                                    })),
                            Expanded(child: _buildDescription()),
                            Expanded(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildDescriptionCancelButton(),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    _buildDescriptionDoneButton()
                                  ]),
                            )
                          ],
                        ),
                      )));
            }));
  }

  _deleteRepairAlerteDialog(activityIndex) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Attention...'),
              content: const Text('Voulez vous supprimer cet repas?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Non')),
                TextButton(
                    onPressed: () => {
                          setState(() {
                            _repairs.remove(activityIndex);
                            Navigator.pop(context);
                          })
                        },
                    child: const Text('Oui'))
              ],
            ));
  }

  _showCostumerDialogue() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Avertissement!!!'),
              content: const Text(
                  'Vous ne pouvez pas enregistrer une réparation sans ajouter une client...'),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _chooseCostumer = true;
                        Navigator.pop(context);
                      });
                    },
                    child: const Text('Ajouter un client'))
              ],
            ));
  }

  _buildExpansionTile(
      List repairList,
      repairUid,
      ticketNumber,
      total,
      ticketDate,
      costumerName,
      costumerAdress,
      costumerPhone,
      discount,
      accompte,
      emplacement,
      state) {
    return ExpansionTile(
      title: _buildList(repairList),
      trailing: _buidCard(Colors.blue, Colors.white, total),
      leading: _buidCard(
          Colors.blue, Colors.white, DateFormat('HH:MM').format(ticketDate)),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: TextButton(
                  onPressed: () async {
                    var pdf = PdfCreator(
                      accompte: accompte,
                      isTicket: "A4",
                      documentValue: "Facture",
                      path: path,
                      url: url,
                      costumerAdress: costumerAdress,
                      costumerName: costumerName,
                      costumerPhone: costumerPhone,
                      payWay: '',
                      invoiceNumber: ticketNumber,
                      total: total,
                      date: DateFormat('HH:mm dd/MM/yyyy').format(ticketDate),
                      discount: discount,
                      cart: repairList
                          .map((repair) => Article(
                              description: repair["description"],
                              article: "${repair["part"]} ${repair["model"]}",
                              price: repair["price"],
                              quantity: "1"))
                          .toList(),
                    ).generatePdf(context);
                    await Printing.layoutPdf(onLayout: (_) => pdf);
                  },
                  child: const Text('Facture A4')),
            ),
            kIsWeb || Platform.isWindows
                ? Expanded(
                    child: TextButton(
                        onPressed: () async {
                          var pdf = PdfCreator(
                            accompte: accompte,
                            isTicket: "REPAIR",
                            documentValue: "Ticket de dépot",
                            path: path,
                            url: url,
                            costumerAdress: costumerAdress,
                            costumerName: costumerName,
                            costumerPhone: costumerPhone,
                            payWay: '',
                            invoiceNumber: ticketNumber,
                            total: total,
                            date: DateFormat('HH:mm dd/MM/yyyy')
                                .format(ticketDate),
                            discount: discount,
                            cart: repairList
                                .map((repair) => Article(
                                    description: repair["description"],
                                    article:
                                        "${repair["part"]} ${repair["model"]}",
                                    price: repair["price"],
                                    quantity: "1"))
                                .toList(),
                          ).generatePdf(context);
                          await Printing.layoutPdf(onLayout: (_) => pdf);
                        },
                        child: const Text('Ticket')),
                  )
                : Expanded(
                    child: FutureBuilder<bool?>(
                        future: bluetooth.isConnected,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return snapshotError;
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return loader;
                          }
                          bool isConnected = snapshot.requireData ?? false;
                          return TextButton(
                              onPressed: () {
                                if (isConnected) {
                                  setState(() {
                                    PrintTicket().printRepairTicket(
                                        DateFormat('HH:MM dd/mm/yyyy')
                                            .format(ticketDate),
                                        repairList
                                            .map((repair) => Repair(
                                                description:
                                                    repair['description'],
                                                part: repair['part'],
                                                model: repair['model'],
                                                price: repair['price']))
                                            .toList(),
                                        total,
                                        double.parse(accompte),
                                        double.parse(discount),
                                        'Ib-Developpe',
                                        ticketNumber,
                                        costumerName,
                                        costumerPhone);
                                  });
                                } else {
                                  _showBluetoothAlertDialog();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const BluetoothPrinter()));
                                }
                              },
                              child: Text(
                                isConnected ? 'Ticket' : 'aucune imprimante',
                                style: TextStyle(
                                    color:
                                        isConnected ? Colors.blue : Colors.red),
                              ));
                        }),
                  ),
            Expanded(
              child: TextButton(
                  onPressed: () {
                    _showDeleteAlertDialog(repairUid);
                  },
                  child: const Text(
                    'Supprimer',
                    style: TextStyle(color: Colors.red),
                  )),
            ),
            Expanded(
              child: TextButton(
                  onPressed: () {
                    _showModifyAlertDialog(
                        repairList,
                        discount,
                        accompte,
                        costumerName,
                        costumerPhone,
                        costumerAdress,
                        repairUid,
                        ticketDate,
                        state,
                        ticketNumber,
                        emplacement);
                  },
                  child: const Text(
                    'Modifier',
                    style: TextStyle(color: Colors.red),
                  )),
            ),
            Expanded(
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PdfCreator(
                                  accompte: accompte,
                                  isTicket: "REPAIR",
                                  documentValue: "Facture",
                                  path: path,
                                  url: url,
                                  costumerAdress: costumerAdress,
                                  costumerName: costumerName,
                                  costumerPhone: costumerPhone,
                                  payWay: '',
                                  invoiceNumber: ticketNumber,
                                  total: total,
                                  date: DateFormat('HH:mm dd/MM/yyyy')
                                      .format(ticketDate),
                                  discount: discount,
                                  cart: repairList
                                      .map((repair) => Article(
                                          description: repair["description"],
                                          article:
                                              "${repair["part"]} ${repair["model"]}",
                                          price: repair["price"],
                                          quantity: "1"))
                                      .toList(),
                                )));
                  },
                  child: const Text('Voir')),
            ),
          ],
        )
      ],
    );
  }

  _showDeleteAlertDialog(String? repairUid) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Attention...'),
              content: const Text(
                  'Vous êtes sur le point de supprimer une reparation. Etes vous sures?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annuler')),
                TextButton(
                    onPressed: () => {
                          CompanyDatabase(userUid: userUid)
                              .deleteRepair(repairUid, context),
                          Navigator.pop(context),
                        },
                    child: const Text('Ok'))
              ],
            ));
  }

  _showPrintAlertDialog() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Impression...'),
              content: const Text(
                  'Impression terminée appuyer sur Ok pour continuer?'),
              actions: [
                TextButton(
                    onPressed: () => {
                          setState(() {
                            _repairs.clear();
                            _partControler.clear();
                            _modelControler.clear();
                            _priceControler.clear();
                            _phoneControler.clear();
                            _nameControler.clear();
                            _adressControler.clear();
                          }),
                          Navigator.pop(context)
                        },
                    child: const Text('Ok'))
              ],
            ));
  }

  _showModifyAlertDialog(List repairList, discount, accompte, name, phone,
      adress, repairUid, date, state, ticketNumber, emplacement) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Attention...'),
              content: const Text('Voulez vous modifier cette reparation ?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annuler')),
                TextButton(
                    onPressed: () => {
                          setState(() {
                            _date = date;
                            _discountControler.text = discount;
                            _accompteControler.text = accompte;
                            _ticketNumber = ticketNumber;
                            _emplacement = emplacement;
                            _phoneControler.text = phone;
                            _adressControler.text = adress;
                            _nameControler.text = name;
                            _repairs = repairList
                                .map((repair) => Repair(
                                    description: repair['description'],
                                    price: repair['price'],
                                    model: repair['model'],
                                    part: repair['part']))
                                .toList();
                          }),
                          Navigator.pop(context),
                        },
                    child: const Text('Ok'))
              ],
            ));
  }

  _showBluetoothAlertDialog() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Attention...'),
              content: const Text(
                  'Vous allez etre rédiriger vers la page de connexion '),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annuler')),
                TextButton(
                    onPressed: () => {
                          setState(() {}),
                          Navigator.pop(context),
                        },
                    child: const Text('Ok'))
              ],
            ));
  }

  _buidCard(color, background, text) {
    return Card(
        color: background,
        elevation: 10,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: color,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        margin: const EdgeInsets.all(3),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: FittedBox(
            child: Text('$text',
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize:
                        MediaQuery.of(context).size.height > 600 ? 16 : 7)),
          ),
        ));
  }

  _buildList(List list) {
    return ListView(
        shrinkWrap: true,
        children: list
            .map((repair) => Card(
                color: Colors.white,
                elevation: 10,
                shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.blue,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(
                        MediaQuery.of(context).size.height > 600 ? 12 : 2))),
                margin: EdgeInsets.all(
                    MediaQuery.of(context).size.height > 600 ? 3 : 1),
                child: Padding(
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.height > 600 ? 6 : 2),
                  child: Text('${repair['part']}  ${repair['model']}',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height > 600
                              ? 16
                              : 7)),
                )))
            .toList());
  }

  Future<void> _addToFireBase(invoiceNumber) async {
    double total = _repairs.fold(
        0,
        (previousValue, element) =>
            previousValue + double.parse('${element.price}'));

    CompanyDatabase(userUid: userUid)
        .addRepair(
            invoiceNumber,
            _phoneControler.value.text,
            _nameControler.value.text,
            getPrice(_discountControler.value.text
                .replaceAll(",", ".")
                .replaceAll(" ", "")),
            getPrice(_accompteControler.value.text
                .replaceAll(",", ".")
                .replaceAll(" ", "")),
            _repairs,
            total,
            _adressControler.value.text,
            _date,
            context)
        .then((value) => _updateStocks(_repairs));
  }

  _updateStocks(List<Repair> repairs) {
    for (var repair in repairs) {
      var stock = StockBox.stockBox!.values.firstWhere((stock) =>
          stock["uid"] ==
          "${repair.part!.toUpperCase()} ${repair.model!.toUpperCase()}");
      StockDatabase().modifyStockQuantity(
          "${repair.part!.toUpperCase()} ${repair.model!.toUpperCase()}",
          repair.model,
          repair.part,
          context,
          repair.price,
          stock["quantity"],
          stock["emplacement"]);
    }
  }

  String getPrice(String price) {
    String price0;
    if (price == '') {
      price0 = '0';
    } else {
      price0 = price;
    }
    return price0;
  }
}
