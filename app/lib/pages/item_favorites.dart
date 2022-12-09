import 'package:app/models/articles.dart';
import 'package:app/pages/detail.dart';
import 'package:app/provider/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ItemFavoritesView extends StatefulWidget {
  const ItemFavoritesView({super.key});

  @override
  State<ItemFavoritesView> createState() => _ItemFavoritesViewState();
}

class _ItemFavoritesViewState extends State<ItemFavoritesView> {
  late ServiceProvider _serviceProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
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

  Widget _makeDataList(List<Articles> articles) {
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
                        tag: articles[index].id,
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
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.clip,
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Text(
                                  articles[index].town,
                                  style: TextStyle(
                                      fontSize: 12,
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
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Expanded(
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SvgPicture.asset(
                                            'assets/svg/cards-heart-outline.svg',
                                            width: 17,
                                            height: 17),
                                        const SizedBox(
                                          width: 1,
                                        ),
                                        Text(
                                            articles[index].likeCnt.toString()),
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
      return Center(child: Text("해당 지역에 데이터가 없습니다."));
    }
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
        leading: null,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          '관심목록',
          style: TextStyle(fontSize: 13),
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
                        tag: articles[index].id,
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
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.clip,
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Text(
                                  articles[index].town,
                                  style: TextStyle(
                                      fontSize: 12,
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
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Expanded(
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SvgPicture.asset(
                                            'assets/svg/cards-heart-outline.svg',
                                            width: 17,
                                            height: 17),
                                        const SizedBox(
                                          width: 1,
                                        ),
                                        Text(
                                            articles[index].likeCnt.toString()),
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
      return Center(child: Text("해당 지역에 데이터가 없습니다."));
    }
  }

  @override
  Widget build(BuildContext context) {
    print('ItemFavorites build');

    return Scaffold(
      appBar: _appbarWidget(),
      body: Consumer<ServiceProvider>(builder: ((context, value, child) {
        if (value.currentTown == null)
          return Center(child: Text("회원 동네정보가 존재하지 않습니다."));

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
