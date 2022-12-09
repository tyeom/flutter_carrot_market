const moment = require('moment');
const bodyParser = require('body-parser');

const admin = require('firebase-admin');
const serviceAccount = require("./serviceAccountKey.json");

const firebaseAdmin = admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://carrotmarketclone-c6231-default-rtdb.firebaseio.com"
});
  
module.exports = function(app) {
    app.use(bodyParser.json());

    // Main
    app.get('/',function(req,res) {
        res.statusCode = 200;
        res.send("Main");
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