class PaymentResponse {
  String? pAYMENTOPTIONS;

  PaymentResponse({this.pAYMENTOPTIONS});

  PaymentResponse.fromJson(Map<String, dynamic> json) {
    pAYMENTOPTIONS = json['PAYMENT_OPTIONS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PAYMENT_OPTIONS'] = this.pAYMENTOPTIONS;
    return data;
  }
}
