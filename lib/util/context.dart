import 'dart:io';
import 'package:care_solutions/util/nousbiz-api.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class User {
  int id;
  String firstname;
  String middlename;
  String lastname;
  String userid;
  String password;
  String role;
  String createddate;
  String updateddate;
  String sortname;

  User()
      : id = 0,
        firstname = "",
        middlename = "",
        lastname = "",
        userid = "",
        password = "",
        role = "",
        createddate = "",
        updateddate = "",
        sortname = "";

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        firstname = json['firstname'],
        middlename = json['middlename'],
        lastname = json['lastname'],
        userid = json['user_id'],
        password = json['password'],
        role = json['role'],
        createddate = json['created_date'],
        updateddate = json['updated_date'],
        sortname = json['sortname'];

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "middlename": middlename,
        "lastname": lastname,
        "user_id": userid,
        "password": password,
        "role": role,
        "created_date": createddate,
        "updated_date": updateddate,
        "sortname": sortname
      };
  static Future<List<User>> getAll() async {
    try {
      NousbizAPI _api = new NousbizAPI();
      Response response = await _api.get("/users/");

      if (response.statusCode == 200) {
        String jsonString = response.body;
        var users = (json.decode(jsonString) as List)
            .map((i) => User.fromJson(i))
            .toList();
        return users;
      } else {
        return null;
      }
    } catch (ex) {
      return null;
    }
  }

  static Future<String> login(String username, String password) async {
    try {
      NousbizAPI _api = new NousbizAPI();
      Response response = await _api.post(
          "/users/login/",
          jsonEncode(
              <String, String>{'username': username, 'password': password}));

      if (response.statusCode == 201) {
        String token = response.body;
        return token;
      } else {
        return null;
      }
    } catch (ex) {
      return null;
    }
  }
}

class Resident {
  int id;
  String firstname;
  String middlename;
  String lastname;
  String residentid;
  String room;
  String createddate;
  String updateddate;
  String sortname;

  Resident()
      : id = 0,
        firstname = "",
        middlename = "",
        lastname = "",
        residentid = "",
        room = "",
        createddate = "",
        updateddate = "",
        sortname = "";

  Resident.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        firstname = json['firstname'],
        middlename = json['middlename'],
        lastname = json['lastname'],
        residentid = json['resident_id'],
        room = json['room'],
        createddate = json['created_date'],
        updateddate = json['updated_date'],
        sortname = json['sortname'];

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "middlename": middlename,
        "lastname": lastname,
        "resident_id": residentid,
        "room": room,
        "created_date": createddate,
        "updated_date": updateddate,
        "sortname": sortname
      };
  static Future<List<Resident>> getAll() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;

    var file = File('$path/resident.json');

    if (await file.exists() == false) {
      String str = await rootBundle.loadString('assets/data/resident.json');
      await file.writeAsString(str);
    }

    String jsonString = await file.readAsString();

    var residents = (json.decode(jsonString) as List)
        .map((i) => Resident.fromJson(i))
        .toList();
    return residents;
  }
}

class Transaction {
  int id;
  String servicecode;
  String transdate;
  String residentid;
  String userid;
  String createddate;
  String updateddate;

  Transaction()
      : id = 0,
        servicecode = "",
        transdate = "",
        residentid = "",
        userid = "",
        createddate = "",
        updateddate = "";

  Transaction.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        servicecode = json['service_code'],
        transdate = json['trans_date'],
        residentid = json['resident_id'],
        userid = json['user_id'],
        createddate = json['created_date'],
        updateddate = json['updated_date'];

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_code": servicecode,
        "trans_date": transdate,
        "resident_id": residentid,
        "user_id": userid,
        "created_date": createddate,
        "updated_date": updateddate,
      };
  static Future<List<Transaction>> getAll() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;

    var file = File('$path/transaction.json');

    if (await file.exists() == false) {
      String str = await rootBundle.loadString('assets/data/transaction.json');
      await file.writeAsString(str);
    }

    String jsonString = await file.readAsString();

    var transactions = (json.decode(jsonString) as List)
        .map((i) => Transaction.fromJson(i))
        .toList();
    return transactions;
  }

  static Future<void> add(Transaction transaction) async {
    var transactions = await Transaction.getAll();
    transaction.id = transactions.length + 1;
    transactions.add(transaction);
    var jsonstr = "[" +
        transactions.map((i) => json.encode(i.toJson())).toList().join(',') +
        "]";

    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;

    var file = File('$path/transaction.json');

    await file.writeAsString(jsonstr);
  }
}

class Service {
  int id;
  String servicecode;
  String servicename;
  String createddate;
  String updateddate;

  Service()
      : id = 0,
        servicecode = "",
        servicename = "",
        createddate = "",
        updateddate = "";
  Service.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        servicecode = json['service_code'],
        servicename = json['service_name'],
        createddate = json['created_date'],
        updateddate = json['updated_date'];

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_code": servicecode,
        "service_name": servicename,
        "created_date": createddate,
        "updated_date": updateddate,
      };
  static Future<List<Service>> getAll() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;

    var file = File('$path/services.json');

    if (await file.exists() == false) {
      String str = await rootBundle.loadString('assets/data/services.json');
      await file.writeAsString(str);
    }

    String jsonString = await file.readAsString();

    var services = (json.decode(jsonString) as List)
        .map((i) => Service.fromJson(i))
        .toList();
    return services;
  }
}
