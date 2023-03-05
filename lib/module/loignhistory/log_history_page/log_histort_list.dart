import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:letzpay/module/loignhistory/login_history_module/response_login_history.dart';
import 'package:letzpay/utils/assets_path.dart';
import 'package:letzpay/utils/colors.dart';
import 'package:letzpay/utils/strings.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../common_functions/common_functions.dart';
import '../../../common_components/common_widget.dart';
import '../../../common_components/home_app_bar.dart';
import '../../../services/network/api_services.dart';
import '../../../services/shared_pref.dart';

class LogHistoryPage extends StatefulWidget {
  const LogHistoryPage({Key? key}) : super(key: key);

  @override
  LogHistoryPageState createState() => LogHistoryPageState();
}

class LogHistoryPageState extends State<LogHistoryPage> {
  late ApiService apiService;
  String selectedFromDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String selectedToDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  String lastFromDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String lastToDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  late Loginhistoryresponse loginhistoryresponse;
  late List<LoginHistoryData> loginHistoryData;
  bool _isFirstLoadRunning = false;
  // The controller for the ListView
  late ScrollController _controller;

  @override
  void setState(fn) {
    //this method is call for avoid memory leak issue.
    if (mounted) {
      super.setState(fn);
    }
  }

//get login history with date filter or without filter
  void getLoginHistory(var context, var isFilter) async {
    if (loginHistoryData.isNotEmpty) {
      loginHistoryData.clear();
    }

    setState(() {
      _isFirstLoadRunning = true;
    });
    Response response;
    try {
      var params;
      if (isFilter == false) {
        params = {
          "MOBILE_NUMBER": await getStringVal("mobileNumber"), //without filter
        };
      } else {
        params = {
          "MOBILE_NUMBER": await getStringVal("mobileNumber"),
          "DATE_FROM": selectedFromDate, //with date filter
          "DATE_TO": selectedToDate //with date filter
        };
      }

      response = await apiService.getLoginHistory(params,
          context); //API call for getting login hisory according to filter or not

      if (response.statusCode == 200) {
        setState(() {
          loginhistoryresponse = Loginhistoryresponse.fromJson(response.data);

          if (loginhistoryresponse.lOGINRECORDS != null) {
            json
                .decode(loginhistoryresponse.lOGINRECORDS.toString())
                .forEach((v) {
              loginHistoryData.add(new LoginHistoryData.fromJson(v));
            });
          }
        });
      } else {
        //    showPopUpDialog("error found");
      }
    } on Exception catch (e) {
      showPopUpDialog(errorpop, e.toString(), context);
    }
  }

