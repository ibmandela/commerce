import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:gestion_commerce_reparation/common/constant.dart';
import 'package:gestion_commerce_reparation/modeles/user.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:gestion_commerce_reparation/services/firebase/storage_firebase.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import 'package:printing/printing.dart';

class PdfCreator extends StatelessWidget {
  final String invoiceNumber,
      costumerName,
      costumerPhone,
      costumerAdress,
      date,
      payWay,
      discount,
      accompte,
      documentValue,
      url,
      path,
      isTicket;
  final double total;
  final List<Article> cart;

  PdfCreator(
      {required this.invoiceNumber,
      required this.costumerAdress,
      required this.costumerName,
      required this.costumerPhone,
      required this.date,
      required this.payWay,
      required this.cart,
      required this.total,
      required this.discount,
      required this.documentValue,
      required this.url,
      required this.path,
      required this.isTicket,
      required this.accompte,
      super.key});

  final spaceDown = pw.SizedBox(height: 0.2 * PdfPageFormat.cm);

  final space = pw.SizedBox(width: 0.2 * PdfPageFormat.cm);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PdfPreview(build: (format) => generatePdf(context)),
    );
  }

  Future<Uint8List> generatePdf(context) async {
    pw.MemoryImage? image;
    if (path == "" && url == "") {
      image = null;
    } else if (kIsWeb) {
      Uint8List data = await StorageFirebase().downloadWebFile(url, context);
      image = pw.MemoryImage(data);
    } else {
      image = pw.MemoryImage(File(path).readAsBytesSync());
    }
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

    pdf.addPage(pw.Page(
      pageFormat: isTicket != "A4" ? PdfPageFormat.roll80 : PdfPageFormat.a4,
      // margin: isTicket ? const pw.EdgeInsets.all(0) : null,
      build: (context) => _buildPage(image, false),
    ));
    if (isTicket == "REPAIR") {
      pdf.addPage(pw.Page(
        pageFormat: isTicket != "A4" ? PdfPageFormat.roll80 : PdfPageFormat.a4,
        // margin: isTicket ? const pw.EdgeInsets.all(0) : null,
        build: (context) => _buildPage(null, true),
      ));
    }

    return pdf.save();
  }

  pw.Widget _buildPage(image, isRepair) {
    return pw.Column(
      // crossAxisAlignment:
      //     isTicket ? pw.CrossAxisAlignment.start : pw.CrossAxisAlignment.center,
      mainAxisAlignment: isTicket != "A4"
          ? pw.MainAxisAlignment.start
          : pw.MainAxisAlignment.spaceEvenly,
      children: [
        _buildHeader(image, documentValue, invoiceNumber, costumerName,
            costumerPhone, costumerAdress, date, isRepair),
        if (isTicket == "A4") pw.SizedBox(height: PdfPageFormat.cm),
        if (isTicket == "A4") spaceDown,
        _builInvoice(cart),
        if (isTicket == "A4") spaceDown,
        _buildFooter(isRepair),
        if (isTicket == "REPAIR".toUpperCase() && !isRepair)
          pw.Text(warning,
              style: pw.TextStyle(fontSize: 6, fontWeight: pw.FontWeight.bold)),
        spaceDown,
        spaceDown,
        pw.Text(ibDeveloppe,
            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold))
      ],
    );
  }

  pw.Widget _buildHeader(image, documentValue, invoiceNumber, costumerName,
      costumerPhone, costumerAdress, date, isRepair) {
    final pw.TextStyle pdfstyle =
        pw.TextStyle(fontSize: isTicket != "A4" ? 8 : 12);
    final pw.TextStyle pdfSubtitle = pw.TextStyle(
        fontSize: isTicket != "A4" ? 9 : 13, fontWeight: pw.FontWeight.bold);

    final pw.TextStyle pdfTitle = pw.TextStyle(
        fontSize: isTicket != "A4" ? 11 : 20, fontWeight: pw.FontWeight.bold);
    final costumerInformation = [
      spaceDown,
      pw.Text(costumerName, style: pdfSubtitle),
      pw.Text(costumerPhone, style: pdfstyle),
      pw.Text(costumerAdress, style: pdfstyle),
    ];
    final companyInformation = [
      pw.Text(companyName, style: pdfTitle),
      pw.Text(companyAdress, style: pdfstyle),
      pw.Text(postalCode, style: pdfstyle),
      pw.SizedBox(height: 0.1 * PdfPageFormat.cm),
      pw.Text(companyPhone, style: pdfstyle),
      pw.Text(fax, style: pdfstyle),
      pw.SizedBox(height: 0.1 * PdfPageFormat.cm),
      pw.Text(siret, style: pdfstyle),
      pw.Text(tva, style: pdfstyle),
    ];
    return isTicket != "A4"
        ? _buildTicketHead(image, companyInformation, costumerInformation,
            pdfSubtitle, isRepair)
        : image == null
            ? pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                    pw.SizedBox(
                        width: 5 * PdfPageFormat.cm,
                        child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: companyInformation)),
                    pw.SizedBox(
                        width: 5 * PdfPageFormat.cm,
                        child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.end,
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.Text('$documentValue N°$invoiceNumber',
                                  style: pdfSubtitle),
                              ...costumerInformation,
                              spaceDown,
                              pw.Text(date, style: pdfSubtitle)
                            ]))
                  ])
            : pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          if (image != null && isTicket == "A4")
                            pw.SizedBox(
                                height: 04 * PdfPageFormat.cm,
                                child: pw.Image(image)),
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.end,
                            children: [
                              pw.Text('$documentValue N°$invoiceNumber',
                                  style: pdfSubtitle),
                              spaceDown,
                              pw.Text(date, style: pdfSubtitle),
                            ],
                          )
                        ]),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.SizedBox(
                              width: 5 * PdfPageFormat.cm,
                              child: pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: companyInformation)),
                          pw.SizedBox(
                              width: 5 * PdfPageFormat.cm,
                              child: pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: costumerInformation))
                        ])
                  ]);
  }

  _buildTicketHead(
      image, companyInformation, costumerInformation, pdfSubtitle, isRepair) {
    return pw.SizedBox(
        width: 7 * PdfPageFormat.cm,
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            if (image != null && !isRepair)
              pw.SizedBox(
                  width: 4 * PdfPageFormat.cm,
                  height: 2 * PdfPageFormat.cm,
                  child: pw.Image(image)),
            if (!isRepair) ...companyInformation.sublist(0, 6),
            spaceDown,
            pw.Text('$documentValue N°$invoiceNumber', style: pdfSubtitle),
            pw.Text(date, style: pdfSubtitle),
            spaceDown,
            ...costumerInformation,
          ],
        ));
  }

  pw.Widget _builInvoice(List cartList) {
    final pw.TextStyle pdfItem = pw.TextStyle(
        fontSize: isTicket != "A4" ? 7 : 14, fontWeight: pw.FontWeight.bold);
    final pw.TextStyle pdfSubtitle = pw.TextStyle(
        fontSize: isTicket != "A4" ? 6 : 13, fontWeight: pw.FontWeight.bold);
    return user["invoiceType"] != "1" || isTicket != "A4"
        ? pw.Column(children: [
            pw.Container(
                decoration: const pw.BoxDecoration(
                    color: PdfColor.fromInt(0xb7b7b3),
                    borderRadius: pw.BorderRadius.all(pw.Radius.circular(5))),
                width: isTicket != "A4"
                    ? 7 * PdfPageFormat.cm
                    : 17 * PdfPageFormat.cm,
                child: pw.Padding(
                  padding: pw.EdgeInsets.all(isTicket != "A4" ? 3 : 10),
                  child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        if (isTicket == "A4")
                          pw.Expanded(
                              child: pw.Text('Qté', style: pdfSubtitle)),
                        pw.SizedBox(width: 0.2 * PdfPageFormat.cm),
                        pw.Expanded(
                            child: pw.Text('Désignations', style: pdfSubtitle),
                            flex: isTicket != "A4" ? 5 : 8),
                        pw.Expanded(
                          child: pw.Text(
                            'Prix',
                            style: pdfSubtitle,
                          ),
                        ),
                        if (isTicket == "A4")
                          pw.SizedBox(width: 1 * PdfPageFormat.cm),
                      ]),
                )),
            isTicket != "A4"
                ? pw.Container(
                    // height: 11 * PdfPageFormat.cm,
                    width: 7 * PdfPageFormat.cm,
                    padding: const pw.EdgeInsets.all(0.2 * PdfPageFormat.cm),
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(bottom: pw.BorderSide()),
                    ),
                    child: pw.ListView(
                        children: cartList
                            .map((cart) => pw.Container(
                                    child: pw.Row(children: [
                                  pw.Expanded(
                                      flex: 4,
                                      child: pw.Column(
                                          crossAxisAlignment:
                                              pw.CrossAxisAlignment.start,
                                          children: [
                                            pw.Text(
                                                "${cart.article} x${cart.quantity}",
                                                style: pdfItem),
                                            pw.Text('${cart.description}',
                                                style: pdfSubtitle.copyWith(
                                                    fontWeight:
                                                        pw.FontWeight.normal))
                                          ])),
                                  pw.SizedBox(width: 0.2 * PdfPageFormat.cm),
                                  pw.Expanded(
                                      child: pw.Text(
                                          NumberFormat.currency(
                                                  locale: "fr",
                                                  symbol:
                                                      String.fromCharCode(128))
                                              .format(double.parse(
                                                  '${cart.price}')),
                                          style: cartList.length < 5
                                              ? pdfItem
                                              : pdfItem.copyWith(
                                                  fontSize:
                                                      100 / cartList.length)))
                                ])))
                            .toList()))
                : pw.Container(
                    height: 11 * PdfPageFormat.cm,
                    width: 17 * PdfPageFormat.cm,
                    padding: const pw.EdgeInsets.all(0.2 * PdfPageFormat.cm),
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(bottom: pw.BorderSide()),
                    ),
                    child: pw.ListView.builder(
                        itemBuilder: (context, index) {
                          return pw.Container(
                              color: index.isOdd
                                  ? const PdfColor.fromInt(0xf5f5f5)
                                  : null,
                              child: pw.Row(children: [
                                pw.SizedBox(width: 0.5 * PdfPageFormat.cm),
                                pw.Expanded(
                                    child: pw.Text(
                                        '${cartList[index].quantity}',
                                        style: cartList.length < 5
                                            ? pdfItem
                                            : pdfItem.copyWith(
                                                fontSize:
                                                    100 / cartList.length))),
                                pw.SizedBox(width: 0.2 * PdfPageFormat.cm),
                                pw.Expanded(
                                    flex: 14,
                                    child: pw.Column(
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.start,
                                        children: [
                                          pw.Text('${cartList[index].article}',
                                              style: cartList.length < 5
                                                  ? pdfItem
                                                  : pdfItem.copyWith(
                                                      fontSize: 100 /
                                                          cartList.length)),
                                          pw.Text(
                                              '${cartList[index].description}',
                                              style: cartList.length < 5
                                                  ? pdfSubtitle.copyWith(
                                                      fontWeight:
                                                          pw.FontWeight.normal)
                                                  : pdfItem.copyWith(
                                                      fontWeight:
                                                          pw.FontWeight.normal,
                                                      fontSize:
                                                          50 / cartList.length))
                                        ])),
                                pw.SizedBox(width: 0.5 * PdfPageFormat.cm),
                                pw.SizedBox(width: 0.2 * PdfPageFormat.cm),
                                pw.Expanded(
                                    flex: 4,
                                    child: pw.Text(
                                        NumberFormat.currency(
                                                locale: "fr",
                                                symbol:
                                                    String.fromCharCode(128))
                                            .format(double.parse(
                                                '${cartList[index].price}')),
                                        style: cartList.length < 5
                                            ? pdfItem
                                            : pdfItem.copyWith(
                                                fontSize:
                                                    100 / cartList.length)))
                              ]));
                        },
                        itemCount: cartList.length))
          ])
        : pw.Column(children: [
            pw.Container(
              width: 17 * PdfPageFormat.cm,
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.SizedBox(width: 0.5 * PdfPageFormat.cm),
                    pw.Expanded(child: pw.Text('Qté', style: pdfSubtitle)),
                    pw.SizedBox(width: 3 * PdfPageFormat.cm),
                    pw.Expanded(
                        child: pw.Text('Désignations', style: pdfSubtitle),
                        flex: 8),
                    pw.SizedBox(width: 0.2 * PdfPageFormat.cm),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        'Prix',
                        style: pdfSubtitle,
                      ),
                    )
                  ]),
            ),
            pw.Container(
                height: 11 * PdfPageFormat.cm,
                width: 17 * PdfPageFormat.cm,
                padding: const pw.EdgeInsets.all(0.2 * PdfPageFormat.cm),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                  borderRadius:
                      const pw.BorderRadius.all(pw.Radius.circular(15)),
                ),
                child: pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 20),
                  child: pw.ListView.builder(
                      itemBuilder: (context, index) {
                        return pw.Column(children: [
                          pw.Row(children: [
                            pw.SizedBox(width: 0.5 * PdfPageFormat.cm),
                            pw.Expanded(
                                child: pw.Text('${cartList[index].quantity}',
                                    style: cartList.length < 5
                                        ? pdfItem
                                        : pdfItem.copyWith(
                                            fontSize: 100 / cartList.length))),
                            pw.Expanded(
                                flex: 12,
                                child: pw.Column(children: [
                                  pw.Text('${cartList[index].article}',
                                      style: cartList.length < 5
                                          ? pdfItem
                                          : pdfItem.copyWith(
                                              fontSize: 100 / cartList.length)),
                                  pw.Text('${cartList[index].description}',
                                      style: cartList.length < 5
                                          ? pdfSubtitle.copyWith(
                                              fontWeight: pw.FontWeight.normal)
                                          : pdfItem.copyWith(
                                              fontWeight: pw.FontWeight.normal,
                                              fontSize: 50 / cartList.length))
                                ])),
                            pw.SizedBox(width: 0.5 * PdfPageFormat.cm),
                            pw.Expanded(
                                flex: 4,
                                child: pw.Text(
                                    NumberFormat.currency(
                                            locale: "fr",
                                            symbol: String.fromCharCode(128))
                                        .format(double.parse(
                                            '${cartList[index].price}')),
                                    style: cartList.length < 5
                                        ? pdfItem
                                        : pdfItem.copyWith(
                                            fontSize: 100 / cartList.length)))
                          ]),
                          pw.SizedBox(height: PdfPageFormat.cm)
                        ]);
                      },
                      itemCount: cartList.length),
                ))
          ]);
  }

  pw.Widget _buildFooter(isRepair) {
    final pw.TextStyle pdfSubtitle = pw.TextStyle(
        fontSize: isTicket != "A4" ? 8 : 13, fontWeight: pw.FontWeight.bold);
    return pw.Container(
        width: isTicket != "A4" ? 7 * PdfPageFormat.cm : 17 * PdfPageFormat.cm,
        padding: const pw.EdgeInsets.all(8),
        child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              if (!isRepair)
                pw.Column(children: [
                  pw.Text(payWay, style: pdfSubtitle),
                  pw.Container(
                    height: isTicket != "A4" ? 30 : 40,
                    width: isTicket != "A4" ? 30 : 40,
                    child: pw.BarcodeWidget(
                      barcode: pw.Barcode.qrCode(),
                      data: invoiceNumber,
                    ),
                  ),
                ]),
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    spaceDown,
                    if (double.parse(_getPrice(accompte)) > 0)
                      pw.Text(
                          'Accompte : ${NumberFormat.currency(locale: "fr", symbol: String.fromCharCode(128)).format(double.parse(accompte))}',
                          style: pdfSubtitle),
                    if (double.parse(_getPrice(discount)) > 0)
                      pw.Text(
                          'Réduction : ${NumberFormat.currency(locale: "fr", symbol: String.fromCharCode(128)).format(double.parse(discount))}',
                          style: pdfSubtitle),
                    if (double.parse(_getPrice(discount)) > 0) spaceDown,
                    pw.Text(
                        'Net à payer : ${NumberFormat.currency(locale: "fr", symbol: String.fromCharCode(128)).format(total - double.parse(_getPrice(discount)))}',
                        style: pdfSubtitle),
                    spaceDown,
                    if (isTicket != "REPAIR".toUpperCase())
                      pw.Text(
                          'Total HT : ${NumberFormat.currency(locale: "fr", symbol: String.fromCharCode(128)).format((total - double.parse(_getPrice(discount))) / 1.2)}',
                          style: pdfSubtitle),
                    spaceDown,
                    if (isTicket != "REPAIR".toUpperCase())
                      pw.Text(
                          'Total HT : ${NumberFormat.currency(locale: "fr", symbol: String.fromCharCode(128)).format(total - (total / 1.2))}',
                          style: pdfSubtitle),
                  ]),
            ]));
  }

  String _getPrice(String price) {
    String price0;
    if (price == '') {
      price0 = '0';
    } else {
      price0 = price;
    }
    return price0;
  }
}

