class ItemFavorites {
  final String id;
  final String userId;
  int? updateTime;
  final List<String> itemId;

  ItemFavorites(this.id, this.userId, this.itemId);

  ItemFavorites.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['userId'],
        updateTime = json['updateTime'],
        itemId = (json['itemId'] == null) ? [] : json['itemId'].cast<String>();

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'itemId': itemId,
      };
}
