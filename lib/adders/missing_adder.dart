import 'package:flutter/services.dart';
import 'package:gestion_commerce_reparation/common/constant.dart';
import 'package:gestion_commerce_reparation/modeles/user.dart';
import 'package:gestion_commerce_reparation/services/firebase/company_database.dart';
import 'package:flutter/material.dart';
import 'package:gestion_commerce_reparation/services/hive_database/boxes.dart';
import 'package:gestion_commerce_reparation/viewer.dart/object/missing_viewer.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MissingAddPage extends StatelessWidget {
  const MissingAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MissingAdd();
  }
}

class MissingAdd extends StatefulWidget {
  const MissingAdd({super.key});

  @override
  State createState() => _MissingAddState();
}

class _MissingAddState extends State<MissingAdd> {
  final _partcontroler = TextEditingController();
  final _modelControler = TextEditingController();
  String _searchPart = "";
  String _searchModel = "";
  bool _partOrModel = true;

  final _formKey = GlobalKey<FormState>();
  final spaceDown = const SizedBox(
    height: 10,
  );
  @override
  void dispose() {
    _partcontroler.dispose();
    _modelControler.dispose();
    super.dispose();
  }
  @override
  void initState() {
super.initState();
  SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
  ]);    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        Text(
                          'Articles manquants',
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: MediaQuery.of(context).size.width < 600
                                  ? 25
                                  : 15,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500),
                        ),
                        if (MediaQuery.of(context).size.width < 600) spaceDown,
                        _buildPartButton(),
                        spaceDown,
                        _buildModelButton(),
                        spaceDown,
                        _buildButton(),
                        spaceDown,
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 3,
                            child: _buildMissingList())
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: _partOrModel ? _showPart() : _showModel()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildMissingList() {
    return MissingView(
      isSmall: MediaQuery.of(context).size.width > 600,
    );
  }

  Widget _buildButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width < 600 ? 100 : 10,
              vertical: MediaQuery.of(context).size.width < 600 ? 20 : 5,
            ),
            backgroundColor: Colors.blue,
            elevation: 30),
        onPressed: () {
          setState(() {
            if (_searchModel != "" && _searchPart != "") {
              submit();
            }
          });
        },
        child: const Text(
          "Ajouter",
        ));
  }

  Widget _buildModelButton() {
    return InkWell(
      onTap: () => setState(() {
        _partOrModel = false;
      }),
      child: Container(
        width: double.infinity,
        decoration: boxdecoration,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            _searchModel != "" ? _searchModel : 'Recharger un modèle',
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 60,
                color: _searchModel != "" ? Colors.black : Colors.blue,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildPartButton() {
    return InkWell(
      onTap: () => setState(() {
        _partOrModel = true;
      }),
      child: Container(
        decoration: boxdecoration,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(_searchPart != "" ? _searchPart : 'Rechercher une piéce',
              style: TextStyle(
                  color: _searchPart != "" ? Colors.black : Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width / 60)),
        ),
      ),
    );
  }

  _showPart() {
    return ValueListenableBuilder<Box>(
        valueListenable: PartBox.partBox!.listenable(),
        builder: (context, box, child) {
          List<Part> data = box.values
              .map((part) => Part(part: part["part"], uid: part["uid"]))
              .where((part) =>
                  part.part.toUpperCase().contains(_searchPart.toUpperCase()))
              .toList();
          return Container(
            decoration: boxdecoration,
            width: MediaQuery.of(context).size.width / 3,
            height: MediaQuery.of(context).size.height / 1.5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  children: [
                    Expanded(
                        child: TextFormField(
                      style: formTextStyle,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.characters,
                      autocorrect: false,
                      decoration: textInputDecoration3.copyWith(
                          label: const Text(
                            'Pièce',
                            style: formTextStyle,
                          ),
                          hintText: 'Pièce'),
                      controller: _partcontroler,
                      onChanged: (value) {
                        setState(() {
                          _searchPart = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return "Verifiez champ SVP";
                        }
                        if (value.isNotEmpty && value.length < 2) {
                          return "Verifiez champ SVP";
                        } else {
                          return null;
                        }
                      },
                    )),
                    Expanded(
                      flex: 6,
                      child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _partcontroler.text = data[index].part;
                                  _searchPart = data[index].part;
                                  _partOrModel = false;
                                  // _searchModel = "";
                                  // _modelControler.clear();
                                });
                              },
                              child: Column(children: [
                                divider,
                                Text(
                                  data[index].part,
                                  style: formTextStyle.copyWith(
                                      fontSize:
                                          MediaQuery.of(context).size.width <
                                                  600
                                              ? 20
                                              : 10),
                                )
                              ]),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _showModel() {
    return ValueListenableBuilder<Box>(
        valueListenable: StockBox.stockBox!.listenable(),
        builder: (context, box, child) {
          List<Stock> data = _searchModel != ""
              ? box.values
                  .map((stock) => Stock(
                      uid: stock["uid"],
                      emplacement: stock["emplacement"],
                      model: stock["model"],
                      part: stock["part"],
                      price: stock["price"],
                      quantity: stock["quantity"]))
                  .where((stock) => _searchPart != ""
                      ? stock.part!
                              .toUpperCase()
                              .contains(_searchPart.toUpperCase()) &&
                          stock.model!
                              .toUpperCase()
                              .contains(_searchModel.toUpperCase())
                      : stock.model!
                          .toUpperCase()
                          .contains(_searchModel.toUpperCase()))
                  .toList()
              : box.values
                  .map((stock) => Stock(
                      uid: stock["uid"],
                      emplacement: stock["emplacement"],
                      model: stock["model"],
                      part: stock["part"],
                      price: stock["price"],
                      quantity: stock["quantity"]))
                  .where((stock) => stock.part!
                      .toUpperCase()
                      .contains(_searchPart.toUpperCase()))
                  .toList();
          return Container(
            decoration: boxdecoration,
            width: MediaQuery.of(context).size.width / 3,
            height: MediaQuery.of(context).size.height / 1.5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(children: [
                  Expanded(
                      child: TextFormField(
                    style: formTextStyle,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                    autocorrect: false,
                    decoration: textInputDecoration3.copyWith(
                        label: const Text(
                          'Modèle',
                          style: formTextStyle,
                        ),
                        hintText: 'Modèle'),
                    controller: _modelControler,
                    onChanged: (value) {
                      setState(() {
                        _searchModel = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return "Verifiez champ SVP";
                      }
                      if (value.isNotEmpty && value.length < 2) {
                        return "Verifiez champ SVP";
                      } else {
                        return null;
                      }
                    },
                  )),
                  Expanded(
                    flex: 6,
                    child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Column(children: [
                            divider,
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _modelControler.text = '${data[index].model}';
                                  _searchModel = '${data[index].model}';
                                  _partOrModel = true;
                                  CompanyDatabase(userUid: userUid)
                                      .addMissingItem(
                                          data[index].part!.toUpperCase(),
                                          data[index].model!.toUpperCase(),
                                          context)
                                      .then((value) => {
                                            _searchPart = "",
                                            _partcontroler.clear()
                                          });
                                });
                              },
                              child: Text(
                                '${data[index].part} ${data[index].model}',
                                style: formTextStyle.copyWith(
                                    fontSize:
                                        MediaQuery.of(context).size.width < 600
                                            ? 20
                                            : 10),
                              ),
                            )
                          ]);
                        }),
                  ),
                ]),
              ),
            ),
          );
        });
  }

  void submit() {
    var model = _modelControler.text;
    var part = _partcontroler.text;
    CompanyDatabase(userUid: userUid).addMissingItem(part, model, context);
    Navigator.pop(context);
  }
}