class PdfMissingCreator extends StatelessWidget {
  final List<dynamic> streamCart;

  final pw.TextStyle? pdfTitle =
      pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold);
  final pw.TextStyle? pdfstyle = const pw.TextStyle(fontSize: 14);
  final pw.TextStyle? pdfSubtitle =
      pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold);
  final pw.TextStyle? pdfItem =
      pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold);
  final space = pw.SizedBox(width: 0.2 * PdfPageFormat.cm);
  final spaceDown = pw.SizedBox(height: 0.2 * PdfPageFormat.cm);

  PdfMissingCreator({required this.streamCart, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PdfPreview(build: (format) => _generatePdf(format)),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

    pdf.addPage(pw.MultiPage(
      build: (context) => [
        buildHeader(),
        pw.SizedBox(height: PdfPageFormat.cm),

        buildInvoiceTitle(),
        spaceDown,
        // buildStreamInvoice(),
        // spaceDown,
        pw.Wrap(
            children: streamCart
                .map((missing) => pw.Padding(
                    padding: const pw.EdgeInsets.all(3),
                    child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('${missing['part']}  ${missing['model']}',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 15)),
                          pw.Text('[  ]',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 15))
                        ])))
                .toList()),

        buildFooter()
      ],
    ));

    return pdf.save();
  }

  pw.Widget buildHeader() =>
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        pw.Container(
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
              pw.Text(companyName, style: pdfTitle),
              pw.Text(companyAdress, style: pdfstyle),
              pw.Text(postalCode, style: pdfstyle),
              pw.SizedBox(height: 0.1 * PdfPageFormat.cm),
              pw.Text(companyPhone, style: pdfstyle),
            ])),
      ]);

  pw.Widget buildInvoiceTitle() {
    return pw.Container(
        width: 17 * PdfPageFormat.cm,
        child: pw.Text('Listes des produits à Acheter', style: pdfTitle));
  }

  pw.Widget buildStreamInvoice() {
    return pw.Container(
        // height: 17 * PdfPageFormat.cm,
        // width: 17 * PdfPageFormat.cm,
        padding: const pw.EdgeInsets.all(0.2 * PdfPageFormat.cm),
        decoration: const pw.BoxDecoration(
          border: pw.Border.symmetric(horizontal: pw.BorderSide(width: 3)),
        ),
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            spaceDown,
            pw.ListView(
                children: streamCart
                    .map((missing) => pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text('${missing['part']}  ${missing['model']}',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 20)),
                              pw.Text('[  ]',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 20))
                            ]))
                    .toList())
          ],
        ));
  }
  // itemCount: streamCart.length)

  pw.Widget buildFooter() {
    return pw.Container(
        padding: const pw.EdgeInsets.all(8),
        child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                  'Saint-Ouen le ${DateFormat('dd/mm/yyyy').format(DateTime.now())}'),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                      height: 60,
                      width: 60,
                      child: pw.BarcodeWidget(
                        barcode: pw.Barcode.qrCode(),
                        data: 'IB-Develope',
                      ),
                    ),
                    pw.Text('IB-Develope')
                  ])
            ]));
  }
}

