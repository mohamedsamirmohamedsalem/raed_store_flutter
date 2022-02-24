class GetItemWithBalanceByIdResponse {
  int? itemId;
  int? itemIdId;
  int? itemUnitId;
  String? itemName;
  double? itemBalance;
  double? amount;
  double? itemAmountBuy;
  int? qtyInpackage;
  String? itemDesc;
  String? itemUnitName;

  GetItemWithBalanceByIdResponse(
      {this.itemId,
      this.itemIdId,
      this.itemName,
      this.itemBalance,
      this.amount,
      this.itemUnitId,
      this.itemUnitName,
      this.itemAmountBuy,
      this.qtyInpackage,
      this.itemDesc});

  GetItemWithBalanceByIdResponse.fromJson(Map<String, dynamic> json) {
    itemId = json['ItemId'];
    itemIdId = json['ItemIdId'];
    itemName = json['ItemName'];
    itemBalance = json['itemBalance'];
    amount = json['Amount'];
    itemUnitName = json['ItemUnitName'];
    itemUnitId = json["ItemUnitId"];
    itemAmountBuy = json['ItemAmountBuy'];
    qtyInpackage = json['QtyInpackage'];
    itemDesc = json['ItemDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ItemId'] = itemId;
    data['ItemIdId'] = itemIdId;
    data['ItemName'] = itemName;
    data['itemBalance'] = itemBalance;
    data['Amount'] = amount;
    data['ItemUnitName'] = itemUnitName;
    data['ItemUnitId'] = itemUnitId;
    data['ItemAmountBuy'] = itemAmountBuy;
    data['QtyInpackage'] = qtyInpackage;
    data['ItemDesc'] = itemDesc;
    return data;
  }
}
