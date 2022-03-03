import 'package:raed_store/data/base/base_print_doc.dart';

class InvoiceResponse implements BasePrintDoc {
  String? transId;
  int? clientId;
  int? transTypeId;
  String? transTypeName;
  String? clinetName;
  double? totalInvoiceAmount;
  double? paid;
  double? discountValue;
  double? net;
  int? userId;
  double? customrtInvoiceDiscount;
  String? comment;
  List<LstTransDetailsModel>? lstTransDetailsModel;
  int? countItem;
  double? sumItem;
  String? invoiceDate;
  String? representativeName;
  String? driverName;
  String? companyName;
  String? phone1;
  String? phone2;
  String? providerName;
  String? providerPhone;
  String? accountBalanceAfter;
  String? accountBalanceBefore;
  String? stockName;

  InvoiceResponse(
      {this.transId,
      this.clientId,
      this.transTypeId,
      this.transTypeName,
      this.clinetName,
      this.totalInvoiceAmount,
      this.paid,
      this.discountValue,
      this.net,
      this.userId,
      this.customrtInvoiceDiscount,
      this.comment,
      this.lstTransDetailsModel,
      this.countItem,
      this.sumItem,
      this.invoiceDate,
      this.representativeName,
      this.driverName,
      this.companyName,
      this.phone1,
      this.phone2,
      this.providerName,
      this.providerPhone,
      this.accountBalanceAfter,
      this.accountBalanceBefore,
      this.stockName});

  InvoiceResponse.fromJson(Map<String, dynamic> json) {
    transId = json['TransId'];
    clientId = json['ClientId'];
    transTypeId = json['TransTypeId'];
    transTypeName = json['TransTypeName'];
    clinetName = json['ClinetName'];
    totalInvoiceAmount = json['TotalInvoiceAmount'];
    paid = json['Paid'];
    discountValue = json['DiscountValue'];
    net = json['Net'];
    userId = json['UserId'];
    customrtInvoiceDiscount = json['CustomrtInvoiceDiscount'];
    comment = json['Comment'];
    if (json['lstTransDetailsModel'] != null) {
      lstTransDetailsModel = <LstTransDetailsModel>[];
      json['lstTransDetailsModel'].forEach((v) {
        lstTransDetailsModel!.add(new LstTransDetailsModel.fromJson(v));
      });
    }
    countItem = json['CountItem'];
    sumItem = json['SumItem'];
    invoiceDate = json['InvoiceDate'];
    representativeName = json['RepresentativeName'];
    driverName = json['DriverName'];
    companyName = json['CompanyName'];
    phone1 = json['Phone1'];
    phone2 = json['Phone2'];
    providerName = json['ProviderName'];
    providerPhone = json['ProviderPhone'];
    accountBalanceAfter = json['AccountBalanceAfter'];
    accountBalanceBefore = json['AccountBalanceBefore'];
    stockName = json['StockName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TransId'] = this.transId;
    data['ClientId'] = this.clientId;
    data['TransTypeId'] = this.transTypeId;
    data['TransTypeName'] = this.transTypeName;
    data['ClinetName'] = this.clinetName;
    data['TotalInvoiceAmount'] = this.totalInvoiceAmount;
    data['Paid'] = this.paid;
    data['DiscountValue'] = this.discountValue;
    data['Net'] = this.net;
    data['UserId'] = this.userId;
    data['CustomrtInvoiceDiscount'] = this.customrtInvoiceDiscount;
    data['Comment'] = this.comment;
    if (this.lstTransDetailsModel != null) {
      data['lstTransDetailsModel'] =
          this.lstTransDetailsModel!.map((v) => v.toJson()).toList();
    }
    data['CountItem'] = this.countItem;
    data['SumItem'] = this.sumItem;
    data['InvoiceDate'] = this.invoiceDate;
    data['RepresentativeName'] = this.representativeName;
    data['DriverName'] = this.driverName;
    data['CompanyName'] = this.companyName;
    data['Phone1'] = this.phone1;
    data['Phone2'] = this.phone2;
    data['ProviderName'] = this.providerName;
    data['ProviderPhone'] = this.providerPhone;
    data['AccountBalanceAfter'] = this.accountBalanceAfter;
    data['AccountBalanceBefore'] = this.accountBalanceBefore;
    data['StockName'] = this.stockName;
    return data;
  }
}

class LstTransDetailsModel {
  int? serial;
  int? itemIdId;
  int? itemId;
  String? itemName;
  String? packageName;
  double? qty;
  double? amount;
  double? totalItemAmount;
  double? itemAmountBuy;
  int? qtyInpackage;
  int? itemUnitId;

  LstTransDetailsModel(
      {this.serial,
      this.itemIdId,
      this.itemId,
      this.itemName,
      this.packageName,
      this.qty,
      this.amount,
      this.totalItemAmount,
      this.itemAmountBuy,
      this.qtyInpackage,
      this.itemUnitId});

  LstTransDetailsModel.fromJson(Map<String, dynamic> json) {
    serial = json['Serial'];
    itemIdId = json['ItemIdId'];
    itemId = json['ItemId'];
    itemName = json['ItemName'];
    packageName = json['PackageName'];
    qty = json['Qty'];
    amount = json['Amount'];
    totalItemAmount = json['TotalItemAmount'];
    itemAmountBuy = json['ItemAmountBuy'];
    qtyInpackage = json['QtyInpackage'];
    itemUnitId = json['ItemUnitId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Serial'] = this.serial;
    data['ItemIdId'] = this.itemIdId;
    data['ItemId'] = this.itemId;
    data['ItemName'] = this.itemName;
    data['PackageName'] = this.packageName;
    data['Qty'] = this.qty;
    data['Amount'] = this.amount;
    data['TotalItemAmount'] = this.totalItemAmount;
    data['ItemAmountBuy'] = this.itemAmountBuy;
    data['QtyInpackage'] = this.qtyInpackage;
    data['ItemUnitId'] = this.itemUnitId;
    return data;
  }
}
