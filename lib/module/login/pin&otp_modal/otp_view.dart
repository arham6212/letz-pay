//changes of page for OTP enter as per requirment ,so this page is committed if any changes we can re use this pageS

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:letzpay/common_components/common_functions/common_widget.dart';

// import 'package:letzpay/login/loginmodule/response_loginauth.dart';

// import 'package:letzpay/services/authentication_service.dart';
// // import 'package:letzpay/services/network/api_services.dart';
// import 'package:letzpay/services/shared_pref.dart';
// import 'package:letzpay/utils/assets_path.dart';
// import 'package:letzpay/utils/colors.dart';
// import 'package:letzpay/utils/strings.dart';
// import 'package:pinput/pinput.dart';
// import 'package:velocity_x/velocity_x.dart';

// class OTP_View extends StatefulWidget {
//   final String mobileNumber;
//   const OTP_View({Key? key, required this.mobileNumber}) : super(key: key);

//   @override
//   State<OTP_View> createState() => _OTP_ViewState();
// }

// class _OTP_ViewState extends State<OTP_View> {
//   late ApiService apiService;

//   late Loginauthresponse loginauthresponse;

//   @override
//   void initState() {
//     super.initState();
//     apiService = ApiService();
//     loginauthresponse = Loginauthresponse();
//   }

//   Future getLogin(
//     var context,
//     String mobileNo,
//     String value,
//   ) async {
//     Response response;
//     try {
//       var params = {
//         "MOBILE_NUMBER": mobileNo,
//         "LOGIN_TYPE": "PIN",
//         "PIN": value
//       };
//       response = await apiService.getLogin(
//         context,
//         params,
//       );

//       if (response.statusCode == 200) {
//         if (response.data['RESPONSE_CODE'] == '000') {
//           saveKeyValString("mobileNumber", mobileNo);
//           saveKeyValString("pinOrOtp", value);
//           saveKeyValString("loginType", "PIN");

//           //saveKeyValString("uSERTYPE", uSERTYPE);

//           loginauthresponse = Loginauthresponse.fromJson(response.data);
//           saveKeyValString("uSERTYPE", loginauthresponse.uSERTYPE.toString());

//           print("heyyyyy" + loginauthresponse.uSERTYPE.toString());
//           AuthenticationProvider.of(context).login(); //go to login page
//           Navigator.of(context).pushNamed('/fhome');
//         } else {
//           setState(() {
//             _pinPutController.clear();
//             showPopUpDialog(errorpop,
//                 response.data['RESPONSE_MESSAGE'].toString(), context);
//             //   showToastMsg(response.data['RESPONSE_MESSAGE'].toString());
//           });

//           // print(response.data['RESPONSE_MESSAGE'].toString());
//         }
//       } else {
//         _pinPutController.clear();
//         showPopUpDialog(errorpop, errorSomeWrong, context);
//         // showToastMsg("error found");
//       }
//     } on Exception catch (e) {
//       _pinPutController.clear();
//       showPopUpDialog(errorpop, e.toString(), context);
//       //   showToastMsg(e.toString());
//     }
//   }

//   Future validatePIN(var context, String mobileNo, String value) async {
//     Response response;
//     try {
//       var params = {"MOBILE_NUMBER": mobileNo, "PIN": value};
//       response = await apiService.validatePIN(context, params);

//       if (response.statusCode == 200) {
//         if (response.data['RESPONSE_CODE'] == '000') {
//           getLogin(context, mobileNo, value);
//         } else {
//           setState(() {
//             _pinPutController.clear();
//             showPopUpDialog(errorpop,
//                 response.data['RESPONSE_MESSAGE'].toString(), context);
//             //  showToastMsg(response.data['RESPONSE_MESSAGE'].toString());
//           });
//           // print(response.data['RESPONSE_MESSAGE'].toString());
//         }
//       } else {
//         _pinPutController.clear();
//         showPopUpDialog(errorpop, errorSomeWrong, context);
//         // showToastMsg("error found");
//       }
//     } on Exception catch (e) {
//       _pinPutController.clear();
//       showPopUpDialog(errorpop, e.toString(), context);
//       //   showToastMsg(e.toString());
//     }
//   }

//   final defaultPinTheme = PinTheme(
//     width: 56,
//     height: 56,
//     textStyle: TextStyle(
//         fontSize: 20.0,
//         color: Vx.hexToColor(balckMainColor),
//         fontWeight: FontWeight.w600),
//     decoration: BoxDecoration(
//       border: Border.all(color: Vx.hexToColor(darkblue)),
//       borderRadius: BorderRadius.circular(10),
//     ),
//   );
//   final TextEditingController _pinPutController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     String mobileNo = widget.mobileNumber;

//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: white,
//         leading: IconButton(
//             icon: Icon(Icons.arrow_back, color: Colors.black),
//             onPressed: () => {
//                   Navigator.of(context).pushNamed('/login'),
//                 }),
//       ),
//       body: SafeArea(
//         child: Container(
//           height: MediaQuery.of(context).size.height,
//           margin: const EdgeInsets.all(18.0),
//           padding: const EdgeInsets.only(top: 10),
//           // width: double.infinity,
//           // height: double.infinity,
//           color: Colors.white,
//           child: Column(children: [
//             //  VSpace(50.0),
//             imageView(
//               authotplogo,
//               190.0,
//               100.0,
//             ),
//             VSpace(50.0),
//             Text(
//               enterPin,
//               style: fontStyleHeaderBold(),
//             ),
//             VSpace(10.0),
//             RichText(
//               text: TextSpan(children: [
//                 TextSpan(
//                   text: forMobileNumber,
//                   style: fontStyleHeader(),
//                 ),
//                 TextSpan(
//                   text: mobileNo, //TODO : Change to mobile variable
//                   style: fontStyleHeader(),
//                   //style: fontStyleHeaderBold(),
//                 ),
//               ]),
//             ),
//             VSpace(30),
//             Center(
//               child: Pinput(
//                   autofocus: true,
//                   obscureText: true,
//                   errorText: enterPinError,
//                   length: 6,
//                   onCompleted: (value) {
//                     {
//                       getLogin(context, mobileNo, value);
//                     }
//                   }, // navigate through

//                   defaultPinTheme: defaultPinTheme,
//                   controller: _pinPutController,
//                   pinAnimationType: PinAnimationType.fade,
//                   onSubmitted: (pin) {}),
//             ),
//             Expanded(
//               child: Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment
//                       .spaceBetween, //Center Row contents horizontally,
//                   crossAxisAlignment: CrossAxisAlignment
//                       .center, //Center Row contents vertically,
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         Navigator.pushNamed(context, '/forgetpin',
//                             arguments: {"mobileNo": mobileNo});
//                       },
//                       child: Text(
//                         forgetPin,
//                         style: TextStyle(
//                           fontSize: 18.0,
//                           color: Vx.hexToColor(darkblue),
//                         ),
//                       ),
//                     ),
//                     InkWell(
//                       onTap: () {
//                         Navigator.pushNamed(context, '/otpenter',
//                             arguments: {"mobileNo": mobileNo});
//                       },
//                       child: Text(
//                         loginWithOtp,
//                         style: TextStyle(
//                           fontSize: 18.0,
//                           color: Vx.hexToColor(darkblue),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             )
//           ]),
//         ),
//       ),
//     );
//   }
// }
