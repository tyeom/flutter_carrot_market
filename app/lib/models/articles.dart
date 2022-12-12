import 'package:app/models/profile.dart';

class Articles {
  String? id;
  List<String>? photoList;
  Profile profile;
  String title;
  String? content;
  String town;
  num price;
  int? likeCnt;
  int? readCnt;
  int? uploadTime;
  int? updateTime;
  String category;

  Articles(
      {required this.photoList,
      required this.profile,
      required this.title,
      required this.content,
      required this.town,
      required this.price,
      required this.likeCnt,
      required this.readCnt,
      required this.category});

  Articles.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        photoList = json['photoList'].cast<String>(),
        profile = Profile.fromJson(json['profile']),
        title = json['title'],
        content = json['content'],
        town = json['town'],
        price = json['price'],
        likeCnt = json['likeCnt'],
        readCnt = json['readCnt'],
        uploadTime = json['uploadTime'],
        updateTime = json['updateTime'],
        category = json['category'];

  Map<String, dynamic> toJson() => {
        'photoList': photoList,
        'profile': profile,
        'title': title,
        'content': content,
        'town': town,
        'price': price,
        'likeCnt': likeCnt,
        'readCnt': readCnt,
        'category': category,
      };
}
