import 'package:gestion_commerce_reparation/adders/costumer.dart';
import 'package:gestion_commerce_reparation/common/constant.dart';
import 'package:gestion_commerce_reparation/modeles/user.dart';
import 'package:gestion_commerce_reparation/services/costumer_class.dart';
import 'package:gestion_commerce_reparation/services/hive_database/boxes.dart';
import 'package:gestion_commerce_reparation/viewer.dart/profils/costumer_profil.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CostumerViewerPage extends StatelessWidget {
  final String? costumerNumber;
  const CostumerViewerPage({this.costumerNumber, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: CostumerViewer(costumerNumber: costumerNumber));
  }
}

class CostumerViewer extends StatefulWidget {
  final String? costumerNumber;
  const CostumerViewer({this.costumerNumber, super.key});

  @override
  State createState() => _CostumerViewerState();
}

class _CostumerViewerState extends State<CostumerViewer> {
  String? _search;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: SizedBox(
            width: MediaQuery.of(context).size.height / 3,
            child: _buildPhone()),
      ),
      body: ValueListenableBuilder<Box<dynamic>>(
          valueListenable: CostumerBox.costumerBox!.listenable(),
          builder: (context, box, widget1) {
            var costumerData = _search == null
                ? box.values
                    .map((costumer) => Costumer(
                        uid: costumer["uid"],
                        name: costumer["name"],
                        phone: costumer["phone"],
                        adress: costumer["adress"]))
                    .toList()
                : box.values
                    .where((costumer) =>
                        costumer["name"]
                            .toUpperCase()
                            .contains(_search!.toUpperCase()) ||
                        costumer["phone"]
                            .toUpperCase()
                            .contains(_search!.toUpperCase()))
                    .map((costumer) => Costumer(
                        uid: costumer["uid"],
                        name: costumer["name"],
                        phone: costumer["phone"],
                        adress: costumer["adress"]))
                    .toList();
            costumerData.sort((a, b) => a.name!.compareTo("${b.name}"));
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                  itemCount: costumerData.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ExpansionTile(
                        title: Text(
                          "${costumerData[index].name}",
                          style: titleStyle,
                        ),
                        trailing: Text(
                          "${costumerData[index].phone}",
                          style: titleStyle,
                        ),
                        children: [
                          Text(
                            '${costumerData[index].adress}',
                            style: formTextStyle,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                  icon:
                                      const Icon(Icons.remove_red_eye_rounded),
                                  onPressed: () => {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CostumerProfilPage(
                                                      name: costumerData[index]
                                                          .name,
                                                      phone: costumerData[index]
                                                          .phone,
                                                      adress:
                                                          costumerData[index]
                                                              .adress,
                                                    ))),
                                      }),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CostumerAdd(
                                              name: costumerData[index].name,
                                              phone: costumerData[index].phone,
                                              adress:
                                                  costumerData[index].adress,
                                            ))),
                              ),
                              IconButton(
                                  icon:
                                      const Icon(Icons.delete_outline_rounded),
                                  onPressed: () {
                                    CostumerBox.costumerBox!
                                        .delete(costumerData[index].uid);
                                    CostumerDatabase().deleteCostumer(
                                        costumerData[index].uid, context);
                                  })
                            ],
                          )
                        ],
                      ),
                    );
                  }),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CostumerAddPage())),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPhone() {
    return TextFormField(
      keyboardType: TextInputType.name,
      autocorrect: false,
      decoration: textInputDecoration.copyWith(
          label: const Text(
            'Rechercher un client',
            style: formTextStyle,
          ),
          hintText: 'Rechercher un client'),
      onChanged: (value) {
        setState(() {
          _search = value;
        });
      },
    );
  }
}
