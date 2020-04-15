import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:care_solutions/models.dart';
import 'dart:convert';

class Scanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Welcome'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Login()),
              (Route<dynamic> route) => false,
            );
          },
          child: Center(
            child: Text("Logout"),
          ),
        ),
        backgroundColor: Color(0xFF293D50),
      ),
      body: ScannerBody(),
    );
  }
}

class ScannerBody extends StatefulWidget {
  @override
  ScannerBodyState createState() => ScannerBodyState();
}

class ScannerBodyState extends State<ScannerBody> {
  final _residentData = <Resident>[];

  final _searchController = TextEditingController();
  final _searchKey = GlobalKey<FormState>();

  Future<String> _getCurrentUserRole() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String out = pref.getString('role');
    return out;
  }

  void _searchResident(String keyword) async {
    String jsonString =
        await rootBundle.loadString('assets/data/resident.json');

    var residents = (json.decode(jsonString) as List)
        .map((i) => Resident.fromJson(i))
        .toList();
    var searchresult = residents
        .where((resident) =>
            resident.firstname.toLowerCase().contains(keyword.toLowerCase()) ||
            resident.lastname.toLowerCase().contains(keyword.toLowerCase()) ||
            resident.residentid.toLowerCase().contains(keyword.toLowerCase()))
        .toList();

    setState(() {
      _residentData.clear();
      _residentData.addAll(searchresult);
    });
  }

  Future<List<Transaction>> _getTransactions(String residentId) async {
    String jsonString =
        await rootBundle.loadString('assets/data/transaction.json');

    var transactions = (json.decode(jsonString) as List)
        .map((i) => Transaction.fromJson(i))
        .toList();
    var renderedservices = transactions
        .where((transaction) => transaction.residentid == residentId)
        .toList();

    return renderedservices;
  }

  void _showRenderedServices(Resident resident) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Rendered Services'),
              actions: <Widget>[
                // Add 3 lines from here...
                IconButton(
                  icon: Icon(Icons.list),
                  onPressed: () => {},
                ),
              ],
              backgroundColor: Color(0xFF293D50),
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _residentData.clear();
                    _searchController.text = "";
                  });
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: FutureBuilder(
              future: _getTransactions(resident.residentid),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Transaction>> snapshot) {
                if (snapshot.hasData) {
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
                } else {
                  return Center(
                    child: Text("Please wait ..."),
                  );
                }
              },
            ),
          );
        },
      ),
    );
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

  Widget _buildSearchResult() {
    if (_residentData.length > 0) {
      return ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (context, index) => Divider(
                color: Colors.white,
                height: 0,
              ),
          itemCount: _residentData.length,
          itemBuilder: (context, i) {
            return _buildRow(_residentData[i]);
          });
    } else {
      return Center(
        child: Text(
          "Resident not found",
          style: TextStyle(color: Colors.red),
        ),
      );
    }
  }

  Widget _buildRow(Resident resident) {
    return Container(
      color: Color(0xFF293D50),
      child: ListTile(
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                resident.sortname,
                style: TextStyle(color: Colors.white),
              ),
              Container(
                padding: const EdgeInsets.only(left: 5, right: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  resident.room,
                  style: TextStyle(color: Color(0xFF293D50), fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          color: Colors.white,
        ),
        onTap: () => _showRenderedServices(resident),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getCurrentUserRole(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          String role = snapshot.data;
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(),
              child: Column(children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  color: Color(0xFF293D50),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          child: RaisedButton(
                            onPressed: () async {
                              String scannedCode = await scanner.scan();
                              setState(() {
                                _searchController.text = scannedCode;
                              });
                              _searchResident(scannedCode);
                            },
                            color: Colors.blue,
                            textColor: Colors.white,
                            padding: const EdgeInsets.only(
                                top: 15.0, bottom: 15.0, left: 10.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(5.0),
                            ),
                            child: Row(children: [
                              Container(
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey,
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                child: Icon(Icons.search),
                              ),
                              Expanded(
                                child: Text(
                                  "Scan Resident Code",
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: role.toLowerCase() == "admin",
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          /*1*/
                          child: Form(
                            key: _searchKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter Last Name, First Name or Resident Code';
                                    }
                                    return null;
                                  },
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(
                                          top: 15.0,
                                          bottom: 15.0,
                                          left: 10.0,
                                          right: 10.0),
                                      border: new OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(8.0),
                                        ),
                                      ),
                                      hintText:
                                          'Enter Last Name, First Name or Scan'),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 10.0, right: 10.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: RaisedButton(
                                      onPressed: () {
                                        if (_searchKey.currentState
                                            .validate()) {
                                          _searchResident(
                                              _searchController.text);
                                        }
                                      },
                                      color: Color(0xFF293D50),
                                      textColor: Colors.white,
                                      padding: const EdgeInsets.only(
                                          top: 15.0, bottom: 15.0, left: 10.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(5.0),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.search),
                                          Expanded(
                                            child: Text(
                                              "Search",
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _buildSearchResult(),
                  ),
                ),
              ]),
            ),
          );
        } else {
          return Center(
            child: Text("Please wait ..."),
          );
        }
      },
    );
  }
}
