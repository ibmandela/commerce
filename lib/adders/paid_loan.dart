import 'package:gestion_commerce_reparation/common/constant.dart';
import 'package:gestion_commerce_reparation/services/costumer_class.dart';
import 'package:gestion_commerce_reparation/services/firebase/company_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class PaidLaonPage extends StatelessWidget {
  final String? name, adress, phone, description, debt, refund, loanPaidUid;
  final double? solde;

  const PaidLaonPage(
      {this.name,
      this.adress,
      this.phone,
      this.solde,
      this.debt,
      this.description,
      this.refund,
      this.loanPaidUid,
      super.key});

  @override
  Widget build(BuildContext context) {
    return PaidLoan(
        name: name,
        adress: adress,
        phone: phone,
        description: description,
        debt: debt,
        refund: refund,
        loanPaidUid: loanPaidUid);
  }
}

class PaidLoan extends StatefulWidget {
  final String? name, adress, phone, description, debt, refund, loanPaidUid;
  final double? solde;
  const PaidLoan(
      {super.key,
      this.name,
      this.adress,
      this.phone,
      this.solde,
      this.debt,
      this.description,
      this.refund,
      this.loanPaidUid});

  @override
  State createState() => _PaidLoanState();
}

class _PaidLoanState extends State<PaidLoan> {
  final _nameControler = TextEditingController();
  final _refundControler = TextEditingController();
  final _debtControler = TextEditingController();
  final _dateControler = TextEditingController();
  final _phoneComControler = TextEditingController();
  final _descriptionControler = TextEditingController();
  final _adressControler = TextEditingController();
  var format = DateFormat('dd/MM/yy');
  final _formKey = GlobalKey<FormState>();
  bool uidIsNull = false;

  @override
  void dispose() {
    _nameControler.dispose();
    _phoneComControler.dispose();
    _dateControler.dispose();
    _refundControler.dispose();
    _debtControler.dispose();
    _descriptionControler.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.name != null) {
      _nameControler.text = widget.name ?? "";
      _phoneComControler.text = widget.phone ?? "";
      _adressControler.text = widget.adress ?? "";

      if (widget.loanPaidUid != null) {
        uidIsNull = !uidIsNull;
        _debtControler.text = widget.debt ?? "";
        _refundControler.text = widget.refund ?? "";
        _descriptionControler.text = widget.description ?? "";
      }
    }

