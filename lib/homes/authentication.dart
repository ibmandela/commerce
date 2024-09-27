// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:gestion_commerce_reparation/common/constant.dart';
import 'package:gestion_commerce_reparation/common/message.dart';
import 'package:gestion_commerce_reparation/common/widget/actions.dart';
import 'package:gestion_commerce_reparation/services/firebase/database.dart';
import 'package:gestion_commerce_reparation/services/hive_database/boxes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Authenticate();
  }
}

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool _loading = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final _emailControler = TextEditingController();
  final _verifyEmailControler = TextEditingController();
  final _passwordCrontroler = TextEditingController();
  final _verifyPasswordCrontroler = TextEditingController();
  final _companyNameControler = TextEditingController();
  final _adressComControler = TextEditingController();
  final _postalCodeComControler = TextEditingController();
  final _phoneComControler = TextEditingController();
  final _faxComControler = TextEditingController();
  final _siretControler = TextEditingController();
  final _tvaControler = TextEditingController();

  bool _showSignIn = true;
  bool _showForgetPassword = false;
  var spaceDown = const SizedBox(
    height: 5,
  );

  @override
  void dispose() {
    _emailControler.dispose();
    _passwordCrontroler.dispose();
    _companyNameControler.dispose();
    _postalCodeComControler.dispose();
    _phoneComControler.dispose();
    _faxComControler.dispose();
    _siretControler.dispose();
    _tvaControler.dispose();
    _verifyEmailControler.dispose();
    _verifyPasswordCrontroler.dispose();
    super.dispose();
  }

  void toggleView() {
    setState(() {
      _formKey.currentState!.reset();
      _showSignIn = !_showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: actions(context),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(
                MediaQuery.of(context).size.width > 600 ? 20.0 : 20),
            child: Center(
              child: Material(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width > 600 ? 600 : null,
                  child: Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width > 600 ? 50.0 : 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _showSignIn
                              ? "Formulaire de création de compte"
                              : "S'authentifier",
                          style: formTextStyle,
                        ),
                        spaceDown,
                        spaceDown,
                        _buildEmail(),
                        spaceDown,
                        if (_showSignIn) _buildVerifyEmail(),
                        spaceDown,
                        if (!_showForgetPassword) _buildPassword(),
                        spaceDown,
                        if (_showSignIn) _buildVerifyPassword(),
                        spaceDown,
                        if (_showSignIn) _buildCompanyName(),
                        spaceDown,
                        if (_showSignIn) _buildCompAdress(),
                        spaceDown,
                        if (_showSignIn) _builPostalCode(),
                        spaceDown,
                        if (_showSignIn) _buildComPhone(),
                        spaceDown,
                        if (_showSignIn) _builFax(),
                        spaceDown,
                        if (_showSignIn) _buildSiret(),
                        spaceDown,
                        if (_showSignIn) _buildTva(),
                        spaceDown,
                        buildButton(),
                        spaceDown,
                        spaceDown,
                        TextButton(
                            onPressed: () => toggleView(),
                            child: Text(
                              _showSignIn ? 'Se connecter' : 'Créer un compte',
                              style: titleStyle,
                            )),
                        spaceDown,
                        if (!_showSignIn) _buildForgetPassword()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmail() {
    return TextFormField(
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        textCapitalization: TextCapitalization.none,
        decoration: textInputDecoration.copyWith(
            label: const Text('Email', style: formTextStyle),
            hintText: 'Email'),
        controller: _emailControler,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Ce champ est obligatoire";
          } else if (!RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(value)) {
            return "Veuillez entrer un email valide";
          }
          return null;
        });
  }

  Widget _buildVerifyEmail() {
    return TextFormField(
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        textCapitalization: TextCapitalization.none,
        decoration: textInputDecoration.copyWith(
            label: const Text("Confirmation de l'email", style: formTextStyle),
            hintText: "Confirmation de l'email"),
        controller: _verifyEmailControler,
        validator: (value) {
          if (value != _emailControler.value.text) {
            return "L'email et sa confirmation sont différents";
          }
          return null;
        });
  }

  Widget _buildPassword() {
    return TextFormField(
      keyboardType: TextInputType.text,
      obscureText: true,
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
      decoration: textInputDecoration.copyWith(
          label: const Text('Mot de passe', style: formTextStyle),
          hintText: 'Mot de passe'),
      controller: _passwordCrontroler,
      validator: (value) {
        if (value == null || value.length < 6) {
          return "Veuillez entrer un mot de passe valide SVP";
        } else {
          return null;
        }
      },
    );
  }

  Widget _buildVerifyPassword() {
    return TextFormField(
      keyboardType: TextInputType.text,
      obscureText: true,
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
      decoration: textInputDecoration.copyWith(
          label:
              const Text('Confirmation du mot de passe', style: formTextStyle),
          hintText: 'Confirmation du mot de passe'),
      controller: _verifyPasswordCrontroler,
      validator: (value) {
        if (value != _passwordCrontroler.value.text) {
          return "Le mot de passe et sa confirmation sont différents";
        } else {
          return null;
        }
      },
    );
  }

  Widget _buildCompanyName() {
    return TextFormField(
      keyboardType: TextInputType.name,
      autocorrect: false,
      textCapitalization: TextCapitalization.words,
      decoration: textInputDecoration.copyWith(
          label: const Text(
            "Nom de l'entreprise",
            style: formTextStyle,
          ),
          hintText: "Nom de l'entreprise"),
      controller: _companyNameControler,
      validator: (value) {
        if (value == null && value!.isEmpty) {
          return "Ce champ est obligatoire";
        }
        return null;
      },
    );
  }

  Widget _buildCompAdress() {
    return TextFormField(
      keyboardType: TextInputType.streetAddress,
      autocorrect: true,
      textCapitalization: TextCapitalization.words,
      decoration: textInputDecoration.copyWith(
          label: const Text("Adresse de l'entreprise", style: formTextStyle),
          hintText: "Adresse de l'entreprise"),
      controller: _adressComControler,
      validator: (value) {
        if (value == null) {
          return null;
        } else if (value.isNotEmpty && value.length < 2) {
          return "Cette adresse est invalide";
        } else {
          return null;
        }
      },
    );
  }

  Widget _buildComPhone() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      autocorrect: false,
      decoration: textInputDecoration.copyWith(
          label: const Text('numéro de téléphone', style: formTextStyle),
          hintText: 'numéro de téléphone'),
      controller: _phoneComControler,
      validator: (value) {
        if (value == null) {
          return null;
        } else if (value.isNotEmpty && value.length < 10) {
          return "Ce numéro de telephone est invalide";
        } else {
          return null;
        }
      },
    );
  }

  Widget _builPostalCode() {
    return TextFormField(
      keyboardType: TextInputType.name,
      autocorrect: false,
      decoration: textInputDecoration.copyWith(
        label: const Text('Code postal', style: formTextStyle),
        hintText: 'Code postal',
      ),
      controller: _postalCodeComControler,
      validator: (value) {
        if (value == null) {
          return null;
        }
        if (value.isNotEmpty && value.length < 2) {
          return "Verifiez champ SVP";
        } else {
          return null;
        }
      },
    );
  }

  Widget _builFax() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
      decoration: textInputDecoration.copyWith(
          label: const Text('Fax', style: formTextStyle), hintText: 'Fax'),
      controller: _faxComControler,
      validator: (value) {
        if (value == null) {
          return null;
        }
        if (value.isNotEmpty && value.length < 2) {
          return "Verifiez champ SVP";
        } else {
          return null;
        }
      },
    );
  }

  Widget _buildSiret() {
    return TextFormField(
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.none,
      decoration: textInputDecoration.copyWith(
          label: const Text('Siret', style: formTextStyle), hintText: 'Siret'),
      controller: _siretControler,
      validator: (value) {
        if (value == null) {
          return null;
        }
        if (value.isNotEmpty && value.length < 2) {
          return "Verifiez champ SVP";
        } else {
          return null;
        }
      },
    );
  }

  Widget _buildTva() {
    return TextFormField(
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.none,
      decoration: textInputDecoration.copyWith(
          label: const Text('Numéro de TVA', style: formTextStyle),
          hintText: 'Numéro de TVA'),
      controller: _tvaControler,
      validator: (value) {
        if (value == null) {
          return null;
        }
        if (value.isNotEmpty && value.length < 2) {
          return "Verifiez champ SVP";
        } else {
          return null;
        }
      },
    );
  }

  Widget buildButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            backgroundColor: Colors.blue,
            elevation: 30),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            setState(() {
              _loading = true;
              submit();
            });
          }
        },
        child: _loading
            ? loader
            : Text(
                _showSignIn
                    ? "Valider"
                    : _showForgetPassword
                        ? "Envoyer"
                        : "Connexion",
                style: const TextStyle(fontSize: 20),
              ));
  }

  _buildForgetPassword() {
    return TextButton(
        onPressed: () {
          setState(() {
            _showForgetPassword = !_showForgetPassword;
          });
        },
        child:
            Text(_showForgetPassword ? "Se connecter" : "Mot de passe oublié"));
  }

  Future _sendResetMessage() async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(
          email: _emailControler.value.text);
      setState(() {
        _showForgetPassword = false;
        _loading = false;
      });
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        if (e.code == "network-request-failed") {
          showCostumDialog(context, "Erreur de connexion",
              "Vérifiez que vous êtes bien connecté à internet puis réessayez.");
        } else if (e.code == "user-not-found") {
          showCostumDialog(context, "Attention!!!",
              "Votre email est incorrect.\n Vérifiez le puis réessayez.");
        } else {
          showCostumDialog(context, "Erreur de reinitialisation",
              "Une erreur est survenue.\nVeuillez réessayer.");
        }
      }
      setState(() {
        _loading = false;
      });
    }
  }

  Future submit() async {
    dynamic result = !_showSignIn
        ? _showForgetPassword
            ? await _sendResetMessage()
            : await _signIn()
        : _register();

    log("Verification   $result");
  }

  _signIn() async {
    try {
      // UserCredential result =
      await _firebaseAuth
          .signInWithEmailAndPassword(
              email: _emailControler.value.text,
              password: _passwordCrontroler.value.text)
          .then((credential) async {
        await FirebaseFirestore.instance
            .collection("Companies")
            .doc(credential.user!.uid)
            .get()
            .then((doc) {
          CurrentUserBox().loadUser(doc);
        });
        FirebaseFirestore.instance
            .collection("Companies")
            .doc(credential.user!.uid)
            .collection("Costumers")
            .snapshots()
            .listen((costumers) =>
                CostumerBox.instance.laodCostumers(costumers.docs));
        FirebaseFirestore.instance
            .collection("Companies")
            .doc(credential.user!.uid)
            .collection("Stock")
            .snapshots()
            .listen((data) => StockBox.instance.loadStock(data.docs));
        FirebaseFirestore.instance
            .collection("Companies")
            .doc(credential.user!.uid)
            .collection("Activities")
            .snapshots()
            .listen((data) => ActivitiesBox.instance.loadActivities(data.docs));
        FirebaseFirestore.instance
            .collection("Companies")
            .doc(credential.user!.uid)
            .collection("Repairs")
            .snapshots()
            .listen((data) => RepairBox.instance.laodRepairs(data.docs));
        FirebaseFirestore.instance
            .collection("Companies")
            .doc(credential.user!.uid)
            .collection("DebtOrRefund")
            .snapshots()
            .listen(
                (data) => DebtOrRefundBox.instance.loadDebtOrRefund(data.docs));
        FirebaseFirestore.instance
            .collection("Companies")
            .doc(credential.user!.uid)
            .collection("Articles")
            .snapshots()
            .listen((data) => ArticleBox.instance.loadArticles(data.docs));
        FirebaseFirestore.instance
            .collection("Companies")
            .doc(credential.user!.uid)
            .collection("Brands")
            .snapshots()
            .listen((data) => BrandBox.instance.loadBrand(data.docs));
        FirebaseFirestore.instance
            .collection("Companies")
            .doc(credential.user!.uid)
            .collection("Categories")
            .snapshots()
            .listen((data) => CategoriesBox.instance.loadCategorie(data.docs));
        FirebaseFirestore.instance
            .collection("Companies")
            .doc(credential.user!.uid)
            .collection("Descriptions")
            .snapshots()
            .listen(
                (data) => DescriptionBox.instance.loadDescription(data.docs));
        FirebaseFirestore.instance
            .collection("Companies")
            .doc(credential.user!.uid)
            .collection("Models")
            .snapshots()
            .listen((data) => ModelBox.instance.loadModel(data.docs));
        FirebaseFirestore.instance
            .collection("Companies")
            .doc(credential.user!.uid)
            .collection("Parts")
            .snapshots()
            .listen((data) => PartBox.instance.loadPart(data.docs));
        FirebaseFirestore.instance
            .collection("Companies")
            .doc(credential.user!.uid)
            .collection("Missing")
            .snapshots()
            .listen((data) => MissingBox.instance.loadMissing(data.docs));

        //   async {
        // print(doc["adress"]);
        // print(doc["code"]);
        // print(doc["name"]);
        // print(["phone"]);
        // String path = doc["url"] == ""
        //     ? ""
        //     : await StorageFirebase().downloadFile(doc["url"]);
        // Hive.box("user").put(doc.id, {
        //   "adress": doc["adress"],
        //   "code": doc["code"],
        //   "fax": doc["fax"],
        //   "name": doc["name"],
        //   "phone": doc["phone"],
        //   "siret": doc["siret"],
        //   "tva": doc["tva"],
        //   "uid": doc.id,
        //   "path": path,
        //   "url": doc["url"]
        // });
      });
      // User? user = result.user;
      // return user;
    } on FirebaseAuthException catch (e) {
      setState(() {
        _loading = false;
      });
      if (context.mounted) {
        if (e.code == "network-request-failed") {
          showCostumDialog(context, "Attention!!!",
              "Vérifiez que vous êtes bien connecté à internet puis réessayez.");
        } else if (e.code == "wrong-password") {
          showCostumDialog(context, "Attention!!!",
              "Votre mot de passe est incorrect.\nMerci de le vérifier puis réessayer.");
        } else if (e.code == "user-not-found" ||
            e.code == "invalid-credential") {
          showCostumDialog(context, "Erreur de connexion",
              "Votre email est incorrect.\nMerci de le vérifier  puis réessayer.");
        } else {
          showCostumDialog(context, "Erreur de connexion",
              "Une erreur de connexion est survenue.\nVeuillez réessayer.");
        }
      }
    }
  }

  Future _register() async {
    try {
      UserCredential result =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: _emailControler.value.text,
              password: _passwordCrontroler.value.text);
      User? user = result.user;

      // Creation du nouvel utilisateur sur firebase
      await DatabaseService(uid: user!.uid).saveCompany(
          _companyNameControler.value.text,
          _adressComControler.value.text,
          _postalCodeComControler.value.text,
          _phoneComControler.value.text,
          _faxComControler.value.text,
          _siretControler.value.text,
          _tvaControler.value.text,
          "",
          "",
          "first",
          defaultSentence);

      return user;
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        if (e.code == "network-request-failed") {
          showCostumDialog(context, "Pas de connexion!!!",
              "Vérifiez que vous êtes bien connecté à internet puis réessayez.");
        } else if (e.code == "email-already-in-use") {
          showCostumDialog(context, "Erreur de création",
              "Cet email est déja utilisé.\nMerci de le vérifier  puis réessayer.");
        } else {
          showCostumDialog(context, "Erreur de création",
              "Une erreur est survenue lors de la création de votre compte.\nVeuillez réessayer.");
        }
      }
      setState(() {
        _loading = false;
      });
    }
  }
}
