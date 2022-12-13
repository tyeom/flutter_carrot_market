import 'dart:io';

import 'package:app/models/articles.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:app/provider/service_provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http_parser/http_parser.dart';

class AddArticle extends StatefulWidget {
  const AddArticle({super.key});

  @override
  State<AddArticle> createState() => _AddArticleState();
}

class _AddArticleState extends State<AddArticle> {
  late ServiceProvider _serviceProvider;
  late TextEditingController _titleTextEditingController;
  late TextEditingController _priceTextEditingController;
  late TextEditingController _contentTextEditingController;
  String _selectedCategory = '디지털기기';
  final ImagePicker _imagePicker = ImagePicker();
  List<XFile> _pickerImgList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _titleTextEditingController = TextEditingController();
    _priceTextEditingController = TextEditingController();
    _contentTextEditingController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _titleTextEditingController.dispose();
    _priceTextEditingController.dispose();
    _contentTextEditingController.dispose();

    super.dispose();
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black,
          ),
          onPressed: (() => Navigator.pop(context))),
      backgroundColor: Colors.white,
      elevation: 1,
      title: Text(
        '중고거래 글쓰기',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      actions: [
        Container(
            height: 25,
            child: TextButton(
                onPressed: () {
                  _addArticle();
                },
                child: Text(
                  '완료',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xfff08f4f)),
                ))),
      ],
    );
  }

  Widget _line() {
    return Container(
      height: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  }

  // 중고물품 데이터 등록
  _addArticle() async {
    if (_pickerImgList.length <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("중고 물품 사진을 1장 이상 등록해주세요."),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: Duration(
            milliseconds: 2000,
          ),
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 100,
              right: 10,
              left: 10),
        ),
      );

      return;
    }
    if (_pickerImgList.length > 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("사진은 최대 5장 까지 등록 가능합니다."),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: Duration(
            milliseconds: 2000,
          ),
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 100,
              right: 10,
              left: 10),
        ),
      );

      return;
    }

    // 업로드할 중고물품 사진 리스트
    final List<MultipartFile> uploadImages = [];

    // 선택된 카메라 앨범 사진정보 기준으로 MultipartFile 타입 생성
    for (int i = 0; i < _pickerImgList.length; i++) {
      File imageFile = File(_pickerImgList[i].path);
      var stream = _pickerImgList[i].openRead();
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile("articlesImages", stream, length,
          filename: _pickerImgList[i].name,
          contentType: MediaType('image', 'jpg'));
      uploadImages.add(multipartFile);
    }

    // 등록될 중고물품 데이터 정보
    Articles article = Articles(
        photoList: [],
        profile: _serviceProvider.profile!,
        title: _titleTextEditingController.text,
        content: _contentTextEditingController.text,
        town: _serviceProvider.currentTown!,
        price: _priceTextEditingController.text == ''
            ? 0
            : num.parse(_priceTextEditingController.text),
        likeCnt: 7,
        readCnt: 0,
        category: _selectedCategory);

    try {
      // 데이터 등록중 표시
      _serviceProvider.dataFetching();

      // 새로운 중고물품 데이터 등록
      bool result = await _serviceProvider.addArticle(uploadImages, article);
      if (result) {
        Fluttertoast.showToast(
            msg: "새로운 중고물품을 등록하였습니다.",
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.redAccent,
            fontSize: 20,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_SHORT);

        // 데이터 등록 후 AddArticle 닫기
        Navigator.pop<bool>(context, result);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("중고물품 등록도중 오류가 발생하였습니다."),
              duration: Duration(
                milliseconds: 1000,
              )),
        );
      }
    } catch (ex) {
      print("error: $ex");
      Fluttertoast.showToast(
          msg: ex.toString(),
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.redAccent,
          fontSize: 20,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG);
    }
  }

  // 카레라 앨범에서 사진 선택
  Future<void> _pickImg() async {
    final List<XFile>? images = await _imagePicker.pickMultiImage();
    if (images == null) return;

    setState(() {
      _pickerImgList = images;
    });
  }

  // 선택된 사진 미리보기
  Widget _photoPreviewWidget() {
    if (_pickerImgList.length <= 0) return Container();

    return GridView.count(
        shrinkWrap: true,
        padding: EdgeInsets.all(2),
        crossAxisCount: 5, // 최대 5개
        mainAxisSpacing: 1,
        crossAxisSpacing: 5,
        children: List.generate(_pickerImgList.length, (index) {
          //return Container();
          // 대시라인 보더 위젯으로 감싸 선택한 사진을 표시한다.
          return DottedBorder(
              child: Container(
                  child: Container(
                    child: Stack(
                      children: [
                        Image.file(
                          File(_pickerImgList[index].path),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                padding: EdgeInsets.only(left: 20, bottom: 30),
                                onPressed: () {
                                  setState(() {
                                    _pickerImgList.removeAt(index);
                                  });
                                },
                                icon: SvgPicture.asset(
                                  "assets/svg/close-circle.svg",
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(3))),
              dashPattern: [5, 3],
              borderType: BorderType.RRect,
              radius: Radius.circular(3));
        }).toList());
  }

  Widget _bodyWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Stack(
        children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 카메라 앨범에서 사진 선택
                      ElevatedButton(
                        onPressed: () {
                          _pickImg();
                        },
                        child: SvgPicture.asset(
                          "assets/svg/camera.svg",
                        ),
                      ),
                      Flexible(child: _photoPreviewWidget())
                      // Expanded(
                      //   child: GridView.count(
                      //     crossAxisCount: 3,
                      //     mainAxisSpacing: 1,
                      //     crossAxisSpacing: 20,
                      //     children: List.generate(5, (index) {
                      //       return Container(
                      //         color: Colors.yellow,
                      //         child: Text('aasd'),
                      //       );
                      //     }),
                      //   ),
                      // )
                    ],
                  ),
                ),
                // 제목 입력 필드
                TextField(
                  controller: _titleTextEditingController,
                  decoration: InputDecoration(
                      hintText: '제목',
                      contentPadding: EdgeInsets.symmetric(vertical: 10)),
                ),
                SizedBox(
                  height: 15,
                ),
                // 카테고리 선택 드롭다운
                DropdownButton(
                    isExpanded: true,
                    items: [
                      '디지털기기',
                      '생활가전',
                      '가구/인테리어',
                      '유아동',
                      '의류',
                      '식품',
                      '삽니다',
                      '기타'
                    ]
                        .map((item) => DropdownMenuItem(
                              child: Text(item),
                              value: item,
                            ))
                        .toList(),
                    value: _selectedCategory,
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value.toString();
                      });
                    }),
                //가격 입력 필드
                TextField(
                  controller: _priceTextEditingController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: '￦ 가격',
                      contentPadding: EdgeInsets.symmetric(vertical: 10)),
                ),
                SizedBox(
                  height: 15,
                ),
                // 내용 입력 필드
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                      border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  )),
                  constraints: BoxConstraints(maxHeight: 200),
                  child: Scrollbar(
                    child: TextField(
                      controller: _contentTextEditingController,
                      style: TextStyle(fontSize: 17),
                      keyboardType: TextInputType.multiline,
                      maxLength: null,
                      maxLines: null,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.transparent,
                          hintMaxLines: 3,
                          hintText:
                              '해당동에 올릴 게시글 내용을 작성해주세요. (가품 및 판매 금지 물품은 게시가 제한될 수 있어요.)',
                          hintStyle: TextStyle(
                              fontSize: 17, overflow: TextOverflow.clip)),
                    ),
                  ),
                )
              ]),
          Consumer<ServiceProvider>(builder: ((context, value, child) {
            // 중고물품 데이터 등록중인 경우 로딩 위젯 표시
            if (value.isDataFetching) {
              return const Center(
                  child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 252, 113, 49)));
            } else {
              return Container(height: 0, width: 0);
            }
          }))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: _bodyWidget(),
    );
  }
}
