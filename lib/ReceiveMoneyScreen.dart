import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:raed_store/data/SaveMoneyRequest/SaveMoneyRequest.dart';
import 'package:raed_store/data/SaveMoneyRequest/save_received_money_response.dart';
import 'package:raed_store/data/client/clientResponse.dart';
import 'package:raed_store/network/network_manager.dart';

class ReceiveMoneyScreen extends StatefulWidget {
  const ReceiveMoneyScreen({Key? key}) : super(key: key);

  @override
  _ReceiveMoneyScreenState createState() => _ReceiveMoneyScreenState();
}

class _ReceiveMoneyScreenState extends State<ReceiveMoneyScreen> {
  bool isClientBalanceReceived = false;
  List<ClientResponse> agentsList = [];
  ClientResponse? selectedClientValue;
  String? currentClientBalance = "0";
  bool _isloading = false;
  SaveReceivedMoney? response;

  TextEditingController paidAmountController = TextEditingController();

  @override
  void initState() {
    try {
      NetworkManager().getAgents().then((value) {
        agentsList = value!;
        selectedClientValue = agentsList[0];
        setState(() {
          isClientBalanceReceived = true;
        });
      });
    } on Exception catch (_, e) {
      setState(() {
        isClientBalanceReceived = true;
      });
      _showErrorDialog(e);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.yellow,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "cash_collection_receipt",
          style: TextStyle(color: Colors.black),
        ).tr(),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              child: isClientBalanceReceived
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildAppLogo(),
                        _buildAgentDropDownList(),
                        // _isBalanceAvailable
                        //     ? _buildCurrentBalanceRow()
                        //     : Container(),
                        _buildPaidMoneyDataInputField(),
                        _buildSaveButton()
                      ],
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        alignment: Alignment.center,
                        width: 100,
                        height: 100,
                        child: const CircularProgressIndicator(
                          color: Colors.yellow,
                        ),
                      ),
                    ),
            ),
          ),
          _isloading
              ? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    alignment: Alignment.center,
                    width: 100,
                    height: 100,
                    child: const CircularProgressIndicator(
                      color: Colors.yellow,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildAppLogo() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      width: 200,
      height: 100,
      child:
          const Image(image: AssetImage('assets/images/raad_store_logo.jpeg')),
    );
  }
  // Widget _buildScreenTitle() => Container(
  //       alignment: Alignment.center,
  //       margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
  //       child: const Text("cash_collection_receipt").tr(),
  //     );

  Widget _buildAgentDropDownList() {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                    color: Colors.yellow, style: BorderStyle.solid, width: 2.0),
              ),
              child: _buildDropdownButton()),
          const Spacer(),
          _buildShowClientBalance(),
        ],
      ),
    );
  }

  DropdownButton<ClientResponse> _buildDropdownButton() {
    return DropdownButton<ClientResponse>(
      underline: Container(),
      items: agentsList.map((ClientResponse value) {
        return DropdownMenuItem<ClientResponse>(
          value: value,
          child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Center(child: Text(value.accName!))),
        );
      }).toList(),
      value: selectedClientValue,
      onChanged: (value) async {
        paidAmountController.clear();
        setState(() {
          selectedClientValue = value;
        });
      },
    );
  }

  Widget _buildCurrentBalanceRow() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Text("current_balance".tr()),
            const Spacer(),
            Text(currentClientBalance ?? "")
          ],
        ),
      );

  Widget _buildPaidMoneyDataInputField() => Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: TextField(
          cursorColor: Colors.yellow,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            labelText: "paid_amount".tr(),
            focusColor: Colors.yellow,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow, width: 2.0)),
            labelStyle: const TextStyle(color: Colors.black),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.yellow, width: 2.0),
            ),
          ),
          keyboardType: TextInputType.number,
          controller: paidAmountController,

          // inputFormatters: <TextInputFormatter>[
          //   FilteringTextInputFormatter.digitsOnly
          // ], // Only numbers can be entered
        ),
      );

  Widget _buildSaveButton() => Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.yellow),
          ),
          onPressed: () => _saveRecieveMoney(),
          child: const Text(
            "save_print",
            style: TextStyle(color: Colors.black),
          ).tr(),
        ),
      );

  void _saveRecieveMoney() async {
    try {
      if (paidAmountController.value.text.isNotEmpty &&
          double.parse(paidAmountController.value.text) != 0) {
        setState(() {
          _isloading = true;
        });
        response = await NetworkManager().saveMoney(SaveMoneyRequest(
            clinetId: selectedClientValue!.accNumber!,
            amount: paidAmountController.value.text,
            userName: "",
            notes: "Mobile"));
        if (response?.satatus != "NotSaved") paidAmountController.clear();
        setState(() {
          _isloading = false;
        });
        _showErrorDialog(null,
            errorMSG: response?.message ?? "",
          );
      } else {
        _showErrorDialog(null, errorMSG: "please_enter_quantity".tr());
      }
    } on Exception catch (_, e) {
        setState(() {
          _isloading = false;
        });
      _showErrorDialog(e);
    }
  }

  void _showErrorDialog(StackTrace? e,
      {String errorMSG = "", Function? onPostivePressed}) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              actions: [
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.yellow),
                    ),
                    onPressed: () => onPostivePressed == null
                        ? Navigator.of(context).pop()
                        : onPostivePressed(),
                    child: const Text("ok").tr())
              ],
              title: Text('alert'.tr()),
              content: Text(e != null ? e.toString() : errorMSG),
            ));
  }

  Widget _buildShowClientBalance() {
    return ElevatedButton(
        onPressed: () async {
          try {
            setState(() {
              _isloading = true;
            });
            currentClientBalance = await NetworkManager()
                .getClientBalance(selectedClientValue!.accNumber!);
            setState(() {
              _isloading = false;
            });
            _showErrorDialog(null,
                errorMSG: '${"current_balance".tr()} : $currentClientBalance');
          } on Exception catch (_, e) {
            _showErrorDialog(e);
          }
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.yellow),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(horizontal: 2, vertical: 5))),
        child: const Text(
          "show_balance",
          style: TextStyle(color: Colors.black),
        ).tr());
  }

  // Future<void> _navigateToPrint() {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   try {
  //     if (response?.transId == null ||
  //         response?.transType == null) {
  //       throw Exception("cannot_find_transaction_number".tr());
  //     } else {
  //       PrintReceiveMoneyResponse? response = await NetworkManager()
  //           .printReceiveMoney(
  //               receiveMoneyItem.transId!, receiveMoneyItem.transType!);
  //       setState(() {
  //         _isLoadingAbove = false;
  //       });
  //       PdfInvoiceApi.generate(response!).then((value) {
  //         //PdfApi.openFile(value);
  //         Navigation(navigationKey: navigatorKey)
  //             .navigateTo(routeName: RoutesNames.pdfPrinterScreen, arg: value);
  //       });
  //     }
  //   } on Exception catch (_, e) {
  //     _showErrorDialog(e);
  //   }

  // }
}
