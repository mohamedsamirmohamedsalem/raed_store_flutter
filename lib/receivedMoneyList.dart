import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:raed_store/data/money_receive_list/recieve_money_list.dart';
import 'package:raed_store/network/network_manager.dart';

class ReceiveMoneyHistory extends StatefulWidget {
  const ReceiveMoneyHistory({Key? key}) : super(key: key);

  @override
  _ReceiveMoneyHistoryState createState() => _ReceiveMoneyHistoryState();
}

class _ReceiveMoneyHistoryState extends State<ReceiveMoneyHistory> {
  List<ReceiveMoneyListResponse> _receiveMoneyList = [];
  bool _isLoading = true;

  @override
  void initState() {
    NetworkManager().getReceiptList().then((value) {
      _receiveMoneyList = value!;
      setState(() {
        _isLoading = false;
      });
    }).catchError((error, stackTrace) {
      _showErrorDialog(null, errorMSG: error.toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.yellow,
        title: Text(
          "receipts".tr(),
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: _isLoading
          ? _buildProgressIndicator()
          : Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: ListView.builder(
                itemCount: _receiveMoneyList.length,
                itemBuilder: (context, index) => _buildRowItem(index),
              ),
            ),
    );
  }

  Card _buildRowItem(int index) {
    return Card(
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.yellow, width: 2.0),
            borderRadius: BorderRadius.circular(4.0)),
        color: Colors.white,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            trailing: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.print,
                  color: Colors.yellow,
                  size: 30,
                )),
            title: Column(
              children: [
                _buildRow_1(index),
                _buildRow_2(index),
                _buildRow_3(index),
                _buildRow_4(index),
                _buildRow_5(index),
              ],
            ),
          ),
        ));
  }

  Row _buildRow_1(int index) {
    return Row(
      children: [
        Text(
          "trans_num".tr() + ' : ' + (_receiveMoneyList[index].transId ?? ""),
          style: const TextStyle(fontSize: 12),
        ),
        const Spacer(),
        Text(
          "amount".tr() +
              ' : ' +
              (_receiveMoneyList[index].amount ?? 0).toString(),
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Row _buildRow_2(int index) {
    return Row(
      children: [
        Text(
          "trans_type".tr() +
              ' : ' +
              (_receiveMoneyList[index].transType ?? ""),
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Row _buildRow_3(int index) {
    return Row(
      children: [
        Text(
          "client".tr() + ' : ' + (_receiveMoneyList[index].clientName ?? ""),
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Row _buildRow_4(int index) {
    return Row(
      children: [
        Text(
          "date".tr() + ' : ' + (_receiveMoneyList[index].invoiceDate ?? ""),
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Row _buildRow_5(int index) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "comment".tr() + ' : ' + (_receiveMoneyList[index].notes ?? ""),
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  Center _buildProgressIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.yellow,
      ),
    );
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
}
