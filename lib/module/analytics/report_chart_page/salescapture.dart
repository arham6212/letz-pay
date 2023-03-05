import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:letzpay/common_components/common_widget.dart';
import 'package:letzpay/common_functions/common_functions.dart';

import 'package:letzpay/module/analytics/report_chart_page/report_module/response_report_chart.dart';
import 'package:letzpay/services/network/api_services.dart';
import 'package:letzpay/services/shared_pref.dart';
import 'package:letzpay/utils/assets_path.dart';

import 'package:letzpay/utils/colors.dart';
import 'package:letzpay/utils/strings.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:velocity_x/velocity_x.dart';

import '../../../common_components/home_app_bar.dart';

class SaleCapture extends StatefulWidget {
  const SaleCapture({Key? key}) : super(key: key);

  @override
  State<SaleCapture> createState() => _SaleCaptureState();
}

class _SaleCaptureState extends State<SaleCapture> {
  late String reportType;
  late String fromDate;
  late String toDate;
  late ApiService apiService;
  late ResponseReportChart responseReportChart;
  late Map<String, double> dataMap;
  late bool apiState = false;
  String selectedFromDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String selectedToDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  String lastFromDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String lastToDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  late String superMerchantFlag = "";
  late String superMerchantPayId = "";
  late String userType = "";
  late String businessName = "";
  late String merchantID = "";
  late String merchantName = "";
  late String subMerchantID = "";
  late String subMerchantName = "";
  //color list for PIE chart transaction data
  final colorList = <Color>[
    Color.fromARGB(255, 120, 192, 223),
    Color.fromARGB(255, 156, 231, 133),
    Color.fromARGB(255, 147, 130, 226),
    Color.fromARGB(255, 201, 215, 148),
    Color.fromARGB(255, 227, 136, 136),
    Color.fromARGB(255, 167, 97, 183),
    Color.fromARGB(255, 233, 181, 149),
    Color.fromARGB(255, 211, 130, 162),
    // Color.fromARGB(255, 107, 195, 176),
  ];

  @override
  void setState(fn) {
    //this method is call for avoid memory leak issue.
    if (mounted) {
      super.setState(fn);
    }
  }

