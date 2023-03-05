import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:injectable/injectable.dart';
import 'package:letzpay/common_functions/common_functions.dart';
import 'package:letzpay/common_components/home_app_bar.dart';
import 'package:letzpay/common_components/logger.dart';
import 'package:letzpay/module/history/transaction_detail_page/historydetail_module/getstatusresponse.dart';
import 'package:letzpay/module/history/transaction_detail_page/historydetail_module/reponseresendlink.dart';
import 'package:letzpay/module/history/transaction_detail_page/historydetail_module/response_transactiondetail.dart';
import 'package:letzpay/services/network/api_services.dart';
import 'package:letzpay/utils/assets_path.dart';
import 'package:letzpay/utils/colors.dart';
import 'package:letzpay/utils/strings.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../common_components/common_widget.dart';
import '../transaction_history_new/transaction_history_new.dart';
import '../../../services/shared_pref.dart';

class SuccessTransaction extends StatefulWidget {
  const SuccessTransaction(
      {Key? key,
      required this.invoice,
      required this.amount,
      required this.mComingFrom})
      : super(key: key);
  final String invoice;
  final String amount;
  final String mComingFrom;

  @override
  State<SuccessTransaction> createState() => _SuccessTransactionState();
}

class _SuccessTransactionState extends State<SuccessTransaction> {
  late ApiService apiService;
  late TransactionDetailResponse transactiondetailresponse;
  late Getstatusresponse getstatusresponse;
  late List<TransactionDetail> transactiondetails;
  late ResendLinkResponse resendlinkresponse;
  // late var email;
  // late var ePOSPAYMENTOPTION;
  // late var customerMob;
  // late var cUSTNAME;
  // late var remarks;
  late String superMerchantFlag = "";
  late String superMerchantPayId = "";
  late String userType = "";
  late String businessName = "";
  late String merchantID = "";
  late String merchantName = "";
  late String subMerchantID = "";
  late String subMerchantName = "";

  late String transStatusIconFlag = "";
  late String transStatusFlag = "";

  // String get email => widget.Cus

  // var email =TransactionDetailResponse.data

  // late String invoice;
  @override
  initState() {
    super.initState();
    resendlinkresponse = ResendLinkResponse();
    getstatusresponse = Getstatusresponse();
    apiService = ApiService();
    transactiondetails = <TransactionDetail>[];

    getSharedData();
    //transactionDetails(invoice, context);
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

    transactionDetails(widget.invoice, widget.amount, context);
  }

  Future resndLink(String invoice, var context) async {
    Response response;
    try {
      late var params;
      // = {
      //   "INVOICE_ID": invoice,
      //   "MOBILE_NUMBER": await getStringVal("mobileNumber"),
      // };

      if (userType.toString() == "RESELLER") {
        params = {
          "PAY_ID": merchantID,
          "INVOICE_ID": invoice,
          "MOBILE_NUMBER": await getStringVal("mobileNumber")
        };
      } else if (userType.toString() == "MERCHANT" &&
          subMerchantID.toString().isNotEmpty) {
        // if (superMerchantPayId.toString().isNotEmpty) {
        //   getSubMerchantList(context, superMerchantPayId.toString());
        // }
        params = {
          "PAY_ID": subMerchantID,
          "INVOICE_ID": invoice,
          "MOBILE_NUMBER": await getStringVal("mobileNumber")
        };
      } else {
        params = {
          "INVOICE_ID": invoice,
          "MOBILE_NUMBER": await getStringVal("mobileNumber"),
        };
      }

      response = await apiService.resendLink(
          params, context); //API call for resend payment link

      if (response.statusCode == 200) {
        setState(() {
          resendlinkresponse = ResendLinkResponse.fromJson(response.data);
          if (resendlinkresponse.rESPONSECODE.toString() == "000") {
            showPopUpDialog(successPop,
                resendlinkresponse.rESPONSEMESSAGE.toString(), context);
          }
        });
      } else {
        showPopUpDialog(errorpop, errorSomeWrong, context);
        // showToastMsg("error found");
      }
    } on Exception catch (e) {
      showPopUpDialog(errorpop, e.toString(), context);
      //showToastMsg(e.toString());
    }
  }

