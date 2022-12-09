import 'package:app/pages/my_carrot.dart';
import 'package:app/provider/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'home.dart';

class App extends StatefulWidget {
  App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late NavigationProvider _navigationBar;

  Widget _bodyWidget() {
    switch (_navigationBar.currentNavigationIndex) {
      case 0:
        return Home();
        break;
      case 1:
        return Container();
        break;
      case 2:
        return Container();
        break;
      case 3:
        return Container();
        break;
      case 4:
        return MyCarrot();
        break;
    }
    return Container();
  }

  Widget _bottomNavigationBarWidget() {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          print('selectedIdx : ' + index.toString());
          _navigationBar.updatePage(index);
        },
        currentIndex: _navigationBar.currentNavigationIndex,
        selectedItemColor: Colors.black,
        selectedFontSize: 12,
        items: [
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svg/home-outline.svg',
                width: 30,
              ),
              activeIcon: SvgPicture.asset(
                'assets/svg/home.svg',
                width: 30,
              ),
              label: '홈'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svg/text-box-outline.svg',
                width: 30,
              ),
              activeIcon: SvgPicture.asset(
                'assets/svg/text-box.svg',
                width: 30,
              ),
              label: '동네생활'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svg/map-marker-radius-outline.svg',
                width: 30,
              ),
              activeIcon: SvgPicture.asset(
                'assets/svg/map-marker-radius.svg',
                width: 30,
              ),
              label: '내근처'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svg/chat-outline.svg',
                width: 30,
              ),
              activeIcon: SvgPicture.asset(
                'assets/svg/chat.svg',
                width: 30,
              ),
              label: '채팅'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svg/account-outline.svg',
                width: 30,
              ),
              activeIcon: SvgPicture.asset(
                'assets/svg/account.svg',
                width: 30,
              ),
              label: '나의당근')
        ]);
  }

  @override
  Widget build(BuildContext context) {
    _navigationBar = Provider.of<NavigationProvider>(context);

    return Scaffold(
      appBar: null,
      body: _bodyWidget(),
      bottomNavigationBar: _bottomNavigationBarWidget(),
    );
  }
}
