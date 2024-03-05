import 'package:flutter/material.dart';

class TabSong extends StatefulWidget {
  const TabSong({super.key});

  @override
  State<TabSong> createState() => _TabSongState();
}

class _TabSongState extends State<TabSong> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 4,
      child: TabBar(
        isScrollable: true,
        indicatorColor: Colors.green,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        tabs: [
          Tab(
            child: Text(
              'Favourite artist',
              style: TextStyle(
                fontSize: size.height * 0.02,
              ),
            ),
          ),
          Tab(
            child: Text(
              'Most played',
              style: TextStyle(fontSize: size.height * 0.02),
            ),
          ),
          Tab(
            child: Text(
              'Recent Download',
              style: TextStyle(
                fontSize: size.height * 0.02,
              ),
            ),
          ),
          Tab(
            child: Text(
              'Top new songs',
              style:
                  TextStyle(fontSize: size.height * 0.02, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
