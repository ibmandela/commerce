import 'package:gestion_commerce_reparation/common/constant.dart';
import 'package:gestion_commerce_reparation/viewer.dart/activity.dart';
import 'package:gestion_commerce_reparation/viewer.dart/object/loan_paid_viewer.dart';
import 'package:flutter/material.dart';
import 'package:gestion_commerce_reparation/viewer.dart/statistic_viewer.dart';

class CostumerProfilPage extends StatelessWidget {
  final String? name, phone, adress;
  const CostumerProfilPage(
      {required this.name,
      required this.phone,
      required this.adress,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CostumerProfil(
      name: name,
      adress: adress,
      phone: phone,
    ));
  }
}

class CostumerProfil extends StatefulWidget {
  final String? name, phone, adress;
  const CostumerProfil({
    super.key,
    required this.name,
    required this.adress,
    required this.phone,
  });
  @override
  State createState() => _CostumerProfilState();
}

class _CostumerProfilState extends State<CostumerProfil> {
  final spaceDown = const SizedBox(
    height: 10,
  );
  final space = const SizedBox(
    width: 30,
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: MediaQuery.of(context).size.height < 600
                ? const Size.fromHeight(40)
                : const Size.fromHeight(60),
            child: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _builIcon(
                      const Icon(
                        Icons.person_pin,
                        color: Colors.blue,
                      ),
                      '${widget.name}'),
                  const SizedBox(
                    height: 5,
                  ),
                  _builIcon(
                      const Icon(
                        Icons.phone,
                        color: Colors.blue,
                      ),
                      '${widget.phone}'),
                  const SizedBox(
                    height: 5,
                  ),
                  _builIcon(
                      const Icon(
                        Icons.location_pin,
                        color: Colors.blue,
                      ),
                      '${widget.adress}'),
                ],
              ),
            )),
        backgroundColor: Colors.blue,
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: MediaQuery.of(context).size.height > 600 ? 10.0 : 0),
          child: Column(children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [Expanded(child: _buildTabIcon())],
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(30))),
                  padding: const EdgeInsets.all(8),
                  child: _buildTabView()),
            )
          ]),
        ),
      ),
    );
  }

  _buildTabIcon() {
    return TabBar(
      labelColor: Colors.white,
      labelPadding: const EdgeInsets.all(0),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      indicatorColor: Colors.white,
      indicatorWeight: 3,
      indicatorPadding: const EdgeInsets.all(0),
      tabs: [
        Tab(
            // height: 45,
            iconMargin: const EdgeInsets.all(0),
            icon: MediaQuery.of(context).size.height > 600
                ? const Icon(
                    Icons.sell_outlined,
                  )
                : null,
            text: 'Ventes'),
        Tab(
            // height: 40,
            iconMargin: const EdgeInsets.all(0),
            icon: MediaQuery.of(context).size.height > 600
                ? const Icon(
                    Icons.home_repair_service,
                  )
                : null,
            text: 'Activités'),
        Tab(
            // height: 40,
            iconMargin: const EdgeInsets.all(0),
            icon: MediaQuery.of(context).size.height > 600
                ? const Icon(Icons.attach_money_rounded)
                : null,
            text: 'Solde'),
      ],
    );
  }

  _buildTabView() {
    return TabBarView(
      children: [
        _builActivityList(),
        _builRepairList(),
        LoanPaidviewer(
          phone: widget.phone,
          adress: widget.phone,
          name: widget.name,
        )
      ],
    );
  }

  _builActivityList() {
    return StatViewerPage(
      isCostumerView: true,
      costumerName: widget.name,
    );
  }

  _builRepairList() {
    return ActivityPage(
      isCostumerView: true,
      costumerName: widget.name,
    );
  }

  _builIcon(Icon icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: MediaQuery.of(context).size.height > 600 ? 10 : 3),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.white),
          borderRadius: const BorderRadius.all(Radius.circular(30))),
      child: Row(
        children: [
          icon,
          space,
          Text(
            label,
            style: formTextStyle,
          )
        ],
      ),
    );
  }
}
