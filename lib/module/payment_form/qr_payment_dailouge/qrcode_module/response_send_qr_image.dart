class ResponseSendQrImage {
  String? rESPONSECODE;
  String? rESPONSEMESSAGE;
  String? emailId;

  ResponseSendQrImage({this.rESPONSECODE, this.rESPONSEMESSAGE, this.emailId});

  ResponseSendQrImage.fromJson(Map<String, dynamic> json) {
    rESPONSECODE = json['RESPONSE_CODE'];
    rESPONSEMESSAGE = json['RESPONSE_MESSAGE'];
    emailId = json['emailId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RESPONSE_CODE'] = this.rESPONSECODE;
    data['RESPONSE_MESSAGE'] = this.rESPONSEMESSAGE;
    data['emailId'] = this.emailId;
    return data;
  }
}
