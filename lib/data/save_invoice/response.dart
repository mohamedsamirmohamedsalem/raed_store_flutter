class SaveInvoiceResponse {
  String? satatus;
  String? message;
  String? transId;
  var errorCode;
  int? logType;
  var requestContent;

  SaveInvoiceResponse(
      {this.satatus,
        this.message,
        this.transId,
        this.errorCode,
        this.logType,
        this.requestContent});

  SaveInvoiceResponse.fromJson(Map<String, dynamic> json) {
    satatus = json['Satatus'];
    message = json['Message'];
    transId = json['TransId'];
    errorCode = json['ErrorCode'];
    logType = json['LogType'];
    requestContent = json['RequestContent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Satatus'] = this.satatus;
    data['Message'] = this.message;
    data['TransId'] = this.transId;
    data['ErrorCode'] = this.errorCode;
    data['LogType'] = this.logType;
    data['RequestContent'] = this.requestContent;
    return data;
  }
}