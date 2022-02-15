import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:raed_store/data/SaveMoneyRequest/SaveMoneyRequest.dart';
import 'package:raed_store/data/client/clientResponse.dart';
import 'package:raed_store/network/network_manager.dart';
import 'package:raed_store/widgets/entryField.dart';

class ReceiveMoneyScreen extends StatefulWidget {
  const ReceiveMoneyScreen({Key? key}) : super(key: key);

  @override
  _ReceiveMoneyScreenState createState() => _ReceiveMoneyScreenState();
}

class _ReceiveMoneyScreenState extends State<ReceiveMoneyScreen> {
  bool isClientBalanceReceived = false;
  List<ClientResponse> agentsList = [];
  ClientResponse? selectedClientValue;
  String currentClientBalance = "0";

  TextEditingController paidAmountController = TextEditingController();

  @override
  void initState() {
    try {
      NetworkManager().getAgents().then((value) {
        agentsList = value;
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
        title: Text("cash_collection_receipt").tr(),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: isClientBalanceReceived
              ? Column(
                  children: [
                    _buildAppLogo(),
                    //       _buildScreenTitle(),
                    _buildAgentDropDownList(),
                    _buildCurrentBalanceRow(),
                    _buildPaidMoneyDataInputField(),
                    _buildSaveButton()
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }

  Widget _buildAppLogo() => Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
        child: const Text(
          "Raad_store",
          style: TextStyle(fontSize: 20),
        ).tr(),
      );

  // Widget _buildScreenTitle() => Container(
  //       alignment: Alignment.center,
  //       margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
  //       child: const Text("cash_collection_receipt").tr(),
  //     );

  Widget _buildAgentDropDownList() {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("agent".tr()),
          SizedBox(
            height: 10,
          ),
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                    color: Colors.yellow, style: BorderStyle.solid, width: 1.0),
              ),
              child: _buildDropdownButton()),
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
          child: Container(
              width: MediaQuery.of(context).size.width / 2,
              child: Center(child: Text(value.accName!))),
        );
      }).toList(),
      value: selectedClientValue,
      onChanged: (value) async {
        try {
          currentClientBalance =
              await NetworkManager().getClientBalance(value!.accNumber!);
        } on Exception catch (_, e) {
          _showErrorDialog(e);
        }
        setState(() {
          selectedClientValue = value;
        });

        if (kDebugMode) {
          print(value);
        }
      },
    );
  }

  Widget _buildCurrentBalanceRow() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Text("current_balance".tr()),
            const Spacer(),
            Text(currentClientBalance)
          ],
        ),
      );

  Widget _buildPaidMoneyDataInputField() => Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: TextField(
          decoration: InputDecoration(
            labelText: "paid_amount".tr(),
            labelStyle: TextStyle(color: Colors.black),
            enabledBorder: const OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.yellow, width: 1.0),
            ),
          ),
          keyboardType: TextInputType.number,
          controller: paidAmountController,

          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ], // Only numbers can be entered
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
      String response = await NetworkManager().saveMoney(SaveMoneyRequest(
          clinetId: selectedClientValue!.accNumber!,
          amount: paidAmountController.value.text,
          userId: 1,

          /// user id !!!!!
          notes: "Mobile"));
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text('Alert'),
                content: Text(response),
              ));
    } on Exception catch (_, e) {
      _showErrorDialog(e);
    }
  }

  void _showErrorDialog(StackTrace e) {
    var dialog = showDialog(
        context: context,
        builder: (_) => AlertDialog(
              actions: [
                ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("OK"))
              ],
              title: const Text('Error'),
              content: Text(e.toString()),
            ));
  }
}
