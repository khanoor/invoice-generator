import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:invoice_generater/screen/global/global.dart';
import 'package:invoice_generater/screen/home.dart';
import 'package:invoice_generater/screen/invoice/file_handle_api.dart';
import 'package:invoice_generater/screen/invoice/pdf_invoice_api.dart';

// ignore: must_be_immutable
class InvoiceDetails extends StatefulWidget {
  var item_key;
  InvoiceDetails({Key? key, required this.item_key}) : super(key: key);

  @override
  State<InvoiceDetails> createState() => InvoiceDetailsState();
}

class InvoiceDetailsState extends State<InvoiceDetails> {
  final box = Hive.box("invoice");
  List itemData = [];
  double Total_Amount = 0.0;
  List<Map<String, dynamic>> listData = [];
  var existingItem;

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  void refreshData() {
    final data = box.keys.map((key) {
      final value = box.get(key);
      print(value);
      print(value);
      return {
        "key": key,
        "name": value["name"],
        "address": value['address'],
        "items": value['items'],
        "date": value['date'],
        "time": value['time'],
        "total": value['total'],
      };
    }).toList();
    setState(() {
      listData = data.reversed.toList();
      readItem(widget.item_key);
    });
  }

  Map<String, dynamic> readItem(int key) {
    // final item = box.get(key);
    existingItem = listData.firstWhere((element) => element['key'] == key);
    print(existingItem);
    itemData = existingItem['items'];
    Total_Amount = existingItem['total'];
    print(itemData);
    return existingItem;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => Home()));
        // Navigator.of(context,)
        //   ..pop()
        //   ..pop();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => Home(), maintainState: true),
            (Route<dynamic> route) => false);
        // Navigator.pop(context, "add");
        return false;
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Invoice Details')),
        floatingActionButton: FloatingActionButton(
          backgroundColor: app_color,
          onPressed: () async {
            final pdfFile = await PdfInvoiceApi.generate(listData, itemData);
            // opening the pdf file
            FileHandleApi.openFile(pdfFile);
          },
          child: Icon(Icons.picture_as_pdf_outlined),
        ),
        body: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 10),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${listData[0]['name']}",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text("${listData[0]['address']}"),
                      SizedBox(
                        height: 5,
                      ),
                      Text("${listData[0]['date']}"
                      //  - ${listData[0]['time']}"
                       ),
                    ],
                  ),
                  Spacer(),
                  Image(
                    height: 72,
                    image: AssetImage('images/invoice.png'),
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            FittedBox(
              child: DataTable(
                columns: [
                  DataColumn(
                      label: Text('Sr No.',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Item Name',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold))),
                  // DataColumn(
                  //     label: Text('Quantity',
                  //         style: TextStyle(
                  //             fontSize: 16, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Price',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold))),
                  // DataColumn(
                  //     label: Text('Total',
                  //         style: TextStyle(
                  //             fontSize: 16, fontWeight: FontWeight.bold))),
                ],
                rows: List.generate(
                  itemData.length,
                  (index) => DataRow(cells: [
                    DataCell(
                      Text("${index + 1}"),
                    ),
                    DataCell(
                      Text(itemData[index]['item_name']),
                    ),
                    // DataCell(
                    //   Text(itemData[index]['item_quantity']),
                    // ),
                    DataCell(
                      Text(
                          "${NumberFormat.currency(symbol: '', decimalDigits: 1, locale: 'Hi').format(num.parse(itemData[index]['item_price'].toString()))}"),
                    ),
                    // DataCell(
                    //   Text(
                    //       "${NumberFormat.currency(symbol: '', decimalDigits: 1, locale: 'Hi').format(num.parse(itemData[index]['item_total'].toString()))}"),
                    // ),
                  ]),
                ).toList(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(right: 20),
              alignment: Alignment.centerRight,
              child: Text(
                  "Total : ${NumberFormat.currency(symbol: '₹', decimalDigits: 1, locale: 'Hi').format(num.parse(Total_Amount.toString()))}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}
