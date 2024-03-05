import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:musiclify/Animations/FadeAnimat.dart';
import 'package:musiclify/Animations/FadeImg.dart';
import 'package:musiclify/Animations/ListAnimation.dart';
import 'package:musiclify/helpers/ArtistList.dart';
import 'package:musiclify/helpers/DashCard.dart';
import 'package:musiclify/helpers/SongLis.dart';
import 'package:musiclify/helpers/SongLists.dart';
import 'package:musiclify/helpers/TabsSong.dart';
import 'package:musiclify/provider/GetTrackInfoEventProvider.dart';
import 'package:provider/provider.dart';

class OnlineDashboard extends StatelessWidget {
  const OnlineDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GetTrackInfoEventProvider>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.height * 0.03),
          child: Row(
            children: [
              Lottie.asset('assets/musicify.json',
                  height: size.height * 0.08, width: size.height * 0.08),
              Text(
                'Musiclify',
                style: TextStyle(
                    fontSize: size.height * 0.025, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
        leading: Padding(
          padding: EdgeInsets.only(left: size.height * 0.02),
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
            icon: Icon(Icons.search_outlined),
          ),
        ),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: size.height * 0.025),
              child: SizedBox(
                height: size.height * 0.04,
                width: size.height * 0.055,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Switch(
                    value: provider.isDashboardChange,
                    onChanged: (value) {
                      print('Switch is tapped');
                      provider.GoToOffline();
                    },
                  ),
                ),
              ))
        ],
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  height: size.height * 0.24,
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        child: FadeAnimation(
                          1,
                          Card(
                            color: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(size.height * 0.05),
                            ),
                            child: Container(
                              width: size.width - 20,
                              height: size.height * 0.2,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: size.height * 0.06,
                          left: size.height * 0.05,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FadeAnimation(
                                1.5,
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: size.height * 0.005),
                                  child: Text(
                                    'Most played',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: size.height * 0.02),
                                  ),
                                ),
                              ),
                              FadeAnimation(
                                2,
                                Text(
                                  'Done for\nme',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: size.height * 0.04),
                                ),
                              ),
                              FadeAnimation(
                                1,
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: size.height * 0.005,
                                      left: size.height * 0.003),
                                  child: Text(
                                    'Charlie Puth',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: size.height * 0.02),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Positioned(
                        bottom: 0,
                        right: size.height * 0.03,
                        child: Row(
                          children: [
                            FadeImg(
                              6,
                              Image.asset(
                                'assets/Charlieputh.png',
                                height: size.height * 0.24,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: size.height * 0.02),
              ),
              SliverToBoxAdapter(
                child: const TabSong(),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: size.height * 0.02),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                  child: SizedBox(
                    height: size.height * 0.2,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: items.length,
                      separatorBuilder: (ctx, _) => SizedBox(
                        width: size.width * 0.05,
                      ),
                      itemBuilder: (ctx, index) =>
                          ListAnimate(2, DashCard(cardModel: items[index])),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: size.height * 0.04),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.045,
                    right: size.width * 0.03,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Playlist',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.green,
                          decorationThickness: 1,
                          color: Colors.white,
                          fontSize: size.height * 0.034,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'See more',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.height * 0.014,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: size.height * 0.02),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.038),
                      child: ListAnimate(
                          3, SongList(songListModel: songListsItem[index])),
                    );
                  },
                  childCount: songListsItem.length,
                ),
              ),
            ],
          ),
          Visibility(
            visible:
                provider.isSongStarted && provider.MusicModelList.isNotEmpty,
            child: Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: InkWell(
                onTap: () => Navigator.pushNamed(context, '/player'),
                child: Container(
                  height: size.height * 0.1,

                  decoration: BoxDecoration(
                      color: provider.MusicModelList.isNotEmpty
                          ? provider.MusicModelList[0].songColorm
                          : Colors.greenAccent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          size.height * 0.02,
                        ),
                        topRight: Radius.circular(
                          size.height * 0.02,
                        ),
                      )), // Set your desired height

                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.height * 0.02),
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.005,
                        ),
                        if (provider.MusicModelList.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(size.height * 0.05),
                                child: Image.network(
                                  provider.MusicModelList[0].coverImage ??
                                      songListsItem[0].SongImg,
                                  fit: BoxFit.cover,
                                  height: size.height * 0.065,
                                  width: size.height * 0.065,
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: size.height * 0.005,
                                      left: size.height * 0.015),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          provider.MusicModelList[0].songName ??
                                              songListsItem[0].SongName,
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: size.height * 0.03,
                                              color: Colors.white),
                                        ),
                                      ),
                                      SizedBox(
                                        width: size.height * 0.01,
                                      ),
                                      Flexible(
                                        child: Text(
                                          provider.MusicModelList[0]
                                                  .artistName ??
                                              songListsItem[0].artistName,
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: size.height * 0.03,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  provider.isofflineAudioPlaying();
                                },
                                icon: provider.isofflinePlaying == true
                                    ? Icon(
                                        Icons.pause_circle,
                                        size: size.width * 0.1,
                                      )
                                    : Icon(
                                        Icons.play_circle,
                                        size: size.width * 0.1,
                                      ),
                              ),
                            ],
                          ),
                        // if (provider.audioProgress > Duration.zero)
                        //   Expanded(
                        //     child: ProgressBar(
                        //       thumbGlowColor: Colors.grey,
                        //       progressBarColor: Colors.blueAccent,
                        //       bufferedBarColor: Colors.white,
                        //       thumbColor: Colors.white24,
                        //       baseBarColor: Color.fromARGB(255, 3, 32, 65),
                        //       progress: provider.audioProgress,
                        //       total: provider.MusicModelList[0].duration ??
                        //           Duration(minutes: 0, seconds: 32),
                        //       onSeek: (duration) {
                        //         provider.SeekthePosition(duration);
                        //       },
                        //     ),
                        //   ),
                      ],
                    ),
                  ), // Customize the color
                  // Add your mini player content here...
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
