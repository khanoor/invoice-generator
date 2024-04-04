import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'file_handle_api.dart';

class PdfInvoiceApi {
  static Future<File> generate(var list, List data) async {
    final pdf = pw.Document();

    final iconImage =
        (await rootBundle.load('images/top.jpeg')).buffer.asUint8List();

    // STANDARD Table
    final tableHeaders = [
      'SR NO.',
      'ITEMS',
      'PRICE',
      // 'RATE',
      // 'TOTAL',
    ];

    final tableData = [[]];

    List.generate(data.length, (index) {
      String sr = "${index + 1}";
      String name = data[index]["item_name"];
      // String quty = data[index]["item_quantity"];
      String price = data[index]["item_price"];
      // String total = data[index]["item_total"];

      List d = [
        sr,
        name,
        // quty,
        price,
        // total,
      ];
      //  d.add(service);
      tableData.add(d);
    });

    pdf.addPage(
      pw.MultiPage(
        header: (context) {
          return pw.Image(
            pw.MemoryImage(iconImage),
            // height: 60,
            // width: 72,
          );
        },
        build: (context) {
          return [
            pw.Padding(
              padding:
                  pw.EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 10),
              child: pw.Row(
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "${list[0]['name']}",
                        style: pw.TextStyle(
                            fontSize: 20, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.SizedBox(
                        height: 5,
                      ),
                      pw.Text("${list[0]['address']}"),
                      pw.SizedBox(
                        height: 5,
                      ),

                      // - ${list[0]['time']}"),
                    ],
                  ),
                  pw.Spacer(),
                  pw.Text("${list[0]['date']}"),
                  // pw.Image(
                  //   pw.MemoryImage(iconImage),
                  //   height: 72,
                  //   width: 72,
                  // ),
                ],
              ),
            ),

            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            // pw.Divider(),
            // pw.SizedBox(height: 1 * PdfPageFormat.mm),
            // pw.Text(
            //   'Dear John,\nLorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia, molestiae quas vel sint commodi repudiandae consequuntur voluptatum laborum numquam blanditiis harum quisquam eius sed odit fugiat iusto fuga praesentium optio, eaque rerum! Provident similique accusantium nemo autem. Veritatis obcaecati tenetur iure eius earum ut molestias architecto voluptate aliquam nihil, eveniet aliquid culpa officia aut! Impedit sit sunt quaerat, odit, tenetur error',
            //   textAlign: pw.TextAlign.justify,
            // ),

            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Divider(),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),

            pw.Table.fromTextArray(
              headers: tableHeaders,
              data: tableData,
              border: null,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey300),
              cellHeight: 20.0,
              cellAlignments: {
                0: pw.Alignment.center,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.center,
                // 3: pw.Alignment.center,
                // 4: pw.Alignment.center,
              },
              columnWidths: {
                0: const pw.FlexColumnWidth(40),
                1: const pw.FlexColumnWidth(220),
                2: const pw.FlexColumnWidth(100),
                // 3: const pw.FlexColumnWidth(100),
                // 4: const pw.FlexColumnWidth(100),
              },
            ),

            pw.Spacer(),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Divider(),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Container(
              padding: pw.EdgeInsets.only(right: 20),
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                "Total :${NumberFormat.currency(symbol: '', decimalDigits: 1, locale: 'Hi').format(num.parse(list[0]['total'].toString()))}",
                style:
                    pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Divider(),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),

            // pw.SizedBox(height: 2 * PdfPageFormat.mm),
            // pw.Container(height: 1, color: PdfColors.grey400),
            // pw.SizedBox(height: 0.5 * PdfPageFormat.mm),
            // pw.Container(height: 1, color: PdfColors.grey400),
            // pw.SizedBox(height: 2 * PdfPageFormat.mm),
          ];
        },
        // footer: (context) {
        //   return pw.Column(
        //     mainAxisSize: pw.MainAxisSize.min,
        //     children: [
        //       pw.Divider(),
        //       pw.SizedBox(height: 2 * PdfPageFormat.mm),
        //       pw.Text(
        //         'Flutter Approach',
        //         style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        //       ),
        //       pw.SizedBox(height: 1 * PdfPageFormat.mm),
        //       pw.Row(
        //         mainAxisAlignment: pw.MainAxisAlignment.center,
        //         children: [
        //           pw.Text(
        //             'Address: ',
        //             style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        //           ),
        //           pw.Text(
        //             'Merul Badda, Anandanagor, Dhaka 1212',
        //           ),
        //         ],
        //       ),
        //       pw.SizedBox(height: 1 * PdfPageFormat.mm),
        //       pw.Row(
        //         mainAxisAlignment: pw.MainAxisAlignment.center,
        //         children: [
        //           pw.Text(
        //             'Email: ',
        //             style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        //           ),
        //           pw.Text(
        //             'flutterapproach@gmail.com',
        //           ),
        //         ],
        //       ),
        //     ],
        //   );
        // },
      ),
    );

    return FileHandleApi.saveDocument(name: '${list[0]['name']}.pdf', pdf: pdf);
  }
}
