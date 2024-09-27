import 'package:gestion_commerce_reparation/adders/missing_adder.dart';
import 'package:gestion_commerce_reparation/common/constant.dart';
import 'package:gestion_commerce_reparation/services/firebase/company_database.dart';
import 'package:gestion_commerce_reparation/services/hive_database/boxes.dart';
import 'package:gestion_commerce_reparation/services/print_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MissingView extends StatefulWidget {
  final bool isSmall;
  const MissingView({required this.isSmall, super.key});

  @override
  State createState() => _MissingViewState();
}

class _MissingViewState extends State<MissingView> {
  final List<String> _missingList = [];
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<dynamic>>(
        valueListenable: MissingBox.missingBox!.listenable(),
        builder: (context, box, widget1) {
          final data = box.values.toList();

          return Scaffold(
              appBar: !widget.isSmall ? AppBar() : null,
              floatingActionButton: !widget.isSmall
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FloatingActionButton(
                          heroTag: 'addMissinBtn',
                          child: const Icon(Icons.add),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MissingAddPage())),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        FloatingActionButton(
                            heroTag: 'shareMissinBtn',
                            child: const Icon(Icons.share),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PdfMissingCreator(streamCart: data)))),
                        const SizedBox(
                          width: 10,
                        ),
                        FloatingActionButton(
                            heroTag: 'deleteMissinBtn',
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(_missingList.isEmpty
                                  ? "Tout éffacer"
                                  : "éffacer"),
                            ),
                            onPressed: () {
                              if (_missingList.isEmpty) {
                                for (var missing in data) {
                                  CompanyDatabase(userUid: userUid)
                                      .deleteMissingItem(
                                          missing["uid"], context);
                                }
                              } else {
                                for (String missing in _missingList) {
                                  CompanyDatabase(userUid: userUid)
                                      .deleteMissingItem(missing, context);
                                }
                              }
                            }),
                      ],
                    )
                  : null,
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          if (_missingList.contains(data[index]["uid"])) {
                            _missingList.remove(data[index]["uid"]);
                          } else {
                            _missingList.add(data[index]["uid"]);
                          }
                          setState(() {});
                        },
                        child: Card(
                          color: _missingList.contains(data[index]["uid"])
                              ? Colors.blue
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "${data[index]['part']} ${data[index]['model']}",
                                style: listTextStyle.copyWith(
                                    fontSize:
                                        MediaQuery.of(context).size.height > 600
                                            ? 16
                                            : 10,
                                    color: _missingList
                                            .contains(data[index]["uid"])
                                        ? Colors.white
                                        : Colors.blue)),
                          ),
                        ),
                      );
                    }),
              ));
        });
  }
}
