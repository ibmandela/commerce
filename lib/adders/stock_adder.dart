import 'package:gestion_commerce_reparation/common/constant.dart';
import 'package:gestion_commerce_reparation/modeles/user.dart';
import 'package:gestion_commerce_reparation/services/costumer_class.dart';
import 'package:gestion_commerce_reparation/services/hive_database/boxes.dart';
import 'package:flutter/material.dart';

class StockAdderPage extends StatelessWidget {
  final String? emplacement, quantity, part, model, price, stockUid, brand;
  const StockAdderPage(
      {this.emplacement,
      this.part,
      this.model,
      this.quantity,
      this.stockUid,
      this.price,
      this.brand,
      super.key});

  @override
  Widget build(BuildContext context) {
    return StockAdder(
      emplacement: emplacement,
      quantity: quantity,
      part: part,
      model: model,
      price: price,
      stockUid: stockUid,
      brand: brand,
    );
  }
}

class StockAdder extends StatefulWidget {
  final String? emplacement, quantity, part, model, price, stockUid, brand;
  const StockAdder(
      {this.emplacement,
      this.part,
      this.model,
      this.price,
      this.quantity,
      this.stockUid,
      this.brand,
      super.key});

  @override
  State<StockAdder> createState() => _StockAdderState();
}

class _StockAdderState extends State<StockAdder> {
  final _formKey = GlobalKey<FormState>();
  String error = '';
  String _part = '';
  // String? _model;

  final _quantityControler = TextEditingController();
  final _emplacementControler = TextEditingController();
  final _priceControler = TextEditingController();
  final _modelControler = TextEditingController();

  bool uidIsnull = true;

  bool isDone = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _part = '${widget.part}';
    if (widget.brand != null) {
      _modelControler.text = '${widget.brand}';
    }
    if (widget.stockUid != null) {
      uidIsnull = false;
      _modelControler.text = '${widget.model}';
      _quantityControler.text = '${widget.quantity}';
      _emplacementControler.text = '${widget.emplacement}';
      _priceControler.text = '${widget.price}';
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
        title: Text(uidIsnull ? "Ajout de $_part" : "Modification de $_part"),
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
                    // if (_modelControler.value.text != "") _buildmodelList(),
                    _buildModel(),
                    const SizedBox(
                      height: 10,
                    ),
                    _builQuantity(),
                    const SizedBox(
                      height: 10,
                    ),
                    _builPrice(),
                    const SizedBox(
                      height: 10,
                    ),
                    _builEmplacement(),
                    const SizedBox(
                      height: 10,
                    ),
                    _buildButton(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _builQuantity() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: textInputDecoration3.copyWith(
          hintText: 'Quantité',
          hintStyle:
              const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
      autocorrect: false,
      controller: _quantityControler,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Verifiez ce champ SVP";
        } else {
          return null;
        }
      },
    );
  }

  Widget _builPrice() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: textInputDecoration3.copyWith(
          hintText: 'prix',
          hintStyle:
              const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
      autocorrect: false,
      controller: _priceControler,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Verifiez ce champ SVP";
        } else {
          return null;
        }
      },
    );
  }

  Widget _builEmplacement() {
    return TextFormField(
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.characters,
      decoration: textInputDecoration3.copyWith(
          hintText: 'Emplacement',
          hintStyle:
              const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
      autocorrect: false,
      controller: _emplacementControler,
    );
  }

  Widget _buildModel() {
    return TextFormField(
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.characters,
      decoration: textInputDecoration3.copyWith(
          hintText: 'Modèle',
          hintStyle:
              const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
      autocorrect: true,
      controller: _modelControler,
    );
  }

  Widget _buildButton() {
    final Iterable<String> parts =
        PartBox.partBox!.values.map((part) => part["part"]);

    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: borderRaduis,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            textStyle: textStyle),
        onPressed: () {
          if (isDone) {
            Navigator.pop(context);
          } else {
            if (_formKey.currentState!.validate()) {
              setState(() {
                if (!uidIsnull) {
                  _showModifyDialog(parts);
                } else {
                  _addStock(parts);
                  Navigator.pop(context);
                }
              });
            }
          }
        },
        child: Text(isDone
            ? "Terminer"
            : uidIsnull
                ? "Valider"
                : "Modifier"));
  }

  _showModifyDialog(parts) {
    final Iterable<Stock> stocks = StockBox.stockBox!.values
        .where((stock) => stock["model"].toUpperCase() == widget.model)
        .map((stock) => Stock(
            uid: stock["uid"],
            emplacement: stock["emplacement"],
            model: stock["model"],
            part: stock["part"],
            price: stock["price"],
            quantity: stock["quantity"]));
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Attention!!!",
            ),
            content: const Text("Voulez vous modifier le nom de ce modèle ?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Non")),
              TextButton(
                  onPressed: () {
                    _updateStock(stocks);
                    setState(() {
                      isDone = true;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("Oui"))
            ],
          );
        });
  }

  void _addStock(parts) {
    for (String part in parts) {
      StockDatabase().addStock(
          part.toUpperCase(),
          _modelControler.value.text.toUpperCase(),
          part.toUpperCase() == _part ? _emplacementControler.value.text : "",
          part.toUpperCase() == _part
              ? int.parse(_quantityControler.value.text)
              : 0,
          part.toUpperCase() == _part
              ? _priceControler.value.text
                  .replaceAll(",", ".")
                  .replaceAll(" ", "")
              : "0",
          context);
    }
  }

  void _updateStock(Iterable<Stock> stocks) {
    for (Stock stock in stocks) {
      print(stock);
      StockDatabase().deleteStock(stock.uid, context);
      StockDatabase().addStock(
          stock.part!.toUpperCase(),
          _modelControler.value.text.toUpperCase(),
          stock.part!.toUpperCase() == _part.toUpperCase()
              ? _emplacementControler.value.text
              : stock.emplacement,
          stock.part!.toUpperCase() == _part.toUpperCase()
              ? int.parse(_quantityControler.value.text)
              : stock.quantity ?? 0,
          stock.part!.toUpperCase() == _part.toUpperCase()
              ? _priceControler.value.text
                  .replaceAll(",", ".")
                  .replaceAll(" ", "")
              : stock.price,
          context);
    }
  }
}
