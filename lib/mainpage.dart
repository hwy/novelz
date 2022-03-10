import 'package:flutter/material.dart';
import 'scrollview.dart';
import 'reader_scene.dart';
import 'reader/reader_view.dart';

import 'bookdisplay.dart';
import 'bookshell.dart';
import 'bookshow.dart';
import 'rank.dart';
import 'search.dart';


class MainPage extends StatefulWidget {
  @override
  Catalog createState() => Catalog();
}

class Catalog extends State<MainPage>  {

  static final catalogPageKey = new GlobalKey<Catalog>();

  int _selectedTabIndex = 0;
  var apptitle = ['小說','榜單','搜尋','更多'];


  final List<Widget> _children = [
    BookShell(),
    scrollview(),
    SearchPage(),
    Rank(),
  ];
  /* List _pages = [
    Text("Home"),
    Text("Search"),
    Text("Cart"),
    Text("Account"),
  ];
*/
  _changeIndex(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(apptitle[_selectedTabIndex]),
      ),
      body: _children[_selectedTabIndex],
      key: catalogPageKey,

      // body: MainPageView(),
      //   child: _pages[_selectedTabIndex],

      //alignment: FractionalOffset(0.5, 0.9),



      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: _changeIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: apptitle[0]),
          BottomNavigationBarItem(icon: Icon(Icons.equalizer), label: apptitle[1]),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: apptitle[2]),
          BottomNavigationBarItem(icon: Icon(Icons.storage), label: apptitle[3]),
        ],
      ),
    );
  }
}


