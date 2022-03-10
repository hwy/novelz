import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:html/parser.dart';

import '../loadingdialog.dart';
import '../sqfhelper.dart';
import 'public.dart';

class ArticleProvider {
  static Future<Article> fetchArticle(int articleId,int bookId) async {
    // var response = await Request.get(action: 'article_$articleId');
    //  var reponse;
    DatabaseHelper databaseHelper= DatabaseHelper.instance;

    var article;

    //  print("ArticleProvider"+articleId.toString());
    List<Map<String, dynamic>> chapterContent = await databaseHelper.queryChapterContent(articleId);


    if (chapterContent[0]['bookchaptercontent'].toString()=='0'){

      String getNetContent  = await getNetBookChapter(chapterContent[0]['bookchapterlink']);

      await databaseHelper.updatechapterContent(articleId,getNetContent);

      chapterContent = await databaseHelper.queryChapterContent(articleId);


    }


      //List<Map<String, dynamic>> chapterContent = await databaseHelper.queryChapterContent(1);

      List<Map<String, dynamic>> prenextchapterID = await databaseHelper.chapterPrevNextId(articleId,bookId);

      int prevChapterId =0;


      if (prenextchapterID.length> 0 && prenextchapterID[0]['PrevName']!=null){

        //print(prenextchapterID.toString()+"prevChapterIdprevChapterIdprevChapterId");

        prevChapterId= prenextchapterID[0]['PrevName'];
      }


      int nextChapterId =0;
      if (prenextchapterID.length>0  && prenextchapterID[0]['NxtName']!=null){
        nextChapterId= prenextchapterID[0]['NxtName'];
      }
      //   print(nextChapterId.toString()+"prenextchapterID[0]['PrevName']]");


      //print('atricle_provider 60 nextChapterId'+nextChapterId.toString()+'prevChapterId '+prevChapterId.toString()+chapterContent[0]['bookchaptertitle'].toString());
      article = Article.fromJson(chapterContent[0],prevChapterId,nextChapterId);


    return article;
  }




}



Future <String> getNetBookChapter(String bookChapterlink) async {
  //  searchbook = await ChineseConverter.convert(searchbook, T2S());
  //var seargbk ='武炼巅峰';

  var url = bookChapterlink;

  Dio dio = new Dio();
  print(url);
  //   Transformer.transformRequest();

  dio.options.connectTimeout = 5 * 1000;
  dio.options.sendTimeout = 5 * 1000;
  dio.options.receiveTimeout = 3 * 1000;
  dio.options.headers = {
    HttpHeaders.acceptHeader: "application/json;charset=gbk"
  };
  //   var response = await dio.get(url, options: Options(responseDecoder: gbkDecoder),);

  var response ;
  try {
    response = await dio.get(url);
  } on DioError catch (e) {
    print("e.toString()");

    print(e.toString());

    return '0';
    /* if (e.type == DioErrorType.connectTimeout) {
      // ...
    }
    if (e.type == DioErrorType.receiveTimeout) {
      // ...
    }*/
  }


  var document = parse(response.data.toString());
  //  var element =parse( document.getElementsByClassName('lists'));

  debugPrint(document.toString()+'article provider documentdocumentdocument');


  //   var element =document.getElementsByClassName('bookinfo')[0].querySelectorAll('p');
  var elementchapter =document.getElementsByClassName('content')[0];


  return elementchapter.innerHtml.replaceAll("&nbsp;", "").replaceAll('<br><br>', '\n　　').replaceAll('<br>', '');



  // return  datadetail;
}