class PrintTicket {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  final _format = NumberFormat("###.00#", 'fr');

  printTicket(ticketDate, List<Article> cart, total, qRCode, ticketNumber,
      costumerName, costumerAdress, costumerPhone, payWay, discount) async {
    double net = total - double.parse(getPrice(discount));
    double ht = net / 1.2;
    double tva = net - (net / 1.2);
    bluetooth.isConnected.then((isConnected) {
      if (isConnected != null && isConnected) {
        bluetooth.printCustom(companyName, 4, 1);
        bluetooth.printCustom(companyAdress, 3, 1);
        bluetooth.printCustom(postalCode, 3, 1);
        bluetooth.printCustom(companyPhone, 3, 1);
        bluetooth.printCustom('Siret: $siret', 1, 1);
        bluetooth.printNewLine();
        bluetooth.printCustom('Ticket: $ticketNumber', 1, 1);
        bluetooth.printLeftRight('$costumerName', '$costumerPhone', 1);
        bluetooth.printCustom('$ticketDate', 1, 1);
        bluetooth.printNewLine();
        bluetooth.print3Column('Qte', 'Designation', 'prix', 0);
        bluetooth.printCustom('------------------------------', 3, 1);
        for (var article in cart) {
          bluetooth.print3Column('${article.quantity}', '${article.article}',
              '${article.price}', 0);
        }
        bluetooth.printCustom('------------------------------', 3, 1);
        if (double.parse(getPrice(discount)) > 0) {
          bluetooth.printLeftRight(
              "", "Reduction: ${_format.format(getPrice(discount))}EUR", 1);
        }
        bluetooth.printLeftRight("", "Net: ${_format.format(net)}EUR", 1);
        bluetooth.printLeftRight("", "HT: ${_format.format(ht)}EUR", 1);
        bluetooth.printLeftRight("", "TVA: ${_format.format(tva)}EUR", 1);
        bluetooth.printCustom('$payWay', 3, 1);
        bluetooth.printNewLine();
        bluetooth.printCustom('Ib-Develope', 4, 1);
        bluetooth.paperCut();
        bluetooth.paperCut();
      }
    });
  }

