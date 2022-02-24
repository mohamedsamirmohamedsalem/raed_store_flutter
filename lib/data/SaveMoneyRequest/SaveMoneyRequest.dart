class SaveMoneyRequest {
  String? clinetId;
  String? amount;
  String? userName;
  String? notes;

  SaveMoneyRequest({this.clinetId, this.amount, this.userName, this.notes});

  SaveMoneyRequest.fromJson(Map<String, dynamic> json) {
    clinetId = json['ClinetId'];
    amount = json['Amount'];
    userName = json['UserName'];
    notes = json['Notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ClinetId'] = this.clinetId;
    data['Amount'] = this.amount;
    data['UserName'] = this.userName;
    data['Notes'] = this.notes;
    return data;
  }
}