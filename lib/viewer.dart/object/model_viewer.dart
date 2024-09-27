import 'package:gestion_commerce_reparation/adders/models_adder.dart';
import 'package:gestion_commerce_reparation/common/constant.dart';
import 'package:gestion_commerce_reparation/services/hive_database/boxes.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ModelViewPage extends StatelessWidget {
  final String? model;
  const ModelViewPage({this.model, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ModelAdderPage())),
          child: const Icon(Icons.add),
        ),
        body: ModelView(
          model: model,
        ));
  }
}

class ModelView extends StatefulWidget {
  final String? model;
  const ModelView({this.model, super.key});

  @override
  State createState() => _ModelViewState();
}

class _ModelViewState extends State<ModelView> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<dynamic>>(
        valueListenable: ModelBox.modelBox!.listenable(),
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
                    title:
                        Text("${data[index]['model']}", style: listTextStyle),
                  )
                ]);
              });
        });
  }
}
