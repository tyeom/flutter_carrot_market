# Flutter 당근마켓

Flutter 당근마켓 모바일 버전 클론 프로젝트 입니다. <br/>
웹 API부터 모바일 클라이언트까지 심플하게 구현한 프로젝트 입니다. <br/>
이 프로젝트는 Flutter를 중점으로 초급, 초중급 수준의 대상으로 학습 목적으로 제작하였습니다. <br/>
저 역시 모자란 부분이 많아 잘못된 부분이 있다면 같이 함께 학습하면서 고쳐봤으면 좋겠습니다.

이 프로젝트는 다음과 같은 부분을 학습하실 수 있습니다.<br/>
- Dart및 JavaScript 기본문법을 익힐 수 있습니다.<br/>
- Node.js에서 Firebase Realtime Database를 다루는 학습을 할 수 있습니다.
- Flutter의 http(s)통신에 필요한 http모듈, 이미지 슬라이드 뷰어 carousel_slider모듈, 상태관리 provider모듈, 카메라 앨범 이미지 선택 image_picker모듈 사용을 익힐 수 있습니다.
- provider모듈을 사용한 기본적인 상태관리에 대해 익힐 수 있습니다.
- 멀티 이미지 업로드 구현을 익힐 수 있습니다.
- 기본 위젯에 대해 익힐 수 있습니다.

> Flutter 소스는 아래 코드를 참고 하였음을 알려드립니다. <br/>
> https://github.com/sudar-life/flutter_carrot_market

#### Web API Server
- Node.js [express]

#### DataBase
- Firebase Realtime Database

#### Flutter
- Flutter 3.3.9
- Engine : revision 8f2221fbef
- Tools : Dart 2.18.5 / DevTools 2.15.0


🛠️ 개발 환경 정보
-

- IDE : Visual Source Code
- Language : Dart(Flutter) / JavaScript (Node.js)


📕 library to use (Flutter)
-

| Name | Version |
| --- | --- |
| [**cupertino_icons**](https://pub.dev/packages/cupertino_icons) | 1.0.2
| [**flutter_svg**](https://pub.dev/packages/flutter_svg) | 1.1.6 |
| [**intl**](https://pub.dev/packages/intl) | 0.17.0 |
| [**http**](https://pub.dev/packages/http) | 0.13.5 |
| [**carousel_slider**](https://pub.dev/packages/carousel_slider) | 4.1.1 |
| [**provider**](https://pub.dev/packages/provider) | 6.0.4 |
| [**image_picker**](https://pub.dev/packages/image_picker) | 0.8.6 |
| [**dotted_border**](https://pub.dev/packages/dotted_border) | 2.0.0+3 |
| [**fluttertoast**](https://pub.dev/packages/fluttertoast) | 8.1.2 |
| [**cached_network_image**](https://pub.dev/packages/cached_network_image) | 3.2.3 |


📕 library to use (Node.js)
-

| Name | Version |
| --- | --- |
| [**express**](https://www.npmjs.com/package/express) | 4.18.2
| [**body-parser**](https://www.npmjs.com/package/body-parserg) | 1.20.1 |
| [**moment**](https://www.npmjs.com/package/moment) | 2.29.4 |
| [**decode-html**](https://www.npmjs.com/package/decode-html) | 2.0.0 |
| [**firebase-admin**](https://www.npmjs.com/package/firebase-admin) | 11.3.0 |
| [**multer**](https://www.npmjs.com/package/multer) | 1.4.5 |


***

> Carrot Market?
>> This is a used goods trading service app in Korea.

<br/>
Flutter carrot market mobile version clone project.<br/>
This is a simple implementation project from web API to mobile client.<br/>
This project was created for the purpose of learning for beginners and beginners with a focus on Flutter.

Environment
-

- IDE : Visual Source Code
- Language : Dart(Flutter) / JavaScript (Node.js)

***

✅ 구현 기능
-

- [x] 스플래시 화면
- [x] 중고물품 리스트 화면 [콤보박스에서 동네별 필터]
- [x] 중고물품 등록하기
- [x] 등록한 중고물품 삭제하기
- [x] 중고물품 관심상품 등록/제거
- [x] 등록한 관심상품 보기
- [x] 내 판매 물품 리스트 보기

☑️ 앞으로 구현 기능
-

- [ ] 디바이스 번호를 통한 자동 로그인 구현 [현재는 휴대폰 번호 하드코딩으로 로그인]
- [ ] 등록한 중고물품 정보 수정 및 감추기 / 끌어올리기
- [ ] 공유하기 기능
- [ ] Web API JWT사용 사용자 인증구현 [현재는 미인증, Open API상태]
- [ ] Web Socket 및 FCM을 이용한 실시간 채팅 구현


📷 Screenshots
-

#### `중고물품 리스트 화면`
| Mobile App | Windows App |
| --- | --- |
| <img src="https://user-images.githubusercontent.com/13028129/206992683-edb9c45c-aec0-474d-90b9-f9bb15a3005c.png" width="300" height="700"/> | <img src="https://user-images.githubusercontent.com/13028129/207190777-6603c0ff-aacd-498c-a443-5e93b719ea8b.png" width="300" height="700"/>


#### `물품 상세보기 화면`
| Mobile App | Windows App |
| --- | --- |
| <img src="https://user-images.githubusercontent.com/13028129/207193186-66d25b28-33b5-41d4-ad7d-ca41442d67bd.png" width="300" height="700"/> | <img src="https://user-images.githubusercontent.com/13028129/207193543-708b7c7d-05ba-47ff-a22a-430f23f0a441.png" width="300" height="700"/>


#### `마이 당근 화면`
| Mobile App | Windows App |
| --- | --- |
| <img src="https://user-images.githubusercontent.com/13028129/207194917-e7c44ede-50f9-4145-bc9f-4c5b94cdae1a.png" width="300" height="700"/> | <img src="https://user-images.githubusercontent.com/13028129/207195142-61b325d9-5735-4969-968c-f1bf726289df.png" width="300" height="700"/>


#### `관심상품 목록 화면`
| Mobile App | Windows App |
| --- | --- |
| <img src="https://user-images.githubusercontent.com/13028129/207196164-38371149-27b3-4052-acde-113d06749e8a.png" width="300" height="700"/> | <img src="https://user-images.githubusercontent.com/13028129/207196273-cc0b5647-f392-490d-85bc-70b9c9fbbcef.png" width="300" height="700"/>


#### `중고물품 등록 화면`
| Mobile App | Windows App |
| --- | --- |
| <img src="https://user-images.githubusercontent.com/13028129/207196497-17c40548-7f92-4031-af3f-e8fc233c4e74.png" width="300" height="700"/> | 해당 없음<br/>모바일 디바이스 카메라 앨범 기능 의존


#### `판매내역 목록 화면`
| Mobile App | Windows App |
| --- | --- |
| <img src="https://user-images.githubusercontent.com/13028129/207197411-178157ad-2f62-45e4-a476-7f08d3f07e33.png" width="300" height="700"/> | <img src="https://user-images.githubusercontent.com/13028129/207197523-7b38321a-e6b1-4b31-b434-f7984ba4f990.png" width="300" height="700"/>