  printRepairTicket(
    ticketDate,
    List<Repair> cart,
    total,
    accompt,
    discount,
    qRCode,
    ticketNumber,
    costumerName,
    costumerPhone,
  ) async {
    bluetooth.isConnected.then((isConnected) {
      if (isConnected != null && isConnected) {
        bluetooth.printCustom(companyName, 4, 1);
        bluetooth.printCustom(companyAdress, 3, 1);
        bluetooth.printCustom(postalCode, 3, 1);
        bluetooth.printCustom(companyPhone, 3, 1);
        bluetooth.printCustom('Siret: $siret', 1, 1);
        bluetooth.printNewLine();
        bluetooth.printCustom('Depot: $ticketNumber', 1, 1);
        bluetooth.printLeftRight('$costumerName', '$costumerPhone', 1);
        bluetooth.printCustom('$ticketDate', 1, 1);
        bluetooth.printNewLine();
        bluetooth.printLeftRight('Designation', 'Prix', 0);
        bluetooth.printCustom('------------------------------', 3, 1);
        for (var repair in cart) {
          bluetooth.printLeftRight(
              "${repair.part} ${repair.model}", '${repair.price} EUR', 0);
        }
        bluetooth.printCustom('------------------------------', 3, 1);
        bluetooth.printCustom("Accompte: ${_format.format(accompt)}EUR", 1, 1);
        bluetooth.printCustom(
            "Reduction: ${_format.format(discount)}EUR", 1, 1);
        bluetooth.printCustom("total: ${_format.format(total)}EUR", 1, 1);
        bluetooth.printCustom(
            "Net a payer: ${_format.format(total - accompt - discount)}EUR",
            3,
            1);
        bluetooth.printNewLine();
        bluetooth.printCustom('Ib-Develope', 4, 1);
        bluetooth.paperCut();
        bluetooth.printCustom('Depot: $ticketNumber', 1, 1);
        bluetooth.printCustom('$costumerName / $costumerPhone', 1, 1);
        bluetooth.printCustom('$ticketDate', 1, 1);
        bluetooth.printNewLine();
        bluetooth.printLeftRight("Designation", 'Prix', 0);
        bluetooth.printCustom('------------------------------', 3, 1);
        for (var repair in cart) {
          bluetooth.printLeftRight(
              "${repair.part} ${repair.model}", '${repair.price}EUR', 0);
        }
        bluetooth.printCustom('------------------------------', 3, 1);
        bluetooth.printCustom("Accompte: ${_format.format(accompt)}EUR", 1, 1);
        bluetooth.printCustom(
            "Reduction: ${_format.format(discount)} EUR", 3, 1);
        bluetooth.printCustom("Total: ${_format.format(total)}EUR", 1, 1);
        bluetooth.printCustom(
            "Net a payer: ${_format.format(total - accompt - discount)}EUR",
            3,
            1);
        bluetooth.printNewLine();
        bluetooth.printCustom('Ib-Develope', 4, 1);
        bluetooth.paperCut();
      }
    });
  }

  String getPrice(String price) {
    String price0;
    if (price == '') {
      price0 = '0';
    } else {
      price0 = price;
    }
    return price0;
  }
}
