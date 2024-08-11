class PhotosModel {
  String? id;
  String? createdAt;
  String? color;
  String? creatorName; // Add this line
  Map<String, dynamic>? urls;

  PhotosModel({this.id, this.createdAt, this.color, this.urls, this.creatorName});

  PhotosModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    color = json['color'];
    urls = json['urls'];
    creatorName = json['user']['name']; // Add this line
  }
}
