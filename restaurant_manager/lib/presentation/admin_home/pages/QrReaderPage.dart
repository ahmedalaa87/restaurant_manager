import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:restaurant_manager/presentation/shared/extensions/context_extensions.dart';

class QrReaderPage extends StatefulWidget {
  const QrReaderPage({Key? key}) : super(key: key);

  @override
  State<QrReaderPage> createState() => _QrReaderPageState();
}

class _QrReaderPageState extends State<QrReaderPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: QRView(
              key: qrKey,
              overlay: QrScannerOverlayShape(
                cutOutHeight: 150,
                cutOutWidth: 150,
                borderLength: 25
              ),
              onQRViewCreated: (QRViewController controller) {
                this.controller = controller;
                controller.scannedDataStream.listen((scanData) {
                  context.navigator.pop(scanData.code);
                  controller.dispose();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
