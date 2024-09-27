// import 'package:flutter/material.dart';

// void errorConnexionMessage(BuildContext context) {
//   const message = SnackBar(
//       backgroundColor: Colors.red,
//       content: Text(
//         'Erreur de connection. Verifiez que vous êtes bien connecter a internet',
//         style: TextStyle(color: Colors.white, fontSize: 20),
//       ));
//   ScaffoldMessenger.of(context).showSnackBar(message);
// }

// void errorSignOutMessage(BuildContext context) {
//   const message = SnackBar(
//       backgroundColor: Colors.red,
//       content: Text(
//         'Erreur de lors de la déconnection',
//         style: TextStyle(color: Colors.white, fontSize: 20),
//       ));
//   ScaffoldMessenger.of(context).showSnackBar(message);
// }

// void addMessage(BuildContext context) {
//   const message = SnackBar(
//       backgroundColor: Colors.transparent,
//       content: Text(
//         'Ajouté',
//         style: TextStyle(color: Colors.red, fontSize: 20),
//       ));
//   ScaffoldMessenger.of(context).showSnackBar(message);
// }

// void addError(BuildContext context) {
//   const message = SnackBar(
//       backgroundColor: Colors.transparent,
//       content: Text(
//         "Erreur lors de l'ajout",
//         style: TextStyle(color: Colors.red, fontSize: 20),
//       ));
//   ScaffoldMessenger.of(context).showSnackBar(message);
// }

// void modifyMessage(BuildContext context) {
//   const message = SnackBar(
//       backgroundColor: Colors.transparent,
//       content: Text(
//         'Modifié',
//         style: TextStyle(color: Colors.red, fontSize: 20),
//       ));
//   ScaffoldMessenger.of(context).showSnackBar(message);
// }

// void modifyError(BuildContext context) {
//   const message = SnackBar(
//       backgroundColor: Colors.transparent,
//       content: Text(
//         "Erreur lors de la modification",
//         style: TextStyle(color: Colors.red, fontSize: 20),
//       ));
//   ScaffoldMessenger.of(context).showSnackBar(message);
// }

// void deleteMessage(BuildContext context) {
//   const message = SnackBar(
//       backgroundColor: Colors.transparent,
//       content: Text(
//         'Supprimé',
//         style: TextStyle(color: Colors.red, fontSize: 20),
//       ));
//   ScaffoldMessenger.of(context).showSnackBar(message);
// }

// void deleteError(BuildContext context) {
//   const message = SnackBar(
//       backgroundColor: Colors.transparent,
//       content: Text(
//         'Erreur lors de la suppression',
//         style: TextStyle(color: Colors.red, fontSize: 20),
//       ));
//   ScaffoldMessenger.of(context).showSnackBar(message);
// }

// void costumerError(BuildContext context) {
//   const message = SnackBar(
//       backgroundColor: Colors.transparent,
//       content: Text(
//         'vous devez obligatoirement ajouter un client',
//         style: TextStyle(color: Colors.red, fontSize: 20),
//       ));
//   ScaffoldMessenger.of(context).showSnackBar(message);
// }
import 'package:flutter/material.dart';

showCostumDialog(BuildContext context, String title, String message) {
  return showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"))
            ],
          )));
}

showAddDialog(BuildContext context, e) {
  return showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: const Text("Erreur d'ajout"),
            content: Text(
                "Une erreur est survenue lors de l'ajout.\nVeuillez réessayer.\n(${e.code.toString()})"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"))
            ],
          )));
}

showModifyDialog(BuildContext context, e) {
  return showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: const Text("Erreur de modification"),
            content: Text(
                "Une erreur est survenue lors de la modificaton.\nVeuillez réessayer.\n(${e.code.toString()})"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"))
            ],
          )));
}

showDeleteDialog(BuildContext context, e) {
  return showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: const Text("Erreur de suppression"),
            content: Text(
                "Une erreur est survenue lors de la suppression.\nVeuillez réessayer.\n(${e.code.toString()})"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"))
            ],
          )));
}
