// ignore_for_file: prefer_interpolation_to_compose_strings
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letzpay/common_components/common_widget.dart';
import 'package:letzpay/common_components/home_app_bar.dart';
import 'package:letzpay/module/profile/profile_module/reponse_profile.dart';
import 'package:letzpay/services/authentication_service.dart';
import 'package:letzpay/services/network/api_services.dart';
import 'package:letzpay/utils/assets_path.dart';
import 'package:letzpay/utils/colors.dart';
import 'package:letzpay/utils/strings.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../common_components/common_progress_dailoug.dart';
import '../../../services/shared_pref.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ApiService apiService;

  late Profileresponse profileresponse;
  @override
  void initState() {
    super.initState();

    profileresponse = Profileresponse();
    apiService = ApiService();

    getProfileDetail(context);
  }

  //this function handle getProfileDetail API
  Future getProfileDetail(var context) async {
    Response response;
    try {
      // showToastMsg("Loading started");
      // RequestAllCountUser requestAllCountUser = RequestAllCountUser();
      // requestAllCountUser.user_id = "7";

      var params = {"MOBILE_NUMBER": await getStringVal("mobileNumber")};

      response = await apiService.getProfileDetail(
          params, context); //API call for get Profile detail of user

      if (response.statusCode == 200) {
        setState(() {
          // showToastMsg(response.data.toString());
          profileresponse = Profileresponse.fromJson(response.data);
          // allCountUser = responseAllCountUser.allCountUser;
          //  showToastMsg("testResp : " + profileresponse.bUSINESSNAME.toString());
          // showToastMsg("Response deactivateSitePendingCount " +
          //     allCountUser.deactivateSitePendingCount.toString());
        });
      } else {
        showPopUpDialog(errorpop, errorSomeWrong, context);
        // showToastMsg("error found");
      }
    } on Exception catch (e) {
      showPopUpDialog(errorpop, e.toString(), context);
      //  showToastMsg(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildHomeAppBar(
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('/fhome'); //redirect to home page
            },
            child: Image.asset(blackArrow)),
        title: profile.text.bold
            .size(20.0.sp)
            .color(Vx.hexToColor(blackprofilecolor))
            .make(),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 0.0.w, right: 0.0.w, top: 10),
        color: Vx.hexToColor(whiteMainColor),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1.w,
                            color: Theme.of(context).scaffoldBackgroundColor),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 10))
                        ],
                        shape: BoxShape.circle,
                        image: profileresponse.lOGO.toString() == ""
                            ? DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(userIcon.toString()))
                            : DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  profileresponse.lOGO.toString(),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              VSpace(10.0.h),
              const Divider(),
              VSpace(16.0.h),
              Padding(
                padding: EdgeInsets.only(left: 24.w, right: 16.w),
                child: Column(
                  children: [
                    Container(
                      height: 60.h,
                      width: MediaQuery.of(context).size.width.w,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        //  borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: EdgeInsets.only(top: 10.0.h),
                          child: SvgPicture.asset(
                            profileUserIcon,
                            width: 20.0.w,
                            height: 20.0.h,
                            color: Vx.hexToColor(greyHintTextColor),
                          ),
                        ),
                        title: uesrType.text
                            .color(Vx.hexToColor(greyHintTextColor))
                            .size(12.0.sp)
                            .make(),
                        subtitle: Container(
                          margin: EdgeInsets.only(top: 2.0.h),
                          child: profileresponse.uSERTYPE
                              .toString()
                              .text
                              .fontWeight(FontWeight.w700)
                              .size(14.0.sp)
                              .color(Vx.hexToColor(blackprofilecolor))
                              .make(),
                        ),
                      ),
                    ),
                    const Divider(),
                    VSpace(16.0.h),
                    Container(
                      height: 60.h,
                      width: MediaQuery.of(context).size.width.w,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        //  borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: EdgeInsets.only(top: 10.0.h),
                          child: SvgPicture.asset(
                            busineesNameIcon,
                            width: 20.0.w,
                            height: 20.0.h,
                            color: Vx.hexToColor(greyHintTextColor),
                          ),
                        ),
                        title: buinessName.text
                            .color(Vx.hexToColor(greyHintTextColor))
                            .size(12.0.sp)
                            .make(),
                        subtitle: Container(
                          margin: EdgeInsets.only(top: 2.0.h),
                          child: profileresponse.bUSINESSNAME
                              .toString()
                              .text
                              .fontWeight(FontWeight.w700)
                              .color(Vx.hexToColor(blackprofilecolor))
                              .size(14.0.sp)
                              .make(),
                        ),
                      ),
                    ),
                    const Divider(),
                    VSpace(16.0.h),
                    Container(
                      height: 60.h,
                      width: MediaQuery.of(context).size.width.w,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        //  borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: EdgeInsets.only(top: 10.0.h),
                          child: SvgPicture.asset(
                            useremailIcon,
                            width: 20.0.w,
                            height: 20.0.h,
                            color: Vx.hexToColor(greyHintTextColor),
                          ),
                        ),
                        title: emailAddress.text
                            .color(Vx.hexToColor(greyHintTextColor))
                            .size(12.0.sp)
                            .make(),
                        subtitle: Container(
                          margin: EdgeInsets.only(top: 2.0.h),
                          child: profileresponse.cUSTEMAIL
                              .toString()
                              .text
                              .fontWeight(FontWeight.w700)
                              .color(Vx.hexToColor(blackprofilecolor))
                              .size(14.0.sp)
                              .make(),
                        ),
                      ),
                    ),
                    const Divider(),
                    VSpace(16.0.h),
                    Container(
                      height: 60.h,
                      width: MediaQuery.of(context).size.width.w,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        //  borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: EdgeInsets.only(top: 10.0.h),
                          child: SvgPicture.asset(
                            phoneIcon,
                            width: 20.0.w,
                            height: 20.0.h,
                            color: Vx.hexToColor(greyHintTextColor),
                          ),
                        ),
                        title: mobileNumber.text
                            .color(Vx.hexToColor(greyHintTextColor))
                            .size(12.0.sp)
                            .make(),
                        subtitle: Container(
                          margin: EdgeInsets.only(top: 2.0.h),
                          child: profileresponse.cUSTMOBILE
                              .toString()
                              .text
                              .fontWeight(FontWeight.w700)
                              .color(Vx.hexToColor(blackprofilecolor))
                              .size(14.0.sp)
                              .make(),
                        ),
                      ),
                    ),
                    const Divider(),
                    VSpace(16.0.h),
                    Container(
                      height: 60.h,
                      width: MediaQuery.of(context).size.width.w,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        //  borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: EdgeInsets.only(top: 10.0.h),
                          child: SvgPicture.asset(
                            languageUserIcon,
                            width: 20.0.w,
                            height: 20.0.h,
                            color: Vx.hexToColor(greyHintTextColor),
                          ),
                        ),
                        title: language.text
                            .color(Vx.hexToColor(greyHintTextColor))
                            .size(12.0.sp)
                            .make(),
                        subtitle: Container(
                          margin: EdgeInsets.only(top: 2.0.h),
                          child: profileresponse.dEFAULTLANGUAGE
                              .toString()
                              .text
                              .fontWeight(FontWeight.w700)
                              .color(Vx.hexToColor(blackprofilecolor))
                              .size(14.0.sp)
                              .make(),
                        ),
                      ),
                    ),
                    const Divider(),
                    VSpace(16.0.h),
                    Container(
                      height: 60.h,
                      width: MediaQuery.of(context).size.width.w,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        //  borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: EdgeInsets.only(top: 10.0.h),
                          child: SvgPicture.asset(
                            industryIcon,
                            width: 20.0.w,
                            height: 20.0.h,
                            color: Vx.hexToColor(greyHintTextColor),
                          ),
                        ),
                        title: industryCategory.text
                            .color(Vx.hexToColor(greyHintTextColor))
                            .size(12.0.sp)
                            .make(),
                        subtitle: Container(
                          margin: EdgeInsets.only(top: 2.0.h),
                          child: profileresponse.iNDUSTRYCATEGORY
                              .toString()
                              .text
                              .fontWeight(FontWeight.w700)
                              .color(Vx.hexToColor(blackprofilecolor))
                              .size(14.0.sp)
                              .make(),
                        ),
                      ),
                    ),
                    const Divider(),
                    VSpace(16.0.h),
                    Container(
                      height: 60.h,
                      width: MediaQuery.of(context).size.width.w,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        //  borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: EdgeInsets.only(top: 10.0.h),
                          child: SvgPicture.asset(
                            calendarIcon,
                            width: 20.0.w,
                            height: 20.0.h,
                            color: Vx.hexToColor(greyHintTextColor),
                          ),
                        ),
                        title: registrationDate.text
                            .color(Vx.hexToColor(greyHintTextColor))
                            .size(12.0.sp)
                            .make(),
                        subtitle: Container(
                          margin: EdgeInsets.only(top: 2.0.h),
                          child: profileresponse.rEGISTRATIONDATE
                              .toString()
                              .text
                              .fontWeight(FontWeight.w700)
                              .color(Vx.hexToColor(blackprofilecolor))
                              .size(14.0.sp)
                              .make(),
                        ),
                      ),
                    ),
                    const Divider(),
                    VSpace(16.0.h),
                    Container(
                      height: 60.h,
                      width: MediaQuery.of(context).size.width.w,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        //  borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: EdgeInsets.only(top: 10.0.h),
                          child: SvgPicture.asset(
                            calendarIcon,
                            width: 20.0.w,
                            height: 20.0.h,
                            color: Vx.hexToColor(greyHintTextColor),
                          ),
                        ),
                        title: activationDate.text
                            .color(Vx.hexToColor(greyHintTextColor))
                            .size(12.0.sp)
                            .make(),
                        subtitle: Container(
                          margin: EdgeInsets.only(top: 2.0.h),
                          child: profileresponse.aCTIVATIONDATE
                              .toString()
                              .text
                              .fontWeight(FontWeight.w700)
                              .color(Vx.hexToColor(blackprofilecolor))
                              .size(14.0.sp)
                              .make(),
                        ),
                      ),
                    ),
                    VSpace(20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
