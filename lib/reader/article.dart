class Article {
  int id;
  int novelId;
  String title;
  String content;
  int price;
  int index;
  int nextArticleId;
  int preArticleId;

  List<Map<String, int>> pageOffsets;

  Article.fromJson(Map data,int prevChapter,int nextChapter) {
    id = data['id'];
    novelId = data['bookchapterid'];
    title = data['bookchaptertitle'];
    content = data['bookchaptercontent'];
    content = '\n'+data['bookchaptertitle'] + '\n\n\n' + 'ãã' + content+ '\n\n\n\n';
    content = content.replaceAll('<br><br>', '\nãã');
    price = 2;
    if(data['bookchaptercontent'].compareTo('0')==0){index = 0;} else{index = 1;}

    nextArticleId = nextChapter;

    preArticleId = prevChapter;
  }

  String stringAtPageIndex(int index) {
    var offset = pageOffsets[index];
    return this.content.substring(offset['start'], offset['end']);
  }

  int get pageCount {
    return pageOffsets.length;
  }



}