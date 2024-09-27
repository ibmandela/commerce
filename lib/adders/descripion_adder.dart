import 'package:gestion_commerce_reparation/adders/repair_adder.dart';
import 'package:gestion_commerce_reparation/common/constant.dart';
import 'package:gestion_commerce_reparation/services/firebase/company_database.dart';
import 'package:flutter/material.dart';

class DescriptionAdderPage extends StatelessWidget {
  final String? descriptionUid, description;
  const DescriptionAdderPage(
      {this.descriptionUid, this.description, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: DescriptionAdder(
          description: description,
          descriptionUid: descriptionUid,
        ));
  }
}

class DescriptionAdder extends StatefulWidget {
  final String? descriptionUid, description;
  const DescriptionAdder(
      {required this.description, required this.descriptionUid, super.key});

  @override
  State<DescriptionAdder> createState() => _DescriptionAdderState();
}

class _DescriptionAdderState extends State<DescriptionAdder> {
  final _keyForm = GlobalKey<FormState>();
  bool uidIsNull = true;
  bool isDone = true;
  final _descriptionControler = TextEditingController();
  final spaceDown = const SizedBox(
    height: 3,
  );

  var date = DateTime.now();

  @override
  void dispose() {
    _descriptionControler.dispose();

    super.dispose();
  }

  @override
  void initState() {
    if (widget.descriptionUid != null) {
      uidIsNull = false;
      _descriptionControler.text = '${widget.description}';
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
                  _buildDescription(),
                  spaceDown,
                  _buildButton(),
                  if (!isDone) _buildDoneButton(),
                  if (!uidIsNull) _buildDeleteButton(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return TextFormField(
      keyboardType: TextInputType.name,
      autocorrect: true,
      textCapitalization: TextCapitalization.characters,
      decoration: textInputDecoration.copyWith(
          label: const Text(
            'Description',
            style: formTextStyle,
          ),
          hintText: 'Description'),
      controller: _descriptionControler,
      validator: (value) {
        if (value == null || value.length < 2) {
          return "Ce champ est invalide";
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
              if (uidIsNull) {
                CompanyDatabase(userUid: userUid).addDescription(
                    _descriptionControler.value.text.toUpperCase(), context);
              } else {
                CompanyDatabase(userUid: userUid).addDescription(
                    _descriptionControler.value.text.toUpperCase(), context);
              }
              isDone = false;
            }),
            _descriptionControler.clear(),
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
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const RepairAdderPage()))
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
      onPressed: () => {
        CompanyDatabase(userUid: userUid)
            .deleteDescription(widget.descriptionUid, context),
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const RepairAdderPage()))
      },
      child: const Text('Supprimer'),
    );
  }
}