  @override
  initState() {
    super.initState();
    apiService = ApiService();
    loginHistoryData = <LoginHistoryData>[];
    loginhistoryresponse = Loginhistoryresponse();

    getLoginHistory(context, false);
    _controller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      appBar: backButtonIos(
        backgroundColor: Vx.hexToColor(blackColor),
        automaticallyImplyLeading: !Platform.isAndroid,
        title: loginHistoryLbl.text.size(32).bold.color(white).make(),
      ),
      body: SafeArea(
        child: Container(
          //   padding: pagepadding(),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(24),
                color: Vx.hexToColor(blackColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        // clipBehavior: Clip.hardEdge,

                        decoration: BoxDecoration(
                          color: Vx.hexToColor(whiteMainColor),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                        ),
                        margin: EdgeInsets.all(0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(
                                    () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                              context: context,
                                              builder: (BuildContext context,
                                                  Widget? child) {
                                                return Theme(
                                                  data: ThemeData(
                                                    primarySwatch: Colors.grey,
                                                    splashColor: Colors.black,
                                                    textTheme: const TextTheme(
                                                      subtitle1: TextStyle(
                                                          color: Colors.black),
                                                      button: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    accentColor: Colors.black,
                                                    colorScheme: const ColorScheme
                                                            .light(
                                                        primary: Color.fromARGB(
                                                            255,
                                                            15,
                                                            14,
                                                            14), //main chnages
                                                        primaryVariant:
                                                            Colors.black,
                                                        secondaryVariant:
                                                            Colors.black,
                                                        onSecondary:
                                                            Colors.black,
                                                        onPrimary: Colors.white,
                                                        surface: Colors.black,
                                                        onSurface: Colors.black,
                                                        secondary:
                                                            Colors.black),
                                                    dialogBackgroundColor:
                                                        Colors.white,
                                                  ),
                                                  child: child ?? Text(""),
                                                );
                                              },
                                              initialDate: DateTime.parse(
                                                  selectedFromDate),
                                              firstDate: DateTime(
                                                  2000), //DateTime.now() - not to allow to choose before today.
                                              lastDate:
                                                  DateTime.parse(lastFromDate));

                                      if (pickedDate != null) {
                                        String formattedDate =
                                            DateFormat('yyyy-MM-dd')
                                                .format(pickedDate);
                                        setState(() {
                                          final difference = daysBetween(
                                              DateTime.parse(formattedDate),
                                              DateTime.parse(selectedToDate));
                                          if (difference > 30) {
                                            showPopUpDialog(errorpop,
                                                errorOneMonthLimit, context);
                                          } else if (difference < 0) {
                                            showPopUpDialog(
                                                errorpop,
                                                errorStartDateBeforeEndDate,
                                                context);
                                          } else {
                                            selectedFromDate =
                                                formattedDate; //set output date to TextField value.
                                            getLoginHistory(context, true);
                                          }
                                        });
                                      }
                                    },
                                  );
                                },
                                child: Container(
                                  width:
                                      (MediaQuery.of(context).size.width / 2) -
                                          34,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      HSpace(10),
                                      SvgPicture.asset(calendarIcon),
                                      HSpace(10),
                                      Center(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            fromLbl.text
                                                .size(12)
                                                .color(Vx.hexToColor(
                                                    greySubTextColor))
                                                .make(),
                                            DateFormat('dd-MM-yyyy')
                                                .format(DateTime.parse(
                                                    selectedFromDate))
                                                .toString()
                                                .text
                                                .size(14)
                                                .color(Vx.hexToColor(
                                                    balckMainColor))
                                                .make(),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 35,
                                color: greyColor,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(
                                    () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                              context: context,
                                              builder: (BuildContext context,
                                                  Widget? child) {
                                                return Theme(
                                                  data: ThemeData(
                                                    primarySwatch: Colors.grey,
                                                    splashColor: Colors.black,
                                                    textTheme: const TextTheme(
                                                      subtitle1: TextStyle(
                                                          color: Colors.black),
                                                      button: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    accentColor: Colors.black,
                                                    colorScheme: const ColorScheme
                                                            .light(
                                                        primary: Color.fromARGB(
                                                            255,
                                                            15,
                                                            14,
                                                            14), //main chnages
                                                        primaryVariant:
                                                            Colors.black,
                                                        secondaryVariant:
                                                            Colors.black,
                                                        onSecondary:
                                                            Colors.black,
                                                        onPrimary: Colors.white,
                                                        surface: Colors.black,
                                                        onSurface: Colors.black,
                                                        secondary:
                                                            Colors.black),
                                                    dialogBackgroundColor:
                                                        Colors.white,
                                                  ),
                                                  child: child ?? Text(""),
                                                );
                                              },
                                              initialDate: DateTime.parse(
                                                  selectedToDate),
                                              firstDate: DateTime(
                                                  2000), //DateTime.now() - not to allow to choose before today.
                                              lastDate:
                                                  DateTime.parse(lastToDate));

                                      if (pickedDate != null) {
                                        String formattedDate =
                                            DateFormat('yyyy-MM-dd')
                                                .format(pickedDate);
                                        setState(() {
                                          final difference = daysBetween(
                                              DateTime.parse(selectedFromDate),
                                              DateTime.parse(formattedDate));

                                          if (difference > 30) {
                                            showPopUpDialog(errorpop,
                                                errorOneMonthLimit, context);
                                          } else if (difference < 0) {
                                            showPopUpDialog(
                                                errorpop,
                                                errorEndDateAfterStartDate,
                                                context);
                                          } else {
                                            selectedToDate =
                                                formattedDate; //set output date to TextField value.
                                            getLoginHistory(context, true);
                                          }
                                        });
                                      }
                                    },
                                  );
                                },
                                child: Container(
                                  width:
                                      (MediaQuery.of(context).size.width / 2) -
                                          34,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      HSpace(10),
                                      SvgPicture.asset(calendarIcon),
                                      HSpace(10),
                                      Center(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            toLbl.text
                                                .size(12)
                                                .color(Vx.hexToColor(
                                                    greySubTextColor))
                                                .make(),
                                            DateFormat('dd-MM-yyyy')
                                                .format(DateTime.parse(
                                                    selectedToDate))
                                                .toString()
                                                .text
                                                .size(14)
                                                .color(Vx.hexToColor(
                                                    balckMainColor))
                                                .make(),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: loginHistoryData.length,
                    //  controller: _controller,
                    itemBuilder: (BuildContext context, int index) {
                      // return _historyWidget(histories[index]);
                      return _loginHistoryWidget(loginHistoryData[index]);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

//login history Item view
  Widget _loginHistoryWidget(LoginHistoryData history) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 5.0, top: 5.0, left: 10.0, right: 10.0),
      child: Column(children: [
        VSpace(10.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            businessNameLbl.text
                .size(16.0.sp)
                .color(Vx.hexToColor(balckMainColor))
                .bold
                .make(),
            history.businessName
                .toString()
                .text
                .size(12.0.sp)
                .color(Vx.hexToColor(balckMainColor))
                .bold
                .make(),
          ],
        ),
        VSpace(5.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            emailIdLbl.text
                .size(16.0.sp)
                .color(Vx.hexToColor(balckMainColor))
                .bold
                .make(),
            history.emailId
                .toString()
                .text
                .size(12.0.sp)
                .color(Vx.hexToColor(balckMainColor))
                .bold
                .make(),
          ],
        ),
        VSpace(5.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            browserLbl.text
                .size(16.0.sp)
                .color(Vx.hexToColor(balckMainColor))
                .bold
                .make(),
            history.browser
                .toString()
                .text
                .size(12.0.sp)
                .color(Vx.hexToColor(balckMainColor))
                .bold
                .make(),
          ],
        ),
        VSpace(5.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ipAddressLbl.text
                .size(16.0.sp)
                .color(Vx.hexToColor(balckMainColor))
                .bold
                .make(),
            history.ip
                .toString()
                .text
                .size(12.0.sp)
                .color(Vx.hexToColor(balckMainColor))
                .bold
                .make(),
          ],
        ),
        VSpace(5.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            operatingSystemLbl.text
                .size(16.0.sp)
                .color(Vx.hexToColor(balckMainColor))
                .bold
                .make(),
            history.os
                .toString()
                .text
                .size(12.0.sp)
                .color(Vx.hexToColor(balckMainColor))
                .bold
                .make(),
          ],
        ),
        VSpace(5.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            loginTimeLbl.text
                .size(16.0.sp)
                .color(Vx.hexToColor(balckMainColor))
                .bold
                .make(),
            history.timeStamp
                .toString()
                .text
                .size(12.0.sp)
                .color(Vx.hexToColor(balckMainColor))
                .bold
                .make(),
          ],
        ),
        VSpace(5.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            statusLbl.text
                .size(16.0.sp)
                .color(Vx.hexToColor(balckMainColor))
                .bold
                .make(),
            history.status
                .toString()
                .text
                .size(12.0.sp)
                .color(Vx.hexToColor(balckMainColor))
                .bold
                .make(),
          ],
        ),
        VSpace(10.0),
        Divider(),
      ]),
    );
  }
}
