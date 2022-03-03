import 'package:raed_store/data/base/base_print_doc.dart';

class PrintReceiveMoneyResponse implements BasePrintDoc{
  String? transId;
  String? transTrpeName;
  String? transDate;
  double? amount;
  String? fromAccount;
  String? toAccount;
  String? amountOnly;
  String? currentBalance;
  String? thanksComment;
  String? companyName;
  String? companyAddress;
  String? companyPhone1;
  String? companyPhone2;

  PrintReceiveMoneyResponse(
      {this.transId,
      this.transTrpeName,
      this.transDate,
      this.amount,
      this.fromAccount,
      this.toAccount,
      this.amountOnly,
      this.currentBalance,
      this.thanksComment,
      this.companyName,
      this.companyAddress,
      this.companyPhone1,
      this.companyPhone2});

  PrintReceiveMoneyResponse.fromJson(Map<String, dynamic> json) {
    transId = json['TransId'];
    transTrpeName = json['TransTrpeName'];
    transDate = json['TransDate'];
    amount = json['Amount'];
    fromAccount = json['FromAccount'];
    toAccount = json['ToAccount'];
    amountOnly = json['AmountOnly'];
    currentBalance = json['CurrentBalance'];
    thanksComment = json['ThanksComment'];
    companyName = json['CompanyName'];
    companyAddress = json['CompanyAddress'];
    companyPhone1 = json['CompanyPhone1'];
    companyPhone2 = json['CompanyPhone2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      
    };
    data['TransId'] = transId;
    data['TransTrpeName'] = transTrpeName;
    data['TransDate'] = transDate;
    data['Amount'] = amount;
    data['FromAccount'] = fromAccount;
    data['ToAccount'] = toAccount;
    data['AmountOnly'] = amountOnly;
    data['CurrentBalance'] = currentBalance;
    data['ThanksComment'] = thanksComment;
    data['CompanyName'] = companyName;
    data['CompanyAddress'] = companyAddress;
    data['CompanyPhone1'] = companyPhone1;
    data['CompanyPhone2'] = companyPhone2;
    return data;
  }
}