  //This function get transaction data according to payment option
  Future getReportChart(var context, var params) async {
    setState(() {
      apiState = true;
    });

    Response response;
    try {
      response = await apiService.getReportChart(
          context, params); //API call for getReportChart data

      if (response.statusCode == 200) {
        setState(() {
          responseReportChart = ResponseReportChart.fromJson(response.data);

          dataMap = {
            "Credit Card": double.parse(responseReportChart.cC.toString()),
            "Cash On Delivery": double.parse(responseReportChart.cD.toString()),
            "UPI QR": double.parse(responseReportChart.uPIQR.toString()),
            "EMI": double.parse(responseReportChart.eM.toString()),
            "Net Banking": double.parse(responseReportChart.nB.toString()),
            "Wallet": double.parse(responseReportChart.wL.toString()),
            "UPI": double.parse(responseReportChart.uP.toString()),
            "Debit Card": double.parse(responseReportChart.dC.toString()),
            // "Internatinal": double.parse(responseReportChart.cC.toString()),
          };
        });
      } else {
        showPopUpDialog(errorpop, errorSomeWrong, context);
        // showToastMsg("error found");
      }
      setState(() {
        apiState = false;
      });
    } on Exception catch (e) {
      showPopUpDialog(errorpop, e.toString(), context);
      //  showToastMsg(e.toString());
      setState(() {
        apiState = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    dataMap = {};
    responseReportChart = ResponseReportChart();

    apiService = ApiService();

    getSharedData();
    // makeReportChartParams();
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

    makeReportChartParams();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backButtonIos(
        backgroundColor: Vx.hexToColor(blackColor),
        automaticallyImplyLeading: !Platform.isAndroid,
        title: saleCapture.text.size(32.sp).bold.color(white).make(),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 15.0.w),
              child: GestureDetector(
                  child: Icon(
                    Icons.filter_alt,
                    color: white,
                  ),
                  onTap: (() => _navigateWithCallBack(context)))),
        ],
      ),
      body: SafeArea(
        child: apiState
            ? Center(child: Image.asset(loaderimage))
            : SingleChildScrollView(
                child: Container(
                    //  height: MediaQuery.of(context).size.height,
                    padding:
                        pagepadding(), //  padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              children: [
                                totalTrans.text
                                    .size(15)
                                    .color(Vx.hexToColor(darkblue))
                                    .fontWeight(FontWeight.bold)
                                    .make(),
                                responseReportChart.tOTALTRANSACTION
                                    .toString()
                                    .text
                                    .size(15.0.sp)
                                    .color(black)
                                    .fontWeight(FontWeight.bold)
                                    .make(),
                              ],
                            ),
                            Column(
                              children: [
                                totalAmount.text
                                    .size(15)
                                    .color(Vx.hexToColor(darkblue))
                                    .fontWeight(FontWeight.bold)
                                    .make(),
                                "\u{20B9}${responseReportChart.tOTALAMOUNT.toString()}"
                                    .text
                                    .color(black)
                                    .size(15.0.sp)
                                    .bold
                                    .make(),
                              ],
                            ),
                          ],
                        ),
                        VSpace(10),
                        dataMap != null && dataMap.isNotEmpty
                            ? PieChart(
                                dataMap: dataMap,
                                animationDuration:
                                    const Duration(milliseconds: 500),
                                chartLegendSpacing: 32,
                                //chartRadius: MediaQuery.of(context).size.width / 1.2,
                                colorList: colorList,
                                initialAngleInDegree: 0,
                                chartType: ChartType.ring,
                                ringStrokeWidth: 32,
                                //  centerText: "HYBRID",
                                legendOptions: const LegendOptions(
                                  showLegendsInRow: false,

                                  // showLegendsInRow: false,
                                  legendPosition: LegendPosition.right,
                                  showLegends: true,
                                  //  legendShape: _BoxShape.circle,
                                  legendTextStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : Container()
                      ],
                    )),
              ),
      ),
    );
  }

  _navigateWithCallBack(BuildContext context) async {
    var params = await Navigator.of(context).pushNamed(
        '/Reportview'); //redirect to sale capture screen to view PIE chart.

    if (!mounted) return;

    if (params != null) {
      setState(() {
        dataMap = {};
        responseReportChart = ResponseReportChart();
        getReportChart(context, params);
      });
    }
  }

  void makeReportChartParams() async {
    var date = DateTime.now().toString();
    var dateParse = DateTime.parse(date);

    reportType = "SALE_CAPTURED";
    if (dateParse.month.toString().length > 2) {
      fromDate =
          "${dateParse.year}-${dateParse.month - 1}-${dateParse.day + 1}";
    } else {
      fromDate =
          "${dateParse.year}-0${dateParse.month - 1}-${dateParse.day + 1}";
    }

    toDate = "${dateParse.year}-${dateParse.month}-${dateParse.day}";

    late var params;
    //  = {
    //   "MOBILE_NUMBER": await getStringVal("mobileNumber"),
    //   "REPORT_TYPE": reportType,
    //   "DATE_FROM": fromDate,
    //   "DATE_TO": toDate
    // };

    if (userType.toString() == "RESELLER") {
      params = {
        "SUPERMERCHANT_PAY_ID": merchantID,
        "MOBILE_NUMBER": await getStringVal("mobileNumber"),
        "REPORT_TYPE": reportType,
        "DATE_FROM": fromDate,
        "DATE_TO": toDate
      };
    } else if (userType.toString() == "MERCHANT" &&
        subMerchantID.toString().isNotEmpty) {
      // if (superMerchantPayId.toString().isNotEmpty) {
      //   getSubMerchantList(context, superMerchantPayId.toString());
      // }
      params = {
        "SUPERMERCHANT_PAY_ID": subMerchantID,
        "MOBILE_NUMBER": await getStringVal("mobileNumber"),
        "REPORT_TYPE": reportType,
        "DATE_FROM": fromDate,
        "DATE_TO": toDate
      };
    } else {
      params = {
        "MOBILE_NUMBER": await getStringVal("mobileNumber"),
        "REPORT_TYPE": reportType,
        "DATE_FROM": fromDate,
        "DATE_TO": toDate
      };
    }

    getReportChart(context, params);
  }
}
