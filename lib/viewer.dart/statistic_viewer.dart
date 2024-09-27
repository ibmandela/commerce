import 'dart:io';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/foundation.dart';
import 'package:gestion_commerce_reparation/adders/paid_loan.dart';
import 'package:gestion_commerce_reparation/adders/quick_sell.dart';
import 'package:gestion_commerce_reparation/common/constant.dart';
import 'package:gestion_commerce_reparation/modeles/user.dart';
import 'package:gestion_commerce_reparation/services/bluetooth_printer.dart';
import 'package:gestion_commerce_reparation/services/firebase/company_database.dart';
import 'package:gestion_commerce_reparation/services/hive_database/boxes.dart';
import 'package:gestion_commerce_reparation/services/print_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

class StatViewerPage extends StatelessWidget {
  final bool isCostumerView;
  final String? costumerName;
  const StatViewerPage(
      {required this.isCostumerView, this.costumerName, super.key});

  @override
  Widget build(BuildContext context) {
    return StatViewer(
      isCostumerView: isCostumerView,
      costumerName: costumerName,
    );
  }
}

class StatViewer extends StatefulWidget {
  final bool isCostumerView;
  final String? costumerName;

  const StatViewer(
      {required this.isCostumerView, this.costumerName, super.key});

  @override
  State<StatViewer> createState() => _StatViewerState();
}

