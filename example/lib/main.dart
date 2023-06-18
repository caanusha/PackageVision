import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner_example/productDataBase.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(home: Home()));
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PackageVision')),
      body: const Center(
        child: HomePageComponentsList(),
      ),
    );
  }
}

class HomePageComponentsList extends StatefulWidget {
  const HomePageComponentsList({Key? key}) : super(key: key);

  @override
  _HomePageComponentsListState createState() => _HomePageComponentsListState();
}

class _HomePageComponentsListState extends State<HomePageComponentsList> {
  final TextEditingController _textEditingController = TextEditingController();
  String _textInput = '';

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final list = [
      ScanCode(
        'Scan QR code',
        'Scans the product QR Code',
            () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QRCodeScanner()),
        ),
      ),
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(
              labelText: 'Enter your order ID',
            ),
            onChanged: (value) {
              setState(() {
                _textInput = value;
              });
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Open the new page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RealtimeDatabaseDataPage( textInput: _textInput)),
            );
          },
          child: const Text('Submit'),
        ),
        Expanded(
          child: ListView(
            children: list.map((component) => HomePageListCard(component: component)).toList(),
          ),
        ),
      ],
    );
  }
}

class HomePageListCard extends StatelessWidget {
  const HomePageListCard({Key? key, required this.component}) : super(key: key);
  final ScanCode component;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          component.onTap();
        },
        child: ListTile(
          title: Text(component.name),
          subtitle: Text(component.description),
        ),
      ),
    );
  }
}

class ScanCode {
  const ScanCode(this.name, this.description, this.onTap);
  final String name;
  final String description;
  final Function onTap;
}

class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRCodeScannerState();
}


class _QRCodeScannerState extends State<QRCodeScanner> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    controller!.pauseCamera();
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    GestureDetector(
                      onTap: () {
                        var productId = '';
                        Uri? qrUri = Uri.tryParse(result?.code as String);
                        if (qrUri != null && qrUri.queryParameters.containsKey('textInput')) {
                          productId = qrUri.queryParameters['textInput']!;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RealtimeDatabaseDataPage(textInput: productId)),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: '${result?.code}',
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              var productId = '';
                              Uri? qrUri = Uri.tryParse(result?.code as String);
                              if (qrUri != null && qrUri.queryParameters.containsKey('textInput')) {
                                productId = qrUri.queryParameters['textInput']!;
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => RealtimeDatabaseDataPage(textInput: productId)),
                              );
                            },
                        ),
                      ),
                    )
                  else
                    const Text('Scan a code'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.toggleFlash();
                            setState(() {});
                          },
                          child: FutureBuilder(
                            future: controller?.getFlashStatus(),
                            builder: (context, snapshot) {
                              return Text('Flash: ${snapshot.data}');
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.flipCamera();
                            setState(() {});
                          },
                          child: FutureBuilder(
                            future: controller?.getCameraInfo(),
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                return Text(
                                    'Camera facing ${describeEnum(snapshot.data!)}');
                              } else {
                                return const Text('loading');
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.pauseCamera();
                          },
                          child:
                          const Text('pause', style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.resumeCamera();
                          },
                          child:
                          const Text('resume', style: TextStyle(fontSize: 20)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

}
