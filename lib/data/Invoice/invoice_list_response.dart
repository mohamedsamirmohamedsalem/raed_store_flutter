class InoviceListResponse {
  String? transId;
  String? transTypeName;
  String? clientName;
  String? invoiceDate;
  double? totalInvoice;
  double? discountValue;
  double? net;
  double? paid;
  String? notes;

  InoviceListResponse(
      {this.transId,
      this.transTypeName,
      this.clientName,
      this.invoiceDate,
      this.totalInvoice,
      this.discountValue,
      this.net,
      this.paid,
      this.notes});

  InoviceListResponse.fromJson(Map<String, dynamic> json) {
    transId = json['TransId'];
    transTypeName = json['TransTypeName'];
    clientName = json['ClientName'];
    invoiceDate = json['InvoiceDate'];
    totalInvoice = json['TotalInvoice'];
    discountValue = json['DiscountValue'];
    net = json['Net'];
    paid = json['Paid'];
    notes = json['Notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TransId'] = transId;
    data['TransTypeName'] = transTypeName;
    data['ClientName'] = clientName;
    data['InvoiceDate'] = invoiceDate;
    data['TotalInvoice'] = totalInvoice;
    data['DiscountValue'] = discountValue;
    data['Net'] = net;
    data['Paid'] = paid;
    data['Notes'] = notes;
    return data;
  }
}