import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:invoice_generater/screen/global/global.dart';
import 'package:invoice_generater/screen/invoice_details.dart';

// ignore: must_be_immutable
class CreateInvoice extends StatefulWidget {
  int key_value;
  CreateInvoice({Key? key, required this.key_value}) : super(key: key);

  @override
  State<CreateInvoice> createState() => CreateInvoiceState();
}

List ItemList = [];
String name = '';
String address = '';
double Total_Amount = 0.0;

class CreateInvoiceState extends State<CreateInvoice> {
  @override
  void initState() {
    super.initState();
    ItemList = [];
    Total_Amount = 0.0;
  }

  final box = Hive.box("invoice");

  // Add Item
  Future<void> AddItem(Map<String, dynamic> newItem) async {
    await box.add(newItem);
    print(newItem);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => InvoiceDetails(item_key: widget.key_value)));
  }

  String currentDate = DateFormat("dd-MM-yyyy").format(DateTime.now());
  Future<void> PickDate(BuildContext context) async {
    final DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 365 * 4)),
        lastDate: DateTime.now().add(const Duration(days: 90)),
        builder: (context, child) {
          return Theme(data: Theme.of(context).copyWith(), child: child!);
        });
    if (date != null) {
      setState(() {
        currentDate = DateFormat("dd-MM-yyyy").format(date);
      });
    }
  }

  TextEditingController customer_name = TextEditingController();
  TextEditingController customer_address = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Invoice"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: app_color,
        onPressed: () {
          // FocusScope.of(context).unfocus();
          showForm();
        },
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            // FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                child: TextField(
                  controller: customer_name,
                  decoration: InputDecoration(
                      hintText: "Customer Name",
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0)),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 5),
                child: TextField(
                  controller: customer_address,
                  decoration: InputDecoration(
                      hintText: "Customer Address",
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 5),
                  Text("$currentDate"),
                  IconButton(
                      onPressed: () {
                        PickDate(context);
                      },
                      icon: Icon(Icons.calendar_month_outlined)),
                ],
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: Colors.black,
              ),
              SizedBox(height: 5),
              FittedBox(
                child: ItemList.isEmpty
                    ? Center(
                        child: Text("No Item Add in List"),
                      )
                    : DataTable(
                        columns: [
                          DataColumn(
                              label: Text('Sr No.',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Particular ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold))),
                          // DataColumn(
                          //     label: Text('Quantity',
                          //         style: TextStyle(
                          //             fontSize: 16,
                          //             fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Price',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold))),
                          // DataColumn(
                          //     label: Text('Total',
                          //         style: TextStyle(
                          //             fontSize: 16,
                          //             fontWeight: FontWeight.bold))),
                        ],
                        rows: List.generate(
                          ItemList.length,
                          (index) => DataRow(
                              onLongPress: () {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title:
                                            Text("Are You Sure, Delete This"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  Total_Amount = Total_Amount -
                                                      double.parse(
                                                          ItemList[index]
                                                                  ['item_total']
                                                              .toString());
                                                  ItemList.removeAt(index);
                                                });
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "Delete",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              )),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("Cancel"))
                                        ],
                                      );
                                    });
                              },
                              cells: [
                                DataCell(
                                  Text("${index + 1}"),
                                ),
                                DataCell(
                                  Text(ItemList[index]['item_name']),
                                ),

                                DataCell(
                                  Text(
                                      "${NumberFormat.currency(symbol: '', decimalDigits: 1, locale: 'Hi').format(num.parse(ItemList[index]['item_price'].toString()))}"),
                                ),
                                // DataCell(
                                //   Text(
                                //       "${NumberFormat.currency(symbol: '', decimalDigits: 1, locale: 'Hi').format(num.parse(ItemList[index]['item_total'].toString()))}"),
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
                    "Total : ₹ ${NumberFormat.currency(symbol: '', decimalDigits: 1, locale: 'Hi').format(num.parse(Total_Amount.toString()))}",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              ElevatedButton(
                  onPressed: () {
                    if (customer_name.text != "") {
                      AddItem(
                        {
                          'name': customer_name.text,
                          'date': currentDate,
                          //     DateFormat('dd-MM-yyyy').format(DateTime.now()),
                          // 'time': DateFormat('HH:mm:ss').format(DateTime.now()),
                          'address': customer_address.text,
                          'items': ItemList,
                          'total': Total_Amount,
                        },
                      );
                      print(customer_name.text);
                      print(customer_address.text);
                    } else {
                      Fluttertoast.showToast(msg: "Enter Name");
                    }
                  },
                  child: Text("Generate Invoice"))
            ],
          ),
        ),
      ),
    );
  }

  showForm() {
    TextEditingController item_name = TextEditingController();
    TextEditingController item_quantity = TextEditingController();
    TextEditingController item_price = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Container(
              alignment: Alignment.center,
              height: 280,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Add Product Details',
                          style: TextStyle(
                            fontSize: 16,
                          )),
                      Spacer(),
                      // Spacer(),
                      IconButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.clear_outlined)),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, top: 0, right: 10),
                    child: TextField(
                      controller: item_name,
                      decoration: InputDecoration(hintText: "Work"),
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                  //   child: TextField(
                  //     keyboardType: TextInputType.number,
                  //     controller: item_quantity,
                  //     decoration: InputDecoration(hintText: "Quantity in KG"),
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 10, top: 10, right: 10, bottom: 15),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: item_price,
                      decoration: InputDecoration(hintText: "Rate"),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (item_name.text != "" && item_price.text != "") {
                          setState(() {
                            Map<String, String> data = {
                              'item_price': item_price.text,
                              'item_name': item_name.text,
                              // 'item_total':
                              //     "${double.parse(item_price.text)}",
                            };

                            ItemList.add(data);
                            Total_Amount = Total_Amount +
                                double.parse(
                                    "${double.parse(item_price.text)}");
                            print(ItemList);
                            Navigator.pop(context);
                          });
                        } else {
                          Fluttertoast.showToast(msg: "Enter All Details");
                        }
                      },
                      child: Text("ADD"))
                ],
              )),
        );
      },
    );
  }
}
