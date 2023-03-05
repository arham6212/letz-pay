import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letzpay/utils/assets_path.dart';
import 'package:letzpay/utils/colors.dart';
import 'package:letzpay/utils/strings.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../common_components/common_widget.dart';

class ConfirmPage extends StatefulWidget {
  final String mobileNumber;
  const ConfirmPage({Key? key, required this.mobileNumber}) : super(key: key);

  @override
  State<ConfirmPage> createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // controller.jumpToPage(_selectedIndex);
    });
  }

  Future<bool> _onWillPop(context) async {
    if (_selectedIndex != 0) {
      _onItemTapped(0);
      return false;
    } else {
      Navigator.of(context)
          .popAndPushNamed('/login'); //redirect to login screen.
      return true;
    }
    // false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context)
              .popAndPushNamed('/login'); //redirect to login screen.
          return true;
        },
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: (Vx.hexToColor(balckMainColor)),
            body: Container(
                height: MediaQuery.of(context).size.height.h,
                margin: EdgeInsets.all(18.0.sp),
                padding: EdgeInsets.only(top: 150.0.h),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(confirmCheck),
                          VSpace(20.sp),
                          pinChanged.text
                              .color(Vx.hexToColor(whiteMainColor))
                              .size(24.sp)
                              .bold
                              .make(),
                          VSpace(10.sp),
                          pinSuccessStatment.text
                              .color(Vx.hexToColor(whiteMainColor))
                              .size(16.sp)
                              .make(),
                          VSpace(5.sp),
                        ],
                      ),
                      Column(
                        children: [
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: confirmation(context: context, signNow,
                                  ref: () {
                                Navigator.of(context).popAndPushNamed(
                                    '/login'); //redirect to login screen.
                              }, onpressed: null)),
                        ],
                      )
                    ],
                  ),
                ))));
  }
}
