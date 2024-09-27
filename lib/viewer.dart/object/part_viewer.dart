import 'package:gestion_commerce_reparation/adders/part_adder.dart';
import 'package:gestion_commerce_reparation/common/constant.dart';
import 'package:gestion_commerce_reparation/services/hive_database/boxes.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PartViewPage extends StatelessWidget {
  final String? part;

  const PartViewPage({this.part, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const PartAdderPage())),
          child: const Icon(Icons.add),
        ),
        body: PartView(
          part: part,
        ));
  }
}

class PartView extends StatefulWidget {
  final String? part;
  const PartView({this.part, super.key});

  @override
  State createState() => _PartViewState();
}

class _PartViewState extends State<PartView> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<dynamic>>(
        valueListenable: PartBox.partBox!.listenable(),
        builder: (context, box, widget1) {
          final data = box.values.toList();

          return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Column(children: [
                  const Divider(
                    thickness: 2,
                    height: 2.0,
                  ),
                  ListTile(
                    title: Text("${data[index]['part']}", style: listTextStyle),
                  )
                ]);
              });
        });
  }
}
