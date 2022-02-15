class ClientResponse {
  String? accName;
  String? accNumber;
  String? accTel;
  double? customrtInvoiceDiscount;
  String? accAddress;

  ClientResponse(
      {this.accName,
        this.accNumber,
        this.accTel,
        this.customrtInvoiceDiscount,
        this.accAddress});

  ClientResponse.fromJson(Map<String, dynamic> json) {
    accName = json['AccName'];
    accNumber = json['AccNumber'];
    accTel = json['AccTel'];
    customrtInvoiceDiscount = json['CustomrtInvoiceDiscount'];
    accAddress = json['AccAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AccName'] = this.accName;
    data['AccNumber'] = this.accNumber;
    data['AccTel'] = this.accTel;
    data['CustomrtInvoiceDiscount'] = this.customrtInvoiceDiscount;
    data['AccAddress'] = this.accAddress;
    return data;
  }
}