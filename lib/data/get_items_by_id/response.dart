class GetItemWithBalanceByIdResponse {
  int? itemId;
  int? itemIdId;
  int? ItemUnitId;
  String? itemName;
  double? itemBalance;
  double? amount;
  double? itemAmountBuy;
  int? qtyInpackage;
  String? itemDesc;

  GetItemWithBalanceByIdResponse(
      {this.itemId,
      this.itemIdId,
      this.itemName,
      this.itemBalance,
      this.amount,
      this.ItemUnitId,
      this.itemAmountBuy,
      this.qtyInpackage,
      this.itemDesc});

  GetItemWithBalanceByIdResponse.fromJson(Map<String, dynamic> json) {
    itemId = json['ItemId'];
    itemIdId = json['ItemIdId'];
    itemName = json['ItemName'];
    itemBalance = json['itemBalance'];
    amount = json['Amount'];
    ItemUnitId = json["ItemUnitId"];
    itemAmountBuy = json['ItemAmountBuy'];
    qtyInpackage = json['QtyInpackage'];
    itemDesc = json['ItemDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItemId'] = this.itemId;
    data['ItemIdId'] = this.itemIdId;
    data['ItemName'] = this.itemName;
    data['itemBalance'] = this.itemBalance;
    data['Amount'] = this.amount;
    data['ItemUnitId'] = this.ItemUnitId;
    data['ItemAmountBuy'] = this.itemAmountBuy;
    data['QtyInpackage'] = this.qtyInpackage;
    data['ItemDesc'] = this.itemDesc;
    return data;
  }
}
