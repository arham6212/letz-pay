class ResendLinkResponse {
  String? rESPONSECODE;
  String? rESPONSEMESSAGE;

  ResendLinkResponse({this.rESPONSECODE, this.rESPONSEMESSAGE});

  ResendLinkResponse.fromJson(Map<String, dynamic> json) {
    rESPONSECODE = json['RESPONSE_CODE'];
    rESPONSEMESSAGE = json['RESPONSE_MESSAGE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RESPONSE_CODE'] = this.rESPONSECODE;
    data['RESPONSE_MESSAGE'] = this.rESPONSEMESSAGE;
    return data;
  }
}
