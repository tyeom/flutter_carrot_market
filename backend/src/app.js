const moment = require('moment');
const multer = require("multer");
const sharp = require("sharp");
const bodyParser = require('body-parser');

const admin = require('firebase-admin');
const serviceAccount = require("./serviceAccountKey.json");

const firebaseAdmin = admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://carrotmarketclone-c6231-default-rtdb.firebaseio.com"
});

const imageUploadPath = '/home/node/app/imageUpload';
//const imageUploadPath = './imageUpload';

// 업로드 이미지 origin 파일로 바로 저장
const multerStorage = multer.diskStorage({
    destination: function(req, file, cb) {
        cb(null, imageUploadPath);
    },
    filename: function(req, file, cb) {
        cb(null, `articles_${Date.now()}.${file.mimetype.split("/")[1]}`);
    }
});

// 이미지 업로드 필터
const multerFilter = (req, file, cb) => {
    if (file.mimetype.startsWith("image")) {
      cb(null, true);
    }
    else {
      cb("Please upload only articlesImages.", false);
    }
};

// 이미지 업로드 필터 적용 By 파일 스토리지
const upload = multer({
    storage: multerStorage,
    // 업로드 사이즈 제한 : 50MB
    //limits: { fileSize: 50 * 1024 * 1024 },
    fileFilter: multerFilter
});

// Limit 5 image uploads
const uploadFiles = upload.array("articlesImages", 5);

// 업로드 이미지 메모리로 저장
const multerStorageByMemory = multer.memoryStorage();

// 이미지 업로드 필터 적용 By 메모리 스토리지
const uploadByMem = multer({
    storage: multerStorageByMemory,
    // 업로드 사이즈 제한 : 50MB
    //limits: { fileSize: 50 * 1024 * 1024 },
    fileFilter: multerFilter
});

// Limit 5 image uploads
const uploadFilesByMem = uploadByMem.array("articlesImages", 5);