  Future getStatusRefresh(
    String invoice,
    var context,
    String amount,
  ) async {
    Response response;
    try {
      late var params;
      //  = {
      //   "AMOUNT": amount,
      //   "INVOICE_ID": invoice,
      //   "MOBILE_NUMBER": await getStringVal("mobileNumber"),
      // };

      if (userType.toString() == "RESELLER") {
        params = {
          "PAY_ID": merchantID,
          "INVOICE_ID": invoice,
          "MOBILE_NUMBER": await getStringVal("mobileNumber"),
          "TRANSACTION_MODE": "ePOS"
        };
      } else if (userType.toString() == "MERCHANT" &&
          subMerchantID.toString().isNotEmpty) {
        // if (superMerchantPayId.toString().isNotEmpty) {
        //   getSubMerchantList(context, superMerchantPayId.toString());
        // }
        params = {
          "PAY_ID": subMerchantID,
          "INVOICE_ID": invoice,
          "MOBILE_NUMBER": await getStringVal("mobileNumber"),
          "TRANSACTION_MODE": "ePOS"
        };
      } else {
        params = {
          "AMOUNT": amount,
          "INVOICE_ID": invoice,
          "MOBILE_NUMBER": await getStringVal("mobileNumber"),
        };
      }

      response = await apiService.getStatus(
          params, context); //API call for getSatus of transaction

      if (response.statusCode == 200) {
        setState(() {
          getstatusresponse = Getstatusresponse.fromJson(response.data);
        });
      } else {
        showPopUpDialog(errorpop, errorSomeWrong, context);
        //showToastMsg("error found");
      }
    } on Exception catch (e) {
      showPopUpDialog(errorpop, e.toString(), context);
      // showToastMsg(e.toString());
    }
  }

  Future resendQrCode(
    BuildContext context,
    String invoice,
    String email,
    String ePOSPAYMENTOPTION,
    String customerMob,
    String amount,
    String cUSTNAME,
    String remarks,
  ) async {
    Response response;
    try {
      late var params;
      //  = {
      //     "MOBILE_NUMBER": await getStringVal("mobileNumber"),
      //     "INVOICE_ID": invoice,
      //     "CUST_EMAIL": email,
      //     "EPOS_PAYMENT_OPTION": ePOSPAYMENTOPTION,
      //     "CUST_MOBILE": customerMob,
      //     "AMOUNT": aMOUNT,
      //     "NAME": cUSTNAME,
      //     "REMARKS": remarks,
      // };

      if (userType.toString() == "RESELLER") {
        params = {
          "PAY_ID": merchantID,
          "MOBILE_NUMBER": await getStringVal("mobileNumber"),
          "INVOICE_ID": invoice,
          "CUST_EMAIL": email,
          "EPOS_PAYMENT_OPTION": ePOSPAYMENTOPTION,
          "CUST_MOBILE": customerMob,
          "AMOUNT": amount,
          "NAME": cUSTNAME,
          "REMARKS": "remark",
        };
      } else if (userType.toString() == "MERCHANT" &&
          subMerchantID.toString().isNotEmpty) {
        // if (superMerchantPayId.toString().isNotEmpty) {
        //   getSubMerchantList(context, superMerchantPayId.toString());
        // }
        params = {
          "PAY_ID": subMerchantID,
          "MOBILE_NUMBER": await getStringVal("mobileNumber"),
          "INVOICE_ID": invoice,
          "CUST_EMAIL": email,
          "EPOS_PAYMENT_OPTION": ePOSPAYMENTOPTION,
          "CUST_MOBILE": customerMob,
          "AMOUNT": amount,
          "NAME": cUSTNAME,
          "REMARKS": remarks,
        };
      } else {
        params = {
          "MOBILE_NUMBER": await getStringVal("mobileNumber"),
          "INVOICE_ID": invoice,
          "CUST_EMAIL": email,
          "EPOS_PAYMENT_OPTION": ePOSPAYMENTOPTION,
          "CUST_MOBILE": customerMob,
          "AMOUNT": amount,
          "NAME": cUSTNAME,
          "REMARKS": remarks,
        };
      }

      response = await apiService.getUpiQrSale(
          params, context); //API call for getUPIQR

      if (response.statusCode == 200) {
        setState(() {
          if (response.data['RESPONSE_CODE'] == "000") {
            if (response.data['UPI_QR_CODE'].toString().isEmptyOrNull ||
                response.data['UPI_QR_CODE'] == null ||
                response.data['UPI_QR_CODE'].toString() == "null") {
              showPopUpDialog(errorpop, errorSomeWrong, context);
              //  showToastMsg(errorSomeWrong);
              //  Navigator.pop(context);
            } else {
              Navigator.of(context).pushNamed('/qrcode', arguments: {
                "qr_code": response.data["UPI_QR_CODE"]
              }); //redirect to qrCode screen with argument QRCOde.
            }
          } else {
            showPopUpDialog(
                errorpop, response.data['RESPONSE_MESSAGE'], context);
            //  showToastMsg(response.data['RESPONSE_MESSAGE']);
          }
        });
      } else {
        showPopUpDialog(errorpop, errorSomeWrong, context);
        // showToastMsg("error found");
      }
    } on Exception catch (e) {
      showPopUpDialog(errorpop, e.toString(), context);
      //showToastMsg(e.toString());
    }
  }

