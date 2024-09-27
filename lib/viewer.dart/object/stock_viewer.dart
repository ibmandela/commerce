import 'package:gestion_commerce_reparation/adders/stock_adder.dart';
import 'package:gestion_commerce_reparation/common/constant.dart';
import 'package:gestion_commerce_reparation/common/message.dart';
import 'package:gestion_commerce_reparation/services/costumer_class.dart';
import 'package:gestion_commerce_reparation/services/hive_database/boxes.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StockViewPage extends StatelessWidget {
  final String? part;
  const StockViewPage({this.part, super.key});

  @override
  Widget build(BuildContext context) {
    return StockView(
      part: part,
    );
  }
}

class StockView extends StatefulWidget {
  final String? part;
  const StockView({this.part, super.key});

  @override
  State createState() => _StockViewState();
}

class _StockViewState extends State<StockView> {
  var emplacementControler = TextEditingController();
  final _partControler = TextEditingController();

  final _keyForm = GlobalKey<FormState>();
  String? _part;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_part == null
              ? "Tout votre stock"
              : "Stock de : ${_part!.toUpperCase()}"),
          actions: [
            TextButton(
                onPressed: () {
                  _showPartDialog();
                },
                child: const Text(
                  'Choisir une piéce',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _part == null
              ? showCostumDialog(context, "Attention!!!",
                  "Vous devez obligatoirement choisir une pièce")
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StockAdderPage(
                            part: _part!.toUpperCase(),
                          ))),
          child: const Icon(Icons.add),
        ),
        body: ValueListenableBuilder<Box<dynamic>>(
            valueListenable: StockBox.stockBox!.listenable(),
            builder: (context, box, widget1) {
              final data = _part == null
                  ? box.values.toList()
                  : box.values
                      .where((stock) =>
                          stock["part"].toUpperCase() == _part!.toUpperCase())
                      .toList();
              data.sort((a, b) =>
                  // a["part"].toUpperCase() !=
                  //         b["part"].toUpperCase()
                  //             ||
                  _part == null
                      ? a["part"]
                          .toUpperCase()
                          .compareTo(b["part"].toUpperCase())
                      : a["model"]
                          .toUpperCase()
                          .compareTo(a["model"].toUpperCase()));

              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Column(children: [
                      const Divider(
                        thickness: 2,
                        height: 2.0,
                      ),
                      InkWell(
                        onLongPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StockAdderPage(
                                        stockUid: data[index]["uid"],
                                        emplacement: data[index]['emplacement'],
                                        model: data[index]['model'],
                                        part: data[index]['part'],
                                        price: data[index]['price'],
                                        quantity:
                                            data[index]['quantity'].toString(),
                                      )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(children: [
                            Expanded(
                              flex: 6,
                              child: Text(
                                  "${data[index]['part']} ${data[index]['model']}",
                                  style: listTextStyle.copyWith(
                                      color:
                                          _setColor(data[index]['quantity']))),
                            ),
                            Expanded(
                              child: Text(
                                "${data[index]['quantity']}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _setColor(data[index]['quantity'])),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${data[index]['price']}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                                child: InkWell(
                              onTap: () {
                                _showEmplacementAlertDialog(
                                    data[index]['uid'],
                                    data[index]['emplacement'],
                                    data[index]['part'],
                                    data[index]['model'],
                                    data[index]['quantity'],
                                    data[index]['price']);
                              },
                              child: Text(
                                "${data[index]['emplacement']}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ))
                          ]),
                        ),
                      )
                    ]);
                  });
            }));
  }

  Widget _buildPartSearch() {
    return TextFormField(
      keyboardType: TextInputType.name,
      autocorrect: true,
      textCapitalization: TextCapitalization.sentences,
      decoration: textInputDecoration.copyWith(
          label: const Text(
            'Pièce',
            style: formTextStyle,
          ),
          hintText: 'Pièce'),
      controller: _partControler,
    );
  }

  _showPartDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ValueListenableBuilder<Box<dynamic>>(
                valueListenable: PartBox.partBox!.listenable(),
                builder: (context, box, widget1) {
                  final data = box.values.toList();
                  return Scaffold(
                    appBar: AppBar(
                      title: _buildPartSearch(),
                      actions: [
                        IconButton(
                            onPressed: () => {
                                  setState(() {
                                    PartBox.partBox!.put(
                                        _partControler.text.toUpperCase(), {
                                      "part": _partControler.text.toUpperCase(),
                                      "uid": _partControler.text.toUpperCase()
                                    });
                                    PartsDatabase().addPart(
                                        _partControler.value.text.toUpperCase(),
                                        context);

                                    _part = _partControler.value.text;
                                    Navigator.pop(context);
                                  })
                                },
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ))
                      ],
                      // title: _buildMenu(),
                    ),
                    body: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Column(children: [
                            divider,
                            GestureDetector(
                              onLongPress: () {
                                _deletePartDialog(data[index].id);
                              },
                              onTap: () {
                                setState(() {
                                  _part = data[index]['part'];
                                });

                                Navigator.pop(context);
                              },
                              child: Text(
                                '${data[index]['part']}',
                                style: formTextStyle,
                              ),
                            )
                          ]);
                        }),
                  );
                },
              ),
            )));
  }

  _showEmplacementAlertDialog(
      String? stockUid, emplacement, part, model, quantity, price) {
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
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                            maxLength: 5,
                            controller: emplacementControler,
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
                                  StockDatabase().modifyStockEmplacement(
                                      stockUid,
                                      emplacementControler.value.text,
                                      part,
                                      quantity,
                                      price,
                                      model,
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

  _deletePartDialog(partUid) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Attention...'),
              content: const Text('Voulez vous supprimer cette pièce ?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annuler')),
                TextButton(
                    onPressed: () => {
                          setState(() {
                            Navigator.pop(context);
                            PartBox.partBox!.delete(partUid);
                            PartsDatabase().deletePart(partUid, context);
                          })
                        },
                    child: const Text('Oui'))
              ],
            ));
  }

  Color _setColor(int quantity) {
    if (quantity <= 1) {
      return Colors.red;
    }
    if (quantity <= 3) {
      return Colors.black;
    } else {
      return Colors.green;
    }
  }
}
