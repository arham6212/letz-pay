import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:letzpay/common_functions/common_regex.dart';
import 'package:letzpay/common_components/common_widget.dart';
import 'package:letzpay/common_components/home_app_bar.dart';
import 'package:letzpay/common_functions/common_functions.dart';
import 'package:letzpay/services/network/api_services.dart';
import 'package:letzpay/services/network_services.dart';
import 'package:letzpay/services/shared_pref.dart';
import 'package:letzpay/utils/colors.dart';
import 'package:letzpay/utils/strings.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'dart:math' as math;

import '../../utils/assets_path.dart';

class AllPage extends StatefulWidget {
  AllPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<AllPage> createState() => _AllPageState();
}

class _AllPageState extends State<AllPage> {
  late final ValueChanged<String> onSubmit;
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController mobnumController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController invoiceController = TextEditingController();
  TextEditingController udfController = TextEditingController();
  TextEditingController udfController1 = TextEditingController();
  TextEditingController udfController2 = TextEditingController();
  TextEditingController udfController3 = TextEditingController();
  TextEditingController udfController4 = TextEditingController();
  TextEditingController udfController5 = TextEditingController();
  TextEditingController udfController6 = TextEditingController();
  TextEditingController udfController7 = TextEditingController();
  TextEditingController udfController8 = TextEditingController();
  TextEditingController udfController9 = TextEditingController();
  // final _text = TextEditingController();
  FocusNode currentFocus = FocusNode();
  late ApiService apiService;
  late var networkStatus;

  late String superMerchantFlag = "";
  late String superMerchantPayId = "";
  late String userType = "";
  late String businessName = "";
  late String merchantID = "";
  late String merchantName = "";
  late String subMerchantID = "";
  late String subMerchantName = "";

  bool visible = false;
  bool vis = false;
  bool vis1 = false;
  bool vis2 = false;
  bool vis3 = false;
  bool vis4 = false;
  bool vis5 = false;
  bool vis6 = false;
  bool vis7 = false;

  late double doubleVar = 0.0;
  var count = 0;

  @override
  void dispose() {
    udfController8.dispose();
    // _text.dispose();
    super.dispose();
  }

