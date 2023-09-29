import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:restaurant_manager/presentation/shared/extensions/context_extensions.dart';

class IdQrCodeImage extends StatefulWidget {
  final int id;
  const IdQrCodeImage({Key? key, required this.id}) : super(key: key);

  @override
  State<IdQrCodeImage> createState() => _IdQrCodeImageState();
}

class _IdQrCodeImageState extends State<IdQrCodeImage> {
  bool _loopStarted = false;

  Future<void> startRefreshLoop(int interval) async {
     while (true) {
       await Future.delayed(Duration(milliseconds: interval), () {
         if (!mounted) return;
         setState(() {});
       });
     }
  }


  @override
  Widget build(BuildContext context) {
    if (!_loopStarted) {
      _loopStarted = true;
      startRefreshLoop(60000);
    }

    return QrImageView(
      data: jsonEncode({
        "id": widget.id,
        "timestamp": DateTime.now().toUtc().millisecondsSinceEpoch,
      },),
      size: 350.w,
      backgroundColor: context.colorScheme.primary,
    );
  }
}
