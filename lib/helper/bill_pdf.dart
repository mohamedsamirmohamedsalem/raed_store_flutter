import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:raed_store/data/Invoice/invoice_response.dart';
import 'package:raed_store/helper/file_saver_helper.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PDFGeneratorHelper {
  final InvoiceResponse _invoiceResponse = InvoiceResponse();

  PDFGeneratorHelper();

  Future<void> generateInvoicePDF() async {
    //Create a PDF document.
    final PdfDocument document = PdfDocument();
    //Add page to the PDF
    final PdfPage page = document.pages.add();
    //Get page client size
    final Size pageSize = page.getClientSize();
    //Draw rectangle
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
        pen: PdfPen(PdfColor(142, 170, 219, 255)));
    //Generate PDF grid.
    final PdfGrid grid = _getGrid();
    //Draw the header section by creating text element
    final PdfLayoutResult result = await _drawHeader(page, pageSize, grid);
    //Draw grid
    _drawGrid(page, grid, result);
    //Add invoice footer
    _drawFooter(page, pageSize);
    //Save and dispose the document.
    final List<int> bytes = document.save();
    document.dispose();
    //Launch file.
    await FileSaveHelper.saveAndLaunchFile(bytes, 'Invoice.pdf');
  }

  //Draws the invoice header
  Future<PdfLayoutResult> _drawHeader(
      PdfPage page, Size pageSize, PdfGrid grid) async {
    var font = await _getFont();
    //Draw rectangle
    page.graphics.drawRectangle(
        brush: PdfSolidBrush(PdfColor(91, 126, 215, 255)),
        bounds: Rect.fromLTWH(0, 0, pageSize.width - 115, 90));
    //Draw string
    page.graphics.drawString('invoice'.tr(), font,
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(25, 0, pageSize.width - 115, 90),
        format: _stringFormat());
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 90),
        brush: PdfSolidBrush(PdfColor(65, 104, 205)));
    page.graphics.drawString(
        _invoiceResponse.totalInvoiceAmount.toString(), font,
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 100),
        brush: PdfBrushes.white,
        format: _stringFormat());
    final PdfFont contentFont = await _getFont();
    //Draw string
    page.graphics.drawString("price".tr(), contentFont,
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 33),
        format: _stringFormat());
    //Create data foramt and convert it to text.
    final String invoiceNumber =
        '${'invoice_number'.tr()}: ${_invoiceResponse.transId}\r\n\r\nDate: ${_invoiceResponse.invoiceDate}';
    final Size contentSize = contentFont.measureString(invoiceNumber);
    String contentData =
        '${'client_name'.tr()}: \r${_invoiceResponse.clinetName}, \r\n\r\n${'invoice_type'.tr()} :\r ${_invoiceResponse.transTypeName} \r\n\r\n${'account_balance_before'.tr()} : ${_invoiceResponse.accountBalanceBefore}\r\n\r\n${'account_balance_after'.tr()} : ${_invoiceResponse.accountBalanceAfter}';
    PdfTextElement(text: invoiceNumber, font: contentFont).draw(
        page: page,
        //  format:PdfLayoutFormat(layoutType: PdfLayoutType.onePage,p),
        bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 120,
            contentSize.width + 30, pageSize.height - 120));
    return PdfTextElement(text: contentData, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(30, 120,
            pageSize.width - (contentSize.width + 30), pageSize.height - 120))!;
  }

  Future<PdfTrueTypeFont> _getFont() async =>
      PdfTrueTypeFont(await _readFontData(), 14);

  //Draws the grid
  Future<void> _drawGrid(
      PdfPage page, PdfGrid grid, PdfLayoutResult result) async {
    Rect? totalPriceCellBounds;
    Rect? quantityCellBounds;
    //Invoke the beginCellLayout event.
    grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
      final PdfGrid grid = sender as PdfGrid;
      if (args.cellIndex == grid.columns.count - 1) {
        totalPriceCellBounds = args.bounds;
      } else if (args.cellIndex == grid.columns.count - 2) {
        quantityCellBounds = args.bounds;
      }
    };
    //Draw the PDF grid and get the result.
    result = grid.draw(
        page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0))!;
    //Draw grand total.
    var font = await _getFont();
    page.graphics.drawString("price".tr(), font,
        format: _stringFormat(),
        bounds: Rect.fromLTWH(
            quantityCellBounds!.left,
            result.bounds.bottom + 10,
            quantityCellBounds!.width,
            quantityCellBounds!.height));
    page.graphics.drawString(_invoiceResponse.net.toString(), font,
        format: _stringFormat(),
        bounds: Rect.fromLTWH(
            totalPriceCellBounds!.left,
            result.bounds.bottom + 10,
            totalPriceCellBounds!.width,
            totalPriceCellBounds!.height));
    // Draw discount
    page.graphics.drawString("discount".tr(), font,
        format: _stringFormat(),
        bounds: Rect.fromLTWH(
            quantityCellBounds!.left,
            result.bounds.bottom + 30,
            quantityCellBounds!.width,
            quantityCellBounds!.height));
    page.graphics.drawString(_invoiceResponse.discountValue.toString(), font,
        format: _stringFormat(),
        bounds: Rect.fromLTWH(
            totalPriceCellBounds!.left,
            result.bounds.bottom + 30,
            totalPriceCellBounds!.width,
            totalPriceCellBounds!.height));

    // Draw discount
    page.graphics.drawString("total".tr(), font,
        bounds: Rect.fromLTWH(
            quantityCellBounds!.left,
            result.bounds.bottom + 50,
            quantityCellBounds!.width,
            quantityCellBounds!.height));
    page.graphics.drawString(
        _invoiceResponse.totalInvoiceAmount.toString(), font,
        format: _stringFormat(),
        bounds: Rect.fromLTWH(
            totalPriceCellBounds!.left,
            result.bounds.bottom + 50,
            totalPriceCellBounds!.width,
            totalPriceCellBounds!.height));
  }

  //Draw the invoice footer data.
  Future<void> _drawFooter(PdfPage page, Size pageSize) async {
    var font = await _getFont();
    final PdfPen linePen =
        PdfPen(PdfColor(142, 170, 219, 255), dashStyle: PdfDashStyle.custom);
    linePen.dashPattern = <double>[3, 3];
    //Draw line
    page.graphics.drawLine(linePen, Offset(0, pageSize.height - 100),
        Offset(pageSize.width, pageSize.height - 100));
    String footerContent =
        '${_invoiceResponse.representativeName}\r\n\r\n${_invoiceResponse.driverName}\r\n\r\n${_invoiceResponse.companyName}\r\n\r\n${'phone'.tr()}: ${_invoiceResponse.phone1}\r\n\r\n${'provider_phone'.tr()}: ${_invoiceResponse.providerPhone}';
    //Added 30 as a margin for the layout
    page.graphics.drawString(footerContent, font,
        format: _stringFormat(),
        bounds: Rect.fromLTWH(pageSize.width - 30, pageSize.height - 70, 0, 0));
  }

  //Create PDF grid and return
  PdfGrid _getGrid() {
    //Create a PDF grid
    final PdfGrid grid = PdfGrid();
    //Secify the columns count to the grid.
    grid.columns.add(count: 6);
    //Create the header row of the grid.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    //Set style
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'item_id'.tr();
    headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[1].value = 'item_name'.tr();
    headerRow.cells[2].value = 'package_name'.tr();
    headerRow.cells[3].value = 'price'.tr();
    headerRow.cells[4].value = 'quantity'.tr();
    headerRow.cells[5].value = 'total'.tr();
    _invoiceResponse.lstTransDetailsModel?.forEach(((element) {
      _addProducts(element, grid);
    }));
    // _addProducts('CA-1098', 'AWC Logo Cap', 8.99, 2, 17.98, grid);
    // _addProducts(
    //     'LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 3, 149.97, grid);
    // _addProducts('So-B909-M', 'Mountain Bike Socks,M', 9.5, 2, 19, grid);
    // _addProducts(
    //     'LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 4, 199.96, grid);
    // _addProducts('FK-5136', 'ML Fork', 175.49, 6, 1052.94, grid);
    // _addProducts('HL-U509', 'Sports-100 Helmet,Black', 34.99, 1, 34.99, grid);
    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
    grid.columns[1].width = 200;
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j == 0) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
        }
        cell.style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }
    return grid;
  }

  //Create and row for the grid.
  void _addProducts(LstTransDetailsModel element, PdfGrid grid) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = element.itemId ?? "";
    row.cells[1].value = element.itemName ?? "";
    row.cells[2].value = element.packageName ?? "";
    row.cells[3].value = element.amount ?? "";
    row.cells[4].value = element.qty ?? "";
    row.cells[5].value = element.totalItemAmount ?? "";
  }

  PdfStringFormat _stringFormat() {
    return PdfStringFormat(
        textDirection: PdfTextDirection.rightToLeft,
        alignment: PdfTextAlignment.right,
        paragraphIndent: 35);
  }

  Future<List<int>> _readFontData() async {
    final ByteData bytes = await rootBundle.load('assets/fonts/arial.ttf');
    return bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  }
}
