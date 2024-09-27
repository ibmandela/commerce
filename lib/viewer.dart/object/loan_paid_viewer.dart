import 'package:gestion_commerce_reparation/adders/paid_loan.dart';
import 'package:gestion_commerce_reparation/modeles/user.dart';
import 'package:gestion_commerce_reparation/services/hive_database/boxes.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class LoanPaidviewerPage extends StatelessWidget {
  const LoanPaidviewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoanPaidviewer();
  }
}

class LoanPaidviewer extends StatefulWidget {
  final String? phone, name, adress;
  const LoanPaidviewer({super.key, this.phone, this.name, this.adress});

  @override
  State createState() => _LoanPaidviewerState();
}

class _LoanPaidviewerState extends State<LoanPaidviewer> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<dynamic>>(
        valueListenable: DebtOrRefundBox.debtorRefundBox!.listenable(),
        builder: (context, box, widget1) {
          final data = box.values
              .where((debtOrRefund) => debtOrRefund["number"] == widget.phone)
              .map((debtOrRefund) => DebtOrRefund(
                  date: debtOrRefund["date"],
                  debt: debtOrRefund["debt"],
                  description: debtOrRefund["description"],
                  name: debtOrRefund["name"],
                  number: debtOrRefund["number"],
                  refund: debtOrRefund["refund"],
                  uid: debtOrRefund["uid"]))
              .toList();
          double totalDebt =
              data.fold(0, (prev, debt) => prev + parseDouble('${debt.debt}'));
          double totalRefund = data.fold(
              0, (prev, refund) => prev + parseDouble('${refund.refund}'));
          data.sort((a, b) => DateFormat("dd/MM/yy")
              .parse("${b.date}")
              .compareTo(DateFormat("dd/MM/yy").parse("${a.date}")));
          return Scaffold(
            body: Column(
              children: [
                Row(children: [
                  Expanded(
                    child: Card(
                        elevation: 10,
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        margin: const EdgeInsets.all(3),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: MediaQuery.of(context).size.height > 600
                                  ? 10
                                  : 0),
                          child: Text('Dates',
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 50,
                                  fontWeight: FontWeight.bold)),
                        )),
                  ),
                  Expanded(
                    flex: 2,
                    child: Card(
                        elevation: 10,
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        color: Colors.white,
                        margin: const EdgeInsets.all(3),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: MediaQuery.of(context).size.height > 600
                                  ? 10
                                  : 0),
                          child: Text('Dettes',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize:
                                      MediaQuery.of(context).size.width / 50,
                                  fontWeight: FontWeight.bold)),
                        )),
                  ),
                  Expanded(
                    child: Card(
                        elevation: 10,
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        margin: const EdgeInsets.all(3),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: MediaQuery.of(context).size.height > 600
                                  ? 10
                                  : 0),
                          child: Text('Remboursements',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize:
                                      MediaQuery.of(context).size.width / 50,
                                  fontWeight: FontWeight.bold)),
                        )),
                  )
                ]),
                Expanded(
                  child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Row(children: [
                          Expanded(
                            child: Card(
                                elevation: 10,
                                shape: const RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Colors.white,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                                margin: const EdgeInsets.all(3),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical:
                                          MediaQuery.of(context).size.height >
                                                  600
                                              ? 10
                                              : 0),
                                  child: Text('${data[index].date}',
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              50,
                                          fontWeight: FontWeight.bold)),
                                )),
                          ),
                          Expanded(
                            flex: 2,
                            child: Card(
                                elevation: 10,
                                shape: const RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.red),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                                color: Colors.red,
                                margin: const EdgeInsets.all(3),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical:
                                          MediaQuery.of(context).size.height >
                                                  600
                                              ? 10
                                              : 0),
                                  child: Text(
                                      '${data[index].description} : ${data[index].debt}',
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              50,
                                          fontWeight: FontWeight.bold)),
                                )),
                          ),
                          Expanded(
                            child: Card(
                                elevation: 10,
                                shape: const RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.green),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                                color: Colors.green,
                                margin: const EdgeInsets.all(3),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical:
                                          MediaQuery.of(context).size.height >
                                                  600
                                              ? 10
                                              : 0),
                                  child: Text('${data[index].refund}',
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              50,
                                          fontWeight: FontWeight.bold)),
                                )),
                          )
                        ]);
                      }),
                ),
                Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue, width: 3),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30))),
                          height: MediaQuery.of(context).size.height > 600
                              ? 60
                              : 50,
                          padding: const EdgeInsets.all(3),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text(
                                  'solde',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11),
                                ),
                                Text(
                                    NumberFormat.currency(locale: 'fr')
                                        .format(totalRefund - totalDebt),
                                    style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11))
                              ]),
                        )),
                        Expanded(
                            child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.red, width: 3),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30))),
                          height: MediaQuery.of(context).size.height > 600
                              ? 60
                              : 50,
                          padding: const EdgeInsets.all(5),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text(
                                  'Total dettes',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11),
                                ),
                                Text(
                                    NumberFormat.currency(locale: 'fr')
                                        .format(totalDebt),
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11))
                              ]),
                        )),
                        Expanded(
                            child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.green, width: 3),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30))),
                          height: MediaQuery.of(context).size.height > 600
                              ? 60
                              : 50,
                          padding: const EdgeInsets.all(5),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text(
                                  'Total payés',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11),
                                ),
                                Text(
                                    NumberFormat.currency(locale: 'fr')
                                        .format(totalRefund),
                                    style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11))
                              ]),
                        )),
                        const Expanded(child: SizedBox()),
                      ],
                    )),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaidLoan(
                              name: widget.name,
                              phone: widget.phone,
                              adress: widget.adress,
                              solde: totalRefund - totalDebt,
                            )));
              },
              child: const Icon(Icons.add),
            ),
          );
        });
  }

  double parseDouble(String strNumber) {
    if (strNumber.isNotEmpty) {
      return double.parse(strNumber);
    } else {
      return 0;
    }
  }
}
