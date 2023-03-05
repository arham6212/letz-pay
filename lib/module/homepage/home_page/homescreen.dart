import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/components/dropdown/gf_dropdown.dart';
import 'package:letzpay/common_functions/common_functions.dart';

import 'package:letzpay/common_components/common_widget.dart';
import 'package:letzpay/module/payment_form/paymentgrid_modal/allcard_grid.dart';
import 'package:letzpay/module/drawer/drawer.dart';
import 'package:letzpay/common_components/logger.dart';

import 'package:letzpay/main.dart';

import 'package:letzpay/module/analytics/report_chart_page/report_module/response_request_option.dart';
// import 'package:letzpay/modules/franchise/homepage/piechart_card.dart';
import 'package:letzpay/module/homepage/merchant_modules/reponse_supermerchant.dart';
import 'package:letzpay/module/homepage/summary_module/respons_transactionsummary.dart';
import 'package:letzpay/module/logout%20_modal/log_out_module/response_logout.dart';
import 'package:letzpay/module/homepage/merchant_modules/response_submerchant.dart';

import 'package:letzpay/module/history/transaction_history_new/transaction_history_module/response_transaction_history.dart';
import 'package:letzpay/module/login/loginmodule/response_loginauth.dart';

import 'package:letzpay/services/authentication_service.dart';
import 'package:letzpay/services/network/api_services.dart';
import 'package:letzpay/services/network_services.dart';
import 'package:letzpay/services/shared_pref.dart';
import 'package:letzpay/utils/assets_path.dart';
import 'package:letzpay/utils/colors.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../utils/strings.dart';
import 'package:getwidget/getwidget.dart';

class HomeScreen extends StatefulWidget {
  // var uSERTYPE = getStringVal('USER_TYPE');

  // HomeScreen({Key? key}) : super(key: key);

  HomeScreen({
    Key? key,
  }) : super(key: key);

  // HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ApiService apiService;
  int _selectedIndex = 0;
  final NavigationService _navigationService = locator<NavigationService>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late Loginauthresponse loginauthresponse;
  late Transsummaryresponse transsummaryresponse;
  late ResponseRequestOption requestOption;
  late List<PaymentOptionData> paymentOptionData;
  late Logoutresponse logoutresponse;

  late ResponseTransactionHistory responseTransactionHistory;

  late List<TransactionData> transactionData;

  bool _hasTransactionData = false;
  late var mContext;
  late String superMerchantFlag;
  late String superMerchantPayId;
  late String userType = "";
  late String businessName = "";
  late String merchantID = "";
  late String merchantName = "";
  late String subMerchantID = "";
  late String subMerchantName = "";

  late String mobileNumberPref = "";
  late String loginTypePref = "";
  late String pinOrOtpPref = "";

  late SupermerchantResponse supermerchantResponse;
  late SubmerchantResponse submerchantResponse;
  late List<UserData> userdata;
  late List<SubUserdata> subuserdata;

  StateSetter? _setState;

  static late UserData selectedMerchant;
  static late SubUserdata selectedSubMerchant;

  bool? sUPERMERCHANTFLAG = false;
  bool? showSubMerchantFlag = false;
  bool? showSubmitBtnFlag = true;