    _dateControler.text = format.format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
        title: const Text("Ajouter une dette  ou \n un remboursement"),
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
                    _buildCostumerCard(),
                    _builDebtCard(),
                    _buildRefundCard(),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildButton(),
                    const SizedBox(
                      height: 10,
                    ),
                    if (uidIsNull) _buildDeleteButton()
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCostumerCard() {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      color: Colors.blue,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              "Informations du client",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _builDate(),
                const SizedBox(
                  height: 3,
                ),
                _buildName(),
                const SizedBox(
                  height: 3,
                ),
                _buildPhone(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _builDebtCard() {
    return Card(
      color: Colors.red,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              "Dette",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _buildDescription(),
                const SizedBox(
                  height: 3,
                ),
                _buildDebt(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRefundCard() {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
      color: Colors.green,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              "Remboursement",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _builRefund(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildName() {
    return TextFormField(
      keyboardType: TextInputType.name,
      autocorrect: true,
      textCapitalization: TextCapitalization.characters,
      decoration: textInputDecoration.copyWith(
          prefixIcon: const Icon(
            Icons.person,
            color: Colors.blue,
          ),
          suffixIcon: IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.blue,
              ),
              onPressed: () => _showNameDialog()),
          label: const Text(
            'Non du Client',
            style: formTextStyle,
          ),
          hintText: 'Nom du client'),
      controller: _nameControler,
      validator: (value) {
        if (value == null || value.length < 2) {
          return "Cet email est invalide";
        } else {
          return null;
        }
      },
    );
  }

  Widget _buildDescription() {
    return TextFormField(
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.characters,
      autocorrect: false,
      decoration: textInputDecoration.copyWith(
          suffixIcon: IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.blue,
              ),
              onPressed: () =>
                  _showArticleDialog(_descriptionControler, _debtControler)),
          label: const Text(
            'Article',
            style: formTextStyle,
          ),
          hintText: 'Article'),
      controller: _descriptionControler,
      validator: (value) {
        if (value == null) {
          return null;
        }
        if (value.isNotEmpty && value.length < 2) {
          return "Verifiez champ SVP";
        } else {
          return null;
        }
      },
    );
  }

  Widget _builDate() {
    return TextFormField(
      keyboardType: TextInputType.datetime,
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
      decoration: textInputDecoration.copyWith(
          prefixIcon: const Icon(
            Icons.calendar_today,
            color: Colors.blue,
          ),
          hintText: 'Date',
          label: const Text(
            'Date',
            style: formTextStyle,
          )),
      controller: _dateControler,
      validator: (value) {
        if (value == null || value.length < 4) {
          return "Entrez une date valide SVP";
        } else {
          return null;
        }
      },
    );
  }

  Widget _buildPhone() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      autocorrect: false,
      decoration: textInputDecoration.copyWith(
          prefixIcon: const Icon(
            Icons.phone,
            color: Colors.blue,
          ),
          label: const Text(
            'numéro de téléphone',
            style: formTextStyle,
          ),
          hintText: 'numéro de téléphone'),
      controller: _phoneComControler,
      validator: (value) {
        if (value == null || value.length < 10) {
          return "Ce numéro de téléphone est invalide";
        } else {
          return null;
        }
      },
    );
  }

  Widget _buildDebt() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[+-]?([0-9]*[.])?[0-9]+'))
      ],
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
      decoration: textInputDecoration.copyWith(
          label: const Text(
            'Prix',
            style: formTextStyle,
          ),
          hintText: 'Prix'),
      controller: _debtControler,
    );
  }

  Widget _builRefund() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[+-]?([0-9]*[.])?[0-9]+'))
      ],
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
      decoration: textInputDecoration.copyWith(
          label: const Text(
            'Prix',
            style: formTextStyle,
          ),
          hintText: 'Prix'),
      controller: _refundControler,
    );
  }

  Widget _buildButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
            elevation: 30),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            submit();
          }
        },
        child: Text(
          uidIsNull ? "Modifier" : "Ajouter",
          style: const TextStyle(fontSize: 20),
        ));
  }

  Widget _buildDeleteButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
            elevation: 30),
        onPressed: () {
          CompanyDatabase(userUid: userUid)
              .deleteRefundOrDebt(widget.loanPaidUid, context);
          Navigator.pop(context);
        },
        child: const Text(
          "Supprimer",
          style: TextStyle(fontSize: 20),
        ));
  }

  double parseDouble(String strNumber) {
    if (strNumber.isNotEmpty) {
      return double.parse(strNumber);
    } else {
      return 0;
    }
  }

  _sendMessage(String? phone, refund, debt, double solde) async {
    double soldeRefund = solde + parseDouble(refund);
    double soldeDebt = solde - parseDouble(debt);
    double parseRefund = parseDouble(refund);
    double parseDebt = parseDouble(debt);
    String body = refund.length > 0
        ? "Bonjour, sauf erreur de notre part vous nous avez reglé ${NumberFormat.currency(locale: 'fr').format(parseRefund)}. Votre solde chez nous est de ${NumberFormat.currency(locale: 'fr').format(soldeRefund)} \n Cordialement SAMY Télécom"
        : "Bonjour, sauf erreur de notre part vous avez pris ${NumberFormat.currency(locale: 'fr').format(parseDebt)}. Votre solde chez nous est de ${NumberFormat.currency(locale: 'fr').format(soldeDebt)} \n Cordialement SAMY Télécom";
    final Uri smsLaunchUri = Uri(
      scheme: 'sms',
      path: phone,
      queryParameters: <String, String>{
        'body': body,
      },
    );
    await launchUrl(smsLaunchUri);

    // if (refund.length > 0) {
    //   if (Platform.isAndroid) {
    //     //FOR Android
    //     var url =
    //         "sms:${phone}?body=Bonjour, sauf erreur de notre part vous nous avez reglé ${NumberFormat.currency(locale: 'fr').format(parseRefund)}. Votre solde chez nous est de ${NumberFormat.currency(locale: 'fr').format(soldeRefund)} \n Cordialement SAMY Télécom";
    //     await launch(url);
    //   } else if (Platform.isIOS) {
    //     //FOR IOS
    //     var url =
    //         "sms:${phone}&body=Bonjour, sauf erreur de notre part vous nous avez reglé ${NumberFormat.currency(locale: 'fr').format(parseRefund)}. Votre solde chez nous est de ${NumberFormat.currency(locale: 'fr').format(soldeRefund)} \n Cordialement SAMY Télécom";
    //     await launch(url);
    //   }
    // } else if (debt.length > 0) {
    //   if (Platform.isAndroid) {
    //     //FOR Android
    //     var url =
    //         "sms:${phone}?body=Bonjour, sauf erreur de notre part vous avez pris ${NumberFormat.currency(locale: 'fr').format(parseDebt)}. Votre solde chez nous est de ${NumberFormat.currency(locale: 'fr').format(soldeDebt)} \n Cordialement SAMY Télécom";
    //     await launch(url);
    //   } else if (Platform.isIOS) {
    //     //FOR IOS
    //     var url =
    //         "sms:${phone}&body=Bonjour, sauf erreur de notre part vous avez pris ${NumberFormat.currency(locale: 'fr').format(parseDebt)}. Votre solde chez nous est de ${NumberFormat.currency(locale: 'fr').format(soldeDebt)} \n Cordialement SAMY Télécom";
    //     // ignore: deprecated_member_use
    //     await launch(url);
    //   }
    // }
  }

  _showNameDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: CostumerDatabase().costumers(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Un probleme est survenu');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Veuillez patienter");
                    }
                    final data = snapshot.requireData;
                    return ListView.builder(
                        itemCount: data.size,
                        itemBuilder: (context, index) {
                          return Column(children: [
                            const Divider(
                              thickness: 2,
                              height: 0,
                            ),
                            ListTile(
                                onTap: () {
                                  _nameControler.text =
                                      data.docs[index]['name'];
                                  _phoneComControler.text =
                                      data.docs[index]['phone'];

                                  Navigator.pop(context);
                                },
                                title: Text(
                                  '${data.docs[index]['name']}',
                                  style: formTextStyle,
                                ),
                                trailing: Text(
                                  '${data.docs[index]['phone']}',
                                  style: formTextStyle,
                                ),
                                subtitle: Text(
                                  '${data.docs[index]['adress']}',
                                ))
                          ]);
                        });
                  },
                ))));
  }

  _showArticleDialog(TextEditingController articleController, priceControler) {
    return showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: CompanyDatabase(userUid: userUid).activities(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Un probleme est survenu');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Veuillez patienter...");
                  }
                  final data = snapshot.requireData;
                  return ListView.builder(
                      itemCount: data.size,
                      itemBuilder: (context, index) {
                        return Column(children: [
                          divider,
                          GestureDetector(
                            onTap: () {
                              articleController.text =
                                  data.docs[index]['article'];

                              priceControler.text =
                                  data.docs[index]['price'].toString();
                              Navigator.pop(context);
                            },
                            child: Text(
                              '${data.docs[index]['article']}  ${data.docs[index]['price']}',
                              style: formTextStyle,
                            ),
                          )
                        ]);
                      });
                },
              ),
            )));
  }

  void submit() {
    String date = _dateControler.text;
    String name = _nameControler.text;
    String description = _descriptionControler.text;
    String debt = _debtControler.text == ""
        ? "0"
        : _debtControler.text.replaceAll(",", ".").replaceAll(" ", "");
    String refund = _refundControler.text == ''
        ? "0"
        : _refundControler.text.replaceAll(",", ".").replaceAll(" ", "");
    String phone = _phoneComControler.text;
    if (uidIsNull) {
      CompanyDatabase(userUid: userUid).addRefundOrDebt(
          date, name, phone, description, debt, refund, context);
      CompanyDatabase(userUid: userUid)
          .deleteRefundOrDebt(widget.loanPaidUid, context);
    } else {
      CompanyDatabase(userUid: userUid).addRefundOrDebt(
          date, name, phone, description, debt, refund, context);
      _sendMessage(phone, refund, debt, widget.solde!);
    }
    Navigator.pop(context);
  }
}
