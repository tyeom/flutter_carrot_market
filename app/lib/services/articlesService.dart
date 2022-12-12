import 'dart:convert';

import 'package:app/models/articles.dart';
import 'package:app/models/profile.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ArticlesService {
  static const String _baseURL = 'arong.info:7004';
  //final String _baseURL = '127.0.0.1:7004';

  // 판매 데이터 가져오기 By 동네이름
  Future<List<Articles>> fetchArticles(http.Client client, String? town) async {
    if (town == null) return [];

    // http://arong.info:7004/Articles?town=강남구
    var url = Uri.http(_baseURL, '/Articles', {'town': town});
    final response = await client.get(url);
    if (response.statusCode == 200) {
      return parseArticles(response.body);
    } else if (response.statusCode == 401) {
      // 해당 지역 데이터 없음
      return [];
    } else {
      throw Exception('Unable to fetch articles from the REST API');
    }
  }

  // 판매 데이터 가져오기 By PhoneNum
  Future<List<Articles>> fetchArticlesByProfile(
      http.Client client, Profile profile) async {
    // http://arong.info:7004/ArticlesByPhonenum?phoneNum=01011112222
    var url = Uri.http(
        _baseURL, '/ArticlesByPhonenum', {'phoneNum': profile.phoneNum});
    final response = await client.get(url);
    if (response.statusCode == 200) {
      return parseArticles(response.body);
    } else if (response.statusCode == 401) {
      // 해당 지역 데이터 없음
      return [];
    } else {
      throw Exception('Unable to fetch articlesByProfle from the REST API');
    }
  }

  // 관심상품 목록 데이터 가져오기
  Future<List<Articles>> fetchFavoritesArticles(
      http.Client client, Profile profile) async {
    // http://arong.info:7004/FavoritesArticles?userId={userId}
    var url = Uri.http(_baseURL, '/FavoritesArticles', {'userId': profile.id});
    final response = await client.get(url);
    if (response.statusCode == 200) {
      return parseArticles(response.body);
    } else if (response.statusCode == 401) {
      // 관심상품 데이터 없음
      return [];
    } else {
      throw Exception('Unable to fetch favoritesArticles from the REST API');
    }
  }

  List<Articles> parseArticles(String responseBody) {
    final articlesMap = jsonDecode(responseBody);
    if (articlesMap.containsKey("rows")) {
      final articlesList = articlesMap["rows"]
          .map<Articles>((json) => Articles.fromJson(json))
          .toList();
      return articlesList;
    } else {
      // 데이터 없음.
      return [];
    }
  }

  // 판매 데이터 상세 정보 가져오기
  Future<Articles> fetchDetailArticle(
      http.Client client, String articleId) async {
    // http://arong.info:7004/DetailArticle/{articleKey}
    var url = Uri.http(_baseURL, '/DetailArticle/${articleId}');
    final response = await client.get(url);
    if (response.statusCode == 200) {
      final detailArticleMap = jsonDecode(response.body);
      return Articles.fromJson(detailArticleMap);
    } else {
      throw Exception('Unable to fetch detail articles from the REST API');
    }
  }

  // 판매 데이터 ReadCnt 업데이트 (+1)
  Future<bool> updateArticleReadCnt(
      http.Client client, String articleId) async {
    // http://arong.info:7004/updateArticleReadCnt/{articleKey}
    var url = Uri.http(_baseURL, '/updateArticleReadCnt/${articleId}');
    final response = await client.post(url);
    if (response.statusCode == 200) {
      final resultMap = jsonDecode(response.body);
      if (resultMap.containsKey("message")) {
        return (resultMap["message"] == "ok");
      } else {
        return false;
      }
    } else {
      throw Exception('Unable to update article read cnt from the REST API');
    }
  }

  // 중고거래 상품 등록
  Future<bool> addArticle(http.Client client, List<MultipartFile> uplopadImages,
      Articles article) async {
    print('상품 이미지 업로드 시작');
    // 1. 상품 이미지 업로드
    // http://arong.info:7004/articlesImageUpload
    var url = Uri.http(_baseURL, '/articlesImageUpload');
    http.MultipartRequest request = new http.MultipartRequest('POST', url);
    request.files.addAll(uplopadImages);
    final response = await request.send();
    if (response.statusCode == 200) {
      print('상품 이미지 업로드 완료');
      print('상품 데이터 등록 시작');

      // 2. 상품 데이터 등록
      url = Uri.http(_baseURL, '/addArticle');
      final body = json.encode(article.toJson());
      final addArticleResponse = await client.post(url,
          headers: {"Content-Type": "application/json"}, body: body);

      if (addArticleResponse.statusCode == 200) {
        print('상품 데이터 등록 완료');

        return true;
      } else {
        print('상품 이미지 업로드 성공 -> 상품 데이터 등록 오류');
        return false;
      }
    } else {
      print('상품 이미지 업로드도중 오류가 발생하였습니다.');
      print(response.toString());
      throw Exception(response.toString());
    }
  }
}
