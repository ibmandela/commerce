import 'package:gestion_commerce_reparation/adders/repair_adder.dart';
import 'package:gestion_commerce_reparation/common/constant.dart';
import 'package:gestion_commerce_reparation/services/costumer_class.dart';
import 'package:gestion_commerce_reparation/services/hive_database/boxes.dart';
import 'package:flutter/material.dart';

class BrandAdderPage extends StatelessWidget {
  final String? brandUid, brand;
  const BrandAdderPage({this.brandUid, this.brand, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: BrandAdder(
          brand: brand,
          brandUid: brandUid,
        ));
  }
}

class BrandAdder extends StatefulWidget {
  final String? brandUid, brand;
  const BrandAdder({required this.brand, required this.brandUid, super.key});

  @override
  State<BrandAdder> createState() => _BrandAdderState();
}

class _BrandAdderState extends State<BrandAdder> {
  final _keyForm = GlobalKey<FormState>();
  bool uidIsNull = true;
  bool isDone = true;
  final _brandControler = TextEditingController();
  final spaceDown = const SizedBox(
    height: 3,
  );

  var date = DateTime.now();

  String documentValue = 'Facture';

  @override
  void dispose() {
    _brandControler.dispose();

    super.dispose();
  }

  @override
  void initState() {
    if (widget.brandUid != null) {
      uidIsNull = false;
      _brandControler.text = '${widget.brand}';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _keyForm,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Column(
                children: [
                  _buildBrand(),
                  spaceDown,
                  _buildButton(),
                  if (!isDone) _buildDoneButton(),
                  if (!uidIsNull) _buildDeleteButton()
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrand() {
    return TextFormField(
      keyboardType: TextInputType.name,
      autocorrect: true,
      textCapitalization: TextCapitalization.characters,
      decoration: textInputDecoration.copyWith(
          label: const Text(
            'Marque',
            style: formTextStyle,
          ),
          hintText: 'Marque'),
      controller: _brandControler,
      validator: (value) {
        if (value == null || value.length < 2) {
          return "Verifier ce champ";
        } else {
          return null;
        }
      },
    );
  }

  _buildButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: borderRaduis,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          textStyle: textStyle),
      onPressed: () => {
        if (_keyForm.currentState!.validate())
          {
            setState(() {
              if (widget.brandUid != null) {
                ModelDatabase().addBrand(
                    _brandControler.value.text.toUpperCase(), context);
                ModelDatabase().deleteBrand(widget.brandUid, context);
              } else {
                ModelDatabase().addBrand(
                    _brandControler.value.text.toUpperCase(), context);
              }
            }),
            _brandControler.clear(),
            isDone = false,
          }
      },
      child: Text(uidIsNull ? 'Valider' : 'Modifier'),
    );
  }

  _buildDoneButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: borderRaduis,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          textStyle: textStyle),
      onPressed: () => {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const RepairAdderPage()))
      },
      child: const Text('Terminer'),
    );
  }

  _buildDeleteButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: borderRaduis,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          textStyle: textStyle),
      onPressed: () {
        BrandBox.brandBox!.delete(widget.brandUid);
        ModelDatabase().deleteBrand(widget.brandUid, context);
      },
      child: const Text('Supprimer'),
    );
  }
}
