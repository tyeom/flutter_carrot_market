class Profile {
  final String id;
  final String phoneNum;
  final String email;
  final String nickName;
  final String? photo;
  final double temperature;
  final List<String> town;

  Profile(this.id, this.phoneNum, this.email, this.nickName, this.photo,
      this.temperature, this.town);

  Profile.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        phoneNum = json['phoneNum'],
        email = json['email'],
        nickName = json['nickName'],
        photo = json['photo'],
        temperature = json['temperature'].toDouble(),
        town = json['town'].cast<String>();

  Map<String, dynamic> toJson() => {
        'id': id,
        'phoneNum': phoneNum,
        'email': email,
        'nickName': nickName,
        'photo': photo,
        'temperature': temperature,
        'town': town,
      };
}
