/*
 * 사용 모듈 : npm install express
              npm install body-parser
 *            npm install moment
 *            npm install decode-html
 *            npm install firebase-admin
 *
 */

const express = require('express');
const app = express();
app.use(express.urlencoded({extended: true}));
const router = require('./src/app')(app);

app.set('port', process.env.PORT || 7004);

// Start Express
const server = app.listen(app.get('port'), function(){
    console.clear();
    console.log(`Start express web server : ${app.get('port')}`);
});