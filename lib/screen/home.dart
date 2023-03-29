import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:invoice_generater/screen/global/global.dart';
import 'package:invoice_generater/screen/invoice_create.dart';
import 'package:invoice_generater/screen/invoice_details.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  List<Map<String, dynamic>> listData = [];
  // late Box box;
  final box = Hive.box("invoice");

  @override
  void initState() {
    super.initState();
    // openBox();
    refreshData();
    print(listData.length);
  }

  // Future openBox() async {
  //   var dir = await getApplicationDocumentsDirectory();
  //   Hive.init(dir.path);
  //   box = await Hive.openBox("invoice");
  //   return;
  // }

  // Get all items from the database
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
    });
  }

  // Retrieve a single item from the database by using its key
  // Our app won't use this function but I put it here for your reference
  // Map<String, dynamic> readItem(int key) {
  //   final item = box.get(key);
  //   return item;
  // }

  // // Add Item
  // Future<void> AddItem(Map<String, dynamic> newItem) async {
  //   await box.add(newItem);
  //   refreshData(); // update the UI
  // }

  // // Delete a single item
  // Future<void> deleteItem(int id) async {
  //   await box.delete(id);
  //   refreshData(); // update the UI

  //   // Display a snackbar
  //   ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('An item has been deleted')));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text("Invoice List"),
        actions: [
          IconButton(
              onPressed: () {
                refreshData();
              },
              icon: Icon(Icons.refresh_rounded))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: app_color,
        onPressed: () async {
          String add = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateInvoice(
                        key_value: listData.isEmpty ? 0 : listData.length,
                      )));

          if (add == "add") {
            refreshData();
            print("Test");
          }
        },
        child: Icon(Icons.add),
      ),
      body: Stack(
        children: [
          listData.isEmpty
              ? const Center(
                  child: Text(
                    'No Data',
                    style: TextStyle(fontSize: 30),
                  ),
                )
              : ListView.builder(
                  itemCount: listData.length,
                  itemBuilder: (_, index) {
                    final currentItem = listData[index];
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade500,
                            offset: const Offset(
                              0.0,
                              0.0,
                            ),
                            blurRadius: 10.0,
                          ),
                          BoxShadow(
                            color: Colors.white,
                            offset: const Offset(0.0, 0.0),
                            blurRadius: 0.0,
                            spreadRadius: 0.0,
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentItem['name'],
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(currentItem['address']),
                            ],
                          ),
                          Spacer(),
                          Column(
                            children: [
                              Text(currentItem['date'],
                                  style: TextStyle(
                                    fontSize: 16,
                                  )),
                              SizedBox(
                                height: 5,
                              ),
                              Text(currentItem['time'],
                                  style: TextStyle(
                                    fontSize: 16,
                                  )),
                            ],
                          ),
                          Spacer(),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: app_color,
                            ),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => InvoiceDetails(
                                                item_key: currentItem['key'],
                                              )));
                                },
                                icon: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                )),
                          )
                        ],
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
