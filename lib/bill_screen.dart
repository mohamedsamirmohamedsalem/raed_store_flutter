// ignore_for_file: deprecated_member_use

import 'dart:core';

import 'package:easy_localization/easy_localization.dart' as localized;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:raed_store/data/Invoice/invoice_response.dart';
import 'package:raed_store/data/client/clientResponse.dart';
import 'package:raed_store/data/get_items_by_id/response.dart';
import 'package:raed_store/data/save_invoice/request.dart' as invoiceRequest;
import 'package:raed_store/data/save_invoice/response.dart';
import 'package:raed_store/helper/bill_pdf.dart';
import 'package:raed_store/network/network_manager.dart';

class BillScreen extends StatefulWidget {
  BillType? billType;

  BillScreen({Key? key, @required this.billType}) : super(key: key);

  @override
  _BillScreenState createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  bool _isClientBalanceReceived = false;
  bool _isLoading = true;
  // Clients
  List<ClientResponse> _agentsList = [];
  ClientResponse? _selectedClientValue;

  // Items
  List<GetItemWithBalanceByIdResponse> _itemsList = [];
  GetItemWithBalanceByIdResponse? _currentSelectedItem;
  TextEditingController _itemsQuantityController = TextEditingController();
  var focusNode = FocusNode();

  // bill Details
  List<invoiceRequest.LstTransDetailsModel> _billRecords = [];

  // received Money Text Field
  TextEditingController _receivedMoneyController = TextEditingController();

  // total amount
  double totalAmount = 0;
  double totalDiscount = 0;
  double totalAmountAfterDiscount = 0;

  // print bill
  SaveInvoiceResponse? saveInvoiceResponse;

