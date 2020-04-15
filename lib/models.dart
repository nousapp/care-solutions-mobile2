class User {
  final int id;
  final String firstname;
  final String middlename;
  final String lastname;
  final String userid;
  final String password;
  final String role;
  final String createddate;
  final String updateddate;
  final String sortname;

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
}
class Resident {
  final int id;
  final String firstname;
  final String middlename;
  final String lastname;
  final String residentid;
  final String room;
  final String createddate;
  final String updateddate;
  final String sortname;

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
}

class Transaction {
  final int id;
  final String servicecode;
  final String transdate;
  final String residentid;
  final String userid;
  final String createddate;
  final String updateddate;

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
        "firstname": servicecode,
        "trans_date": transdate,
        "resident_id": residentid,
        "user_id": userid,
        "created_date": createddate,
        "updated_date": updateddate,
      };
}
