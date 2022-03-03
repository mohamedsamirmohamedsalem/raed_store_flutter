import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:raed_store/api/pdf_invoice_api.dart';
import 'package:raed_store/constants/routes.dart';
import 'package:raed_store/data/Invoice/invoice_list_response.dart';
import 'package:raed_store/data/Invoice/invoice_response.dart';
import 'package:raed_store/helper/bill_pdf.dart';
import 'package:raed_store/main.dart';
import 'package:raed_store/network/network_manager.dart';
import 'package:raed_store/utils/navigation/navigation.dart';

class InvoicesHistoryScreen extends StatefulWidget {
  InvoicesHistoryScreen({Key? key}) : super(key: key);

  @override
  State<InvoicesHistoryScreen> createState() => _InvoicesHistoryScreenState();
}

class _InvoicesHistoryScreenState extends State<InvoicesHistoryScreen> {
  List<InoviceListResponse> _invoicesList = [];
  bool _isLoading = true;
  bool _isLoadingAbove = false;
  @override
  void initState() {
    NetworkManager().getInvoiceList().then((value) {
      _invoicesList = value ?? [];
      setState(() {
        _isLoading = false;
      });
    }).catchError((error, stackTrace) {
      setState(() {
        _isLoading = false;
      });
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
          "invoice_history".tr(),
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          _isLoading
              ? _buildProgressIndicator()
              : Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: ListView.builder(
                    itemCount: _invoicesList.length,
                    itemBuilder: (context, index) => _buildRowItem(index),
                  ),
                ),
          _isLoadingAbove ? _buildProgressIndicator() : Container()
        ],
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
                onPressed: () => _callPrintAPI(_invoicesList[index].transId),
                icon: const Icon(
                  Icons.print,
                  color: Colors.yellow,
                  size: 30,
                )),
            title: Column(
              children: [
                _buildRow_1(index),
                _buildSplit(),
                _buildRow_2(index),
                _buildSplit(),
                _buildRow_3(index),
                _buildSplit(),
                _buildRow_4(index),
                _buildSplit(),
                _buildRow_5(index),
              ],
            ),
          ),
        ));
  }

  Center _buildProgressIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.yellow,
      ),
    );
  }

  Row _buildRow_1(int index) {
    return Row(
      children: [
        Text(
          "trans_num".tr() + ' : ' + (_invoicesList[index].transId ?? ""),
          style: const TextStyle(fontSize: 12),
        ),
        const Spacer(),
        Text(
          "bill_total".tr() +
              ' : ' +
              (_invoicesList[index].totalInvoice ?? 0).toString(),
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
              (_invoicesList[index].transTypeName ?? ""),
          style: const TextStyle(fontSize: 12),
        ),
        const Spacer(),
        Text(
          "discount".tr() +
              ' : ' +
              (_invoicesList[index].discountValue ?? 0).toString(),
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Row _buildRow_3(int index) {
    return Row(
      children: [
        Text(
          "client".tr() + ' : ' + (_invoicesList[index].clientName ?? ""),
          style: const TextStyle(fontSize: 12),
        ),
        const Spacer(),
        Text(
          "net".tr() + ' : ' + (_invoicesList[index].net ?? 0).toString(),
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Row _buildRow_4(int index) {
    return Row(
      children: [
        Text(
          "date".tr() + ' : ' + (_invoicesList[index].invoiceDate ?? ""),
          style: const TextStyle(fontSize: 12),
        ),
        const Spacer(),
        Text(
          "paid".tr() + ' : ' + (_invoicesList[index].paid ?? 0).toString(),
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
            "comment".tr() + ' : ' + (_invoicesList[index].notes ?? ""),
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
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

  Widget _buildSplit() => const SizedBox(
        height: 1,
      );

  Future<void> _callPrintAPI(String? transId) async {
    setState(() {
      _isLoadingAbove = true;
    });
    try {
      if (transId == null) {
        throw Exception("cannot_find_transaction_number".tr());
      } else {
        InvoiceResponse? response =
            await NetworkManager().printInvoice(transId);
        setState(() {
          _isLoadingAbove = false;
        });
        PdfInvoiceApi.generate(response!).then((value) {
          //PdfApi.openFile(value);
          Navigation(navigationKey: navigatorKey)
              .navigateTo(routeName: RoutesNames.pdfPrinterScreen, arg: value);
        });
      }
    } on Exception catch (_, e) {
      _showErrorDialog(e);
    }
  }
}
