import 'package:gestion_commerce_reparation/common/constant.dart';
import 'package:gestion_commerce_reparation/services/firebase/company_database.dart';
import 'package:gestion_commerce_reparation/services/costumer_class.dart';
import 'package:gestion_commerce_reparation/services/hive_database/boxes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../modeles/user.dart';

class CostumerAddPage extends StatelessWidget {
  const CostumerAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CostumerAdd();
  }
}

class CostumerAdd extends StatefulWidget {
  final String? name, phone, adress;
  const CostumerAdd({super.key, this.name, this.adress, this.phone});

  @override
  State createState() => _CostumerAddState();
}

class _CostumerAddState extends State<CostumerAdd> {
  final _nameControler = TextEditingController();
  final _adressComControler = TextEditingController();
  final _phoneComControler = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool uidIsnull = true;
  bool isDone = false;

  final spaceDown = const SizedBox(
    height: 10,
  );
  int repairItemsModify = 0;
  int activityItemsModify = 0;
  int debtItemsModiify = 0;

  @override
  void dispose() {
    _nameControler.dispose();
    _adressComControler.dispose();
    _phoneComControler.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.phone != null) {
      _nameControler.text = '${widget.name}';
      _phoneComControler.text = '${widget.phone}';
      _adressComControler.text = '${widget.adress}';
      uidIsnull = !uidIsnull;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
        title: Text(uidIsnull ? "Ajouter un client" : "Modifier un client"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                if (!isDone) _buildCostumerCard(),
                spaceDown,
                if (!isDone) _buildButton(),
                if (isDone) Center(child: _buildBackButton())
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
          borderRadius: BorderRadius.all(Radius.circular(20))),
      color: Colors.blue,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'Informations du clients',
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
                spaceDown,
                _buildName(),
                spaceDown,
                _buildPhone(),
                spaceDown,
                _buildAdress(),
                spaceDown
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
            'Nom du Client',
            style: formTextStyle,
          ),
          hintText: 'Nom du client'),
      controller: _nameControler,
      validator: (value) {
        if (value == null || value.length < 2) {
          return "Cet nom est invalide";
        } else {
          return null;
        }
      },
    );
  }

  Widget _buildAdress() {
    return TextFormField(
      keyboardType: TextInputType.streetAddress,
      autocorrect: true,
      textCapitalization: TextCapitalization.characters,
      decoration: textInputDecoration.copyWith(
          prefixIcon: const Icon(
            Icons.home,
            color: Colors.blue,
          ),
          label: const Text(
            "Adresse du client",
            style: formTextStyle,
          ),
          hintText: "Adresse du client"),
      controller: _adressComControler,
      validator: (value) {
        if (value == null) {
          return null;
        }
        if (value.isNotEmpty && value.length < 6) {
          return "Entrez une adresse valide SVP";
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

  _buildBackButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: borderRaduis,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            textStyle: textStyle),
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text("Retour"));
  }

  Widget _buildButton() {
    return FutureBuilder<List>(
        future: Future.wait([
          CompanyDatabase(userUid: userUid)
              .activitiesByCostumerFuture('${widget.phone}'),
          CompanyDatabase(userUid: userUid)
              .refundsOrdebtsByCostumerFuture('${widget.phone}'),
          CompanyDatabase(userUid: userUid).repairsBycostumerFutre(widget.phone)
        ]),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Une erreur s'est produit");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loader;
          }

          return ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: borderRaduis,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  textStyle: textStyle),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    isDone = !isDone;
                  });
                  _showUpdateDialogue(
                      snapshot.data![0], snapshot.data![2], snapshot.data![1]);
                }
              },
              child: Text(uidIsnull ? "Ajouter" : "Modifier"));
        });
  }

  Future _submit() async {
    var name = _nameControler.value.text;
    var adress = _adressComControler.value.text;
    var phone = _phoneComControler.value.text;
    CostumerBox.costumerBox!.put(
        phone, {"name": name, "phone": phone, "adress": adress, "uid": phone});

    CostumerDatabase().addCostumer(name, adress, phone, context);
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
                                  _adressComControler.text =
                                      data.docs[index]['adress'];
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

  _showUpdateDialogue(List<Activity> activities, List<RepairActivity> repairs,
      List<DebtOrRefund> debts) {
    List<dynamic> hiveActivity = ActivitiesBox.activitiesBox!.values
        .where(
          (activity) => activity["phone"] == widget.phone,
        )
        .toList();
    List<dynamic> hiveRepair = RepairBox.repairBox!.values
        .where(
          (repair) => repair["phone"] == widget.phone,
        )
        .toList();
    List<dynamic> hiveDebtOrRefund = DebtOrRefundBox.debtorRefundBox!.values
        .where(
          (debtOrRefunf) => debtOrRefunf["number"] == widget.phone,
        )
        .toList();
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Rapport'),
              content: SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: Column(
                  children: [
                    const Text(
                      'Vous etes sur le point de Modifier les informations du client suivant:',
                      style: textStyle,
                    ),
                    Text('Nom: ${widget.name}'),
                    Text('Téléphone: ${widget.phone}'),
                    Text('Adresse: ${widget.adress}'),
                    const Text('**************************'),
                    const Text(
                      'par les informations suivantes:',
                      style: textStyle,
                    ),
                    Text('Nom: ${_nameControler.value.text}'),
                    Text('Téléphone: ${_phoneComControler.value.text}'),
                    Text('Adresse: ${_adressComControler.value.text}'),
                    const Text('**************************'),
                    if (activities.isNotEmpty ||
                        repairs.isNotEmpty ||
                        debts.isNotEmpty)
                      const Text('Cela impactera:'),
                    if (activities.isNotEmpty)
                      Text('${activities.length} Vente(s)'),
                    if (repairs.isNotEmpty)
                      Text('${repairs.length} Réparation(s)'),
                    if (debts.isNotEmpty)
                      Text('${debts.length} Dettes et remboursement(s)'),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => {
                          Navigator.pop(context),
                          _updateActivityNumber(activities),
                          _updateDebtNumber(debts),
                          _updateRepairNumber(repairs),
                          _updateHiveActivityNumber(hiveActivity),
                          _updateHiveDebtNumber(hiveDebtOrRefund),
                          _updateHiveRepairNumber(hiveRepair),
                          CostumerDatabase()
                              .deleteCostumer(widget.phone, context),
                          CostumerBox.costumerBox!.delete(widget.phone),
                          _submit(),
                        },
                    child: const Text('Valider')),
                TextButton(
                    onPressed: () => {Navigator.pop(context)},
                    child: const Text('Annuler'))
              ],
            ));
  }

  _updateRepairNumber(List<RepairActivity> list) {
    for (var repair in list) {
      CompanyDatabase(userUid: userUid).modifyRepairNumber(
          repair.repairUid, _phoneComControler.value.text, context);
    }
  }

  _updateDebtNumber(List<DebtOrRefund> list) {
    for (var debtOrRefund in list) {
      CompanyDatabase(userUid: userUid).modifyDebtOrRefundPhone(
          debtOrRefund.uid, _phoneComControler.value.text, context);
    }
  }

  _updateActivityNumber(List<Activity> list) {
    for (var activity in list) {
      CompanyDatabase(userUid: userUid).modifyActitvityNumber(
          activity.activityUid, _phoneComControler.value.text, context);
    }
  }

  _updateHiveRepairNumber(List<dynamic> list) {
    for (var repair in list) {
      RepairBox.repairBox!.put(repair["uid"], {
        "repairList": repair["repairList"],
        "costumerName": repair["costumerName"],
        "phone": _phoneComControler.value.text,
        "costumerAdress": repair["costumerAdress"],
        "discount": repair["discount"],
        "accompte": repair["accompte"],
        "emplacement": repair["emplacement"],
        "ticketNumber": repair["ticketNumber"],
        "state": repair["state"],
        "date": repair["date"],
        "total": repair["total"],
        "uid": repair["uid"]
      });
    }
  }

  _updateHiveDebtNumber(List<dynamic> list) {
    for (var debtOrRefund in list) {
      DebtOrRefundBox.debtorRefundBox!.put(debtOrRefund["uid"], {
        "date": debtOrRefund["date"],
        "debt": debtOrRefund["debt"],
        "description": debtOrRefund["description"],
        "name": debtOrRefund["name"],
        "number": _phoneComControler.value.text,
        "refund": debtOrRefund["refund"],
        "uid": debtOrRefund["uid"]
      });
    }
  }

  _updateHiveActivityNumber(List<dynamic> list) {
    for (var activity in list) {
      ActivitiesBox.activitiesBox!.put(activity["uid"], {
        "activityList": activity["activityList"],
        "costumerName": activity["costumerName"],
        "phone": _phoneComControler.value.text,
        "costumerAdress": activity["costumerAdress"],
        "discount": activity["discount"],
        "payWay": activity["payWay"],
        "ticketNumber": activity["ticketNumber"],
        "date": activity["date"],
        "isEstimate": activity["isEstimate"],
        "total": activity["total"],
        "uid": activity["uid"],
      });
    }
  }
}
