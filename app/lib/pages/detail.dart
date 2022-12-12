import 'package:app/models/articles.dart';
import 'package:app/models/item_favorites.dart';
import 'package:app/provider/service_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../components/manor_temperature_widget.dart';

class DetailArticleView extends StatefulWidget {
  final Articles articles;

  const DetailArticleView({required this.articles, super.key});

  @override
  State<DetailArticleView> createState() => _DetailArticleViewState();
}

class _DetailArticleViewState extends State<DetailArticleView>
    with TickerProviderStateMixin {
  late ServiceProvider _serviceProvider;
  late Size _size;
  late int _current;
  ScrollController _scrollController = ScrollController();
  double _locationAlpha = 0;
  late AnimationController _animationController;
  late Animation _colorTween;
  bool _isMyFavoriteContent = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _serviceProvider = Provider.of<ServiceProvider>(context, listen: false);

    if (_serviceProvider.itemFavorites != null) {
      _isMyFavoriteContent = _serviceProvider.itemFavorites!.itemId
          .any((p) => p == widget.articles.id);
    }

    // 판매 데이터 상세 조회
    _serviceProvider.fetchDetailArticle(widget.articles.id!);

    // 해당 판매자 게시글 조회
    _serviceProvider.fetchArticlesByProfile(widget.articles.profile);

    _size = MediaQuery.of(context).size;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _animationController = AnimationController(vsync: this);
    _colorTween = ColorTween(begin: Colors.white, end: Colors.black)
        .animate(_animationController);
    _current = 0;
    _scrollController.addListener(() {
      setState(() {
        if (_scrollController.offset > 255) {
          _locationAlpha = 255;
        } else {
          _locationAlpha = _scrollController.offset;
        }

        _animationController.value = _locationAlpha / 255;
      });
    });
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: _colorTween.value,
          ),
          onPressed: (() => Navigator.pop(context))),
      backgroundColor: Colors.white.withAlpha(_locationAlpha.toInt()),
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.share, color: _colorTween.value),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.more_vert,
            color: _colorTween.value,
          ),
        ),
      ],
    );
  }

  Widget _makeSliderImage() {
    return Container(
      height: _size.width * 0.8,
      child: Stack(
        children: [
          Hero(
            tag: widget.articles.id!,
            child: CarouselSlider(
              options: CarouselOptions(
                  height: _size.width * 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
              items: widget.articles.photoList!
                  .map((item) => Container(
                        width: _size.width,
                        height: _size.width,
                        color: Colors.red,
                        child: Image.asset(
                          item,
                          fit: BoxFit.cover,
                        ),
                      ))
                  .toList(),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  List.generate(widget.articles.photoList!.length, (index) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _profileInfo() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: widget.articles.profile.photo == null
                ? Image.asset("assets/images/user.png").image
                : Image.asset(widget.articles.profile.photo!).image,
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.articles.profile.nickName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                widget.articles.town,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          Expanded(
            child: ManorTemperature(
                manorTemp: widget.articles.profile.temperature),
          )
        ],
      ),
    );
  }

  Widget _line() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      color: Colors.grey.withOpacity(0.3),
    );
  }

  String _calcUploadTime(int uploadTime) {
    DateTime uploadDateTime =
        DateTime.fromMillisecondsSinceEpoch(uploadTime * 1000);
    int minutesDifference = DateTime.now().difference(uploadDateTime).inMinutes;
    int hoursDifference = DateTime.now().difference(uploadDateTime).inHours;

    if (hoursDifference <= 0) {
      return "${minutesDifference}분 전";
    } else if (hoursDifference > 0 && hoursDifference < 24) {
      return "${hoursDifference}시간 전";
    } else {
      return "올린날짜 ${DateFormat('yyyy/MM/dd').format(uploadDateTime).toString()}";
    }
  }

  Widget _contentDetail(Articles detailArticle) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          Text(
            detailArticle.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Text(detailArticle.category,
                  style: TextStyle(
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      color: Colors.grey)),
              SizedBox(width: 2),
              Text('·',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 151, 145, 145),
                  )),
              SizedBox(width: 2),
              Text(_calcUploadTime(detailArticle.updateTime!),
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 151, 145, 145),
                  )),
            ],
          ),
          SizedBox(height: 15),
          Text(
            detailArticle.content!,
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          SizedBox(height: 15),
          Text(
            "채팅 7 ∙ 관심 ${detailArticle.likeCnt} ∙ 조회 ${detailArticle.readCnt}",
            style: TextStyle(
              fontSize: 12,
              color: Color.fromARGB(255, 151, 145, 145),
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _otherCellContents() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "이 게시글 신고하기",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                  onPressed: () {
                    //
                  },
                  icon: Icon(
                    Icons.chevron_right_sharp,
                    color: Colors.black,
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${widget.articles.profile.nickName}님의 판매 상품",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                  onPressed: () {
                    //
                  },
                  icon: Icon(
                    Icons.chevron_right_sharp,
                    color: Colors.black,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sellerArticlesWidget(List<Articles>? sellerArticles) {
    // 데이터 로딩중이라면 임시 데이터로 표시한다.
    if (sellerArticles == null) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
          delegate: SliverChildListDelegate(List.generate(5, (index) {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        color:
                            Color.fromARGB(255, 170, 170, 170).withOpacity(0.3),
                        height: 120,
                      )),
                  Text(
                    '~~~~~~~~',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    '0 원',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            );
          }).toList()),
        ),
      );
    } else {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 0, crossAxisSpacing: 10),
          delegate: SliverChildListDelegate(
              List.generate(sellerArticles.length, (index) {
            return GestureDetector(
              onTap: () {
                print(
                    '판매자의 다른 상품보기 - Article id : ${sellerArticles[index].id}');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => DetailArticleView(
                            articles: sellerArticles[index]))));
              },
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        sellerArticles[index].photoList![0],
                        height: 130,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      sellerArticles[index].title,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 5),
                    Text(
                      sellerArticles[index].price <= 0
                          ? "무료나눔"
                          : NumberFormat("###,###,###.###원")
                              .format(sellerArticles[index].price),
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            );
          }).toList()),
        ),
      );
    }
  }

  Widget _bodyWidget(Articles detailArticle, List<Articles>? sellerArticles) {
    return CustomScrollView(controller: _scrollController, slivers: [
      SliverList(
        delegate: SliverChildListDelegate(
          [
            _makeSliderImage(),
            _profileInfo(),
            _line(),
            _contentDetail(detailArticle),
            _otherCellContents()
          ],
        ),
      ),

      // 해당 판매자 게시글
      _sellerArticlesWidget(sellerArticles),
    ]);
  }

  _itemFavorites(bool isMyFavoriteContent) {
    // 등록된 관심상품이 없음, 최초 등록
    if (isMyFavoriteContent && _serviceProvider.itemFavorites == null) {
      _serviceProvider.updateItemFavorites(ItemFavorites(
          '', _serviceProvider.profile!.id, [widget.articles.id!]));
      _serviceProvider.fetchItemFavorites();
    }
    // 관심상품에 추가
    else if (isMyFavoriteContent && _serviceProvider.itemFavorites != null) {
      // 관심상품 추가
      _serviceProvider.itemFavorites!.itemId.add(widget.articles.id!);
      _serviceProvider.updateItemFavorites(_serviceProvider.itemFavorites!);
    }
    // 관심상품에 제거
    else if (isMyFavoriteContent == false &&
        _serviceProvider.itemFavorites != null) {
      // 관심상품 제거
      _serviceProvider.itemFavorites!.itemId.remove(widget.articles.id);
      _serviceProvider.updateItemFavorites(_serviceProvider.itemFavorites!);
    }
  }

  Widget _bottomBarWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 55,
      color: Colors.white,
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              _itemFavorites(!_isMyFavoriteContent);

              setState(() {
                _isMyFavoriteContent = !_isMyFavoriteContent;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(_isMyFavoriteContent
                        ? "관심목록에 추가됐어요."
                        : "관심목록에서 제거됐어요."),
                    duration: Duration(
                      milliseconds: 1000,
                    )),
              );
            },
            child: SvgPicture.asset(
              _isMyFavoriteContent
                  ? "assets/svg/heart_on.svg"
                  : "assets/svg/heart_off.svg",
              width: 20,
              height: 20,
              color: Color(0xfff08f4f),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 15, right: 10),
            height: 40,
            width: 1,
            color: Colors.grey.withOpacity(0.3),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.articles.price <= 0
                    ? "무료나눔"
                    : NumberFormat("###,###,###.###원")
                        .format(widget.articles.price),
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              Text(
                "가격제안불가",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              )
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xfff08f4f),
                  ),
                  child: Text(
                    "채팅으로 거래하기",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _appbarWidget(),
      body: Consumer<ServiceProvider>(builder: (context, value, child) {
        if (value.detailArticle == null) {
          return const Center(
              child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 252, 113, 49)));
        } else {
          return _bodyWidget(value.detailArticle!, value.sellerArticles);
        }
      }),
      bottomNavigationBar: _bottomBarWidget(),
    );
  }
}
