import 'package:app/models/profile.dart';
import 'package:app/pages/item_favorites.dart';
import 'package:app/pages/sales_history.dart';
import 'package:app/provider/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class MyCarrot extends StatefulWidget {
  const MyCarrot({super.key});

  @override
  State<MyCarrot> createState() => _MyCarrotState();
}

class _MyCarrotState extends State<MyCarrot> {
  late ServiceProvider _serviceProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
    // 계정정보 요청
    _serviceProvider.fetchProfile('01077778888');
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
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: null,
      actions: [
        IconButton(
          onPressed: () {
            print('설정 click');
          },
          icon: Icon(Icons.settings),
        ),
      ],
    );
  }

  // 프로필 보기 위젯
  Widget _profileWidget(Profile profile) {
    return Container(
      child: Column(children: [
        Row(
          children: [
            SvgPicture.asset("assets/svg/account-circle.svg",
                width: 50, height: 50, color: Color(0xff000000)),
            SizedBox(
              width: 5,
            ),
            Text(
              profile.nickName,
              style: TextStyle(fontSize: 20),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: (() {
                      print('프로필 보기 click');
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color.fromARGB(255, 68, 68, 68),
                      ),
                      child: Text(
                        "프로필 보기",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ]),
    );
  }

  // 당근페이 위젯
  Widget _carrotPayWidget() {
    return Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: Color.fromARGB(255, 68, 68, 68), width: 1)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(children: [
                    Image(
                        image: Image.asset('assets/images/carrot_paypng.jpg')
                            .image),
                    SizedBox(
                      width: 10,
                    ),
                    Text('0원', style: TextStyle(fontSize: 20))
                  ]),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: (() {
                          print('충전 click');
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 60, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color.fromARGB(255, 68, 68, 68),
                          ),
                          child: Text(
                            "+ 충전",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 15),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (() {
                          print('계좌송금 click');
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 60, vertical: 7),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color.fromARGB(255, 68, 68, 68),
                          ),
                          child: Text(
                            "￦ 계좌송금",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ]),
    );
  }

  Widget _line() {
    return Container(
      height: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  }

  // 나의 거래 메뉴 위젯
  Widget _mySaleMenuWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '나의 거래',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/text-box.svg',
                    width: 30,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => SalesHistory())));
                      },
                      child: Container(
                        height: 25,
                        child: Text(
                          '판매 내역',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/basket.svg',
                    width: 30,
                  ),
                  Text(
                    '구매 내역',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/cards-heart.svg',
                    width: 30,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => ItemFavoritesView())));
                      },
                      child: Container(
                        height: 25,
                        child: Text(
                          '관심 목록',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/wallet.svg',
                    width: 30,
                  ),
                  Text(
                    '당근 가계부',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              _line()
            ],
          )
        ],
      ),
    );
  }

  // 나의 동네 생활 메뉴 위젯
  Widget _myTownLifeWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '나의 동네생활',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/text-box.svg',
                    width: 30,
                  ),
                  Text(
                    '동네생활 글/댓글',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              _line(),
              SizedBox(
                height: 20,
              ),
            ],
          )
        ],
      ),
    );
  }

  // 나의 비즈니스 메뉴 위젯
  Widget _myBusinessWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '나의 비즈니스',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/storefront.svg',
                    width: 30,
                  ),
                  Text(
                    '비즈프로필 관리',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/bullhorn.svg',
                    width: 30,
                  ),
                  Text(
                    '광고',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/text-box-multiple.svg',
                    width: 30,
                  ),
                  Text(
                    '동네홍보 글',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              _line()
            ],
          )
        ],
      ),
    );
  }

  Widget _bodyWidget(Profile profile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _profileWidget(profile),
            _carrotPayWidget(),
            _mySaleMenuWidget(),
            _myTownLifeWidget(),
            _myBusinessWidget()
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('MyCarrot build');

    return Scaffold(
        appBar: _appbarWidget(),
        body: Consumer<ServiceProvider>(builder: ((context, value, child) {
          // 프로필 정보 요청중
          if (value.profile == null) {
            return const Center(
                child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 252, 113, 49)));
          }
          // 프로필 정보 요청 완료
          else {
            return _bodyWidget(value.profile!);
          }
        })));
  }
}