module.exports = function(app) {
    app.use(bodyParser.json());

    // Main
    app.get('/',function(req,res) {
        res.statusCode = 200;
        res.send("Main");
    });

    // 이미지 업로드
    app.post('/articlesImageUpload', function(req, res){
        uploadFiles(req, res, err => {
            if(err instanceof multer.MulterError) {
                if(err.code == "LIMIT_UNEXPECTED_FILE") {
                    res.status(401)
                    .json({error: 'Limit unexpected file'});
                }
                else {
                    res.status(401)
                    .json({error: err.toString()});
                }
            }
            else if (err) {
                res.status(500)
                .json({error: err.toString()});
            }
            else {
                console.log(req.files);
                console.log('이미지 업로드 완료');

                res.status(200)
                .json({images: req.files.map((item) => item.filename)});
            }
        });
    });

    // 이미지 업로드, 이미지 리사이징 처리
    app.post('/articlesImageUploadWithResizing', function(req, res, next){
        uploadFilesByMem(req, res, err => {
            if(err instanceof multer.MulterError) {
                if(err.code == "LIMIT_UNEXPECTED_FILE") {
                    res.status(401)
                    .json({error: 'Limit unexpected file'});
                }
                else {
                    res.status(401)
                    .json({error: err.toString()});
                }
            }
            else if (err) {
                res.status(500)
                .json({error: err.toString()});
            }
            else {
                console.log(req.files);
                console.log('이미지 업로드 완료 - Memory');

                // 이미지 리사이징 처리
                next();
            }
        });
    });

    const resizeImages = async (req, res, next) => {
        if (!req.files) return next();
        
        req.body.articlesImages = [];
        await Promise.all(
            req.files.map(async file => {
                const filename = file.originalname.replace(/\..+$/, "");
                const newFilename = `articles_${filename}_${Date.now()}.jpeg`;
                
                await sharp(file.buffer)
                    .resize(850, 650)
                    .toFormat("jpeg")
                    .jpeg({ quality: 90 })
                    .toFile(`${imageUploadPath}/${newFilename}`);
                
                req.body.articlesImages.push(newFilename);
            })
        );
        
        console.log('이미지 리사이징 완료');
        next();
    };

    const getResult = async (req, res) => {
        if (req.body.articlesImages.length <= 0) {
            return res.send(`You must select at least 1 image.`);
        }

        res.status(200)
        .json({images: req.body.articlesImages.map((item) => item)});
    };

    app.use('/articlesImageUploadWithResizing', resizeImages, getResult);

    // 업로드 이미지 보기
    app.get('/articlesImage/:imageName',function(req,res) {
        const imageName = req.params.imageName;
        const fs = require('fs');

        if (fs.existsSync(`${imageUploadPath}/${imageName}`) == false) {
            res.status(401)
            .json({error: 'not found image'});
            return;
        }

        fs.readFile(`${imageUploadPath}/${imageName}`, function(err, data){
            console.log('image loading');
            if(err) {
                res.status(500)
                .json({error: err.toString()});
            }
            else {
                res.writeHead(200);
                res.write(data);
                res.end();
            }
        });
    });

    // 사용자 추가
    app.post('/addUser',function(req,res) {
        let reqJson = req.body;
        console.log(reqJson);

        let usersRef = firebaseAdmin.database().ref('users');
        usersRef.push(reqJson, function(err) {    
            console.log(err);
        });
        res.statusCode = 200;
        res.send("ok");
    });

    // 판매 정보 추가
    app.post('/addArticle',function(req,res) {
        let reqJson = req.body;
        let articlesRef = firebaseAdmin.database().ref('articles');
        articlesRef.push({uploadTime: moment().unix(), updateTime: moment().unix(), ...reqJson}, function(err) {    
            console.log(err);
        });
        res.statusCode = 200;
        res.send("ok");
    });

    // 판매 정보 삭제
    app.get('/removeArticle/:articleId',function(req,res) {
        const articleId = req.params.articleId;
        let articlesRef = firebaseAdmin.database().ref(`articles/${articleId}`);
        articlesRef.remove(function(err) {    
            if(err) {
                console.log(err);
                res.status(500)
                .json({error: error.toString()});
            }
            else {
                res.statusCode = 200;
                res.send("ok");
            }
        });
    });

    // 사용자 정보 조회 By PhoneNum
    app.get('/user',function(req,res) {
        let rows = [];
        let phoneNum = req.query.phoneNum;
        let ref = firebaseAdmin.database().ref('users');
        ref.orderByChild('phoneNum')
        .equalTo(phoneNum)
        .once('value', (snapshot) => {
            snapshot.forEach((childSnapshot) => {
                rows.push({id: childSnapshot.key,
                    ...childSnapshot.val()});
            });
        })
        .then(() => {
            if(rows.length > 0) {
                res.send({rows: rows});
            }
            else {
                res.status(401)
                .json({error: 'No user found'});
            }

        })
        .catch((error) => {
            console.log(error);
            res.status(500)
            .json({error: error.toString()});
        });
    });

    /*
    app.get('/Articles',function(req,res) {
        let rows = [];
        let town = req.query.town;
        let ref = firebaseAdmin.database().ref('articles');
        ref.orderByChild('town')
        .equalTo(town)
        .get()
        .then((snapshot) => {
            snapshot.forEach((doc) => {
                let childData = doc.val();
                rows.push(childData);
            });

            if(rows.length > 0) {
                res.send({rows: rows});
            }
            else {
                res.status(401)
                .json({error: 'No articles found'});

            }

        })
        .catch((error) => {
            console.log(error);
            res.status(500)
            .json({error: error.toString()});
        });
    });
    */

    // 해당 유저의 관심상품으로 등록된 판매 데이터 조회
    app.get('/FavoritesArticles',function(req,res) {
        const itemFavoritesRows = [];
        const userId = req.query.userId;
        const rows = [];

        // 해당 유저의 itemFavorites 조회
        const itemFavoritesRef = firebaseAdmin.database().ref('itemFavorites');
        itemFavoritesRef.orderByChild('userId')
        .equalTo(userId)
        .once('value', (snapshot) => {
            snapshot.forEach((childSnapshot) => {
                // itemFavorites의 itemId 추출
                const itemIds = childSnapshot.val()['itemId'];
                if(itemIds != null)
                    itemIds.forEach((item) => itemFavoritesRows.push(item));
            });
        })
        .then(() => {
            console.log(`userId : ${userId}회원의 관신 상품 목록 itemIds : ${itemFavoritesRows}`);

            // 위에서 관심목록 itemId를 추출한 기준으로 articles 조회
            const articlesRef = firebaseAdmin.database().ref('articles');
            articlesRef.once('value', (snapshot) => {
                itemFavoritesRows.forEach((articleItemKey) => {
                    snapshot.forEach((childSnapshot) => {
                        if(childSnapshot.key == articleItemKey) {
                            rows.push({id: childSnapshot.key, ...childSnapshot.val()});
                        }
                    });
                });
            })
            .then(() => {
                if(rows.length > 0) {
                    res.send({rows: rows});
                }
                else {
                    res.status(401)
                    .json({error: 'No articles found'});
                }
    
            })
            .catch((error) => {
                console.log('관심상품 목록 조회 -> 판매 상품 데이터 조회 오류');
                console.log(error);
                res.status(500)
                .json({error: error.toString()});
            });
        })
        .catch((error) => {
            console.log('관심 상품 목록 조회 오류');
            console.log(error);
            res.status(500)
            .json({error: error.toString()});
        });
    });

    // 판매 데이터 조회 By 동네이름
    app.get('/Articles',function(req,res) {
        let rows = [];
        let town = req.query.town;
        let ref = firebaseAdmin.database().ref('articles');
        ref.orderByChild('town')
        .equalTo(town)
        .once('value', (snapshot) => {
            snapshot.forEach((childSnapshot) => {
                rows.push({id: childSnapshot.key,
                    ...childSnapshot.val()});
            });
        })
        .then(() => {
            if(rows.length > 0) {
                res.send({rows: rows});
            }
            else {
                res.status(401)
                .json({error: 'No articles found'});
            }

        })
        .catch((error) => {
            console.log(error);
            res.status(500)
            .json({error: error.toString()});
        });
    });

    // 판매 데이터 조회 By 카테고리명
    app.get('/ArticlesByCategory',function(req,res) {
        let rows = [];
        let category = req.query.category;
        let ref = firebaseAdmin.database().ref('articles');
        ref.orderByChild('category')
        .equalTo(category)
        .once('value', (snapshot) => {
            snapshot.forEach((childSnapshot) => {
                rows.push({id: childSnapshot.key,
                    ...childSnapshot.val()});
            });
        })
        .then(() => {
            if(rows.length > 0) {
                res.send({rows: rows});
            }
            else {
                res.status(401)
                .json({error: 'No articles found'});
            }

        })
        .catch((error) => {
            console.log(error);
            res.status(500)
            .json({error: error.toString()});
        });
    });

    // 해당 유저의 판매 데이터 조회
    app.get('/ArticlesByPhonenum',function(req,res) {
        let rows = [];
        let phoneNum = req.query.phoneNum;
        let ref = firebaseAdmin.database().ref('articles');
        ref.orderByChild('profile/phoneNum')
        .equalTo(phoneNum)
        .once('value', (snapshot) => {
            snapshot.forEach((childSnapshot) => {
                rows.push({id: childSnapshot.key,
                    ...childSnapshot.val()});
            });
        })
        .then(() => {
            if(rows.length > 0) {
                res.send({rows: rows});
            }
            else {
                res.status(401)
                .json({error: 'No articles found'});
            }

        })
        .catch((error) => {
            console.log(error);
            res.status(500)
            .json({error: error.toString()});
        });
    });

    // 판매 데이터 상세 조회 By 판매 데이터 Id
    // * 사실상 /Articles, /ArticlesByCategory, /ArticlesByPhonenum 라우터 데이터 조회도 상세 데이터다.
    // * firebase의 Realtime Database는 NoSQL 기반이라 DB 2정규화를 하지 않고 학습목적으로 통으로 데이터를 관리하는 구조로 되어 있다.
    app.get('/DetailArticle/:articleKey',function(req,res) {
        const articleKey = req.params.articleKey;
        const ref = firebaseAdmin.database().ref(`articles/${articleKey}`);
        ref.once('value', (snapshot) => {
            res.send({id: snapshot.key, ...snapshot.val()});
        });
    });

    // 해당 판매 데이터 ReadCnt 업데이트 (+1)
    app.post('/updateArticleReadCnt/:articleKey',function(req,res) {
        const articleKey = req.params.articleKey;
        const ref = firebaseAdmin.database().ref(`articles/${articleKey}`);
        let articleData;
        let updateReadCnt;
        ref.once('value', (snapshot) => {
            articleData = snapshot.val();
            if(articleData == null) {
                updateReadCnt = -1;
            }
            else {
                updateReadCnt = articleData['readCnt'] + 1;
            }
        })
        .then(() => {
            if(updateReadCnt == -1) {
                res.status(401)
                .json({error: 'No articles found'});
                return;
            }
            const updatePostRef = ref.update({'readCnt': Number(updateReadCnt)}, function(err) {
                if(err) {
                    res.status(500)
                    .json({error: error.toString()});
                }
                else {
                    res.status(200)
                    .json({message: 'ok', uid: articleKey});
                }
            });
        })
        .catch((error) => {
            console.log(error);
            res.status(500)
            .json({error: error.toString()});
        });
    });

    // 관심상품으로 최초 등록
    app.post('/AddItemFavorites',function(req,res) {
        let reqJson = req.body;
        let itemFavoritesRef = firebaseAdmin.database().ref('itemFavorites');
        let newPostRef = itemFavoritesRef.push({updateTime: moment().unix(), ...reqJson}, function(err) {
            if(err) {
                res.status(500)
                .json({error: error.toString()});
            }
            else {
                res.status(200)
                .json({message: 'ok', uid: newPostRef.key});
            }
        });
    });

    // 관심상품 데이터 수정 [관심상품 목록 추가/제거]
    app.post('/SetItemFavorites/:favoritesKey',function(req,res) {
        const favoritesKey = req.params.favoritesKey;
        const reqJson = req.body;
        const itemFavoritesRef = firebaseAdmin.database().ref(`itemFavorites/${favoritesKey}`);
        const updatePostRef = itemFavoritesRef.set({updateTime: moment().unix(), ...reqJson}, function(err) {
            if(err) {
                res.status(500)
                .json({error: error.toString()});
            }
            else {
                res.status(200)
                .json({message: 'ok', uid: favoritesKey});
            }
        });
    });

    // 관심상품 데이터 조회 By phoneNum
    app.get('/ItemFavorites',function(req,res) {
        let rows = [];
        let userId = req.query.userId;
        let ref = firebaseAdmin.database().ref('itemFavorites');
        ref.orderByChild('userId')
        .equalTo(userId)
        .once('value', (snapshot) => {
            snapshot.forEach((childSnapshot) => {
                rows.push({id: childSnapshot.key,
                    ...childSnapshot.val()});
            });
        })
        .then(() => {
            res.send({rows: rows});
        })
        .catch((error) => {
            console.log(error);
            res.status(500)
            .json({error: error.toString()});
        });
    });
}