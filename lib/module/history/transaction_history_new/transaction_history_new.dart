import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';

import 'package:letzpay/common_functions/no_data_found.dart';

import 'package:letzpay/services/network/api_services.dart';
import 'package:letzpay/services/shared_pref.dart';
import 'package:letzpay/utils/assets_path.dart';
import 'package:letzpay/utils/colors.dart';
import 'package:letzpay/utils/strings.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../common_functions/common_functions.dart';
import '../../../common_components/common_list_loader.dart';
import '../../../common_components/common_widget.dart';
import '../../../common_components/home_app_bar.dart';
import '../../../common_components/logger.dart';
import 'transaction_history_module/response_transaction_history.dart';

class TransactionHistoryNew extends StatefulWidget {
  const TransactionHistoryNew({Key? key}) : super(key: key);

  @override
  State<TransactionHistoryNew> createState() => _TransactionHistoryNewState();
}

class _TransactionHistoryNewState extends State<TransactionHistoryNew> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late ApiService apiService;
  late ResponseTransactionHistory responseTransactionHistory;
  late List<TransactionData> transactionData;
  late List transCreatedDate;
  int startPage = 0;
  String reloadFlag = "true";
  final int _limit = 10;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  late var mContext;
  String selectedFromDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String selectedToDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  String lastFromDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String lastToDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  String selectedPayType = "ALL";
  List payType = [
    "ALL",
    crDeCardLbl,
    internationalLbl,
    netBankingLbl,
    upiLbl,
    upiQrLbl,
    pgQrLbl,
    emiLbl,
    walletLbl,
    cashOnDeliveryLbl
  ];

  String selectedStatus = "ALL";
  List statusType = ["ALL", "Success", "Failed", "Cancelled", "Pending"];

  String selectedTransType = "EPOS";
  List transType = ["EPOS", "Direct", "All"];

  @override
  void setState(fn) {
    //this method is call for avoid memory leak issue.
    if (mounted) {
      super.setState(fn);
    }
  }

  // get Transaction history list with isFilter bool variable
  void getTransactionHistory(var isFilter) async {
    if (transactionData.isNotEmpty) {
      transactionData.clear();
    }

    setState(() {
      _isFirstLoadRunning = true;
    });

    Response response;
    try {
      var params;

      if (isFilter == false) {
        //list without date filter
        params = {
          "START": startPage,
          "LENGTH": _limit,
          "MOBILE_NUMBER": await getStringVal("mobileNumber"),
          "TRANSACTION_MODE": "ePOS"
        };
      } else {
        params = {
          //list with date filter
          "START": startPage,
          "LENGTH": _limit,
          "MOBILE_NUMBER": await getStringVal("mobileNumber"),
          "PAYMENT_TYPE": getPaymentData(selectedPayType),
          "STATUS": getStatuDtata(selectedStatus),
          "TRANSACTION_MODE": selectedTransType,
          "DATE_FROM": selectedFromDate,
          "DATE_TO": selectedToDate
        };
      }

      response = await apiService.getTransactionHistory(params, mContext,
          "First"); //API call for getting transaction history list

      if (response.statusCode == 200) {
        //success of api call
        setState(() {
          responseTransactionHistory =
              ResponseTransactionHistory.fromJson(response.data);

          if (responseTransactionHistory.tRANSACTIONDATA != null) {
            json
                .decode(responseTransactionHistory.tRANSACTIONDATA.toString())
                .forEach((v) {
              transactionData.add(TransactionData.fromJson(v));
            });
            reloadFlag = responseTransactionHistory.rELOAD.toString();
          } else {
            showPopUpDialog(errorpop, errorNoDataAvailable, context);
          }
        });
      } else {
        showPopUpDialog(errorpop, errorSomeWrong, context);
      }
    } on Exception catch (e) {
      showPopUpDialog(errorpop, e.toString(), context);
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  // getting transaction hisory if recored are more and user perform scroll in the list
  void getTransactionHistoryLoadMore() async {
    if (reloadFlag == "true" &&
        _hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      startPage = transactionData.length + 1; // Increase _page by 1
      Response response;
      try {
        var params = {
          "START": startPage,
          "LENGTH": _limit,
          "MOBILE_NUMBER": await getStringVal("mobileNumber"),
          "PAYMENT_TYPE": getPaymentData(selectedPayType),
          "STATUS": selectedStatus,
          "TRANSACTION_MODE": selectedTransType,
          "DATE_FROM": selectedFromDate,
          "DATE_TO": selectedToDate
        };

        response = await apiService.getTransactionHistory(params, mContext,
            "LoadMore"); //API call for getting transaction hisory if recored are more and user perform scroll in the list

        if (response.statusCode == 200) {
          //success of API call
          setState(() {
            responseTransactionHistory =
                ResponseTransactionHistory.fromJson(response.data);
            reloadFlag = responseTransactionHistory.rELOAD.toString();
            if (responseTransactionHistory.tRANSACTIONDATA != null ||
                responseTransactionHistory.rELOAD.toString().toLowerCase() ==
                    "true") {
              json
                  .decode(responseTransactionHistory.tRANSACTIONDATA.toString())
                  .forEach((v) {
                transactionData.add(TransactionData.fromJson(v));
              });
            } else {
              setState(() {
                _hasNextPage = false;
                showPopUpDialog(errorpop, errorNoDataAvailable, context);
              });
            }
          });
        } else {
          showPopUpDialog(errorpop, errorSomeWrong, context);
        }
      } on Exception catch (e) {
        showPopUpDialog(errorpop, e.toString(), context);
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  // The controller for the ListView
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();

    mContext = context;

    responseTransactionHistory = ResponseTransactionHistory();
    transactionData = <TransactionData>[];
    transCreatedDate = <String>[];
    apiService = ApiService();

    //printLog("test", getPaymentData("Cash On Delivery"), "e");
    getTransactionHistory(true);

    _controller = ScrollController()
      ..addListener(getTransactionHistoryLoadMore);
  }

  @override
  void dispose() {
    _controller.removeListener(getTransactionHistoryLoadMore);
    super.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context, {String? invoice}) {
    // TODO: implement build

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.transparent,
      appBar: backButtonIos(
        backgroundColor: Vx.hexToColor(blackColor),
        automaticallyImplyLeading: !Platform.isAndroid,
        title: historyLbl.text.size(32.sp).bold.color(white).make(),
        // SvgPicture.asset(notificationIcon)
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(24),
                  color: Vx.hexToColor(blackColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Card(
                          // clipBehavior: Clip.hardEdge,
                          color: white,
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
                                                      primarySwatch:
                                                          Colors.grey,
                                                      splashColor: Colors.black,
                                                      textTheme:
                                                          const TextTheme(
                                                        subtitle1: TextStyle(
                                                            color:
                                                                Colors.black),
                                                        button: TextStyle(
                                                            color:
                                                                Colors.black),
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
                                                          onPrimary:
                                                              Colors.white,
                                                          surface: Colors.black,
                                                          onSurface:
                                                              Colors.black,
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
                                                lastDate: DateTime.parse(
                                                    lastFromDate));

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
                                              getTransactionHistory(true);
                                            }
                                          });
                                        }
                                      },
                                    );
                                  },
                                  child: Container(
                                    width: (MediaQuery.of(context).size.width /
                                            2) -
                                        34,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                                      primarySwatch:
                                                          Colors.grey,
                                                      splashColor: Colors.black,
                                                      textTheme:
                                                          const TextTheme(
                                                        subtitle1: TextStyle(
                                                            color:
                                                                Colors.black),
                                                        button: TextStyle(
                                                            color:
                                                                Colors.black),
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
                                                          onPrimary:
                                                              Colors.white,
                                                          surface: Colors.black,
                                                          onSurface:
                                                              Colors.black,
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
                                                DateTime.parse(
                                                    selectedFromDate),
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
                                              getTransactionHistory(true);
                                            }
                                          });
                                        }
                                      },
                                    );
                                  },
                                  child: Container(
                                    width: (MediaQuery.of(context).size.width /
                                            2) -
                                        34,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                      VSpace(12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: (MediaQuery.of(context).size.width / 3) - 24,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                paymentType.text
                                    .size(12)
                                    .color(Vx.hexToColor(whiteMainColor))
                                    .make(),
                                InkWell(
                                  onTap: (() {
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) => StatefulBuilder(
                                                builder: (BuildContext context,
                                                    StateSetter setStateNew) {
                                              return ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxHeight: 620.h,
                                                  // MediaQuery.of(context)
                                                  //         .size
                                                  //         .height *
                                                  //     0.75.h,
                                                  minHeight: 200.h,
                                                  // MediaQuery.of(context)
                                                  //         .size
                                                  //         .height *
                                                  //     0.35.h,
                                                  // MediaQuery.of(context)
                                                  //         .size
                                                  //         .height *
                                                  //     0.75.h,
                                                  // statusType.length *
                                                  //     70.h,
                                                ),
                                                child: Container(
                                                  margin: EdgeInsets.all(10.sp),

                                                  //   height: statusType.length * 200,
                                                  child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 12.0,
                                                                  left: 12.0,
                                                                  top: 10.0,
                                                                  bottom: 10.0),
                                                          child: Row(
                                                            children: [
                                                              InkWell(
                                                                onTap: (() {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                }),
                                                                child:
                                                                    const Icon(
                                                                  Icons.close,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                              HSpace(10.w),
                                                              paymentType.text
                                                                  .size(18)
                                                                  .bold
                                                                  .color(Vx
                                                                      .hexToColor(
                                                                          balckMainColor))
                                                                  .make(),
                                                            ],
                                                          ),
                                                        ),
                                                        const Divider(
                                                          thickness: 1,
                                                        ),
                                                        Expanded(
                                                          child: ListView
                                                              .separated(
                                                                  separatorBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return VSpace(
                                                                        10);
                                                                  },
                                                                  itemCount:
                                                                      payType
                                                                          .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return InkWell(
                                                                      onTap:
                                                                          (() {
                                                                        selectedPayType =
                                                                            payType[index].toString();
                                                                        getTransactionHistory(
                                                                            true);
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      }),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(12),
                                                                        child:
                                                                            Text(
                                                                          payType[
                                                                              index],
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize:
                                                                                18.0.sp,
                                                                            //   fontWeight: FontWeight.bold,
                                                                            // textAlign: TextAlign.center
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }),
                                                        )
                                                      ]),
                                                ),
                                              );
                                            }));
                                  }),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            selectedPayType,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.black,
                                          size: 20,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                // InkWell(
                                //   onTap: () {
                                //     showLsearchPopUp(
                                //         context, paymentType, payType,
                                //         typeFunction: () {
                                //       getTransactionHistory(true);
                                //       //   print('data>>>>>>>>>>');
                                //     });
                                //     //  operateListBottomSheet(context);
                                //   },
                                //   child: Container(
                                //     padding: const EdgeInsets.all(10),
                                //     decoration: BoxDecoration(
                                //       color: Colors.white,
                                //       borderRadius: BorderRadius.circular(5),
                                //     ),
                                //     child: Row(
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.spaceBetween,
                                //       crossAxisAlignment:
                                //           CrossAxisAlignment.start,
                                //       children: [
                                //         "ALL".text.make(),
                                //         const Icon(
                                //           Icons.arrow_drop_down,
                                //           color: Colors.black,
                                //         )
                                //       ],
                                //     ),
                                //   ),
                                // )

                                // DropdownButtonHideUnderline(
                                //   child: GFDropdown(
                                //     isExpanded: true,
                                //     padding: const EdgeInsets.all(10),
                                //     borderRadius: BorderRadius.circular(5),
                                //     border: const BorderSide(
                                //         color: Colors.black12, width: 1),
                                //     dropdownButtonColor: Colors.white,
                                //     value: selectedPayType,
                                //     icon: const Icon(Icons.keyboard_arrow_down),
                                //     items: payType.map((var value) {
                                //       return DropdownMenuItem(
                                //         value: value,
                                //         child: Text(value,
                                //             style: TextStyle(fontSize: 12)),
                                //       );
                                //     }).toList(),
                                //     onChanged: (var newValue) {
                                //       setState(() {
                                //         selectedPayType = newValue.toString();
                                //         getTransactionHistory(true);
                                //       });
                                //     },
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          HSpace(12),
                          Container(
                            width: (MediaQuery.of(context).size.width / 3) - 24,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                statusMode.text
                                    .size(12)
                                    .color(Vx.hexToColor(whiteMainColor))
                                    .make(),
                                InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                        //  isScrollControlled: true,
                                        context: context,
                                        builder:
                                            (context) => StatefulBuilder(
                                                    builder:
                                                        (BuildContext context,
                                                            StateSetter
                                                                setStateNew) {
                                                  return ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                      maxHeight: 350.h,

                                                      minHeight: 200.h,
                                                      // statusType.length *
                                                      //     70.h,
                                                    ),
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.all(10.sp),

                                                      //   height: statusType.length * 200,
                                                      child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          12.0,
                                                                      left:
                                                                          12.0,
                                                                      top: 10.0,
                                                                      bottom:
                                                                          10.0),
                                                              child: Row(
                                                                children: [
                                                                  InkWell(
                                                                    onTap: (() {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    }),
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .close,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                  HSpace(10.w),
                                                                  statusLbl.text
                                                                      .size(18)
                                                                      .bold
                                                                      .color(Vx
                                                                          .hexToColor(
                                                                              balckMainColor))
                                                                      .make(),
                                                                ],
                                                              ),
                                                            ),
                                                            const Divider(
                                                              thickness: 1,
                                                            ),
                                                            Expanded(
                                                              child: ListView
                                                                  .separated(
                                                                      separatorBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return VSpace(
                                                                            10);
                                                                      },
                                                                      itemCount:
                                                                          statusType
                                                                              .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return InkWell(
                                                                          onTap:
                                                                              (() {
                                                                            selectedStatus =
                                                                                statusType[index].toString();
                                                                            getTransactionHistory(true);
                                                                            Navigator.of(context).pop();
                                                                          }),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(12),
                                                                            child:
                                                                                Text(
                                                                              statusType[index],
                                                                              style: const TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 18.0,
                                                                                //   fontWeight: FontWeight.bold,
                                                                                // textAlign: TextAlign.center
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }),
                                                            )
                                                          ]),
                                                    ),
                                                  );
                                                }));
                                    //  operateListBottomSheet(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            selectedStatus,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                          ),
                                        ),
                                        // selectedStatus.text
                                        //     .overflow(TextOverflow.ellipsis)
                                        //     .make(), //status
                                        const Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.black,
                                          size: 20,
                                        )
                                      ],
                                    ),
                                  ),
                                )

                                // DropdownButtonHideUnderline(
                                //   child: GFDropdown(
                                //     isExpanded: true,
                                //     padding: const EdgeInsets.all(10),
                                //     borderRadius: BorderRadius.circular(5),
                                //     border: const BorderSide(
                                //         color: Colors.black12, width: 1),
                                //     dropdownButtonColor: Colors.white,
                                //     value: selectedStatus,
                                //     icon: const Icon(Icons.keyboard_arrow_down),
                                //     items: statusType.map((var value) {
                                //       return DropdownMenuItem(
                                //         value: value,
                                //         child: Text(value,
                                //             style: TextStyle(fontSize: 12)),
                                //       );
                                //     }).toList(),
                                //     onChanged: (var newValue) {
                                //       setState(() {
                                //         selectedStatus = newValue.toString();
                                //         getTransactionHistory(true);
                                //       });
                                //     },
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          HSpace(12),
                          Container(
                            width: (MediaQuery.of(context).size.width / 3) - 24,
                            // color: white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                transModeLbl.text
                                    .size(12)
                                    .color(Vx.hexToColor(whiteMainColor))
                                    .make(),
                                InkWell(
                                  onTap: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) =>
                                    //           PersistentBottomScreen()),
                                    // );

                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) => StatefulBuilder(
                                                builder: (BuildContext context,
                                                    StateSetter setStateNew) {
                                              return ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxHeight: 240.h,
                                                  // MediaQuery.of(context)
                                                  //         .size
                                                  //         .height *
                                                  //     0.29.h,
                                                  minHeight: 200.h,
                                                  // statusType.length * 40.h,
                                                ),
                                                child: Container(
                                                  margin: EdgeInsets.all(10.sp),
                                                  // height:
                                                  //     MediaQuery.of(context)
                                                  //             .size
                                                  //             .height *
                                                  //         0.2,
                                                  child:
                                                      Column(children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 12.0,
                                                              left: 12.0,
                                                              top: 10.0,
                                                              bottom: 10.0),
                                                      child: Row(
                                                        children: [
                                                          InkWell(
                                                            onTap: (() {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            }),
                                                            child: const Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                          HSpace(10.w),
                                                          transMode.text
                                                              .size(18)
                                                              .bold
                                                              .color(Vx.hexToColor(
                                                                  balckMainColor))
                                                              .make(),
                                                        ],
                                                      ),
                                                    ),
                                                    const Divider(
                                                      thickness: 1,
                                                    ),
                                                    Expanded(
                                                      child: ListView.separated(
                                                          separatorBuilder:
                                                              (context, index) {
                                                            return VSpace(10);
                                                          },
                                                          // controller:
                                                          //     scrollController,
                                                          itemCount:
                                                              transType.length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return InkWell(
                                                              onTap: () {
                                                                selectedTransType =
                                                                    transType[
                                                                            index]
                                                                        .toString();
                                                                getTransactionHistory(
                                                                    true);
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(12),
                                                                child: Text(
                                                                  transType[
                                                                      index],
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        18.0,
                                                                    //   fontWeight: FontWeight.bold,
                                                                    // textAlign: TextAlign.center
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                    )
                                                  ]),
                                                ),
                                              );
                                            }));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            selectedTransType,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                          ),
                                        ),
                                        // selectedTransType.text
                                        //     .make(), //transmode
                                        const Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.black,
                                          size: 20,
                                        )
                                      ],
                                    ),
                                  ),
                                )

                                // DropdownButtonHideUnderline(
                                //   child: GFDropdown(
                                //     isExpanded: true,
                                //     padding: const EdgeInsets.all(10),
                                //     borderRadius: BorderRadius.circular(5),
                                //     border: const BorderSide(
                                //         color: Colors.black12, width: 1),
                                //     dropdownButtonColor: Colors.white,
                                //     value: selectedTransType,
                                //     icon: const Icon(Icons.keyboard_arrow_down),
                                //     items: transType.map((var value) {
                                //       return DropdownMenuItem(
                                //           value: value,
                                //           child: Text(
                                //             value,
                                //             style: TextStyle(
                                //               fontSize: 12.0.sp,
                                //             ),
                                //           ));
                                //     }).toList(),
                                //     onChanged: (var newValue) {
                                //       setState(() {
                                //         selectedTransType = newValue.toString();
                                //         getTransactionHistory(true);
                                //       });
                                //     },
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
              transactionData.isEmpty || transactionData == null
                  ? Column(
                      children: [
                        VSpace(MediaQuery.of(context).size.height * 0.25),
                        NoDataFound()
                      ],
                    )
                  : Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          controller: _controller,
                          itemCount: transactionData.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                                onTap: () => {
                                      //redirect to success transaction screen with argument invoiceId,amount and TransactionHistory type.
                                      Navigator.of(context).pushNamed(
                                          '/succestrasaction',
                                          arguments: {
                                            "invoice": transactionData[index]
                                                .iNVOICEID,
                                            "amount": transactionData[index]
                                                .aMOUNT
                                                .toString(),
                                            "mComingFrom": "TransactionHistory"
                                          }),
                                    },
                                child: _transHistListWidget(
                                    transactionData[index], index));
                          }),
                    ),
              // when the _loadMore function is running
              if (_isLoadMoreRunning == true)
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 40),
                  child: Center(
                    child: LoadingList(),
                  ),
                ),

              // When nothing else to load
              if (_hasNextPage == false)
                Container(
                  padding: const EdgeInsets.only(top: 30, bottom: 40),
                  color: Colors.amber,
                  child: Center(
                    child: loaderFetch.text.make(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  //transaction history listItem view
  _transHistListWidget(TransactionData history, int position) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          position == 0 ? VSpace(15.0) : Container(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              historyStatus(history.sTATUS.toString()),
              Container(
                padding: EdgeInsets.only(left: 10.0),
                width: MediaQuery.of(context).size.width - 88,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        history.iNVOICEID
                            .toString()
                            .text
                            .size(16)
                            .color(Vx.hexToColor(balckMainColor))
                            .bold
                            .align(TextAlign.left)
                            .make(),
                        VSpace(5),
                        history.ePOSPAYMENTOPTION
                            .toString()
                            .text
                            .size(12)
                            .color(Vx.hexToColor(greySubTextColor))
                            .make(),
                        VSpace(5),
                        history.cREATEDATE
                            .toString()
                            .text
                            .size(12)
                            .color(Vx.hexToColor(greySubTextColor))
                            .make(),
                      ],
                    ),
                    "\u{20B9} ${history.aMOUNT.toString()}"
                        .text
                        .size(14)
                        .color(Vx.hexToColor(balckMainColor))
                        .fontWeight(FontWeight.bold)
                        .make(),
                  ],
                ),
              )
            ],
          ),
          VSpace(10),
          Divider()
        ],
      ),
    );
  }

  //return Container according to transaction status value.
  historyStatus(String status) {
    switch (status) {
      case successVal:
        return Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
              color: Vx.hexToColor(softGrey), shape: BoxShape.circle),
          child: Center(
            child: SvgPicture.asset(successCheck),
          ),
        );
      case capturedVal:
        return Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
              color: Vx.hexToColor(softGrey), shape: BoxShape.circle),
          child: Center(
            child: SvgPicture.asset(successCheck),
          ),
        );
      case pendingval:
        return Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
              color: Vx.hexToColor(softGrey), shape: BoxShape.circle),
          child: Center(
            child: SvgPicture.asset(pending),
          ),
        );
      case failedval:
        return Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
              color: Vx.hexToColor(softGrey), shape: BoxShape.circle),
          child: Center(
            child: SvgPicture.asset(failed),
          ),
        );
      default:
        return Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
              color: Vx.hexToColor(softGrey), shape: BoxShape.circle),
          child: Center(
              // child: SvgPicture.asset(failed),
              ),
        );
    }
  }
}
