const String baseUrl = "http://mydatasoft.net/api/";

class NetworkHelper {
  String register = baseUrl + "Account/Register";
  String login = baseUrl + "token";
  String getClientBalance = baseUrl + "AccountData/GetClinetBalance";
  String saveReceivedMoney = baseUrl + "AccountData/SaveReceiveMoney";

  String getClients = baseUrl + "AccountData/GetClinets";
  String getItemsByID = baseUrl + "Item/GetItemsWithBalance";
  String saveInvoice = baseUrl + "Invoice/SaveInvoice";
  String printInvoice = baseUrl + "Invoice/PrintInvoice";
}
