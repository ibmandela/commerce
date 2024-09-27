import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gestion_commerce_reparation/common/constant.dart';
import 'package:gestion_commerce_reparation/services/firebase/company_database.dart';

import 'quick_sell.dart';

class ArticleAdderPage extends StatelessWidget {
  final String? articleUid, article, categorie, price;
  final bool? isQuickSell;
  const ArticleAdderPage(
      {this.articleUid,
      this.categorie,
      this.article,
      this.price,
      this.isQuickSell,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ArticleAdder(
          articleUid: articleUid,
          article: article,
          categorie: categorie,
          price: price,
          isQuickSell: isQuickSell),
    );
  }
}

class ArticleAdder extends StatefulWidget {
  final String? articleUid, article, categorie, price;
  final bool? isQuickSell;
  const ArticleAdder(
      {required this.articleUid,
      required this.categorie,
      required this.article,
      required this.price,
      required this.isQuickSell,
      super.key});

  @override
  State<ArticleAdder> createState() => _ArticleAdderState();
}

class _ArticleAdderState extends State<ArticleAdder> {
  final _keyForm = GlobalKey<FormState>();
  bool uidIsNull = true;
  bool _isDone = true;
  final _articleControler = TextEditingController();
  final _priceControler = TextEditingController();
  final spaceDown = const SizedBox(
    height: 3,
  );

  var date = DateTime.now();

  String _categorie = '';

  @override
  void dispose() {
    _priceControler.dispose();
    _articleControler.dispose();

    super.dispose();
  }

  @override
  void initState() {
    if (widget.articleUid != null) {
      uidIsNull = false;
      _articleControler.text = '${widget.article}';
      _priceControler.text = '${widget.price}';
    }
    _categorie = '${widget.categorie}';
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
                  spaceDown,
                  _buildArticle(),
                  spaceDown,
                  _buildPrice(),
                  spaceDown,
                  _buildButton(),
                  if (!_isDone) _buildDoneButton(),
                  if (!uidIsNull) _buildDeleteButton()
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArticle() {
    return TextFormField(
      keyboardType: TextInputType.name,
      autocorrect: true,
      textCapitalization: TextCapitalization.characters,
      decoration: textInputDecoration.copyWith(
          label: const Text(
            'Article',
            style: formTextStyle,
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
    );
  }

  Widget _buildPrice() {
    var numberInputFormatters = [
      FilteringTextInputFormatter.allow(RegExp(r"[0-9,]")),
    ];
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: numberInputFormatters,
      autocorrect: false,
      decoration: textInputDecoration.copyWith(
          label: const Text(
            'Prix',
            style: formTextStyle,
          ),
          hintText: 'Prix'),
      controller: _priceControler,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Cet nom est invalide";
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
                CompanyDatabase(userUid: userUid).addProduct(
                    _articleControler.value.text,
                    _priceControler.value.text
                        .replaceAll(",", ".")
                        .replaceAll(" ", ""),
                    _categorie);
              } else {
                CompanyDatabase(userUid: userUid).addProduct(
                    _articleControler.value.text,
                    _priceControler.value.text
                        .replaceAll(",", ".")
                        .replaceAll(" ", ""),
                    _categorie);
                CompanyDatabase(userUid: userUid)
                    .deleteProduct(widget.articleUid, context);
              }
              _isDone = false;
            }),
            _articleControler.clear(),
            _priceControler.clear(),
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
            context, MaterialPageRoute(builder: (context) => const QuickSellPage()))
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
            .deleteProduct(widget.articleUid, context),
        Navigator.of(context).pop()
      },
      child: const Text('Supprimer'),
    );
  }
}
