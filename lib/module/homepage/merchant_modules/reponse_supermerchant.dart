class SubmerchantResponse {
  String? rESPONSECODE;
  String? rESPONSEMESSAGE;
  String? list;

  SubmerchantResponse({this.rESPONSECODE, this.rESPONSEMESSAGE, this.list});

  SubmerchantResponse.fromJson(Map<String, dynamic> json) {
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

class SubUserdata {
  String? pAYID;
  String? bUSINESSNAME;
  String? eMAIL;

  SubUserdata({this.pAYID, this.bUSINESSNAME, this.eMAIL});

  SubUserdata.fromJson(Map<String, dynamic> json) {
    pAYID = json['PAYID'];
    bUSINESSNAME = json['BUSINESSNAME'];
    eMAIL = json['EMAIL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PAYID'] = this.pAYID;
    data['BUSINESSNAME'] = this.bUSINESSNAME;
    data['EMAIL'] = this.eMAIL;
    return data;
  }
}
