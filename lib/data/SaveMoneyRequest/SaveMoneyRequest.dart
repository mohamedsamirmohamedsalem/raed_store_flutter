class SaveMoneyRequest {
  String? clinetId;
  String? amount;
  int? userId;
  String? notes;

  SaveMoneyRequest({this.clinetId, this.amount, this.userId, this.notes});

  SaveMoneyRequest.fromJson(Map<String, dynamic> json) {
    clinetId = json['ClinetId'];
    amount = json['Amount'];
    userId = json['UserId'];
    notes = json['Notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ClinetId'] = this.clinetId;
    data['Amount'] = this.amount;
    data['UserId'] = this.userId;
    data['Notes'] = this.notes;
    return data;
  }
}