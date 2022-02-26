class SaveInvoiceRequest {
  int? clientId;
  int? transTypeId;
  String? totalInvoiceAmount;
  String? paid;
  String? discountValue;
  String? net;
  String? comment;
  double? customrtInvoiceDiscount;
  List<LstTransDetailsModel>? lstTransDetailsModel;

  SaveInvoiceRequest(
      {this.clientId,
      this.transTypeId,
      this.totalInvoiceAmount,
      this.paid,
      this.discountValue,
      this.net,
      this.comment,
      this.customrtInvoiceDiscount,
      this.lstTransDetailsModel});

  SaveInvoiceRequest.fromJson(Map<String, dynamic> json) {
    clientId = json['ClientId'];
    transTypeId = json['TransTypeId'];
    totalInvoiceAmount = json['TotalInvoiceAmount'];
    paid = json['Paid'];
    discountValue = json['DiscountValue'];
    net = json['Net'];
    comment = json['Comment'];
    customrtInvoiceDiscount = json['CustomrtInvoiceDiscount'];
    if (json['lstTransDetailsModel'] != null) {
      lstTransDetailsModel = <LstTransDetailsModel>[];
      json['lstTransDetailsModel'].forEach((v) {
        lstTransDetailsModel!.add(new LstTransDetailsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ClientId'] = this.clientId;
    data['TransTypeId'] = this.transTypeId;
    data['TotalInvoiceAmount'] = this.totalInvoiceAmount;
    data['Paid'] = this.paid;
    data['DiscountValue'] = this.discountValue;
    data['Net'] = this.net;
    data['Comment'] = this.comment;
    data['CustomrtInvoiceDiscount'] = this.customrtInvoiceDiscount;
    if (this.lstTransDetailsModel != null) {
      data['lstTransDetailsModel'] =
          this.lstTransDetailsModel!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LstTransDetailsModel {
  int? itemId;
  int? itemIdId;
  int? itemUnitId;
  int? qtyInpackage;
  double? qty;
  String? itemName;
  String? itemUnitName;
  double? amount;
  double? totalItemAmount;
  double? itemAmountBuy;

  LstTransDetailsModel(
      {this.itemId,
      this.itemIdId,
      this.itemUnitId,
      this.qtyInpackage,
      this.qty,
      this.itemName,
      this.itemUnitName,
      this.amount,
      this.totalItemAmount,
      this.itemAmountBuy});

  LstTransDetailsModel.fromJson(Map<String, dynamic> json) {
    itemId = json['ItemId'];
    itemIdId = json['ItemIdId'];
    itemUnitId = json['ItemUnitId'];
    qtyInpackage = json['QtyInpackage'];
    qty = json['Qty'];
    itemUnitName = json['ItemUnitName'];
    amount = json['Amount'];
    totalItemAmount = json['TotalItemAmount'];
    itemAmountBuy = json['ItemAmountBuy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItemId'] = this.itemId;
    data['ItemIdId'] = this.itemIdId;
    data['ItemUnitId'] = this.itemUnitId;
    data['QtyInpackage'] = this.qtyInpackage;
    data['Qty'] = this.qty;
    data['ItemUnitName'] = this.itemUnitName;
    data['Amount'] = this.amount;
    data['TotalItemAmount'] = this.totalItemAmount;
    data['ItemAmountBuy'] = this.itemAmountBuy;
    return data;
  }
}
