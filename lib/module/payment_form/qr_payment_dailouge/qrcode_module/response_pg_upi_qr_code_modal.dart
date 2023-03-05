class ResponseStaticPgAndUPIQr {
  String? rESPONSECODE;
  String? sTATICPGQR;
  String? rESPONSEMESSAGE;
  String? sTATICUPIQR;

  ResponseStaticPgAndUPIQr(
      {this.rESPONSECODE,
      this.sTATICPGQR,
      this.rESPONSEMESSAGE,
      this.sTATICUPIQR});

  ResponseStaticPgAndUPIQr.fromJson(Map<String, dynamic> json) {
    rESPONSECODE = json['RESPONSE_CODE'];
    sTATICPGQR = json['STATIC_PG_QR'];
    rESPONSEMESSAGE = json['RESPONSE_MESSAGE'];
    sTATICUPIQR = json['STATIC_UPI_QR'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RESPONSE_CODE'] = this.rESPONSECODE;
    data['STATIC_PG_QR'] = this.sTATICPGQR;
    data['RESPONSE_MESSAGE'] = this.rESPONSEMESSAGE;
    data['STATIC_UPI_QR'] = this.sTATICUPIQR;
    return data;
  }
}
