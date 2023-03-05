class Salereportrequest {
  String? mOBILENUMBER;
  String? rEPORTTYPE;
  String? dATEFROM;
  String? dATETO;

  Salereportrequest(
      {this.mOBILENUMBER, this.rEPORTTYPE, this.dATEFROM, this.dATETO});

  Salereportrequest.fromJson(Map<String, dynamic> json) {
    mOBILENUMBER = json['MOBILE_NUMBER'];
    rEPORTTYPE = json['REPORT_TYPE'];
    dATEFROM = json['DATE_FROM'];
    dATETO = json['DATE_TO'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MOBILE_NUMBER'] = this.mOBILENUMBER;
    data['REPORT_TYPE'] = this.rEPORTTYPE;
    data['DATE_FROM'] = this.dATEFROM;
    data['DATE_TO'] = this.dATETO;
    return data;
  }
}
