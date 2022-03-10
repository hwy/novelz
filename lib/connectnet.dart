import 'dart:io';
import 'gbkurldecode.dart';
//import 'package:html/parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_open_chinese_convert/flutter_open_chinese_convert.dart';
//import 'package:fast_gbk/fast_gbk.dart';
/*


UrlEncode urlEncode=new UrlEncode();
/*
class ConnectPage extends StatefulWidget {
  @override
  ConnectNet createState() => new ConnectNet();
} */

class ConnectNet   {
  // String searchbook ="武煉巅峰";
  List<BookResult>  listsearchbookresult;

  // State<ConnectPage>

/*  String _content = "搜查結果";



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title
        ///----------------------使用第三方?Dio的?求-----------------------
            : new Text("武炼巅峰"),
      ),
      body: new Center(
          child: Column(
            children: <Widget>[
              buildRow(getNet, "dio方式-GET" ),
              new Padding(padding: EdgeInsets.all(20.0), child: new Text(_content))
            ],
          )),
    );
  }

  Row buildRow(
      VoidCallback method1, String text1 ,  ) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        new RaisedButton(
          onPressed: method1,
          color: Colors.redAccent,
          child: new Text(text1),
        ),

      ],
    );
  }

  */

  Future<List<BookResult>>getNet(String searchbook) async {

   //  searchbook = await ChineseConverter.convert(searchbook, T2S());

     var seargbk =await ChineseConverter.convert(searchbook, T2S());

     seargbk='武煉巅峰';
      seargbk =urlEncode.encode(searchbook);

     var url ="https://m.biquge.com.cn/search.php?q=$seargbk"; //深圳
   // var url ="http://www.shuquge.com/search.php?searchkey=$searchbook"; //深圳
    Dio dio = new Dio();
    print(url);
  //   Transformer.transformRequest();

     dio.options.connectTimeout = 5 * 1000;
     dio.options.sendTimeout = 5 * 1000;
     dio.options.receiveTimeout = 3 * 1000;
     dio.options.headers = {HttpHeaders.acceptHeader:"application/json;charset=gbk"};
 //    dio.options.contentType= "application/x-www-form-urlencoded";
 //dio.options.headers= httpHeaders;
  //  dio.options.contentType= Headers.formUrlEncodedContentType;

     var response = await dio.get(url, options: Options(responseDecoder: gbkDecoder),);

   //  debugPrint(response.data.toString()+"222222222222222");

      var document = parse(response.data.toString());
   //  var element =parse( document.getElementsByClassName('lists'));
     var element =document.getElementsByClassName('lists')[0];
     var elementchapter =document.getElementsByClassName('readlist')[0];

    var chapterlink=  elementchapter.querySelectorAll('a');
     var chaptertitle=  elementchapter.querySelectorAll('a');
     var parentLinkName = element.querySelectorAll('a');
     var parentNew = element.getElementsByClassName('intro');

     print(chapterlink.toString()+"5555555555555555555555555555555555555");
     //print(chaptertitle);
    var count=0;

     //透過資料產生器，產生資料
      listsearchbookresult = new List<BookResult>.generate(parentLinkName.length, (i) {
       return BookResult(
         bookname: parentLinkName[i].innerHtml,
         booklink: parentLinkName[i].attributes.toString(),
         bookdesc: parentNew[count].text,
         bookupdate: parentNew[count+1].text,
       );
       count=count+2;
        } );
/*
     for (i = 0; i < parentLinkName.length; i++) {

       debugPrint(listsearchbookresult[i].bookname);
       debugPrint(listsearchbookresult[i].booklink);
       debugPrint(listsearchbookresult[i].bookdesc);
       debugPrint(listsearchbookresult[i].bookupdate);

      /* debugPrint(parentLinkName[i].attributes.toString());
       debugPrint(parentNew[count].text);
       debugPrint(parentNew[count+1].text);
       count=count+2;
       debugPrint(count.toString());*/
    //   debugPrint(parentelement[i].querySelector('intro fgreen').text);
      // debugPrint(parentelement[i].querySelector('a') .toString());

       // debugPrint(parentelement[i].getElementsByTagName('a').toString()+i.toString());
     }

    // ConnectNet(this.listsearchbookresult);
*/
    /*
     element.querySelectorAll('p').forEach((value) {

       //value.querySelectorAll('[href*=href_value]');
    debugPrint(value.querySelectorAll('a').text);
    });
    // Map data = json.decode(response.data);
*/
//debugPrint(data.toString());
  //   var document = parse(response);
//    _content = response.data.toString();
//    Map data = json.decode(response);
  //  debugPrint(document.getElementById('bookinfo').firstChild);
 /*   var element = document.getElementById('content');

    print(element.querySelectorAll('div').toString());
    element.querySelectorAll('div').forEach((value) {
      debugPrint(value.outerHtml);
    });
    // Weather weather = Weather.fromJson(json.decode(response.data.toString()));
    //_content = '城市：${weather.skInfo.cityName} \n?度：${weather.skInfo.temp}\n?向：${weather.skInfo.wd}';
    setState(() {});
  }*/

/*
  void postNet_3() async {

    const Utf8Codec utf8 = Utf8Codec();

    var encoded = utf8.encode("完整代?");
    print(gbk.decode(encoded)+"888888888888888888888888888");

    FormData formData = new FormData.fromMap ({
      "searchtype": "novelname",
      "searchkey": "完整代?",
    });

    var dio = new Dio();
    dio.options.headers= httpHeaders;


    var response = await dio.post(url_post, data :formData, options: Options(responseDecoder: gbkDecoder));
    //  _content = response.data;
    debugPrint(response.data);
    setState(() {});
  }

return listsearchbookresult;
}


//  ConnectNet(listsearchbookresult);
//  ConnectNet({this.searchbook});


}




const httpHeaders={
 // 'Accept': 'application/json, text/plain, */*',
  'Authorization': '666',
  'Content-Type': 'application/json;charset=gbk',
  'Origin': 'http://localhost:8080',
  'Referer': 'http://localhost:8080/',
  'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36',
};

  String gbkDecoder (List<int> responseBytes, RequestOptions options, ResponseBody responseBody) {  //gbk to utf8

    String result =  gbk.decode(responseBytes);
    return result;
  }



//產品資料
class BookResult {
  final String bookname;
  final String booklink;
  final String bookdesc;
  final String bookupdate;
  BookResult({this.bookname, this.booklink,this.bookdesc,this.bookupdate});
}*/