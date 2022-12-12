import 'package:app/models/articles.dart';
import 'package:app/pages/detail.dart';
import 'package:app/provider/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SalesHistory extends StatefulWidget {
  const SalesHistory({super.key});

  @override
  State<SalesHistory> createState() => _SalesHistoryState();
}

class _SalesHistoryState extends State<SalesHistory> {
  late ServiceProvider _serviceProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
    _serviceProvider.dataFetching(isNotify: false);
    // 판매중인 데이터 조회
    _serviceProvider.fetchSalesHistoryArticles();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _serviceProvider.dispose();
    super.dispose();
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
        // Leading 제거 (상단 뒤로가기 버튼)
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          '판매내역',
          style: TextStyle(fontSize: 20),
        ));
  }

  Widget _bodyWidget(List<Articles> articles) {
    if (articles.length > 0) {
      return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 10),
          physics: ClampingScrollPhysics(), // bounce 효과 제거
          itemBuilder: (BuildContext _context, int index) {
            return GestureDetector(
              onTap: () {
                print(articles[index].id);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) =>
                            DetailArticleView(articles: articles[index]))));
              },
              child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Hero(
                        tag: articles[index].id!,
                        child: Image.asset(
                          (articles[index].photoList == null)
                              ? 'assets/images/empry.jpg'
                              : articles[index].photoList![0],
                          width: 100,
                          height: 100,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.only(left: 20, top: 2),
                          height: 100,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  articles[index].title,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.clip,
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Text(
                                  articles[index].town,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black.withOpacity(0.3)),
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Text(
                                  articles[index].price <= 0
                                      ? "무료나눔"
                                      : NumberFormat("###,###,###.###원")
                                          .format(articles[index].price),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Expanded(
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SvgPicture.asset(
                                            'assets/svg/chat-outline.svg',
                                            width: 17,
                                            height: 17),
                                        const SizedBox(
                                          width: 1,
                                        ),
                                        Text(
                                          '77',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        SvgPicture.asset(
                                            'assets/svg/cards-heart-outline.svg',
                                            width: 17,
                                            height: 17),
                                        const SizedBox(
                                          width: 1,
                                        ),
                                        Text(articles[index].likeCnt.toString(),
                                            style: TextStyle(fontSize: 14)),
                                      ]),
                                )
                              ])),
                    )
                  ])),
            );
          },
          separatorBuilder: (BuildContext _context, int index) {
            return Container(
                height: 1, color: Color.fromARGB(150, 163, 155, 155));
          },
          itemCount: articles.length);
    } else {
      return Center(child: Text("판매중인 상품이 없습니다."));
    }
  }

  @override
  Widget build(BuildContext context) {
    print('ItemFavorites build');

    return Scaffold(
      appBar: _appbarWidget(),
      body: Consumer<ServiceProvider>(builder: ((context, value, child) {
        if (value.isDataFetching) {
          return const Center(
              child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 252, 113, 49)));
        } else if (value.articles != null) {
          return _bodyWidget(value.articles!);
        } else {
          return Container();
        }
      })),
    );
  }
}
