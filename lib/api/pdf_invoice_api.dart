import 'dart:io';
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:raed_store/api/pdf_api.dart';
import 'package:raed_store/data/Invoice/invoice_response.dart';
import 'package:raed_store/data/base/base_print_doc.dart';
import 'package:raed_store/data/print_receive_money/print_receive_money_response.dart';

class PdfInvoiceApi {
  static Future<Uint8List> _readFontData() async {
    final ByteData bytes = await rootBundle.load('assets/fonts/arial.ttf');
    return bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  }

  static Future<File> generate(BasePrintDoc invoice) async {
    final pdf = Document();
    final Uint8List fontData = await _readFontData();
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());
    pdf.addPage(MultiPage(
      theme: ThemeData.withFont(
        base: ttf,
      ),
      
      build: (context) => invoiceItems(invoice, ttf),
      footer: (context) => buildFooter(invoice, ttf),
    ));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static List<pw.Widget> invoiceItems(BasePrintDoc invoice, pw.Font ttf) {
    if (invoice is InvoiceResponse) {
      return [
        pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: buildHeader(invoice, ttf)),
        SizedBox(height: 3 * PdfPageFormat.cm),
        pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: buildTitle(invoice, ttf)),
        pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: buildInvoice(invoice, ttf)),
        Divider(),
        pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: buildTotal(invoice, ttf)),
      ];
    } else if (invoice is PrintReceiveMoneyResponse) {
      return [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Center(
                child: Text(invoice.transTrpeName ?? "",
                    style: pw.TextStyle(
                        font: ttf, fontSize: 24, fontWeight: FontWeight.bold),
                    textDirection: pw.TextDirection.rtl),
              ),
            ),
            SizedBox(height: 0.8 * PdfPageFormat.cm),
            pw.Column(children: [
              Text(invoice.companyName ?? "",
                  style: pw.TextStyle(font: ttf, fontWeight: FontWeight.bold),
                  textDirection: pw.TextDirection.rtl),
              Text(invoice.companyAddress ?? "",
                  style: pw.TextStyle(font: ttf, fontWeight: FontWeight.bold),
                  textDirection: pw.TextDirection.rtl),
              Text(invoice.companyPhone1 ?? "",
                  style: pw.TextStyle(font: ttf),
                  textDirection: pw.TextDirection.rtl),
              Text(invoice.companyPhone2 ?? "",
                  style: pw.TextStyle(font: ttf),
                  textDirection: pw.TextDirection.rtl),
            ]),
             SizedBox(height: 3.0 * PdfPageFormat.cm),
            buildReceiveMoneyInfo(invoice, ttf),
          ],
        ),
      ];
    } else {
      return [];
    }
  }

  static Widget buildHeader(InvoiceResponse invoice, pw.Font ttf) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSupplierAddress(invoice, ttf),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(invoice, ttf),
              buildInvoiceInfo(invoice, ttf),
            ],
          ),
        ],
      );

  static Widget buildCustomerAddress(InvoiceResponse invoice, pw.Font ttf) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(invoice.clinetName ?? "",
              style: pw.TextStyle(font: ttf, fontWeight: FontWeight.bold),
              textDirection: pw.TextDirection.rtl),
          Text(invoice.phone1 ?? "",
              style: pw.TextStyle(font: ttf),
              textDirection: pw.TextDirection.rtl),
          Text(invoice.phone2 ?? "",
              style: pw.TextStyle(font: ttf),
              textDirection: pw.TextDirection.rtl),
        ],
      );

  static Widget buildInvoiceInfo(InvoiceResponse invoice, pw.Font ttf) {
    final titles = <String>[
      'invoice_number'.tr() + " : ",
      'date'.tr() + " : ",
      'client_name'.tr() + " : ",
      'invoice_type'.tr() + " : ",
      'account_balance_before'.tr() + " : ",
      'account_balance_after'.tr() + " : "
    ];
    final data = <String>[
      invoice.transId ?? "",
      invoice.invoiceDate ?? "",
      invoice.clinetName ?? "",
      (invoice.transTypeId ?? 0).toString(),
      invoice.accountBalanceBefore ?? "",
      invoice.accountBalanceAfter ?? ""
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(
          title: title,
          value: value,
          width: 200,
          ttf: ttf,
        );
      }),
    );
  }

  static Widget buildSupplierAddress(
          InvoiceResponse invoiceResponse, pw.Font ttf) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(invoiceResponse.providerName ?? "",
              style: pw.TextStyle(font: ttf, fontWeight: FontWeight.bold),
              textDirection: pw.TextDirection.rtl),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(invoiceResponse.providerPhone ?? "",
              style: pw.TextStyle(
                font: ttf,
              ),
              textDirection: pw.TextDirection.rtl),
        ],
      );

  static Widget buildTitle(InvoiceResponse invoice, pw.Font ttf) => Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        mainAxisAlignment: pw.MainAxisAlignment.end,
        children: [
          Text('invoice'.tr(),
              style: pw.TextStyle(
                  font: ttf, fontSize: 24, fontWeight: FontWeight.bold),
              textDirection: pw.TextDirection.rtl),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text(invoice.comment ?? "",
              style: pw.TextStyle(font: ttf),
              textDirection: pw.TextDirection.rtl),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(InvoiceResponse invoice, pw.Font ttf) {
    final headers = [
      'item_id'.tr(),
      'item_name'.tr(),
      'package_name'.tr(),
      'price'.tr(),
      'quantity'.tr(),
      'total'.tr()
    ];
    var data = invoice.lstTransDetailsModel!.map((element) {
      return [
        element.itemId ?? "",
        element.itemName ?? "",
        element.packageName ?? "",
        element.amount ?? "",
        element.qty ?? "",
        element.totalItemAmount ?? "",
      ];
    }).toList();

    return pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: Table.fromTextArray(
          headers: headers,
          data: data,
          border: null,
          cellStyle: pw.TextStyle(font: ttf, fontWeight: FontWeight.bold),
          headerStyle: pw.TextStyle(font: ttf, fontWeight: FontWeight.bold),
          headerDecoration: BoxDecoration(color: PdfColors.grey300),
          cellHeight: 30,
          cellAlignments: {
            0: Alignment.centerLeft,
            1: Alignment.centerRight,
            2: Alignment.centerRight,
            3: Alignment.centerRight,
            4: Alignment.centerRight,
            5: Alignment.centerRight,
          },
        ));
  }

  static Widget buildTotal(InvoiceResponse invoice, pw.Font ttf) {
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: "total".tr(),
                  value: (invoice.totalInvoiceAmount ?? 0.0).toString(),
                  unite: true,
                  ttf: ttf,
                ),
                buildText(
                  title: "discount".tr(),
                  value: (invoice.discountValue ?? 0.0).toString(),
                  unite: true,
                  ttf: ttf,
                ),
                Divider(),
                buildText(
                  title: "price".tr(),
                  ttf: ttf,
                  titleStyle: pw.TextStyle(
                    font: ttf,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: (invoice.net ?? 0.0).toString(),
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(BasePrintDoc invoice, pw.Font ttf) {
    if (invoice is PrintReceiveMoneyResponse) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(
              title: '', value: invoice.thanksComment ?? "", ttf: ttf),
        ],
      );
    } else if (invoice is InvoiceResponse) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(
              title: '', value: invoice.providerName ?? "", ttf: ttf),
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(
              title: '', value: invoice.companyName ?? "", ttf: ttf),
          //  SizedBox(height: 1 * PdfPageFormat.mm),
          // buildSimpleText(title: '', value: invoice??""),
        ],
      );
    } else {
      return Container();
    }
  }

  static buildSimpleText(
      {required String title, required String value, Font? ttf}) {
    final style = pw.TextStyle(font: ttf, fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style, textDirection: pw.TextDirection.rtl),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value, style: style, textDirection: pw.TextDirection.rtl),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
    Font? ttf,
  }) {
    final style =
        titleStyle ?? pw.TextStyle(font: ttf, fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        mainAxisAlignment: pw.MainAxisAlignment.end,
        children: [
          Text(value, style: style, textDirection: pw.TextDirection.rtl),
          Text(title + " : ",
              style: style, textDirection: pw.TextDirection.rtl),
        ],
      ),
    );
  }

  static Widget buildReceiveMoneyInfo(
      PrintReceiveMoneyResponse invoice, pw.Font ttf) {
    final titles = <String>[
      'invoice_number'.tr() + " : ",
      'date'.tr() + " : ",
      'current_balance'.tr() + " : ",
      'amount'.tr() + " : ",
      'amount_only'.tr() + " : ",
      'from_account'.tr() + " : ",
      'to_account'.tr() + " : ",
    ];
    final data = <String>[
      invoice.transId ?? "",
      invoice.transDate ?? "",
      invoice.currentBalance ?? "",
      (invoice.amount ?? 0).toString(),
      invoice.amountOnly ?? "",
      invoice.fromAccount ?? "",
      invoice.toAccount ?? ""
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(
          title: title,
          value: value,
          width: 200,
          ttf: ttf,
        );
      }),
    );
  }
}
