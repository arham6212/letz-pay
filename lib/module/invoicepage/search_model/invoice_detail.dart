import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:letzpay/common_functions/common_regex.dart';

import 'package:letzpay/common_components/home_app_bar.dart';
import 'package:letzpay/utils/assets_path.dart';

import 'package:letzpay/utils/colors.dart';
import 'package:letzpay/utils/strings.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../common_components/common_widget.dart';
import '../../../services/network/api_services.dart';
import '../../../services/shared_pref.dart';
import '../Search _invoice_module/invoiceresponse.dart';

class InvoiceDetails extends StatefulWidget {
  const InvoiceDetails({Key? key}) : super(key: key);

  @override
  State<InvoiceDetails> createState() => _InvoiceDetailsState();
}

class _InvoiceDetailsState extends State<InvoiceDetails> {
  late ApiService apiService;
  late List<InvoceData> invoiceData;
  late Invoiceresponse invoiceresponse;

  late GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController mobileController = TextEditingController(text: "");
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController invoiceController = TextEditingController(text: "");
  // late String _mobileNumber

  late bool invDetailsFlag = false;

  @override
  void setState(fn) {
    //this method is call for avoid memory leak issue.
    if (mounted) {
      super.setState(fn);
    }
  }

  //This function display invoice list according without filter or with filter
  Future invoiceDetails(var context) async {
    Response response;
    setState(() {
      invDetailsFlag = true;
      invoiceData = <InvoceData>[];
    });
    try {
      var params = {
        "MOBILE_NUMBER": await getStringVal("mobileNumber"),
        "INVOICE_ID": invoiceController.text.toString(),
        "CUST_MOBILE": mobileController.text.toString(),
        "CUST_EMAIL": emailController.text.toString()
      };

      response = await apiService.invoiceDetails(
          params, context); //API call for invoice list according to params

      if (response.statusCode == 200) {
        //on success of API
        setState(() {
          invoiceresponse = Invoiceresponse.fromJson(response.data);
          if (invoiceresponse.iNVOICEDATA != null) {
            json.decode(invoiceresponse.iNVOICEDATA.toString()).forEach((v) {
              invoiceData.add(InvoceData.fromJson(v));
            });
          }
          invDetailsFlag = false;
        });
      } else {
        showPopUpDialog(errorpop, errorSomeWrong, context);
        // showToastMsg("error found");
        setState(() {
          invDetailsFlag = false;
        });
      }
    } on Exception catch (e) {
      showPopUpDialog(errorpop, e.toString(), context);
      // showToastMsg(e.toString());
      setState(() {
        invDetailsFlag = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    invoiceresponse = Invoiceresponse();
    invoiceData = <InvoceData>[];
    invoiceDetails(context);
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
        title: invoiceLbl.text.size(32).bold.color(white).make(),
      ),
//       appBar: buildHomeAppBar(
//         leading: InkWell(
//             onTap: () {
//               Navigator.of(context).pushNamed('/fhome');
//             },
//             child: Image.asset(blackArrow)),

//         title: invoiceLbl.text
//             .size(32.sp)
//             .bold
//             .color(Vx.hexToColor(balckMainColor))
//             .make(),

//         //As suggested by LetzPay; VizPay Business Solution Pvt Ltd will show half page for filter option & will show list of invoices on remaining page also will removed filter function with icon from toolbar
// // LetzPay will provide new ui idea for invoice details list
//         // actions: [
//         //   Padding(
//         //     padding: const EdgeInsets.only(right: 15.0),
//         //     child: GestureDetector(
//         //       child: Icon(
//         //         Icons.search,
//         //         color: white,
//         //       ),
//         //       onTap: (() =>
//         //           Navigator.of(context).pushReplacementNamed('/Invoicsearch')),
//         //     ),
//         //   ),
//         // ],
//       ),

      //backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  color: Vx.hexToColor(blackColor),
                  padding: EdgeInsets.all(22),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // invoiceLbl.text.size(32).bold.color(white).make(),
                      // VSpace(16.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            //  color: white,
                            width: (MediaQuery.of(context).size.width / 2) -
                                30.0.w,
                            decoration: BoxDecoration(
                              color: Vx.hexToColor(whiteMainColor),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            child: customtextfeildInvoice(
                              Controller: mobileController,
                              // labelText: mobileTittle,
                              HintText: mobileTittle,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                                FilteringTextInputFormatter.allow(
                                  RegExp(r"[0-9]"),
                                )
                              ],
                              validator: (value) {
                                if (!value.isEmptyOrNull &&
                                    value.toString().length < 10) {
                                  return enterMobileProp;
                                }
                              },
                            ),
                          ),
                          HSpace(12.w),
                          Container(
                            width: (MediaQuery.of(context).size.width / 2) - 30,
                            decoration: BoxDecoration(
                              color: Vx.hexToColor(whiteMainColor),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            child: customtextfeildInvoice(
                              HintText: invoiceTittle,
                              Controller: invoiceController,
                              //  labelText: invoiceTittle
                            ),
                          )
                        ],
                      ),
                      VSpace(16.h),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        //   margin: EdgeInsets.all(0),
                        // padding: const EdgeInsets.symmetric(
                        //   horizontal: 6.0,
                        // ),
                        decoration: BoxDecoration(
                          color: Vx.hexToColor(whiteMainColor),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                        ),
                        child: customtextfeildInvoice(
                          HintText: emailTittle,
                          // key: emailKey,
                          // labelText: emailTittle,
                          Controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(60),
                          ],

                          validator: (value) {
                            if (!value.isEmptyOrNull &&
                                !isEmailValid(value.toString())) {
                              return emailAddressError;
                            }
                          },
                        ),
                      ),
                      VSpace(20.h),
                      Container(
                        child: confirmation(
                          context: context,
                          searchButton,
                          onpressed: null,
                          ref: () {
                            setState(() {
                              fieldValidation();
                              FocusScope.of(context).requestFocus(FocusNode());
                              // final formstate = _formKey.currentState;
                              // if (formstate!.validate()) {

                              // }
                            });
                          },
                        ),
                      ),
                      VSpace(10.h.sp),
                    ],
                  )),

              // formbutton(
              //   context: context,
              //   searchButton,
              //   onpressed: null,
              //   ref: () {
              //     setState(() {
              //       final formstate = _formKey.currentState;
              //       if (formstate!.validate()) {
              //         fieldValidation();
              //       }
              //     });
              //   },
              // ),
              invoiceData.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          VSpace(25),
                          Image.asset(
                            noDataIcon,
                            width: 100,
                            height: 100,
                          ),
                          errorNoDataAvailable.text.size(16).make()
                        ],
                      ),
                    )
                  : Container(
                      child: Expanded(
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: invoiceData.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _invoicelistWidget(
                                  invoiceData[index], index);
                            }),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void fieldValidation() {
    // if want all the validation including empty
    if (mobileController.text.isEmptyOrNull &&
        emailController.text.isEmptyOrNull &&
        invoiceController.text.isEmptyOrNull) {
      showPopUpDialog(errorpop, emptyfeild, context);
      //showToastMsg("Please enter required data");
    } else if (!emailController.text.isEmptyOrNull &&
        !isEmailValid(emailController.text)) {
      showPopUpDialog(errorpop, emailAddressError, context);
      //  showToastMsg(emailAddressError);
    } else if (!mobileController.text.isEmptyOrNull &&
        mobileController.text.length < 10) {
      showPopUpDialog(errorpop, enterMobileProp, context);
      // showToastMsg(enterMobileProp);
    } else {
      invoiceDetails(context);
    }

    //invoiceDetails(context);
  }
}

