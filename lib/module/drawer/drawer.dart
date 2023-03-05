import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letzpay/common_components/common_widget.dart';
import 'package:letzpay/main.dart';
import 'package:letzpay/module/t&c/term_condition.dart';

import 'package:letzpay/common_components/loading_screen.dart';
import 'package:letzpay/module/changepin/change_pin.dart';
import 'package:letzpay/module/loignhistory/log_history_page/log_histort_list.dart';
import 'package:letzpay/module/profile/profile_modal/profile_page.dart';
import 'package:letzpay/services/network_services.dart';
import 'package:letzpay/services/shared_pref.dart';

import 'package:letzpay/utils/assets_path.dart';
import 'package:letzpay/utils/strings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:letzpay/module/drawer/drawer_data.dart';
import 'package:letzpay/services/authentication_service.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:letzpay/utils/theme.dart';

import 'package:open_mail_app/open_mail_app.dart';

import '../../utils/colors.dart';

class DrawerList extends StatefulWidget {
  //drawer option screen.
  GlobalKey<ScaffoldState>? scaffoldKey;
  DrawerList({Key? key, this.scaffoldKey}) : super(key: key);

  @override
  State<DrawerList> createState() => _DrawerListState();
}

class _DrawerListState extends State<DrawerList> {
  final NavigationService _navigationService = locator<NavigationService>();
  List<DrawerDataModal> drawerMenuList = <DrawerDataModal>[];
  final TextEditingController _numberCtrl = TextEditingController();
  bool _visible = true;
  bool _isExpanded = false;
  String drawerimg = drawererror;
  final divider = const Divider(
    color: Colors.black,
  );

  @override
  void setState(fn) {
    //this method is call for avoid memory leak issue.
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    _visible = true;
    _numberCtrl.text = "012345678";
    LoadingScreen();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              shrinkWrap: true,
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                const DrawerHeader(
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(backgroundCardImage),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.cancel,
                      color: black,
                    ),
                  ),
                ),
                ListTile(
                  leading: drawericon(drawerProfile),
                  title: drawerLbl(myProfile),
                  onTap: () {
                    Navigator.of(context).popAndPushNamed(
                        '/profilescreen'); //redirect to profile screen.
                  },
                  trailing:
                      InkWell(onTap: () {}, child: Image.asset(drawererror)),
                ),
                ListTile(
                  leading: drawericon(drawerLoginHistory),
                  trailing:
                      InkWell(onTap: () {}, child: Image.asset(drawererror)),
                  title: drawerLbl(loginHistoryLbl),
                  onTap: () {
                    Navigator.of(context).popAndPushNamed(
                        '/loginhistory'); //redirect to login History screen.
                  },
                ),
                ListTile(
                  leading: drawericon(drawerChangePin),
                  trailing:
                      InkWell(onTap: () {}, child: Image.asset(drawererror)),
                  title: drawerLbl(changePin),
                  onTap: () {
                    Navigator.of(context).popAndPushNamed(
                        '/changepage'); //redirect to changepin screen.
                  },
                ),
                ListTile(
                  leading: drawericon(drawerTermCondition),
                  trailing:
                      InkWell(onTap: () {}, child: Image.asset(drawererror)),
                  title: drawerLbl(termAndCondition),
                  onTap: () {
                    Navigator.of(context).popAndPushNamed(
                        '/termNdCondition'); //redirect to term and condition screen.
                  },
                ),
                ListTile(
                  leading: drawericon(drawerPravicyPolicy),
                  trailing:
                      InkWell(onTap: () {}, child: Image.asset(drawererror)),
                  title: drawerLbl(privacyPolicy),
                  onTap: () {
                    Navigator.of(context).popAndPushNamed(
                        '/privacyPolicy'); //redirect to privacyPolicy screen.
                  },
                ),
                ExpansionTile(
                  leading: drawericon(drawerSupport),
                  title: drawerLbl(suppport),

                  // null if expanded, will using default arrow
                  trailing: _isExpanded
                      ? Icon(
                          Icons.expand_more,
                          size: 25,
                          color: Vx.hexToColor(balckMainColor),
                        )
                      : Image.asset(drawerimg),
                  children: <Widget>[
                    ListTile(
                      leading: drawericon(phoneIcon),
                      title: drawerLbl('0123456789'),
                      onTap: () async {
                        FlutterPhoneDirectCaller.callNumber(_numberCtrl.text);
                      },
                    ),
                    ListTile(
                        onTap: () async {
                          String email =
                              Uri.encodeComponent("Support@letzpay.com");
                          String subject = Uri.encodeComponent("");
                          String body = Uri.encodeComponent("");
                          print(subject); //output: Hello%20Flutter
                          Uri mail = Uri.parse(""
                              "mailto:$email?subject=$subject&body=$body");
                          if (await launchUrl(mail)) {
                            //email app opened
                          } else {
                            //email app is not opened
                          }
                        },
                        leading: drawericon(useremailIcon),
                        title: drawerLbl('Support@letpay.com')),
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => _isExpanded = expanded);
                  },
                ),
                InkWell(
                  onTap: (() {
                    // if (widget.scaffoldKey!.currentState!.isDrawerOpen) {
                    //   widget.scaffoldKey!.currentState!.closeDrawer();
                    showPopUpDialogClose(rYoulogOutLbl, wantLogoutLbl, context,
                        refYes: () {
                      _navigationService.clearAllAndNavigatorTo("/login");
                      // AuthenticationProvider.of(context).logout();
                      // // prefs.clear();

                      // Navigator.of(context).pop(false);
                    }, refNo: () {
                      Navigator.of(context).pop(false);
                    });
                    // } else {
                    //   showPopUpDialogClose(
                    //       rYoulogOutLbl, wantLogoutLbl, context);
                    // }
                  }),
                  child: ListTile(
                    title: logout.text.center
                        .size(14.0.sp)
                        .fontWeight(FontWeight.w700)
                        .color(Vx.hexToColor(redcolor))
                        .make(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
