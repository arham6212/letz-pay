import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:letzpay/common_components/home_app_bar.dart';
import 'package:letzpay/utils/assets_path.dart';
import 'package:letzpay/utils/colors.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../utils/strings.dart';

class QrCodePage extends StatefulWidget {
  String qr_code;
  QrCodePage({Key? key, required this.qr_code}) : super(key: key);

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  @override
  build(BuildContext context) {
    Uint8List _bytesImage =
        base64Decode(widget.qr_code); //convert image to byte

    return Scaffold(
      backgroundColor: white,
      appBar: buildHomeAppBar(
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Image.asset(blackArrow)),
        title: qrCode.text.color(Vx.hexToColor(balckMainColor)).bold.make(),
      ),
      body: SafeArea(
          child: Center(
              child: Image.memory(_bytesImage,
                  fit: BoxFit.fill, width: 350, height: 350))),
    );
  }
}
