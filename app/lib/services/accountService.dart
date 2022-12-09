import 'dart:convert';

import 'package:app/models/item_favorites.dart';
import 'package:http/http.dart' as http;

import 'package:app/models/profile.dart';

class AccountService {
  final String _baseURL = 'arong.info:7004';

  // 프로필 정보 요청
  Future<Profile> fetchProfile(http.Client client, String phoneNum) async {
    // http://arong.info:7004/user?phoneNum=01011112222
    var url = Uri.http(_baseURL, '/user', {'phoneNum': phoneNum});

    final response = await client.get(url);
    if (response.statusCode == 200) {
      final profileMap = jsonDecode(response.body);
      if (profileMap.containsKey("rows")) {
        var profile = Profile.fromJson(profileMap["rows"][0]);
        return profile;
      } else {
        throw Exception('No account data');
      }
    } else {
      throw Exception('Unable to fetch account from the REST API');
    }
  }

  // 등록한 관심상품 정보 요청
  Future<ItemFavorites?> fetchItemFavorites(
      http.Client client, String userId) async {
    // http://arong.info:7004/ItemFavorites?userId=-NIVCK7LmyT6E1bumyAQ
    var url = Uri.http(_baseURL, '/ItemFavorites', {'userId': userId});

    final response = await client.get(url);
    if (response.statusCode == 200) {
      final itemFavoritesMap = jsonDecode(response.body);
      if (itemFavoritesMap.containsKey("rows")) {
        if (itemFavoritesMap["rows"].length <= 0) return null;
        var itemFavorites = ItemFavorites.fromJson(itemFavoritesMap["rows"][0]);
        return itemFavorites;
      } else {
        throw Exception('No item favorites data');
      }
    } else {
      throw Exception('Unable to fetch itemFavorites from the REST API');
    }
  }

  // 등록한 관심상품 정보 업데이트
  Future<bool> updateItemFavorites(
      http.Client client, ItemFavorites itemFavorites) async {
    Uri url;
    if (itemFavorites.id != "") {
      print('관심상품 정보 업데이트');
      // http://arong.info:7004/SetItemFavorites/{ItemFavorites ID}
      url = Uri.http(_baseURL, '/SetItemFavorites/${itemFavorites.id}');
    } else {
      print('관심상품 최초 등록');
      // http://arong.info:7004/AddItemFavorites
      url = Uri.http(_baseURL, '/AddItemFavorites');
    }
    final body = json.encode(itemFavorites.toJson());
    final response = await client.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
