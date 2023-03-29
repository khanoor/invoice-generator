import 'package:flutter/material.dart';

class ViewInvoice extends StatefulWidget {
  const ViewInvoice({Key? key}) : super(key: key);

  @override
  State<ViewInvoice> createState() => ViewInvoiceState();
}

class ViewInvoiceState extends State<ViewInvoice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Veiw Invoice"),
      ),
    );
  }
}