  @override
  void initState() {
    try {
      NetworkManager().getAgents().then((value) {
        _agentsList = value!;
        NetworkManager().getItemWithBalance("1").then((value) {
          _itemsList = value ?? [];
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
        actions: [
          TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.all(5)),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: const BorderSide(
                    width: 2.0,
                    color: Color.fromARGB(255, 126, 126, 35),
                  ),
                ),
              ),
            ),
            onPressed: (() => _onsaveBillPressed()),
            child: const Text(
              "save_print",
              style: TextStyle(color: Colors.black),
            ).tr(),
          )
        ],
        iconTheme: const IconThemeData(color: Colors.black),
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
                      const SizedBox(
                        height: 10,
                      ),
                      _buildTotalAmountRow(),
                      const SizedBox(
                        height: 10,
                      ),
                      _buildClientArea(),
                      _buildItemsCard(),
                      _buildBillDetailsCard(),
                      _buildTotals(),
                      //  _buildSavePrintButton()
                    ],
                  ),
                ),
                _isLoading
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
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Text("agent".tr()),
          // const SizedBox(
          //   height: 10,
          // ),
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                    color: Colors.yellow, style: BorderStyle.solid, width: 2.0),
              ),
              child: _buildDropdownButton()),
          Spacer(),
          _selectedClientValue != null
              ? ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.yellow),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(0))
                  ),
                  onPressed: (() => _callBalanceAPI()),
                  child: Text(
                    'show_balance'.tr(),
                    style: const TextStyle(color: Colors.black),
                  ))
              : Container(),
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
        _resetCells();
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
              ],
            ),
          );
  }

  Container _buildAddItemButton() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.yellow),
          ),
          onPressed: () {
            if (_isBillListHasSelectedItem()) {
              _showErrorDialog(null, errorMSG: "item_already_added".tr());
              return;
            } else if (_itemsQuantityController.value.text.isNotEmpty &&
                double.parse(_itemsQuantityController.value.text) != 0) {
              _billRecords.add(invoiceRequest.LstTransDetailsModel(
                  itemId: _currentSelectedItem!.itemId!,
                  itemIdId: _currentSelectedItem!.itemIdId!,
                  qtyInpackage: _currentSelectedItem!.qtyInpackage!,
                  itemUnitName: _currentSelectedItem!.itemUnitName,
                  qty: double.parse(_itemsQuantityController.value.text),
                  itemUnitId: _currentSelectedItem!.itemUnitId!,
                  amount: _currentSelectedItem!.amount!,
                  totalItemAmount:
                      double.parse(_itemsQuantityController.value.text) *
                          _currentSelectedItem!.amount!,
                  itemName: _currentSelectedItem!.itemName!,
                  itemAmountBuy: _currentSelectedItem!.itemAmountBuy));
              totalAmount = 0;
              for (var e in _billRecords) {
                totalAmount += e.totalItemAmount ?? 0;
              }
              totalDiscount = totalAmount *
                  (_selectedClientValue?.customrtInvoiceDiscount ?? 0.0) /
                  100;
              totalAmountAfterDiscount = totalAmount - totalDiscount;
              _itemsQuantityController.clear();
              setState(() {});
            } else {
              _showErrorDialog(null, errorMSG: "please_enter_quantity".tr());
            }
          },
          child: const Text(
            "add",
            style: TextStyle(color: Colors.black),
          ).tr()),
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
                              itemBuilder: (context, i) {
                                return _buildItemRecondInList(i);
                              },
                            ),
                          ),
                        ],
                      ),
                    )),
        ],
      );

  Widget _buildItemRecondInList(int index) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 100,
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width-100,
                      child: SizedBox(
                         width: MediaQuery.of(context).size.width-70,
                        child: Row(
                          children: [
                            Text(_billRecords[index].itemUnitName ?? ""),
                            const SizedBox(
                              width: 20,
                            ),
                            SizedBox(width: 150,
                              child: Text(
                                _billRecords[index].itemName ?? "",maxLines: 2,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () => _onCancelItemPressed(index),
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    SizedBox(
                        width: MediaQuery.of(context).size.width-70,
                      child: Row(
                        children: [
                          Text("quantity".tr() +
                              ' : ' +
                              (_billRecords[index].qty ?? 0)
                                  .toStringAsFixed(2)),
                                  Spacer(),
                          Text("price".tr() +
                              ' : ' +
                              (_billRecords[index].amount ?? 0)
                                  .toStringAsFixed(2)),
                                  Spacer(),
                          Text("total".tr() +
                              ' : ' +
                              (_billRecords[index].totalItemAmount ?? 0)
                                  .toStringAsFixed(2))
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 2,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              color: Colors.yellow,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMoneyReceivedEntryField() => Container(
        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        width: 150,
        // height: 60,
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
          // inputFormatters: <TextInputFormatter>[
          //   FilteringTextInputFormatter.digitsOnly
          // ], // Only numbers can be entered
        ),
      );

  Widget _buildSavePrintButton() => Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.yellow),
          ),
          onPressed: () async {
            await _onsaveBillPressed();
          },
          child: const Text(
            "save_print",
            style: TextStyle(color: Colors.black),
          ).tr(),
        ),
      );

  Future<void> _onsaveBillPressed() async {
    if (_receivedMoneyController.value.text.isNotEmpty &&
        double.parse(_receivedMoneyController.value.text) != 0) {
      setState(() {
        _isLoading = false;
      });
      try {
        saveInvoiceResponse = await NetworkManager().saveInvoice(
            widget.billType!,
            invoiceRequest.SaveInvoiceRequest(
                comment: "Mobile",
                transTypeId: widget.billType == BillType.saleBill ? 2 : 3,
                lstTransDetailsModel: _billRecords,
                discountValue: totalDiscount.toString(),
                net: totalAmount.toString(),
                paid: _receivedMoneyController.value.text,
                customrtInvoiceDiscount:
                    _selectedClientValue?.customrtInvoiceDiscount ?? 0.0,
                clientId: int.parse(_selectedClientValue?.accNumber ?? "0"),
                totalInvoiceAmount: totalAmountAfterDiscount.toString()));
        if (saveInvoiceResponse?.satatus != "NotSaved") {
          _resetCells();
        }
        _showErrorDialog(
          null,
          errorMSG: saveInvoiceResponse!.message.toString(),
          // onPostivePressed: _printInvoice,
        );
      } on Exception catch (_, e) {
        _isClientBalanceReceived = true;
        _showErrorDialog(e);
      }
    } else {
      _showErrorDialog(null, errorMSG: "please_enter_received_Money".tr());
    }
  }

  void _resetCells() {
    setState(() {
      _isLoading = true;
      totalAmountAfterDiscount = 0;
      totalAmount = 0;
      totalDiscount = 0;
      _billRecords = [];
      _receivedMoneyController.clear();
    });
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
                  FocusScope.of(context).requestFocus(focusNode);
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
                  child: Text("price".tr() +
                      ' : ' +
                      (_currentSelectedItem?.amount ?? 0)
                          .toStringAsFixed(2))))
        ],
      );

  Widget _buildQuantityEntryField() => Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Row(
          children: [
            SizedBox(
              width: 200,
              child: TextField(
                textAlign: TextAlign.center,
                focusNode: focusNode,
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

                // inputFormatters: <TextInputFormatter>[
                //   FilteringTextInputFormatter.digitsOnly
                // ], // Only numbers can be entered
              ),
            ),
            const Spacer(),
            _buildAddItemButton()
          ],
        ),
      );

  void _onCancelItemPressed(int index) {
    final itemToRemove = _billRecords[index];
    totalAmount -= itemToRemove.totalItemAmount!;
    totalDiscount = totalAmount *
        (_selectedClientValue?.customrtInvoiceDiscount ?? 0.0) /
        100;
    totalAmountAfterDiscount = totalAmount - totalDiscount;
    setState(() {
      _billRecords.removeAt(index);
    });
  }

  Widget _buildTotalAmountRow() => Container(
    height: 110,
    child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Text(
                    "bill_total".tr() +
                        ' : ' +
                        totalAmount.toStringAsFixed(2),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Text(
                    "discount".tr() + " : " + totalDiscount.toStringAsFixed(2),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Text(
                    "net".tr() +
                        " : " +
                        totalAmountAfterDiscount.toStringAsFixed(2),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                _buildMoneyReceivedEntryField(),
              ],
            ),
          ],
        ),
  );

  void _printInvoice() async {
    Navigator.of(context).pop();
    setState(() {
      _isLoading = false;
    });
    try {
      if (saveInvoiceResponse!.transId == null) {
        throw Exception("cannot_find_transaction_number".tr());
      } else {
        InvoiceResponse? response =
            await NetworkManager().printInvoice(saveInvoiceResponse!.transId!);
        setState(() {
          _isLoading = true;
        });
        PDFGeneratorHelper(response!).generatePDF();
      }
    } on Exception catch (_, e) {
      _showErrorDialog(e);
    }
  }

  Future<void> _callBalanceAPI() async {
    try {
      setState(() {
        _isLoading = false;
      });
      var currentClientBalance = await NetworkManager()
          .getClientBalance(_selectedClientValue!.accNumber!);
      setState(() {
        _isLoading = true;
      });
      _showErrorDialog(null,
          errorMSG: '${"current_balance".tr()} : $currentClientBalance');
    } on Exception catch (_, e) {
      _showErrorDialog(e);
    }
  }

  Widget _buildTotals() => Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Text("total_items".tr() + " : " + _getTotalItems()),
          const Spacer(),
          Text("total_quantity".tr() + " : " + _getTotalQuantity()),
        ],
      ));

  String _getTotalItems() {
    int counter = 0;
    for (var itemElement in _itemsList) {
      for (var billElement in _billRecords) {
        if (itemElement.itemName == billElement.itemName) {
          counter++;
          break;
        }
      }
    }
    return counter.toString();
  }

  String _getTotalQuantity() {
    double quantity = 0;
    for (var element in _billRecords) {
      quantity += element.qty ?? 0.0;
    }
    return quantity.toStringAsFixed(2);
  }

  bool _isBillListHasSelectedItem() {
    for (var element in _billRecords) {
      if (element.itemIdId == (_currentSelectedItem?.itemIdId ?? -1)) {
        return true;
      }
    }
    return false;
  }
}

enum BillType { saleBill, returnBill }
