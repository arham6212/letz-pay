import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:letzpay/common_components/common_widget.dart';
import 'package:letzpay/module/analytics/report_chart_page/report_module/response_request_option.dart';
import 'package:letzpay/module/payment_form/payment_form_module/responspayment.dart';
import 'package:letzpay/services/network/api_services.dart';

import 'package:letzpay/utils/colors.dart';
import 'package:letzpay/utils/strings.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common_functions/common_functions.dart';

import '../qr_payment_dailouge/qrcode_modal/qr_dailouge.dart';

class GridPage extends StatefulWidget {
  List<PaymentOptionData> paymentOptionData;
  GridPage(this.paymentOptionData);

  @override
  State<GridPage> createState() => _GridPageState();
}

class _GridPageState extends State<GridPage> {
  late ApiService apiService;

  late PaymentResponse paymentResponse;
  @override
  void initState() {
    //paymentResponse = PaymentResponse();
    //apiService = ApiService();

    super.initState();
  }

//payment option list item view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Grid Example"),
      // ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.paymentOptionData.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 18.0.w,
          mainAxisSpacing: 22.0.h,
          childAspectRatio: 83.0.w / 123.0.h,
        ),
        itemBuilder: (
          context,
          index,
        ) {
          return GestureDetector(
              onTap: () {
                // navigateTo(choices[index].title, context);
                navigateTo(
                    widget.paymentOptionData[index].pAYMENTOPTIONS.toString(),
                    context);
              },
              child: Column(
                children: [
                  Container(
                    width: 56.w,
                    height: 56.h,
                    padding: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(56)),
                      color: Vx.hexToColor(softGrey),
                    ),
                    child: SvgPicture.asset(
                        getTransIcon(widget
                            .paymentOptionData[index].pAYMENTOPTIONS
                            .toString()),
                        color: Vx.hexToColor(balckMainColor),
                        width: 24.0.w,
                        height: 24.0.h,
                        fit: BoxFit.scaleDown),
                  ),
                  VSpace(8.0.h),
                  Flexible(
                    child: Text(
                      getTransText(widget
                          .paymentOptionData[index].pAYMENTOPTIONS
                          .toString()
                          .replaceAll("_", " ")),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.0.sp,
                        fontWeight: FontWeight.bold,
                        color: Vx.hexToColor(balckMainColor),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  //  VSpace(12.0.h),
                ],
              ));
        },
      ),
    );
  }

  Alltext(var title) {
    return Center(
      child: Text(title,
          style: TextStyle(fontSize: 18.0.sp, color: Colors.black),
          textAlign: TextAlign.center),
    );
  }

  // alltext() {
  //   return Text(choices[index].title,
  //       style: TextStyle(fontSize: 12, color: Vx.hexToColor(darkblue)),
  //       textAlign: TextAlign.center);
  // }

  void navigateTo(String title, BuildContext context) async {
    if (title == staticQr || title == staticPgQr) {
      CustomDialog(context);
    } else {
      var result = await Navigator.of(context).pushNamed('/allpage',
          arguments: {"title": title}); //redirect to AllPage screen.
      if (result != null) {
        print('=====>>>>>$result');
      }
    }
  }
}