  Future transactionDetails(
    String invoice,
    String amount,
    var context,
  ) async {
    transactiondetails = <TransactionDetail>[];

    Response response;

    try {
      late var params;
      //  = {
      //   "INVOICE_ID": invoice,
      //   "MOBILE_NUMBER": await getStringVal("mobileNumber"),
      //   "TRANSACTION_MODE": "ePOS",
      // };

      if (userType.toString() == "RESELLER") {
        params = {
          "INVOICE_ID": invoice,
          "PAY_ID": merchantID,
          "AMOUNT": amount,
          "MOBILE_NUMBER": await getStringVal("mobileNumber"),
          "TRANSACTION_MODE": "ePOS",
        };
      } else if (userType.toString() == "MERCHANT" &&
          subMerchantID.toString().isNotEmpty) {
        params = {
          "INVOICE_ID": invoice,
          "PAY_ID": subMerchantID,
          "AMOUNT": amount,
          "MOBILE_NUMBER": await getStringVal("mobileNumber"),
          "TRANSACTION_MODE": "ePOS",
        };
      } else {
        params = {
          "INVOICE_ID": invoice,
          "MOBILE_NUMBER": await getStringVal("mobileNumber"),
          "TRANSACTION_MODE": "ePOS",
        };
      }

      response = await apiService.transactionDetail(
          params, context); //API call for transaction details

      if (response.statusCode == 200) {
        setState(() {
          transactiondetailresponse =
              TransactionDetailResponse.fromJson(response.data);
          if (transactiondetailresponse.tRANSACTIONDETAILS != null) {
            // transactionData = <TransactionData>[];
            json
                .decode(transactiondetailresponse.tRANSACTIONDETAILS.toString())
                .forEach((v) {
              transactiondetails.add(TransactionDetail.fromJson(v));
            });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Vx.hexToColor(blackColor),
      appBar: backButtonIos(
        backgroundColor: Vx.hexToColor(blackColor),
        automaticallyImplyLeading: !Platform.isAndroid,
        actions: [
          InkWell(
            onTap: () {
              if (widget.mComingFrom == "FormPage") {
                Navigator.pushNamedAndRemoveUntil(
                    context, "/fhome", (route) => false);
              } else {
                Navigator.of(context).pop(true);
              }
            },
            child: Container(
              padding: EdgeInsets.only(right: 20.0.w, top: 10.0.h),
              child: Icon(
                Icons.cancel,
                color: Colors.white,
                size: 35.h,
              ),
            ),
          ),
        ],
      ),
      /* appBar: buildHomeAppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => {
                    Navigator.of(context).pushNamed('/fhome'),
                  }),
          title: const Text("")), */
      body: SafeArea(
        child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            // physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            // itemCount: transactiondetails.length,
            itemCount: 1,

            //isNotEmpty
            // ? transactiondetails.length
            // : 0,
            itemBuilder: (BuildContext context, int index) {
              return transactiondetails.isNotEmpty
                  ? _statuswidget(transactiondetails[index])
                  : Container();
            }),
      ),
    );
  }

  Widget _statuswidget(
    TransactionDetail statusdata,
  ) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 25.h),
          child: Center(
            child: Container(
              width: 164.0.w,
              height: 164.0.h,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: inspireGreyColor,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              left: 20.0.w, right: 10.0.w, top: 100.0.h, bottom: 10.h),
          width: 335.0.w,
          height: 558.0.h,
          child: Card(
            child: Padding(
              padding: EdgeInsets.only(
                  right: 10.0.w, left: 20.0.w, top: 50.0.h, bottom: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.currency_rupee_outlined,
                        color: Colors.black,
                        size: 16.0.sp,
                      ),
                      statusdata.aMOUNT
                          .toString()
                          .text
                          .fontWeight(FontWeight.w700)
                          .size(36.0.sp)
                          .make(),
                    ],
                  ),

                  //use in future if needed status in two place
                  /*  Align(
                    alignment: Alignment.topCenter,
                    child: statusdata.sTATUS
                        .toString()
                        .text
                        .color(statuscolor(statusdata.sTATUS.toString()))
                        .size(14.sp)
                        .make(),
                  ), */
                  VSpace(8.0.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                              getTransIcon(
                                  statusdata.ePOSPAYMENTOPTION.toString()),
                              width: 30.0.w,
                              height: 30.0.h,
                              color: Vx.hexToColor(balckMainColor),
                              fit: BoxFit.scaleDown),
                          Padding(
                            padding: EdgeInsets.all(10.0.sp),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                VSpace(7.0.h),
                                statusdata.sTATUS
                                    .toString()
                                    .text
                                    .bold
                                    .color(statuscolor(
                                        statusdata.sTATUS.toString()))
                                    .size(14.0.sp)
                                    .make(),
                                VSpace(5.0.h),
                                statusdata.cREATEDATE
                                    .toString()
                                    .selectableText
                                    .color(Vx.hexToColor(balckMainColor))
                                    .size(12.0.sp)
                                    .make(),
                                VSpace(10.0.h),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          getstatus(
                            context,
                            statusdata.sTATUS.toString(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(),
                  VSpace(10.0.h),
                  invoiceDate.text
                      .color(Vx.hexToColor(balckMainColor))
                      .size(14.0.sp)
                      .bold
                      .make(),
                  VSpace(5.0.h),
                  statusdata.iNVOICEID
                      .toString()
                      .text
                      .color(Vx.hexToColor(balckMainColor))
                      .size(14.sp)
                      .make(),
                  VSpace(10.h),
                  buinessName.text
                      .color(Vx.hexToColor(balckMainColor))
                      .size(14.sp)
                      .bold
                      .make(),
                  VSpace(5.0.h),
                  statusdata.bUSINESSNAME
                      .toString()
                      .text
                      .color(Vx.hexToColor(balckMainColor))
                      .size(14.sp)
                      .make(),
                  VSpace(10.0.h),
                  cutomerName.text
                      .color(Vx.hexToColor(balckMainColor))
                      .size(14.sp)
                      .bold
                      .make(),
                  VSpace(5.0.h),
                  SizedBox(
                    //   width: ,
                    child: statusdata.cUSTNAME
                        .toString()
                        .text
                        .color(Vx.hexToColor(balckMainColor))
                        .maxLines(1)
                        .align(TextAlign.start)
                        .softWrap(false)
                        .size(14.sp)
                        .make(),
                  ),
                  VSpace(10.0.h),
                  customerEmail.text
                      .color(Vx.hexToColor(balckMainColor))
                      .size(14.sp)
                      .bold
                      .make(),
                  VSpace(5.0.h),
                  statusdata.cUSTEMAIL
                      .toString()
                      .text
                      .color(Vx.hexToColor(balckMainColor))
                      .size(14.0.sp)
                      .make(),
                  VSpace(10.0.h),
                  customerMob.text
                      .color(Vx.hexToColor(balckMainColor))
                      .size(14.0.sp)
                      .bold
                      .make(),
                  VSpace(5.0.h),
                  statusdata.cUSTMOBILE
                      .toString()
                      .text
                      .color(Vx.hexToColor(balckMainColor))
                      .size(14.0.sp)
                      .make(),
                  VSpace(5.0.h),

                  reportbutton(context, statusdata.sTATUS!, statusdata),
                  // VSpace(10.0.h),
                ],
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 60.h),
          child: Center(
            child: Container(
              height: 116.h,
              width: 116.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: statussysbol(statusdata.sTATUS.toString()),
            ),
          ),
        ),
      ],
    );
  }

