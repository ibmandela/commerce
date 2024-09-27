// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:gestion_commerce_reparation/common/constant.dart';
import 'package:gestion_commerce_reparation/common/functions.dart';
import 'package:gestion_commerce_reparation/homes/home.dart';
import 'package:gestion_commerce_reparation/services/firebase/database.dart';
import 'package:flutter/material.dart';
import 'package:gestion_commerce_reparation/services/firebase/storage_firebase.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ProfilEdit extends StatefulWidget {
  const ProfilEdit({
    super.key,
  });

  @override
  State createState() => _ProfilEditState();
}

class _ProfilEditState extends State<ProfilEdit> {
  final _formKey = GlobalKey<FormState>();

  String _sentence = '';
  // final _user = FirebaseAuth.instance.currentUser;

  final _companyNameControler = TextEditingController();
  final _adressComControler = TextEditingController();
  final _postalCodeComControler = TextEditingController();
  final _phoneComControler = TextEditingController();
  final _faxComControler = TextEditingController();
  final _siretControler = TextEditingController();
  final _tvaControler = TextEditingController();
  final _sentenceControler = TextEditingController();
  File? _file;
  Uint8List? _webFile;
  bool _chooseInvoice = false;
  bool _editSentence = false;

  final spaceDown = const SizedBox(
    height: 10,
  );
  final space = const SizedBox(
    width: 30,
  );

