class BannerListModel {
  bool? status;
  String? message;
  List<Data>? data;

  BannerListModel({this.status, this.message, this.data});

  BannerListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? idBanner;
  int? idRegion;
  String? createdAt;
  String? updatedAt;
  List<Banner>? banner;
  Region? region;

  Data(
      {this.id,
        this.idBanner,
        this.idRegion,
        this.createdAt,
        this.updatedAt,
        this.banner,
        this.region});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idBanner = json['id_banner'];
    idRegion = json['id_region'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['banner'] != null) {
      banner = <Banner>[];
      json['banner'].forEach((v) {
        banner!.add(new Banner.fromJson(v));
      });
    }
    region =
    json['region'] != null ? new Region.fromJson(json['region']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_banner'] = this.idBanner;
    data['id_region'] = this.idRegion;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.banner != null) {
      data['banner'] = this.banner!.map((v) => v.toJson()).toList();
    }
    if (this.region != null) {
      data['region'] = this.region!.toJson();
    }
    return data;
  }
}

class Banner {
  int? id;
  String? image;
  String? url;
  String? title;
  String? description;
  int? position;
  int? publish;
  String? createdAt;
  String? updatedAt;

  Banner(
      {this.id,
        this.image,
        this.url,
        this.title,
        this.description,
        this.position,
        this.publish,
        this.createdAt,
        this.updatedAt});

  Banner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    url = json['url'];
    title = json['title'];
    description = json['description'];
    position = json['position'];
    publish = json['publish'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['url'] = this.url;
    data['title'] = this.title;
    data['description'] = this.description;
    data['position'] = this.position;
    data['publish'] = this.publish;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Region {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Region({this.id, this.name, this.createdAt, this.updatedAt, this.deletedAt});

  Region.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}