  statuscolor(String status) {
    switch (status) {
      case successVal:
        return Colors.green;
      case capturedVal:
        return Colors.green;
      case pendingval:
        return Colors.orange;
      case failedval:
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  statussysbol(String status) {
    switch (status) {
      case successVal:
        return Container(
          width: 100.0.w,
          height: 100.0.h,
          decoration: BoxDecoration(
              color: Vx.hexToColor(balckMainColor), shape: BoxShape.circle),
          child: Center(
            child: SvgPicture.asset(
              successCheck,
              width: 50.0.w,
              height: 50.0.h,
            ),
          ),
        );
      case capturedVal:
        return Container(
          width: 100.0.w,
          height: 100.0.h,
          decoration: BoxDecoration(
              color: Vx.hexToColor(balckMainColor), shape: BoxShape.circle),
          child: Center(
            child: SvgPicture.asset(
              successCheck,
              width: 50.0.w,
              height: 50.0.h,
            ),
          ),
        );
      case pendingval:
        return Container(
          width: 100.0.w,
          height: 100.0.h,
          decoration: BoxDecoration(
              color: Vx.hexToColor(balckMainColor), shape: BoxShape.circle),
          child: Center(
            child: SvgPicture.asset(
              pending,
              width: 50.0.w,
              height: 50.0.h,
            ),
          ),
        );
      case failedval:
        return Container(
          width: 100.0.w,
          height: 100.0.h,
          decoration: BoxDecoration(
              color: Vx.hexToColor(balckMainColor), shape: BoxShape.circle),
          child: Center(
            child: SvgPicture.asset(
              failed,
              width: 50.0.w,
              height: 50.0.h,
            ),
          ),
        );
      default:
        return Container(
          width: 100.0.w,
          height: 100.0.h,
          decoration: BoxDecoration(
              color: Vx.hexToColor(balckMainColor), shape: BoxShape.circle),
          child: const Center(
              // child: SvgPicture.asset(failed),
              ),
        );
    }
  }

//calling status botton
  getstatus(
    BuildContext context,
    String status,
  ) {
    switch (status) {
      case successVal:
        return Container(
          width: 0.w,
          height: 0.h,
        );
      case pendingval:
        return getbutton(
          getStatus,
          ref: () {
            // getStatusRefresh(widget.invoice, context, amount);
            transactionDetails(widget.invoice, widget.amount, context);
          },
          onpressed: null,
        );
      case failedval:
        return getbutton(
          getStatus,
          ref: () {
            // getStatusRefresh(widget.invoice, context, amount);
            transactionDetails(widget.invoice, widget.amount, context);
          },
          onpressed: null,
        );

      default:
        return Container();
    }
  }

  reportbutton(
    BuildContext context,
    String status,
    TransactionDetail statusdata,
  ) {
    switch (status) {
      case successVal:
        return Container();
      case pendingval:
        if (statusdata.ePOSPAYMENTOPTION.toString() == "PG_QR") {
          return resendbutton(regenratedQrcode, ref: () {
            resendQrCode(
                context,
                widget.invoice,
                statusdata.cUSTEMAIL.toString(),
                statusdata.ePOSPAYMENTOPTION.toString(),
                statusdata.cUSTMOBILE.toString(),
                widget.amount,
                statusdata.bUSINESSNAME.toString(),
                remarks);
          }, onpressed: null);
        } else {
          return resendbutton(resendLink, ref: () {
            resndLink(widget.invoice, context);
          }, onpressed: null);
        }

      case failedval:
        return resendbutton(resendLink, ref: () {
          resndLink(widget.invoice, context);
        }, onpressed: null);
      default:
        return Container();
    }
  }
}
