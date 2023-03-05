import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:letzpay/utils/colors.dart';
import 'package:letzpay/utils/strings.dart';
import 'package:velocity_x/velocity_x.dart';

CustomDialog(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      // elevation: 0.0,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              // backgroundColor: Colors.black87,
              content: dialogeView(context),
            ));

        // dialogeView(context);
      });
}

dialogeView(BuildContext context) {
  return Material(
    child: Container(
      width: 70.w,
      decoration: BoxDecoration(
        color: whiteMedLight,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(80.0),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: whiteMedLight,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: staticQr.text
                        .size(20.0.sp)
                        .bold
                        .color(Vx.hexToColor(balckMainColor))
                        .make(),
                  ), //
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceAround, //Center Row contents horizontally,
                  crossAxisAlignment: CrossAxisAlignment
                      .center, //Center Row contents vertically,

                  children: [
                    InkWell(
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.qr_code_2,
                              size: 70,
                              color: Vx.hexToColor(balckMainColor),
                            ),
                            pgQr.text.color(greyColor).size(18.0.sp).make(),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed('/Pgcode'); //redirect to Pgcode screen.
                      },
                    ),
                    Container(
                      color: Color.fromARGB(255, 176, 174, 174),
                      height: 100,
                      width: 1,
                    ),
                    InkWell(
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.qr_code_2,
                            size: 70,
                            color: Vx.hexToColor(balckMainColor),
                          ),
                          upiQr.text
                              .color(greyColor)
                              .center
                              .size(18.0.sp)
                              .make(),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            '/Upicode'); //redirect to upiCode screen.
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            left: 2.0,
            right: 0.0,
            bottom: 10.0,
            top: 0.0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Align(
                alignment: Alignment.topRight,
                child: Icon(
                  Icons.close,
                  color: Colors.grey,
                  size: 25,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
