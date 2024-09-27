import 'package:gestion_commerce_reparation/adders/quick_sell.dart';
import 'package:gestion_commerce_reparation/common/constant.dart';
import 'package:gestion_commerce_reparation/modeles/user.dart';
import 'package:gestion_commerce_reparation/services/firebase/company_database.dart';
import 'package:flutter/material.dart';
import 'package:gestion_commerce_reparation/services/hive_database/boxes.dart';

class CategorieAdderPage extends StatelessWidget {
  final String? categorieUid, categorie;
  const CategorieAdderPage({this.categorieUid, this.categorie, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: CategorieAdder(
          categorie: categorie,
          categorieUid: categorieUid,
        ));
  }
}

class CategorieAdder extends StatefulWidget {
  final String? categorieUid, categorie;
  const CategorieAdder(
      {required this.categorie, required this.categorieUid, super.key});

  @override
  State<CategorieAdder> createState() => _CategorieAdderState();
}

class _CategorieAdderState extends State<CategorieAdder> {
  final _keyForm = GlobalKey<FormState>();
  bool uidIsNull = true;
  bool isDone = true;
  final _categorieControler = TextEditingController();
  final spaceDown = const SizedBox(
    height: 3,
  );

  var date = DateTime.now();

  String documentValue = 'Facture';
  List<Product> _products = [];

  @override
  void dispose() {
    _categorieControler.dispose();

    super.dispose();
  }

  @override
  void initState() {
    if (widget.categorieUid != null) {
      uidIsNull = false;
      _categorieControler.text = '${widget.categorie}';
      _products = ArticleBox.articleBox!.values
          .where((product) => product["categorie"] == widget.categorie)
          .map((product) => Product(
              article: product["article"],
              price: product["price"],
              categorie: product["categorie"],
              uid: product["uid"]))
          .toList();
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
                  _buildCategorie(),
                  spaceDown,
                  _buildButton(),
                  if (!isDone) _buildDoneButton(),
                  if (!uidIsNull && isDone) _buildDeleteButton()
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorie() {
    return TextFormField(
      keyboardType: TextInputType.name,
      autocorrect: true,
      textCapitalization: TextCapitalization.characters,
      decoration: textInputDecoration.copyWith(
          label: const Text(
            'Categorie',
            style: formTextStyle,
          ),
          hintText: 'Categorie'),
      controller: _categorieControler,
      validator: (value) {
        if (value == null || value.length < 2) {
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
                CompanyDatabase(userUid: userUid).addCategorie(
                    _categorieControler.value.text.toUpperCase(), context);
              } else {
                _showDeleteDialogue(_products, false);
              }
              isDone = false;
            }),
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
        Navigator.pop(context)
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => QuickSellPage(
        //             url: widget.url ?? "",
        //             path: widget.path ?? "",
        //             invoiceType: widget.invoiceType ?? "first",
        //             companyAdress: '${widget.companyAdress}',
        //             companyName: '${widget.companyName}',
        //             companyPhone: '${widget.companyPhone}',
        //             fax: '${widget.fax}',
        //             postalCode: '${widget.postalCode}',
        //             siret: '${widget.siret}',
        //             tva: '${widget.tva}',
        //             userUid: '${widget.userUid}')))
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
            .deleteCategorie(widget.categorieUid, context),
        _deleteProducts(_products),
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const QuickSellPage()))
      },
      child: const Text('Supprimer'),
    );
  }

  _showDeleteDialogue(List<Product> products, bool isToDelete) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Attention!!!'),
              content: Text(
                'Vous etes sur le point de Modifier cette pièce:\n Cela affectera ${products.length} elements en stock',
                style: textStyle,
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      if (!isToDelete) {
                        CompanyDatabase(userUid: userUid).addCategorie(
                            _categorieControler.value.text.toUpperCase(),
                            context);
                        _updateProducts(products);
                        CompanyDatabase(userUid: userUid)
                            .deleteCategorie(widget.categorieUid, context)
                            .then((value) => _categorieControler.clear());
                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                        _deleteProducts(products);
                        CompanyDatabase(userUid: userUid)
                            .deleteCategorie(widget.categorieUid, context)
                            .then((value) => _categorieControler.clear());
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

  _deleteProducts(List<Product> products) {
    for (var product in products) {
      CompanyDatabase(userUid: userUid).deleteProduct(product.uid, context);
    }
  }

  _updateProducts(List<Product> products) {
    for (var product in products) {
      CompanyDatabase(userUid: userUid).addProduct(
        product.article,
        product.price,
        _categorieControler.value.text,
      );
    }
  }
}
