import 'package:gestion_commerce_reparation/common/constant.dart';
import 'package:gestion_commerce_reparation/services/costumer_class.dart';
import 'package:gestion_commerce_reparation/services/hive_database/boxes.dart';
import 'package:flutter/material.dart';

class ModelAdderPage extends StatelessWidget {
  const ModelAdderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModelAdder();
  }
}

class ModelAdder extends StatefulWidget {
  const ModelAdder({super.key});

  @override
  State<ModelAdder> createState() => _ModelAdderState();
}

class _ModelAdderState extends State<ModelAdder> {
  final _formKey = GlobalKey<FormState>();
  String error = '';

  bool uidIsnull = true;
  bool isDone = true;

  final _modelControler = TextEditingController();

  @override
  void dispose() {
    _modelControler.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
        title: Text(uidIsnull
            ? "Ajouter un modéle d'appareil"
            : "Modifier un modéle d'appareil"),
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
                    _buildModel(),
                    _buildButton(),
                    if (!isDone) _buildDoneButton()
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModel() {
    return TextFormField(
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.characters,
      autocorrect: false,
      decoration: textInputDecoration.copyWith(
          label: const Text(
            'Modèle',
            style: formTextStyle,
          ),
          hintText: 'Modèle'),
      controller: _modelControler,
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

  Widget _buildButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: borderRaduis,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            textStyle: textStyle),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            setState(() {
              _submit();
              isDone = false;
            });
          }
          _modelControler.clear();
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
    ModelBox.modelBox!.put(_modelControler.value.text.toUpperCase(), {
      "model": _modelControler.value.text.toUpperCase(),
      "uid": _modelControler.value.text.toUpperCase()
    });
    ModelDatabase().addModel(_modelControler.text.toUpperCase(), context);
  }
}