  late String _name;
  late String _email;
  late String _amount;
  late String _remark;
  late String _phoneNumber;
  late String _invoice;
  late GlobalKey<FormState> _formKey = new GlobalKey();
  late List<GlobalKey<FormFieldState>> fieldKeys;
  late GlobalKey<FormFieldState> nameKey;
  late GlobalKey<FormFieldState> emailKey;
  late GlobalKey<FormFieldState> amountKey;
  late GlobalKey<FormFieldState> remarkKey;
  late GlobalKey<FormFieldState> phoneNumberKey;
  late GlobalKey<FormFieldState> invoiceKey;
  @override
  void initState() {
    super.initState();
    nameKey = GlobalKey<FormFieldState>();
    emailKey = GlobalKey<FormFieldState>();
    amountKey = GlobalKey<FormFieldState>();
    remarkKey = GlobalKey<FormFieldState>();
    phoneNumberKey = GlobalKey<FormFieldState>();
    invoiceKey = GlobalKey<FormFieldState>();
    fieldKeys = [
      nameKey,
      emailKey,
      amountKey,
      remarkKey,
      phoneNumberKey,
      invoiceKey,
    ];

//For testing we create invoiceID as below... change it when we go live
    var _chars =
        "LetzPayInv" + DateTime.now().millisecondsSinceEpoch.toString();
    Random _rnd = Random();
    invoiceController.text = String.fromCharCodes(Iterable.generate(
        15, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
//For testing we create invoiceID as above

    apiService = ApiService();

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
  }

  bool validate() {
    return fieldKeys.every((element) => element.currentState!.validate());
  }

  void save() {
    for (var element in fieldKeys) {
      element.currentState!.save();
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    networkStatus = Provider.of<NetworkStatus>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: buildHomeAppBar(
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Image.asset(blackArrow)),
        title: getTransText(widget.title)
            .toString()
            .replaceAll("_", " ")
            .text
            .color(Vx.hexToColor(balckMainColor))
            .bold
            .make(),
      ),
      body: SafeArea(
        child: Form(
          // autovalidateMode: AutovalidateMode.always,
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              color: Vx.hexToColor(whiteMainColor),
              // width: 335.w,
              child: Padding(
                padding:
                    EdgeInsets.only(top: 20.0.h, left: 16.0.w, right: 16.0.w),
                //.only(top: 20.0.h, left: 24.w, right: 16.0.w),
                // padding: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customtextfeild(
                      textInputAction: TextInputAction.go,
                      key: nameKey,
                      labelText: nameTittle,

                      Controller: nameController,
                      keyboardType: TextInputType.name,
                      //  errorText: _errorText, // Handling error manually,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(50),
                        FilteringTextInputFormatter.allow(
                          RegExp(r"[a-zA-Z]+|\s"),
                        )
                      ],

                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return nameValidate;
                        }
                        if (text.length < 4) {
                          return toShort;
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        _name = value;
                      },
                    ),
                    VSpace(10),
                    customtextfeild(
                      key: amountKey,
                      labelText: amountTittle,
                      Controller: amountController,

                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      // onChanged: (value) => setState(() {
                      //   doubleVar = double.parse(value);
                      // }),

                      inputFormatters: [
                        LengthLimitingTextInputFormatter(6),
                        DecimalTextInputFormatter(decimalRange: 2),
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}')),
                      ],

                      // The validator receives the text that the user has entered.
                      validator: (input) {
                        // if (input!.isEmpty) return cantbeempty;
                        if (input!.isEmpty) {
                          return amountValidate;
                        } else if (double.parse(input).toInt() <= 0) {
                          return "Amount should be greater than 0";
                        }

                        final isDigitsOnly = double.tryParse(input);
                        return isDigitsOnly == null ? digitOnly : null;
                      },
                      onSaved: (String input) {
                        _amount = input;
                      },
                    ),
                    VSpace(10),
                    customtextfeild(
                      key: phoneNumberKey,
                      labelText: mobileTittle,
                      Controller: mobnumController,
                      keyboardType: TextInputType.numberWithOptions(
                        signed: true,
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.allow(
                          RegExp(r"[0-9]"),
                        )
                      ],
                      validator: (value) {
                        if (value!.isEmpty) return mobnoValidate;
                        String mobile = mobnumController.text.trim();
                        if (mobile.isEmpty) {
                          return enterMobile;
                        } else if (mobile.length < 10) {
                          return enterMobileProp;
                        } else {
                          return null;
                        }
                      },
                      onSaved: (String value) {
                        _phoneNumber = value;
                      },
                    ),
                    VSpace(10),
                    customtextfeild(
                      // key: emailKey,
                      labelText: emailTittle,
                      Controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(60),
                      ],
                      validator: (value) {
                        if (value.isEmptyOrNull) {
                          return emailValidate;
                        } else if (isEmailValid(value!)) {
                          return null;
                        } else {
                          return emailAddressError;
                        }
                      },
                    ),
                    VSpace(10),
                    customtextfeild(
                      Controller: remarkController,
                      onSaved: (String value) {},
                      labelText: remarkTittle,
                      key: remarkKey,
                    ),
                    VSpace(10),
                    customtextfeildreadonly(
                      Controller: invoiceController,
                      key: invoiceKey,
                      labelText: invoiceTittle,
                      validator: (value) {
                        if (value!.isEmpty) return cantbeempty;
                      },
                      // onSaved: (value) { Umesh will check later what is the exact use of this function
                      //   showToastMsg("true $value");
                      // },
                    ),
                    VSpace(10),
                    Visibility(
                        visible: visible, child: UDIfeild(1, udfController)),
                    Visibility(
                        visible: vis, child: UDIfeild(2, udfController1)),
                    Visibility(
                        visible: vis1, child: UDIfeild(3, udfController2)),
                    Visibility(
                        visible: vis2,
                        child: UDIfeild(
                          4,
                          udfController3,
                        )),
                    Visibility(
                        visible: vis3, child: UDIfeild(5, udfController4)),
                    Visibility(
                        visible: vis4, child: UDIfeild(6, udfController5)),
                    Visibility(
                        visible: vis5, child: UDIfeild(7, udfController6)),
                    Visibility(
                        visible: vis6, child: UDIfeild(8, udfController7)),
                    VSpace(10.sp),
                    vis6 == true
                        ? Container()
                        : Container(
                            margin: EdgeInsets.only(left: 10.0.w),
                            child: FloatingActionButton.extended(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                              backgroundColor: Vx.hexToColor(whiteMainColor),
                              onPressed: () {
                                setState(() {
                                  // count++;
                                  if (visible == false) {
                                    visible = true;
                                  } else if (vis == false) {
                                    vis = true;
                                  } else if (vis1 == false) {
                                    vis1 = true;
                                  } else if (vis2 == false) {
                                    vis2 = true;
                                  } else if (vis3 == false) {
                                    vis3 = true;
                                  } else if (vis4 == false) {
                                    vis4 = true;
                                  } else if (vis5 == false) {
                                    vis5 = true;
                                  } else if (vis6 == false) {
                                    vis6 = true;
                                  }
                                });
                              },
                              icon: Icon(
                                Icons.add_circle,
                                color: Vx.hexToColor(floaticonGrey),
                              ),
                              label: udfLbl.text
                                  .color(Vx.hexToColor(blackprofilecolor))
                                  .make(),
                            ),
                          ),
                    VSpace(20),
                    /* formbutton(context: context, proccesButton, ref: () {
                      final formstate = _formKey.currentState;
                      if (formstate!.validate()) {
                        validateForm();
                      }
                    }, onpressed: null), */

                    signInButton(context: context, proccesButton, ref: () {
                      final formstate = _formKey.currentState;
                      if (formstate!.validate()) {
                        validateForm();
                      }
                    }, onpressed: null),
                    VSpace(10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget UDIfeild(int count, controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customtextfeild(
          labelText: 'UDF $count',
          Controller: controller,
        )
      ],
    );
  }

