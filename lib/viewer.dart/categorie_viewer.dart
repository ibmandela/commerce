import 'package:gestion_commerce_reparation/adders/add_article.dart';
import 'package:gestion_commerce_reparation/adders/categorie_adder.dart';
import 'package:gestion_commerce_reparation/services/hive_database/boxes.dart';
import 'package:gestion_commerce_reparation/viewer.dart/article_viewer.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CategorieViewerPage extends StatelessWidget {
  const CategorieViewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CategorieViewer();
  }
}

class CategorieViewer extends StatefulWidget {
  const CategorieViewer({super.key});

  @override
  State<CategorieViewer> createState() => _CategorieViewerState();
}

class _CategorieViewerState extends State<CategorieViewer> {
  bool isQuickSell = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: Container(
          color: Colors.white,
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ArticleAdderPage(
                                isQuickSell: true,
                              )));
                },
                child: const Text('Vente ou Devis')),
            FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CategorieAdderPage()))
                    }),
          ])),
      body: ValueListenableBuilder<Box<dynamic>>(
        valueListenable: CategoriesBox.categoriesBox!.listenable(),
        builder: (context, box, widget1) {
          final data = box.values.toList();
          return Padding(
            padding: const EdgeInsets.all(8),
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return GridTile(
                      child: InkWell(
                          onLongPress: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CategorieAdderPage(
                                          categorie: data[index]['categorie'],
                                          categorieUid: data[index].id,
                                        )));
                          },
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => QuickSellsViewerPage(
                                          categorie: data[index]['categorie'],
                                        )));
                          },
                          child: _buildCard(data[index]["categorie"])));
                }),
          );
        },
      ),
    );
  }

  _buildCard(article) {
    return Hero(
      tag: article,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.35,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          color: Colors.blue,
        ),
        child: Center(
            child: Text(
          '$article',
          style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        )),
      ),
    );
  }
}
