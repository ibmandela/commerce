import 'package:flutter/material.dart';
import 'package:gestion_commerce_reparation/common/constant.dart';
import 'package:gestion_commerce_reparation/common/functions.dart';
import 'package:gestion_commerce_reparation/common/widget/actions.dart';

class ContactMe extends StatefulWidget {
  const ContactMe({super.key});

  @override
  State<ContactMe> createState() => _ContactMeState();
}

class _ContactMeState extends State<ContactMe> {
  bool _isSms = false;
  bool _isMail = false;
  final _messageControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double fontSize = MediaQuery.of(context).size.width > 550
        ? MediaQuery.of(context).size.width / 60
        : MediaQuery.of(context).size.width / 30;
    return Scaffold(
      appBar: AppBar(actions: actions(context)),
      body: Row(
        children: [
          Expanded(
            // width: MediaQuery.of(context).size.width / 2,
            child: Image.asset("assets/contact.png"),
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Contactez moi",
                style: titleStyle.copyWith(fontSize: fontSize),
              ),
              const SizedBox(
                height: 20,
              ),
              _buildRow(
                  const Icon(Icons.phone_android),
                  "+33 6 98 55 75 67",
                  TextButton(
                    style: const ButtonStyle(alignment: Alignment.centerLeft),
                    onPressed: () {
                      setState(() {
                        _isMail = false;
                        _isSms = !_isSms;
                      });
                    },
                    child: Text(
                      "+33 6 98 55 75 67",
                      style: titleStyle.copyWith(fontSize: fontSize),
                    ),
                  )),
              if (_isSms) _buildTextField(),
              _buildRow(
                  Image.asset("assets/whatsapp.png"),
                  "+33 6 98 55 75 67",
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "+33 6 98 55 75 67",
                      style: titleStyle.copyWith(fontSize: fontSize),
                    ),
                  )),
              _buildRow(
                  const Icon(Icons.email),
                  "ibrahimacicamara@gmail.com",
                  TextButton(
                    style: const ButtonStyle(alignment: Alignment.centerLeft),
                    onPressed: () {
                      setState(() {
                        _isSms = false;
                        _isMail = !_isMail;
                      });
                    },
                    child: Text(
                      "ibrahimacicamara@gmail.com\ncontact@ibdeveloppe.fr",
                      style: titleStyle.copyWith(fontSize: fontSize),
                    ),
                  )),
              if (_isMail) _buildTextField(),
              _buildRow(
                  Image.asset("assets/github.png"),
                  "",
                  TextButton(
                    style: const ButtonStyle(alignment: Alignment.centerLeft),
                    onPressed: () {
                      launchUPageWeb("github.com/ibmandela");
                    },
                    child: Text(
                      "Ibrahima Camara",
                      style: titleStyle.copyWith(fontSize: fontSize),
                    ),
                  )),
              _buildRow(
                  Image.asset("assets/linkedin.png"),
                  "",
                  TextButton(
                    style: const ButtonStyle(alignment: Alignment.centerLeft),
                    onPressed: () {
                      launchUPageWeb(
                          "linkedin.com/in/ibrahima-camara-11b369172");
                    },
                    child: Text(
                      "Ibrahima Camara",
                      style: titleStyle.copyWith(fontSize: fontSize),
                    ),
                  )),
            ],
          ))
        ],
      ),
    );
  }

  _buildRow(child, label, widget) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          // margin: EdgeInsets.only(bottom: 10, left: 5, right: 5, top: 5),
          child: SizedBox(
            width: 50,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: child,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(child: widget)
      ],
    );
  }

  _buildTextField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            elevation: 10,
            child: SizedBox(
              height: 80,
              width: MediaQuery.of(context).size.width > 550
                  ? MediaQuery.of(context).size.width / 5
                  : MediaQuery.of(context).size.width / 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _messageControler,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    alignLabelWithHint: false,
                    border: InputBorder.none,
                    hintText: "Tapez votre message",
                    // label: Text("Message")
                  ),
                ),
              ),
            )),
        const SizedBox(
          width: 10,
        ),
        IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              setState(() {
                _isSms
                    ? Theme.of(context).platform == TargetPlatform.iOS ||
                            Theme.of(context).platform == TargetPlatform.android
                        ? sendSms(_messageControler.value.text)
                        : _showErrorDialog()
                    : sendMail(_messageControler.value.text);
              });
            })
      ],
    );
  }

  _showErrorDialog() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Attention !!!"),
              content: const Text(
                  "La fonctionnalité d'envoi de SMS n'est disponible que sur un téléphone portable.\nVeuillez utiliser un téléphone portable ou envoyez moi un mail."),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("OK"))
              ],
            ));
  }
}
