import 'package:flutter/material.dart';
import 'selectservice.dart';
import 'package:care_solutions/util/context.dart';

class RenderedServices extends StatelessWidget {
  RenderedServices(this.resident);
  final Resident resident;

  @override
  Widget build(BuildContext context) {
    return RenderedServicesBody(resident);
  }
}

class RenderedServicesBody extends StatefulWidget {
  RenderedServicesBody(this.resident);
  final Resident resident;
  @override
  RenderedServicesBodyState createState() =>
      RenderedServicesBodyState(resident);
}

class RenderedServicesBodyState extends State<RenderedServicesBody> {
  RenderedServicesBodyState(this.resident);
  final Resident resident;
  Future<List<Transaction>> _renderedServicesData;
  int i = 0;
  @override
  void initState() {
    super.initState();
    _renderedServicesData = _getTransactions(resident.residentid);
  }

  List<TableRow> _buildRSRows(List<Transaction> renderedservices) {
    List<TableRow> rows = <TableRow>[];
    rows.add(
      TableRow(
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(15),
              child: Text(
                'Service',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(15),
              child: Text(
                'Date',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(15),
              child: Text(
                'Service By',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
    rows.addAll(renderedservices.map((transaction) {
      return TableRow(children: [
        Container(
          padding: EdgeInsets.all(10),
          child: Text(transaction.servicecode),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child:
              Text(transaction.transdate == null ? "" : transaction.transdate),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Text(transaction.userid),
        ),
      ]);
    }).toList());
    return rows;
  }

  Future<List<Transaction>> _getTransactions(String residentId) async {
    var transactions = await Transaction.getAll();
    var renderedservices = transactions
        .where((transaction) => transaction.residentid == residentId)
        .toList();

    return renderedservices;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: [
            Container(
              height: 90,
              child: DrawerHeader(
                child: Center(
                  child: Text(
                    resident.sortname,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  topLeft: Radius.circular(8),
                ),
              ),
              child: ListTile(
                title: Text(
                  '1. Performance Service',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  Navigator.of(context).pop();
                  await Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => SelectService(resident),
                    ),
                  );
                  setState(() {
                    _renderedServicesData =
                        _getTransactions(resident.residentid);
                  });
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
              ),
              child: ListTile(
                title: Text(
                  '2. Incident Report',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Rendered Services'),
        backgroundColor: Color(0xFF293D50),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder(
        future: _renderedServicesData,
        builder:
            (BuildContext context, AsyncSnapshot<List<Transaction>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text("Please wait ..."),
            );
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: ConstrainedBox(
                constraints: BoxConstraints(),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        padding: EdgeInsets.only(bottom: 15),
                        child: Text(
                          resident.sortname,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: 20,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    Table(
                      border: TableBorder.all(),
                      children: _buildRSRows(snapshot.data),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
