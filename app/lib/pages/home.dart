import 'package:app/models/articles.dart';
import 'package:app/pages/add_article.dart';
import 'package:app/pages/detail.dart';
import 'package:app/provider/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ServiceProvider _serviceProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _serviceProvider = Provider.of<ServiceProvider>(context, listen: false);

    // 계정정보 요청
    _serviceProvider.fetchProfile('01011112222');
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
      elevation: 1,
      title: GestureDetector(
        onTap: () {
          print('Click!');
        },
        child: Consumer<ServiceProvider>(
          builder: (context, value, child) {
            if (value.profile == null) return Container();

            // 회원의 동네 리스트 불러오기
            List<String> townList = value.profile!.town;

            return PopupMenuButton<String>(
                offset: Offset(0, 25),
                shape: ShapeBorder.lerp(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    1),
                itemBuilder: (context) => townList
                    .map((item) => PopupMenuItem<String>(
                          value: item,
                          child: Text(item),
                        ))
                    .toList(),
                child: Row(children: [
                  Text(value.currentTown == null ? "" : value.currentTown!),
                  SvgPicture.asset('assets/svg/chevron-down.svg')
                ]),
                onSelected: (String selectedValue) {
                  value.dataFetching();
                  value.currentTown = selectedValue;
                  value.fetchArticles(selectedValue);
                });
          },
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.search),
        ),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset('assets/svg/menu.svg'),
        ),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset('assets/svg/bell-outline.svg'),
        )
      ],
    );
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
      return Center(child: Text("해당 지역에 데이터가 없습니다."));
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Home build');

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: ((context) => AddArticle())));
        },
        backgroundColor: Color(0xfff08f4f),
        child: const Icon(Icons.add),
      ),
    );
  }
}
