# 플러터 당근마켓

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
- [ ] Web API JWT사용 사용자 인증구현 [현재는 미인증, Open API상태]
- [ ] Web Socket 및 FCM을 이용한 실시간 채팅 구현
- [ ] 등록한 중고물품 정보 수정 및 감추기 / 끌어올리기


📷 Screenshots
-

#### `중고물품 리스트 화면`
![KakaoTalk_20221212_170150961_07](https://user-images.githubusercontent.com/13028129/206992683-edb9c45c-aec0-474d-90b9-f9bb15a3005c.png){: width="100" height="100"}


#### `잠금 화면`
![image](https://user-images.githubusercontent.com/13028129/168453264-f05b781f-b9ce-49da-a4ea-0f9fca887631.png)


#### `메인 환경설정`
![image](https://user-images.githubusercontent.com/13028129/168229251-a6136f83-1388-40b7-bc8b-fbb3b5be3c78.png)


#### `메인 환경설정 > 프로필`
![image](https://user-images.githubusercontent.com/13028129/168229303-30a339a1-49ee-4ef6-8dba-d1d532ad23fb.png)


#### `친구 리스트`
![image](https://user-images.githubusercontent.com/13028129/168229352-954a75b4-0eff-474c-af10-b4c50658307c.png)


#### `친구 검색`
![wpfKakaoTalk_FriendFilter](https://user-images.githubusercontent.com/13028129/169466846-1fc9317e-90a0-44aa-bf2e-88e138ca7015.gif)


#### `친구 검색 및 친구 등록`
![image](https://user-images.githubusercontent.com/13028129/168712827-ad47f974-ba86-46f8-ac76-db5f1bab5621.png)


#### `프로필 보기 및 친구 이름 변경`
![image](https://user-images.githubusercontent.com/13028129/168711985-78ebf7d5-cd69-404d-a5e8-54fa3933665f.png)


#### `채팅방 리스트`
![image](https://user-images.githubusercontent.com/13028129/168229381-1d8329de-3c4d-4b34-8d6d-8bd8a270695c.png)<br/>


#### `채팅1`
![wpfKakaoTalk_Chat](https://user-images.githubusercontent.com/13028129/169466176-c6977249-462d-4057-a35a-16a1e5fe8654.gif)


#### `채팅2`
![image](https://user-images.githubusercontent.com/13028129/169466073-f4e1e605-eaab-4c80-9c8c-6a59e772aa05.png)