//Invoice listItem view
Widget _invoicelistWidget(InvoceData invoice, int position) {
  return Container(
    color: Vx.hexToColor(whiteMainColor),
    margin: EdgeInsets.all(0.sp),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(children: [
        // VSpace(10.0),
        position == 0 ? VSpace(15.0) : Container(),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            invoiceId.text
                .size(16.0.sp)
                .color(Vx.hexToColor(balckMainColor))
                .bold
                .make(),
            invoice.iNVOICEID
                .toString()
                .text
                .size(12.0.sp)
                .color(Vx.hexToColor(balckMainColor))
                .make(),
          ],
        ),
        VSpace(5.0.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            date.text
                .size(16.0.sp)
                .color(Vx.hexToColor(balckMainColor))
                .bold
                .make(),
            invoice.cREATEDATE
                .toString()
                .text
                .size(12.0.sp)
                .color(Vx.hexToColor(balckMainColor))
                .make(),
          ],
        ),
        VSpace(5.0.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            phone.text
                .size(16.0.sp)
                .color(Vx.hexToColor(balckMainColor))
                .bold
                .make(),
            invoice.cUSTMOBILE
                .toString()
                .text
                .size(12.0.sp)
                .color(Vx.hexToColor(balckMainColor))
                .make(),
          ],
        ),
        VSpace(5.0.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            amount.text
                .size(16.0.sp)
                .color(Vx.hexToColor(balckMainColor))
                .bold
                .make(),
            invoice.aMOUNT
                .toString()
                .text
                .size(12.0.sp)
                .color(Vx.hexToColor(balckMainColor))
                .make(),
          ],
        ),
        VSpace(5.0.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            status.text
                .size(16.0.sp)
                .color(Vx.hexToColor(balckMainColor))
                .bold
                .make(),
            invoice.sTATUS
                .toString()
                .text
                .size(12.0.sp)
                .color(Vx.hexToColor(balckMainColor))
                .make(),
          ],
        ),
        VSpace(5.0.h),
        Row(
          //crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            custName.text
                .size(16.0.sp)
                .color(Vx.hexToColor(balckMainColor))
                .bold
                .make(),
            SizedBox(
              width: 60.w,
              child: invoice.cUSTNAME
                  .toString()
                  .text
                  .softWrap(false)
                  .align(TextAlign.end)
                  .maxLines(1)
                  .overflow(TextOverflow.ellipsis)
                  .size(12.0.sp)
                  .color(Vx.hexToColor(balckMainColor))
                  .make(),
            ),
          ],
        ),
        VSpace(5.0.h),
        Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            remarks.text
                .size(16.0.sp)
                .color(Vx.hexToColor(balckMainColor))
                .bold
                .make(),
            SizedBox(
              width: 100.w,
              child: (invoice.rEMARKS
                  .toString()
                  .text
                  .size(12.0.sp)
                  .softWrap(false)
                  .align(TextAlign.end)
                  .maxLines(1)
                  .overflow(TextOverflow.ellipsis)
                  .color(Vx.hexToColor(balckMainColor))
                  .bold
                  .make()),
            )
          ],
        ),
        VSpace(5.0.h),
        Divider(),
      ]),
    ),
  );
}
