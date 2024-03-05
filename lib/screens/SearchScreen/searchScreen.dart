import 'package:flutter/material.dart';
import 'package:musiclify/Animations/ListAnimation.dart';
import 'package:musiclify/helpers/SongLists.dart';
import 'package:musiclify/provider/GetTrackInfoEventProvider.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final TrackList =
        Provider.of<GetTrackInfoEventProvider>(context).TrackInfolist;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: size.height * 0.0135,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.height * 0.02),
                  child: TextField(
                    controller: SearchTextController,
                    style: TextStyle(
                        color: Colors.white, fontSize: size.height * 0.025),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search here...',
                      focusColor: Colors.green,
                      focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(size.height * 0.015),
                          borderSide: const BorderSide(color: Colors.green)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(size.height * 0.015),
                          borderSide: const BorderSide(color: Colors.white)),
                    ),
                    onSubmitted: (x) {
                      String myQuery = x.toString();
                      Provider.of<GetTrackInfoEventProvider>(context,
                              listen: false)
                          .GetSearchQuery(myQuery);
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.0135,
                ),
                Expanded(
                  child: TrackList.isEmpty
                      ? Center(
                          child: Text(
                            'No tracks found',
                            style: TextStyle(
                                fontSize: size.height * 015,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.04),
                          child: Container(
                            height: size.height * 0.6,
                            child: ListView.separated(
                                scrollDirection: Axis.vertical,
                                itemCount: TrackList.length,
                                separatorBuilder: (ctx, _) => SizedBox(
                                      height: size.height * 0.01,
                                    ),
                                itemBuilder: (ctx, index) => ListAnimate(
                                    2, SongList(trackInfo: TrackList[index]))),
                          ),
                        ),
                )
              ],
            ),
            Provider.of<GetTrackInfoEventProvider>(context).showBuffer
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