  //submit form according to user type for payment option
  void submitForEPosSale(BuildContext context) async {
    Response response;
    try {
      late var params;
      //  = {
      //   "MOBILE_NUMBER": await getStringVal("mobileNumber"),
      //   "INVOICE_ID": invoiceController.text.toString(),
      //   "EPOS_PAYMENT_OPTION": widget.title,
      //   "CUST_EMAIL": emailController.text.toString(),
      //   "CUST_MOBILE": mobnumController.text.toString(),
      //   "AMOUNT": convertAmountTwoDecimal(amountController.text.toString()),
      //   "NAME": nameController.text.toString(),
      //   "REMARKS": remarkController.text.toString(),
      //   "UDF11": udfController.text.toString(),
      //   "UDF12": udfController1.text.toString(),
      //   "UDF13": udfController2.text.toString(),
      //   "UDF14": udfController3.text.toString(),
      //   "UDF15": udfController4.text.toString(),
      //   "UDF16": udfController5.text.toString(),
      //   "UDF17": udfController6.text.toString(),
      //   "UDF18": udfController7.text.toString()
      // };

      if (userType.toString() == "RESELLER") {
        params = {
          "PAY_ID": merchantID,
          "MOBILE_NUMBER": await getStringVal("mobileNumber"),
          "INVOICE_ID": invoiceController.text.toString(),
          "EPOS_PAYMENT_OPTION": widget.title,
          "CUST_EMAIL": emailController.text.toString(),
          "CUST_MOBILE": mobnumController.text.toString(),
          "AMOUNT": convertAmountTwoDecimal(amountController.text.toString()),
          "NAME": nameController.text.toString(),
          "REMARKS": remarkController.text.toString(),
          "UDF11": udfController.text.toString(),
          "UDF12": udfController1.text.toString(),
          "UDF13": udfController2.text.toString(),
          "UDF14": udfController3.text.toString(),
          "UDF15": udfController4.text.toString(),
          "UDF16": udfController5.text.toString(),
          "UDF17": udfController6.text.toString(),
          "UDF18": udfController7.text.toString()
        };
      } else if (userType.toString() == "MERCHANT" &&
          subMerchantID.toString().isNotEmpty) {
        // if (superMerchantPayId.toString().isNotEmpty) {
        //   getSubMerchantList(context, superMerchantPayId.toString());
        // }

        params = {
          "PAY_ID": subMerchantID,
          "MOBILE_NUMBER": await getStringVal("mobileNumber"),
          "INVOICE_ID": invoiceController.text.toString(),
          "EPOS_PAYMENT_OPTION": widget.title,
          "CUST_EMAIL": emailController.text.toString(),
          "CUST_MOBILE": mobnumController.text.toString(),
          "AMOUNT": convertAmountTwoDecimal(amountController.text.toString()),
          "NAME": nameController.text.toString(),
          "REMARKS": remarkController.text.toString(),
          "UDF11": udfController.text.toString(),
          "UDF12": udfController1.text.toString(),
          "UDF13": udfController2.text.toString(),
          "UDF14": udfController3.text.toString(),
          "UDF15": udfController4.text.toString(),
          "UDF16": udfController5.text.toString(),
          "UDF17": udfController6.text.toString(),
          "UDF18": udfController7.text.toString()
        };
      } else {
        params = {
          "MOBILE_NUMBER": await getStringVal("mobileNumber"),
          "INVOICE_ID": invoiceController.text.toString(),
          "EPOS_PAYMENT_OPTION": widget.title,
          "CUST_EMAIL": emailController.text.toString(),
          "CUST_MOBILE": mobnumController.text.toString(),
          "AMOUNT": convertAmountTwoDecimal(amountController.text.toString()),
          "NAME": nameController.text.toString(),
          "REMARKS": remarkController.text.toString(),
          "UDF11": udfController.text.toString(),
          "UDF12": udfController1.text.toString(),
          "UDF13": udfController2.text.toString(),
          "UDF14": udfController3.text.toString(),
          "UDF15": udfController4.text.toString(),
          "UDF16": udfController5.text.toString(),
          "UDF17": udfController6.text.toString(),
          "UDF18": udfController7.text.toString()
        };
      }

      response = await apiService.getEposSale(
          params, context); //API call for getting epos sale payment option

      if (response.statusCode == 200) {
        setState(() {
          if (response.data['RESPONSE_CODE'] == "000") {
            if (widget.title == "PG_QR") {
              Navigator.of(context).pushReplacementNamed('/qrcode', arguments: {
                "qr_code": response.data["PG_QR_CODE"]
              }); //redirect to QRCode  screen.
            } else {
              Navigator.of(context)
                  .pushReplacementNamed('/succestrasaction', arguments: {
                "invoice": invoiceController.text.toString(),
                "amount": convertAmountTwoDecimal(
                  amountController.text.toString(),
                ),
                "mComingFrom": "FormPage"
              }); //redirect to successTransaction screen.
              // showToastMsg(response.data['RESPONSE_MESSAGE']);

            }
          } else {
            showPopUpDialog(
                errorpop, response.data['RESPONSE_MESSAGE'], context);
            // showToastMsg(response.data['RESPONSE_MESSAGE']);
          }
        });
      } else {
        showPopUpDialog(errorpop, errorSomeWrong, context);
        //  showToastMsg("error found");
      }
    } on Exception catch (e) {
      showPopUpDialog(errorpop, e.toString(), context);
      //  showToastMsg(e.toString());
    }
  }

