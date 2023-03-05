import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:letzpay/common_components/common_widget.dart';
import 'package:letzpay/common_components/home_app_bar.dart';
import 'package:letzpay/module/payment_form/qr_payment_dailouge/qrcode_module/response_pg_upi_qr_code_modal.dart';
import 'package:letzpay/module/payment_form/qr_payment_dailouge/qrcode_module/response_send_qr_image.dart';
import 'package:letzpay/services/network/api_services.dart';
import 'package:letzpay/services/shared_pref.dart';
import 'package:letzpay/utils/assets_path.dart';
import 'package:letzpay/utils/colors.dart';
import 'package:letzpay/utils/strings.dart';
import 'package:velocity_x/velocity_x.dart';

class UPICode extends StatefulWidget {
  const UPICode({super.key});

  @override
  State<UPICode> createState() => _UPICodeState();
}

class _UPICodeState extends State<UPICode> {
  late ApiService apiService;
  late var mContext;
  late ResponseStaticPgAndUPIQr responseStaticPgAndUPIQr;
  late ResponseSendQrImage responseSendQrImage;
  late var networkStatus;
  late Uint8List _bytesImage;

  @override
  void initState() {
    super.initState();

    _bytesImage = base64Decode("");

    responseStaticPgAndUPIQr = ResponseStaticPgAndUPIQr();
    responseSendQrImage = ResponseSendQrImage();

    apiService = ApiService();

    mContext = context;

    getStaticPgAndUPIQr(mContext);
  }

  @override
  Widget build(BuildContext context) {
    // networkStatus = Provider.of<NetworkStatus>(context);
    // if (networkStatus == NetworkStatus.offline) {
    //   showToastMsg(errorNoInternet);
    // } else {
    //   getStaticPgAndUPIQr(mContext);
    // }
    return Scaffold(
      backgroundColor: white,
      appBar: buildHomeAppBar(
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Image.asset(blackArrow)),
        title: upiQr.text.color(Vx.hexToColor(balckMainColor)).bold.make(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: GestureDetector(
              child: Icon(
                Icons.message,
                color: white,
              ),
              onTap: (() => sendQrImage(context)),
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              upiIcon,
              width: 100.0.w,
              height: 40.0.h,
              // color: greyColor,
            ),
            _bytesImage.isEmpty
                ? Container(child: errorSomeWrong.text.make())
                : Image.memory(_bytesImage,
                    fit: BoxFit.fill, width: 350, height: 350),
          ],
        ),
      )),
    );
  }

//This function get static QR code
  Future getStaticPgAndUPIQr(var context) async {
    Response response;
    try {
      var params = {
        // "FLAG": true,
        "MOBILE_NUMBER": await getStringVal("mobileNumber")
      };

      response = await apiService.getStaticPgAndUPIQr(
          params, context); //API call for get static QR code image

      if (response.statusCode == 200) {
        setState(() {
          responseStaticPgAndUPIQr =
              ResponseStaticPgAndUPIQr.fromJson(response.data);

          if (responseStaticPgAndUPIQr.rESPONSECODE.toString() == "000") {
            _bytesImage =
                base64Decode(responseStaticPgAndUPIQr.sTATICPGQR.toString());
          } else {
            showPopUpDialog(errorpop,
                responseStaticPgAndUPIQr.rESPONSEMESSAGE.toString(), context);
            // showToastMsg(responseStaticPgAndUPIQr.rESPONSEMESSAGE.toString());
          }
        });
      } else {
        showPopUpDialog(errorpop, errorSomeWrong, context);
        //showToastMsg("error found");
      }
    } on Exception catch (e) {
      showPopUpDialog(errorpop, e.toString(), context);
      //showToastMsg(e.toString());
    }
  }

  Future sendQrImage(BuildContext context) async {
    Response response;
    try {
      var params = {
        "TITLE": "Static UPI QR",
        "MOBILE_NUMBER": await getStringVal("mobileNumber")
      };

      response = await apiService.sendQrImage(
          params, context); //API call for send QR code image

      if (response.statusCode == 200) {
        setState(() {
          responseSendQrImage = ResponseSendQrImage.fromJson(response.data);

          if (responseSendQrImage.rESPONSECODE.toString() == "000") {
            Navigator.pop(context);
            showPopUpDialog(
                errorpop,
                "$sentQrOnEmail ${responseSendQrImage.emailId.toString()}",
                context);
            // showToastMsg(
            //     "$sentQrOnEmail ${responseSendQrImage.emailId.toString()}");
          } else {
            showPopUpDialog(errorpop,
                responseSendQrImage.rESPONSEMESSAGE.toString(), context);
            // showToastMsg(responseSendQrImage.rESPONSEMESSAGE.toString());
          }
        });
      } else {
        showPopUpDialog(errorpop, errorSomeWrong, context);
        //showToastMsg("error found");
      }
    } on Exception catch (e) {
      showPopUpDialog(errorpop, e.toString(), context);
      //  showToastMsg(e.toString());
    }
  }
}
