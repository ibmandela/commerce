import 'package:gestion_commerce_reparation/gestion.dart';
import 'package:gestion_commerce_reparation/homes/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User?>(context);

    if (user == null) {
      return const Gestion();
    } else {
      return HomePage(
        userUid: user.uid,
      );
    }
  }
}
