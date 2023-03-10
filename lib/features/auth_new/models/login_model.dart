// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) => LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) => json.encode(data.toJson());

class LoginResponseModel {
  LoginResponseModel({
    required this.responseCode,
    required this.responseMessage,
    required this.businessName,
    required this.userType,
    required this.sessionId,
  });

  String responseCode;
  String responseMessage;
  String businessName;
  String userType;
  String sessionId;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
    responseCode: json["RESPONSE_CODE"],
    responseMessage: json["RESPONSE_MESSAGE"],
    businessName: json["BUSINESS_NAME"],
    userType: json["USER_TYPE"],
    sessionId: json["SESSION_ID"],
  );

  Map<String, dynamic> toJson() => {
    "RESPONSE_CODE": responseCode,
    "RESPONSE_MESSAGE": responseMessage,
    "BUSINESS_NAME": businessName,
    "USER_TYPE": userType,
    "SESSION_ID": sessionId,
  };
}
