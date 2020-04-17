import 'package:flutter/material.dart';
import 'package:care_solutions/util/context.dart';
import 'package:care_solutions/util/session.dart';
import 'package:intl/intl.dart';

class SelectService extends StatelessWidget {
  SelectService(this.resident);
  final Resident resident;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Select Service"),
        backgroundColor: Color(0xFF293D50),
      ),
      body: SelectServiceBody(resident),
    );
  }
}

class SelectServiceBody extends StatefulWidget {
  SelectServiceBody(this.resident);
  final Resident resident;
  @override
  SelectServiceBodyState createState() => SelectServiceBodyState(resident);
}

class SelectServiceBodyState extends State<SelectServiceBody> {
  SelectServiceBodyState(this.resident);
  final Resident resident;
  Widget _buildServiceList(List<Service> servicesData) {
    if (servicesData.length > 0) {
      return ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (context, index) => Divider(
                color: Colors.white,
                height: 0,
              ),
          itemCount: servicesData.length,
          itemBuilder: (context, i) {
            return _buildRow(servicesData[i]);
          });
    } else {
      return Center(
        child: Text(
          "Service not found",
          style: TextStyle(color: Colors.red),
        ),
      );
    }
  }

  Widget _buildRow(Service service) {
    return Container(
      color: Color(0xFF293D50),
      child: ListTile(
        title: Text(
          service.servicename,
          style: TextStyle(color: Colors.white),
        ),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          color: Colors.white,
        ),
        onTap: () async {
          bool fin = false;
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Select Service"),
                content: Text("Do you want to complete service?"),
                actions: [
                  FlatButton(
                    child: Text("Yes"),
                    onPressed: () async {
                      var transaction = new Transaction();
                      var formatter = new DateFormat('MM/dd/yy HH:mm');
                      String transdate = formatter.format(DateTime.now());
                      transaction.servicecode = service.servicecode;
                      transaction.transdate = transdate;
                      transaction.residentid = resident.residentid;
                      transaction.userid = await Session.getKey('user');
                      await Transaction.add(transaction);

                      fin = true;
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text("No"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              );
            },
          );
          if (fin) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  Future<List<Service>> _getServiceList() async {
    var services = await Service.getAll();
    return services;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getServiceList(),
      builder: (BuildContext context, AsyncSnapshot<List<Service>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Text("Please wait ..."),
          );
        } else {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(),
              child: Column(children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _buildServiceList(snapshot.data),
                  ),
                ),
              ]),
            ),
          );
        }
      },
    );
  }
}
