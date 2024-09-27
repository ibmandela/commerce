import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:gestion_commerce_reparation/adders/add_article.dart';
import 'package:gestion_commerce_reparation/adders/categorie_adder.dart';
import 'package:gestion_commerce_reparation/adders/repair_adder.dart';
import 'package:gestion_commerce_reparation/common/constant.dart';
import 'package:gestion_commerce_reparation/modeles/user.dart';
import 'package:gestion_commerce_reparation/services/firebase/company_database.dart';
import 'package:gestion_commerce_reparation/services/costumer_class.dart';
import 'package:gestion_commerce_reparation/services/hive_database/boxes.dart';
import 'package:gestion_commerce_reparation/services/print_service.dart';
import 'package:gestion_commerce_reparation/viewer.dart/statistic_viewer.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import '../services/bluetooth_printer.dart';

class QuickSellPage extends StatelessWidget {
  final String? tikectNumber,
      phone,
      name,
      adress,
      discount,
      payWay,
      activityUid;
  final DateTime? ticketDate;
  final List<Article>? activityList;
  final bool? isEstimate;
  final double? total;

  const QuickSellPage({
    super.key,
    this.activityUid,
    this.activityList,
    this.adress,
    this.discount,
    this.isEstimate,
    this.name,
    this.payWay,
    this.phone,
    this.tikectNumber,
    this.ticketDate,
    this.total,
  });

  @override
  Widget build(BuildContext context) {
    return QuickSell(
      isEstimate: isEstimate,
      activityList: activityList,
      name: name,
      activityUid: activityUid,
      adress: adress,
      phone: phone,
      discount: discount,
      payWay: payWay,
      ticketDate: ticketDate,
      tikectNumber: tikectNumber,
    );
  }
}

class QuickSell extends StatefulWidget {
  final String? activityUid,
      tikectNumber,
      phone,
      name,
      adress,
      discount,
      payWay;
  final DateTime? ticketDate;
  final List<Article>? activityList;
  final bool? isEstimate;
  final double? total;

  const QuickSell(
      {this.activityUid,
      this.activityList,
      this.adress,
      this.discount,
      this.isEstimate,
      this.name,
      this.payWay,
      this.phone,
      this.tikectNumber,
      this.ticketDate,
      this.total,
      super.key});

  @override
  State<QuickSell> createState() => _QuickSellState();
}

class _QuickSellState extends State<QuickSell> {
  final _nameControler = TextEditingController();
  final _adressControler = TextEditingController();
  final _phoneControler = TextEditingController();
  final _priceControler = TextEditingController();
  final _discountControler = TextEditingController();
  final _articleControler = TextEditingController();
  final _descriptionContoler = TextEditingController();
  var _date = DateTime.now();

  final _invoiceDate = DateFormat('ddMMyy').format(DateTime.now());

  final _randomNumber = Random().nextInt(100);

  String _payWay = 'Paiement en espèce';
  String _documentValue = 'Facture';

  bool _phoneIsNull = false;
  bool _chooseCostumer = false;
  bool _boolPayWay = false;
  bool _isEstimate = false;
  bool _boolDocument = false;
  bool _addDescription = false;
  bool _addDiscount = false;
  bool _addDate = false;

  String? _categorie;
  String? _searchPhone;
  var _price = '';
  final _articleFormKey = GlobalKey<FormState>();
  final _costumerFormKey = GlobalKey<FormState>();

