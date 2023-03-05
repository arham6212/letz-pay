class Loginhistoryresponse {
  String? rESPONSECODE;
  String? rESPONSEMESSAGE;
  String? rECORDTOTAL;
  String? lOGINRECORDS;

  Loginhistoryresponse(
      {this.rESPONSECODE,
      this.rESPONSEMESSAGE,
      this.rECORDTOTAL,
      this.lOGINRECORDS});

  Loginhistoryresponse.fromJson(Map<String, dynamic> json) {
    rESPONSECODE = json['RESPONSE_CODE'];
    rESPONSEMESSAGE = json['RESPONSE_MESSAGE'];
    rECORDTOTAL = json['RECORD_TOTAL'];
    lOGINRECORDS = json['LOGIN_RECORDS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RESPONSE_CODE'] = this.rESPONSECODE;
    data['RESPONSE_MESSAGE'] = this.rESPONSEMESSAGE;
    data['RECORD_TOTAL'] = this.rECORDTOTAL;
    data['LOGIN_RECORDS'] = this.lOGINRECORDS;
    return data;
  }
}

class LoginHistoryData {
  int? id;
  String? businessName;
  String? emailId;
  String? ip;
  String? browser;
  String? os;
  bool? status;
  String? timeStamp;
  String? failureReason;

  LoginHistoryData(
      {this.id,
      this.businessName,
      this.emailId,
      this.ip,
      this.browser,
      this.os,
      this.status,
      this.timeStamp,
      this.failureReason});

  LoginHistoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    businessName = json['businessName'];
    emailId = json['emailId'];
    ip = json['ip'];
    browser = json['browser'];
    os = json['os'];
    status = json['status'];
    timeStamp = json['timeStamp'];
    failureReason = json['failureReason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['businessName'] = this.businessName;
    data['emailId'] = this.emailId;
    data['ip'] = this.ip;
    data['browser'] = this.browser;
    data['os'] = this.os;
    data['status'] = this.status;
    data['timeStamp'] = this.timeStamp;
    data['failureReason'] = this.failureReason;
    return data;
  }
}
