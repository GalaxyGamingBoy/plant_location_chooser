import 'dart:async';
import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

ScanResult? connectedDevice;

void main() {
  runApp(const MainApp());
}

const List<String> temperatureScale = <String>['General', 'Cool', 'Tropical'];
const List<String> lightScale = <String>['Medium', 'Low', 'High'];
const List<String> moistureScale = <String>['Medium', 'Dry', 'High'];
const List<String> humidityScale = <String>['Medium', 'Low', 'High'];

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Main(),
      title: 'Plant Location Chooser',
    );
  }
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Plant Location Chooser',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.green[800],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const BluetoothManager(),
            const Divider(
              color: Colors.green,
            ),
            Text(
              'Plant Settings',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.green[900]),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [PlantForm()],
            ),
          ],
        ));
  }
}

class PlantForm extends StatefulWidget {
  const PlantForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<PlantForm> {
  final _formKey = GlobalKey<FormState>();
  String temperatureValue = temperatureScale.first;
  String lightValue = lightScale.first;
  String moistureValue = moistureScale.first;
  String humidityValue = humidityScale.first;

  String createSettingString() {
    String currentSettings = "";

    switch (temperatureValue) {
      case 'Cool':
        currentSettings += "w";
        break;
      case 'Tropical':
        currentSettings += "e";
        break;
      default:
        currentSettings += "q";
        break;
    }

    switch (lightValue) {
      case 'Low':
        currentSettings += "t";
        break;
      case 'High':
        currentSettings += "y";
        break;
      default:
        currentSettings += "r";
        break;
    }

    switch (moistureValue) {
      case 'Dry':
        currentSettings += "i";
        break;
      case 'High':
        currentSettings += "o";
        break;
      default:
        currentSettings += "u";
        break;
    }

    switch (humidityValue) {
      case 'Low':
        currentSettings += "s";
        break;
      case 'High':
        currentSettings += "d";
        break;
      default:
        currentSettings += "a";
        break;
    }
    return currentSettings;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // Temperature Scale
          Row(
            children: [
              const Text('Temperature:  '),
              DropdownButton<String>(
                value: temperatureValue,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: TextStyle(color: Colors.green[700]),
                underline: Container(
                  height: 2,
                  color: Colors.green[900],
                ),
                onChanged: (String? value) {
                  setState(() {
                    temperatureValue = value!;
                  });
                },
                items: temperatureScale
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              )
            ],
          ),

          // Light
          Row(
            children: [
              const Text('Light:  '),
              DropdownButton<String>(
                value: lightValue,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: TextStyle(color: Colors.green[700]),
                underline: Container(
                  height: 2,
                  color: Colors.green[900],
                ),
                onChanged: (String? value) {
                  setState(() {
                    lightValue = value!;
                  });
                },
                items: lightScale.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              )
            ],
          ),

          // Moisture
          Row(
            children: [
              const Text('Moisture:  '),
              DropdownButton<String>(
                value: moistureValue,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: TextStyle(color: Colors.green[700]),
                underline: Container(
                  height: 2,
                  color: Colors.green[900],
                ),
                onChanged: (String? value) {
                  setState(() {
                    moistureValue = value!;
                  });
                },
                items:
                    moistureScale.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              )
            ],
          ),

          // Humidity
          Row(
            children: [
              const Text('Humidity:  '),
              DropdownButton<String>(
                value: humidityValue,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: TextStyle(color: Colors.green[700]),
                underline: Container(
                  height: 2,
                  color: Colors.green[900],
                ),
                onChanged: (String? value) {
                  setState(() {
                    humidityValue = value!;
                  });
                },
                items:
                    humidityScale.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              )
            ],
          ),

          // Submit Button
          ElevatedButton(
            onPressed: () async {
              Fluttertoast.showToast(
                  msg:
                      "Submited with, Temperature: $temperatureValue, Light: $lightValue, Moisture: $moistureValue, Humidity: $humidityValue");
              if (connectedDevice != null) {
                List<BluetoothService> services =
                    await connectedDevice!.device.discoverServices();
                services.forEach((service) async {
                  service.characteristics.forEach((char) {
                    if (char.properties.write == true &&
                        char.properties.read == true &&
                        char.properties.writeWithoutResponse == true &&
                        char.properties.notify == true) {
                      char
                          .write(ascii.encode(createSettingString()))
                          .catchError((e) {});
                    }
                  });
                });
              }
            },
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.green[700]!)),
            child: const Text('Submit!'),
          )
        ],
      ),
    );
  }
}

class BluetoothManager extends StatefulWidget {
  const BluetoothManager({super.key});

  @override
  State<BluetoothManager> createState() => _BluetoothManagerState();
}

class _BluetoothManagerState extends State<BluetoothManager> {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  List<ScanResult> bluetoothResults = [];

  @override
  Widget build(BuildContext context) {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {});
    });

    return Column(
      children: [
        Text(
          'Bluetooth Manager',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.green[900]),
        ),
        Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.green[700]!)),
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                'Devices Found: ',
                style: TextStyle(fontSize: 18, color: Colors.green[800]),
              ),
              for (var i in bluetoothResults)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      i.device.name,
                      style: TextStyle(
                          fontSize: 16, color: Colors.lightGreen[900]),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        i.device.disconnect();
                        await i.device.connect();
                        connectedDevice = i;
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.green[600]!)),
                      child: const Text('Connect!'),
                    )
                  ],
                ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Connected: ',
              style: TextStyle(fontSize: 15, color: Colors.lightGreen[900]),
            ),
            Text(
              connectedDevice?.device.name ?? 'None',
              style: TextStyle(fontSize: 15, color: Colors.lightGreen[900]),
            ),
            const SizedBox(
              width: 12,
            ),
            ElevatedButton(
              onPressed: () {
                if (connectedDevice != null) {
                  connectedDevice!.device.disconnect();
                }
                connectedDevice = null;
              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green[600]!)),
              child: const Text('Disconnect!'),
            )
          ],
        ),
        ElevatedButton(
            onPressed: () {
              setState(() {});
              flutterBlue.startScan(timeout: const Duration(seconds: 4));
              bluetoothResults.clear();
              flutterBlue.scanResults.listen((results) {
                for (ScanResult r in results) {
                  var scanResult = r;
                  if (!bluetoothResults.contains(scanResult)) {
                    bluetoothResults.add(scanResult);
                  }
                }
              });
              flutterBlue.stopScan();
              setState(() {});
            },
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.green[700]!)),
            child: const Text('Scan'))
      ],
    );
  }
}
