import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:letzpay/common_components/common_widget.dart';
import 'package:letzpay/common_components/home_app_bar.dart';
import 'package:letzpay/common_components/logger.dart';
import 'package:letzpay/common_functions/common_functions.dart';
import 'package:letzpay/module/analytics/report_chart_page/report_module/report_model.dart';
import 'package:letzpay/services/shared_pref.dart';
import 'package:letzpay/utils/assets_path.dart';
import 'package:letzpay/utils/colors.dart';
import 'package:letzpay/utils/strings.dart';
import 'package:velocity_x/velocity_x.dart';

class ReportView extends StatefulWidget {
  const ReportView({Key? key}) : super(key: key);

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  String selectedFromDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String selectedToDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  String lastFromDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String lastToDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  late GlobalKey<FormState> _formKey = new GlobalKey();
  late List<ReportModel> users;
  late ReportModel selectedUser = ReportModel("1", "Sale Capture");
  TextEditingController dateinput =
      TextEditingController(); //text editing controller for text field(date from)
  TextEditingController dateinputto = TextEditingController();

  String selectedPayType = "Sale Captured";
  List payType = [
    "Sale Captured",
    "Sale Settled",
    "Refund Capture",
  ]; //text editing controller for text field(date to)
  String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  setSelectedUser(ReportModel user) {
    setState(() {
      selectedUser = user;
    });
  }

  @override
  void initState() {
    users = ReportModel.paymentlist();
    dateinput.text =
        currentDate; //set the initial value of text field(date from)

    dateinputto.text =
        currentDate; //set the initial value of text field  (date to)
    super.initState();
  }

