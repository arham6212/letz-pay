import 'package:flutter/src/material/dropdown.dart';

class SupermerchantResponse {
  String? rESPONSECODE;
  String? rESPONSEMESSAGE;
  String? list;

  SupermerchantResponse({this.rESPONSECODE, this.rESPONSEMESSAGE, this.list});

  SupermerchantResponse.fromJson(Map<String, dynamic> json) {
    rESPONSECODE = json['RESPONSE_CODE'];
    rESPONSEMESSAGE = json['RESPONSE_MESSAGE'];
    list = json['list'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RESPONSE_CODE'] = this.rESPONSECODE;
    data['RESPONSE_MESSAGE'] = this.rESPONSEMESSAGE;
    data['list'] = this.list;
    return data;
  }
}

class UserData {
  String? pAYID;
  bool? sUPERMERCHANTFLAG;
  String? bUSINESSNAME;
  String? eMAIL;

  UserData({this.pAYID, this.sUPERMERCHANTFLAG, this.bUSINESSNAME, this.eMAIL});

  UserData.fromJson(Map<String, dynamic> json) {
    pAYID = json['PAYID'];
    sUPERMERCHANTFLAG = json['SUPERMERCHANT_FLAG'];
    bUSINESSNAME = json['BUSINESSNAME'];
    eMAIL = json['EMAIL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PAYID'] = this.pAYID;
    data['SUPERMERCHANT_FLAG'] = this.sUPERMERCHANTFLAG;
    data['BUSINESSNAME'] = this.bUSINESSNAME;
    data['EMAIL'] = this.eMAIL;
    return data;
  }
}
