class ResponseReportChart {
  String? cC;
  String? mERCHANTAMOUNT;
  String? cD;
  String? rESPONSECODE;
  String? sUFCHARGES;
  String? uPIQR;
  String? eM;
  String? aCQUIRERGST;
  String? nB;
  String? tOTALTRANSACTION;
  String? wL;
  String? rESPONSEMESSAGE;
  String? pGTDRSC;
  String? pGGST;
  String? uP;
  String? tOTALAMOUNT;
  String? aCQUIRERTDRSC;
  String? dC;

  ResponseReportChart(
      {this.cC,
      this.mERCHANTAMOUNT,
      this.cD,
      this.rESPONSECODE,
      this.sUFCHARGES,
      this.uPIQR,
      this.eM,
      this.aCQUIRERGST,
      this.nB,
      this.tOTALTRANSACTION,
      this.wL,
      this.rESPONSEMESSAGE,
      this.pGTDRSC,
      this.pGGST,
      this.uP,
      this.tOTALAMOUNT,
      this.aCQUIRERTDRSC,
      this.dC});

  ResponseReportChart.fromJson(Map<String, dynamic> json) {
    cC = json['CC'];
    mERCHANTAMOUNT = json['MERCHANT_AMOUNT'];
    cD = json['CD'];
    rESPONSECODE = json['RESPONSE_CODE'];
    sUFCHARGES = json['SUF_CHARGES'];
    uPIQR = json['UPI_QR'];
    eM = json['EM'];
    aCQUIRERGST = json['ACQUIRER_GST'];
    nB = json['NB'];
    tOTALTRANSACTION = json['TOTAL_TRANSACTION'];
    wL = json['WL'];
    rESPONSEMESSAGE = json['RESPONSE_MESSAGE'];
    pGTDRSC = json['PG_TDR_SC'];
    pGGST = json['PG_GST'];
    uP = json['UP'];
    tOTALAMOUNT = json['TOTAL_AMOUNT'];
    aCQUIRERTDRSC = json['ACQUIRER_TDR_SC'];
    dC = json['DC'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CC'] = this.cC;
    data['MERCHANT_AMOUNT'] = this.mERCHANTAMOUNT;
    data['CD'] = this.cD;
    data['RESPONSE_CODE'] = this.rESPONSECODE;
    data['SUF_CHARGES'] = this.sUFCHARGES;
    data['UPI_QR'] = this.uPIQR;
    data['EM'] = this.eM;
    data['ACQUIRER_GST'] = this.aCQUIRERGST;
    data['NB'] = this.nB;
    data['TOTAL_TRANSACTION'] = this.tOTALTRANSACTION;
    data['WL'] = this.wL;
    data['RESPONSE_MESSAGE'] = this.rESPONSEMESSAGE;
    data['PG_TDR_SC'] = this.pGTDRSC;
    data['PG_GST'] = this.pGGST;
    data['UP'] = this.uP;
    data['TOTAL_AMOUNT'] = this.tOTALAMOUNT;
    data['ACQUIRER_TDR_SC'] = this.aCQUIRERTDRSC;
    data['DC'] = this.dC;
    return data;
  }
}
