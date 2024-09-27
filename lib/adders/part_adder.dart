import 'package:gestion_commerce_reparation/common/constant.dart';
import 'package:gestion_commerce_reparation/modeles/user.dart';
import 'package:gestion_commerce_reparation/services/costumer_class.dart';
import 'package:gestion_commerce_reparation/services/hive_database/boxes.dart';
import 'package:flutter/material.dart';

class PartAdderPage extends StatelessWidget {
  final String? partUid, part;
  const PartAdderPage({this.partUid, this.part, super.key});

  @override
  Widget build(BuildContext context) {
    return PartAdder(
      part: part,
      partUid: partUid,
    );
  }
}

class PartAdder extends StatefulWidget {
  final String? part, partUid;
  const PartAdder({this.part, this.partUid, super.key});

  @override
  State<PartAdder> createState() => _PartAdderState();
}

class _PartAdderState extends State<PartAdder> {
  final _formKey = GlobalKey<FormState>();
  String error = '';

  bool uidIsnull = true;
  bool isDone = true;
  List<Stock> _stocks = [];

  final _partControler = TextEditingController();

  @override
  void dispose() {
    _partControler.dispose();

    super.dispose();
  }

  @override
  void initState() {
    if (widget.partUid != null) {
      _partControler.text = '${widget.part}';
      uidIsnull = false;
      _stocks = StockBox.stockBox!.values
          .where((stock) =>
              stock["part"].toUpperCase() == widget.part!.toUpperCase())
          .map((stock) => Stock(
              uid: stock["uid"],
              emplacement: stock["emplacement"],
              model: stock["model"],
              part: stock["part"],
              price: stock["price"],
              quantity: stock["quantity"]))
          .toList();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
        title: Text(uidIsnull ? "Ajouter une pièce" : "Modifier une pièce"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Column(
                  children: [
                    _buildPart(),
                    _buildButton(),
                    if (!isDone) _buildDoneButton(),
                    if (!uidIsnull && isDone) _buildDeleteButton()
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPart() {
    return TextFormField(
      keyboardType: TextInputType.text,
      autocorrect: false,
      textCapitalization: TextCapitalization.characters,
      decoration: textInputDecoration.copyWith(
          label: const Text(
            'pièce',
            style: formTextStyle,
          ),
          hintText: 'pièce'),
      controller: _partControler,
      validator: (value) {
        if (value == null) {
          return null;
        }
        if (value.isNotEmpty && value.length < 2) {
          return "Verifiez ce champ SVP";
        } else {
          return null;
        }
      },
    );
  }

  _buildDeleteButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: borderRaduis,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          textStyle: textStyle),
      onPressed: () => {
        _showDeleteDialogue(_stocks, true),
      },
      child: const Text('Supprimer'),
    );
  }

  Widget _buildButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: borderRaduis,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            textStyle: textStyle),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            setState(() {
              if (widget.partUid != null) {
                _showDeleteDialogue(_stocks, false);
              } else {
                _submit();
              }
              isDone = false;
            });
          }
        },
        child: Text(uidIsnull ? "Valider" : "Modifier"));
  }

  Widget _buildDoneButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: borderRaduis,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            textStyle: textStyle),
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text("Terminer"));
  }

  Future _submit() async {
    PartsDatabase()
        .addPart(_partControler.text.toUpperCase(), context)
        .then((value) => _partControler.clear());
  }

  _deleteStocks(List<Stock> stocks) {
    for (var stock in stocks) {
      StockDatabase().deleteStock(stock.uid, context);
    }
  }

  _updateStocks(List<Stock> stocks) {
    for (var stock in stocks) {
      StockDatabase().addStock(
          _partControler.value.text.toUpperCase(),
          stock.model,
          stock.emplacement,
          stock.quantity ?? 1,
          stock.price,
          context);
      StockDatabase().deleteStock(stock.uid, context);
    }
  }

  _showDeleteDialogue(List<Stock> stocks, bool isToDelete) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Attention!!!'),
              content: Text(
                'Vous etes sur le point de Modifier cette pièce:\n Cela affectera ${stocks.length} elements en stock',
                style: textStyle,
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      if (!isToDelete) {
                        Navigator.pop(context);
                        _updateStocks(stocks);
                        PartsDatabase()
                            .deletePart(widget.partUid, context);
                        _submit();
                      } else {
                        Navigator.pop(context);
                        _deleteStocks(stocks);
                        PartsDatabase()
                            .deletePart(widget.partUid, context)
                            .then((value) => _partControler.clear());
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => RepairAdderPage(
                        //             url: widget.url,
                        //             path: widget.path,
                        //             invoiceType: widget.invoiceType,
                        //             companyAdress: '${widget.companyAdress}',
                        //             companyName: '${widget.companyName}',
                        //             companyPhone: '${widget.companyPhone}',
                        //             fax: '${widget.fax}',
                        //             postalCode: '${widget.postalCode}',
                        //             siret: '${widget.siret}',
                        //             tva: '${widget.tva}',
                        //             userUid: '${widget.userUid}')));
                      }
                    },
                    child: const Text('Valider')),
                TextButton(
                    onPressed: () => {Navigator.pop(context)},
                    child: const Text('Annuler'))
              ],
            ));
  }
}
