import 'package:flutter/material.dart';



import 'package:flutter/services.dart';
import 'dart:ui' as ui show window;

import 'reader/article.dart';


PageController pageController = PageController(keepPage: false);
double topSafeHeight = 0;

// ignore: must_be_immutable
class BookDisplay extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
  //  Article contentf=fetchArticle(1);
   var content;
   return Scaffold(
       body: new Container(
      color: Colors.transparent,
      margin: EdgeInsets.fromLTRB(15, topSafeHeight + ReaderUtils.topOffset, 10, Screen.bottomSafeHeight + ReaderUtils.bottomOffset),
      child: Text.rich(
        TextSpan(children: [TextSpan(text: content, style: TextStyle(fontSize: fixedFontSize(ReaderConfig.instance.fontSize)))]),
        textAlign: TextAlign.justify,
      ),
       ),);
  }
}

fixedFontSize(double fontSize) {
  return fontSize / Screen.textScaleFactor;
}

class ReaderPageAgent {
  static List<Map<String, int>> getPageOffsets(String content, double height, double width, double fontSize) {
    String tempStr = content;
    List<Map<String, int>> pageConfig = [];
    int last = 0;
    while (true) {
      Map<String, int> offset = {};
      offset['start'] = last;
      TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
      textPainter.text = TextSpan(text: tempStr, style: TextStyle(fontSize: fontSize));
      textPainter.layout(maxWidth: width);
      var end = textPainter.getPositionForOffset(Offset(width, height)).offset;

      if (end == 0) {
        break;
      }
      tempStr = tempStr.substring(end, tempStr.length);

      offset['end'] = last + end;
      last = last + end;
      pageConfig.add(offset);
    }
    return pageConfig;
  }
}


