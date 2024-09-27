import 'package:gestion_commerce_reparation/adders/add_article.dart';
import 'package:gestion_commerce_reparation/services/hive_database/boxes.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class QuickSellsViewerPage extends StatelessWidget {
  final String categorie;
  const QuickSellsViewerPage({required this.categorie, super.key});

  @override
  Widget build(BuildContext context) {
    return QuickSellsViewer(categorie: categorie);
  }
}

class QuickSellsViewer extends StatefulWidget {
  final String categorie;
  const QuickSellsViewer({required this.categorie, super.key});

  @override
  State<QuickSellsViewer> createState() => _QuickSellsViewerState();
}

class _QuickSellsViewerState extends State<QuickSellsViewer> {
  bool isQuickSell = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: Container(
        color: Colors.white,
        child: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ArticleAdderPage(
                                categorie: widget.categorie,
                              )))
                }),
      ),
      body: ValueListenableBuilder<Box<dynamic>>(
        valueListenable: ArticleBox.articleBox!.listenable(),
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
                                    builder: (context) => ArticleAdderPage(
                                          articleUid: data[index].id,
                                          article: data[index]['article'],
                                          price: data[index]['price'],
                                          categorie: data[index]['categorie'],
                                        )));
                          },
                          child: _buildCard(
                              data[index]["article"], data[index]["price"])));
                }),
          );
        },
      ),
    );
  }

  _buildCard(article, price) {
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
          '$article\n$price€',
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