  List<Article> _activities = [];
  List<Product> productData = [];
  final _bluetooth = BlueThermalPrinter.instance;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    if (widget.activityUid != null) {
      _nameControler.text = '${widget.name}';
      _phoneControler.text = '${widget.phone}';
      _adressControler.text = '${widget.adress}';
      _discountControler.text = '${widget.discount}';
      _activities = widget.activityList ?? [];
      _payWay = '${widget.payWay}';
      _date = widget.ticketDate ?? DateTime.now();
    }
    super.initState();
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
              Expanded(child: _buildArticle()),
              Expanded(child: _buildPrice()),
              Expanded(child: _buildFormDescription()),
              _buildAddTocart()
            ]),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RepairAdderPage()))
                        .then((value) => Navigator.pop(context));
                  },
                  icon: const Icon(Icons.home_repair_service)),
              IconButton(
                icon: const Icon(Icons.person_add_rounded),
                onPressed: () {
                  setState(() {
                    _chooseCostumer = !_chooseCostumer;
                  });
                },
              )
            ],
          ),
        ),
        body: _buildBody());
  }

  _buildBody() {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                  flex: MediaQuery.of(context).size.height > 600 ? 3 : 2,
                  child: _buildCategorieGrid()),
              if (!_addDiscount && !_addDescription && !_addDate)
                Expanded(flex: 2, child: _buildBouttons())
              else
                Expanded(flex: 2, child: _buildTextField())
            ],
          ),
        ),
        Expanded(
          flex: MediaQuery.of(context).size.height > 600 ? 3 : 2,
          child: Row(
            children: [
              Expanded(flex: 3, child: _buildArticleGrid()),
              _chooseCostumer
                  ? Expanded(flex: 2, child: _buildCostumer())
                  : _activities.isNotEmpty
                      ? Expanded(flex: 2, child: _buildOrder())
                      : Expanded(flex: 2, child: _buildActivityList())
            ],
          ),
        ),
      ],
    );
  }

  // _buildSmallBody() {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: Column(
  //           children: [
  //             Expanded(child: _buildCategorieGrid()),
  //             Expanded(flex: 2, child: _buildArticleGrid()),
  //           ],
  //         ),
  //       ),
  //       Expanded(
  //         // flex: 3,
  //         child: Column(
  //           children: [
  //             if (!_addDiscount && !_addDescription && !_addDate)
  //               Expanded(child: _buildBouttons())
  //             else
  //               Expanded(child: _buildTextField()),
  //             _chooseCostumer
  //                 ? Expanded(child: _buildCostumer())
  //                 : _activities.isNotEmpty
  //                     ? Expanded(child: _buildOrder())
  //                     : Expanded(child: _buildActivityList())
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  _buildArticleGrid() {
    return ValueListenableBuilder<Box<dynamic>>(
        valueListenable: ArticleBox.articleBox!.listenable(),
        builder: (context, box, widget1) {
          productData = _categorie != null
              ? box.values
                  .where((product) => product["categorie"] == _categorie)
                  .map((product) => Product(
                      uid: product["uid"],
                      categorie: product["categorie"],
                      price: product["price"],
                      article: product["article"]))
                  .toList()
              : box.values
                  .map((product) => Product(
                      uid: product["uid"],
                      categorie: product["categorie"],
                      price: product["price"],
                      article: product["article"]))
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
                      itemCount: productData.length,
                      itemBuilder: (context, index) {
                        return GridTile(
                            child: InkWell(
                                onLongPress: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ArticleAdderPage(
                                                article:
                                                    productData[index].article,
                                                articleUid:
                                                    productData[index].uid,
                                                categorie: productData[index]
                                                    .categorie,
                                                price: productData[index].price,
                                              )));
                                },
                                onTap: () {
                                  setState(() {
                                    _categorie = productData[index].categorie;
                                    _activities.add(Article(
                                        quantity: '1',
                                        price: productData[index].price,
                                        article: productData[index].article,
                                        description: ''));
                                    _price = '${productData[index].price}';
                                    _articleControler.text =
                                        '${productData[index].article}';
                                    _priceControler.text =
                                        '${productData[index].price}';
                                  });
                                },
                                child: _buidCard(Colors.blue, Colors.white,
                                    '${productData[index].article}\n${NumberFormat.currency(locale: 'fr', symbol: "€").format(double.parse('${productData[index].price}'))}')));
                      })),
              if (MediaQuery.of(context).size.height > 600)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      heroTag: "btn1",
                      backgroundColor:
                          _categorie != null ? Colors.blue : Colors.grey,
                      child: const Icon(
                        Icons.add,
                      ),
                      onPressed: () {
                        if (_categorie != null) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ArticleAdderPage(
                                        categorie: _categorie,
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

  _buildCategorieGrid() {
    return ValueListenableBuilder<Box<dynamic>>(
        valueListenable: CategoriesBox.categoriesBox!.listenable(),
        builder: (context, box, widget1) {
          var categorieData = box.values
              .map((categorie) => Categorie(
                  uid: categorie["uid"], categorie: categorie["categorie"]))
              .toList();
          return Stack(
            children: [
              SizedBox(
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              MediaQuery.of(context).size.height > 600 ? 6 : 4,
                          childAspectRatio: 3),
                      itemCount: categorieData.length,
                      itemBuilder: (context, index) {
                        return GridTile(
                            child: InkWell(
                                onLongPress: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CategorieAdderPage(
                                                categorieUid:
                                                    categorieData[index].uid,
                                                categorie: categorieData[index]
                                                    .categorie,
                                              )));
                                },
                                onTap: () {
                                  setState(() {
                                    _categorie =
                                        '${categorieData[index].categorie}';
                                  });
                                },
                                child: _buidCard(Colors.white, Colors.blue,
                                    categorieData[index].categorie)));
                      })),
              if (MediaQuery.of(context).size.height > 600)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      heroTag: "btn2",
                      child: const Icon(Icons.add),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CategorieAdderPage()));
                      },
                    ),
                  ),
                )
            ],
          );
        });
  }

  _buildOrder() {
    int totalArticle = _activities.fold(
        0,
        (previousValue, element) =>
            previousValue + int.parse('${element.quantity}'));
    double total = _activities.fold(
        0.0,
        (previousValue, element) =>
            previousValue + double.parse('${element.price}'));
    return SizedBox(
      child: Column(
        children: [
          Expanded(
              child: Text('Ticket : $_invoiceDate$_randomNumber',
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
                itemCount: _activities.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            MediaQuery.of(context).size.height > 600 ? 8.0 : 5,
                        vertical:
                            MediaQuery.of(context).size.height > 600 ? 5 : 0),
                    child: GestureDetector(
                      onLongPress: () =>
                          _deleteActivityAlerteDialog(_activities[index]),
                      child: Column(children: [
                        Row(children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height > 600
                                ? 40
                                : 23,
                            child: DropdownButton<String>(
                              underline: const Visibility(
                                visible: false,
                                child: Icon(Icons.ac_unit),
                              ),
                              value: _activities[index].quantity,
                              elevation: 16,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _activities[index].quantity = newValue!;
                                  _activities[index].price =
                                      (double.parse(_price) *
                                              int.parse(newValue))
                                          .toString();
                                });
                              },
                              items: <String>[
                                '1',
                                '2',
                                '3',
                                '4',
                                '6',
                                '7',
                                '8',
                                '9',
                                '10',
                                '11',
                                '12',
                                '13',
                                '14',
                                '16',
                                '17',
                                '18',
                                '19',
                                '20',
                                '21',
                                '22',
                                '23',
                                '24',
                                '25',
                                '26',
                                '27',
                                '28',
                                '29',
                                '30',
                                '31',
                                '32',
                                '33',
                                '34',
                                '35',
                                '36',
                                '37',
                                '38',
                                '39',
                                '40',
                                '41',
                                '42',
                                '43',
                                '45',
                                '44',
                                '46',
                                '47',
                                '48',
                                '49',
                                '50'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: listItem.copyWith(
                                        fontSize:
                                            MediaQuery.of(context).size.height >
                                                    600
                                                ? 14
                                                : 7),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          Expanded(
                              flex: 6,
                              child: Text(
                                '${_activities[index].article}',
                                style: listItem.copyWith(
                                    fontSize:
                                        MediaQuery.of(context).size.height > 600
                                            ? 14
                                            : 7),
                              )),
                          Expanded(
                              flex: 2,
                              child: Text('${_activities[index].price}€',
                                  style: listItem.copyWith(
                                      fontSize:
                                          MediaQuery.of(context).size.height >
                                                  600
                                              ? 14
                                              : 7)))
                        ]),
                        if (_activities[index].description != '')
                          Text('${_activities[index].description}')
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
                    "Nombre d'article : $totalArticle    Total : $total€",
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
        valueListenable: ActivitiesBox.activitiesBox!.listenable(),
        builder: (context, box, child) {
          final activityData = box.values
              .where((activity) => activity["date"]
                  .isAfter(DateTime.now().subtract(const Duration(days: 1))))
              .map((activity) => Activity(
                  activityUid: activity["activityUid"],
                  ticketNumber: activity["ticketNumber"],
                  ticketDate: activity["date"],
                  phone: activity["phone"],
                  costumerName: activity["costumerName"],
                  costumerAdress: activity["costumerAdress"],
                  discount: activity["discount"],
                  payWay: activity["payWay"],
                  total: activity["total"],
                  isEstimate: activity["isEstimate"],
                  activityList: activity["activityList"]))
              .toList();
          double totalSell = activityData.fold(
              0.0, (previousValue, element) => previousValue + element.total);
          activityData.sort((a, b) => b.ticketDate.compareTo(a.ticketDate));
          return SizedBox(
            child: Column(children: [
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Ventes du jour',
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
                                builder: (context) => const StatViewerPage(
                                      isCostumerView: false,
                                    )));
                      },
                      child: Text(
                        "Voir tous",
                        style: subtitle.copyWith(
                            fontSize: MediaQuery.of(context).size.height > 600
                                ? 15
                                : 9),
                      ))
                ],
              )),
              Expanded(
                  flex: 6,
                  child: ListView.builder(
                      itemCount: activityData.length,
                      itemBuilder: (context, index) {
                        return _buildExpansionTile(
                            activityData[index].activityList,
                            activityData[index].activityUid,
                            activityData[index].ticketNumber,
                            activityData[index].total,
                            activityData[index].ticketDate,
                            activityData[index].costumerName,
                            activityData[index].costumerAdress,
                            activityData[index].phone,
                            activityData[index].payWay,
                            activityData[index].discount,
                            activityData[index].isEstimate);
                      })),
              if (MediaQuery.of(context).size.height > 600)
                Expanded(
                  child: Container(
                      decoration: boxdecoration,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'Vente du jour : ${totalSell.toString()}€',
                          style: titleStyle,
                        ),
                      )),
                )
            ]),
          );
        });
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

  Widget _buildArticle() {
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
                  'Article',
                  style: formTextStyle.copyWith(
                      fontSize:
                          MediaQuery.of(context).size.height > 600 ? 17 : 8),
                ),
                hintText: 'Article'),
            controller: _articleControler,
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

  Widget _buildPrice() {
    return SizedBox(
        height: MediaQuery.of(context).size.height > 600 ? 50 : 30,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextFormField(
            keyboardType: TextInputType.phone,
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "verifier ce champ";
              } else {
                return null;
              }
            },
          ),
        ));
  }

  Widget _buildFormDescription() {
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
                  'Descrption',
                  style: formTextStyle.copyWith(
                      fontSize:
                          MediaQuery.of(context).size.height > 600 ? 17 : 8),
                ),
                hintText: 'Description'),
            controller: _descriptionContoler,
          ),
        ));
  }

  Widget _buildDiscount() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      autocorrect: false,
      decoration: textInputDecoration.copyWith(
          label: const Text(
            'Réduction',
            style: formTextStyle,
          ),
          hintText: 'Réduction'),
      controller: _discountControler,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Verifier ce champ";
        } else {
          return null;
        }
      },
    );
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
    return SizedBox(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(children: [
            Expanded(child: _buildDoubleCancelButton()),
            Expanded(child: _buildDoubleDoneButton())
          ]),
          const SizedBox(
            height: 10,
          ),
          if (_addDescription)
            Text('Ajouter une description', style: titleStyle),
          if (_addDate) Text('Modififier la date', style: titleStyle),
          if (_addDiscount)
            Text(
              'Ajouter une Réduction',
              style: titleStyle,
            ),
          const SizedBox(
            height: 5,
          ),
          if (_addDescription) Expanded(child: _buildFormDescription()),
          if (_addDate) Expanded(child: _buildDate()),
          if (_addDiscount) Expanded(child: _buildDiscount()),
        ],
      ),
    );
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

  _buildBouttons() {
    return SizedBox(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildDoneButton()),
              const SizedBox(
                width: 4,
              ),
              Expanded(child: _buildCancelButton()),
              const SizedBox(
                width: 4,
              ),
              Expanded(child: _buildAddButton()),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildPayWayButton()),
              const SizedBox(
                width: 4,
              ),
              Expanded(child: _buildDocumentButton())
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildPrintButton()),
              const SizedBox(
                width: 4,
              ),
              Expanded(child: _buildTicketButton())
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildDescriptionButton()),
              const SizedBox(
                width: 4,
              ),
              Expanded(child: _buildDiscountButton()),
              const SizedBox(
                width: 4,
              ),
              Expanded(child: _buildDateButton())
            ],
          ),
        )
      ],
    ));
  }

  Widget _buildPayWayButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2))),
          backgroundColor: !_boolPayWay ? Colors.blue : Colors.green,
        ),
        onPressed: () {
          if (_boolPayWay) {
            setState(() {
              _payWay = 'Paiement en espèce';
              _boolPayWay = false;
            });
          } else {
            setState(() {
              _payWay = 'Paiement par carte blue';
              _boolPayWay = true;
            });
          }
        },
        child: Text(_payWay,
            style: buttonText.copyWith(
                fontSize: MediaQuery.of(context).size.height > 600 ? 16 : 10)));
  }

  Widget _buildDocumentButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2))),
          backgroundColor: !_boolDocument ? Colors.blue : Colors.green,
        ),
        onPressed: () {
          if (_boolDocument) {
            setState(() {
              _documentValue = 'Facture';
              _boolDocument = false;
            });
          } else {
            setState(() {
              _documentValue = 'Devis';
              _boolDocument = true;
              _isEstimate = true;
            });
          }
        },
        child: Text(_documentValue,
            style: buttonText.copyWith(
                fontSize: MediaQuery.of(context).size.height > 600 ? 16 : 10)));
  }

  Widget _buildAddDoneButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
        ),
        onPressed: () {
          if (_articleFormKey.currentState!.validate()) {
            setState(() {
              _activities.add(Article(
                  article: _articleControler.value.text,
                  price: _priceControler.value.text
                      .replaceAll(",", ".")
                      .replaceAll(" ", ""),
                  description: _descriptionContoler.value.text,
                  quantity: '1'));
            });
            Navigator.pop(context);
            _articleControler.clear();
            _priceControler.clear();
            _descriptionContoler.clear();
          }
        },
        child: Text("Valider",
            style: buttonText.copyWith(
                fontSize: MediaQuery.of(context).size.height > 600 ? 16 : 10)));
  }

  Widget _buildPrintButton() {
    double total = _activities.fold(
        0,
        (previousValue, element) =>
            previousValue + double.parse('${element.price}'));
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2))),
          backgroundColor: _activities.isNotEmpty ? Colors.blue : Colors.grey,
        ),
        onPressed: () {
          if (_activities.isNotEmpty) {
            if (_nameControler.value.text != '') {
              setState(() {});
              _submit(total);
              _submitPrint(total);
            } else {
              _showCostumerAlertDialog();
            }
          }
        },
        child: Text("Imprimer",
            style: buttonText.copyWith(
                fontSize: MediaQuery.of(context).size.height > 600 ? 16 : 10)));
  }

  Widget _buildAddCancelButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
        ),
        onPressed: () {
          Navigator.pop(context);
          _articleControler.clear();
          _priceControler.clear();
          _descriptionContoler.clear();
        },
        child: Text("Annuler",
            style: buttonText.copyWith(
                fontSize: MediaQuery.of(context).size.height > 600 ? 16 : 10)));
  }

  Widget _buildAddButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2))),
          backgroundColor: Colors.blue,
        ),
        onPressed: () => _showAddArticleDialogue(),
        child: Text("Autre article",
            style: buttonText.copyWith(
                fontSize: MediaQuery.of(context).size.height > 600 ? 16 : 8)));
  }

  Widget _buildDoneButton() {
    double total = _activities.fold(
        0,
        (previousValue, element) =>
            previousValue + double.parse('${element.price}'));
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2))),
          backgroundColor: _activities.isNotEmpty ? Colors.blue : Colors.grey,
        ),
        onPressed: () {
          if (_activities.isNotEmpty) {
            setState(() {
              _submit(total);
            });
          }
        },
        child: Text("Valider",
            style: buttonText.copyWith(
                fontSize: MediaQuery.of(context).size.height > 600 ? 16 : 10)));
  }

  Widget _buildAddCostumerButton() {
    return ElevatedButton(
        onPressed: () {
          if (_costumerFormKey.currentState!.validate()) {
            setState(() {
              CostumerBox.costumerBox!.put(_phoneControler.value.text, {
                "name": _nameControler.value.text,
                "phone": _phoneControler.value.text,
                "adress": _adressControler.value.text,
                "uid": _phoneControler.value.text
              });

              CostumerDatabase().addCostumer(
                  _nameControler.value.text,
                  _adressControler.value.text,
                  _phoneControler.value.text,
                  context);
            });
          }
          _chooseCostumer = false;
          _phoneIsNull = false;
        },
        child: Text("Ajouter le contact", style: buttonText));
  }

  Widget _buildCancelButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2))),
          backgroundColor: _activities.isNotEmpty ? Colors.red : Colors.grey,
        ),
        onPressed: () {
          if (_activities.isNotEmpty) {
            setState(() {
              _activities.clear();
              _phoneControler.clear();
              _nameControler.clear();
              _adressControler.clear();
              _activities.clear();
              _discountControler.clear();
              _descriptionContoler.clear();
              _date = DateTime.now();
            });
          }
        },
        child: Text("Annuler",
            style: buttonText.copyWith(
                fontSize: MediaQuery.of(context).size.height > 600 ? 16 : 10)));
  }

  Widget _buildTicketButton() {
    List<Article> list = _activities;
    double total = _activities.fold(
        0,
        (previousValue, element) =>
            previousValue + double.parse('${element.price}'));
    return kIsWeb || Platform.isWindows
        ? ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2))),
                backgroundColor:
                    _activities.isNotEmpty ? Colors.blue : Colors.grey,
                textStyle: textStyle),
            onPressed: () async {
              if (_activities.isNotEmpty) {
                setState(() {});
                _submit(total);
                var pdf = PdfCreator(
                  accompte: "",
                  isTicket: "TICKET",
                  documentValue: "Ticket",
                  path: path,
                  url: url,
                  costumerAdress: _adressControler.value.text,
                  costumerName: _nameControler.value.text,
                  costumerPhone: _phoneControler.value.text,
                  payWay: _payWay,
                  invoiceNumber: '$_invoiceDate$_randomNumber',
                  total: total,
                  date: DateFormat('HH:mm dd/MM/yyyy').format(_date),
                  discount: _discountControler.value.text
                      .replaceAll(",", ".")
                      .replaceAll(" ", ""),
                  cart: _activities,
                ).generatePdf(context);
                await Printing.layoutPdf(onLayout: (_) => pdf);
              }
            },
            child: Text(
              "Ticket",
              style: buttonText.copyWith(
                  fontSize: MediaQuery.of(context).size.height > 600 ? 16 : 10),
            ))
        : FutureBuilder<bool?>(
            future: _bluetooth.isConnected,
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
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2))),
                      backgroundColor: _activities.isNotEmpty && isConnected
                          ? Colors.blue
                          : Colors.grey,
                      textStyle: textStyle),
                  onPressed: () {
                    if (isConnected) {
                      if (_activities.isNotEmpty) {
                        setState(() {
                          _submit(total);
                          _submitTicket(total, list);
                        });
                      }
                    } else {
                      _showBluetoothAlertDialog();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BluetoothPrinter()));
                    }
                  },
                  child: Text(isConnected ? "Ticket" : "aucune imprimante"));
            });
  }

  Widget _buildDiscountButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(2))),
            backgroundColor:
                _activities.isNotEmpty ? Colors.blue : Colors.grey),
        onPressed: () {
          if (_activities.isNotEmpty) {
            setState(() {
              _addDiscount = true;
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
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(2))),
            backgroundColor:
                _activities.isNotEmpty ? Colors.blue : Colors.grey),
        onPressed: () {
          if (_activities.isNotEmpty) {
            setState(() {
              _addDescription = true;
            });
          }
        },
        child: Text("Description",
            style: buttonText.copyWith(
                fontSize: MediaQuery.of(context).size.height > 600 ? 16 : 8)));
  }

  Widget _buildDateButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(2))),
            backgroundColor:
                _activities.isNotEmpty ? Colors.blue : Colors.grey),
        onPressed: () {
          if (_activities.isNotEmpty) {
            setState(() {
              _addDate = true;
            });
          }
        },
        child: Text("Nouvelle date",
            style: buttonText.copyWith(
                fontSize: MediaQuery.of(context).size.height > 600 ? 16 : 7)));
  }

  Widget _buildDoubleCancelButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        onPressed: () {
          setState(() {
            _addDescription = false;
            _addDiscount = false;
            _addDate = false;
            _descriptionContoler.clear();
            _discountControler.clear();
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
            _addDescription = false;
            _addDiscount = false;
            _addDate = false;
            _descriptionContoler.clear();
          });
        },
        child: Text(
          "Valider",
          style: buttonText.copyWith(
              fontSize: MediaQuery.of(context).size.height > 600 ? 16 : 10),
        ));
  }

  _buildAddTocart() {
    Iterable articles =
        productData.map((product) => product.article!.toUpperCase());
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
        ),
        child: const Text('Valider', style: TextStyle(color: Colors.blue)),
        onPressed: () {
          if (_articleControler.value.text != '') {
            setState(() {
              var newPrice = _priceControler.value.text == ''
                  ? '0'
                  : _priceControler.value.text
                      .replaceAll(",", ".")
                      .replaceAll(" ", "");

// permet à l'utilisateur d'ajouter un nouveau produit ou de le modifier s'il existe deja
              if (articles
                  .contains(_articleControler.value.text.toUpperCase())) {
                Product product = productData.firstWhere((product) =>
                    product.article!.toUpperCase() ==
                    _articleControler.value.text.toUpperCase());
                if (product.price!.toUpperCase() != newPrice.toUpperCase()) {
                  _showModifyArticleDialog(false, newPrice);
                } else {
                  if (_activities.isNotEmpty &&
                      _activities.last.article ==
                          _articleControler.value.text) {
                    // Permet de rajouter le l'article au panier de commande du client en dernière position.
                    _activities.last = Article(
                        quantity: "1",
                        article: _articleControler.value.text,
                        price: newPrice,
                        description: _descriptionContoler.text);
                  } else {
                    _activities.add(Article(
                        quantity: "1",
                        article: _articleControler.value.text,
                        price: newPrice,
                        description: _descriptionContoler.value.text));
                  }
                }
              } else {
                _showModifyArticleDialog(true, newPrice);
              }
            });
          }
        });
  }

