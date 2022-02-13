import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:raed_store/network/network_manager.dart';

class ReceiveMoneyScreen extends StatefulWidget {
  const ReceiveMoneyScreen({Key? key}) : super(key: key);

  @override
  _ReceiveMoneyScreenState createState() => _ReceiveMoneyScreenState();
}

class _ReceiveMoneyScreenState extends State<ReceiveMoneyScreen> {
  bool isClientBalanceReceived = false;
  String clientBalance = "0";
  var agentsList = ["agent 1", "agent 2", "agent 3"];
  String selectedValue="0";

  @override
  void initState() {
    selectedValue =agentsList[0];
    NetworkManager().getClientBalance("1003").then((value) {
      clientBalance = value;
      setState(() {
        isClientBalanceReceived = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: isClientBalanceReceived
            ? Column(
                children: [
                  _buildAppLogo(),
                  _buildScreenTitle(),
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
    );
  }

  Widget _buildAppLogo() => Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
        child: const Text("Raad_store").tr(),
      );

  Widget _buildScreenTitle() => Container(
    alignment: Alignment.center,
    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    child: const Text("cash_collection_receipt").tr(),
  );

  Widget _buildAgentDropDownList() {

  return  Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("agent".tr()),
          _buildDropdownButton(),
        ],
      ),
    );
  }

  DropdownButton<String> _buildDropdownButton() {
    return DropdownButton<String>(
      items: agentsList.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Container(width: MediaQuery.of(context).size.width/2,child: Center(child: Text(value))),
        );
      }).toList(),
      value: selectedValue,
      onChanged: (value) {
        setState(() {
          selectedValue=value.toString();
        });

        if (kDebugMode) {
          print(value);
        }
      },
    );
  }

  Widget _buildCurrentBalanceRow() => Container(
        child: Row(
          children: [
            Text("current_balance".tr()),
            const Spacer(),
            Text("maddin".tr()),
            Text(clientBalance)
          ],
        ),
      );

  Widget _buildPaidMoneyDataInputField() => Container();

  Widget _buildSaveButton() => Container();
}
