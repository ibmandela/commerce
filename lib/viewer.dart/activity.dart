import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:gestion_commerce_reparation/adders/paid_loan.dart';
import 'package:gestion_commerce_reparation/adders/repair_adder.dart';
import 'package:gestion_commerce_reparation/common/constant.dart';
import 'package:gestion_commerce_reparation/modeles/user.dart';
import 'package:gestion_commerce_reparation/services/firebase/company_database.dart';
import 'package:gestion_commerce_reparation/services/hive_database/boxes.dart';
import 'package:gestion_commerce_reparation/services/print_service.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

class ActivityPage extends StatelessWidget {
  final bool isCostumerView;
  final String? costumerName;
  const ActivityPage(
      {required this.isCostumerView, this.costumerName, super.key});

  @override
  Widget build(BuildContext context) {
    return ActivityList(
      isCostumerView: isCostumerView,
      costumerName: costumerName,
    );
  }
}

class ActivityList extends StatefulWidget {
  final bool isCostumerView;
  final String? costumerName;
  const ActivityList(
      {required this.isCostumerView, this.costumerName, super.key});

  @override
  State createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityList> {
  final _bluetooth = BlueThermalPrinter.instance;
  final _emplacementControler = TextEditingController();
  final _keyForm = GlobalKey<FormState>();
  List<String> cart = [];
  var format = DateFormat('HH:mm dd/MM');
  var pdfFormat = DateFormat('HH:mm dd/MM/yyyy');
  var week = DateTime.now().subtract(const Duration(days: 7));
  var month = DateTime.now().subtract(const Duration(days: 30));
  var now = DateTime.now();
  String? _searchCostumer;
  DateTime? _searchDate;
  String? _searchTotal;
  String? _searchRepair;
  String? _date;
  String? documentValue;
  @override
  void initState() {
    if (widget.isCostumerView) {
      _searchCostumer = widget.costumerName;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: widget.isCostumerView == false
            ? PreferredSize(
                preferredSize: MediaQuery.of(context).size.height < 600
                    ? const Size.fromHeight(52)
                    : const Size.fromHeight(120),
                child: AppBar(
                  title: Row(children: [
                    Expanded(child: _buildSearchCostumer()),
                    Expanded(child: _buildSearchRepair()),
                    Expanded(child: _builIcon()),
                    Expanded(child: _buildSearchTotal())
                  ]),
                  bottom: _buildTab(),
                ))
            : null,
        body: widget.isCostumerView == true
            ? _buildByCostumerList()
            : TabBarView(children: [
                _searchCostumer != null
                    ? _buildByCostumerList()
                    : _searchRepair != null
                        ? _buildByRepairList()
                        : _searchTotal != null
                            ? _buildByTotalList()
                            : _searchDate != null
                                ? _buildByDateList()
                                : _buildDateList(null),
                _buildDateList(DateTime(now.year, now.month, now.day)),
                _buildDateList(month),
                _buildDateList(now),
              ]),
        floatingActionButton: widget.isCostumerView == true
            ? FloatingActionButton(
                onPressed: (() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RepairAdderPage()));
                }),
                child: const Icon(Icons.add),
              )
            : null,
      ),
    );
  }

  _builIcon() {
    return GestureDetector(
      onTap: () async {
        DateTime? newDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100));
        if (newDate == null) return;
        setState(() {
          _searchCostumer = null;
          _searchDate = newDate;
          _date = '${newDate.day}/${newDate.month}/${newDate.year}';
        });
      },
      child: Container(
        height: MediaQuery.of(context).size.height > 600 ? 50 : 30,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.blue, width: 3),
            borderRadius: const BorderRadius.all(Radius.circular(30))),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: MediaQuery.of(context).size.height > 600 ? 20 : 15,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              _date != null ? "$_date" : "Choisir une date",
              style: formTextStyle.copyWith(
                  fontSize: MediaQuery.of(context).size.height > 600 ? 17 : 8),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSearchTotal() {
    return SizedBox(
        height: MediaQuery.of(context).size.height > 600 ? 50 : 30,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              autocorrect: true,
              textCapitalization: TextCapitalization.characters,
              decoration: textInputDecoration.copyWith(
                  label: Text(
                    'chercher montant',
                    style: formTextStyle.copyWith(
                        fontSize:
                            MediaQuery.of(context).size.height > 600 ? 17 : 8),
                  ),
                  hintText: 'chercher montant'),
              onChanged: (value) => setState(() {
                _searchTotal = value;
              }),
            )));
  }

  Widget _buildSearchCostumer() {
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
                    'chercher client',
                    style: formTextStyle.copyWith(
                        fontSize:
                            MediaQuery.of(context).size.height > 600 ? 17 : 8),
                  ),
                  hintText: 'chercher client'),
              onChanged: (value) => setState(() {
                _searchCostumer = value;
              }),
            )));
  }

  Widget _buildSearchRepair() {
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
                    'chercher appareil',
                    style: formTextStyle.copyWith(
                        fontSize:
                            MediaQuery.of(context).size.height > 600 ? 17 : 8),
                  ),
                  hintText: 'chercher appariel'),
              onChanged: (value) => setState(() {
                _searchRepair = value;
              }),
            )));
  }

  _buildTab() {
    return TabBar(
      labelColor: Colors.white,
      indicatorColor: Colors.white,
      indicatorWeight: 3,
      tabs: [
        Tab(
            height: MediaQuery.of(context).size.height < 600 ? 20 : 60,
            iconMargin: const EdgeInsets.all(0),
            text: 'Toutes les reparations'),
        Tab(
            height: MediaQuery.of(context).size.height < 600 ? 20 : 60,
            iconMargin: const EdgeInsets.all(0),
            text: "aujourd'hui"),
        Tab(
            height: MediaQuery.of(context).size.height < 600 ? 20 : 60,
            iconMargin: const EdgeInsets.all(0),
            text: 'de la semaine'),
        Tab(
            height: MediaQuery.of(context).size.height < 600 ? 20 : 60,
            iconMargin: const EdgeInsets.all(0),
            text: 'du mois'),
      ],
    );
  }

  _buildByCostumerList() {
    return ValueListenableBuilder<Box<dynamic>>(
        valueListenable: RepairBox.repairBox!.listenable(),
        builder: (context, box, widget1) {
          var data = box.values
              .where((repair) => repair["costumerName"]
                  .toUpperCase()
                  .contains(_searchCostumer!.toUpperCase()))
              .map((repair) => RepairActivity(
                  repairUid: repair["uid"],
                  ticketNumber: repair["ticketNumber"],
                  date: repair["date"],
                  phone: repair["phone"],
                  costumerName: repair["costumerName"],
                  costumerAdress: repair["costumerAdress"],
                  discount: repair["discount"],
                  accompte: repair["accompte"],
                  total: repair["total"].toDouble(),
                  state: repair["state"],
                  emplacement: repair["emplacement"],
                  repairList: repair["repairList"]))
              .toList();

          return _buildotherList(data);
        });
  }

  _buildByRepairList() {
    return ValueListenableBuilder<Box<dynamic>>(
        valueListenable: RepairBox.repairBox!.listenable(),
        builder: (context, box, widget1) {
          var data = box.values
              .where((repair) {
                Iterable cart = repair["repairList"]
                    .map((label) => "${label["part"]} ${label["model"]}");

                return cart
                    .where((element) => element
                        .toUpperCase()
                        .contains(_searchRepair!.toUpperCase()))
                    .isNotEmpty;
              })
              .map((repair) => RepairActivity(
                  repairUid: repair["uid"],
                  ticketNumber: repair["ticketNumber"],
                  date: repair["date"],
                  phone: repair["phone"],
                  costumerName: repair["costumerName"],
                  costumerAdress: repair["costumerAdress"],
                  discount: repair["discount"],
                  accompte: repair["accompte"],
                  total: repair["total"].toDouble(),
                  state: repair["state"],
                  emplacement: repair["emplacement"],
                  repairList: repair["repairList"]))
              .toList();

          return _buildotherList(data);
        });
  }

  _buildByTotalList() {
    return ValueListenableBuilder<Box<dynamic>>(
        valueListenable: RepairBox.repairBox!.listenable(),
        builder: (context, box, widget1) {
          var data = box.values
              .where((repair) => repair["total"]
                  .toDouble()
                  .toString()
                  .toUpperCase()
                  .contains(_searchTotal!.toUpperCase()))
              .map((repair) => RepairActivity(
                  repairUid: repair["uid"],
                  ticketNumber: repair["ticketNumber"],
                  date: repair["date"],
                  phone: repair["phone"],
                  costumerName: repair["costumerName"],
                  costumerAdress: repair["costumerAdress"],
                  discount: repair["discount"],
                  accompte: repair["accompte"],
                  total: repair["total"].toDouble(),
                  state: repair["state"],
                  emplacement: repair["emplacement"],
                  repairList: repair["repairList"]))
              .toList();

          return _buildotherList(data);
        });
  }

  _buildByDateList() {
    return ValueListenableBuilder<Box<dynamic>>(
        valueListenable: RepairBox.repairBox!.listenable(),
        builder: (context, box, widget1) {
          var data = box.values
              .where((repair) => DateTime(repair["date"].year,
                      repair["date"].month, repair["date"].day)
                  .isAtSameMomentAs(DateTime(
                      _searchDate!.year, _searchDate!.month, _searchDate!.day)))
              .map((repair) => RepairActivity(
                  repairUid: repair["uid"],
                  ticketNumber: repair["ticketNumber"],
                  date: repair["date"],
                  phone: repair["phone"],
                  costumerName: repair["costumerName"],
                  costumerAdress: repair["costumerAdress"],
                  discount: repair["discount"],
                  accompte: repair["accompte"],
                  total: repair["total"].toDouble(),
                  state: repair["state"],
                  emplacement: repair["emplacement"],
                  repairList: repair["repairList"]))
              .toList();

          return _buildotherList(data);
        });
  }

  _buildDateList(time) {
    return ValueListenableBuilder<Box<dynamic>>(
        valueListenable: RepairBox.repairBox!.listenable(),
        builder: (context, box, widget1) {
          var data = time != null
              ? box.values
                  .where((repair) => repair["date"].isAfter(time))
                  .map((repair) => RepairActivity(
                      repairUid: repair["uid"],
                      ticketNumber: repair["ticketNumber"],
                      date: repair["date"],
                      phone: repair["phone"],
                      costumerName: repair["costumerName"],
                      costumerAdress: repair["costumerAdress"],
                      discount: repair["discount"],
                      accompte: repair["accompte"],
                      total: repair["total"].toDouble(),
                      state: repair["state"],
                      emplacement: repair["emplacement"],
                      repairList: repair["repairList"]))
                  .toList()
              : box.values
                  .map((repair) => RepairActivity(
                      repairUid: repair["uid"],
                      ticketNumber: repair["ticketNumber"],
                      date: repair["date"],
                      phone: repair["phone"],
                      costumerName: repair["costumerName"],
                      costumerAdress: repair["costumerAdress"],
                      discount: repair["discount"],
                      accompte: repair["accompte"],
                      total: repair["total"].toDouble(),
                      state: repair["state"],
                      emplacement: repair["emplacement"],
                      repairList: repair["repairList"]))
                  .toList();

          return _buildotherList(data);
        });
  }

  _buildotherList(List data) {
    data.sort((a, b) => b.date.compareTo(a.date));
    int totalItem = data.fold(0, (previousValue, element) => previousValue + 1);
    double totalPrice = data.fold(
        0.0, (previousValue, element) => previousValue + element.total);
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(children: [
          ListView.builder(
              itemCount: data.length + 1,
              itemBuilder: (context, index) {
                if (index == data.length) {
                  return Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.blue, width: 5),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30))),
                      padding: const EdgeInsets.all(8),
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Total réparation: ${NumberFormat.currency(locale: 'fr').format(totalPrice)}',
                            style: formTextStyle,
                          ),
                          Text(
                            'Nombre: $totalItem',
                            style: formTextStyle,
                          ),
                        ],
                      ));
                }
                return Card(
                  elevation: 10,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical:
                            MediaQuery.of(context).size.height > 600 ? 10 : 0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            format.format(data[index].date),
                            style: titleStyle.copyWith(
                                fontSize:
                                    MediaQuery.of(context).size.height < 600
                                        ? 10
                                        : 20,
                                color: _setColor(data[index].state)),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "${data[index].costumerName}",
                            style: textStyle.copyWith(
                                fontSize:
                                    MediaQuery.of(context).size.height < 600
                                        ? 10
                                        : 20,
                                color: _setColor(data[index].state)),
                          ),
                        ),
                        Expanded(
                            flex: 5,
                            child: _buildRepairList(
                                data[index].repairList,
                                data[index].phone,
                                data[index].state,
                                data[index].emplacement,
                                data[index].repairUid,
                                data[index].ticketNumber,
                                data[index].costumerName,
                                data[index].accompte,
                                data[index].discount,
                                data[index].total,
                                data[index].date)),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              _showEmplacementAlertDialog(data[index].repairUid,
                                  "${data[index].emplacement}");
                            },
                            child: Text("${data[index].emplacement}",
                                style: textStyle.copyWith(
                                    fontSize:
                                        MediaQuery.of(context).size.height > 600
                                            ? 20
                                            : 10,
                                    color: _setColor(data[index].state))),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            onPressed: () {
                              _repairAlertDialog(
                                  data[index].ticketNumber,
                                  data[index].costumerName,
                                  data[index].phone,
                                  data[index].accompte,
                                  data[index].discount,
                                  data[index].total,
                                  data[index].repairList,
                                  data[index].date,
                                  data[index].repairUid,
                                  data[index].state,
                                  data[index].costumerAdress,
                                  data[index].emplacement);
                            },
                            icon: Icon(
                              Icons.remove_red_eye_rounded,
                              size: MediaQuery.of(context).size.height > 600
                                  ? 20
                                  : 15,
                              color: _setColor(data[index].state),
                            ),
                          ),
                        ),
                        Expanded(
                            child: _dropdown(
                                data[index].repairUid,
                                data[index].state,
                                data[index].phone,
                                data[index].ticketNumber,
                                data[index].costumerName,
                                data[index].costumerAdress,
                                data[index].accompte,
                                data[index].discount,
                                data[index].repairList,
                                data[index].total,
                                setState,
                                data[index].date)),
                      ],
                    ),
                  ),
                );
              }),
          if (MediaQuery.of(context).size.height > 600 &&
              widget.isCostumerView == false)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.blue, width: 5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(30))),
                  padding: const EdgeInsets.all(8),
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Total vente: ${NumberFormat.currency(locale: 'fr').format(totalPrice)}',
                        style: formTextStyle,
                      ),
                      Text(
                        'Nombre: $totalItem',
                        style: formTextStyle,
                      ),
                    ],
                  )),
            ),
        ]));
  }

  _buildRepairList(List list, phone, state, emplacement, repairUid,
      ticketNumber, name, accompte, discount, total, date) {
    return ListView(
        shrinkWrap: true,
        children: list
            .map((repair) => Text("${repair['part']} ${repair['model']}",
                style: TextStyle(
                    fontSize:
                        MediaQuery.of(context).size.height < 600 ? 10 : 20,
                    fontWeight: FontWeight.bold,
                    color: _setColor("$state"))))
            .toList());
  }

  Color _setColor(String state) {
    if (state.toUpperCase() == 'FAIT') {
      return Colors.green;
    }

    if (state.toUpperCase() == 'EN ATTENTE') {
      return Colors.blue;
    }

    if (state.toUpperCase() == 'IRREPARABLE') {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }

  _dropdown(String repairUid, state, phone, ticketNumber, costumerName,
      costumerAdress, accompte, discount, repairList, total, setState, date) {
    String dropdownValue = state;
    return DropdownButton<String>(
      underline: const Visibility(
        visible: false,
        child: Icon(Icons.ac_unit),
      ),
      value: dropdownValue,
      icon: const Visibility(
        visible: false,
        child: Icon(Icons.ac_unit),
      ),
      elevation: 16,
      style: TextStyle(color: _setColor(state)),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          CompanyDatabase(userUid: userUid).modifyRepairState(
              repairUid,
              newValue,
              ticketNumber,
              phone,
              costumerName,
              costumerAdress,
              accompte,
              discount,
              repairList,
              total,
              date,
              context);
          if (newValue == 'Fait') {
            // _showSmsAlertDialog(number, part, model);
          }
        });
      },
      items: <String>['En cours', 'Fait', 'En attente', 'Irreparable']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height > 600 ? 20 : 7,
                fontWeight: FontWeight.bold),
          ),
        );
      }).toList(),
    );
  }

  _showEmplacementAlertDialog(String? activityUid, emplacement) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.zero,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Form(
                      key: _keyForm,
                      child: Column(children: [
                        Text(
                          "Changement d'emplacement",
                          style: textStyle.copyWith(color: Colors.blue),
                        ),
                        if (MediaQuery.of(context).size.height > 600)
                          const SizedBox(
                            height: 15,
                          ),
                        TextFormField(
                            maxLength: 5,
                            controller: _emplacementControler,
                            validator: (value) {
                              if (value == null) {
                                return "Verifiez ce champ SVP";
                              }
                              if (value.isNotEmpty && value.length < 2) {
                                return "Verifiez ce champ SVP";
                              } else {
                                return null;
                              }
                            },
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Emplacement')),
                      ]),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Annuler'),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => {
                              if (_keyForm.currentState!.validate())
                                {
                                  Navigator.of(context).pop(),
                                  CompanyDatabase(userUid: userUid)
                                      .modifyRepairEmplacement(
                                          activityUid,
                                          _emplacementControler.value.text,
                                          context),
                                }
                            },
                            child: const Text('Valider'),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        });
  }

  _repairAlertDialog(
      ticketNumber,
      costumerName,
      phone,
      accompte,
      discount,
      total,
      List repairList,
      date,
      repairUid,
      state,
      costumerAdress,
      emplacement) {
    var net = total - double.parse(accompte) - double.parse(discount);
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              return Dialog(
                  elevation: 20,
                  backgroundColor: Colors.blue,
                  shape: const RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height > 600
                        ? MediaQuery.of(context).size.height / 1.5
                        : MediaQuery.of(context).size.height / 1.2,
                    width: MediaQuery.of(context).size.height > 600
                        ? MediaQuery.of(context).size.width / 1.5
                        : MediaQuery.of(context).size.width / 1.2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (MediaQuery.of(context).size.height < 600)
                              Row(
                                children: [
                                  Expanded(
                                      child: _buildCard(
                                          Colors.blue,
                                          Colors.white,
                                          "Ticket: $ticketNumber")),
                                  Expanded(
                                      child: _buildCard(Colors.blue,
                                          Colors.white, costumerName)),
                                  Expanded(
                                      child: _buildCard(
                                          Colors.blue, Colors.white, phone)),
                                ],
                              ),
                            if (MediaQuery.of(context).size.height > 600)
                              Expanded(
                                  child: _buildCard(Colors.blue, Colors.white,
                                      "Ticket: $ticketNumber")),
                            if (MediaQuery.of(context).size.height > 600)
                              Expanded(
                                  child: _buildCard(
                                      Colors.blue, Colors.white, costumerName)),
                            if (MediaQuery.of(context).size.height > 600)
                              Expanded(
                                  child: _buildCard(
                                      Colors.blue, Colors.white, phone)),
                            Expanded(
                              flex: 5,
                              child: SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: ListView.builder(
                                      itemCount: repairList.length,
                                      itemBuilder: (context, index) => Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '${repairList[index]['model']}  ${repairList[index]['part']}',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .height >
                                                                  600
                                                              ? 20
                                                              : 10,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                _buildCard(
                                                    Colors.black,
                                                    Colors.white,
                                                    '${repairList[index]['price']}€'),
                                              ])),
                                ),
                              ),
                            ),
                            if (MediaQuery.of(context).size.height < 600)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildCard(Colors.black, Colors.white,
                                      "Total: $total EUR"),
                                  _buildCard(Colors.black, Colors.white,
                                      "Accompte: $accompte EUR"),
                                  _buildCard(Colors.black, Colors.white,
                                      "Reduction: $discount EUR"),
                                  _buildCard(Colors.black, Colors.white,
                                      "Net à payer: $net EUR")
                                ],
                              ),
                            if (MediaQuery.of(context).size.height > 600)
                              _buildCard(Colors.black, Colors.white,
                                  "Total: $total EUR"),
                            if (MediaQuery.of(context).size.height > 600)
                              _buildCard(Colors.black, Colors.white,
                                  "Accompte: $accompte EUR"),
                            if (MediaQuery.of(context).size.height > 600)
                              _buildCard(Colors.black, Colors.white,
                                  "Reduction: $discount EUR"),
                            if (MediaQuery.of(context).size.height > 600)
                              _buildCard(Colors.black, Colors.white,
                                  "Net à payer: $net EUR"),
                            Expanded(
                                child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        'Annuler',
                                        style: titleStyle.copyWith(
                                            fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height >
                                                    600
                                                ? 20
                                                : 10,
                                            color: Colors.white),
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        CompanyDatabase(userUid: userUid)
                                            .deleteRepair(repairUid, context);
                                        Navigator.pop(context);
                                      },
                                      child: Text('suppr',
                                          style: titleStyle.copyWith(
                                              fontSize: MediaQuery.of(context)
                                                          .size
                                                          .height >
                                                      600
                                                  ? 20
                                                  : 10,
                                              color: Colors.white))),
                                  kIsWeb || Platform.isWindows
                                      ? TextButton(
                                          onPressed: () async {
                                            var pdf = PdfCreator(
                                                    accompte: accompte,
                                                    isTicket: "REPAIR",
                                                    documentValue: "Facture",
                                                    path: path,
                                                    url: url,
                                                    invoiceNumber: ticketNumber,
                                                    costumerAdress:
                                                        costumerAdress,
                                                    costumerName: costumerName,
                                                    costumerPhone: phone,
                                                    date:
                                                        pdfFormat.format(date),
                                                    payWay: '',
                                                    cart: repairList
                                                        .map((repair) => Article(
                                                            description: repair[
                                                                "description"],
                                                            article:
                                                                "${repair["part"]} ${repair["model"]}",
                                                            price:
                                                                repair["price"],
                                                            quantity: "1"))
                                                        .toList(),
                                                    total: total,
                                                    discount: discount)
                                                .generatePdf(context);
                                            await Printing.layoutPdf(
                                                onLayout: (_) => pdf);
                                          },
                                          child: Text(
                                            "Ticket",
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                          .size
                                                          .height >
                                                      600
                                                  ? 20
                                                  : 10,
                                            ),
                                          ))
                                      : FutureBuilder<bool?>(
                                          future: _bluetooth.isConnected,
                                          builder: (context, snapshot) {
                                            if (snapshot.hasError) {
                                              return snapshotError;
                                            }
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return loader;
                                            }
                                            bool isConnected =
                                                snapshot.requireData ?? false;
                                            return TextButton(
                                                onPressed: () => {
                                                      Navigator.pop(context),
                                                      if (isConnected)
                                                        {
                                                          setState(() {
                                                            PrintTicket().printRepairTicket(
                                                                date,
                                                                repairList
                                                                    .map((repair) => Repair(
                                                                        part: repair[
                                                                            "part"],
                                                                        model: repair[
                                                                            "model"],
                                                                        price: repair[
                                                                            "price"],
                                                                        description:
                                                                            repair["description"]))
                                                                    .toList(),
                                                                net,
                                                                accompte,
                                                                discount,
                                                                ticketNumber,
                                                                ticketNumber,
                                                                costumerName,
                                                                phone);
                                                          })
                                                        }
                                                    },
                                                child: Text('ticket',
                                                    style: titleStyle.copyWith(
                                                        fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height >
                                                                600
                                                            ? 20
                                                            : 10,
                                                        color: Colors.white)));
                                          }),
                                  TextButton(
                                      onPressed: () async {
                                        var pdf = PdfCreator(
                                                accompte: accompte,
                                                isTicket: "A4",
                                                documentValue: "Facture",
                                                path: path,
                                                url: url,
                                                invoiceNumber: ticketNumber,
                                                costumerAdress: costumerAdress,
                                                costumerName: costumerName,
                                                costumerPhone: phone,
                                                date: pdfFormat.format(date),
                                                payWay: '',
                                                cart: repairList
                                                    .map((repair) => Article(
                                                        description: repair[
                                                            "description"],
                                                        article:
                                                            "${repair["part"]} ${repair["model"]}",
                                                        price: repair["price"],
                                                        quantity: "1"))
                                                    .toList(),
                                                total: total,
                                                discount: discount)
                                            .generatePdf(context);
                                        await Printing.layoutPdf(
                                            onLayout: (_) => pdf);
                                      },
                                      child: Text('A4',
                                          style: titleStyle.copyWith(
                                              fontSize: MediaQuery.of(context)
                                                          .size
                                                          .height >
                                                      600
                                                  ? 20
                                                  : 10,
                                              color: Colors.white))),
                                  TextButton(
                                      onPressed: () {
                                        _showModifyAlertDialog(
                                            repairList,
                                            discount,
                                            accompte,
                                            costumerName,
                                            phone,
                                            costumerAdress,
                                            repairUid,
                                            date,
                                            state,
                                            ticketNumber,
                                            emplacement);
                                      },
                                      child: Text(
                                        'Modifier',
                                        style: titleStyle.copyWith(
                                            fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height >
                                                    600
                                                ? 20
                                                : 10),
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => PdfCreator(
                                                    accompte: accompte,
                                                    isTicket: "A4",
                                                    documentValue: "Facture",
                                                    path: path,
                                                    url: url,
                                                    invoiceNumber: ticketNumber,
                                                    costumerAdress:
                                                        costumerAdress,
                                                    costumerName: costumerName,
                                                    costumerPhone: phone,
                                                    date:
                                                        pdfFormat.format(date),
                                                    payWay: '',
                                                    cart: repairList
                                                        .map((repair) => Article(
                                                            description: repair[
                                                                "description"],
                                                            article:
                                                                "${repair["part"]} ${repair["model"]}",
                                                            price:
                                                                repair["price"],
                                                            quantity: "1"))
                                                        .toList(),
                                                    total: total,
                                                    discount: discount)));
                                      },
                                      child: Text(
                                        "Voir",
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height >
                                                  600
                                              ? 20
                                              : 10,
                                        ),
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PaidLaonPage(
                                                      adress: costumerAdress,
                                                      debt: total.toString(),
                                                      description: repairList
                                                          .map((repair) =>
                                                              "${repair["part"]} ${repair["model"]}")
                                                          .join(", "),
                                                      name: costumerName,
                                                      phone: phone,
                                                      loanPaidUid: DateTime
                                                              .now()
                                                          .millisecondsSinceEpoch
                                                          .toString(),
                                                    )));
                                      },
                                      child: Text(
                                        "Crédit",
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height >
                                                  600
                                              ? 20
                                              : 10,
                                        ),
                                      ))
                                ],
                              ),
                            )),
                          ]),
                    ),
                  ));
            }));
  }

  _buildCard(color, background, text) {
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
                  fontSize: MediaQuery.of(context).size.height > 600 ? 17 : 8,
                )),
          ),
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
                          Navigator.pop(context),
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RepairAdder(
                                        date: date,
                                        discount: discount,
                                        accompte: accompte,
                                        state: state,
                                        ticketNumber: ticketNumber,
                                        emaplacement: emplacement,
                                        costumerPhone: phone,
                                        costumerAdress: adress,
                                        costumerName: name,
                                        repairUid: repairUid,
                                        repairList: repairList
                                            .map((repair) => Repair(
                                                description:
                                                    repair['description'],
                                                price: repair['price'],
                                                model: repair['model'],
                                                part: repair['part']))
                                            .toList(),
                                      )))
                        },
                    child: const Text('Ok'))
              ],
            ));
  }
}
