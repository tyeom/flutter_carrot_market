import 'dart:convert';

import 'package:app/models/articles.dart';
import 'package:app/models/profile.dart';
import 'package:http/http.dart' as http;

class ArticlesService {
  final String _baseURL = 'arong.info:7004';

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
}
