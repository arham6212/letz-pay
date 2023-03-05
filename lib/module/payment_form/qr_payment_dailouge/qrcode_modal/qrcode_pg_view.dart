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

class PGCode extends StatefulWidget {
  const PGCode({super.key});

  @override
  State<PGCode> createState() => _PGCodeState();
}

class _PGCodeState extends State<PGCode> {
  late ApiService apiService;
  late var mContext;
  late ResponseStaticPgAndUPIQr responseStaticPgAndUPIQr;
  late ResponseSendQrImage responseSendQrImage;
  late var networkStatus;
  late Uint8List _bytesImage;

  late String superMerchantFlag = "";
  late String superMerchantPayId = "";
  late String userType = "";
  late String businessName = "";
  late String merchantID = "";
  late String merchantName = "";
  late String subMerchantID = "";
  late String subMerchantName = "";

  @override
  void initState() {
    super.initState();

    _bytesImage = base64Decode("");

    responseStaticPgAndUPIQr = ResponseStaticPgAndUPIQr();
    responseSendQrImage = ResponseSendQrImage();

    apiService = ApiService();

    mContext = context;

    getSharedData();
  }

  //getting value from shared pref variable.
  void getSharedData() async {
    superMerchantFlag = await getStringVal(superMerchantFlagPrefKey);
    superMerchantPayId = await getStringVal(superMerchantPayIdPrefKey);

    userType = await getStringVal(userTypePrefKey);
    businessName = await getStringVal(businessNamePrefKey);

    merchantID = await getStringVal(merchantIdPrefKey);
    merchantName = await getStringVal(merchantNamePrefKey);
    subMerchantID = await getStringVal(subMerchantIdPrefKey);
    subMerchantName = await getStringVal(subMerchantNamePrefKey);

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
        title: staticLbl.text.color(Vx.hexToColor(balckMainColor)).bold.make(),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.0.w),
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

//This function get Static QR code image
  Future getStaticPgAndUPIQr(var context) async {
    Response response;
    try {
      late var params;
      // = {
      //   // "FLAG": true,
      //   "MOBILE_NUMBER": await getStringVal("mobileNumber")
      // };

      if (userType.toString() == "RESELLER") {
        params = {
          "PAY_ID": merchantID,
          "MOBILE_NUMBER": await getStringVal("mobileNumber")
        };
      } else if (userType.toString() == "MERCHANT" &&
          subMerchantID.toString().isNotEmpty) {
        // if (superMerchantPayId.toString().isNotEmpty) {
        //   getSubMerchantList(context, superMerchantPayId.toString());
        // }
        params = {
          "PAY_ID": subMerchantID,
          "MOBILE_NUMBER": await getStringVal("mobileNumber")
        };
      } else {
        params = {
          // "FLAG": true,
          "MOBILE_NUMBER": await getStringVal("mobileNumber")
        };
      }

      response = await apiService.getStaticPgAndUPIQr(
          params, context); //API call for get static QR code

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
            //  showToastMsg(responseStaticPgAndUPIQr.rESPONSEMESSAGE.toString());
          }
        });
      } else {
        showPopUpDialog(errorpop, errorSomeWrong, context);
        // showToastMsg("error found");
      }
    } on Exception catch (e) {
      showPopUpDialog(errorpop, e.toString(), context);
      // showToastMsg(e.toString());
    }
  }

//send QR code image
  Future sendQrImage(BuildContext context) async {
    Response response;
    try {
      var params = {
        "TITLE": "Static PG QR",
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
      //showToastMsg(e.toString());
    }
  }
}