// Dialogue pour permettre de modifier ou ajouté un article
  _showModifyArticleDialog(isToAdd, newPrice) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Attention...'),
              content: Text(isToAdd
                  ? "Voulez vous ajouter cet article ?"
                  : 'Voulez vous modifier  cet article ?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (_activities.isNotEmpty &&
                          _activities.last.article ==
                              _articleControler.value.text) {
                        // Permet de rajouter le l'article au panier de commande du client en dernière position.
                        _activities.last = Article(
                            quantity: "1",
                            article: _articleControler.value.text,
                            price: newPrice,
                            description: _descriptionContoler.text);
                      } else {
                        _activities.add(Article(
                            quantity: "1",
                            article: _articleControler.value.text,
                            price: newPrice,
                            description: _descriptionContoler.value.text));
                      }
                      setState(() {
                        _articleControler.clear();
                        _priceControler.clear();
                        _descriptionContoler.clear();
                      });
                    },
                    child: const Text('Non')),
                TextButton(
                    onPressed: () {
                      // Lorsque la categorie etait vide, on ajoute un nouvel article dans le cas contraire on modifie l'article
                      if (!isToAdd) {
                        CompanyDatabase(userUid: userUid)
                            .addProduct(
                              _articleControler.value.text,
                              _priceControler.value.text
                                  .replaceAll(",", '.')
                                  .replaceAll(" ", ""),
                              _categorie,
                            )
                            .then((value) => Navigator.pop(context));
                        if (_activities.isNotEmpty &&
                            _activities.last.article ==
                                _articleControler.value.text) {
                          // Permet de rajouter le l'article au panier de commande du client en dernière position.
                          _activities.last = Article(
                              quantity: "1",
                              article: _articleControler.value.text,
                              price: newPrice,
                              description: _descriptionContoler.text);
                        } else {
                          _activities.add(Article(
                              quantity: "1",
                              article: _articleControler.value.text,
                              price: newPrice,
                              description: _descriptionContoler.value.text));
                        }
                        setState(() {
                          _articleControler.clear();
                          _priceControler.clear();
                          _descriptionContoler.clear();
                        });
                      } else {
                        if (_categorie == null) {
                          // Lorsque la categorie est nulle on demande a l'utilisateur d'en choisir une
                          Navigator.pop(context);
                          _showCategorieDialog();
                        } else {
                          CompanyDatabase(userUid: userUid)
                              .addProduct(_articleControler.value.text,
                                  _priceControler.value.text, _categorie)
                              .then((value) => Navigator.pop(context));
                          if (_activities.isNotEmpty &&
                              _activities.last.article ==
                                  _articleControler.value.text) {
                            // Permet de rajouter le l'article au panier de commande du client en dernière position.
                            _activities.last = Article(
                                quantity: "1",
                                article: _articleControler.value.text,
                                price: newPrice,
                                description: _descriptionContoler.text);
                          } else {
                            _activities.add(Article(
                                quantity: "1",
                                article: _articleControler.value.text,
                                price: newPrice,
                                description: _descriptionContoler.value.text));
                          }
                          setState(() {
                            _articleControler.clear();
                            _priceControler.clear();
                            _descriptionContoler.clear();
                          });
                        }
                      }
                    },
                    child: const Text('Oui'))
              ],
            ));
  }

  _showCategorieDialog() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: ((context) => AlertDialog(
              title: const Text("Attention!!!"),
              content: const Text(
                  "Vous devez obligatoirement choisir une catégorie avant d'enregistrer un produit.\nChoisissez une catégorie puis réessayez"),
              actions: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        // permet d'enrengistrer l'article au lieu de le modifier
                      });
                      Navigator.pop(context);
                    },
                    child: const Text("OK"))
              ],
            )));
  }

  _submitPrint(total) async {
    var pdf = PdfCreator(
            accompte: "",
            isTicket: "A4",
            path: path,
            url: url,
            invoiceNumber: '$_invoiceDate$_randomNumber',
            costumerAdress: _adressControler.value.text,
            costumerName: _nameControler.value.text,
            costumerPhone: _phoneControler.value.text,
            date: DateFormat('hh:mm dd/MM/yyyy').format(_date),
            payWay: _payWay,
            cart: _activities,
            total: total,
            discount: _discountControler.value.text
                .replaceAll(",", ".")
                .replaceAll(" ", ""),
            documentValue: _documentValue)
        .generatePdf(context);
    await Printing.layoutPdf(onLayout: (_) => pdf);
  }

  Future _submitTicket(total, list) async {
    PrintTicket().printTicket(
        DateFormat('hh:mm dd/MM/yyyy').format(_date),
        list,
        total,
        'qRCode',
        '$_invoiceDate$_randomNumber',
        _nameControler.value.text,
        _adressControler.value.text,
        _phoneControler.value.text,
        _payWay,
        _discountControler.value.text.replaceAll(",", ".").replaceAll(" ", ""));
  }

  Future _submit(total) async {
    CompanyDatabase(userUid: userUid).addActivity(
        '$_invoiceDate$_randomNumber',
        _activities,
        _nameControler.value.text,
        _phoneControler.value.text,
        _payWay,
        total,
        _discountControler.value.text.replaceAll(",", ".").replaceAll(" ", ""),
        _isEstimate,
        _adressControler.value.text,
        _date,
        context);

    _showDoneAlertDialog();
  }

  _buildExpansionTile(
      List activityList,
      activityUid,
      ticketNumber,
      total,
      date,
      costumerName,
      costumerAdress,
      costumerPhone,
      payWay,
      discount,
      isEstimate) {
    return ExpansionTile(
      title: _buildList(activityList),
      trailing: _buidCard(Colors.white, Colors.blue, total),
      leading: _buidCard(
          Colors.white, Colors.blue, DateFormat('HH:mm').format(date)),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: TextButton(
                  onPressed: () async {
                    var pdf = PdfCreator(
                      accompte: "",
                      isTicket: "A4",
                      documentValue: isEstimate ? "Devis" : "Facture",
                      path: path,
                      url: url,
                      costumerAdress: '',
                      costumerName: costumerName,
                      costumerPhone: costumerPhone,
                      payWay: payWay,
                      invoiceNumber: ticketNumber,
                      total: total,
                      date: DateFormat('HH:mm dd/MM/yyyy').format(date),
                      discount: discount,
                      cart: activityList
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
                            MediaQuery.of(context).size.height > 600 ? 16 : 7),
                  )),
            ),
            Platform.isWindows || kIsWeb
                ? Expanded(
                    child: TextButton(
                    child: Text("Ticket",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height > 600
                                ? 16
                                : 7)),
                    onPressed: () async {
                      var pdf = PdfCreator(
                        accompte: "",
                        isTicket: "TICKET",
                        documentValue: "Ticket",
                        path: path,
                        url: url,
                        costumerAdress: '',
                        costumerName: costumerName,
                        costumerPhone: costumerPhone,
                        payWay: payWay,
                        invoiceNumber: ticketNumber,
                        total: total,
                        date: DateFormat('HH:mm dd/MM/yyyy').format(date),
                        discount: discount,
                        cart: activityList
                            .map((article) => Article(
                                article: article["article"],
                                description: article["description"],
                                price: article["price"],
                                quantity: article["quantity"]))
                            .toList(),
                      ).generatePdf(context);
                      await Printing.layoutPdf(onLayout: (_) => pdf);
                    },
                  ))
                : Expanded(
                    child: FutureBuilder<bool?>(
                        future: _bluetooth.isConnected,
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
                                    PrintTicket().printTicket(
                                        date,
                                        activityList
                                            .map((article) => Article(
                                                article: article['article'],
                                                price: article['price'],
                                                description:
                                                    article['description'],
                                                quantity: article['quantity']))
                                            .toList(),
                                        total,
                                        ticketNumber,
                                        ticketNumber,
                                        costumerName,
                                        costumerAdress,
                                        costumerPhone,
                                        payWay,
                                        discount);
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
                                      fontSize:
                                          MediaQuery.of(context).size.height >
                                                  600
                                              ? 16
                                              : 7,
                                      color: isConnected
                                          ? Colors.blue
                                          : Colors.red)));
                        }),
                  ),
            Expanded(
              child: TextButton(
                  onPressed: () {
                    _showDeleteAlertDialog(activityUid);
                  },
                  child: Text(
                    'Supprimer',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize:
                            MediaQuery.of(context).size.height > 600 ? 16 : 7),
                  )),
            ),
            Expanded(
              child: TextButton(
                  onPressed: () {
                    _showModifyAlertDialog(
                        activityList,
                        discount,
                        costumerName,
                        costumerPhone,
                        costumerAdress,
                        activityUid,
                        date,
                        ticketNumber,
                        isEstimate);
                  },
                  child: Text(
                    'Modifier',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize:
                            MediaQuery.of(context).size.height > 600 ? 16 : 7),
                  )),
            ),
            Expanded(
              child: TextButton(
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PdfCreator(
                                  accompte: "",
                                  isTicket: "A4",
                                  documentValue:
                                      isEstimate ? "Devis" : "Facture",
                                  path: path,
                                  url: url,
                                  costumerAdress: '',
                                  costumerName: costumerName,
                                  costumerPhone: costumerPhone,
                                  payWay: payWay,
                                  invoiceNumber: ticketNumber,
                                  total: total,
                                  date: DateFormat('HH:mm dd/MM/yyyy')
                                      .format(date),
                                  discount: discount,
                                  cart: activityList
                                      .map((article) => Article(
                                          article: article["article"],
                                          description: article["description"],
                                          price: article["price"],
                                          quantity: article["quantity"]))
                                      .toList(),
                                )));
                  },
                  child: Text("Voir",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height > 600
                              ? 16
                              : 7))),
            )
          ],
        )
      ],
    );
  }

  _showDoneAlertDialog() {
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
                            _reset();
                          }),
                          Navigator.pop(context)
                        },
                    child: const Text('Ok'))
              ],
            ));
  }

  _deleteActivityAlerteDialog(activityIndex) {
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
                            _activities.remove(activityIndex);
                            Navigator.pop(context);
                          })
                        },
                    child: const Text('Oui'))
              ],
            ));
  }

  _showAddArticleDialogue() {
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
                      child: Form(
                        key: _articleFormKey,
                        child: Column(
                          children: [
                            Expanded(
                              child: Text(
                                'Ajouter un article',
                                style: titleStyle,
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: Column(
                                children: [
                                  _buildArticle(),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  _buildPrice(),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  _buildFormDescription(),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildAddDoneButton(),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  _buildAddCancelButton()
                                ],
                              ),
                            ),
                          ],
                        ),
                      )));
            }));
  }

  _showModifyAlertDialog(List activityList, discount, name, phone, adress,
      activityUid, date, ticketNumber, isEstimate) {
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
                          setState(() {
                            _date = date;
                            _discountControler.text = discount;
                            _phoneControler.text = phone;
                            _adressControler.text = adress;
                            _nameControler.text = name;
                            _activities = activityList
                                .map((repair) => Article(
                                    description: repair['description'],
                                    price: repair['price'],
                                    article: repair['article'],
                                    quantity: repair['quantity']))
                                .toList();
                          }),
                          Navigator.pop(context),
                        },
                    child: const Text('Oui'))
              ],
            ));
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
                        child: Text('Repertoir client',
                            style: titleStyle.copyWith(
                                fontSize:
                                    MediaQuery.of(context).size.height > 600
                                        ? 20
                                        : 10)),
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

  _buildList(List list) {
    return ListView(
        shrinkWrap: true,
        children: list
            .map((article) => Card(
                color: Colors.blue,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: Colors.blue,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(
                      MediaQuery.of(context).size.height > 600 ? 12 : 2)),
                ),
                margin: EdgeInsets.all(
                    MediaQuery.of(context).size.height > 600 ? 3 : 1),
                child: Padding(
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.height > 600 ? 6 : 2),
                  child: Text('${article['article']}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height > 600
                              ? 16
                              : 7)),
                )))
            .toList());
  }

  _showDeleteAlertDialog(String? activityUid) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Attention...'),
              content: const Text(
                  'Vous êtes sur le point de supprimer une vente. Etes vous sures?'),
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

  _showCostumerAlertDialog() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Attention...'),
              content:
                  const Text('Vous devez Obligatoirement ajouter un client'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Annuler',
                      style: buttonText,
                    )),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _chooseCostumer = true;
                        Navigator.pop(context);
                      });
                    },
                    child: Text(
                      'Ajouter',
                      style: buttonText,
                    ))
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

  _reset() {
    _phoneControler.clear();
    _nameControler.clear();
    _adressControler.clear();
    _activities.clear();
    _discountControler.clear();
    _descriptionContoler.clear();
    _date = DateTime.now();
    setState(() {});
  }
}