  @override
  void dispose() {
    _companyNameControler.dispose();
    _postalCodeComControler.dispose();
    _phoneComControler.dispose();
    _faxComControler.dispose();
    _siretControler.dispose();
    _tvaControler.dispose();
    _sentenceControler.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (path != "") {
      _file = File(path);
    }
    invoiceType = invoiceType;
    _companyNameControler.text = companyName;
    _faxComControler.text = fax;
    _phoneComControler.text = companyPhone;
    _postalCodeComControler.text = postalCode;
    _adressComControler.text = companyAdress;
    _siretControler.text = siret;
    _tvaControler.text = tva;
    _sentenceControler.text = warning;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.blue,
        body: SingleChildScrollView(
      child: Center(
        child: Card(
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: SizedBox(
            width: MediaQuery.of(context).size.width > 600 ? 600 : null,
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(children: [
                _buildHead(),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Form(
                    key: _formKey,
                    child: _chooseInvoice
                        ? _buildInvoice()
                        : Column(
                            children: [
                              _buildCompanyName(),
                              const SizedBox(
                                height: 5,
                              ),
                              _buildComPhone(),
                              const SizedBox(
                                height: 5,
                              ),
                              _builFax(),
                              const SizedBox(
                                height: 5,
                              ),
                              _buildCompAdress(),
                              const SizedBox(
                                height: 5,
                              ),
                              _builPostalCode(),
                              spaceDown,
                              spaceDown,
                              const SizedBox(
                                height: 5,
                              ),
                              _buildSiret(),
                              const SizedBox(
                                height: 5,
                              ),
                              _buildTva(),
                              const SizedBox(
                                height: 5,
                              ),
                              if (_editSentence)
                                Text(
                                  _sentence,
                                  style: subtitle,
                                ),
                              _buildSentence(),
                              spaceDown,
                            ],
                          ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _chooseInvoice = !_chooseInvoice;
                      });
                    },
                    child: Text("Modèle de facture: $invoiceType")),
                spaceDown,
                _buildButton()
              ]),
            ),
          ),
        ),
      ),
    ));
  }

  Widget _buildCompanyName() {
    return TextFormField(
      keyboardType: TextInputType.name,
      autocorrect: false,
      textCapitalization: TextCapitalization.words,
      decoration: textInputDecoration2.copyWith(
        label: const Text("Nom de l'entreprise", style: formTextStyle),
        hintText: "Nom de l'entreprise",
        prefixIcon: const Icon(
          Icons.person_pin,
          color: Colors.blue,
        ),
      ),
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
      decoration: textInputDecoration2.copyWith(
        label: const Text("Adresse de l'entreprise", style: formTextStyle),
        hintText: "Adresse de l'entreprise",
        prefixIcon: const Icon(
          Icons.location_pin,
          color: Colors.blue,
        ),
      ),
      controller: _adressComControler,
      validator: (value) {
        if (value == null) {
          return null;
        } else if (value.isNotEmpty && value.length < 10) {
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
      decoration: textInputDecoration2.copyWith(
        label: const Text('numéro de téléphone', style: formTextStyle),
        hintText: 'numéro de téléphone',
        prefixIcon: const Icon(
          Icons.phone,
          color: Colors.blue,
        ),
      ),
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
      keyboardType: TextInputType.number,
      autocorrect: false,
      decoration: textInputDecoration2.copyWith(
        label: const Text('Code postal', style: formTextStyle),
        hintText: 'Code postal',
        prefixIcon: const Icon(
          Icons.location_pin,
          color: Colors.blue,
        ),
      ),
      controller: _postalCodeComControler,
      validator: (value) {
        if (value == null) {
          return null;
        } else if (value.isNotEmpty && value.length < 5) {
          return "Ce code postal est invalide";
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
      decoration: textInputDecoration2.copyWith(
        label: const Text('Fax', style: formTextStyle),
        hintText: 'Fax',
        prefixIcon: const Icon(
          Icons.phone,
          color: Colors.blue,
        ),
      ),
      controller: _faxComControler,
      validator: (value) {
        if (value == null) {
          return null;
        } else if (value.isNotEmpty && value.length < 10) {
          return "Ce fax est invalide";
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
        decoration: textInputDecoration2.copyWith(
            label: const Text(
              'Siret',
              style: formTextStyle,
            ),
            hintText: 'Siret'),
        controller: _siretControler,
        validator: (value) {
          (value) {
            if (value == null) {
              return null;
            }
            if (value.isNotEmpty && value.length < 6) {
              return "Entrez une adresse valide SVP";
            } else {
              return null;
            }
          };
          return null;
        });
  }

  Widget _buildTva() {
    return TextFormField(
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.none,
      decoration: textInputDecoration2.copyWith(
          label: const Text(
            'Numéro de TVA',
            style: formTextStyle,
          ),
          hintText: 'Numéro de TVA'),
      controller: _tvaControler,
      validator: (value) {
        (value) {
          if (value == null) {
            return null;
          }
          if (value.isNotEmpty && value.length < 6) {
            return "Entrez une adresse valide SVP";
          } else {
            return null;
          }
        };
        return null;
      },
    );
  }

  Widget _buildSentence() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      decoration: textInputDecoration2.copyWith(
          label: const Text(
            'Mise en garde',
            style: formTextStyle,
          ),
          hintText: 'Mise en garde'),
      controller: _sentenceControler,
      onTap: () => setState(() {
        _editSentence = true;
      }),
      onChanged: (value) {
        setState(() {
          _sentence = value;
        });
      },
    );
  }

  Widget _buildButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
            elevation: 30),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            submit();
          }
        },
        child: const Text(
          "Modifier",
          style: formTextStyle,
        ));
  }

  _buildInvoice() {
    return Column(
      children: [
        Image.asset("assets/$invoiceType.png"),
        spaceDown,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        invoiceType == "1" ? Colors.blue : Colors.grey),
                onPressed: () {
                  setState(() {
                    invoiceType = "1";
                  });
                },
                child: const Text("Modèle 1")),
            space,
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        invoiceType == "2" ? Colors.blue : Colors.grey),
                onPressed: () {
                  setState(() {
                    invoiceType = "2";
                  });
                },
                child: const Text("Modèle 2")),
          ],
        ),
        spaceDown
      ],
    );
  }

  _buildHead() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              size: 40,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 5,
            height: MediaQuery.of(context).size.width / 5,
            child: CircleAvatar(
              child:
                  _webFile == null && _file == null && url == "" && path == ""
                      ? Text(companyName.substring(0, 1))
                      : kIsWeb
                          ? _webFile == null
                              ? Center(child: Image.network(url))
                              : Center(
                                  child: Image.memory(
                                    _webFile!,
                                    fit: BoxFit.fill,
                                  ),
                                )
                          : Center(
                              child: Image.file(
                                _file!,
                                fit: BoxFit.fill,
                              ),
                            ),
            ),
          ),
          IconButton(
              icon: const Icon(
                Icons.image,
                size: 40,
                color: Colors.white,
              ),
              onPressed: () async {
                _pickFile();
              }),
        ],
      ),
    );
  }

  void submit() async {
    String companyName = _companyNameControler.value.text;
    String companyAdress = _adressComControler.value.text;
    String comPostCode = _postalCodeComControler.value.text;
    String companyPhone = _phoneComControler.value.text;
    String fax = _faxComControler.value.text;
    String siret = _siretControler.value.text;
    String tva = _tvaControler.value.text;
    String sentence = _sentenceControler.value.text;
    if (_file != null) {
      var filePath = (Platform.isAndroid
              ? Directory("storage/emulated/0/")
              : await getApplicationSupportDirectory())
          .path;
      await _file!.copy(Platform.isWindows
          ? "$filePath/profile.png".replaceAll("/", "\\")
          : "$filePath/profile.png");
      await StorageFirebase().uploadFile(_file, userUid, context).then((url) =>
          DatabaseService(uid: userUid).saveCompany(
              companyName,
              companyAdress,
              comPostCode,
              companyPhone,
              fax,
              siret,
              tva,
              _file!.path,
              url,
              invoiceType,
              sentence));
    } else if (_webFile != null) {
      await StorageFirebase().uploadFile(_webFile, userUid, context).then(
          (url) => DatabaseService(uid: userUid).saveCompany(
              companyName,
              companyAdress,
              comPostCode,
              companyPhone,
              fax,
              siret,
              tva,
              "",
              url,
              invoiceType,
              sentence));
    } else {
      DatabaseService(uid: userUid).saveCompany(
          companyName,
          companyAdress,
          comPostCode,
          companyPhone,
          fax,
          siret,
          tva,
          path,
          url,
          invoiceType,
          sentence);
    }
    if (context.mounted) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => HomePage(userUid: userUid)));
    }
  }

  _pickFile() async {
    try {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (!kIsWeb) {
        if (image != null) {
          final selectedImage = File(image.path);

          setState(() {
            _file = selectedImage;
          });
        } else {
          if (context.mounted) {
            return errorDialog(context, "Aucune image selectionnée");
          }
        }
      } else {
        if (image != null) {
          var selectedImage = await image.readAsBytes();
          setState(() {
            _webFile = selectedImage;
          });
        } else {
          if (context.mounted) {
            return errorDialog(context, "Aucune image selectionnée");
          }
        }
      }
    } catch (e) {
      if (!context.mounted) {
        errorDialog(context, "Erreur qd'ouverture");
      }
    }
  }
}