Future<Article> fetchArticle(int articleId) async {
  var article;
  article.content="哎！如麟哥儿天赋不凡，早早的就去了升云宗，成了了不得的大人物。”<br“如今宸哥儿还不满十八岁，也已经突破到了武灵之境，竟比麟哥儿还胜出许多。果真是金鳞本非池中物，一遇风云便化龙啊!一个是我李家麒麟，一个是我李家宸宫，真是让我们这些老家伙的心中欢喜不已!”<br><br>　　八长老连连点头道：“有麟哥儿和宸哥儿在，李家何愁不兴啊!”“哈哈哈哈……!”李家家年，看着面容不过四十岁上下。身穿一件藏蓝色的锦袍，颇有几分厚重威严。他见这些长老一个个的越说越多，没完没了的，便开口打断道:“宸哥儿好不容易过来一次，怎能如此怠慢快快安排宴席，且与诸位共饮几杯。”<br><br>“家主说的极是。”<br><br>　　六长老点头，对身后的一个中年男子吩咐道:“快，照家主说的去办。”<br><br>　　“这些日子，族人们都惶惶不安，担惊受怕的。如今宸哥儿带来了佳音，合该安排一次大宴，叫族里面有头有脸的都来参加。”<br><br>　　“且先放下手中的杂事，咱们来个举族同庆!”<br><br>　　“对了，家主，麻烦你弄些新鲜的血肉过来。本座的这两只玄羽飞天雕胃口颇大，记得多准备些，叫人好好给他们喂上，别怠慢了他们。”<br><br>　　李乾宸看着小青和小红，对着李如航说道。<br><br>　　“宸哥儿，你放心，这两只玄羽飞天雕，我一定会找人给你照顾好的。”<br><br>　　李如航满口答应，立马便对着身边一个老者说道:“何管事，快去寻些上好的豚肉来，给这两只玄羽飞天雕好好喂上，记得多拿些来。”<br><br>　　“是！”<br><br>　　何管事连忙领命而去。<br><br>　　李家家主李如航又道：“宸哥儿，玥姐儿，不如先随我等进到大厅里面稍等片刻。等底下的人安排好了，就直接开宴，给你们接风洗尘。”<br><br>　　“多谢家主。”<br><br>　　李乾宸倒也半点不做推辞，只是随意的拱了拱手，当作礼谢。<br><br>　　“家主当真是有心了，本宫在此，谢过家主盛情款待。”<br><br>　　李玥凰娇声软语，仪态万千，嘴上说着‘谢过’，身体却无半点礼谢的动作。<br><br>　　“无妨，无妨，小事一桩而已，这都是我应该做的。”<br><br>　　李家家主李如航在侧前方引路，李乾宸袖袍一摆，当仁不让走在最前头，李玥凰则紫衣翩翩，施施然的紧随其后。<br><br>　　而那十大长老，则只能跟在他们后头。<br><br>　　一群人，便如众星拱月一般，亦步亦趋的跟着李乾宸和李玥凰兄妹二人。<br><br>　　虽说这些长老的辈分都比李乾宸兄妹二人高了许多，但是他们却不是李乾宸兄妹的直系血亲。<br><br>　　李乾宸兄妹俩的修为，又比这些长老高了许多，他们的兄长李真麟更是升云宗的高足。<br><br>　　所以，由李乾宸兄妹走在最前头，于情于理，都再合适不过。<br><br>　　而跟随李乾宸兄妹二人一起过来的李语蓉，则只能跟在了最后头<br><br>　　剩下的那些丫鬟仆从们，根本就没有资格进到议事大厅里面。<br><br>　　至于蝠如海，他则一直隐在暗处。<br><br>　　凭他的修为，李家没有一个人能发现他。<br><br>　　众人刚一进入议事大厅，李乾宸便一马当先，当仁不让的坐在了大厅最上首的位置。<br><br>　　李玥凰则坐在了左侧第一个位置。<br><br>　　李如航只能退居右侧第一个位置。<br><br>　　余下的长老，各按次序，往下排坐。<br><br>　　众人才刚刚坐好，还未说上几句话，便见三个中年管事急匆匆冲进议事大厅，当先一人抱拳躬身，连忙开口道:“启禀家主和诸位长老，出事了!”<br><br>　　“怎么回事？又出什么事了？”<br><br>　　李如航心头不快，眉头一皱，当即问道。<br><br>　　“启禀家主，外面来了一群人，自称是叶家的迎亲队伍。侍卫们还没有通报，他们便强行闯了进来，一个个横冲直撞，马上就要冲进内院了。”<br><br>　　“叶家他们好大的胆子!”<br><br>　　大长老冷声说道。<br><br>　　“带头的是叶家的少家主叶晨和杨家的大长老杨英，还有曹家的二家主曹哲，连同戴家大长老戴明靖。据说，他们都是武动五重天的修为。”<br><br>　　另一个跟过来的管事，也连忙禀报道。<br><br>　　“好哇!好哇!叶家!杨家!曹家!还有戴家!真是好极了!不过就是一个麟哥儿身殒的谣言而已，就让这群牛鬼蛇神全都跳出来了!”<br><br>　　二长老怒目圆睁，显得气愤不已:“以为自己是武动五重天的修为，就能够到我们李家放肆？真是不知天高地厚!”<br><br>　　要是放在昨天，二长老可不敢说这种话。<br><br>　　如今，就不一样了。<br><br>　　现在敢这么说，不过是因为知道了李真麟没有陨落，且李乾宸的修为足以横扫常井镇之后，腰杆子就硬起来了。<br><br>　　“这些人虽然来者不善，但是咱们有宸哥儿坐镇，定要叫他们赔了夫人又折兵!”<br><br>　　十长老倒是没有发怒，反而很是平静，像是一个智者一般，有一种运筹帷幄的感觉。<br><br>　　这时，只听李家家主李如航开口说道:“兵来将挡，水来土掩。不过是一群跳梁小丑而已，诸位长老，且随本家主一起出去看看他们唱的是哪出好戏!”<br><br>　　李如航转头，又对李乾宸询问道:“宸哥儿，你意下如何？”<br><br>　　“家主说的对，那群人，确实只是一群跳梁小丑。”<br><br>　　李乾宸的整个后背都靠在椅子上，显得懒散非常，听到李如航的话，他悠悠然然，很是漫不经心的开口说道:“不过，他们已经来了，咱们就得去会会他们。家主和诸位长老先行一步，本座紧随你等之后，即可。”<br><br>　　“宸哥儿言之有理。”<br><br>　　“合该如此。”<br><br>　　“就依宸哥儿所言。”<br><br>　　…………<br><br>　　“李家当真无人了!我们都来了这么久，李如航和一群李家长老还没出现，难道他们想要当一群缩头乌龟不成”<br><br>　　开口说话，乃是叶家少主叶晨。<br><br>　　他的天赋不凡，今年不过四十一岁而已，就已经有了武动五重的修为。<br><br>　　要知道，普通人族一入武动境界，就有一百二十年到一百八十年的寿命。<br><br>　　按各人所修功法，实力高低不同，各有差别。<br><br>　　而叶晨能在四十多岁就突破到武动五重天，这等天赋，去了外面当然不算什么，但在常井镇上，却是一等一的好资质。<br><br>　　此时的他，满脸都是傲气，一副天大地大我最大的模样。<br><br>　　注：<br><br>　　宸宫，原意是古代帝王所居住的宫殿，后来被用来代指帝王。</di";
  var contentHeight = Screen.height - topSafeHeight - ReaderUtils.topOffset - Screen.bottomSafeHeight - ReaderUtils.bottomOffset - 20;
  var contentWidth = Screen.width - 15 - 10;
  article.pageOffsets = ReaderPageAgent.getPageOffsets(article.content, contentHeight, contentWidth, ReaderConfig.instance.fontSize);
  debugPrint(article.pageOffsets+222222222);
  return article;
}


class ReaderConfig {

  static ReaderConfig _instance;
  static ReaderConfig get instance {
    if (_instance == null) {
      _instance = ReaderConfig();
    }
    return _instance;
  }


  double fontSize = 20.0;
}

class ReaderUtils {
  static double topOffset = 37;
  static double bottomOffset = 37;
}



void setup() async {
  await SystemChrome.setEnabledSystemUIOverlays([]);
  // 不延迟的话，安卓获取到的topSafeHeight是错的。
  await Future.delayed(const Duration(milliseconds: 100), () {});
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  topSafeHeight = Screen.topSafeHeight;



}




class Screen {
  static double get width {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.size.width;
  }

  static double get height {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.size.height;
  }

  static double get scale {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.devicePixelRatio;
  }

  static double get textScaleFactor {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.textScaleFactor;
  }

  static double get navigationBarHeight {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.padding.top + kToolbarHeight;
  }

  static double get topSafeHeight {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.padding.top;
  }

  static double get bottomSafeHeight {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.padding.bottom;
  }

  static updateStatusBarStyle(SystemUiOverlayStyle style) {
    SystemChrome.setSystemUIOverlayStyle(style);
  }
}