  //submit form according to user type for payment option UPI QR
  void submitForUpiQrSale(BuildContext context) async {
    Response response;
    try {
      late var params;
      // = {
      //   "INVOICE_ID": invoiceController.text.toString(),
      //   "EPOS_PAYMENT_OPTION": widget.title,
      //   "CUST_EMAIL": emailController.text.toString(),
      //   "CUST_MOBILE": mobnumController.text.toString(),
      //   "AMOUNT": convertAmountTwoDecimal(amountController.text.toString()),
      //   "NAME": nameController.text.toString(),
      //   "REMARKS": remarkController.text.toString(),
      //   "MOBILE_NUMBER": await getStringVal("mobileNumber"),
      //   "UDF11": udfController.text.toString(),
      //   "UDF12": udfController1.text.toString(),
      //   "UDF13": udfController2.text.toString(),
      //   "UDF14": udfController3.text.toString(),
      //   "UDF15": udfController4.text.toString(),
      //   "UDF16": udfController5.text.toString(),
      //   "UDF17": udfController6.text.toString(),
      //   "UDF18": udfController7.text.toString()
      // };

      if (userType.toString() == "RESELLER") {
        params = {
          "PAY_ID": merchantID,
          "INVOICE_ID": invoiceController.text.toString(),
          "EPOS_PAYMENT_OPTION": widget.title,
          "CUST_EMAIL": emailController.text.toString(),
          "CUST_MOBILE": mobnumController.text.toString(),
          "AMOUNT": convertAmountTwoDecimal(amountController.text.toString()),
          "NAME": nameController.text.toString(),
          "REMARKS": remarkController.text.toString(),
          "MOBILE_NUMBER": await getStringVal("mobileNumber"),
          "UDF11": udfController.text.toString(),
          "UDF12": udfController1.text.toString(),
          "UDF13": udfController2.text.toString(),
          "UDF14": udfController3.text.toString(),
          "UDF15": udfController4.text.toString(),
          "UDF16": udfController5.text.toString(),
          "UDF17": udfController6.text.toString(),
          "UDF18": udfController7.text.toString()
        };
      } else if (userType.toString() == "MERCHANT" &&
          subMerchantID.toString().isNotEmpty) {
        // if (superMerchantPayId.toString().isNotEmpty) {
        //   getSubMerchantList(context, superMerchantPayId.toString());
        // }
        params = {
          "PAY_ID": subMerchantID,
          "INVOICE_ID": invoiceController.text.toString(),
          "EPOS_PAYMENT_OPTION": widget.title,
          "CUST_EMAIL": emailController.text.toString(),
          "CUST_MOBILE": mobnumController.text.toString(),
          "AMOUNT": convertAmountTwoDecimal(amountController.text.toString()),
          "NAME": nameController.text.toString(),
          "REMARKS": remarkController.text.toString(),
          "MOBILE_NUMBER": await getStringVal("mobileNumber"),
          "UDF11": udfController.text.toString(),
          "UDF12": udfController1.text.toString(),
          "UDF13": udfController2.text.toString(),
          "UDF14": udfController3.text.toString(),
          "UDF15": udfController4.text.toString(),
          "UDF16": udfController5.text.toString(),
          "UDF17": udfController6.text.toString(),
          "UDF18": udfController7.text.toString()
        };
      } else {
        params = {
          "INVOICE_ID": invoiceController.text.toString(),
          "EPOS_PAYMENT_OPTION": widget.title,
          "CUST_EMAIL": emailController.text.toString(),
          "CUST_MOBILE": mobnumController.text.toString(),
          "AMOUNT": convertAmountTwoDecimal(amountController.text.toString()),
          "NAME": nameController.text.toString(),
          "REMARKS": remarkController.text.toString(),
          "MOBILE_NUMBER": await getStringVal("mobileNumber"),
          "UDF11": udfController.text.toString(),
          "UDF12": udfController1.text.toString(),
          "UDF13": udfController2.text.toString(),
          "UDF14": udfController3.text.toString(),
          "UDF15": udfController4.text.toString(),
          "UDF16": udfController5.text.toString(),
          "UDF17": udfController6.text.toString(),
          "UDF18": udfController7.text.toString()
        };
      }

      response = await apiService.getUpiQrSale(
          params, context); ////API call for get UPI QR code

      if (response.statusCode == 200) {
        setState(() {
          if (response.data['RESPONSE_CODE'] == "000") {
            if (response.data['UPI_QR_CODE'].toString().isEmptyOrNull ||
                response.data['UPI_QR_CODE'] == null ||
                response.data['UPI_QR_CODE'].toString() == "null") {
              showPopUpDialog(errorpop, errorSomeWrong, context);

              //  showToastMsg(errorSomeWrong);
            } else {
              Navigator.of(context).pushNamed('/qrcode',
                  arguments: {"qr_code": response.data["UPI_QR_CODE"]});
            }
          } else {
            showPopUpDialog(
                errorpop, response.data['RESPONSE_MESSAGE'], context);
            // showToastMsg(response.data['RESPONSE_MESSAGE']);
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

  void validateForm() {
    // if (nameController.text.toString().isEmptyOrNull) {
    //   showToastMsg(errorNameEmpty);
    // } else if (amountController.text.toString().isEmptyOrNull) {
    //   showToastMsg(errorAmountEmpty);
    // } else if (double.parse(amountController.text.toString()) < 10) {
    //   showToastMsg(errorValidAmount);
    // } else if (mobnumController.text.toString().isEmptyOrNull) {
    //   showToastMsg(errorMobileEmpty);
    // } else if (mobnumController.text.toString().length < 10) {
    //   showToastMsg(errorValidMobile);
    // } else if (emailController.text.toString().isEmptyOrNull) {
    //   showToastMsg(errorEmailEmpty);
    // } else if (!isEmailValid(emailController.text.toString())) {
    //   showToastMsg(errorValidEmail);
    // } else if (invoiceController.text.toString().isEmptyOrNull) {
    //   showToastMsg(errorInvoiceEmpty);
    // } else
    if (networkStatus == NetworkStatus.offline) {
      showPopUpDialog(errorpop, errorNoInternet, context);
      // showToastMsg(errorNoInternet);
    } else {
      if (widget.title == "UPI_QR") {
        submitForUpiQrSale(context);
      } else {
        submitForEPosSale(context);
      }

      //showPopUpDialog("procced", "succces", context);

    }
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange == 10 || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }

  floatbutton() {}
}
