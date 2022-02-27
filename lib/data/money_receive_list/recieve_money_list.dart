class ReceiveMoneyListResponse {
  String? transId;
  String? transType;
  String? clientName;
  String? invoiceDate;
  var amount;
  String? notes;

  ReceiveMoneyListResponse(
      {this.transId,
      this.transType,
      this.clientName,
      this.invoiceDate,
      this.amount,
      this.notes});

  ReceiveMoneyListResponse.fromJson(Map<String, dynamic> json) {
    transId = json['TransId'];
    transType = json['TransType'];
    clientName = json['ClientName'];
    invoiceDate = json['InvoiceDate'];
    amount = json['Amount'];
    notes = json['Notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TransId'] = transId;
    data['TransType'] = transType;
    data['ClientName'] = clientName;
    data['InvoiceDate'] = invoiceDate;
    data['Amount'] = amount;
    data['Notes'] = notes;
    return data;
  }
}