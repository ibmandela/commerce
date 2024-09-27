// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:gestion_commerce_reparation/common/constant.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:gestion_commerce_reparation/common/message.dart';
import 'package:path_provider/path_provider.dart';

class BluetoothPrinter extends StatefulWidget {
  const BluetoothPrinter({super.key});

  @override
  State createState() => _BluetoothPrinterState();
}

class _BluetoothPrinterState extends State<BluetoothPrinter> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _device;
  bool _isToconnect = true;
  bool printerConnected = false;
  bool _isLoading = false;
  String? pathImage;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initSavetoPath();
  }

  initSavetoPath() async {
    //read and write
    //image max 300px X 300px
    const filename = 'yourlogo.png';
    String dir = (await getApplicationDocumentsDirectory()).path;
    setState(() {
      pathImage = '$dir/$filename';
    });
  }

  Future<void> initPlatformState() async {
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      if (context.mounted) {
        showCostumDialog(context, "Erreur", "Une erreur s'est produite");
      }
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            showCostumDialog(context, "Bluetooth", "Bluetooth connecté");
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            showCostumDialog(context, "Bluetooth", "Bluetooth déconnecté");
          });
          break;
        case BlueThermalPrinter.DISCONNECT_REQUESTED:
          setState(() {
            showCostumDialog(context, "Bluetooth", "Bluetooth déconnecté");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_OFF:
          setState(() {
            showCostumDialog(context, "Bluetooth", "Bluetooth en désactivé");
          });
          break;
        case BlueThermalPrinter.STATE_OFF:
          setState(() {
            showCostumDialog(context, "Bluetooth", "Bluetooth en désactivé");
          });
          break;
        case BlueThermalPrinter.STATE_ON:
          setState(() {
            showCostumDialog(context, "Bluetooth", "Bluetooth en activé");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_ON:
          setState(() {
            showCostumDialog(context, "Bluetooth", "Bluetooth en activé");
          });
          break;
        case BlueThermalPrinter.ERROR:
          setState(() {
            showCostumDialog(context, "Bluetooth", "Erreur de Bluetooth");
          });
          break;
        default:
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Connecter un appareil en Bluetooth',
          style: titleStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
            child: Column(children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Appareils disponibles',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height / 2,
                  child: ListView.builder(
                      itemCount: _devices.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              setState(() {
                                _device = _devices[index];
                              });
                            },
                            child: Text(
                              "${_devices[index].name}",
                              style: titleStyle,
                            ));
                      })),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          _isLoading
              ? Column(
                  children: [
                    loader,
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(!_isToconnect
                            ? 'Déconnecter : Appuyer pour retourner'
                            : 'Connecter : Appuyer pour retourner'))
                  ],
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                  child: StreamBuilder<bool?>(
                      stream: bluetooth.isConnected.asStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text("Une erreur s'est produite");
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return loader;
                        }
                        final data = snapshot.requireData ?? false;
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: borderRaduis,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      textStyle: textStyle),
                                  onPressed: () {
                                    initPlatformState();
                                  },
                                  child: const Text(
                                    'Actualiser',
                                    // style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: borderRaduis,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30),
                                      backgroundColor:
                                          data ? Colors.red : Colors.green),
                                  onPressed: () {
                                    if (!data) {
                                      if (_device != null) {
                                        _connect();
                                        // Future.delayed(
                                        //     const Duration(seconds: 5),
                                        //     (() => setState(() {
                                        //           _isLoading = false;
                                        //           _isDone = true;
                                        //         })));
                                        setState(() {
                                          _isLoading = true;
                                          _isToconnect = true;
                                        });
                                      } else {
                                        _showAlertDialogue();
                                      }
                                    } else {
                                      _disconnect();
                                      // Future.delayed(
                                      //     const Duration(seconds: 5),
                                      //     (() => setState(() {
                                      //           _isLoading = false;
                                      //           _isDone = true;
                                      //         })));
                                      setState(() {
                                        _isLoading = true;
                                        _isToconnect = false;
                                      });
                                    }
                                  },

                                  // data ? _disconnect : _connect,
                                  //     () {
                                  //   setState(() {
                                  //     // _isLoading = true;
                                  //     bluetooth.disconnect();
                                  //     // if (data) {
                                  //     //   print(data);
                                  //     //   _disconnect;
                                  //     // } else {
                                  //     //   _connect;
                                  //     // }
                                  //   });
                                  // },
                                  child: Text(
                                    data ? 'Deconnecter' : 'Connecter',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: ElevatedButton(
                                child: const Text("Terminer"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ))
                            ],
                          ),
                        );
                      }),
                )
        ])),
      ),
    );
  }

  _showAlertDialogue() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Avertissement!!!'),
              content: const Text(
                  'Vous devez obligatoirement selectionner un periferiques bluetooth'),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'))
              ],
            ));
  }

  void _connect() {
    try {
      bluetooth.isConnected.then((isConnected) {
        if (isConnected != null && !isConnected) {
          bluetooth
              .connect(_device!)
              .then((value) => setState(() => _isLoading = false))
              .catchError((error) {});
          // setState(() => _isLoading = false);
        }
      });
    } catch (e) {
      if (context.mounted) {
        showCostumDialog(context, "Erreur",
            "Une erreur s'est produite lors de la connexion");
      }
    }

    bluetoothState();
  }

  bluetoothState() {
    bluetooth.isConnected.then((isConnected) {
      if (isConnected != null && isConnected) {
        return printerConnected = true;
      } else {
        return printerConnected = false;
      }
    });
  }

  void _disconnect() {
    bluetooth.disconnect().then((value) => setState(() => _isLoading = false));
  }

//write to app path
  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future show(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          duration: duration,
        ),
      );
    }
  }
}