class _StatViewerState extends State<StatViewer> {
  final _now = DateTime.now();
  var week = DateTime.now().subtract(const Duration(days: 7));
  var month = DateTime.now().subtract(const Duration(days: 30));
  var year = DateTime.now().subtract(const Duration(days: 365));
  var format = DateFormat('HH:mm dd/MM/yyyy');
  String article = '';
  String price = '';
  String quantity = '';
  String? _searchCostumer;
  String? _searchArticle;
  DateTime? _searchDate;
  String? _searchTotal;
  String? _date;
  final _bluetooth = BlueThermalPrinter.instance;
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
                    Expanded(child: _buildSearchArticle()),
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
                    : _searchArticle != null
                        ? _buildByArticleList()
                        : _searchTotal != null
                            ? _buildByTotalList()
                            : _searchDate != null
                                ? _buildByDateList()
                                : _buildDateList(null),
                _buildDateList(DateTime(_now.year, _now.month, _now.day)),
                _buildDateList(week),
                _buildDateList(month),
              ]),
      ),
    );
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
            text: "Tous"),
        Tab(
            height: MediaQuery.of(context).size.height < 600 ? 20 : 60,
            iconMargin: const EdgeInsets.all(0),
            text: 'jour'),
        Tab(
            height: MediaQuery.of(context).size.height < 600 ? 20 : 60,
            iconMargin: const EdgeInsets.all(0),
            text: 'semaine'),
        Tab(
            height: MediaQuery.of(context).size.height < 600 ? 20 : 60,
            iconMargin: const EdgeInsets.all(0),
            text: "mois"),
      ],
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

  Widget _buildSearchArticle() {
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
                    'chercher article',
                    style: formTextStyle.copyWith(
                        fontSize:
                            MediaQuery.of(context).size.height > 600 ? 17 : 8),
                  ),
                  hintText: 'chercher article'),
              onChanged: (value) => setState(() {
                _searchArticle = value;
              }),
            )));
  }

  _buildByCostumerList() {
    return ValueListenableBuilder<Box<dynamic>>(
        valueListenable: ActivitiesBox.activitiesBox!.listenable(),
        builder: (context, box, widget1) {
          final data = box.values
              .where((activity) => activity["costumerName"]
                  .toString()
                  .toUpperCase()
                  .contains(_searchCostumer!.toUpperCase()))
              .map((activity) => Activity(
                  activityUid: activity["uid"],
                  ticketNumber: activity["ticketNumber"],
                  ticketDate: activity["date"],
                  phone: activity["phone"],
                  costumerName: activity["costumerName"],
                  costumerAdress: activity["costumerAdress"],
                  discount: activity["discount"],
                  payWay: activity["payWay"],
                  total: activity["total"].toDouble(),
                  isEstimate: activity["isEstimate"],
                  activityList: activity["activityList"]))
              .toList();

          return _buildList(data);
        });
  }

  _buildByArticleList() {
    return ValueListenableBuilder<Box<dynamic>>(
        valueListenable: ActivitiesBox.activitiesBox!.listenable(),
        builder: (context, box, widget1) {
          final data = box.values
              .where((activity) {
                Iterable cart = activity["activityList"]
                    .map((element) => element["article"]);
                return cart
                    .where((element) => element
                        .toUpperCase()
                        .contains(_searchArticle!.toUpperCase()))
                    .isNotEmpty;
              })
              .map((activity) => Activity(
                  activityUid: activity["uid"],
                  ticketNumber: activity["ticketNumber"],
                  ticketDate: activity["date"],
                  phone: activity["phone"],
                  costumerName: activity["costumerName"],
                  costumerAdress: activity["costumerAdress"],
                  discount: activity["discount"],
                  payWay: activity["payWay"],
                  total: activity["total"].toDouble(),
                  isEstimate: activity["isEstimate"],
                  activityList: activity["activityList"]))
              .toList();

          return _buildList(data);
        });
  }

  _buildByTotalList() {
    return ValueListenableBuilder<Box<dynamic>>(
        valueListenable: ActivitiesBox.activitiesBox!.listenable(),
        builder: (context, box, widget1) {
          final data = box.values
              .where((activity) => activity["total"]
                  .toDouble()
                  .toString()
                  .toUpperCase()
                  .contains(_searchTotal!.toUpperCase()))
              .map((activity) => Activity(
                  activityUid: activity["uid"],
                  ticketNumber: activity["ticketNumber"],
                  ticketDate: activity["date"],
                  phone: activity["phone"],
                  costumerName: activity["costumerName"],
                  costumerAdress: activity["costumerAdress"],
                  discount: activity["discount"],
                  payWay: activity["payWay"],
                  total: activity["total"].toDouble(),
                  isEstimate: activity["isEstimate"],
                  activityList: activity["activityList"]))
              .toList();

          return _buildList(data);
        });
  }

  _buildByDateList() {
    return ValueListenableBuilder<Box<dynamic>>(
        valueListenable: ActivitiesBox.activitiesBox!.listenable(),
        builder: (context, box, widget1) {
          final data = box.values
              .where((activity) => DateTime(activity["date"].year,
                      activity["date"].month, activity["date"].day)
                  .isAtSameMomentAs(DateTime(
                      _searchDate!.year, _searchDate!.month, _searchDate!.day)))
              .map((activity) => Activity(
                  activityUid: activity["uid"],
                  ticketNumber: activity["ticketNumber"],
                  ticketDate: activity["date"],
                  phone: activity["phone"],
                  costumerName: activity["costumerName"],
                  costumerAdress: activity["costumerAdress"],
                  discount: activity["discount"],
                  payWay: activity["payWay"],
                  total: activity["total"].toDouble(),
                  isEstimate: activity["isEstimate"],
                  activityList: activity["activityList"]))
              .toList();

          return _buildList(data);
        });
  }

  _buildDateList(time) {
    return ValueListenableBuilder<Box<dynamic>>(
        valueListenable: ActivitiesBox.activitiesBox!.listenable(),
        builder: (context, box, widget1) {
          List<Activity> data = box.values
              .where((activity) =>
                  time != null ? activity["date"].isAfter(time) : true)
              .map((activity) => Activity(
                  activityUid: activity["uid"],
                  ticketNumber: activity["ticketNumber"],
                  ticketDate: activity["date"],
                  phone: activity["phone"],
                  costumerName: activity["costumerName"],
                  costumerAdress: activity["costumerAdress"],
                  discount: activity["discount"],
                  payWay: activity["payWay"],
                  total: activity["total"].toDouble(),
                  isEstimate: activity["isEstimate"],
                  activityList: activity["activityList"]))
              .toList();
          // : box.values
          //     .map((activity) => {
          //           Activity(
          //               activityUid: activity["uid"],
          //               ticketNumber: activity["ticketNumber"],
          //               ticketDate: activity["date"],
          //               phone: activity["phone"],
          //               costumerName: activity["costumerName"],
          //               costumerAdress: activity["costumerAdress"],
          //               discount: activity["discount"],
          //               payWay: activity["payWay"],
          //               total: activity["total"].toDouble(),
          //               isEstimate: activity["isEstimate"],
          //               activityList: activity["activityList"])
          //         })
          //     .toList();

          return _buildList(data);
        });
  }

  _buildList(List<Activity> data) {
    data.sort((a, b) => b.ticketDate.compareTo(a.ticketDate));
    int totalItem = data.fold(0, (previousValue, element) => previousValue + 1);
    double totalPrice = data.fold(
        0.0, (previousValue, element) => previousValue + element.total);

    return Stack(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
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
                          'Total vente: ${NumberFormat.currency(locale: 'fr').format(totalPrice)}',
                          style: formTextStyle,
                        ),
                        Text(
                          'Nombre: ${totalItem.toString()}',
                          style: formTextStyle,
                        ),
                      ],
                    ));
              } else {
                return Card(
                  elevation: 10,
                  child: ExpansionTile(
                    leading: Text(format.format(data[index].ticketDate)),
                    title: Text(
                      '${data[index].ticketNumber} : ${data[index].costumerName}',
                      style: titleStyle.copyWith(
                          fontSize: MediaQuery.of(context).size.height > 600
                              ? 20
                              : 10),
                    ),
                    trailing: Text(
                      '${data[index].total}',
                      style: titleStyle.copyWith(
                          fontSize: MediaQuery.of(context).size.height > 600
                              ? 20
                              : 10),
                    ),
                    children: [
                      Center(
                          child: _buildArticleList(data[index].activityList)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                              onPressed: () async {
                                var pdf = PdfCreator(
                                  accompte: "",
                                  isTicket: "A4",
                                  url: url,
                                  path: path,
                                  documentValue: data[index].isEstimate
                                      ? "Facture"
                                      : "Devis",
                                  costumerAdress: data[index].costumerAdress!,
                                  costumerName: '${data[index].costumerName}',
                                  costumerPhone: '${data[index].phone}',
                                  payWay: "${data[index].payWay}",
                                  invoiceNumber: "${data[index].ticketNumber}",
                                  total: data[index].total,
                                  date: format.format(data[index].ticketDate),
                                  discount: '${data[index].discount}',
                                  cart: data[index]
                                      .activityList
                                      .map((article) => Article(
                                          article: article["article"],
                                          description: article["description"],
                                          price: article["price"],
                                          quantity: article["quantity"]))
                                      .toList(),
                                ).generatePdf(context);
                                await Printing.layoutPdf(onLayout: (_) => pdf);
                              },
                              child: Text(
                                'Facture A4',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height > 600
                                            ? 17
                                            : 8),
                              )),
                          kIsWeb || Platform.isWindows
                              ? TextButton(
                                  onPressed: () async {
                                    var pdf = PdfCreator(
                                      accompte: "",
                                      isTicket: "TICKET",
                                      url: url,
                                      path: path,
                                      documentValue: "Ticket",
                                      costumerAdress:
                                          data[index].costumerAdress!,
                                      costumerName:
                                          '${data[index].costumerName}',
                                      costumerPhone: '${data[index].phone}',
                                      payWay: "${data[index].payWay}",
                                      invoiceNumber:
                                          "${data[index].ticketNumber}",
                                      total: data[index].total,
                                      date:
                                          format.format(data[index].ticketDate),
                                      discount: '${data[index].discount}',
                                      cart: data[index]
                                          .activityList
                                          .map((article) => Article(
                                              article: article["article"],
                                              description:
                                                  article["description"],
                                              price: article["price"],
                                              quantity: article["quantity"]))
                                          .toList(),
                                    ).generatePdf(context);
                                    await Printing.layoutPdf(
                                        onLayout: (_) => pdf);
                                  },
                                  child: Text(
                                    'Ticket',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.height >
                                                    600
                                                ? 17
                                                : 8),
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
                                        onPressed: () {
                                          if (isConnected) {
                                            PrintTicket().printTicket(
                                                data[index].ticketDate,
                                                data[index]
                                                    .activityList
                                                    .map((article) => Article(
                                                        article:
                                                            article["article"],
                                                        description: article[
                                                            "description"],
                                                        price: article["price"],
                                                        quantity: article[
                                                            "quantity"]))
                                                    .toList(),
                                                double.parse(price),
                                                data[index].ticketNumber,
                                                data[index].ticketNumber,
                                                data[index].costumerName,
                                                data[index].costumerAdress,
                                                data[index].phone,
                                                data[index].payWay,
                                                '0');
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const BluetoothPrinter()));
                                          }
                                        },
                                        child: Text(
                                          "Ticket",
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                          .size
                                                          .height >
                                                      600
                                                  ? 17
                                                  : 8),
                                        ));
                                  }),
                          TextButton(
                              onPressed: () {
                                _showModifyAlertDialog(
                                    data[index].activityList,
                                    data[index].discount,
                                    data[index].costumerName,
                                    data[index].phone,
                                    data[index].costumerAdress,
                                    data[index].activityUid,
                                    data[index].ticketDate,
                                    data[index].ticketNumber,
                                    data[index].isEstimate,
                                    data[index].payWay);
                              },
                              child: Text(
                                'Modifier',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize:
                                        MediaQuery.of(context).size.height > 600
                                            ? 17
                                            : 8),
                              )),
                          TextButton(
                              onPressed: () {
                                _showDeleteAlertDialog(data[index].activityUid);
                              },
                              child: Text(
                                'Supprimer',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize:
                                        MediaQuery.of(context).size.height > 600
                                            ? 17
                                            : 8),
                              )),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PdfCreator(
                                              accompte: "",
                                              isTicket: "A4",
                                              url: url,
                                              path: path,
                                              documentValue:
                                                  data[index].isEstimate
                                                      ? "Facture"
                                                      : "Devis",
                                              costumerAdress:
                                                  data[index].costumerAdress!,
                                              costumerName:
                                                  '${data[index].costumerName}',
                                              costumerPhone:
                                                  '${data[index].phone}',
                                              payWay: "${data[index].payWay}",
                                              invoiceNumber:
                                                  "${data[index].ticketNumber}",
                                              total: data[index].total,
                                              date: format.format(
                                                  data[index].ticketDate),
                                              discount:
                                                  '${data[index].discount}',
                                              cart: data[index]
                                                  .activityList
                                                  .map((article) => Article(
                                                      article:
                                                          article["article"],
                                                      description: article[
                                                          "description"],
                                                      price: article["price"],
                                                      quantity:
                                                          article["quantity"]))
                                                  .toList(),
                                            )));
                              },
                              child: Text("Voir",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height >
                                                  600
                                              ? 17
                                              : 8))),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PaidLaonPage(
                                              adress:
                                                  data[index].costumerAdress,
                                              debt:
                                                  data[index].total.toString(),
                                              description: data[index]
                                                  .activityList
                                                  .map((activity) =>
                                                      "${activity["article"]}")
                                                  .join(", "),
                                              name: data[index].costumerName,
                                              phone: data[index].phone,
                                              loanPaidUid: DateTime.now()
                                                  .millisecondsSinceEpoch
                                                  .toString(),
                                            )));
                              },
                              child: Text(
                                "Crédit",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height > 600
                                            ? 17
                                            : 8),
                              ))
                        ],
                      )
                    ],
                  ),
                );
              }
            }),
      ),
      if (MediaQuery.of(context).size.height > 600 &&
          widget.isCostumerView == false)
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.blue, width: 5),
                  borderRadius: const BorderRadius.all(Radius.circular(30))),
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
                    'Nombre: ${totalItem.toString()}',
                    style: formTextStyle,
                  ),
                ],
              )),
        ),
    ]);
  }

  _buildArticleList(List list) {
    return ListView(
      shrinkWrap: true,
      children: list
          .map((article) => InkWell(
                onTap: () {
                  setState(() {
                    price = article["price"];
                    quantity = article['quantity'];
                    article = article['article'];
                  });
                },
                child: Row(
                  children: [
                    Text("${article['quantity']}",
                        style: listTextStyle.copyWith(
                            fontSize: MediaQuery.of(context).size.height > 600
                                ? 17
                                : 8)),
                    const SizedBox(
                      width: 10,
                    ),
                    Text("${article['article']}",
                        style: listTextStyle.copyWith(
                            fontSize: MediaQuery.of(context).size.height > 600
                                ? 17
                                : 8)),
                    const SizedBox(
                      width: 10,
                    ),
                    Text("${article['price']}",
                        style: listTextStyle.copyWith(
                            fontSize: MediaQuery.of(context).size.height > 600
                                ? 17
                                : 8)),
                  ],
                ),
              ))
          .toList(),
    );
  }

  _showDeleteAlertDialog(String? activityUid) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Attention...'),
              content: const Text(
                  'Vous êtes sur le point de supprimer une activité. Etes vous sures?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annuler')),
                TextButton(
                    onPressed: () => {
                          CompanyDatabase(userUid: userUid)
                              .deleteActivity(activityUid, context),
                          Navigator.pop(context),
                        },
                    child: const Text('Ok'))
              ],
            ));
  }

  _showModifyAlertDialog(List activityList, discount, name, phone, adress,
      activityUid, date, ticketNumber, isEstimate, payWay) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Attention...'),
              content: const Text('Voulez vous modifier cette vente ?'),
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
                                  builder: (context) => QuickSell(
                                      discount: discount,
                                      ticketDate: date,
                                      tikectNumber: ticketNumber,
                                      payWay: payWay,
                                      phone: phone,
                                      adress: adress,
                                      name: name,
                                      activityUid: activityUid,
                                      activityList: activityList
                                          .map((repair) => Article(
                                              description:
                                                  repair['description'],
                                              price: repair['price'],
                                              article: repair['article'],
                                              quantity: repair['quantity']))
                                          .toList()))),
                        },
                    child: const Text('Oui'))
              ],
            ));
  }
}