  @override
  void setState(fn) {
    //this method is call for avoid memory leak issue.
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backButtonIos(
        backgroundColor: Vx.hexToColor(blackColor),
        automaticallyImplyLeading: !Platform.isAndroid,
        title: reportTittle.text.size(32.sp).bold.color(white).make(),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Container(
              margin: EdgeInsets.all(20.sp),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10.h),
                      child: paymentType.text.size(20).bold.make(),
                    ),
                    VSpace(10),

                    InkWell(
                      onTap: (() {
                        //open bottom sheet of pay type list
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) => StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter setStateNew) {
                                  return ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight: 240.h,
                                      minHeight: 200.h,
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.all(10.sp),

                                      //   height: statusType.length * 200,
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 12.0,
                                                  left: 12.0,
                                                  top: 10.0,
                                                  bottom: 10.0),
                                              child: Row(
                                                children: [
                                                  InkWell(
                                                    onTap: (() {
                                                      Navigator.of(context)
                                                          .pop();
                                                    }),
                                                    child: const Icon(
                                                      Icons.close,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  HSpace(10.w),
                                                  paymentType.text
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

                                            //lsitview for paytype
                                            Expanded(
                                              child: ListView.separated(
                                                  separatorBuilder:
                                                      (context, index) {
                                                    return VSpace(10);
                                                  },
                                                  itemCount: payType.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return InkWell(
                                                      onTap: (() {
                                                        setState(
                                                          () {
                                                            selectedPayType =
                                                                payType[index]
                                                                    .toString();

                                                            print(
                                                                selectedPayType);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        );
                                                      }),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12),
                                                        child: Text(
                                                          payType[index],
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18.0.sp,
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
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.only(
                            top: 15, bottom: 15, right: 10, left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              selectedPayType,
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

                    // Container(
                    //   decoration: BoxDecoration(
                    //     border: Border.all(color: greyColor, width: 1.0),
                    //     borderRadius: BorderRadius.circular(15),
                    //   ),
                    //   padding: const EdgeInsets.only(left: 25, right: 20),
                    //   margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    //   child: InkWell(
                    //     onTap: (() {
                    //       setState(
                    //         () {
                    //           RadioDailoug();
                    //         },
                    //       );
                    //     }),
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         crossAxisAlignment: CrossAxisAlignment.center,
                    //         children: [
                    //           selectedUser.name.text.make(),
                    //           Icon(
                    //             Icons.arrow_drop_down_circle,
                    //             size: 30,
                    //             color: Vx.hexToColor(darkblue),
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    VSpace(20),
                    //date form

                    // Padding(
                    //   padding: EdgeInsets.only(left: 25, right: 20),
                    //   child: dateForm.text.size(15).make(),
                    // ),

                    // Container(
                    //   decoration: BoxDecoration(
                    //     border: Border.all(color: greyColor, width: 1.0),
                    //     borderRadius: BorderRadius.circular(15),
                    //   ),
                    //   padding: const EdgeInsets.only(left: 25, right: 20),
                    //   margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    //   child: InkWell(
                    //     onTap: (() {
                    //       setState(
                    //         () async {
                    //           DateTime? pickedDate = await showDatePicker(
                    //               context: context,
                    //               initialDate: DateTime.now(),
                    //               firstDate: DateTime(
                    //                   2000), //DateTime.now() - not to allow to choose before today.
                    //               lastDate: DateTime(2101));

                    //           if (pickedDate != null) {
                    //             print(
                    //                 pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                    //             String formattedDate =
                    //                 DateFormat('dd-MM-yyyy').format(pickedDate);
                    //             // print(
                    //             //     formattedDate); //formatted date output using intl package =>  2021-03-16
                    //             //you can implement different kind of Date Format here according to your requirement

                    //             setState(() {
                    //               dateinput.text =
                    //                   formattedDate; //set output date to TextField value.
                    //             });
                    //           } else {
                    //             showPopUpDialog(
                    //                 errorpop, errorDateNotSelected, context);
                    //             // showToastMsg("Date is not selected");
                    //           }
                    //         },
                    //       );
                    //     }),
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         crossAxisAlignment: CrossAxisAlignment.center,
                    //         children: [
                    //           dateinput.text.text.make(),
                    //           Icon(
                    //             Icons.calendar_month,
                    //             size: 30,
                    //             color: Vx.hexToColor(darkblue),
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // VSpace(10),
                    // //date to
                    // Padding(
                    //   padding: EdgeInsets.only(left: 25, right: 20),
                    //   child: dateTo.text.size(15).make(),
                    // ),

                    //  Container(
                    //   decoration: BoxDecoration(
                    //     border: Border.all(color: greyColor, width: 1.0),
                    //     borderRadius: BorderRadius.circular(15),
                    //   ),
                    //   padding: const EdgeInsets.only(left: 25, right: 20),
                    //   margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    //   child: InkWell(
                    //     onTap: (() {
                    //       setState(
                    //         () async {
                    //           DateTime? pickedDate = await showDatePicker(
                    //               context: context,
                    //               initialDate: DateTime.now(),
                    //               firstDate: DateTime(
                    //                   2000), //DateTime.now() - not to allow to choose before today.
                    //               lastDate: DateTime(2101));

                    //           if (pickedDate != null) {
                    //             print(
                    //                 pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                    //             String formattedDate =
                    //                 DateFormat('dd-MM-yyyy').format(pickedDate);
                    //             print(
                    //                 formattedDate); //formatted date output using intl package =>  2021-03-16
                    //             //you can implement different kind of Date Format here according to your requirement

                    //             setState(() {
                    //               dateinputto.text =
                    //                   formattedDate; //set output date to TextField value.
                    //             });
                    //           } else {
                    //             showPopUpDialog(
                    //                 errorpop, errorDateNotSelected, context);
                    //             // showToastMsg("Date is not selected");
                    //           }
                    //         },
                    //       );
                    //     }),
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         crossAxisAlignment: CrossAxisAlignment.center,
                    //         children: [
                    //           dateinputto.text.text.make(),
                    //           Icon(
                    //             Icons.calendar_month,
                    //             size: 30,
                    //             color: Vx.hexToColor(darkblue),
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    Container(
                        // clipBehavior: Clip.hardEdge,
                        //   color: white,
                        margin: EdgeInsets.all(0),
                        //  width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.circular(5),
                        ),
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
                                            // getTransactionHistory(true);
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
                                            // getTransactionHistory(true);
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
                    VSpace(20),
                    signInButton(context: context, reportView, ref: () {
                      final formstate = _formKey.currentState;
                      if (formstate!.validate()) {
                        formstate.save();
                        // showToastMsg("Success");

                        navigateBack(); //call method for date format
                        FocusScope.of(context).requestFocus(FocusNode());
                      } else {
                        showPopUpDialog(errorpop, failedval, context);
                        // showToastMsg("failed");
                      }
                    }, onpressed: null),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  //paymentlist radio not used
  RadioDailoug() {
    // SearchModel searchModel = users[0];

    // selectedUser = SearchModel("", "");
    List<Widget> widgets = [];
    for (ReportModel user in users) {
      widgets.add(
        RadioListTile(
          value: user,
          groupValue: selectedUser,
          //title: Text(user.id),
          title: user.name.text.make(),

          onChanged: (ReportModel? currentUser) {
            //  print("Current User ${currentUser?.name}");
            // showToastMsg("Selected ${currentUser?.name}");
            setSelectedUser(currentUser!);
            Navigator.pop(context);
            // RadioDailoug();
          },
          selected: selectedUser == user,
          activeColor: primaryBlueColor,
        ),
      );
    }
    //   return widgets;
    // }

    return showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            elevation: 0.0,
            backgroundColor: Colors.white,
            child: SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.min, children: widgets))));
  }

  //set from Date and To Date in format.
  void navigateBack() async {
    final fromDateSplited = dateinput.text.toString().split('-');

    var fromDate = "";
    if (fromDateSplited[1].toString().length > 1) {
      fromDate =
          "${fromDateSplited[2]}-${fromDateSplited[1]}-${fromDateSplited[0]}";
    } else {
      fromDate =
          "${fromDateSplited[2]}-0${fromDateSplited[1]}-${fromDateSplited[0]}";
    }

    final toDateSplited = dateinputto.text.toString().split('-');

    var toDate = "";
    if (toDateSplited[1].toString().length > 1) {
      toDate = "${toDateSplited[2]}-${toDateSplited[1]}-${toDateSplited[0]}";
    } else {
      toDate = "${toDateSplited[2]}-0${toDateSplited[1]}-${toDateSplited[0]}";
    }

    var params = {
      "MOBILE_NUMBER": await getStringVal("mobileNumber"),
      "REPORT_TYPE": selectedPayType.replaceAll(" ", "_").toUpperCase(),
      "DATE_FROM": fromDate.toString(),
      "DATE_TO": toDate.toString()
    };

    // printLog("ParamsReport", params.toString(), "d");
    Navigator.pop(context, params);
  }
}
