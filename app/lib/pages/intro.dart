import 'dart:async';

import 'package:app/components/splash_widget.dart';
import 'package:app/pages/app.dart';
import 'package:flutter/material.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Splash 위젯 표시
          SplashWidget()
        ],
      )),
    );
  }

  Future<Timer> _loadData() async {
    // 약 3초 후 App 페이지로 이동
    return Timer(Duration(seconds: 3), _onDoneLoading);
  }

  _onDoneLoading() async {
    // 기타 필수 기초 데이터 로딩 및 선 처리 작업
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => App()));
  }
}
