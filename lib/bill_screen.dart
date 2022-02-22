import 'dart:core';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:raed_store/data/client/clientResponse.dart';
import 'package:raed_store/data/get_items_by_id/response.dart';
import 'package:raed_store/data/save_invoice/request.dart';
import 'package:raed_store/data/save_invoice/response.dart';
import 'package:raed_store/network/network_manager.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class BillScreen extends StatefulWidget {
  BillType? billType;

  BillScreen({Key? key, @required this.billType}) : super(key: key);

  @override
  _BillScreenState createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  bool _isClientBalanceReceived = false;
  bool _isBillSaved = true;

  // Clients
  List<ClientResponse> _agentsList = [];
  ClientResponse? _selectedClientValue;

  // Items
  List<GetItemWithBalanceByIdResponse> _itemsList = [];
  GetItemWithBalanceByIdResponse? _currentSelectedItem;
  TextEditingController _itemsQuantityController = TextEditingController();

  // bill Details
  List<LstTransDetailsModel> _billRecords = [];

  // received Money Text Field
  TextEditingController _receivedMoneyController = TextEditingController();

  // total amount
  double totalAmount = 0;
  double totalDiscount = 0;
  double totalAmountAfterDiscount = 0;

  //
  final pdf = pw.Document();

  @override
  void initState() {
    try {
      NetworkManager().getAgents().then((value) {
        _agentsList = value;
        NetworkManager().getItemWithBalance("1").then((value) {
          _itemsList = value;
          _currentSelectedItem = _itemsList[0];
          setState(() {
            _isClientBalanceReceived = true;
          });
        });
      });
    } on Exception catch (_, e) {
      setState(() {
        _isClientBalanceReceived = true;
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
        title: Text(
          widget.billType == BillType.saleBill
              ? "sale_bill".tr()
              : "return_bill".tr(),
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: _isClientBalanceReceived
          ? Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildClientArea(),
                      _buildItemsCard(),
                      _buildBillDetailsCard(),
                      _buildMoneyReceivedEntryField(),
                      _buildSavePrintButton()
                    ],
                  ),
                ),
                _isBillSaved
                    ? Container()
                    : const Center(
                        child: CircularProgressIndicator(
                          color: Colors.yellow,
                        ),
                      )
              ],
            )
          : const Center(
              child: CircularProgressIndicator(
                color: Colors.yellow,
              ),
            ),
    );
  }

  Widget _buildClientArea() {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("agent".tr()),
          const SizedBox(
            height: 10,
          ),
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                    color: Colors.yellow, style: BorderStyle.solid, width: 2.0),
              ),
              child: _buildDropdownButton()),
        ],
      ),
    );
  }

  DropdownButton<ClientResponse> _buildDropdownButton() {
    return DropdownButton<ClientResponse>(
      underline: Container(),
      items: _agentsList.map((ClientResponse value) {
        return DropdownMenuItem<ClientResponse>(
          value: value,
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: Center(
              child: Text(value.accName!),
            ),
          ),
        );
      }).toList(),
      value: _selectedClientValue,
      onChanged: (value) async {
        setState(() {
          _selectedClientValue = value;
        });
      },
    );
  }

  Widget _buildItemsCard() {
    return _selectedClientValue == null
        ? Container()
        : Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            //shape: ,
            child: Column(
              children: [
                _buildItemsDropDown(),
                _buildQuantityEntryField(),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.yellow),
                      ),
                      onPressed: () {
                        if (_itemsQuantityController.value.text.isNotEmpty) {
                          _billRecords.add(LstTransDetailsModel(
                              itemId: _currentSelectedItem!.itemId!,
                              itemIdId: _currentSelectedItem!.itemIdId!,
                              qtyInpackage: _currentSelectedItem!.qtyInpackage!,
                              qty: int.parse(
                                  _itemsQuantityController.value.text),
                              itemUnitId: _currentSelectedItem!.ItemUnitId!,
                              amount: _currentSelectedItem!.amount!,
                              totalItemAmount: int.parse(
                                      _itemsQuantityController.value.text) *
                                  _currentSelectedItem!.amount!,
                              itemName: _currentSelectedItem!.itemName!,
                              itemAmountBuy:
                                  _currentSelectedItem!.itemAmountBuy));
                          totalAmount = 0;
                          for (var e in _billRecords) {
                            totalAmount += e.totalItemAmount ?? 0;
                          }
                          totalDiscount = totalAmount *
                              _selectedClientValue!.customrtInvoiceDiscount!;
                          totalAmountAfterDiscount =
                              totalAmount - totalDiscount;
                          _itemsQuantityController = TextEditingController();
                          setState(() {});
                        } else {
                          _showErrorDialog(null,
                              errorMSG: "please_enter_quantity".tr());
                        }
                      },
                      child: const Text(
                        "add",
                        style: TextStyle(color: Colors.black),
                      ).tr()),
                )
              ],
            ),
          );
  }

  Widget _buildBillDetailsCard() => Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: _billRecords.isEmpty
                ? Container()
                : Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Text("bill_details".tr())),
          ),
          Card(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              elevation: 5,
              child: _billRecords.isEmpty
                  ? Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      alignment: Alignment.center,
                      child: Text("bill_details".tr()),
                    )
                  : Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 300,
                            child: ListView.builder(
                              itemCount: _billRecords.length,
                              itemBuilder: (context, i) => Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    height: 100,
                                    child: Row(
                                      // alignment: Alignment.topRight,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                _billRecords[i].itemName ?? ""),
                                            Text("price".tr() +
                                                    _billRecords[i]
                                                        .amount
                                                        .toString() ??
                                                ""),
                                            Text("total".tr() +
                                                    _billRecords[i]
                                                        .totalItemAmount
                                                        .toString() ??
                                                "")
                                          ],
                                        ),
                                        Spacer(),
                                        IconButton(
                                            onPressed: () => setState(() {
                                                  _billRecords.removeAt(i);
                                                }),
                                            icon: const Icon(
                                              Icons.cancel,
                                              color: Colors.red,
                                            )),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      color: Colors.yellow,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text("price".tr() + totalAmount.toString()),
                          const SizedBox(
                            height: 2,
                          ),
                          Text("discount".tr() + totalDiscount.toString()),
                          const SizedBox(
                            height: 2,
                          ),
                          Text("total".tr() +
                                  totalAmountAfterDiscount.toString() ??
                              "")
                        ],
                      ),
                    )),
        ],
      );

  Widget _buildMoneyReceivedEntryField() => Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
          controller: _receivedMoneyController,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ], // Only numbers can be entered
        ),
      );

  Widget _buildSavePrintButton() => Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.yellow),
          ),
          onPressed: () async {
            if (_receivedMoneyController.value.text.isNotEmpty) {
              setState(() {
                _isBillSaved = false;
              });
              try {
                SaveInvoiceResponse response = await NetworkManager()
                    .saveInvoice(
                        widget.billType!,
                        SaveInvoiceRequest(
                            comment: "Mobile",
                            transTypeId:
                                widget.billType == BillType.saleBill ? 2 : 3,
                            lstTransDetailsModel: _billRecords,
                            discountValue: totalDiscount.toString(),
                            net: totalAmount.toString(),
                            paid: _receivedMoneyController.value.text,
                            customrtInvoiceDiscount:
                                _selectedClientValue?.customrtInvoiceDiscount ??
                                    0.0,
                            clientId: int.parse(
                                _selectedClientValue?.accNumber ?? "0"),
                            totalInvoiceAmount:
                                totalAmountAfterDiscount.toString()));
                _showErrorDialog(null, errorMSG: response.message.toString());
                _isBillSaved = true;
                totalAmountAfterDiscount = 0;
                totalAmount = 0;
                totalDiscount = 0;
                _billRecords = [];
                _receivedMoneyController = TextEditingController();
                pdf.addPage(pw.Page(
                    pageFormat: PdfPageFormat.a4,
                    build: (pw.Context context) {
                      return pw.Center(
                        child: pw.Text("Hello World"),
                      ); // Center
                    })); // Page
              } on Exception catch (_, e) {
                _isClientBalanceReceived = true;
                _showErrorDialog(e);
              }
            } else {
              _showErrorDialog(null,
                  errorMSG: "please_enter_received_Money".tr());
            }
          },
          child: const Text(
            "save_print",
            style: TextStyle(color: Colors.black),
          ).tr(),
        ),
      );

  void _showErrorDialog(StackTrace? e, {String errorMSG = ""}) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              actions: [
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.yellow),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("ok").tr())
              ],
              title: Text('alert'.tr()),
              content: Text(e != null ? e.toString() : errorMSG),
            ));
  }

  Widget _buildItemsDropDown() => Row(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(
                  color: Colors.yellow, style: BorderStyle.solid, width: 2.0),
            ),
            child: DropdownButton<GetItemWithBalanceByIdResponse>(
                underline: Container(),
                items: _itemsList.map((GetItemWithBalanceByIdResponse value) {
                  return DropdownMenuItem<GetItemWithBalanceByIdResponse>(
                    value: value,
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Center(child: Text(value.itemName ?? ""))),
                  );
                }).toList(),
                value: _currentSelectedItem,
                onChanged: (value) async {
                  setState(() {
                    _currentSelectedItem = value;
                  });
                }),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                      "price".tr() + _currentSelectedItem!.amount!.toString())))
        ],
      );

  Widget _buildQuantityEntryField() => Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: TextField(
          textAlign: TextAlign.center,

          cursorColor: Colors.yellow,
          decoration: InputDecoration(
            labelText: "quantity".tr(),
            labelStyle: const TextStyle(color: Colors.black),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow, width: 2.0)),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.yellow, width: 2.0),
            ),
          ),
          keyboardType: TextInputType.number,
          controller: _itemsQuantityController,

          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ], // Only numbers can be entered
        ),
      );
}

enum BillType { saleBill, returnBill }