  @override
  void setState(fn) {
    //this method is call for avoid memory leak issue.
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

//Handle logout
  Future getlogout(var context) async {
    Response response;
    try {
      var params = {"FLAG": "true"};

      response = await apiService.getLogOut(params, context);

      if (response.statusCode == 200) {
        setState(() {
          _navigationService.clearAllAndNavigatorTo(
              "/login"); //clear all stack and redirect to login screen
          // AuthenticationProvider.of(context).logout();
          // prefs.clear();
          // Navigator.of(context).pop(true);
          // showPopUpDialogClose(rYoulogOutLbl, wantLogoutLbl, context);
        });
      } else {
        showPopUpDialog(errorpop, errorSomeWrong, context);
      }
    } on Exception catch (e) {
      showPopUpDialog(errorpop, e.toString(), context);
    }
  }

  //getting all transaction summary list
  Future getTransactionSummary(var context) async {
    Response response;
    try {
      // var params = {
      //   "MOBILE_NUMBER": await getStringVal("mobileNumber"),
      //   "LOGIN_TYPE": await getStringVal("loginType"),
      //   "PIN": await getStringVal("pinOrOtp"),
      // };

      var params = {
        "MOBILE_NUMBER": mobileNumberPref,
        "LOGIN_TYPE": loginTypePref,
        "PIN": pinOrOtpPref,
      };

      response = await apiService.getTransactionSummary(
          params, context); //API call for getting transaction history list

      if (response.statusCode == 200) {
        setState(() {
          transsummaryresponse = Transsummaryresponse.fromJson(response.data);
        });
      } else {
        showPopUpDialog(errorpop, errorSomeWrong, context);
      }
    } on Exception catch (e) {
      showPopUpDialog(errorpop, e.toString(), context);
    }
  }

//This function all payment option according to user type
  Future getPaymentOption(var context) async {
    paymentOptionData = <PaymentOptionData>[];
    Response response;
    try {
      late var params;
      // = {
      //   "MOBILE_NUMBER": await getStringVal("mobileNumber"),
      //   "LOGIN_TYPE": await getStringVal("loginType"),
      //   "PIN": await getStringVal("pinOrOtp"),
      // };

      if (userType.toString() == "RESELLER") {
        params = {"PAY_ID": merchantID, "MOBILE_NUMBER": mobileNumberPref};
      } else if (userType.toString() == "MERCHANT" &&
          subMerchantID.toString().isNotEmpty) {
        // if (superMerchantPayId.toString().isNotEmpty) {
        //   getSubMerchantList(context, superMerchantPayId.toString());
        // }
        params = {"PAY_ID": subMerchantID, "MOBILE_NUMBER": mobileNumberPref};
      } else {
        params = {
          "MOBILE_NUMBER": mobileNumberPref,
          "LOGIN_TYPE": loginTypePref,
          "PIN": pinOrOtpPref,
        };
      }

      response = await apiService.getPymentOption(params,
          context); //API call for getting payment option according to user

      if (response.statusCode == 200) {
        setState(() {
          requestOption = ResponseRequestOption.fromJson(response.data);

          if (requestOption != null) {
            json
                .decode(requestOption.pAYMENTOPTIONS.toString())
                .forEach((pAYMENTOPTIONS) {
              paymentOptionData
                  .add(new PaymentOptionData(pAYMENTOPTIONS: pAYMENTOPTIONS));
            });
          }
        });
      } else {
        showPopUpDialog(errorpop, errorSomeWrong, context);
      }
    } on Exception catch (e) {
      showPopUpDialog(errorpop, e.toString(), context);
    }
  }

//Getting  Super merchant list
  Future getSuperMerchantList(var context) async {
    Response response;
    try {
      var params = {
        "MOBILE_NUMBER": await getStringVal("mobileNumber"),
      };

      response = await apiService.getSuperMerchantList(
          params, context); //API call for getting Super merchant list

      if (response.statusCode == 200) {
        //on success of API
        setState(() {
          supermerchantResponse = SupermerchantResponse.fromJson(response.data);

          if (supermerchantResponse.list != null) {
            json.decode(supermerchantResponse.list.toString()).forEach((v) {
              userdata.add(UserData.fromJson(v));
            });
          }
        });
      } else {
        showPopUpDialog(errorpop, errorSomeWrong, context);
      }
    } on Exception catch (e) {
      showPopUpDialog(errorpop, e.toString(), context);
    }

    if (userdata.isNotEmpty) {
      selectedMerchant = userdata[0];

      merchantselect(context);
    }
  }

  //This function get sub mechant list
  Future getSubMerchantList(String payid, var context) async {
    Response response;

    subuserdata = <SubUserdata>[];
    try {
      var params = {
        "MOBILE_NUMBER": await getStringVal(
            "mobileNumber"), //getting value from shared pref key
        "PAY_ID": payid,
      };

      response = await apiService.getSubMerchantList(
          params, context); //API call for getting sub merchant list

      if (response.statusCode == 200) {
        //on success of API call
        setState(() {
          submerchantResponse = SubmerchantResponse.fromJson(response.data);

          if (submerchantResponse.list != null) {
            json.decode(submerchantResponse.list.toString()).forEach((v) {
              subuserdata.add(SubUserdata.fromJson(v));
            });
          }
        });
      } else {
        showPopUpDialog(errorpop, errorSomeWrong, context);
      }
    } on Exception catch (e) {
      showPopUpDialog(errorpop, e.toString(), context);
    }

    if (userType.toString() == "MERCHANT") {
      if (superMerchantPayId.toString().isNotEmpty) {
        setState(() {
          if (subuserdata.isNotEmpty) {
            selectedSubMerchant = subuserdata[0];
            showSubMerchantFlag = true;

            UserData userMerchantData = UserData();
            userMerchantData.pAYID = superMerchantPayId.toString();
            userMerchantData.bUSINESSNAME = businessName.toString();
            userMerchantData.sUPERMERCHANTFLAG =
                superMerchantFlag.toString().toLowerCase() == 'true';

            selectedMerchant = userMerchantData;

            merchantselect(context);
          }
        });
      }
    } else {
      _setState!(() {
        if (subuserdata.isNotEmpty) {
          selectedSubMerchant = subuserdata[0];

          if (userType.toString() == "MERCHANT") {
            if (subMerchantID.toString().isNotEmpty) {
              merchantselect(context);
            }
          }
        }
      });
    }
  }

  //getting value from shared pref variable.
  void getSharedData() async {
    mobileNumberPref = await getStringVal("mobileNumber");
    loginTypePref = await getStringVal("loginType");
    pinOrOtpPref = await getStringVal("pinOrOtp");

    superMerchantFlag = await getStringVal(superMerchantFlagPrefKey);
    superMerchantPayId = await getStringVal(superMerchantPayIdPrefKey);
    subMerchantName = await getStringVal(subMerchantNamePrefKey);
    subMerchantID = await getStringVal(subMerchantIdPrefKey);
    merchantName = await getStringVal(merchantNamePrefKey);

    merchantID = await getStringVal(merchantIdPrefKey);

    userType = await getStringVal(userTypePrefKey);
    businessName = await getStringVal(businessNamePrefKey);

    if (mobileNumberPref.toString().isEmptyOrNull ||
        userType.toString().isEmptyOrNull ||
        loginTypePref.toString().isEmptyOrNull) {
      final timer = Timer(
        const Duration(seconds: 1),
        () {
          getTransactionSummary(context);
          getPaymentOption(context);
        },
      );
    } else {
      getTransactionSummary(context);
      getPaymentOption(context);
    }

    if (userType.toString() == "RESELLER") {
      if (merchantID.toString().isEmptyOrNull) {
        getSuperMerchantList(context);
      }
    } else if (userType.toString() == "MERCHANT") {
      if (superMerchantPayId.toString().isNotEmpty &&
          subMerchantName.toString().isEmptyOrNull) {
        getSubMerchantList(superMerchantPayId.toString(), context);
      }
    } else {}

    printLog(
        "Merchant",
        "UserType ${userType.toString()} Flag ${superMerchantFlag.toString()} PayID ${superMerchantPayId.toString()}",
        "e");
  }

  @override
  initState() {
    getTransactionSummary(context);
    super.initState();

    apiService = ApiService();
    logoutresponse = Logoutresponse();
    transsummaryresponse = Transsummaryresponse();
    requestOption = ResponseRequestOption();
    paymentOptionData = <PaymentOptionData>[];
    responseTransactionHistory = ResponseTransactionHistory();
    transactionData = <TransactionData>[];

    supermerchantResponse = SupermerchantResponse();
    submerchantResponse = SubmerchantResponse();
    userdata = <UserData>[];
    subuserdata = <SubUserdata>[];
    selectedMerchant = UserData();
    selectedSubMerchant = SubUserdata();

    loginauthresponse = Loginauthresponse();

    mContext = context;

    getSharedData();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  Future<bool> _onWillPop() async {
    _scaffoldKey.currentState!.closeDrawer();
    return showPopUpDialogExit(rYouSureLbl, wantExitLbl, context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        drawer: DrawerList(scaffoldKey: _scaffoldKey),
        appBar: AppBar(
          backgroundColor: Vx.hexToColor(whiteMainColor),
          iconTheme: IconThemeData(color: Vx.hexToColor(balckMainColor)),
          title: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // "${welcomeNLbl} ${widget.subMerchantName}"
                userType.toString() == "RESELLER"
                    ? "${welcomeNLbl} ${transsummaryresponse.bUSINESSNAME}!"
                        .text
                        .color(Vx.hexToColor(balckMainColor))
                        .size(14)
                        .make()
                    : "${welcomeNLbl} ${businessName}!"
                        .text
                        .color(Vx.hexToColor(balckMainColor))
                        .size(14)
                        .make(),
                merchantName.isEmptyOrNull
                    ? Container()
                    : "${merchantName} "
                        .toString()
                        .text
                        .color(Vx.hexToColor(balckMainColor))
                        .size(14)
                        .make()
              ],
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 15.0.w),
              child: InkWell(
                onTap: (() => showPopUpDialogClose(
                            rYoulogOutLbl, wantLogoutLbl, context, refYes: () {
                          // AuthenticationProvider.of(context).logout()
                          // showToastMsg("succes");
                          getlogout(context);
                        }, refNo: () {
                          Navigator.of(context).pop(false);
                        })

                    // AuthenticationProvider.of(context).logout()
                    ),
                child: Icon(
                  Icons.logout_outlined,
                  color: Vx.hexToColor(balckMainColor),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            color: Vx.hexToColor(whiteMainColor),
            child: Column(
              children: [
                VSpace(20.h),
                Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: Container(
                    // color: Vx.hexToColor(backgroundColor),
                    width: 335.w,
                    height: 120.h,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(backgroundCardImage),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 10.0.w,
                          right: 10.0.w,
                          top: 10.0.h,
                          bottom: 10.0.h),
                      child: Container(
                        margin: EdgeInsets.only(
                            top: 10.0.h, left: 10.0.w, right: 10.0.w),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: todaytransaction.text
                                  .color(Vx.hexToColor(balckMainColor))
                                  .size(16.0.sp)
                                  .bold
                                  .make(),
                            ),
                            VSpace(5.0.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    balanceAmount.text
                                        .color(Vx.hexToColor(balckMainColor))
                                        .size(16.0.sp)
                                        .make(),
                                    VSpace(2.0.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.currency_rupee_outlined,
                                          color: Colors.black,
                                          size: 20.0,
                                        ),
                                        HSpace(5),
                                        // transsummaryresponse.tRANSACTIONAMOUNT
                                        //         .toString()
                                        //         .isEmptyOrNull
                                        //     ? Container()
                                        //     : convertAmountTwoDecimal(
                                        //             transsummaryresponse
                                        //                 .tRANSACTIONAMOUNT
                                        //                 .toString())
                                        transsummaryresponse.tRANSACTIONAMOUNT
                                            .toString()
                                            .text
                                            .color(
                                                Vx.hexToColor(balckMainColor))
                                            .size(18.0.sp)
                                            .bold
                                            .make(),

                                        // willcheck the code and imple ment double decimal
                                        // ".00"
                                        //     .text
                                        //     .color(Vx.hexToColor(balckMainColor))
                                        //     .size(18.sp)
                                        //     .bold
                                        //     .make(),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    volume.text
                                        .color(Vx.hexToColor(balckMainColor))
                                        .size(16.sp)
                                        .make(),
                                    VSpace(2.0.h),
                                    transsummaryresponse.tRANSACTIONCOUNT
                                        .toString()
                                        .text
                                        .color(Vx.hexToColor(balckMainColor))
                                        .size(18.0.sp)
                                        .bold
                                        .make(),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                VSpace(28.h),
                Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: Container(
                    width: 335.w,
                    height: 100.h,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(homebanner),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
                VSpace(28.h),
                SizedBox(
                  height: 369.h,
                  width: 335.w,
                  child: GridPage(paymentOptionData),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//according to user type select merchant dropdown is display to choose mechant
  void merchantselect(
    var context,
  ) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: StatefulBuilder(builder: (context, newSetState) {
              _setState = newSetState;
              return AlertDialog(
                // elevation: 5,
                title: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50.h,
                    decoration: BoxDecoration(
                        color: Vx.hexToColor(balckMainColor),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0))),
                    child: Center(
                      child: merchant.text.size(16).white.make().p(10),
                    )),
                titlePadding: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                content: Container(
                  width: MediaQuery.of(context).size.width,
                  color: white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  (userType == "MERCHANT" &&
                                          superMerchantPayId
                                              .toString()
                                              .isNotEmpty)
                                      ? Container()
                                      : VSpace(10),
                                  (userType == "MERCHANT" &&
                                          superMerchantPayId
                                              .toString()
                                              .isNotBlank)
                                      ? Container()
                                      : selectMerchantLbl.text.size(13).make(),
                                  (userType == "MERCHANT" &&
                                          superMerchantPayId
                                              .toString()
                                              .isNotEmpty)
                                      ? Container()
                                      : VSpace(10),
                                  (userType == "MERCHANT" &&
                                          superMerchantPayId
                                              .toString()
                                              .isNotEmpty)
                                      ? Container()
                                      : DropdownButtonHideUnderline(
                                          child: GFDropdown(
                                            isExpanded: true,
                                            padding: const EdgeInsets.all(10),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: const BorderSide(
                                                color: Colors.black12,
                                                width: 1),
                                            dropdownButtonColor: Colors.white,
                                            value: selectedMerchant,
                                            // borderRadius:
                                            //     BorderRadius.all(Radius.circular(10.0)),
                                            icon: const Icon(
                                                Icons.keyboard_arrow_down),
                                            items: userdata.map((var user) {
                                              return DropdownMenuItem(
                                                value: user,
                                                child: user.bUSINESSNAME
                                                    .toString()
                                                    .text
                                                    .size(14.0.sp)
                                                    .make(),
                                              );
                                            }).toList(),
                                            onChanged: (var newValue) {
                                              UserData userData =
                                                  newValue as UserData;
                                              if (userData.sUPERMERCHANTFLAG ==
                                                  false) {
                                                newSetState(() {
                                                  setState(() {
                                                    selectedMerchant = userData;
                                                    sUPERMERCHANTFLAG = userData
                                                        .sUPERMERCHANTFLAG;

                                                    showSubMerchantFlag = false;
                                                    showSubmitBtnFlag = true;
                                                    // Navigator.pop(context);
                                                    // merchantselect(context);
                                                  });
                                                });
                                              } else {
                                                sUPERMERCHANTFLAG =
                                                    userData.sUPERMERCHANTFLAG;
                                                newSetState(() async {
                                                  selectedMerchant = userData;

                                                  showSubMerchantFlag = true;
                                                  showSubmitBtnFlag == true;
                                                  await getSubMerchantList(
                                                    selectedMerchant.pAYID
                                                        .toString(),
                                                    context,
                                                  );
                                                });
                                              }
                                            },
                                          ),
                                        )
                                ],
                              ),
                            ),
                            (showSubMerchantFlag == false)
                                ? Container()
                                : Container(
                                    width:
                                        MediaQuery.of(context).size.width - 32,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        VSpace(20),
                                        selectSubMerchantLbl.text
                                            .size(13)
                                            .make(),
                                        VSpace(10),
                                        DropdownButtonHideUnderline(
                                          child: GFDropdown(
                                            isExpanded: true,
                                            padding: const EdgeInsets.all(10),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: const BorderSide(
                                                color: Colors.black12,
                                                width: 1),
                                            dropdownButtonColor: Colors.white,
                                            value: selectedSubMerchant,
                                            // borderRadius:
                                            //     BorderRadius.all(Radius.circular(10.0)),
                                            icon: const Icon(
                                                Icons.keyboard_arrow_down),
                                            items: subuserdata.map((var value) {
                                              return DropdownMenuItem(
                                                value: value,
                                                child: value.bUSINESSNAME
                                                    .toString()
                                                    .text
                                                    .size(14.0.sp)
                                                    .make(),
                                              );
                                            }).toList(),
                                            onChanged: (var newValue) {
                                              SubUserdata subuserdata =
                                                  newValue as SubUserdata;
                                              newSetState(() {
                                                setState(() {
                                                  selectedSubMerchant =
                                                      subuserdata;
                                                  showSubmitBtnFlag = true;
                                                  // Navigator.pop(context);
                                                  // merchantselect(context);
                                                });
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            (showSubmitBtnFlag == true)
                                ? Container(
                                    child: Column(
                                    children: [
                                      VSpace(20),
                                      signInButton(context: context, saveButton,
                                          ref: () {
                                        setState(() {
                                          //save in shared pref key
                                          saveKeyValString(
                                              merchantIdPrefKey,
                                              selectedMerchant.pAYID
                                                  .toString());
                                          //save in shared pref key
                                          saveKeyValString(
                                              subMerchantIdPrefKey,
                                              selectedSubMerchant.pAYID
                                                  .toString());
                                          //save in shared pref key
                                          saveKeyValString(
                                              merchantNamePrefKey,
                                              selectedMerchant.bUSINESSNAME
                                                  .toString());
                                          //save in shared pref key
                                          saveKeyValString(
                                              subMerchantNamePrefKey,
                                              selectedSubMerchant.bUSINESSNAME
                                                  .toString());

                                          merchantID =
                                              selectedMerchant.pAYID.toString();
                                          merchantName = selectedMerchant
                                              .bUSINESSNAME
                                              .toString();
                                          subMerchantID = selectedSubMerchant
                                              .pAYID
                                              .toString();
                                          subMerchantName = selectedSubMerchant
                                              .bUSINESSNAME
                                              .toString();

                                          getPaymentOption(context);
                                        });

                                        Navigator.pop(context);
                                      }, onpressed: null),
                                    ],
                                  ))
                                : Container()
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }));
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // controller.jumpToPage(_selectedIndex);
    });
  }
}
