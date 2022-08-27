class userDetailsModel {
  bool? status;
  String? statusCode;
  String? message;
  Data? data;

  userDetailsModel({this.status, this.statusCode, this.message, this.data});

  userDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? userId;
  String? name;
  String? email;
  String? profilePic;
  int? badgeCount;
  Null? deviceType;
  Null? deviceToken;
  Null? uniqueToken;
  String? createdAt;

  Data(
      {this.userId,
        this.name,
        this.email,
        this.profilePic,
        this.badgeCount,
        this.deviceType,
        this.deviceToken,
        this.uniqueToken,
        this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    profilePic = json['profile_pic'];
    badgeCount = json['badge_count'];
    deviceType = json['device_type'];
    deviceToken = json['device_token'];
    uniqueToken = json['unique_token'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['profile_pic'] = this.profilePic;
    data['badge_count'] = this.badgeCount;
    data['device_type'] = this.deviceType;
    data['device_token'] = this.deviceToken;
    data['unique_token'] = this.uniqueToken;
    data['created_at'] = this.createdAt;
    return data;
  }
}
